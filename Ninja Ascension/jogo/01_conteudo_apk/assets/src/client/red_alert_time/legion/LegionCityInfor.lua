-- ------------------------------------------------------------------------------------------------------------
--  说明：城市属性
-- ------------------------------------------------------------------------------------------------------------
LegionCityInfor = class("LegionCityInforClass", Window)

--打开界面
local legion_city_infor_window_open_terminal = {
    _name = "legion_city_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local city_id = params[1]
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionCityInforClass") == nil then
                    local _win = LegionCityInfor:new()
                    _win:init(params)
                    fwin:open(_win,fwin._ui)
                end
            end
        end

        protocol_command.world_city_detail_get.param_list = ""..city_id
        NetworkManager:register(protocol_command.world_city_detail_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_infor_window_close_terminal = {
    _name = "legion_city_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_infor_window_open_terminal)
state_machine.add(legion_city_infor_window_close_terminal)
state_machine.init()

function LegionCityInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info = nil

    app.load("client.red_alert_time.cells.legion.legion_city_infor_cell")

     -- Initialize alert_home state machine.
    local function init_legion_city_infor_window_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_city_infor_window_terminal()
end

-- 显示信息
function LegionCityInfor:onUpdateDraw()
    local root = self.roots[1]
    local Panel_legion_city_infor_city = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_infor_city")
    local Text_legion_city_name_xy = ccui.Helper:seekWidgetByName(root, "Text_legion_city_name_xy")
    local Text_legion_city_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_city_lv")
    local Text_legion_city_legion_name_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_legion_name_n")
    local Panel_legion_city_res_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_res_icon")
    local Text_legion_city_res_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_res_n")
    local Panel_legion_city_occupy_res = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_occupy_res")
    local Text_legion_city_res_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_res_t")
    Panel_legion_city_res_icon:setVisible(true)
    Text_legion_city_res_n:setVisible(true)
    Text_legion_city_res_t:setVisible(true)

    Panel_legion_city_infor_city:removeBackGroundImage()
    Panel_legion_city_res_icon:removeBackGroundImage()

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local name = dms.atos(city_data, world_city_mould.name)
    local level = dms.atoi(city_data, world_city_mould.level)
    local pic = dms.atoi(city_data, world_city_mould.pic)
    local mine_type = dms.atoi(city_data, world_city_mould.mine_type)
    local position = dms.atos(city_data, world_city_mould.position)

    -- 城市图标
    Panel_legion_city_infor_city:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_icon, pic))

    -- 城市名称
    Text_legion_city_name_xy:removeAllChildren(true)
    Text_legion_city_name_xy:setString("")
    local font_size = Text_legion_city_name_xy:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, name, config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " ("..position..")", config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_legion_city_name_xy:getContentSize().width/2,Text_legion_city_name_xy:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_legion_city_name_xy:getContentSize().width,font_size))
    Text_legion_city_name_xy:addChild(_richText)

    -- 城市等级
    Text_legion_city_lv:setString(friends_tip_string[12]..level)

    -- 占领军团
    if tonumber(self._info.progress_union_id) > 0 then
        Text_legion_city_legion_name_n:setString(self._info.progress_union_name)
    elseif tonumber(self._info.union_id) > 0 then
        Text_legion_city_legion_name_n:setString(self._info.union_name)
    else
        Text_legion_city_legion_name_n:setString(tipStringInfo_rank_str[6])
    end

    -- 富饶资源
    if mine_type > 0 then
        local prop_name = dms.string(dms["prop_mould"], mine_type, prop_mould.prop_name)
        local pic_index = dms.string(dms["prop_mould"], mine_type, prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        Panel_legion_city_res_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
        Text_legion_city_res_n:setString(prop_name)
    else
        Panel_legion_city_res_icon:setVisible(false)
        Text_legion_city_res_n:setVisible(false)
        Text_legion_city_res_t:setVisible(false)
    end

    -- 资源产量
    Panel_legion_city_occupy_res:removeAllChildren(true)
    Panel_legion_city_occupy_res:setVisible(true)
    state_machine.excute("legion_city_infor_cell_create", 0, {Panel_legion_city_occupy_res, self._info, self._from_type})

    local Text_res_build_infor = ccui.Helper:seekWidgetByName(root, "Text_res_build_infor")
    if self._from_type == 1 or self._from_type == 2 then
        Text_res_build_infor:setString(world_city_tip_str[17])
    else
        Text_res_build_infor:setString(world_city_tip_str[18])
    end
end

--初始化界面
function LegionCityInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leigon_city_infor_colse"), nil, 
    {
        terminal_name = "legion_city_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    self:onUpdateDraw()
end

--初始化
function LegionCityInfor:init(params)
    self._city_id = params[1]
    self._from_type = params[2]     -- 1：不可分享，2：可分享

    self._info = _ED.world_city_info.detail_info[""..self._city_id]

    self:onInit()
end

--移除状态机
function LegionCityInfor:onExit()

end