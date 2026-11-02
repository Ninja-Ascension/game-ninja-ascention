-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 迎财神
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
LookUpAccumulate = class("LookUpAccumulateClass", Window)
    
function LookUpAccumulate:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	self.getTimes = 0
	self.accumulateSilver = 0
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
    -- Initialize activity_welcome_mammon state machine.
    local function init_activity_welcome_mammon_terminal()
		local look_up_accumulate_close_terminal = {
            _name = "look_up_accumulate_close",
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
		
		local welcome_mammon_six_count_button_terminal = {
            _name = "welcome_six_count_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("activity_welcome_mammon_recharge_state_button", 0, "activity_welcome_mammon_recharge_state_button.")
						if response.node ~= nil then
							fwin:close(response.node)
						end
					end
				end
				NetworkManager:register(protocol_command.greet_fortune.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(look_up_accumulate_close_terminal)
		state_machine.add(welcome_mammon_six_count_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init LookUpAccumulate state machine.
    init_activity_welcome_mammon_terminal()
end




function LookUpAccumulate:onUpdateDraw()
	local root = self.roots[1]
	local getButton = ccui.Helper:seekWidgetByName(root, "Button_pp_1")
	if tonumber(_ED.welcome_mammon.welcome_time_sum) == tonumber(_ED.welcome_mammon.welcome_time_yet) then
		getButton:setBright(true)
		getButton:setTouchEnabled(true)
	else 
		getButton:setBright(false)
		getButton:setTouchEnabled(false)
	end
	
	local Panel_pp_3 = ccui.Helper:seekWidgetByName(root, "Panel_pp_3")
	
	-- app.load("client.cells.utils.resources_icon_cell")
	-- local cell = ResourcesIconCell:createCell()
	-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 1, item_value = _ED.welcome_mammon.return_jsilver_count}}})
	-- Panel_pp_3:addChild(cell)
	
	local cell = propMoneyIcon:createCell()
	cell:init("1",_ED.welcome_mammon.return_jsilver_count,nil)
	Panel_pp_3:addChild(cell)
	
	local Text_pp_3 = ccui.Helper:seekWidgetByName(root, "Text_pp_3")
	Text_pp_3:setString(_string_piece_info[196].."\r\n"..self.accumulateSilver.._string_piece_info[197].."\r\n"..self.getTimes.._string_piece_info[198])
end

function LookUpAccumulate:initDraw()
	if self.loaded == false then
		return
	end
    local csbLookUpAccumulate = csb.createNode("activity/wonderful/welcome_god_Wealth_k.csb")
	local root = csbLookUpAccumulate:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbLookUpAccumulate)
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pp_1"), nil, 
		{
			terminal_name = "welcome_six_count_button", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"), nil, 
		{
			terminal_name = "look_up_accumulate_close", 
			terminal_state = 0
		},
		nil,0)
			
	
	self:onUpdateDraw()
end

function LookUpAccumulate:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function LookUpAccumulate:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function LookUpAccumulate:onEnterTransitionFinish()
 --    local csbLookUpAccumulate = csb.createNode("activity/wonderful/welcome_god_Wealth_k.csb")
	-- local root = csbLookUpAccumulate:getChildByName("root")
 --    table.insert(self.roots, root)
 --    self:addChild(csbLookUpAccumulate)
	-- --领取
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pp_1"), nil, 
	-- 	{
	-- 		terminal_name = "welcome_six_count_button", 
	-- 		terminal_state = 0, 
	-- 		isPressedActionEnabled = true
	-- 	},
	-- 	nil,0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"), nil, 
	-- 	{
	-- 		terminal_name = "look_up_accumulate_close", 
	-- 		terminal_state = 0
	-- 	},
	-- 	nil,0)
			
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 
	self:lazy()
end

function LookUpAccumulate:onExit()
	self:unload()
	state_machine.remove("welcome_six_count_button")
	state_machine.remove("look_up_accumulate_close")
end

function LookUpAccumulate:init(getTimes,accumulateSilver)
	self.getTimes = getTimes
	self.accumulateSilver = accumulateSilver
end

function LookUpAccumulate:createCell()
	local cell = LookUpAccumulate:new()
	cell:registerOnNodeEvent(cell)
	return cell
end