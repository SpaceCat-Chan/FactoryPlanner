-- Logging function with custom excludes
function llog(table)
    local excludes = {parent=true, type=true, category=true, subfloor=true, origin_line=true, tooltip=true}

    if type(table) ~= "table" then log(table); return end

    local tab_width, super_space = 2, ""
    for i=0, tab_width-1, 1 do super_space = super_space .. " " end

    local function format(table, depth)
        if table_size(table) == 0 then return "{}" end

        local spacing = ""
        for i=0, depth-1, 1 do spacing = spacing .. " " end
        local super_spacing = spacing .. super_space

        local out = "{"
        local first_element = true

        for name, value in pairs(table) do
            local element = tostring(value)
            if type(value) == "string" then
                element = "'" .. element .. "'"
            elseif type(value) == "table" then
                if excludes[name] ~= nil then
                    element = value.name or "EXCLUDE"
                else
                    element = format(value, depth+tab_width)
                end
            end

            local comma = (first_element) and "" or ","
            first_element = false

            local key = (type(name) == "number") and "" or (name .. " = ")

            out = out .. comma .. "\n" .. super_spacing .. key .. element
        end

        return (out .. "\n" .. spacing .. "}")
    end

    log("\nlog = " .. format(table, 0))
end