-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面控件2
-------------------------------------------------------------------------------------------------------
SmRoleInformationControlsTwo = class("SmRoleInformationControlsTwoClass", Window)
SmRoleInformationControlsTwo.__size  = nil

local sm_role_information_controls_two_open_terminal = {
    _name = "sm_role_information_controls_two_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local cell = SmRoleInformationControlsTwo:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_controls_two_close_terminal = {
    _name = "sm_role_information_controls_two_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationControlsTwoClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationControlsTwoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_controls_two_open_terminal)
state_machine.add(sm_role_information_controls_two_close_terminal)
state_machine.init()
    
function SmRoleInformationControlsTwo:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    app.load("client.shop.recruit.SmGeneralsCard")
    local function init_sm_role_information_controls_two_terminal()
        -- 显示界面
        local sm_role_information_controls_two_display_terminal = {
            _name = "sm_role_information_controls_two_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsTwoWindow = fwin:find("SmRoleInformationControlsTwoClass")
                if SmRoleInformationControlsTwoWindow ~= nil then
                    SmRoleInformationControlsTwoWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_controls_two_hide_terminal = {
            _name = "sm_role_information_controls_two_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsTwoWindow = fwin:find("SmRoleInformationControlsTwoClass")
                if SmRoleInformationControlsTwoWindow ~= nil then
                    SmRoleInformationControlsTwoWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_controls_two_display_terminal)
        state_machine.add(sm_role_information_controls_two_hide_terminal)
        state_machine.init()
    end
    init_sm_role_information_controls_two_terminal()
end

function SmRoleInformationControlsTwo:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipData = nil
    local ship_id = self.ship_id
    if zstring.tonumber(self.m_type) == -1 then
        shipData = self.ship_id
        ship_id = shipData.ship_template_id
    else
        if self.isMould == true then
            ship_id = self.ship_id
        else
            for i, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_template_id) == tonumber(self.ship_id) then
                    shipData = v
                    ship_id = shipData.ship_template_id
                    break
                end
            end
        end
    end

    local Text_fighting_0 = ccui.Helper:seekWidgetByName(root, "Text_fighting_0")
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], ship_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = nil
    if shipData == nil then
        evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
    else
        local ship_evo = zstring.split(shipData.evolution_status, "|")
        evo_mould_id = evo_info[tonumber(ship_evo[1])]
    end
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local location = word_info[3]
    Text_fighting_0:setString(location)

end

function SmRoleInformationControlsTwo:init(params)
    --模板id
    self.ship_id = params[1]
    self.isMould = params[2]
    self.m_type = params[3] or nil
    self:onInit()
    return self
end

function SmRoleInformationControlsTwo:onInit()
    local csbSmRoleInformationControlsTwo = csb.createNode("packs/HeroStorage/sm_generals_information_2.csb")
    local root = csbSmRoleInformationControlsTwo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationControlsTwo)
	if SmRoleInformationControlsTwo.__size == nil then
        SmRoleInformationControlsTwo.__size = root:getContentSize()
    end
    self:onUpdateDraw()
end

function SmRoleInformationControlsTwo:onExit()
    state_machine.remove("sm_role_information_controls_two_display")
    state_machine.remove("sm_role_information_controls_two_hide")
end