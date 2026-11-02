-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 吃烧鸡，领体力意外获得钻石
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityAddEnergyAccident = class("ActivityAddEnergyAccidentClass", Window)
    
function ActivityAddEnergyAccident:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	app.load("client.cells.utils.resources_icon_cell")
	self.rewardCount = 0
    -- Initialize ActivityAddEnergyAccident state machine.
    local function init_activity_add_energy_terminal()
		
		local reward_add_enter_button_close_terminal = {
            _name = "reward_add_enter_button_close",
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
		
		state_machine.add(reward_add_enter_button_close_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityAddEnergyAccident state machine.
    init_activity_add_energy_terminal()
end

function ActivityAddEnergyAccident:onUpdateDraw()
	local root = self.roots[1]
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local cell = ResourcesIconCell:createCell()
	cell:init(0, 0, 0, {show_reward_list={{prop_type = 2, item_value = self.rewardCount}}})
	Panel_3:addChild(cell)
end

function ActivityAddEnergyAccident:initDraw()
	local csbActivityAddEnergy = csb.createNode("activity/wonderful/add_strength_award.csb")
	local action = csb.createTimeline("activity/wonderful/add_strength_award.csb") 
	
   	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbActivityAddEnergy:runAction(action)
	local root = csbActivityAddEnergy:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbActivityAddEnergy)
	
	self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_81"), nil, 
		{
			terminal_name = "reward_add_enter_button_close", 
			terminal_state = 0, 
		},
		nil,0)
end

function ActivityAddEnergyAccident:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function ActivityAddEnergyAccident:unload()
	local root = self.roots[1]
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if Panel_3 ~= nil then
		Panel_3:removeAllChildren(true)
	end
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function ActivityAddEnergyAccident:onEnterTransitionFinish()
	-- local csbActivityAddEnergy = csb.createNode("activity/wonderful/add_strength_award.csb")
	-- local action = csb.createTimeline("activity/wonderful/add_strength_award.csb") 
	
 --   	action:gotoFrameAndPlay(0, action:getDuration(), false)
 --    csbActivityAddEnergy:runAction(action)
	-- local root = csbActivityAddEnergy:getChildByName("root")
	-- table.insert(self.roots, root)
	-- self:addChild(csbActivityAddEnergy)
	
	-- self:onUpdateDraw()
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"), nil, 
	-- 	{
	-- 		terminal_name = "reward_add_enter_button_close", 
	-- 		terminal_state = 0, 
	-- 	},
	-- 	nil,0)

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end


function ActivityAddEnergyAccident:init(rewardCount)
	self.rewardCount = rewardCount
end


function ActivityAddEnergyAccident:createCell()
	local cell = ActivityAddEnergyAccident:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ActivityAddEnergyAccident:onExit()
	state_machine.remove("reward_add_enter_button_close")
end