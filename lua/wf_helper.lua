local wf_helper = {}

function wf_helper.wml_error(message)
    return wml.error(message)
end

function wf_helper.child_range(cfg, tag)
    return wml.child_range(cfg, tag)
end

function wf_helper.rand(possible_values)
    return mathx.random_choice(possible_values)
end

function wf_helper.get_variable_array(name)
    return wml.array_access.get(name)
end

function wf_helper.set_variable_array(name, value)
    return wml.array_access.set(name, value)
end

function wf_helper.adjacent_tiles(x, y, with_borders)
    local adj = { wesnoth.map.get_adjacent_hexes(x, y) }
    local i = 0
    return function()
        while i < #adj do
            i = i + 1
            local u, v = adj[i].x, adj[i].y
            if wesnoth.current.map:on_board(u, v, with_borders) then
                return u, v
            end
        end
        return nil
    end
end

return wf_helper
