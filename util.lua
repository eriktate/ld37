util = {}

util.sign = function(x)
    return x >= 0 and 1 or x < 0 and -1
end

return util