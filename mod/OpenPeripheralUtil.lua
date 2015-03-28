local op = {}

function op.find(type)
    local found = {}
    for i,v in ipairs(peripheral.getNames()) do
        local p = peripheral.wrap(v)
        if p.listSources and p.listSources()[type] then
            table.insert(found, p)
        end
    end
    return unpack(found)
end

return op