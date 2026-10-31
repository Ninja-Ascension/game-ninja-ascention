-- ----------------------------------------------------------------------------------------------------
-- 说明：斗魂详细信息
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabSoulDescription = class("SmRoleStrengthenTabSoulDescriptionClass", Window)

local sm_role_strengthen_tab_soul_description_open_terminal = {
    _name = "sm_role_strengthen_tab_soul_description_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSoulDescriptionClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabSoulDescription:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_soul_description_close_terminal = {
    _name = "sm_role_strengthen_tab_soul_description_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSoulDescriptionClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabSoulDescriptionClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_soul_description_open_terminal)
state_machine.add(sm_role_strengthen_tab_soul_description_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabSoulDescription:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0

    local function init_sm_role_strengthen_tab_soul_description_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_soul_description_display_terminal = {
            _name = "sm_role_strengthen_tab_soul_description_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSoulDescriptionWindow = fwin:find("SmRoleStrengthenTabSoulDescriptionClass")
                if SmRoleStrengthenTabSoulDescriptionWindow ~= nil then
                    SmRoleStrengthenTabSoulDescriptionWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_soul_description_hide_terminal = {
            _name = "sm_role_strengthen_tab_soul_description_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSoulDescriptionWindow = fwin:find("SmRoleStrengthenTabSoulDescriptionClass")
                if SmRoleStrengthenTabSoulDescriptionWindow ~= nil then
                    SmRoleStrengthenTabSoulDescriptionWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_soul_description_display_terminal)
        state_machine.add(sm_role_strengthen_tab_soul_description_hide_terminal)

        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_soul_description_terminal()
end

function SmRoleStrengthenTabSoulDescription:onUpdateDraw()
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
    local faction_id = zstring.split(dms.string(dms["ship_mould"], ship_id, ship_mould.faction_id),",")
    local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.unlock_condition)
    --找对应的天赋
    local talent_id = tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])
    --锁的背景
    local Image_dh_1 = ccui.Helper:seekWidgetByName(root,"Image_dh_1")
    --开的背景
    local Image_dh_2 = ccui.Helper:seekWidgetByName(root,"Image_dh_2")
    --锁的图案
    local Image_dh_lock = ccui.Helper:seekWidgetByName(root,"Image_dh_lock")
    --画斗魂图标
    local Panel_dh_icon = ccui.Helper:seekWidgetByName(root,"Panel_dh_icon")
    Panel_dh_icon:removeBackGroundImage()
    local icon = dms.string(dms["talent_mould"], talent_id, talent_mould.buff_add_beau)
    if tonumber(icon) < 10 then
        icon = "0"..icon
    end
    Panel_dh_icon:setBackGroundImage(string.format("images/ui/talent_icon/talent_icon_%s.png", icon))

    --名称
    local Text_dh_name = ccui.Helper:seekWidgetByName(root,"Text_dh_name")
    local name = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_name)
    local word_info = dms.element(dms["word_mould"], name)
    local skillName = word_info[3]
    Text_dh_name:setString(skillName)
    --等级
    local Text_dh_lv_n = ccui.Helper:seekWidgetByName(root,"Text_dh_lv_n")
    local Text_dh_lv = ccui.Helper:seekWidgetByName(root,"Text_dh_lv")
    local Text_lock = ccui.Helper:seekWidgetByName(root,"Text_lock")
    local lv = 0
    local Order = 0
    if shipData == nil then
        lv = 1
        Order = 0
    else
        -- 如果他人斗魂信息找不到 就去自己的数据里找
        if shipData.ship_fighting_spirit == nil then
            for i, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_template_id) == tonumber(ship_id) then
                    shipData = v
                    break
                end
            end
        end

        if shipData == nil then
            lv = 1
            Order = 0
        else
            local soul_data = zstring.split(shipData.ship_fighting_spirit,"|")
        
            lv =  tonumber(zstring.split(soul_data[self.m_index],",")[1])
            Order = zstring.tonumber(shipData.Order)+1
        end
    end
    Text_dh_lv_n:setString(lv)
    if unlock_condition > Order then
        --未解锁
        Image_dh_lock:setVisible(true)
        Image_dh_1:setVisible(true)
        Image_dh_2:setVisible(false)
        Text_dh_lv_n:setVisible(false)
        Text_dh_lv:setVisible(false)
        Text_lock:setVisible(true)
    else
        --解锁了
        Image_dh_lock:setVisible(false)
        Image_dh_1:setVisible(false)
        Image_dh_2:setVisible(true)
        Text_dh_lv_n:setVisible(true)
        Text_dh_lv:setVisible(true)
        Text_lock:setVisible(false)
    end

    --描述
    local Text_dh_info = ccui.Helper:seekWidgetByName(root,"Text_dh_info")
    local describe = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], describe)
    local describe_text = word_info[3]
    --画描述内容
    local attribute_content = {}
    local attribute_bonus_library = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.attribute_bonus_library)
    local attributes = dms.searchs(dms["ship_soul_addition_property_param"], ship_soul_addition_property_param.library_group, attribute_bonus_library)
    local attribute_bonus = nil
    for i, v in pairs(attributes) do
        if tonumber(v[3]) == lv then
            attribute_bonus = v
            break
        end
    end

    --战前加的属性
    local base_additional = attribute_bonus[4]
    if base_additional ~= "-1" then
        for i, v in pairs(zstring.split(attribute_bonus[4],"|")) do
            table.insert(attribute_content, zstring.split(v,",")[2])
        end
    end
    --战中加的属性
    local influence_judge_result = attribute_bonus[5]
    if influence_judge_result ~= "-1" then
        local content = zstring.split(attribute_bonus[5],"|")

        local index = 0
        for i, v in pairs(zstring.split(influence_judge_result,"|")) do
            index = index + 1
            local value = zstring.split(v, ",")
            table.insert(attribute_content, zstring.split(content[index],",")[2])
        end
    end
    for i,v in pairs(attribute_content) do
        describe_text = string.gsub(describe_text,"{"..i.."}",v)
    end
    
    local textWidth = Text_dh_info:getContentSize().width
    Text_dh_info:setString(describe_text)
    Text_dh_info:setUnifySizeEnabled(true) --使用归一化尺寸, 不使用自定义尺寸
    Text_dh_info:setTextAreaSize(cc.size(textWidth, 0))	
    Text_dh_info:ignoreContentAdaptWithSize(false) --不使用自定义尺寸

end

function SmRoleStrengthenTabSoulDescription:init(params)
    self.ship_id = params[1]
    self.m_index = tonumber(params[2])
    self.m_type = params[3] or nil
    self.isMould = params[4]
    self:onInit()
    return self
end

function SmRoleStrengthenTabSoulDescription:onInit()
    local csbSmRoleStrengthenTabSoulDescription = csb.createNode("packs/HeroStorage/sm_generals_information_6_window.csb")
    local root = csbSmRoleStrengthenTabSoulDescription:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabSoulDescription)
	
    self:onUpdateDraw()

    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_closed"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_soul_description_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_bg"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_soul_description_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)
	
end

function SmRoleStrengthenTabSoulDescription:onExit()
    state_machine.remove("sm_role_strengthen_tab_soul_description_display")
    state_machine.remove("sm_role_strengthen_tab_soul_description_hide")
end