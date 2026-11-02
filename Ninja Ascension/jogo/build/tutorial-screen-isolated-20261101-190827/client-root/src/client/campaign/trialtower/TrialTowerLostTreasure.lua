----------------------------------------------------------------------------------
-- 失败时弹出的无双秘籍
----------------------------------------------------------------------------------

TrialTowerLostTreasure = class("TrialTowerLostTreasureClass", Window)
    
function TrialTowerLostTreasure:ctor()
    self.super:ctor()
	self.actions = {}
    -- Initialize TrialTowerLostTreasure page state machine.
    local function init_trial_tower_terminal()
	
	
		--返回
		local trial_tower_lost_treasure_back_activity_terminal = {
            _name = "trial_tower_lost_treasure_back_activity",
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
		
		--购买
		local trial_tower_lost_treasure_buy_treasure_terminal = {
            _name = "trial_tower_lost_treasure_buy_treasure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				
				local mid = params._datas.mid
				local count = params._datas.count
				local mouldType = params._datas.mouldType
				local gemPrice = params._datas.gemPrice
				local goodsIndexID = params._datas.goodsIndexID
				
				app.load("client.campaign.trialtower.TrialTowerBuyLostTreasure")
				local tip = TrialTowerBuyLostTreasure:new()
				tip:init(mid, count, mouldType, gemPrice,goodsIndexID)
				fwin:open(tip,fwin._windows)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(trial_tower_lost_treasure_buy_treasure_terminal)
		state_machine.add(trial_tower_lost_treasure_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

--道具
function TrialTowerLostTreasure:getPropCell(mid, count, mouldType)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = count
	cellConfig.touchShowType = nil
	cellConfig.isShowName = nil
	cellConfig.isDebris = true
	cellConfig.mouldType = mouldType or 6
	cell:init(cellConfig)
	return cell
end

function TrialTowerLostTreasure:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end



function TrialTowerLostTreasure:onEnterTransitionFinish()

    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_treasure.csb")	
	local root = csbCampaign:getChildByName("root")
    self:addChild(csbCampaign)
	
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_treasure.csb") 
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "open" then
        elseif str == "close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)

	--当前显示星数
	ccui.Helper:seekWidgetByName(root, "Text_21_0"):setString(_ED.three_kingdoms_view.current_max_stars)
	
	-- 获取当前需要设置的对象参数
	local indexID = _ED.three_kingdoms_lost_treasure.indexID
	local isBuy = _ED.three_kingdoms_lost_treasure.isBuy
	local mid = nil
	local count = nil
	local mouldType = nil
	local selType = nil
	local name = nil
	local quality = 0
	
	mid = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.mould)
	count = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.sel_count)
	selType = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.sel_type)
	selSilver = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.sel_silver)
	price = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.cost_price)
	discountPrice = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.discount_price)
	
	
	if 0 < selSilver then
		mouldType = 1
		count = selSilver
		name = _All_tip_string_info._fundName
		quality		= 1
	elseif 0 == selType then
		mouldType = 6
		name = dms.string(dms["prop_mould"], mid, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            name = setThePropsIcon(mid)[2]
        end
		quality		= dms.int(dms["prop_mould"], mid, prop_mould.prop_quality)+1
	elseif 1 == selType then
		mouldType = 13
		name = dms.string(dms["ship_mould"], mid, ship_mould.captain_name)
		quality		= dms.int(dms["ship_mould"], mid, ship_mould.ship_type)+1
	elseif 2 == selType then
		mouldType = 7
		name = dms.string(dms["equipment_mould"], mid, equipment_mould.equipment_name)
		quality		= dms.int(dms["equipment_mould"], mid, equipment_mould.grow_level)+1
	end

	local treasureCell = self:getPropCell(mid, count, mouldType)
	ccui.Helper:seekWidgetByName(root, "Panel_20"):addChild(treasureCell)
	ccui.Helper:seekWidgetByName(root, "Text_25_0"):setString(price)
	ccui.Helper:seekWidgetByName(root, "Text_26_0"):setString(discountPrice)
	ccui.Helper:seekWidgetByName(root, "Text_24"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_24"):setColor(self:getColor(quality))
	
	local buy_button = ccui.Helper:seekWidgetByName(root, "Button_40")
	local closeDown = ccui.Helper:seekWidgetByName(root, "Image_10")
	
	buy_button:setVisible(false)
	closeDown:setVisible(false)
	
	if 0 == isBuy then
		buy_button:setVisible(true)
		fwin:addTouchEventListener(buy_button, nil,
			{
				terminal_name = "trial_tower_lost_treasure_buy_treasure", 
				terminal_state = 0, 
				replyPhysical = replyPhysicalBtn, 
				isPressedActionEnabled = true,
				
				mid = mid,
				count = count,
				mouldType = mouldType,
				gemPrice = discountPrice,
				goodsIndexID = indexID,
				
			},
			nil,0)
	else
		closeDown:setVisible(true)
	end
	
		
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("trial_tower_lost_treasure_back_activity", 0, "")]]}, nil, 0)
end


function TrialTowerLostTreasure:init()


end

function TrialTowerLostTreasure:onExit()
	state_machine.remove("trial_tower_lost_treasure_back_activity")
	state_machine.remove("trial_tower_lost_treasure_buy_treasure")
end
