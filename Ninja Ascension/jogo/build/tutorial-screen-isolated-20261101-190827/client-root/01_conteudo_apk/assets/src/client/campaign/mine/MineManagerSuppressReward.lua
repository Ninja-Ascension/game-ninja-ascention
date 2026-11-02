-----------------------------------------------------------------------------------------------
-- 说明：镇压获得奖励提示
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

MineManagerSuppressReward = class("MineManagerSuppressRewardClass", Window)
    
function MineManagerSuppressReward:ctor()
    self.super:ctor()
	self.actions = {}
	self.roots = {}
    -- Initialize MineManagerSuppressReward page state machine.
    local function init_mine_manager_suppress_reward_terminal()
	
	
	--返回
		local MineManagerSuppressReward_back_activity_terminal = {
            _name = "MineManagerSuppressReward_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			

				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(MineManagerSuppressReward_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_suppress_reward_terminal()
end

--道具
function MineManagerSuppressReward:getPropCell(mid, num,mtype)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cell:init(cellConfig)
	return cell
end

  
function MineManagerSuppressReward:drawPlayer()
	local img = ""
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		img = string.format("images/face/big_head/big_head_%d.png", self.friend_info.head_picIndex-1000)
	else
		img = string.format("images/face/card_head/card_head_%d.png", self.friend_info.head_picIndex-1000)
	end

	
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_63"):setBackGroundImage(img)
	
end


function MineManagerSuppressReward:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("campaign/MineManager/attack_territory_reward.csb")	
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
	
    self:addChild(csbCampaign)
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory_reward.csb") 
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_5"), nil, {func_string = [[state_machine.excute("MineManagerSuppressReward_back_activity", 0, "Button_2.'")]],
			}, nil, 2)
	
	local rewardList = getSceneReward(52)
	
	-- 目前界面只有一个物品显示
	
	local mid = 0
	local num = 0
	local mtype = 0
	
	for i=1, rewardList.show_reward_item_count do
		local item = rewardList.show_reward_list[i] 

		mid = item.prop_item
		num = item.item_value
		mtype = item.prop_type
	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_64"):addChild(self:getPropCell(mid, num, mtype))
	
	ccui.Helper:seekWidgetByName(root, "Text_61"):setString(tipStringInfo_mine_info[26])	
	
	ccui.Helper:seekWidgetByName(root, "Text_1320"):setString(self.friend_info.name)
	local quality = self.friend_info.quality+1
	ccui.Helper:seekWidgetByName(root, "Text_1320"):setColor(self:getColor(quality))
	
	self:drawPlayer()
end


function MineManagerSuppressReward:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end

function MineManagerSuppressReward:onExit()
	state_machine.remove("MineManagerSuppressReward_back_activity")
end

function MineManagerSuppressReward:init(friend_info)
	self.friend_info = friend_info
end

function MineManagerSuppressReward:createCell()
	local cell = MineManagerSuppressReward:new()
	cell:registerOnNodeEvent(cell)
	return cell
end