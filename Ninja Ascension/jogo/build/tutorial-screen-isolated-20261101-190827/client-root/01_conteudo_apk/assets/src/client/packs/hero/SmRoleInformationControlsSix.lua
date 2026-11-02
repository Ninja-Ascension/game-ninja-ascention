-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面控件6
-------------------------------------------------------------------------------------------------------
SmRoleInformationControlsSix = class("SmRoleInformationControlsSixClass", Window)
SmRoleInformationControlsSix.__size = nil

local sm_role_information_controls_six_open_terminal = {
    _name = "sm_role_information_controls_six_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local cell = SmRoleInformationControlsSix:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_controls_six_close_terminal = {
    _name = "sm_role_information_controls_six_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationControlsSixClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationControlsSixClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_controls_six_open_terminal)
state_machine.add(sm_role_information_controls_six_close_terminal)
state_machine.init()
    
function SmRoleInformationControlsSix:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    app.load("client.shop.recruit.SmGeneralsCard")
    app.load("client.packs.hero.SmRoleStrengthenTabsoulDescription")
    local function init_sm_role_information_controls_six_terminal()
        -- 显示界面
        local sm_role_information_controls_six_display_terminal = {
            _name = "sm_role_information_controls_six_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsSixWindow = fwin:find("SmRoleInformationControlsSixClass")
                if SmRoleInformationControlsSixWindow ~= nil then
                    SmRoleInformationControlsSixWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_controls_six_hide_terminal = {
            _name = "sm_role_information_controls_six_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsSixWindow = fwin:find("SmRoleInformationControlsSixClass")
                if SmRoleInformationControlsSixWindow ~= nil then
                    SmRoleInformationControlsSixWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开描述
        local sm_role_information_controls_six_open_description_terminal = {
            _name = "sm_role_information_controls_six_open_description",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas._index
                state_machine.excute("sm_role_strengthen_tab_soul_description_open", 0, {instance.tship_id, index, instance.m_type, instance.isMould})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_controls_six_display_terminal)
        state_machine.add(sm_role_information_controls_six_hide_terminal)
        state_machine.add(sm_role_information_controls_six_open_description_terminal)
        state_machine.init()
    end
    init_sm_role_information_controls_six_terminal()
end

function SmRoleInformationControlsSix:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local shipData = nil
    local ship_id = self.ship_id
    if zstring.tonumber(self.m_type) == -1 then
        shipData = _ED.other_user_ship
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

    self.tship_id = ship_id

    local faction_id = zstring.split(dms.string(dms["ship_mould"], ship_id, ship_mould.faction_id),",")
    for i=1,4 do
        local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[i], ship_soul_mould.unlock_condition)
        --找对应的天赋
        local talent_id = tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[i], ship_soul_mould.talent_id),",")[1])

        --锁的背景
        local Image_dh_1 = ccui.Helper:seekWidgetByName(root,"Image_dh_"..i.."_1")
        --开的背景
        local Image_dh_2 = ccui.Helper:seekWidgetByName(root,"Image_dh_"..i.."_2")
        --锁的图案
        local Image_dh_lock = ccui.Helper:seekWidgetByName(root,"Image_dh_lock_"..i)
        --画斗魂图标
        local Panel_dh_icon = ccui.Helper:seekWidgetByName(root,"Panel_dh_icon_"..i)
        Panel_dh_icon:removeBackGroundImage()
        local icon = dms.string(dms["talent_mould"], talent_id, talent_mould.buff_add_beau)
        if tonumber(icon) < 10 then
            icon = "0"..icon
        end
        Panel_dh_icon:setBackGroundImage(string.format("images/ui/talent_icon/talent_icon_%s.png", icon))
        if shipData ~= nil then
            if unlock_condition > zstring.tonumber(shipData.Order) then
                --未解锁
                Image_dh_lock:setVisible(true)
                Image_dh_1:setVisible(true)
                Image_dh_2:setVisible(false)
            else
                --解锁了
                Image_dh_lock:setVisible(false)
                Image_dh_1:setVisible(false)
                Image_dh_2:setVisible(true)
            end
        else
            --未解锁
            Image_dh_lock:setVisible(true)
            Image_dh_1:setVisible(true)
            Image_dh_2:setVisible(false)
        end
    end

end

function SmRoleInformationControlsSix:init(params)
    --模板id
    self.ship_id = params[1]
    self.isMould = params[2]
    self.m_type = params[3] or nil
    self:onInit()
    return self
end

function SmRoleInformationControlsSix:onInit()
    local csbSmRoleInformationControlsSix = csb.createNode("packs/HeroStorage/sm_generals_information_6.csb")
    local root = csbSmRoleInformationControlsSix:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationControlsSix)
	if SmRoleInformationControlsSix.__size == nil then
        SmRoleInformationControlsSix.__size = root:getContentSize()
    end

    for i = 1 , 4 do 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_dh_icon_"..i), nil, 
        {
            terminal_name = "sm_role_information_controls_six_open_description", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            _index = i,
        }, 
        nil, 0)
    end

    self:onUpdateDraw()


end

function SmRoleInformationControlsSix:onExit()
    state_machine.remove("sm_role_information_controls_six_display")
    state_machine.remove("sm_role_information_controls_six_hide")
end