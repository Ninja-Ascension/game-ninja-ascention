-- ----------------------------------------------------------------------------------------------------
-- 说明：公会大冒险强制结算提示
-------------------------------------------------------------------------------------------------------
SmUnionAdventureSettlement = class("SmUnionAdventureSettlementClass", Window)

local sm_union_adventure_settlement_open_terminal = {
    _name = "sm_union_adventure_settlement_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureSettlementClass")
        if nil == _homeWindow then
            local panel = SmUnionAdventureSettlement:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_adventure_settlement_close_terminal = {
    _name = "sm_union_adventure_settlement_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureSettlementClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionAdventureSettlementClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_adventure_settlement_open_terminal)
state_machine.add(sm_union_adventure_settlement_close_terminal)
state_machine.init()
    
function SmUnionAdventureSettlement:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_sm_union_adventure_settlement_terminal()
        -- 显示界面
        local sm_union_adventure_settlement_display_terminal = {
            _name = "sm_union_adventure_settlement_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureSettlementWindow = fwin:find("SmUnionAdventureSettlementClass")
                if SmUnionAdventureSettlementWindow ~= nil then
                    SmUnionAdventureSettlementWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_adventure_settlement_hide_terminal = {
            _name = "sm_union_adventure_settlement_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureSettlementWindow = fwin:find("SmUnionAdventureSettlementClass")
                if SmUnionAdventureSettlementWindow ~= nil then
                    SmUnionAdventureSettlementWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 结算
        local sm_union_adventure_settlement_rewarld_receive_terminal = {
            _name = "sm_union_adventure_settlement_rewarld_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.adventure_draw_union = nil
                        state_machine.excute("sm_union_adventure_start_new_start", 0, "0")
                        state_machine.excute("sm_union_adventure_settlement_close", 0, "0")
                    end
                end
                --奖励上限
                local silver_ceiling = 0
                local gem_ceiling = 0
                local prop_ceiling = 0

                local science_info = zstring.split(_ED.union_science_info,"|")
                local hall_technology = zstring.split(science_info[5],",")
                --通过科技类型找到科技模板的库组
                local parameter_group = dms.int(dms["union_science_mould"], 5, union_science_mould.parameter_group)
                --通过参数库组找到对应de经验参数表数据
                local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
                local expData = nil
                for i, v in pairs(expMould) do
                    if tonumber(hall_technology[1]) == tonumber(v[3]) then
                        expData = v
                        break
                    end
                end

                local expData_info = zstring.split(expData[5],",")
                silver_ceiling = tonumber(expData_info[1])
                gem_ceiling = tonumber(expData_info[2])
                prop_ceiling = tonumber(expData_info[3])

                local datas = zstring.split(_ED.union_adventure_state_info,"!")
                if datas[2] == "-1" then
                else
                    local reworldData = zstring.split(datas[2],"|")
                    for i, v in pairs(reworldData) do
                        local datasReworld = zstring.split(v,",")
                        if tonumber(datasReworld[1]) == 1 then
                            silver_ceiling = silver_ceiling - tonumber(datasReworld[3])
                        elseif tonumber(datasReworld[1]) == 2 then
                            gem_ceiling = gem_ceiling - tonumber(datasReworld[3])
                        elseif tonumber(datasReworld[1]) == 6 then 
                            prop_ceiling = prop_ceiling - tonumber(datasReworld[3])
                        end
                    end
                end

                local rewardInfo = ""
                local reward_silver = math.min(tonumber(instance.silver_number), silver_ceiling)
                if reward_silver > 0 then
                    if rewardInfo == "" then
                        rewardInfo = "1,-1,"..reward_silver
                    else
                        rewardInfo = rewardInfo.."|".."1,-1,"..reward_silver
                    end
                end
                local gem_ceiling = math.min(tonumber(instance.gem_number), gem_ceiling)
                if gem_ceiling > 0 then
                    if rewardInfo == "" then
                        rewardInfo = "2,-1,"..gem_ceiling
                    else
                        rewardInfo = rewardInfo.."|".."2,-1,"..gem_ceiling
                    end
                end
                local prop_ceiling = math.min(tonumber(instance.prop_number), prop_ceiling)
                if prop_ceiling > 0 then

                    local propData = zstring.split(dms.string(dms["union_config"], 73, union_config.param), ",")
                    local propType = propData[1]
                    local propId = propData[2]

                    if rewardInfo == "" then
                        rewardInfo = propType .. "," .. propId .. "," .. prop_ceiling
                    else
                        rewardInfo = rewardInfo .. "|".. propType .. "," .. propId .. ",".. prop_ceiling
                    end
                end
                
                local science_info = zstring.split(_ED.union_science_info,"|")
                local adventure = zstring.split(science_info[4],",")
                protocol_command.union_stick_crazy_adventure_draw_reward.param_list = (tonumber(adventure[4])+1).."\r\n"..rewardInfo.."\r\n"..instance.old_current_layer
                NetworkManager:register(protocol_command.union_stick_crazy_adventure_draw_reward.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_adventure_settlement_display_terminal)
        state_machine.add(sm_union_adventure_settlement_hide_terminal)
        state_machine.add(sm_union_adventure_settlement_rewarld_receive_terminal)
        state_machine.init()
    end
    init_sm_union_adventure_settlement_terminal()
end


function SmUnionAdventureSettlement:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_zs_n = ccui.Helper:seekWidgetByName(root,"Text_zs_n")
    Text_zs_n:setString(self.gem_number)
    local Text_jb_n = ccui.Helper:seekWidgetByName(root,"Text_jb_n")
    Text_jb_n:setString(self.silver_number)
    local Text_sp_n = ccui.Helper:seekWidgetByName(root,"Text_sp_n")
    Text_sp_n:setString(self.prop_number)
end

function SmUnionAdventureSettlement:init(params)
    self.silver_number = params[1]
    self.gem_number = params[2]
    self.prop_number = params[3]
    self.old_current_layer = params[4]
    self:onInit()
    return self
end

-- 创建icon
function SmUnionAdventureSettlement:addResourcesIconCell(propData)
    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    if 13 == rewardType then
        local extraTable = {}
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    else
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
    end
    return cell
end

function SmUnionAdventureSettlement:addRewardPropIcon()
    local propData = zstring.split(dms.string(dms["union_config"], 73, union_config.param), ",")
    local cell = self:addResourcesIconCell(propData)

    local Panel_sp_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sp_icon")
    Panel_sp_icon:removeAllChildren(true)
    Panel_sp_icon:addChild(cell)
end

function SmUnionAdventureSettlement:onInit()
    local csbSmUnionAdventureSettlement = csb.createNode("legion/sm_legion_adventure_settlement.csb")
    local root = csbSmUnionAdventureSettlement:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionAdventureSettlement)
	
	local action = csb.createTimeline("legion/sm_legion_adventure_settlement.csb")
    table.insert(self.actions, action)
    csbSmUnionAdventureSettlement:runAction(action)
    action:play("window_open", false)
	
    self:onUpdateDraw()
    
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.UnionAdventureReward)
    if fun_is_open == true then
        self:addRewardPropIcon()
    end

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_union_adventure_settlement_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_union_adventure_settlement_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    -- 结算
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_union_adventure_settlement_rewarld_receive",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionAdventureSettlement:onExit()
    state_machine.remove("sm_union_adventure_settlement_display")
    state_machine.remove("sm_union_adventure_settlement_hide")
end