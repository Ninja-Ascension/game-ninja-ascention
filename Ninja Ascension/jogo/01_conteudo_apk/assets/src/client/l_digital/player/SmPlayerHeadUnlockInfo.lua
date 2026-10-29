-- ----------------------------------------------------------------------------------------------------
-- 说明：数码头像解锁查看
-------------------------------------------------------------------------------------------------------
SmPlayerHeadUnlockInfo = class("SmPlayerHeadUnlockInfoClass", Window)
local sm_player_head_unlock_info_open_terminal = {
    _name = "sm_player_head_unlock_info_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerHeadUnlockInfoClass")
        if _window == nil then
            fwin:open(SmPlayerHeadUnlockInfo:new():init(params),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_head_unlock_info_open_terminal)
state_machine.init()
    
function SmPlayerHeadUnlockInfo:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    local function init_sm_player_head_unlock_info_terminal()
        --关闭
        local sm_player_head_unlock_info_close_terminal = {
            _name = "sm_player_head_unlock_info_close",
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
        state_machine.add(sm_player_head_unlock_info_close_terminal)
        state_machine.init()
    end
    
    init_sm_player_head_unlock_info_terminal()
end

function SmPlayerHeadUnlockInfo:onUpdataDraw()
	local root = self.roots[1]
	local Text_tiaojian = ccui.Helper:seekWidgetByName(root, "Text_tiaojian")
    Text_tiaojian:setString(string.format(_new_interface_text[115] , self.name))

    local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
    Panel_digimon_icon:removeAllChildren(true)

    local big_icon_path = string.format("images/ui/props/props_%d.png", self.pic)
    local SpritHead = cc.Sprite:create(big_icon_path)
    SpritHead:setAnchorPoint(cc.p(0.5,0.5))
    SpritHead:setPosition(cc.p(Panel_digimon_icon:getContentSize().width/2,Panel_digimon_icon:getContentSize().height/2))
    display:gray(SpritHead)

    local quality_path = "images/ui/quality/icon_hero_0.png"
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_digimon_icon:getContentSize().width/2,Panel_digimon_icon:getContentSize().height/2))
    display:gray(SpritKuang)

    Panel_digimon_icon:addChild(SpritKuang)
    Panel_digimon_icon:addChild(SpritHead)
end

function SmPlayerHeadUnlockInfo:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_change_head_list_2_window.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_head_unlock_info_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	self:onUpdataDraw()
end

function SmPlayerHeadUnlockInfo:init(params)
    self.pic = tonumber(params[1])
    self.name = params[2]
    return self
end

function SmPlayerHeadUnlockInfo:onExit()
    state_machine.remove("sm_player_head_unlock_info_close")
end
