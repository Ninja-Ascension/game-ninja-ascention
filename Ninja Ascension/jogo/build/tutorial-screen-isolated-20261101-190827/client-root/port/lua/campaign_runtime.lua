-- Optional online activity notifications must not interrupt local level-up.
local M={}
function M.install()
    local constellation=rawget(_G,'constellationRedotData')
    if type(constellation)=='function' and constellation~=M.constellationWrapper then
        M.constellationWrapper=function(...)
            if not _ED.constellation_info then return end
            return constellation(...)
        end
        constellationRedotData=M.constellationWrapper
    end
    local original=rawget(_G,'getEveryDaySignCenterAllTips')
    if type(original)=='function' and original~=M.signWrapper then
        M.signWrapper=function(...)
            if not _ED.active_activity or not _ED.active_activity[38] then return false end
            return original(...)
        end
        getEveryDaySignCenterAllTips=M.signWrapper
    end
end
return M
