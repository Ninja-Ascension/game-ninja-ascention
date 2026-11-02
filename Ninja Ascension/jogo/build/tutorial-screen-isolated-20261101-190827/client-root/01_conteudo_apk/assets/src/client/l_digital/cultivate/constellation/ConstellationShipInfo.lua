-- ------------------------------------------------------------------------------------------------------------
--  说明：星座数码兽信息
-- ------------------------------------------------------------------------------------------------------------
ConstellationShipInfo = class("ConstellationShipInfoClass", Window)

--打开界面
local constellation_ship_info_open_terminal = {
    _name = "constellation_ship_info_open",
    _init = function (terminal)  
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ConstellationShipInfoClass") == nil then
            fwin:open(ConstellationShipInfo:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
    local constellation_ship_info_window_close_terminal = {
        _name = "constellation_ship_info_window_close",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if fwin:find("ConstellationShipInfoClass") ~= nil then
                fwin:close(fwin:find("ConstellationShipInfoClass"))
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

state_machine.add(constellation_ship_info_open_terminal)
state_machine.add(constellation_ship_info_window_close_terminal)
state_machine.init()

function ConstellationShipInfo:ctor()
    self.super:ctor()
    local function constellation_ship_info_terminal()
        local constellation_ship_change_terminal = {
            _name = "constellation_ship_change",
            _init = function (terminal) 
                app.load("client.l_digital.cultivate.constellation.ConstellationShipActivation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("constellation_ship_activation_open", 0, {instance.constellation_mould_id, instance.index, instance.cell})
            end,
            _terminal = nil,
            _terminals = nil
        }

        local constellat_ship_info_update_terminal = {
            _name = "constellat_ship_info_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:initData()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(constellation_ship_change_terminal)
        state_machine.add(constellat_ship_info_update_terminal)
        state_machine.init()
    end
    
    constellation_ship_info_terminal()
end

function ConstellationShipInfo:onUpdateDraw()
    local root = self.roots[1]
    local ship_icon = ccui.Helper:seekWidgetByName(root,"Panel_xz_hero_head")
    local Panel_xz_hero_q_box = ccui.Helper:seekWidgetByName(root,"Panel_xz_hero_q_box")
    local ship_name = ccui.Helper:seekWidgetByName(root,"Text_xz_hero_name")
    local Text_xz_name = ccui.Helper:seekWidgetByName(root,"Text_xz_name")
    local Panel_xz_att_icon = ccui.Helper:seekWidgetByName(root,"Panel_xz_att_icon")
    local Panel_xz_att_text = ccui.Helper:seekWidgetByName(root,"Panel_xz_att_text")

    local Text_xz_gj_n = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n")
    local Text_xz_fy_n = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n_0")
    local Text_xz_sm_n = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n_0_0")

    local star_add_name = ccui.Helper:seekWidgetByName(root,"Text_11_0")
    local star_add_num = ccui.Helper:seekWidgetByName(root,"Text_11_0_0")
    local star_add_percent = ccui.Helper:seekWidgetByName(root,"Text_11_0_0_0")

    local quality_add_name = ccui.Helper:seekWidgetByName(root,"Text_11_0_2")
    local quality_add_num = ccui.Helper:seekWidgetByName(root,"Text_11_0_0_1")
    local quality_add_percent = ccui.Helper:seekWidgetByName(root,"Text_11_0_0_0_0")

    local constellation_add_name = ccui.Helper:seekWidgetByName(root,"Text_11_0_2_0")
    local constellation_add_num = ccui.Helper:seekWidgetByName(root,"Text_11_0_0_1_0")
    local constellation_add_percent = ccui.Helper:seekWidgetByName(root,"Text_11_0_0_0_0_0")

    local des1 = ccui.Helper:seekWidgetByName(root,"Text_11_0_1")
    local des2 = ccui.Helper:seekWidgetByName(root,"Text_11_0_1_0")
    local des3 = ccui.Helper:seekWidgetByName(root,"Text_11_0_1_0_0")

    local gj_add_percent = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n_1")
    local fy_add_percent = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n_0_1")
    local sm_add_percent = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n_0_0_1")

    local Image_16 = ccui.Helper:seekWidgetByName(root,"Image_16")
    Image_16:setAnchorPoint(0, 0.5)

    local Text_xz_jz_n = ccui.Helper:seekWidgetByName(root,"Text_xz_jz_n")

    ship_name:setString("")
    Text_xz_name:setString("")
    Text_xz_fy_n:setString("")
    Text_xz_gj_n:setString("")
    Text_xz_sm_n:setString("")

    star_add_name:setString("")
    star_add_num:setString("")
    star_add_percent:setString("")

    quality_add_name:setString("")
    quality_add_num:setString("")
    quality_add_percent:setString("")

    -- constellation_add_name:setString("")
    constellation_add_num:setString("")
    constellation_add_percent:setString("")

    Text_xz_jz_n:setString("")

    ship_icon:removeBackGroundImage()
    Panel_xz_att_icon:removeBackGroundImage()
    Panel_xz_att_text:removeBackGroundImage()
    Panel_xz_hero_q_box:removeBackGroundImage()

    local name_mould_id = dms.int(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_name_id)
    local type_id = dms.int(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_ship_type)
    local name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)

    --进化形象
    local evo_image = dms.string(dms["ship_mould"], self.ship_template_id, ship_mould.fitSkillTwo)
    local initial_ship = dms.string(dms["ship_mould"], self.ship_template_id, ship_mould.captain_name)
    local evo_info = zstring.split(evo_image, ",")
    local quality = dms.int(dms["constellation_group"], self.group_id, constellation_group.level_id)
    -- --进化模板id
    local evo_mould_id = evo_info[zstring.tonumber(initial_ship)]
    if self.ship then
        evo_mould_id = smGetSkinEvoIdChange(self.ship)
    end
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local hero_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    --名字等基本信息
    Text_xz_name:setString(name)
    ship_icon:setBackGroundImage(string.format("images/ui/pve_sn/props_%d.png", picIndex))
    Panel_xz_hero_q_box:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/txk_s_%d.png", quality))
    Panel_xz_att_text:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_t_%d.png", type_id))
    Panel_xz_att_icon:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_icon_%d.png", type_id))
    ship_name:setString(hero_name)

    local use_ships = _ED.constellation_info.uc
    local protect_nums = 0
    local all_have = _ED.constellation_info.hba[self.constellation_mould_id .. ""][tostring(tonumber(self.index) - 1)]
    local used_group = _ED.constellation_info.uc[self.constellation_mould_id .. ""][tostring(tonumber(self.index) - 1)]
    for k,v in pairs(all_have) do
        if v then
            local cost = dms.int(dms["constellation_group"], v, constellation_group.protect_num)
            
            protect_nums = protect_nums + cost
        end
    end
    local add_attribute = dms.string(dms["constellation_group"], used_group, constellation_group.add_additional)
    local additionals = zstring.splits(add_attribute, "|", ",")

    Text_xz_gj_n:setString(additionals[1][2])
    Text_xz_fy_n:setString(additionals[2][2])
    Text_xz_sm_n:setString(additionals[3][2])

    Text_xz_jz_n:setString(protect_nums)

    --额外加成
    local add_percent_star = 0
    local add_percent_quality = 0
    local percent_add_constellation = 0
    if not self.ship then
        star_add_name:setString(string.format(tipStringInfo_constellation_tips[3], hero_name))
        Image_16:setVisible(false)
        star_add_num:setString("")
        star_add_percent:setString("")

        quality_add_name:setString(string.format(tipStringInfo_constellation_tips[3], hero_name))
        quality_add_num:setString("")
        quality_add_percent:setString("")

        local temp_str = {star_add_name, star_add_num, des1, star_add_percent}
        star_add_num:setPositionX(self:setStrPos(temp_str, 2))
        des1:setPositionX(self:setStrPos(temp_str, 3))
        star_add_percent:setPositionX(self:setStrPos(temp_str, 4))
    else
        local star_add_config = zstring.splits(dms.string(dms["play_config"], 81, pirates_config.param), "|", ",")
        local star_num = tonumber(self.ship.StarRating)
        add_percent_star = star_add_config[star_num][2]

        star_add_name:setString(string.format(tipStringInfo_constellation_tips[4], hero_name))
        star_add_num:setString(star_num)
        Image_16:setVisible(true)
        star_add_percent:setString(add_percent_star .. "%")

        local temp_str = {star_add_name, star_add_num, Image_16, des1, star_add_percent}
        star_add_num:setPositionX(self:setStrPos(temp_str, 2))
        Image_16:setPositionX(self:setStrPos(temp_str, 3))
        des1:setPositionX(self:setStrPos(temp_str, 4))
        star_add_percent:setPositionX(self:setStrPos(temp_str, 5))

        local quality_add_config = zstring.splits(dms.string(dms["play_config"], 82, pirates_config.param), "|", ",")
        local quality = tonumber(self.ship.Order)
        add_percent_quality = quality_add_config[quality+1][2]
        quality_add_name:setString(string.format(tipStringInfo_constellation_tips[4], hero_name))
        local color_index = shipOrEquipSetColour(quality)
        local str_quality = tonumber(getShipNameOrder(tonumber(self.ship.Order))) == 0 and _ship_types_by_color[color_index] or _ship_types_by_color[color_index] .. " +"..getShipNameOrder(tonumber(self.ship.Order))
        quality_add_num:setString(str_quality)
        quality_add_num:setColor(cc.c3b(tipStringInfo_quality_color_Type[color_index][1],tipStringInfo_quality_color_Type[color_index][2],tipStringInfo_quality_color_Type[color_index][3]))
        quality_add_percent:setString(add_percent_quality .. "%")
    end

    --设置坐标

    local temp_str_q = {quality_add_name, quality_add_num, des2, quality_add_percent}
    quality_add_num:setPositionX(self:setStrPos(temp_str_q, 2))
    des2:setPositionX(self:setStrPos(temp_str_q, 3))
    quality_add_percent:setPositionX(self:setStrPos(temp_str_q, 4))

    local constellation_add_config = zstring.splits(dms.string(dms["play_config"], 83, pirates_config.param), "|", ",")
    local count = 0
    for i,v in pairs(_ED.constellation_info.hba[self.constellation_mould_id][tostring(tonumber(self.index) - 1)]) do
        if v then
            count = count + 1
        end
    end
    -- debug.print_r(constellation_add_config)
    percent_add_constellation = constellation_add_config[count][2]
    constellation_add_num:setString(count)
    constellation_add_percent:setString(percent_add_constellation .. "%")

    local temp_str_c = {constellation_add_name, constellation_add_num, des3, constellation_add_percent}
    constellation_add_num:setPositionX(self:setStrPos(temp_str_c, 2))
    des3:setPositionX(self:setStrPos(temp_str_c, 3))
    constellation_add_percent:setPositionX(self:setStrPos(temp_str_c, 4))


    -- 攻击、防御、生命的属性加成       
    local add_percent_all = tonumber(add_percent_star) + tonumber(add_percent_quality) + tonumber(percent_add_constellation)
    if add_percent_all > 0 then
        gj_add_percent:setString("+" .. add_percent_all .. "%")
        fy_add_percent:setString("+" .. add_percent_all .. "%")
        sm_add_percent:setString("+" .. add_percent_all .. "%")
        local gj_temp = {Text_xz_gj_n, gj_add_percent}
        local fy_temp = {Text_xz_fy_n, fy_add_percent}
        local sm_temp = {Text_xz_sm_n, sm_add_percent}

        gj_add_percent:setPositionX(self:setStrPos(gj_temp, 2))
        fy_add_percent:setPositionX(self:setStrPos(fy_temp, 2))
        sm_add_percent:setPositionX(self:setStrPos(sm_temp, 2))
    else
        gj_add_percent:setString("")
        fy_add_percent:setString("")
        sm_add_percent:setString("")
    end
end

function ConstellationShipInfo:setStrPos( texts, index )
    local posx = texts[1]:getPositionX()
    for k,v in ipairs(texts) do
        local txt_width = 0
        if k < index then
            txt_width = v:getContentSize().width
            posx = posx + txt_width + 5
        end
    end
    return posx
end

function ConstellationShipInfo:onInit()
    local csbItem = csb.createNode("cultivate/constellation_star_infor.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.action = csb.createTimeline("cultivate/constellation_star_infor.csb")
    csbItem:runAction(self.action)
    self.action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "constellation_ship_info_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "constellation_ship_change", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function ConstellationShipInfo:initData()
     for i,ship in pairs(_ED.user_ship) do
        if tonumber(ship.ship_template_id) == tonumber(self.ship_template_id )then
            self.ship = ship
        end
    end

    local use_ships = _ED.constellation_info.uc
    local is_use = false
    self.group_id = 0
    if not use_ships or not use_ships[self.constellation_mould_id] then
        is_use = false
    else
        for i,v in pairs(use_ships[self.constellation_mould_id]) do
            if v and tonumber(self.index) == tonumber(i) + 1 then
                is_use = true
                self.group_id = v
            end
        end
    end
end

function ConstellationShipInfo:init(params)
    self.ship_template_id = params[1]
    self.constellation_mould_id = params[2]
    self.index = params[3]
    self.cell = params[4]
    self.roots = {}

    self:initData()
    self:onInit()
    return self
end

function ConstellationShipInfo:onExit()
    state_machine.remove("constellation_ship_change")
    state_machine.remove("constellat_ship_info_update")
end