-- --------------------------------------------------------------------------------------------------
-- 说明：科研目标cell
-- -----------------------------------------------------------------------------------------------------
BuildUpScientificCell = class("BuildUpScientificCellClass", Window)
BuildUpScientificCellSize = BuildUpScientificCellSize or nil

local build_up_scientific_cell_create_terminal = {
    _name = "build_up_scientific_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BuildUpScientificCell:new()
        local index = params[1]
        local base_barracks_info = params[2]
        local barracks_info = params[3]
        local can_update = params[4]
        local lave_info_table = params[5]
        local m_times = params[6]
        cell:init(index, base_barracks_info, barracks_info, can_update,lave_info_table,m_times)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_scientific_cell_create_terminal)
state_machine.init()

function BuildUpScientificCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._base_barracks_info = nil
    self._barracks_info = nil
    self._can_update = false
    self._lave_info_table = {}
    self.m_times = 0
    app.load("client.red_alert_time.cells.props.props_use_cell")
    local function init_build_up_scientific_cell_terminal()
        -- 查看详情
        local build_up_scientific_cell_click_terminal = {
            _name = "build_up_scientific_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if __lua_project_id == __lua_project_pacific_rim then
                    state_machine.excute("build_up_scientific_up_open", 0, {cell._barracks_info, cell._base_barracks_info})
                else
                    state_machine.excute("build_up_scientific_info_open", 0, {cell._barracks_info, cell._base_barracks_info})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 科技升级
        local build_up_scientific_cell_update_terminal = {
            _name = "build_up_scientific_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._can_update == false then
                    if #cell._lave_info_table <= 0
                        or tonumber(_ED.user_info.credit_level) < cell._barracks_info.barrack_level + 1
                        or tonumber(_ED.home_build["3"].level) < cell._barracks_info.barrack_level + 1 then
                        state_machine.excute("build_up_scientific_cell_click", 0, {_datas = { cell = cell}})
                        return
                    else
                        local need_gold = getUpgradeCostGoldNum(cell._lave_info_table)
                        local tip = ConfirmTip:new()
                        tip:init(cell, cell.sureGoldUpgrade, string.format(red_alert_all_str[296],need_gold))
                        fwin:open(tip,fwin._windows) 
                        return
                    end
                end
                if cell:checkMaxScientificCount() == false then 
                    TipDlg.drawTextDailog(red_alert_all_str[306])
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("home_map_update_prodcution_state", 0, {3})
                        state_machine.excute("build_up_scientific_to_update_draw", 0, "")
                        TipDlg.drawTextDailog(red_alert_all_str[282])
                        checkPlayEffect(33)
                    end
                end     
                protocol_command.barracks_teach_update.param_list = ""..cell._base_barracks_info.id
                NetworkManager:register(protocol_command.barracks_teach_update.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_scientific_cell_click_terminal)    
        state_machine.add(build_up_scientific_cell_update_terminal)     
        state_machine.init()
    end
    init_build_up_scientific_cell_terminal()           
end

function BuildUpScientificCell:checkMaxScientificCount()
    local max_count = dms.int(dms["base_consume"], 79, base_consume.vip_0_value + tonumber(_ED.vip_grade)) -- 最大生产队列长度
    local current_count = 0
    if _ED.barracks_info ~= nil then
        for k, v in pairs(_ED.barracks_info) do
            if tonumber(v.barrack_state) ~= 0 then
                current_count = current_count + 1
            end
        end
    end

    if current_count < max_count then
        return true
    else
        return false
    end
end

-- 金币升级
function BuildUpScientificCell:sureGoldUpgrade(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("home_map_update_prodcution_state", 0, {3})
            state_machine.excute("build_up_scientific_to_update_draw", 0, "")
            TipDlg.drawTextDailog(red_alert_all_str[282])
            checkPlayEffect(33)
        end
    end     
    if sure_number == 0 then
        protocol_command.barracks_teach_update.param_list = ""..self._base_barracks_info.id
        NetworkManager:register(protocol_command.barracks_teach_update.code, nil, nil, nil, nil, responseCallback, false, nil)
    end
end

function BuildUpScientificCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_res_infor = ccui.Helper:seekWidgetByName(root,"Text_res_infor")
    -- 科研目标icon
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")
    Panel_props_icon:removeAllChildren(true)
    Panel_props_icon:removeBackGroundImage()
    if Panel_props_que_icon ~= nil and Panel_attribute_icon ~= nil then
        Panel_props_que_icon:removeBackGroundImage()
        Panel_attribute_icon:removeBackGroundImage()
        local pic_index = zstring.split(dms.string(dms["teach_escalate_param"], self._base_barracks_info.id, teach_escalate_param.pic_index), ",")
        Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
        Panel_props_que_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
        Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))
    else
        local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_barracks_info.id,4})
        Panel_props_icon:addChild(cell) 
    end
    -- 科研目标名字
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_name")
    local Text_scientific_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_lv")
    if Text_scientific_lv ~= nil then
        Text_scientific_lv:setString(self._barracks_info.barrack_level)
        Text_scientific_name:setString(self._base_barracks_info.name)
    else
        local fontSize = Text_scientific_name:getFontSize()
        Text_scientific_name:setString("")
        Text_scientific_name:removeAllChildren(true)
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, self._base_barracks_info.name, "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..string.format(red_alert_all_str[13], self._barracks_info.barrack_level), "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re2)
        _richText_2:setContentSize(cc.size(root:getContentSize().width,fontSize))
        _richText_2:setPosition(cc.p(_richText_2:getContentSize().width / 2,0))
        Text_scientific_name:addChild(_richText_2)
    end
    -- 科研目标描述
    if Text_res_infor ~= nil then
        Text_res_infor:setString("")
        Text_res_infor:removeAllChildren(true)
        local fontName = Text_res_infor:getFontName()
        local fontSize = Text_res_infor:getFontSize()
        local dec_info = zstring.split(self._base_barracks_info.dec, "!x@")
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)    
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,dec_info[1], fontName,fontSize)
        _richText_1:pushBackElement(re3)
        local re4 = nil 
        if #dec_info > 1 then
            local talent_info = zstring.split(dms.string(dms["talent_mould"], self._base_barracks_info.gift, talent_mould.base_additional), "|")
            talent_info = zstring.split(talent_info[1], ",")
            local add_attr = tonumber(talent_info[2]) * tonumber(self._barracks_info.barrack_level)
            for k, v in pairs(attribute_hundred) do
                if v == tonumber(talent_info[1]) then
                    add_attr = ""..add_attr.."%"
                    break
                end
            end
            re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[8][1],color_Type[8][2],color_Type[8][3]),255,"+"..add_attr, fontName,fontSize)
            _richText_1:pushBackElement(re4)
        end
        _richText_1:setPosition(cc.p(Text_res_infor:getContentSize().width/2,Text_res_infor:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_res_infor:getContentSize().width,fontSize))
        Text_res_infor:addChild(_richText_1)
    end

    -- 科研目标所需时间
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    if Text_time_n ~= nil then
        local level = zstring.tonumber(self._barracks_info.barrack_level)
        local base_barracks_level_info = _ED.base_barracks_level_info[""..level]

        --计算科技飙升活动加层
        local activity_discount = 1
        local talentInfo = dms.string(dms["talent_mould"],self._base_barracks_info.gift, talent_mould.base_additional)
        local infoArry = zstring.split(talentInfo,"|")
        local currType = zstring.split(infoArry[1],",")
        if self.m_times > 0 and _ED.activity_info["85"] ~= nil and tonumber(currType[1]) == 59 then
            local timesData = zstring.split(_ED.activity_info["85"].activity_add_state, ",")
            activity_discount = tonumber(timesData[3])
        end
        local max_time = zstring.tonumber(base_barracks_level_info.need_time * self._base_barracks_info.upgrade_factor * activity_discount)

        -- 计算研究加速百分比
        local build_level = _ED.home_build["3"].level
        local build_produce = build_level * _ED.base_build_info["3"].add_get_speed * 100     -- 科技速度提升
        max_time = max_time / (1 + (build_produce + _ED.barracks_time_factor) / 100)

        Text_time_n:setString("")
        Text_time_n:removeAllChildren(true)
        local fontSize2 = Text_time_n:getFontSize()
        if activity_discount ~= 1 then
            local _richText_1 = ccui.RichText:create()
            _richText_1:ignoreContentAdaptWithSize(false) 
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ""..exChangeTimeToString(max_time), config_res.font.font_name,fontSize2)
            _richText_1:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, activity_str_tip[133], config_res.font.font_name,fontSize2)
            _richText_1:pushBackElement(re2)
            _richText_1:setContentSize(cc.size(root:getContentSize().width,fontSize2))
            _richText_1:setPosition(cc.p(_richText_1:getContentSize().width / 2,0))
            Text_time_n:addChild(_richText_1) 
        else
            Text_time_n:setString(exChangeTimeToString(max_time))
        end
    end

    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    if Button_up ~= nil then
        if self._can_update == true then
            Button_up:setBright(true)
        else
            Button_up:setBright(false)
        end
    end
end

function BuildUpScientificCell:onEnterTransitionFinish()

end

function BuildUpScientificCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_scientific_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BuildUpScientificCellSize == nil then
        BuildUpScientificCellSize = size
    end

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "build_up_scientific_cell_click", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 查看详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_infor"), nil, 
    {
        terminal_name = "build_up_scientific_cell_click", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_up"), nil, 
    {
        terminal_name = "build_up_scientific_cell_update", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpScientificCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_scientific_cell, self.roots[1])

end

function BuildUpScientificCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpScientificCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_scientific_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpScientificCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_name")
    local Text_res_infor = ccui.Helper:seekWidgetByName(root,"Text_res_infor")
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    local Text_scientific_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_lv")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Panel_props_icon:removeBackGroundImage()
    end
    if Text_scientific_name ~= nil then
        Text_scientific_name:setString("")
        Text_scientific_name:removeAllChildren(true)
    end
    if Text_res_infor ~= nil then
        Text_res_infor:setString("")
        Text_res_infor:removeAllChildren(true)
    end
    if Text_time_n ~= nil then
        Text_time_n:setString("")
        Text_time_n:removeAllChildren(true)
    end
    if Button_up ~= nil then
        Button_up:setBright(true)
    end
    if Text_scientific_lv ~= nil then
        Text_scientific_lv:setString("")
    end
    if Panel_props_que_icon ~= nil then
        Panel_props_que_icon:removeBackGroundImage()
    end
    if Panel_attribute_icon ~= nil then
        Panel_attribute_icon:removeBackGroundImage()
    end
end

function BuildUpScientificCell:init(index, base_barracks_info, barracks_info, can_update,lave_info_table , m_times) 
    self._index = index
    self._base_barracks_info = base_barracks_info
    self._barracks_info = barracks_info
    self._can_update = can_update
    self._lave_info_table = lave_info_table
    self.m_times = m_times
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(BuildUpScientificCellSize)
end

