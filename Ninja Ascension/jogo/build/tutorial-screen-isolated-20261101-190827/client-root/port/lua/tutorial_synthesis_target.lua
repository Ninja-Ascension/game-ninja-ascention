-- mission3 305014 uses a fixed list index. Owned heroes now occupy that
-- index; their hidden synthesis button must never receive the guide click.
local M={}
function M.find(items,seek)
    for index,row in ipairs(items) do
        for side,cell in ipairs({row.child1 or false,row.child2 or false}) do
            if cell and cell.prop and not cell.heroInstance then
                for _,root in ipairs(cell.roots or {}) do
                    local button=seek(root,'Button_hecheng')
                    if button and button:isVisible() and button:isEnabled() then return index,side end
                end
            end
        end
    end
end
function M.install(class)
    if not class or class.__nr_synthesis_target then return end
    class.__nr_synthesis_target=true
    local update=class.updateTouchPosition
    class.updateTouchPosition=function(self,...)
        local mission=self._mission
        if not mission or tonumber(mission[10])~=305014 then return update(self,...) end
        local window=fwin:find('HeroListViewClass')
        if window then
            for _,root in ipairs(window.roots or {}) do
                local list=ccui.Helper:seekWidgetByName(root,'ListView_25081')
                if list then
                    local index,side=M.find(list:getItems(),function(r,n)return ccui.Helper:seekWidgetByName(r,n)end)
                    if index then
                        local oldIndex,oldName=mission[17],mission[18]
                        mission[17]=tostring(index);mission[18]=side..'|Button_hecheng'
                        local result={pcall(update,self,...)}
                        mission[17],mission[18]=oldIndex,oldName
                        if not result[1] then error(result[2],0) end
                        return unpack(result,2)
                    end
                end
            end
        end
        self._selectObject=nil
        return -- no eligible visible button: do not invoke a hidden one
    end
end
return M
