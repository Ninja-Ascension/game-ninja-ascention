-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励中心的list
-------------------------------------------------------------------------------------------------------
AdventureRewardCenterRewardList = class("AdventureRewardCenterRewardListClass", Window)
    
function AdventureRewardCenterRewardList:ctor()
    self.super:ctor()
	self.roots = {}
	self.rewardData = nil
	self.drawIndex = nil 
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
	app.load("client.adventure.activity.reward.AdventureRewardCenter")
    -- Initialize adventure daily sign in state machine.
    local function init_adventure_reward_center_reward_list_terminal()
		-- 领取
        local adventure_reward_center_reward_list_receive_terminal = {
            _name = "adventure_reward_center_reward_list_receive",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
				local function responsePropCompoundCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED._reward_centre[tonumber(response.node.drawIndex)] = nil 
						app.load("client.adventure.reward.AdventureTipReward")
						if zstring.tonumber(response.node.rewardData._reward_type) ~= 13  then 
							-- 好友爱心不提示奖励框
							local reward = getSceneReward(7)
							if reward ~= nil then 
								fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
							end
							
						end
						state_machine.excute("adventure_reward_center_update_list", 0, {response.node.rewardData})
					end
				end
				protocol_command.draw_reward_center.param_list = "".."1".."\r\n"..cell.rewardData._reward_centre_id..","..cell.rewardData._reward_type
				NetworkManager:register(protocol_command.draw_reward_center.code, nil, nil, nil, cell, responsePropCompoundCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_reward_center_reward_list_receive_terminal)
        state_machine.init()
    end
    
    -- call func init adventure daily sign in state machine.
    init_adventure_reward_center_reward_list_terminal()
end

function AdventureRewardCenterRewardList:init(reward,drawIndex)
	self.rewardData = reward
	self.drawIndex = drawIndex
    return self
end

function AdventureRewardCenterRewardList:onEnterTransitionFinish()
    local csbAdventureWeekSignInReward = csb.createNode("list/list_libao_box.csb")
    local root = csbAdventureWeekSignInReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureWeekSignInReward)
	
	local size = root:getContentSize()

	self:setContentSize(root:getContentSize())
	--
	local Text_aixin = ccui.Helper:seekWidgetByName(root, "Text_aixin")
	
	--送你
	local Text_song = ccui.Helper:seekWidgetByName(root, "Text_song")
		--奖励名称
	local Text_haoyouname = ccui.Helper:seekWidgetByName(root, "Text_haoyouname")
	local Text_libaoName = ccui.Helper:seekWidgetByName(root, "Text_libaoname")
	Text_haoyouname:setString("")
	Text_libaoName:setString("")

	--时间
	local Text_daoju = ccui.Helper:seekWidgetByName(root, "Text_daoju")

	
	--奖励图片
	local Panel_daoju = ccui.Helper:seekWidgetByName(root, "Panel_daoju")
	local image_12 = ccui.Helper:seekWidgetByName(root, "Image_12")
	Panel_daoju:removeAllChildren(true)
	if zstring.tonumber(self.rewardData._reward_type) == 0 then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {resource_type = 3} , "", nil, 0, 0)
		Panel_daoju:addChild(cell)
		local str = ""
		for k,v in pairs(self.rewardData._reward_list) do
			--银币
			if zstring.tonumber(v.prop_type) == 1 then
				str = str.._All_tip_string_info._fundName.."X"..v.item_value
			end
			--金币
			if zstring.tonumber(v.prop_type) == 2 then
				str = str.._All_tip_string_info._crystalName.."X"..v.item_value
			end
			--声望
			if zstring.tonumber(v.prop_type) == 3 then
				str = str.._All_tip_string_info._glories.."X"..v.item_value
			end
			--道具
			if zstring.tonumber(v.prop_type) == 6 then
				str = str..dms.string(dms["prop_mould"], v.prop_item, prop_mould.prop_name).."X"..v.item_value
			end
			--装备
			if zstring.tonumber(v.prop_type) == 7 then
				str = str..dms.string(dms["equipment_mould"], v.prop_item, equipment_mould.equipment_name).."X"..v.item_value
			end
			--武将
			if zstring.tonumber(v.prop_type) == 8 then
				str = str..dms.string(dms["ship_mould"], v.prop_item, ship_mould.captain_name).."X"..v.item_value
			end
		end
		Text_aixin:setString(str)
		Text_song:setVisible(false)
	elseif zstring.tonumber(self.rewardData._reward_type) == 2 then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {resource_type = 24} , "", nil, 0, 0)
		Panel_daoju:addChild(cell)
		Text_aixin:setString(_string_piece_info[420])
		Text_song:setVisible(false)
	elseif zstring.tonumber(self.rewardData._reward_type) == 13 then
			Text_daoju:setVisible(false)
			image_12:setVisible(false)
			Text_song:setVisible(true)
			Text_song:setString(_string_piece_info[421])
			local cell = adventureNewSmallPropIconCell:createCell()
			cell:init(0, {resource_type = 23} , "", nil, 0, 0)
			Panel_daoju:addChild(cell)
			Text_aixin:setString(_All_tip_string_info._friendness .. "X".. self.rewardData._reward_list[1].item_value)
			--Text_aixin:setString(str)
	elseif zstring.tonumber(self.rewardData._reward_type) == 14 then --排位赛奖励
			Text_daoju:setVisible(false)
			image_12:setVisible(false)
			Text_song:setVisible(true)
			Text_song:setVisible(false)
			local cell = adventureNewSmallPropIconCell:createCell()
			cell:init(0, {resource_type = 27} , "", nil, 0, 0)
			Panel_daoju:addChild(cell)
	else
		Text_daoju:setVisible(true)
		image_12:setVisible(true)
	end
	
	if zstring.tonumber(self.rewardData._reward_type) == 0 then
		Text_libaoName:setString(_string_piece_info[396] .. self.rewardData._reward_describe)
	elseif zstring.tonumber(self.rewardData._reward_type) == 13 then 
		Text_haoyouname:setString(self.rewardData._reward_describe)
	elseif zstring.tonumber(self.rewardData._reward_type) == 14 then 
		Text_libaoName:setString(_All_tip_string_info._arena)
	else

		Text_libaoName:setString(self.rewardData._reward_describe)
	end
	
	local rewardTime = os.time() - self.rewardData._reward_time + (_ED.native_time  - _ED.system_time)
	--print("-----------:",rewardTime,_ED.native_time  - _ED.system_time)
	--local temp = os.date("*t",rewardTime )
	Text_daoju:setString(self:getLeaveTimeString(rewardTime))
	
	
	-- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ling"),       nil, 
    {
        terminal_name = "adventure_reward_center_reward_list_receive",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

end


function AdventureRewardCenterRewardList:getLeaveTimeString(rewardTime)
	local str = ""
	local hour = math.floor(tonumber(rewardTime)/3600)
	local mins = math.floor((tonumber(rewardTime)%3600)/60)
	local day = ""
	-- "小时前",----------------288
	-- "分钟前",----------------289
	-- "刚刚",----------------290
	-- "天前",----------------291
	if rewardTime == 0 or mins < 1 then
		str = "1" .. _string_piece_info[289]
	elseif hour < 1 then
		str = "".. mins .. _string_piece_info[289]
	elseif hour >= 1 and hour < 24 then
		str = "" .. hour .._string_piece_info[288]
	elseif hour >= 24 then
		day = math.floor( hour / 24)
		str = "" .. day .._string_piece_info[291]
	end
	return str
end
function AdventureRewardCenterRewardList:onExit()
	
end

function AdventureRewardCenterRewardList:createCell()
	local cell = AdventureRewardCenterRewardList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end