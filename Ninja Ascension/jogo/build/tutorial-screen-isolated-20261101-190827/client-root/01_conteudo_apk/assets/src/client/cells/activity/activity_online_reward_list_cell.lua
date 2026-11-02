-- ----------------------------------------------------------------------------------------------------
-- 说明：在線獎勵
-------------------------------------------------------------------------------------------------------
ActivityOnlineRewardListCell = class("ActivityOnlineRewardListCellClass", Window)
ActivityOnlineRewardListCell.__size = nil
-- ActivityOnlineRewardListCell
function ActivityOnlineRewardListCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	self.example = nil
	self.index = 0
	self.activity = nil
	self.rewardIndex = 0
	self.activityId = 0
	
    -- Initialize ActivityOnlineRewardListCell state machine.
    local function init_activity_online_reward_list_cell_terminal()
		local activity_online_reward_list_cell_draw_fund_reward_terminal = {
            _name = "activity_online_reward_list_cell_draw_fund_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local RewardCell = params._datas._cell
					local index = RewardCell.index
					local function responseGetActivityRewardCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil then
								response.node:rewadDraw(response.node.index)
							end
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._windows)
						end
					end
					protocol_command.get_activity_reward.param_list = ""..RewardCell.activityId.."\r\n"..RewardCell.rewardIndex.."\r\n".."1"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, RewardCell, responseGetActivityRewardCallback, false, nil)
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(activity_online_reward_list_cell_draw_fund_reward_terminal)
		state_machine.init()
    end
    
    -- -- call func init ActivityOnlineRewardListCell state machine.
    init_activity_online_reward_list_cell_terminal()
end

function ActivityOnlineRewardListCell:onUpdateDrawRecharge()

end

function ActivityOnlineRewardListCell:rewadDraw(_index)
	local root = self.roots[1]
	
	ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_13"):setVisible(true)
end
	
function ActivityOnlineRewardListCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[80]
	local rewadArry = nil
	self.activityId = activity.activity_id
	self.rewardIndex = dms.atoi(self.example,online_gift_mould.id)
	
	self.activity  = activity
	local reward_time = dms.atoi(self.example,online_gift_mould.online_time)
	
	local Text_103 = ccui.Helper:seekWidgetByName(root, "Text_103")
	Text_103:setString(string.format(_string_piece_info[390],""..reward_time))

	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListViewDraw:removeAllItems()
	local props = string.split(dms.atos(self.example,online_gift_mould.rewards),"|")
	for k,v in pairs(props) do
		local rewardIcon = nil
		local prop = zstring.split(""..v,",")
		if zstring.tonumber(prop[2]) == -1 then 
			--资源类型
			rewardIcon = propMoneyIcon:createCell()
			rewardIcon:init(""..prop[1], prop[3])
		else
			if zstring.tonumber(prop[1]) == 7 then 
				rewardIcon = EquipIconCell:createCell()
                rewardIcon:init(10, nil, prop[2], nil)
			elseif zstring.tonumber(prop[1]) == 6 then 
				rewardIcon = PropIconCell:createCell()
				rewardIcon:init(24, tostring(prop[2]), prop[3])
			end
		end
		if rewardIcon ~= nil then 
			ListViewDraw:addChild(rewardIcon)
		end
	end
	self:onUpdateRewardStates()
end

--更新领取状态
function ActivityOnlineRewardListCell:onUpdateRewardStates()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local drawButton = ccui.Helper:seekWidgetByName(root, "Button_lingqu")	
	local nodrawButton = ccui.Helper:seekWidgetByName(root, "Image_13")
	local states = zstring.split("".._ED.on_linde_gift_info.reward_states,",")[self.rewardIndex]
	local current_total_time = _ED.on_linde_gift_info.current_online_time[self.index]
	if states ~= nil then 
		if zstring.tonumber(states) == 0 then 
			--没有领取
			local need_time = dms.atoi(self.example,online_gift_mould.online_time)
			local current_time = 0 
			if self.index == zstring.tonumber(_ED.active_activity[80].activity_day_count) then 
				current_time = (os.time() - _ED.on_linde_gift_info.current_system_time ) + current_total_time
			else
				current_time = current_total_time
			end 
			local isTime = current_time >=need_time *60
			drawButton:setBright(isTime)
			drawButton:setTouchEnabled(isTime)
			nodrawButton:setVisible(false)
		else
			--已经领取过了
			nodrawButton:setVisible(true)
			drawButton:setBright(false)
			drawButton:setVisible(false)
		end
	end
end

--道具
function ActivityOnlineRewardListCell:getItemCell(mid,mtype,count,isCertainly)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.isShowName = false
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cellConfig.count = count
	cellConfig.isCertainly = isCertainly
	cell:init(cellConfig)
	return cell
end

function ActivityOnlineRewardListCell:onEnterTransitionFinish()
	
end

function ActivityOnlineRewardListCell:onInit()

 	local root = cacher.createUIRef("activity/wonderful/activity_online_reward_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	if ActivityOnlineRewardListCell.__size == nil then
		ActivityOnlineRewardListCell.__size = root:getChildByName("Panel_2"):getContentSize()
	end	
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.ActivityFightingRank)
	-- 列表控件动画播放
	local action = csb.createTimeline("activity/wonderful/activity_online_reward_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)

	local drawButton = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
	local nodrawButton = ccui.Helper:seekWidgetByName(root, "Image_13")
	nodrawButton:setVisible(false)
	drawButton:setBright(false)
	drawButton:setTouchEnabled(false)
	drawButton:setVisible(true)
	self:onUpdateDraw()
	
	 -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"),       nil, 
    {
        terminal_name = "activity_online_reward_list_cell_draw_fund_reward",
        current_button_name = "Button_lingqu",
        but_image = "Image_kf_01",   
        _cell = self,    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function ActivityOnlineRewardListCell:onExit()
	cacher.freeRef("activity/wonderful/activity_online_reward_list.csb", self.roots[1])
end

function ActivityOnlineRewardListCell:init(example,index)
	self.example = example
	self.index = index
	self:onInit()
	self:setContentSize(ActivityOnlineRewardListCell.__size)
end

function ActivityOnlineRewardListCell:reload()

	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityOnlineRewardListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("activity/wonderful/activity_online_reward_list.csb", root)

	root:removeFromParent(false)
	self.roots = {}
	self.activity = nil
end

function ActivityOnlineRewardListCell:createCell()
	local cell = ActivityOnlineRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end