--------------------------------------------------------------------------------------------------------------
--  说明：科技详情
--------------------------------------------------------------------------------------------------------------
BuildUpScientificInfo = class("BuildUpScientificInfoClass", Window)

--打开界面
local build_up_scientific_info_open_terminal = {
    _name = "build_up_scientific_info_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("BuildUpScientificInfoClass") == nil then
            fwin:open(BuildUpScientificInfo:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_scientific_info_close_terminal = {
    _name = "build_up_scientific_info_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpScientificInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_scientific_info_open_terminal)
state_machine.add(build_up_scientific_info_close_terminal)
state_machine.init()

function BuildUpScientificInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._barracks_info = nil
    self._base_barracks_info = nil
    self.m_times = 0

    self._activity_type = 0
    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_resources_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_build_up_scientific_info_terminal()
        local build_up_scientific_info_show_terminal = {
            _name = "build_up_scientific_info_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local build_up_scientific_info_update_draw_terminal = {
            _name = "build_up_scientific_info_update_draw",
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

        local build_up_scientific_info_activity_rule_infor_terminal = {
            _name = "build_up_scientific_info_activity_rule_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(build_up_scientific_info_show_terminal)
        state_machine.add(build_up_scientific_info_update_draw_terminal)
        state_machine.add(build_up_scientific_info_activity_rule_infor_terminal)
        state_machine.init()
    end
    
    init_build_up_scientific_info_terminal()
end

function BuildUpScientificInfo:updateDraw()
    local root = self.roots[1]
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root, "Text_scientific_name")
    local Panel_res_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_res_build_icon")
    local Text_scientific_infor = ccui.Helper:seekWidgetByName(root, "Text_scientific_infor")
    local Panel_produciton_res_infor = ccui.Helper:seekWidgetByName(root, "Panel_produciton_res_infor")
    Text_scientific_name:setString(self._base_barracks_info.name.." "..string.format(red_alert_all_str[13], self._barracks_info.barrack_level))
    Panel_res_build_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_barracks_info.id,4})
    Panel_res_build_icon:addChild(cell) 
    Panel_produciton_res_infor:removeAllChildren(true)
    local barracks_level_info = _ED.base_barracks_level_info[""..self._barracks_info.barrack_level]

    -- 科研目标描述
    Text_scientific_infor:setString("")
    Text_scientific_infor:removeAllChildren(true)
    local fontName = Text_scientific_infor:getFontName()
    local fontSize = Text_scientific_infor:getFontSize()
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
    _richText_1:setPosition(cc.p(Text_scientific_infor:getContentSize().width/2,Text_scientific_infor:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_scientific_infor:getContentSize().width,fontSize))
    Text_scientific_infor:addChild(_richText_1)
    --计算科技飙升活动加层
    local activity_discount = 1
    local talentInfo = dms.string(dms["talent_mould"],self._base_barracks_info.gift, talent_mould.base_additional)
    local infoArry = zstring.split(talentInfo,"|")
    local currType = zstring.split(infoArry[1],",")
    if _ED.activity_info["85"] ~= nil and tonumber(currType[1]) == 59 then
        local timesData = zstring.split(_ED.activity_info["85"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_discount = tonumber(timesData[3])
        end
    end
    local iron_factor = self._base_barracks_info.cost_iron_factor * barracks_level_info.cost_iron * activity_discount
    local oil_factor = self._base_barracks_info.cost_oil_factor * barracks_level_info.cost_oil * activity_discount
    local lead_factor = self._base_barracks_info.cost_lead_factor * barracks_level_info.cost_lead * activity_discount
    local tita_factor = self._base_barracks_info.cost_tita_factor * barracks_level_info.cost_tita * activity_discount
    local gem_factor = self._base_barracks_info.cost_gem_factor * barracks_level_info.cost_gem * activity_discount

    local info ={
            {config_res.images.ui.home.icon_iron_ore,tipStringInfo_build_up_info[16],iron_factor,_ED.user_info.user_iron,33},
            {config_res.images.ui.home.icon_petroeum,tipStringInfo_build_up_info[17],oil_factor,_ED.user_info.oil_field,41},
            {config_res.images.ui.home.icon_lead_ore,tipStringInfo_build_up_info[18],lead_factor,_ED.user_info.exploits,42},
            {config_res.images.ui.home.icon_titanium_ore,tipStringInfo_build_up_info[19],tita_factor,_ED.user_info.tiger_shaped,43},
            {config_res.images.ui.home.icon_gemstone,tipStringInfo_build_up_info[20],gem_factor,_ED.user_info.user_silver,1}
        }
    local cell = state_machine.excute("build_up_resources_cell_create", 0, {self._barracks_info,self._base_barracks_info,info})
    Panel_produciton_res_infor:addChild(cell)

    -- 火力驱动活动标志
    local Button_build_up_res_act = ccui.Helper:seekWidgetByName(root,"Button_build_up_res_act")    
    if Button_build_up_res_act ~= nil then
        Button_build_up_res_act:setVisible(false)
        if _ED.activity_info ~= nil and _ED.activity_info["117"] ~= nil then
            local other_info = zstring.split(_ED.activity_info["117"].activity_add_state, "!")
            local timesData = zstring.split(other_info[1], ",")
            local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            if leave_times > 0 then
                local start_time = tonumber(timesData[1]/1000)
                local current_time = os.time() + _ED.time_add_or_sub
                local open_info = zstring.split(other_info[2], "|")
                open_info = zstring.split(open_info[1], ",")        -- 科技研究加速
                if (current_time - start_time) > (tonumber(open_info[1])) * 3600 then
                    Button_build_up_res_act:setVisible(true)
                    self._activity_type = 117
                end
            end
        end
    end
end

function BuildUpScientificInfo:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("build_up_scientific_info_update_draw",0,"")
        end
    end
end

--初始化
function BuildUpScientificInfo:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_scientific_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_scientific_infor_close"), nil, 
    {
        terminal_name = "build_up_scientific_info_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_scientific_info_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up_res_act"), nil, 
    {
        terminal_name = "build_up_scientific_info_activity_rule_infor",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 

    self:updateDraw()
end

function BuildUpScientificInfo:onEnterTransitionFinish()

end

function BuildUpScientificInfo:init(param)
    self._barracks_info = param[1]
    self._base_barracks_info = param[2]
    self:onInit()
    return self
end

function BuildUpScientificInfo:onExit()
    state_machine.remove("build_up_scientific_info_show")
    state_machine.remove("build_up_scientific_info_update_draw")
    state_machine.remove("build_up_scientific_info_activity_rule_infor")
end