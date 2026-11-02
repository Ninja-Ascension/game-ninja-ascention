-- ----------------------------------------------------------------------------------------------------
-- 说明：龙珠推送设置
-------------------------------------------------------------------------------------------------------
PlayerPushSet = class("PlayerPushSet", Window)
local sm_player_push_set_page_open_terminal = {
    _name = "sm_player_push_set_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("PlayerPushSet")
        if _window == nil then
            fwin:open(PlayerPushSet:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_push_set_page_open_terminal)
state_machine.init()
    
function PlayerPushSet:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    self.image_on_group = {}
    self.image_off_group = {}
    self.image_button_group = {}

    local function init_sm_player_push_set_page_terminal()

        --关闭
        local sm_player_push_set_page_close_terminal = {
            _name = "sm_player_push_set_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_player_push_set_page_close_terminal)
        state_machine.init()
    end
    
    init_sm_player_push_set_page_terminal()
end

function PlayerPushSet:onUpdataDraw()
    
end


function PlayerPushSet:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_push.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_push_set_page_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	self:initControllor()
end

function PlayerPushSet:initControllor()
    local root = self.roots[1]
    local parentNode = nil
    for i = 1 , 4 do 
        parentNode = ccui.Helper:seekWidgetByName(root, "Image_switch_"..i)
        self.image_on_group[i] = ccui.Helper:seekWidgetByName(parentNode, "Image_on")
        self.image_off_group[i] = ccui.Helper:seekWidgetByName(parentNode, "Image_off")
        self.image_button_group[i] = ccui.Helper:seekWidgetByName(parentNode, "Image_button")

        local status = true
        if i == 1 then
            status = cc.UserDefault:getInstance():getBoolForKey("m_isPushSetting1",true)
        elseif i == 2 then
            status = cc.UserDefault:getInstance():getBoolForKey("m_isPushSetting2",false)
        elseif i == 3 then
            status = cc.UserDefault:getInstance():getBoolForKey("m_isPushSetting3",true)
        else
            status = cc.UserDefault:getInstance():getBoolForKey("m_isPushSetting4",false)
        end

        if status then
            self.image_button_group[i]:setPosition(cc.p(self.image_off_group[i]:getPosition()))
        else
            self.image_button_group[i]:setPosition(cc.p(self.image_on_group[i]:getPosition()))
        end

        local function selectorCallBack(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if status == false then
                    status = true

                    cc.UserDefault:getInstance():setBoolForKey("m_isPushSetting" .. sender.index ,status)
                    cc.UserDefault:getInstance():flush()

                    sender:setPosition(cc.p(self.image_off_group[sender.index]:getPosition()))
                elseif status == true then
                    status = false
                    
                    cc.UserDefault:getInstance():setBoolForKey("m_isPushSetting" .. sender.index ,status)
                    cc.UserDefault:getInstance():flush()

                    sender:setPosition(cc.p(self.image_on_group[sender.index]:getPosition()))
                end
            end
        end

        self.image_button_group[i].index = i
        self.image_button_group[i]:addTouchEventListener(selectorCallBack)
    end
end

function PlayerPushSet:onExit()
    state_machine.remove("sm_player_push_set_page_close")
end
