UnionFightResult = class("UnionFightResultClass", Window)

local union_fight_result_open_terminal = {
	_name = "union_fight_result_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightResultClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        state_machine.lock("union_fight_result_open")
		fwin:open(UnionFightResult:new():init(params), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fight_result_close_terminal = {
	_name = "union_fight_result_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightResultClass")
		if window ~= nil then
			fwin:close(window)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fight_result_open_terminal)
state_machine.add(union_fight_result_close_terminal)
state_machine.init()

function UnionFightResult:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.ship.ship_head_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.unionFighting.UnionFightGainReward")
    else
        app.load("client.union.unionFighting.UnionFightGainReward")
    end
    local function init_union_fight_result_terminal()
        local union_fight_result_request_award_terminal = {
            _name = "union_fight_result_request_award",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.union_fight_result = nil
                        fwin:open(UnionFightGainReward:new():init(), fwin._windows)
                        state_machine.excute("union_fight_result_close", 0, nil)
                    end
                end
                protocol_command.draw_reward_center.param_list = "1\r\n".._ED.union_fight_reward_info._reward_centre_id..",".._ED.union_fight_reward_info._reward_type
                NetworkManager:register(protocol_command.draw_reward_center.code, nil, nil, nil, self, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fight_result_request_award_terminal)
        state_machine.init()
    end
	
    init_union_fight_result_terminal()
end

function UnionFightResult:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    local Text_legion_name_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_name_0")
    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
    local Text_jifen_0 = ccui.Helper:seekWidgetByName(root, "Text_jifen_0")
    local Panel_100 = ccui.Helper:seekWidgetByName(root, "Panel_100")
    local Panel_shibai = ccui.Helper:seekWidgetByName(root, "Panel_shibai")
    Panel_100:setVisible(false)
    Panel_shibai:setVisible(false)

    Text_legion_name:setString(_ED.union_fight_owner_union_name)
    Text_legion_name_0:setString(_ED.union_fight_other_union_name)
    Text_jifen:setString("".._ED.union_fight_owner_score)
    Text_jifen_0:setString("".._ED.union_fight_other_score)

    for i=1,5 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_16_"..i)
        panel:removeAllChildren(true)
        if i <= tonumber(_ED.union_fight_reward_info._reward_item_count) then
            local reward = _ED.union_fight_reward_info._reward_list[i]
            if reward ~= nil then
                if tonumber(reward.prop_type) == 6 then   --道具
                    local cell = self:getItemCell(tostring(reward.prop_item),nil,reward.item_value)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 7 then   --装备
                    local cell = EquipIconCell:createCell()
                    cell:init(11, nil, tostring( reward.prop_item), nil, nil, reward.item_value)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 8 then   --武将
                    local cell = ShipHeadCell:createCell()
                    cell:init(nil, 13,  tostring(reward.prop_item), reward.item_value)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 1 then   --银币
                    local cell = propMoneyIcon:createCell()
                    cell:init("1",reward.item_value,nil)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 2 then   --金币
                    local cell = propMoneyIcon:createCell()
                    cell:init("2",reward.item_value,nil)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 3 then   --声望
                    local cell = propMoneyIcon:createCell()
                    cell:init("3",reward.item_value,nil)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 4 then   --将魂
                    local cell = propMoneyIcon:createCell()
                    cell:init("4",reward.item_value,nil)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 5 then   --魂玉
                    local cell = propMoneyIcon:createCell()
                    cell:init("5",reward.item_value,nil)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 10 then  --决斗荣誉
                    local cell = propMoneyIcon:createCell()
                    cell:init("6",reward.item_value,nil)
                    panel:addChild(cell)
                elseif tonumber(reward.prop_type) == 11 then  --功勋
                    local cell = propMoneyIcon:createCell()
                    cell:init("7",reward.item_value,nil)
                    panel:addChild(cell)
                end
            end
        end
    end
    -- 胜利
    if tonumber(_ED.union_fight_result) == 0 then
        Panel_100:setVisible(true)
        if __lua_project_id == __lua_project_warship_girl_b then
            local ArmatureNode_1 = Panel_100:getChildByName("ArmatureNode_1")
            local animation = ArmatureNode_1:getAnimation()
            animation:playWithIndex(0)
        end
    else-- 失败
        Panel_shibai:setVisible(true)
    end
end

--道具
function UnionFightResult:getItemCell(mid,mtype,count,isCertainly)
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

function UnionFightResult:onInit()
	local csbUnion = csb.createNode("legion/legion_pve_map_victory.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	self:updateDraw()

    local Button_10 = ccui.Helper:seekWidgetByName(root, "Button_10")
    Button_10:setVisible(true)
    fwin:addTouchEventListener(Button_10, nil, 
    {
        terminal_name = "union_fight_result_request_award",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)

    state_machine.unlock("union_fight_result_open")
end

function UnionFightResult:onEnterTransitionFinish()
end

function UnionFightResult:init()
	self:onInit()
	return self
end

function UnionFightResult:onExit()
    state_machine.remove("union_fight_result_request_award")
end
