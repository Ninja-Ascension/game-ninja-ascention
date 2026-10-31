-- Keep the guide's input geometry, hand and effects; remove its dark fill.
local M={}
function M.apply(window)
    for _,root in ipairs(window.roots or {}) do
        root:setBackGroundColorOpacity(0)
        root:setBackGroundColorType(0)
        for _,name in ipairs({'Panel_3','Panel_4','Panel_5','Panel_6','Panel_7','Panel_black'}) do
            local node=ccui.Helper:seekWidgetByName(root,name)
            if node then
                node:setBackGroundColorOpacity(0)
                node:setBackGroundColorType(0)
                if name=='Panel_black' then node:setOpacity(0) end
            end
        end
        -- Five mask images form the black cutout around the round target.
        for _,name in ipairs({'Image_1','Image_1_0','Image_1_0_0','Image_1_0_0_0','Image_1_0_0_0_0'}) do
            local node=ccui.Helper:seekWidgetByName(root,name)
            if node then node:setOpacity(0) end
        end
    end
end
function M.install(class)
    if not class then return end
    class.__nr_guide_hooks=class.__nr_guide_hooks or {}
    for _,name in ipairs({'showWindow','onUpdate','playTuitionAnimation','initTuition'}) do
        local original=class[name]
        if type(original)=='function' and not class.__nr_guide_hooks[name] then
            class.__nr_guide_hooks[name]=true
            class[name]=function(self,...)
                local result={original(self,...)}
                M.apply(self)
                return unpack(result)
            end
        end
    end
end
return M
