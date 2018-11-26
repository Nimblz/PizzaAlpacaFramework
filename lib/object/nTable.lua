-- n dimensional table, it's slow, use with care.

local nTable = {}

local function indexFunc(tbl,key)
    return rawget(rawset(tbl,key,setmetatable({},{__index = indexFunc})),key)
end

function nTable.new()
    return setmetatable({},{
        __index = indexFunc
    })
end

return nTable