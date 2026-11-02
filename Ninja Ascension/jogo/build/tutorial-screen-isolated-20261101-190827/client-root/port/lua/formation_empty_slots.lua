-- Empty formation positions stay discoverable even with no spare hero yet.
local M={}
function M.apply(window,seek,slots)
    for _,root in ipairs(window.roots or {}) do
        for position=1,6 do
            local button=seek(root,'Panel_234_add_'..position)
            if button then button:setVisible((tonumber(slots[position]) or 0)==0) end
        end
    end
end
function M.install(class)
    if not class or class.__nr_empty_slots then return end
    class.__nr_empty_slots=true
    for _,name in ipairs({'onMainHeroesDraw','onHeroesDraw'}) do
        local original=class[name]
        if original then
            class[name]=function(self,...)
                local result={original(self,...)}
                M.apply(self,function(root,key)return ccui.Helper:seekWidgetByName(root,key)end,
                        _ED.user_formetion_status or {})
                return unpack(result)
            end
        end
    end
end
return M
