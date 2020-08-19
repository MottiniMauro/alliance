local M = {}

local meta1
local L = 0
local R = 0

M.set_params = function (l, r)
    L = l
    R = r
end

M.v2_to_angular = function (vl, vr)
    v = (R/2) * (vr + vl)
    w = (R/L) * (vr - vl)
    return v, w
end


M.angular_to_v2 = function (v, w)
    vl = (2 * v - w * L) / (2 * R)
    vr = (2 * v + w * L) / (2 * R)
    return vl, vr
end

return M