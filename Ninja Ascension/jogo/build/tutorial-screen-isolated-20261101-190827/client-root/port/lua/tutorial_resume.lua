-- Restore the lesson, rebuilding its original UI rather than jumping into a
-- widget whose parent windows do not exist after restarting the application.
local M={}
function M.restore()
    local user=_ED and _ED.user_info
    local records=user and user.new_user_teach_record
    local entry=type(records)=='table' and records.nr_local_resume
    M.checkpoint=nil
    if entry then
        local account,group,progress=tostring(entry[2]):match('^(%d+),(%d+),(%d+)$')
        if account==tostring(user.user_id) then
            M.checkpoint={group=tonumber(group),progress=tonumber(progress)}
            print('HOST_TUTORIAL_RESUME saved lesson='..group..' checkpoint='..progress)
        end
    end
end
function M.install()
    if M.installed or not dms or type(dms.searchs)~='function' then return end
    M.installed=true
    local search=dms.searchs
    dms.searchs=function(source,column,value,...)
        local result=search(source,column,value,...)
        local saved=M.checkpoint
        if saved and source==dms.mission3 and column==mission_off then
            local candidate=search(source,mission_id,saved.group)
            local valid=false
            for _,row in ipairs(candidate or {}) do
                if tonumber(row[mission_progress])==saved.progress then valid=true;break end
            end
            -- Never rewind a naturally unlocked newer lesson. Existing start
            -- conditions inspect restored inventory/quality/clears as usual.
            local natural=result and result[1] and tonumber(result[1][mission_id])
            -- A missing natural match means no lesson at this level/trigger.
            -- Forcing the last checkpoint here replayed old stage tutorials.
            if valid and natural==saved.group then return candidate end
        end
        return result
    end
end
return M
