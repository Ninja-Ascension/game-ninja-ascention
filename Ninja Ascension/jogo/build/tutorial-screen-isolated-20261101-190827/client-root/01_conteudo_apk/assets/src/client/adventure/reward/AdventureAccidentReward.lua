-- ----------------------------------------------------------------------------------------------------
-- 说明：意外奖励提示界面
-------------------------------------------------------------------------------------------------------
AdventureAccidentReward = class("AdventureAccidentRewardClass", Window)
    
function AdventureAccidentReward:ctor()
    self.super:ctor()
    self.roots = {}
	self.rewardInfo = nil
	self.rewardList = nil
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()

    	local adventure_battle_reward_close_terminal = {
            _name = "adventure_battle_reward_close",
            _init = function (terminal)  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if #self.rewardList > 0 then 
            		state_machine.excute("adventure_tip_reward_open_accident", 0, {_datas = {list = self.rewardList}})
            	end
            	fwin:close(fwin:find("AdventureAccidentRewardClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        state_machine.add(adventure_battle_reward_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureAccidentReward:init(rewardInfoList)
	self.rewardList = rewardInfoList
	if rewardInfoList ~= nil and #rewardInfoList > 0 then 
		self.rewardInfo = self.rewardList[1]
		table.remove(self.rewardList,1)
	end
	
	return self
end

function AdventureAccidentReward:onUpdateDraw()
	local root = self.roots[1]
	local Text_shouhuo = ccui.Helper:seekWidgetByName(root, "Text_shouhuo")
	local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
	local Panel_harvest = ccui.Helper:seekWidgetByName(root, "Panel_harvest")
	Panel_harvest:removeBackGroundImage()
	Panel_harvest:setScale(1)
	if zstring.tonumber(self.rewardInfo.prop_type) == 7 then
		local equipInfo = dms.element(dms["equipment_mould"], self.rewardInfo.prop_item)
		picIndex = dms.atos(equipInfo, equipment_mould.pic_index)
		Panel_harvest:setBackGroundImage(string.format("images/face/hero_head/bg_skill_skill_%d.png", zstring.tonumber(picIndex)))
		Panel_harvest:setScale(2.5)
		Text_shouhuo:setString(_reward_info_accident[1])
		Text_zhanli:setString(dms.atos(equipInfo, equipment_mould.equipment_name))
	elseif zstring.tonumber(self.rewardInfo.prop_type) == 26 then
		Panel_harvest:setBackGroundImage("images/ui/icon/icon_explore_specialreward_fight.png")
		Text_shouhuo:setString(_reward_info_accident[2])
		Text_zhanli:setString(self.rewardInfo.item_value)
	elseif zstring.tonumber(self.rewardInfo.prop_type) == 27 then
		Panel_harvest:setBackGroundImage("images/ui/icon/icon_explore_specialreward_pick.png")
		Text_shouhuo:setString(_reward_info_accident[3])
		Text_zhanli:setString(self.rewardInfo.item_value)
	elseif zstring.tonumber(self.rewardInfo.prop_type) == 28 then
		Panel_harvest:setBackGroundImage("images/ui/icon/icon_explore_specialreward_chuzhan.png")
		Text_shouhuo:setString(_reward_info_accident[4])
		Text_zhanli:setString(self.rewardInfo.item_value)
	end
	
end

function AdventureAccidentReward:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/unexpected_harvest.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
	self:onUpdateDraw()
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"),       nil, 
    {
        terminal_name = "adventure_battle_reward_close",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

end

function AdventureAccidentReward:onExit()

end