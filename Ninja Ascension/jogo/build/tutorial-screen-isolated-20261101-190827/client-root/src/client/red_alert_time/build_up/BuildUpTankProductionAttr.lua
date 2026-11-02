--------------------------------------------------------------------------------------------------------------
--  坦克生产属性页
--------------------------------------------------------------------------------------------------------------
BuildUpTankProductionAttr = class("BuildUpTankProductionAttrClass", Window)

local build_up_tank_production_attr_window_open_terminal = {
    _name = "build_up_tank_production_attr_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpTankProductionAttr:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_production_attr_window_open_terminal)
state_machine.init()

function BuildUpTankProductionAttr:ctor()
    self.super:ctor()
    self.roots = {}
    
    --var 
    self._can_production = false            
    self._tank_info = nil
    self._tank_id = nil

    self._list_view = nil

    -- Initialize build_up_tank_production_attr state machine.
    local function init_build_up_tank_production_attr_terminal()
        
    end
    
    -- call func build_up_tank_production_attr create state machine.
    init_build_up_tank_production_attr_terminal()

end

function BuildUpTankProductionAttr:updateDraw()
    local root = self.roots[1]
    local ListView_attribute = ccui.Helper:seekWidgetByName(root, "ListView_attribute")
    self._list_view = ListView_attribute
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    self:addBaseInfo()
    if __lua_project_id == __lua_project_pacific_rim then
        -- 不显示技能
    else
        self:addSkillInfo()
    end
    self:addAttackInfo()
    self:addAttrInfo()

    self._list_view:requestRefreshView()
end

-- 添加兵种基本信息
function BuildUpTankProductionAttr:addBaseInfo()
    local csbItem = csb.createNode(config_csb.cells.build_up.build_up_tank_production_tab_cell_1)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)

    local Text_arms_n = ccui.Helper:seekWidgetByName(root, "Text_arms_n")                   -- 兵种
    local Text_attack_range_n = ccui.Helper:seekWidgetByName(root, "Text_attack_range_n")   -- 攻击范围

    for i=1,3 do
        local Text_attribute_infor = ccui.Helper:seekWidgetByName(root, "Text_attribute_infor_"..i)
        Text_attribute_infor:setString("")
    end

    local tank_type = dms.int(dms["ship_mould"], self._tank_id, ship_mould.camp_preference)
    local range = dms.int(dms["ship_mould"], self._tank_id, ship_mould.sign_msg)
    local capacity = dms.int(dms["ship_mould"], self._tank_id, ship_mould.capacity)
    local talent_ids = zstring.split(dms.string(dms["ship_mould"], self._tank_id, ship_mould.talent_id), "|")

    if capacity == 1 then
        Text_arms_n:setString(tipStringInfo_tank_type_info[tank_type]..red_alert_time_str[259])
    else
        Text_arms_n:setString(tipStringInfo_tank_type_info[tank_type])
    end
    if __lua_project_id == __lua_project_pacific_rim then
        Text_arms_n:setString(Text_arms_n:getString().."/"..tipStringInfo_attack_range_info[range])
    end
    Text_attack_range_n:setString(tipStringInfo_attack_range_info[range])

    local telent_info = ""
    for k, info in pairs(talent_ids) do
        local temp_telent = zstring.split(info, ",")
        local telent_type = tonumber(temp_telent[1])
        local telent_id = tonumber(temp_telent[3])
        if telent_type == 0 then
            local Text_attribute_infor = ccui.Helper:seekWidgetByName(root, "Text_attribute_infor_"..k)                   -- 技能
            local talent_name = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_name)
            local telent_des = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_describe)
            Text_attribute_infor:setString(talent_name..": "..telent_des)
        end
    end
    
end

-- 添加兵种技能信息
function BuildUpTankProductionAttr:addSkillInfo()
    local talent_ids = zstring.split(dms.string(dms["ship_mould"], self._tank_id, ship_mould.talent_id), "|")   

    for k, info in pairs(talent_ids) do
        local temp_telent = zstring.split(info, ",")
        local telent_type = tonumber(temp_telent[1])
        local telent_id = tonumber(temp_telent[3])

        if telent_type == 1 then
            local csbItem = csb.createNode(config_csb.cells.build_up.build_up_tank_production_tab_cell_4)
            local root = csbItem:getChildByName("root")
            root:removeFromParent(false)
            self._list_view:addChild(root)

            local telent_pic = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_pic)
            local telent_name = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_name)
            local telent_des = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_describe)

            local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon")
            local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_name")
            Text_skille_effice_name:removeAllChildren(true)
            local Text_skille_effice_infor_n = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_infor_n")
            Panel_skille_effice_icon:removeBackGroundImage()
            Panel_skille_effice_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, telent_pic))

            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, telent_name, "fonts/simhei.ttf",19)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ":"..telent_des, "fonts/simhei.ttf",19)
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_skille_effice_name:getContentSize().width/2,Text_skille_effice_name:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_skille_effice_name:getContentSize().width,19))
            Text_skille_effice_name:addChild(_richText)
        end
    end
end

-- 添加兵种血量，攻击，载重
function BuildUpTankProductionAttr:addAttackInfo()
    local csbItem = csb.createNode(config_csb.cells.build_up.build_up_tank_production_tab_cell_2)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)

    local Text_output_n = ccui.Helper:seekWidgetByName(root, "Text_output_n")           -- 血量
    local Text_attack_n = ccui.Helper:seekWidgetByName(root, "Text_attack_n")           -- 攻击
    local Text_load_n = ccui.Helper:seekWidgetByName(root, "Text_load_n")               -- 载重
    local Text_attack_stye_n = ccui.Helper:seekWidgetByName(root, "Text_attack_stye_n")               -- 攻击形式

    -- 兵种基础属性值
    local tank_data = dms.element(dms["ship_mould"], self._tank_id)
    local output = dms.atoi(tank_data, ship_mould.initial_power)
    local attack = dms.atoi(tank_data, ship_mould.initial_courage)
    local load = dms.atos(tank_data, ship_mould.ability)
    local range = dms.atoi(tank_data, ship_mould.sign_msg)

    if self._ship == nil then
        Text_output_n:setString(output)
        Text_attack_n:setString(attack)
        Text_load_n:setString(load)
    else
        -- 加成值
        local add_output = tonumber(self._ship.ship_health) - output
        local add_attack = tonumber(self._ship.ship_courage) - attack
        local add_load = tonumber(self._ship.attack_speed) - load

        self:setAttrString(Text_output_n, output, add_output, "")
        self:setAttrString(Text_attack_n, attack, add_attack, "")
        self:setAttrString(Text_load_n, load, add_load, "")
    end

    if Text_attack_stye_n ~= nil then
        Text_attack_stye_n:setString(attribute[2]..tipStringInfo_attack_range_info[range])
    end
end

function BuildUpTankProductionAttr:setAttrString(text, attr, add_attr, add_string)
    text:removeAllChildren(true)
    text:setString("")
    if add_attr > 0 then
        self:setTwoColorString(text, attr..add_string, color_Type[1], " +"..string.format("%.1f" , add_attr)..add_string, color_Type[3])
    else
        text:setString(attr..add_string)
    end
end

function BuildUpTankProductionAttr:setTwoColorString(text, string1, color_type1, string2, color_type2)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_type1[1],color_type1[2],color_type1[3]),255, string1, "fonts/simhei.ttf",18)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_type2[1],color_type2[2],color_type2[3]),255, string2, "fonts/simhei.ttf",18)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(text:getContentSize().width/2,text:getContentSize().height/2))
    _richText:setContentSize(cc.size(text:getContentSize().width,18))
    text:addChild(_richText)
end


-- 添加兵种属性
function BuildUpTankProductionAttr:addAttrInfo()
    local csbItem = csb.createNode(config_csb.cells.build_up.build_up_tank_production_tab_cell_3)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)

    local Text_crit_n = ccui.Helper:seekWidgetByName(root, "Text_crit_n")                       -- 暴击
    local Text_pierce_through_n = ccui.Helper:seekWidgetByName(root, "Text_pierce_through_n")   -- 穿透
    local Text_uprising_n = ccui.Helper:seekWidgetByName(root, "Text_uprising_n")               -- 抗暴
    local Text_protect_n = ccui.Helper:seekWidgetByName(root, "Text_protect_n")                 -- 防护
    local Text_hit_n = ccui.Helper:seekWidgetByName(root, "Text_hit_n")                         -- 命中
    local Text_dodge_n = ccui.Helper:seekWidgetByName(root, "Text_dodge_n")                     -- 闪避

    -- 兵种基础属性值
    local tank_data = dms.element(dms["ship_mould"], self._tank_id)
    local crit = dms.atoi(tank_data, ship_mould.initial_critical)
    local pierce_through = dms.atoi(tank_data, ship_mould.initial_retain_break)
    local uprising = dms.atos(tank_data, ship_mould.initial_critical_resist)
    local protect = dms.atoi(tank_data, ship_mould.initial_retain)
    local hit = dms.atoi(tank_data, ship_mould.initial_accuracy)
    local dodge = dms.atos(tank_data, ship_mould.initial_jink)

    if self._ship == nil then
        Text_crit_n:setString(""..crit.."%")
        Text_pierce_through_n:setString(pierce_through)
        Text_uprising_n:setString(""..uprising.."%")
        Text_protect_n:setString(protect)
        Text_hit_n:setString(""..hit.."%")
        Text_dodge_n:setString(""..dodge.."%")
    else
        local add_crit = tonumber(self._ship.crit) - crit
        local add_pierce_through = tonumber(self._ship.wreck) - pierce_through
        local add_uprising = tonumber(self._ship.toughness) - uprising
        local add_protect = tonumber(self._ship.block) - protect
        local add_hit = tonumber(self._ship.hit) - hit
        local add_dodge = tonumber(self._ship.dodge) - dodge

        self:setAttrString(Text_crit_n, crit, add_crit, "%")
        self:setAttrString(Text_pierce_through_n, pierce_through, add_pierce_through, "")
        self:setAttrString(Text_uprising_n, uprising, add_uprising, "%")
        self:setAttrString(Text_protect_n, protect, add_protect, "")
        self:setAttrString(Text_hit_n, hit, add_hit, "%")
        self:setAttrString(Text_dodge_n, dodge, add_dodge, "%")
    end
end

function BuildUpTankProductionAttr:onInit()
    local csbItem = nil
    if self._can_production == true then
        csbItem = csb.createNode(config_csb.build_up.build_up_tank_production_tab_1)
    else
        csbItem = csb.createNode(config_csb.build_up.build_up_tank_production_tab_3)
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    self:updateDraw()
end

function BuildUpTankProductionAttr:onEnterTransitionFinish()
    
end

function BuildUpTankProductionAttr:init(params)
    local rootWindow = params[1]
    self._can_production = params[2]
    self._tank_info = params[3]
    self._ship = params[4]
    self._rootWindows = rootWindow

    self._tank_id = self._tank_info.tank_id
    self:onInit()
    return self
end

function BuildUpTankProductionAttr:onExit()
end