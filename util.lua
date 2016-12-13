util = {}

util.sign = function(x)
    return x >= 0 and 1 or x < 0 and -1
end

util.degtorad = function(deg)
    return deg * (math.pi/180)
end

util.concat = function(table1, table2)
    local concat = {}

    for i = 1, #table1, 1 do
        concat[i] = table1[i]
    end

    for i = 1, #table2, 1 do
        concat[#table1+i] = table2[i]
    end

    return concat
end

return util