-- n dimensional table, lets you do stuff like nTable[x][y][z] = whatever
-- without getting an error that nTable[x][y] is nil

local nTable = {}

function nTable.new()
    return setmetatable({},{
        __index = function(tbl,key)
            return rawget(rawset(tbl,key,setmetatable({},{__index = index})),key)
        end)
    })
end

return nTable