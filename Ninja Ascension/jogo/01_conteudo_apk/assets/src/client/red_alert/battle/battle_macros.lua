-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗宏定义
-- ----------------------------------------------------------------------------------------------------
-- 角度转换
function CC_DEGREES_TO_RADIANS(__ANGLE__)
    return ((__ANGLE__) * 0.01745329252)
end

function CC_RADIANS_TO_DEGREES(__ANGLE__)
    return  ((__ANGLE__) * 57.29577951)
end

function CC_POSITIONS_TO_DEGREES(src, dest)
    local o = dest.x - src.x
    local a = dest.y - src.y
    if a >= -0.001 and a <= 0.001 then
        a = 0.001
    end
    local at = CC_RADIANS_TO_DEGREES(math.atan(o/a)) 
    if a < 0 then
        if o < 0 then
            at = 180 + math.abs(at)
        else
            at = 180 - math.abs(at)
        end
    end
    return  at
end
-- ----------------------------------------------------------------------------------------------------