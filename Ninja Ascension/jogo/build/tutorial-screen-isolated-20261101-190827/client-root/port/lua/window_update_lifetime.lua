local M={}
local function protect(window)
    if not window or window.__nr_update_lifetime or type(window.onUpdate)~='function' then return end
    window.__nr_update_lifetime=true
    local update=window.onUpdate
    window.onUpdate=function(self,...)
        cc.nrKeepAliveFrame(self)
        return update(self,...)
    end
end
function M.install()
    if type(cc.nrKeepAliveFrame)~='function' then return end
    for _,entry in ipairs({{rawget(_G,'fwin'),'registerNodeEvent'},
        {rawget(_G,'Window'),'registerOnNoteUpdate'}}) do
        local class,name=entry[1],entry[2]
        if class and type(class[name])=='function' and not class['__nr_lifetime_'..name] then
            class['__nr_lifetime_'..name]=true
            local original=class[name]
            class[name]=function(self,window,...)
                protect(window)
                return original(self,window,...)
            end
        end
    end
end
return M
