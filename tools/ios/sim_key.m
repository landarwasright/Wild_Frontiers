#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <objc/message.h>

typedef struct IndigoHIDMessageStruct IndigoHIDMessageStruct;
typedef IndigoHIDMessageStruct *(*IndigoKeyboardMessageFn)(NSEvent *event);

static void fail(NSString *message) {
    fprintf(stderr, "%s\n", message.UTF8String);
    exit(1);
}

static BOOL parse_key(NSString *name, unsigned short *keyCode, NSString **characters) {
    if ([name isEqualToString:@"return"]) {
        *keyCode = 36;
        *characters = @"\r";
        return YES;
    }
    if ([name isEqualToString:@"tab"]) {
        *keyCode = 48;
        *characters = @"\t";
        return YES;
    }
    if ([name isEqualToString:@"space"]) {
        *keyCode = 49;
        *characters = @" ";
        return YES;
    }
    if ([name isEqualToString:@"j"]) {
        *keyCode = 38;
        *characters = @"j";
        return YES;
    }

    unichar arrow = 0;
    if ([name isEqualToString:@"left"]) {
        *keyCode = 123;
        arrow = NSLeftArrowFunctionKey;
    } else if ([name isEqualToString:@"right"]) {
        *keyCode = 124;
        arrow = NSRightArrowFunctionKey;
    } else if ([name isEqualToString:@"down"]) {
        *keyCode = 125;
        arrow = NSDownArrowFunctionKey;
    } else if ([name isEqualToString:@"up"]) {
        *keyCode = 126;
        arrow = NSUpArrowFunctionKey;
    }

    if (arrow != 0) {
        *characters = [NSString stringWithCharacters:&arrow length:1];
        return YES;
    }

    return NO;
}

static NSEventModifierFlags parse_modifiers(NSString *input) {
    if (input.length == 0) {
        return 0;
    }

    NSEventModifierFlags flags = 0;
    NSArray<NSString *> *parts = [input componentsSeparatedByString:@","];
    for (NSString *part in parts) {
        NSString *modifier = [[part stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] lowercaseString];
        if (modifier.length == 0) {
            continue;
        } else if ([modifier isEqualToString:@"command"] || [modifier isEqualToString:@"cmd"]) {
            flags |= NSEventModifierFlagCommand;
        } else if ([modifier isEqualToString:@"option"] || [modifier isEqualToString:@"alt"]) {
            flags |= NSEventModifierFlagOption;
        } else if ([modifier isEqualToString:@"control"] || [modifier isEqualToString:@"ctrl"]) {
            flags |= NSEventModifierFlagControl;
        } else if ([modifier isEqualToString:@"shift"]) {
            flags |= NSEventModifierFlagShift;
        } else {
            fail([NSString stringWithFormat:@"unknown modifier: %@", modifier]);
        }
    }

    return flags;
}

static id load_device(NSString *developerDir, NSString *udidString) {
    Class serviceContextClass = NSClassFromString(@"SimServiceContext");
    if (!serviceContextClass) {
        fail(@"failed to load SimServiceContext");
    }

    NSError *error = nil;
    SEL sharedContextSel = NSSelectorFromString(@"sharedServiceContextForDeveloperDir:error:");
    id (*sharedContext)(id, SEL, id, NSError **) = (void *)objc_msgSend;
    id serviceContext = sharedContext(serviceContextClass, sharedContextSel, developerDir, &error);
    if (!serviceContext || error) {
        fail([NSString stringWithFormat:@"failed to get SimServiceContext: %@", error]);
    }

    SEL defaultDeviceSetSel = NSSelectorFromString(@"defaultDeviceSetWithError:");
    id (*defaultDeviceSet)(id, SEL, NSError **) = (void *)objc_msgSend;
    id deviceSet = defaultDeviceSet(serviceContext, defaultDeviceSetSel, &error);
    if (!deviceSet || error) {
        fail([NSString stringWithFormat:@"failed to get default device set: %@", error]);
    }

    SEL devicesByUDIDSel = NSSelectorFromString(@"devicesByUDID");
    id (*devicesByUDID)(id, SEL) = (void *)objc_msgSend;
    NSDictionary *devices = devicesByUDID(deviceSet, devicesByUDIDSel);

    NSUUID *udid = [[NSUUID alloc] initWithUUIDString:udidString];
    id device = devices[udid];
    if (!device) {
        fail([NSString stringWithFormat:@"failed to find device %@", udidString]);
    }

    return device;
}

static id load_hid_client(id device) {
    Class hidClientClass = NSClassFromString(@"SimulatorKit.SimDeviceLegacyHIDClient");
    if (!hidClientClass) {
        hidClientClass = NSClassFromString(@"_TtC12SimulatorKit24SimDeviceLegacyHIDClient");
    }
    if (!hidClientClass) {
        fail(@"failed to load SimDeviceLegacyHIDClient");
    }

    NSError *error = nil;
    id (*allocObject)(id, SEL) = (void *)objc_msgSend;
    id hidClientAlloc = allocObject(hidClientClass, @selector(alloc));
    SEL initWithDeviceSel = NSSelectorFromString(@"initWithDevice:error:");
    id (*initWithDevice)(id, SEL, id, NSError **) = (void *)objc_msgSend;
    id hidClient = initWithDevice(hidClientAlloc, initWithDeviceSel, device, &error);
    if (!hidClient || error) {
        fail([NSString stringWithFormat:@"failed to create HID client: %@", error]);
    }

    return hidClient;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc < 3) {
            fail(@"usage: sim_key <udid> <key> [count] [modifiers]");
        }

        NSString *udidString = [NSString stringWithUTF8String:argv[1]];
        NSString *keyName = [[NSString stringWithUTF8String:argv[2]] lowercaseString];
        NSInteger count = argc >= 4 ? strtol(argv[3], NULL, 10) : 1;
        NSString *modifiersInput = argc >= 5 ? [NSString stringWithUTF8String:argv[4]] : @"";
        if (count < 1) {
            fail(@"count must be >= 1");
        }

        unsigned short keyCode = 0;
        NSString *characters = nil;
        if (!parse_key(keyName, &keyCode, &characters)) {
            fail([NSString stringWithFormat:@"unknown key: %@", keyName]);
        }
        NSEventModifierFlags modifiers = parse_modifiers(modifiersInput);

        NSString *coreSimulatorPath = @"/Library/Developer/PrivateFrameworks/CoreSimulator.framework/CoreSimulator";
        NSString *simulatorKitPath = @"/Applications/Xcode.app/Contents/Developer/Library/PrivateFrameworks/SimulatorKit.framework/SimulatorKit";
        NSString *developerDir = @"/Applications/Xcode.app/Contents/Developer";

        if (!dlopen(coreSimulatorPath.fileSystemRepresentation, RTLD_NOW | RTLD_GLOBAL)) {
            fail([NSString stringWithFormat:@"failed to load %@", coreSimulatorPath]);
        }
        if (!dlopen(simulatorKitPath.fileSystemRepresentation, RTLD_NOW | RTLD_GLOBAL)) {
            fail([NSString stringWithFormat:@"failed to load %@", simulatorKitPath]);
        }

        IndigoKeyboardMessageFn messageForKeyboardEvent =
            (IndigoKeyboardMessageFn)dlsym(RTLD_DEFAULT, "IndigoHIDMessageForKeyboardNSEvent");
        if (!messageForKeyboardEvent) {
            fail(@"failed to resolve IndigoHIDMessageForKeyboardNSEvent");
        }

        id device = load_device(developerDir, udidString);
        id hidClient = load_hid_client(device);

        SEL sendSel = NSSelectorFromString(@"sendWithMessage:freeWhenDone:completionQueue:completion:");
        void (*sendMessage)(id, SEL, IndigoHIDMessageStruct *, BOOL, dispatch_queue_t, id) = (void *)objc_msgSend;

        for (NSInteger i = 0; i < count; i++) {
            NSTimeInterval now = NSProcessInfo.processInfo.systemUptime;
            NSEvent *downEvent = [NSEvent keyEventWithType:NSEventTypeKeyDown
                                                  location:NSZeroPoint
                                             modifierFlags:modifiers
                                                 timestamp:now
                                              windowNumber:0
                                                   context:nil
                                                characters:characters
                               charactersIgnoringModifiers:characters
                                                 isARepeat:NO
                                                   keyCode:keyCode];
            IndigoHIDMessageStruct *downMessage = messageForKeyboardEvent(downEvent);
            sendMessage(hidClient, sendSel, downMessage, YES, nil, nil);

            NSEvent *upEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp
                                                location:NSZeroPoint
                                           modifierFlags:modifiers
                                               timestamp:now
                                            windowNumber:0
                                                 context:nil
                                              characters:characters
                             charactersIgnoringModifiers:characters
                                               isARepeat:NO
                                                 keyCode:keyCode];
            IndigoHIDMessageStruct *upMessage = messageForKeyboardEvent(upEvent);
            sendMessage(hidClient, sendSel, upMessage, YES, nil, nil);
            usleep(150000);
        }
    }

    return 0;
}
