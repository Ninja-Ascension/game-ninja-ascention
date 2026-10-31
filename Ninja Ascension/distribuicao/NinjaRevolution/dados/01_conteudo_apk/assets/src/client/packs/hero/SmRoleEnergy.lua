-- ------------------------------------------------------------------------------------------------------------
SmRoleEnergy = class("SmRoleEnergyClass", Window)

local sm_role_energy_window_open_terminal = {
    _name = "sm_role_energy_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmRoleEnergyClass") == nil then
            fwin:open(SmRoleEnergy:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_energy_window_close_terminal = {
    _name = "sm_role_energy_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmRoleEnergyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_role_energy_window_open_terminal)
state_machine.add(sm_role_energy_window_close_terminal)
state_machine.init()

function SmRoleEnergy:ctor()
    self.super:ctor()
    self.roots = {}

    -- local function init_sm_role_energy_terminal()
    --     local sm_role_fashion_update_terminal = {
    --         _name = "sm_role_fashion_update",
    --         _init = function (terminal) 
            
    --         end,
    --         _inited = false,
    --         _instance = self,
    --         _state = 0,
    --         _invoke = function(terminal, instance, params)
    --             if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then

    --             end
    --             return true
    --         end,
    --         _terminal = nil,
    --         _terminals = nil
    --     }

    --     state_machine.add(sm_role_fashion_update_terminal)
    --     state_machine.init()
    -- end

    -- init_sm_role_energy_terminal()
end

function SmRoleEnergy:onUpdateDraw()
    local root = self.roots[1]
    local data = self.ship_evo_mould_field12_talentInfos[1]
    if data == nil then
        return
    end

    local Panel_energy_skill_list = ccui.Helper:seekWidgetByName(root, "Panel_energy_skill_list")
    local cellCsb = csb.createNode("packs/HeroStorage/energy_skill_list_cell.csb")
    local cellRoot = cellCsb:getChildByName("root")
    cellCsb:setContentSize(cc.size(cellRoot:getContentSize().width, cellRoot:getContentSize().height))
    Panel_energy_skill_list:addChild(cellCsb)

    local talent_name = dms.int(dms["talent_mould"], data, talent_mould.talent_name)
    local talent_describe = dms.int(dms["talent_mould"], data, talent_mould.talent_describe)

    -- 名称
    local Text_energy_t = ccui.Helper:seekWidgetByName(cellRoot, "Text_energy_t")
    local strText_energy_t = dms.element(dms["word_mould"], zstring.tonumber(talent_name))
    Text_energy_t:setString(strText_energy_t[3])

    -- 描述
    local Text_energy_skill_cue_n = ccui.Helper:seekWidgetByName(cellRoot, "Text_energy_skill_cue_n")
    local strText_energy_skill_cue_n = dms.element(dms["word_mould"], zstring.tonumber(talent_describe))
    Text_energy_skill_cue_n:setString(strText_energy_skill_cue_n[3])

    -- 图标
    local Panel_energy_skill_list_skill = ccui.Helper:seekWidgetByName(cellRoot, "Panel_energy_skill_list_skill")
    local new_skill_pic = dms.int(dms["talent_mould"], data, talent_mould.new_skill_pic)
    local head = ccui.ImageView:create("images/ui/skills/skills_" .. new_skill_pic .. ".png")
    head:setPosition(cc.p(Panel_energy_skill_list_skill:getContentSize().width / 2, Panel_energy_skill_list_skill:getContentSize().height / 2))
    Panel_energy_skill_list_skill:addChild(head)

end

function SmRoleEnergy:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/energy_skill_list.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_skill_list_back"), nil, 
    {
        terminal_name = "sm_role_energy_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    self:onUpdateDraw()

end

function SmRoleEnergy:init(params)
    self.ship_evo_mould_field12_talentInfos = params[1]
    self:onInit()
    return self
end

function SmRoleEnergy:onExit()
    -- state_machine.remove("sm_role_fashion_update")
end