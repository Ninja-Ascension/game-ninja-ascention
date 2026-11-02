--------------------------------------------------------------------------------------------------------------
--  说明：将领技能升级
--------------------------------------------------------------------------------------------------------------
LeaderSkillLvUp = class("LeaderSkillLvUpClass", Window)

--打开界面
local leader_skill_lv_up_window_open_terminal = {
    _name = "leader_skill_lv_up_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LeaderSkillLvUpClass") == nil then
            fwin:open(LeaderSkillLvUp:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local leader_skill_lv_up_window_close_terminal = {
    _name = "leader_skill_lv_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderSkillLvUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(leader_skill_lv_up_window_open_terminal)
state_machine.add(leader_skill_lv_up_window_close_terminal)
state_machine.init()

function LeaderSkillLvUp:ctor()
    self.super:ctor()
    self.roots = {}

    self._ship_info = nil
    self._talent_id = nil
    self._index = nil
    self._max_level = nil

    self._need_prop_name = nil          -- 缺少的升级道具

    local function init_leader_skill_lv_up_terminal()
        local leader_skill_lv_up_update_draw_terminal = {
            _name = "leader_skill_lv_up_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 升级
        local leader_skill_lv_up_level_up_terminal = {
            _name = "leader_skill_lv_up_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._need_prop_name ~= nil then
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[83], instance._need_prop_name))
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        TipDlg.drawTextDailog(red_alert_time_str[75])
                        state_machine.excute("leader_info_update", 0, nil)
                    end
                end
                protocol_command.ship_talent_update.param_list = instance._ship_info.ship_id.."\r\n"..(instance._index - 1)
                NetworkManager:register(protocol_command.ship_talent_update.code, nil, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_skill_lv_up_update_terminal)
        state_machine.add(leader_skill_lv_up_level_up_terminal)
        state_machine.init()
    end
    init_leader_skill_lv_up_terminal()
end

function LeaderSkillLvUp:updateDraw( ... )
    local root = self.roots[1]

    -- 技能信息
    local ship_info = _ED.user_ship[""..self._ship_info.ship_id]
    local current_level = tonumber(ship_info.talents[self._index].is_activited)

    local talent_data = dms.element(dms["talent_mould"], self._talent_id)
    local talent_pic = dms.atoi(talent_data, talent_mould.talent_pic)
    local talent_name = dms.atos(talent_data, talent_mould.talent_name)
    local talent_des = dms.atos(talent_data, talent_mould.talent_describe)
    local skill_growing = dms.atof(talent_data, talent_mould.skill_growing)
    local add_attr_value = ""..(current_level * skill_growing)
    local next_attr_value = ""..((current_level + 1) * skill_growing)
    if self._talent_id ~= 225 
        and self._talent_id ~= 226 then
        add_attr_value = add_attr_value.."%"
        next_attr_value = next_attr_value.."%"
    end

    -- 当前技能描述
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon")
    local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_name")
    local Text_skille_effice_infor = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_infor")
    Panel_skille_effice_icon:removeBackGroundImage()
    Panel_skille_effice_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, talent_pic))
    Text_skille_effice_name:setString(talent_name .. " ".. string.format(red_alert_time_str[60], current_level, self._max_level))
    Text_skille_effice_infor:setString(string.format(talent_des, add_attr_value))

    local Text_lvmax = ccui.Helper:seekWidgetByName(root, "Text_lvmax")
    local Text_consume = ccui.Helper:seekWidgetByName(root, "Text_consume")
    local Button_leader_skill_lv_up = ccui.Helper:seekWidgetByName(root, "Button_leader_skill_lv_up")
    local Text_skille_effice_infor_0 = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_infor_0")
    Text_lvmax:setVisible(false)
    Text_consume:setVisible(true)
    Button_leader_skill_lv_up:setVisible(true)
    Text_skille_effice_infor_0:removeAllChildren(true)
    Text_skille_effice_infor_0:setVisible(true)

    for i = 1, 7 do
        local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
        Panel_props_icon:removeAllChildren(true)
        Panel_props_icon:setVisible(false)
    end

    if current_level < self._max_level then
        -- 下一级效果
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(red_alert_time_str[73], add_attr_value), "fonts/simhei.ttf",21)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, string.format(red_alert_time_str[74], next_attr_value), "fonts/simhei.ttf",21)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_skille_effice_infor_0:getContentSize().width/2,Text_skille_effice_infor_0:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_skille_effice_infor_0:getContentSize().width,21))
        Text_skille_effice_infor_0:addChild(_richText)

        -- 升级消耗
        local prop_ids_info = zstring.split(dms.atos(talent_data, talent_mould.upgrade_require), ",")
        local prop_count_info = zstring.split(dms.string(dms["talent_level"], current_level, talent_level.need_count), ",")

        local result_prop = {}
        for k, v in pairs(prop_count_info) do
            if tonumber(v) ~= 0 then
                local info = {}
                info.prop_id = tonumber(prop_ids_info[k])
                info.prop_max_count = tonumber(v)
                local prop_count = 0
                if fundPropWidthId(info.prop_id) ~= nil then 
                    local token = fundPropWidthId(info.prop_id)
                    prop_count = zstring.tonumber(token.prop_number)
                end
                info.prop_count = prop_count
                table.insert(result_prop, info)

                if info.prop_count < info.prop_max_count then
                    if self._need_prop_name == nil then
                        self._need_prop_name = dms.string(dms["prop_mould"], info.prop_id, prop_mould.prop_name)
                    end
                end
            end
        end

        local need_prop_num = #result_prop      -- 消耗道具种类数量

        if need_prop_num == 3 then
            for i = 1, 3 do
                local prop_data = result_prop[i]
                local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
                local cell = state_machine.excute("equipment_reform_props_cell_create", 0, {prop_data.prop_id, prop_data.prop_count, prop_data.prop_max_count})
                Panel_props_icon:addChild(cell)
                Panel_props_icon:setVisible(true)
            end
        else
            for i = 4, 7 do
                local prop_data = result_prop[i - 3]
                local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
                local cell = state_machine.excute("equipment_reform_props_cell_create", 0, {prop_data.prop_id, prop_data.prop_count, prop_data.prop_max_count})
                Panel_props_icon:addChild(cell)
                Panel_props_icon:setVisible(true)
            end
        end
    else
        Text_lvmax:setVisible(true)
        Text_skille_effice_infor_0:setVisible(false)
        Text_consume:setVisible(false)
        Button_leader_skill_lv_up:setVisible(false)
    end

end


function LeaderSkillLvUp:onInit()
    local csbItem = csb.createNode(config_csb.leader.leader_skill_lv_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor_close"), nil, 
    {
        terminal_name = "leader_skill_lv_up_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "leader_skill_lv_up_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_skill_lv_up"), nil, 
    {
        terminal_name = "leader_skill_lv_up_level_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    self:updateDraw()
end

function LeaderSkillLvUp:onEnterTransitionFinish()

end

function LeaderSkillLvUp:init(params)
    self._ship_info = params[1]
    self._talent_id = params[2]
    self._index = params[3]
    -- self._current_level = params[3]
    self._max_level = params[4]
    self:onInit()
    return self
end

function LeaderSkillLvUp:onExit()
    state_machine.remove("leader_skill_lv_up_update_draw")
    state_machine.remove("leader_skill_lv_up_level_up")
end