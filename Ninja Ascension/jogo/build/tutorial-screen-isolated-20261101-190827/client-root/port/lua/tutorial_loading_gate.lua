-- Keep the current tutorial step pending while the login screen is visible.
local M={}
local function loading()
    local node=fwin:find('LoginLoadingClass')
    if not node or tolua.isnull(node) then return false end
    while node do
        if not node:isVisible() then return false end
        node=node:getParent()
    end
    return true
end
function M.install(class)
    if not class or class.__nr_loading_gate then return end
    class.__nr_loading_gate=true
    local show,update=class.showWindow,class.onUpdate
    local function suspend(self)
        if not loading() then return false end
        if not self.__nr_loading_suspended then
            self.__nr_loading_suspended=true
            self.__nr_loading_visible=self:isVisible()
        end
        self:setVisible(false)
        return true
    end
    class.showWindow=function(self,...)
        local result={show(self,...)}
        suspend(self)
        return unpack(result)
    end
    class.onUpdate=function(self,...)
        if suspend(self) then return end
        if self.__nr_loading_suspended then
            self:setVisible(self.__nr_loading_visible)
            self.__nr_loading_suspended=nil
            self.__nr_loading_visible=nil
        end
        return update(self,...)
    end
end
return M
