-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双 购买无双秘籍
-------------------------------------------------------------------------------------------------------
TrialTowerBuyLostTreasure = class("TrialTowerBuyLostTreasureClass", Window)

function TrialTowerBuyLostTreasure:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.interfaceType = 0
	self.npcId = 0
	self.needGold = 0               -- 需要消耗的宝石
    self.resetCount = 0             -- 已经可重置次数
    self.residualCount = 0          -- 剩余的可重置次数
	self.state_machine_info = nil

	self._enum_type = {
		_RESET_ATTACK_COUNT_PLOT_COPY_NPC = 1  		-- NPC 每日挑战次数重置
	}

    -- Initialize recharge tip dialog state machine.
    local function init_recharge_tip_dialog_terminal()
        local trial_tower_buy_lost_treasure_close_terminal = {
            _name = "trial_tower_buy_lost_treasure_close",
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


        local trial_tower_buy_lost_treasure_terminal = {
            _name = "trial_tower_buy_lost_treasure",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.residualCount <= 0 then
					--state_machine.excute("trial_tower_buy_lost_treasure_close", 0, "")
                   
					instance:buyGoods()
                    return
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(trial_tower_buy_lost_treasure_close_terminal)
        state_machine.add(trial_tower_buy_lost_treasure_terminal)
        state_machine.init()
    end
    
    -- call func init recharge tip dialog state machine.
    init_recharge_tip_dialog_terminal()
end

function TrialTowerBuyLostTreasure:onUpdateDraw()
   
end


function TrialTowerBuyLostTreasure:buyGoods()
	local function responseBuGoodsCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then	
			_ED.three_kingdoms_lost_treasure.isBuy = 1
			-- 通知关闭无双秘籍界面
			state_machine.excute("trial_tower_buy_lost_treasure_complete", 0, "")
			
			state_machine.excute("trial_tower_lost_treasure_back_activity", 0, "")
			
			state_machine.excute("trial_tower_buy_lost_treasure_close", 0, "")
			
		end
	end
	if self.gemPrice <= tonumber(_ED.user_info.user_gold) then
		protocol_command.unparallel_purchase.param_list = self.goodsIndexID
		NetworkManager:register(protocol_command.unparallel_purchase.code, nil, nil, nil, nil, responseBuGoodsCallback, false, nil)
	else
		TipDlg.drawTextDailog(_string_piece_info[74])
	end

end

--道具
function TrialTowerBuyLostTreasure:getPropCell(mid, count, mouldType)
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

-- 模板id, 购买数量, 物品类型,宝石价格
-- 暂先这么处理,后面需要再处理成公共面板
function TrialTowerBuyLostTreasure:init(mid, count, mouldType, gemPrice, goodsIndexID)
	self.mid = mid
	self.count = count
	self.mouldType = mouldType
	self.gemPrice = gemPrice
	self.goodsIndexID = goodsIndexID
end

function TrialTowerBuyLostTreasure:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end

function TrialTowerBuyLostTreasure:onEnterTransitionFinish()
	local csbTrialTowerBuyLostTreasure = csb.createNode("campaign/TrialTower/trial_tower_treasure_buy.csb")
    local root = csbTrialTowerBuyLostTreasure:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("campaign/TrialTower/trial_tower_treasure_buy.csb")
    table.insert(self.actions, action )
    csbTrialTowerBuyLostTreasure:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
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

    self:addChild(csbTrialTowerBuyLostTreasure)

    self:onUpdateDraw()
	
	local mid = self.mid
	local mouldType = self.mouldType
	local name = nil
	local price = self.gemPrice
	local quality = 0
	if 1 == mouldType then
		name = _All_tip_string_info._fundName
		quality		= 1
	elseif 6 == mouldType then
		name = dms.string(dms["prop_mould"], mid, prop_mould.prop_name)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            name = setThePropsIcon(mid)[2]
        end
		quality		= dms.int(dms["prop_mould"], mid, prop_mould.prop_quality)+1
	elseif 13 == mouldType then
		name = dms.string(dms["ship_mould"], mid, ship_mould.captain_name)
		quality		= dms.int(dms["ship_mould"], mid, ship_mould.ship_type)+1
	elseif 7 == mouldType then
		name = dms.string(dms["equipment_mould"], mid, equipment_mould.equipment_name)
		quality		= dms.int(dms["equipment_mould"], mid, equipment_mould.grow_level)+1
	end

	local cell = self:getPropCell(self.mid, self.count, self.mouldType)
	ccui.Helper:seekWidgetByName(root, "Panel_5"):addChild(cell)
	ccui.Helper:seekWidgetByName(root, "Text_2_0_0"):setString(price)
	ccui.Helper:seekWidgetByName(root, "Text_285"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_285"):setColor(self:getColor(quality))

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_101"),       nil, 
    {
        terminal_name = "trial_tower_buy_lost_treasure_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"),       nil, 
    {
        terminal_name = "trial_tower_buy_lost_treasure_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	

    -- 请求购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_25"),       nil, 
    {
        terminal_name = "trial_tower_buy_lost_treasure",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function TrialTowerBuyLostTreasure:onExit()
    state_machine.remove("trial_tower_buy_lost_treasure_close")
	state_machine.remove("trial_tower_buy_lost_treasure")
end