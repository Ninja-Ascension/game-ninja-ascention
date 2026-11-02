--------------------------------------------------------------------------------------------------------------
--  说明：主页面资源
--------------------------------------------------------------------------------------------------------------
PlayerResource = class("PlayerResourceClass", Window)

--打开界面
local player_resource_window_open_terminal = {
	_name = "player_resource_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("PlayerResourceClass") == nil then
			fwin:open(PlayerResource:new():init(),fwin._ui)
		end
		state_machine.excute("player_resource_window_show",0,"")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_resource_window_close_terminal = {
	_name = "player_resource_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)

		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_resource_window_open_terminal)
state_machine.add(player_resource_window_close_terminal)
state_machine.init()

function PlayerResource:ctor()
	self.super:ctor()
	self.roots = {}

	self.gem_text = nil
	self.silver_text = nil
	self.mine_text = nil
	self.food_text = nil
	 -- Initialize alert_home state machine.
    local function init_play_resource_terminal()
		
		
		--显示所有
		local player_resource_window_show_terminal = {
            _name = "player_resource_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 隐藏所有
        local player_resource_window_hide_terminal = {
            _name = "player_resource_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --任务完成元宝获得动画
        local player_resource_play_animation_terminal = {
            _name = "player_resource_play_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local value = params[1]
                instance:onPlayAnimation(value)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(player_resource_window_show_terminal)
		state_machine.add(player_resource_window_hide_terminal)	
		state_machine.add(player_resource_play_animation)		
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_play_resource_terminal()

end

function PlayerResource:onShow( ... )
	self:setVisible(true)
end

function PlayerResource:onHide( ... )
	self:setVisible(false)
end

function PlayerResource:updateDraw()
	local root = self.roots[1]
	local Text_gem = ccui.Helper:seekWidgetByName(root,"Text_gem")
	local Text_gold = ccui.Helper:seekWidgetByName(root,"Text_gold")
	local Text_mine = ccui.Helper:seekWidgetByName(root,"Text_mine")
	local Text_power = ccui.Helper:seekWidgetByName(root,"Text_power")

	local Image_gem = ccui.Helper:seekWidgetByName(root,"Image_gem")
	local Image_mine = ccui.Helper:seekWidgetByName(root,"Image_mine")
	self._gold_x = Image_gem:getPositionX()
    self._gold_y = Image_gem:getPositionY()
    self._mine_x = Image_mine:getPositionX()
    self._mine_y = Image_mine:getPositionY()
	--钻石
	if tonumber(_ED.user_info.user_gold) >= 100000 then
		local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
		Text_gem:setString(string.format(red_alert_all_str[122],info))
	else
		Text_gem:setString(_ED.user_info.user_gold)
	end
	--金币
	if tonumber(_ED.user_info.user_silver) >= 100000 then
		local info = math.floor(tonumber(_ED.user_info.user_silver)/10000)
		Text_gold:setString(string.format(red_alert_all_str[122],info))
	else
		Text_gold:setString(_ED.user_info.user_silver)
	end
	--木材
	if tonumber(_ED.user_info.user_iron) >= 100000 then
		local info = math.floor(tonumber(_ED.user_info.user_iron)/10000)
		Text_mine:setString(string.format(red_alert_all_str[122],info))
	else
		Text_mine:setString(_ED.user_info.user_iron)
	end
	--体力
	Text_power:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
	self.gem_text = Text_gem
	self.silver_text = Text_gold
	self.mine_text = Text_mine	
	self.food_text = Text_power
end

--任务完成元宝获得动画onPlayAnimation
function PlayerResource:onPlayAnimation(value)
	--删除
    local function removeDrawAntNumberFuncN(sender)
        sender:removeFromParent(true)
    end
	local root = self.roots[1]
	local Image_gold = ccui.Helper:seekWidgetByName(root,"Image_gold")
	local Image_gold_x = Image_gold:getPositionX()
    local Image_gold_y = Image_gold:getPositionY()
    local Panel_gem_get = ccui.Helper:seekWidgetByName(root,"Panel_gem_get")
	local Panel_gem_get_x = Panel_gem_get:getPositionX()
    local Panel_gem_get_y = Panel_gem_get:getPositionY()
    for i = 1, 5 do
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_gem_mt/effect_gem_mt.ExportJson")
	    local effice = ccs.Armature:create("effect_gem_mt")
	    effice:getAnimation():playWithIndex(0)
	    if math.floor(i % 2) == 0 then
            effice:setPosition(cc.p(Panel_gem_get:getContentSize().width/2 + 10 * i, Panel_gem_get:getContentSize().height/2))
        else
            effice:setPosition(cc.p(Panel_gem_get:getContentSize().width/2 - 10 * i, Panel_gem_get:getContentSize().height/2))
        end
	    Panel_gem_get:addChild(effice) 
	    effice:runAction(cc.Sequence:create(
	    	cc.DelayTime:create(i/5),
	        cc.MoveTo:create(0.7, cc.p(Image_gold_x-Panel_gem_get_x,Image_gold_y-Panel_gem_get_y)),
	        cc.CallFunc:create(removeDrawAntNumberFuncN)
	        ))
	    local text_table = {"+"..value}
	    state_machine.excute("add_number_window_open",0,{27,text_table})
	end
end

function PlayerResource:onUpdate()
	if self.gem_text == nil or self.silver_text == nil or self.food_text == nil or self.mine_text == nil then
		return
	end
	--钻石
	if tonumber(_ED.user_info.user_gold) >= 100000 then
		local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
		self.gem_text:setString(string.format(red_alert_all_str[122],info))
	else
		self.gem_text:setString(_ED.user_info.user_gold)
	end
	--金币
	if tonumber(_ED.user_info.user_silver) >= 100000 then
		local info = math.floor(tonumber(_ED.user_info.user_silver)/10000)
		self.silver_text:setString(string.format(red_alert_all_str[122],info))
	else
		self.silver_text:setString(_ED.user_info.user_silver)
	end
	--木材
	if tonumber(_ED.user_info.user_iron) >= 100000 then
		local info = math.floor(tonumber(_ED.user_info.user_iron)/10000)
		self.mine_text:setString(string.format(red_alert_all_str[122],info))
	else
		self.mine_text:setString(_ED.user_info.user_iron)
	end
	--体力
	self.food_text:setString(_ED.user_info.user_food .. "/".. _ED.user_info.max_user_food)	
end

function PlayerResource:onInit()
    local csbItem = csb.createNode(config_csb.player.player_resource)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  	
    -- 购买体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_2"), nil, 
    {
        terminal_name = "buy_resource_window_open", 
        terminal_state = 0, 
        resource_type = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 购买体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_add_power"), nil, 
    {
        terminal_name = "buy_resource_window_open", 
        terminal_state = 0, 
        resource_type = 1,
    }, nil, 0) 

    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_1"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_add_gem"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
    }, nil, 0)    
	self:updateDraw()
end

function PlayerResource:onEnterTransitionFinish()

end

function PlayerResource:init()
	self:onInit()
	return self
end

function PlayerResource:onExit()
	state_machine.remove("player_resource_window_show")
	state_machine.remove("player_resource_window_hide")
	state_machine.remove("player_resource_play_animation")
end