-- Cocos APIs used by the recovered character collection/development screens.
local M={}
local GRAY_SCALE=15 -- pinned Axmol 2.11.5 backend/Enums.h, ProgramType
local function renderers(node,fn,seen)
    seen=seen or {};if seen[node] then return end;seen[node]=true
    if node.getTexture and not node.setString then fn(node) end
    for _,child in ipairs(node:getChildren()) do renderers(child,fn,seen) end
    if node.getProtectedChildren then
        for _,child in ipairs(node:getProtectedChildren()) do renderers(child,fn,seen) end
    end
end
function M.install()
    -- Android keeps its original Cocos renderer and gray implementation.
    -- ProgramType/getProgramState below belong to the desktop Axmol port.
    if cc.Application and cc.PLATFORM_OS_ANDROID then
        local platform=cc.Application:getInstance():getTargetPlatform()
        if platform==cc.PLATFORM_OS_ANDROID then return end
    end
    if cc.Layer and not cc.Layer.setTouchEnabled then
        cc.Layer.setTouchEnabled=function(self,enabled)
            if self.__nr_touch_blocker then
                self:getEventDispatcher():removeEventListener(self.__nr_touch_blocker)
                self.__nr_touch_blocker=nil
            end
            if enabled then
                local listener=cc.EventListenerTouchOneByOne:create()
                listener:setSwallowTouches(true)
                listener:registerScriptHandler(function() return self:isVisible() end,cc.Handler.EVENT_TOUCH_BEGAN)
                self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self)
                self.__nr_touch_blocker=listener
            end
        end
    end
    if not cc.setGray then
        cc.setGray=function(node)
            renderers(node,function(sprite)
                if not sprite.__nr_color_program then
                    sprite.__nr_color_program=sprite:getProgramState():getProgram():getProgramType()
                end
                sprite:setProgramState(GRAY_SCALE)
            end)
        end
    end
    if gray and not M.grayInstalled then
        M.grayInstalled=true
        gray.removeGray=function(node)
            renderers(node,function(sprite)
                if sprite.__nr_color_program then
                    sprite:setProgramState(sprite.__nr_color_program)
                    sprite.__nr_color_program=nil
                end
                sprite.__isGray__=false
            end)
            node.__isGray__=false
        end
    end
end
return M
