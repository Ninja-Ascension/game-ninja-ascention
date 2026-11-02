ConnectingView = class("ConnectingViewClass", Window)

--打开界面
local connecting_view_window_open_terminal = {
    _name = "connecting_view_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LoginLoadingClass") == nil then
            if nil == fwin:find("ConnectingViewClass") then
                fwin:open(ConnectingView:new(), fwin._system)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local connecting_view_window_close_terminal = {
    _name = "connecting_view_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ConnectingViewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(connecting_view_window_open_terminal)
state_machine.add(connecting_view_window_close_terminal)
state_machine.init()

function ConnectingView:ctor()
    self.super:ctor()
	
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if fwin:find("LoginClass") ~= nil then
            local csbConnectingView = csb.createNode("utils/time_ing_1.csb")
            self:addChild(csbConnectingView)
        else
           local csbConnectingView = csb.createNode("utils/time_ing.csb")
            self:addChild(csbConnectingView)
        end
    else
    	local csbConnectingView = csb.createNode("utils/time_ing.csb")
        self:addChild(csbConnectingView)
    end

    -- local root = csbConnectingView:getChildByName("root")
    -- local Panel_loading = ccui.Helper:seekWidgetByName(root, "Panel_loading")
    -- if nil ~= Panel_loading then
    -- 	local baseName = "images/ui/effice/effect_6/effect_wait"
    -- 	local animation = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, null, false, nil)
	   --  animation:addAnimation(0, "animation_event", true)
	   --  animation:setPosition(cc.p(Panel_loading:getContentSize().width/2,Panel_loading:getContentSize().height/2))
	   --  Panel_loading:addChild(animation)
    -- end
end

function ConnectingView:onEnterTransitionFinish()
	
end

function ConnectingView:onExit()
	
end
