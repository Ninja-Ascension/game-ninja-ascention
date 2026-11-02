-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面控件1
-------------------------------------------------------------------------------------------------------
SmRoleInformationControlsOne = class("SmRoleInformationControlsOneClass", Window)
SmRoleInformationControlsOne.__size = nil

local sm_role_information_controls_one_open_terminal = {
    _name = "sm_role_information_controls_one_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmRoleInformationControlsOne:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_controls_one_close_terminal = {
    _name = "sm_role_information_controls_one_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationControlsOneClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationControlsOneClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_controls_one_open_terminal)
state_machine.add(sm_role_information_controls_one_close_terminal)
state_machine.init()
    
function SmRoleInformationControlsOne:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    self.zOrder = nil               -- 当前界面层级
    app.load("client.packs.hero.GeneralsEvoChainWindow")
    local function init_sm_role_information_controls_one_terminal()
        -- 显示界面
        local sm_role_information_controls_one_display_terminal = {
            _name = "sm_role_information_controls_one_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsOneWindow = fwin:find("SmRoleInformationControlsOneClass")
                if SmRoleInformationControlsOneWindow ~= nil then
                    SmRoleInformationControlsOneWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_controls_one_hide_terminal = {
            _name = "sm_role_information_controls_one_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsOneWindow = fwin:find("SmRoleInformationControlsOneClass")
                if SmRoleInformationControlsOneWindow ~= nil then
                    SmRoleInformationControlsOneWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变名称
        local sm_role_information_controls_one_set_button_name_terminal = {
            _name = "sm_role_information_controls_one_set_button_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(params) == 0 then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_ckxq"):setVisible(true)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_gbxq"):setVisible(false)
                else
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_ckxq"):setVisible(false)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_gbxq"):setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变名称
        local sm_role_information_controls_one_open_evo_terminal = {
            _name = "sm_role_information_controls_one_open_evo",
            _init = function (terminal) 
                app.load("client.packs.hero.GeneralsEvoChainWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(instance.m_type) == -1 then
                    if instance.zOrder ~= nil then
                        local window = GeneralsEvoChainWindow:new()
                        window:init({_ED.other_user_ship.ship_template_id})
                        fwin:open(window, instance.zOrder)
                    else
                        state_machine.excute("generals_evo_chain_window_open",0,{_ED.other_user_ship.ship_template_id})
                    end
                else
                    if instance.shipData ~= nil then
                        state_machine.excute("generals_evo_chain_window_open",0,{instance.shipData})
                    else
                        state_machine.excute("generals_evo_chain_window_open",0,{instance.ship_id})
                    end
                end     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(sm_role_information_controls_one_display_terminal)
        state_machine.add(sm_role_information_controls_one_hide_terminal)
        state_machine.add(sm_role_information_controls_one_set_button_name_terminal)
        state_machine.add(sm_role_information_controls_one_open_evo_terminal)
        state_machine.init()
    end
    init_sm_role_information_controls_one_terminal()
end

function SmRoleInformationControlsOne:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.shipData = nil
    local ship_id = nil
    local currShip = nil
    if zstring.tonumber(self.m_type) == -1 then
        self.shipData = self.ship_id
        ship_id = self.shipData.ship_template_id
        currShip = self.shipData
    else
        ship_id = self.ship_id
        if self.isMould == true then
            ship_id = self.ship_id
        else
            for i, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_template_id) == tonumber(self.ship_id) then
                    self.shipData = v
                    ship_id = self.shipData.ship_template_id
                    break
                end
            end
        end
    end
    if self.shipData == nil or zstring.tonumber(self.m_type) == -1 then
    else
        currShip = getShipByTalent(self.shipData)
    end
    --战斗力
    local Text_fighting_0 = ccui.Helper:seekWidgetByName(root, "Text_fighting_0")

    --等级
    local Text_dengji_0 = ccui.Helper:seekWidgetByName(root, "Text_dengji_0")
    if self.shipData == nil then
        Text_dengji_0:setString("1")
    else
        Text_dengji_0:setString(self.shipData.ship_grade)
    end
    --资质
    local Text_zizhi_0 = ccui.Helper:seekWidgetByName(root, "Text_zizhi_0")
    local ability = dms.int(dms["ship_mould"], ship_id, ship_mould.ability)
    -- Text_zizhi_0:setString(ability)
	Text_zizhi_0:setString(getAbilityFromBaMen(self.shipData,ability))
    
    --攻击
    local Text_gongji_0 = ccui.Helper:seekWidgetByName(root, "Text_gongji_0")
    if self.shipData == nil then
        local initial_courage = dms.int(dms["ship_mould"], ship_id, ship_mould.initial_courage)
        Text_gongji_0:setString(initial_courage)
    else
        Text_gongji_0:setString(currShip.ship_courage)
    end
    --防御
    local Text_wufang_0 = ccui.Helper:seekWidgetByName(root, "Text_wufang_0")
    if self.shipData == nil then
        local initial_intellect = dms.int(dms["ship_mould"], ship_id, ship_mould.initial_intellect)
        Text_wufang_0:setString(initial_intellect)
    else
        Text_wufang_0:setString(currShip.ship_intellect)
    end

    --生命
    local Text_shengming_0 = ccui.Helper:seekWidgetByName(root, "Text_shengming_0")
    if self.shipData == nil then
        local initial_power = dms.int(dms["ship_mould"], ship_id, ship_mould.initial_power)
        Text_shengming_0:setString(initial_power)
    else
        Text_shengming_0:setString(currShip.ship_health)
    end

    if self.shipData == nil then
        --测试的
        -- local fight = (dms.int(dms["ship_mould"], ship_id, ship_mould.initial_power) + dms.int(dms["ship_mould"], ship_id, ship_mould.initial_courage)+ dms.int(dms["ship_mould"], ship_id, ship_mould.initial_intellect))/100
        local ship = {}
        ship.ship_template_id = ship_id
        ship.ship_base_courage = dms.int(dms["ship_mould"], ship_id, ship_mould.initial_courage)
        ship.ship_base_intellect = dms.int(dms["ship_mould"], ship_id, ship_mould.initial_intellect)
        ship.ship_base_health = dms.int(dms["ship_mould"], ship_id, ship_mould.initial_power)

        local skill_level = ""
        local star_count = dms.int(dms["ship_mould"], ship_id, ship_mould.ship_star)
        local lock_info = zstring.split(dms.string(dms["ship_config"], 2, ship_config.param), ",")
        for k, v in pairs(lock_info) do
            if star_count >= tonumber(v) then
                skill_level = skill_level.."1"
            else
                skill_level = skill_level.."0"
            end

            if k ~= #lock_info then
                skill_level = skill_level..","
            end
        end
        ship.skillLevel = skill_level
        ship.StarRating = star_count
        ship_info = getShipByTalent(ship)
        Text_fighting_0:setString(math.ceil(ship_info.hero_fight))
    else
        Text_fighting_0:setString(currShip.hero_fight)
    end
end

function SmRoleInformationControlsOne:init(params)
    --模板id
    self.ship_id = params[1]
    self.isMould = params[2]
    self.m_type = params[3] or nil
    self:onInit()
    return self
end

function SmRoleInformationControlsOne:onInit()
    local csbSmRoleInformationControlsOne = csb.createNode("packs/HeroStorage/sm_generals_information_1.csb")
    local root = csbSmRoleInformationControlsOne:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationControlsOne)

    if SmRoleInformationControlsOne.__size == nil then
        SmRoleInformationControlsOne.__size = root:getContentSize()
    end

    --查看详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ckxq"), nil, 
    {
        terminal_name = "sm_role_information_action", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    --关闭详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gbxq"), nil, 
    {
        terminal_name = "sm_role_information_action", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    --进化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_evo"), nil, 
    {
        terminal_name = "sm_role_information_controls_one_open_evo", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    

    self:onUpdateDraw()
end

function SmRoleInformationControlsOne:onExit()
    state_machine.remove("sm_role_information_controls_one_display")
    state_machine.remove("sm_role_information_controls_one_hide")
end