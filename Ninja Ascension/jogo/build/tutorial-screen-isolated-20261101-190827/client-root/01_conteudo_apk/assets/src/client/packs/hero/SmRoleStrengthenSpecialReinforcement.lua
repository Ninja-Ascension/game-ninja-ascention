-----------------------------
-- 斗魂特殊强化
-----------------------------
SmRoleStrengthenSpecialReinforcement = class("SmRoleStrengthenSpecialReinforcementClass", Window)

--打开界面
local sm_role_strengthen_special_reinforcement_open_terminal = {
	_name = "sm_role_strengthen_special_reinforcementopen",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRoleStrengthenSpecialReinforcementClass") == nil then
			fwin:open(SmRoleStrengthenSpecialReinforcement:new():init(params), fwin._windows)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_role_strengthen_special_reinforcement_open_terminal)
state_machine.init()

function SmRoleStrengthenSpecialReinforcement:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_sm_role_strengthen_special_reinforcementterminal()

        --刷新界面
        local sm_role_strengthen_special_reinforcementupdate_draw_page_terminal = {
            _name = "sm_role_strengthen_special_reinforcementupdate_draw_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭界面
        local sm_role_strengthen_special_reinforcement_close_terminal = {
            _name = "sm_role_strengthen_special_reinforcement_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("SmRoleStrengthenSpecialReinforcementClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 材料强化
        local sm_role_strengthen_special_reinforcement_strengthen_material_terminal = {
            _name = "sm_role_strengthen_special_reinforcement_strengthen_material",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship_id = instance.ship_id
                state_machine.lock("sm_role_strengthen_special_reinforcement_strengthen_material")
                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship_id})
                            if funOpenDrawTip(177,false) == false then
                                state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_update_draw", 0, "")
                            else
                                state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_update_draw", 0, "")
                            end
                            state_machine.excute("sm_role_strengthen_special_reinforcement_close", 0, "")
                            smFightingChange()
                        end
                    end
                    state_machine.unlock("sm_role_strengthen_special_reinforcement_strengthen_material")
                end
                protocol_command.ship_soul_level_up.param_list = instance.ship_id.."\r\n".."1".."\r\n"..(tonumber(instance.m_index)-1).."\r\n"..self.money
                NetworkManager:register(protocol_command.ship_soul_level_up.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_special_reinforcement_close_terminal)
        state_machine.add(sm_role_strengthen_special_reinforcementupdate_draw_page_terminal)
        state_machine.add(sm_role_strengthen_special_reinforcement_strengthen_material_terminal)
        state_machine.init()
    end
    init_sm_role_strengthen_special_reinforcementterminal()
end

function SmRoleStrengthenSpecialReinforcement:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    local faction_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.faction_id),",")
    local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.unlock_condition)
    --找对应的天赋
    local talent_id =  tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])
    local name = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_name)
    local word_info = dms.element(dms["word_mould"], name)
    local skillName = word_info[3]

    local soul_data = zstring.split(shipInfo.ship_fighting_spirit,"|")
    local soul_exp = tonumber(zstring.split(soul_data[self.m_index],",")[2])
    local soul_lv = tonumber(zstring.split(soul_data[self.m_index],",")[1])
    local attribute_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.attribute_id),",")
    local expLibrary = attribute_id[self.m_index]
    local expUpData = dms.searchs(dms["ship_soul_experience_param"], ship_soul_experience_param.library_group, expLibrary)
    local expUpInfo = nil
    for i,v in pairs(expUpData) do
        if tonumber(v[3]) == soul_lv then
            expUpInfo = v
            break
        end
    end

    local Text_tip_1 = ccui.Helper:seekWidgetByName(root,"Text_tip_1")
    local strs = string.format(_new_interface_text[161],""..skillName,""..(soul_lv+1))
    Text_tip_1:setString(strs)

    local Text_zuanshi_number = ccui.Helper:seekWidgetByName(root,"Text_zuanshi_number")
    local needMoney = dms.int(dms["ship_config"], 9, ship_config.param)
    self.money = (tonumber(expUpInfo[4])-soul_exp)*needMoney
    Text_zuanshi_number:setString(self.money)
end

function SmRoleStrengthenSpecialReinforcement:init(params) 
    self.m_index = tonumber(params._datas.index)
    self.ship_id = params._datas.ship_id
	self:onInit()
    return self
end

function SmRoleStrengthenSpecialReinforcement:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_5_tip.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    local action = csb.createTimeline("packs/HeroStorage/sm_role_strengthen_tab_cell_5_tip.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_role_strengthen_special_reinforcement_close",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_role_strengthen_special_reinforcement_strengthen_material",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    
    
    self:onUpdateDraw()
end

function SmRoleStrengthenSpecialReinforcement:onEnterTransitionFinish()
    
end


function SmRoleStrengthenSpecialReinforcement:onExit()
end

