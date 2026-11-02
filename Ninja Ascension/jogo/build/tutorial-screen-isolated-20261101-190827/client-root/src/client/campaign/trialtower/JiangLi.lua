JiangLi = class("JiangLiClass", Window)
    
function JiangLi:ctor()
    self.super:ctor()
	self.actions = {}
    -- Initialize JiangLi page state machine.
    local function init_trial_tower_terminal()
	
	
	--返回
		local JiangLi_back_activity_terminal = {
            _name = "JiangLi_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				--fwin:close(instance)
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		
		-- state_machine.add(trial_tower_back_activity_terminal)
		state_machine.add(JiangLi_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

--道具
function JiangLi:getPropCell(mid, num,mtype)
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

--威名
function JiangLi:getHonourCell(num)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldType = 18
	cellConfig.count = num
	cellConfig.isShowName = true
	cell:init(cellConfig)
	return cell
end



function JiangLi:onEnterTransitionFinish()

    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_yulan.csb")	
	local root = csbCampaign:getChildByName("root")
	
	-- local action = csb.createTimeline("campaign/TrialTower/trial_tower_yulan.csb") 
	   	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
	    -- csbCampaign:runAction(action)
   
    self:addChild(csbCampaign)
	
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_yulan.csb") 
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "window_baoxiang_open" then
        elseif str == "window_baoxiang_close_over" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)
	
	local back_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {
		func_string = [[state_machine.excute("JiangLi_back_activity", 0, "Button_2.'")]],
		isPressedActionEnabled = true,
	}, nil, 2)
	--> print("ccui.Helper:seekWidgetByName",ccui.Helper:seekWidgetByName(root, "Button_2"))

	
	--当前显示星数
	ccui.Helper:seekWidgetByName(root, "Text_13_0"):setString(_ED.three_kingdoms_view.left_stars)
	
	--当前显示关卡
	local layerCount = tonumber(_ED.three_kingdoms_view.current_floor)			-- 第几层
	local currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos)		--当前挑战位置
	local npcIndexStart = (layerCount-1) * 3 +1
	
	ccui.Helper:seekWidgetByName(root, "Text_12_0"):setString(string.format(tipStringInfo_trialTower[7],npcIndexStart,npcIndexStart+2))
	
	--奖励级别
    local firstNeedGetLevel = ccui.Helper:seekWidgetByName(root, "Text_7")
		firstNeedGetLevel:setString(game_infomation_tip_str[1])
	local midNeedGetLevel = ccui.Helper:seekWidgetByName(root, "Text_8")
		midNeedGetLevel:setString(game_infomation_tip_str[2])
	local endNeedGetLevel = ccui.Helper:seekWidgetByName(root, "Text_9")
		endNeedGetLevel:setString(game_infomation_tip_str[3])

	--获取每一层的npc奖励id
	local three_kingdoms_nums = zstring.split(dms.string(dms["three_kingdoms_config"], layerCount, three_kingdoms_config.reward_id), ",")
	
	--先取出道具
	--道具数2个时,不处理荣誉显示
	
	local first_prop_list = zstring.split(dms.string(dms["scene_reward"], tonumber(three_kingdoms_nums[1]), scene_reward.reward_prop), "|")
	local middle_prop_list = zstring.split(dms.string(dms["scene_reward"], tonumber(three_kingdoms_nums[2]), scene_reward.reward_prop), "|")
	local end_prop_list = zstring.split(dms.string(dms["scene_reward"], tonumber(three_kingdoms_nums[3]), scene_reward.reward_prop), "|")
	
	
	local first_panel = {"Panel_8_0", "Panel_8"}
	local first_goods = {}
	
	local middle_panel = {"Panel_10", "Panel_9"}
	local middle_goods = {}
	
	local end_panel = {"Panel_11", "Panel_12"}
	local end_goods = {}
	
	--取荣誉
	local first_honor_nums = dms.string(dms["scene_reward"], tonumber(three_kingdoms_nums[1]), scene_reward.reward_honor)
	local middle_honor_nums = dms.string(dms["scene_reward"], tonumber(three_kingdoms_nums[2]), scene_reward.reward_honor)
	local end_honor_nums = dms.string(dms["scene_reward"], tonumber(three_kingdoms_nums[3]), scene_reward.reward_honor)

	function ergodic(list,data,honor)
		for i = 1 ,table.getn(list) do
			local goods = zstring.split(list[i], ",")
			
			local item = {
				mid = tonumber(goods[2]),
				count = tonumber(goods[1]),
				mtype = 6,
			}
			
			table.insert(data, item)
		end
		
		local honor = {
				mid = -1,
				count = tonumber(honor),
				mtype = 18,
			}
		table.insert(data, honor)
	end
	
	ergodic(first_prop_list,first_goods,first_honor_nums)
	ergodic(middle_prop_list,middle_goods,middle_honor_nums)
	ergodic(end_prop_list,end_goods,end_honor_nums)
	
	function drawCell(list,panellist)
		local num = math.min(2, table.getn(list))
		for i = 1 , num do
			
			local item = list[i]
			local cell = self:getPropCell(item.mid, item.count, item.mtype)
		
			ccui.Helper:seekWidgetByName(root, panellist[i]):addChild(cell)
		end
	end
	
	drawCell(first_goods, first_panel)
	drawCell(middle_goods, middle_panel)
	drawCell(end_goods, end_panel)
end


function JiangLi:onExit()
	
	
	state_machine.remove("JiangLi_back_activity")
	-- state_machine.remove("trial_tower_init_treasure")
end
