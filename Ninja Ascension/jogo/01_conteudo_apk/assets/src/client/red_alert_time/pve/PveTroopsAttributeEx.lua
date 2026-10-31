-- ---------------------------
-- 征战技能详情
-- ---------------------------
PveTroopsAttributeEx = class("PveTroopsAttributeExClass", Window)

local pve_troops_attribute_ex_window_open_terminal = {
    _name = "pve_troops_attribute_ex_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("PveTroopsAttributeExClass") == nil then
            local _win = PveTroopsAttributeEx:new()
            _win:init(params)
            fwin:open(_win, fwin._ui)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local pve_troops_attribute_ex_window_close_terminal = {
    _name = "pve_troops_attribute_ex_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveTroopsAttributeExClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_troops_attribute_ex_window_open_terminal)
state_machine.add(pve_troops_attribute_ex_window_close_terminal)
state_machine.init()

function PveTroopsAttributeEx:ctor()
    self.super:ctor()
    self.roots = {}

    self.mould_id = 0 
    self._have_lv = 0

    local function init_pve_troops_attribute_ex_terminal()
        local pve_troops_attribute_ex_turn_terminal = {
            _name = "pve_troops_attribute_ex_turn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local turn = params._datas.turn_page
                local mould_id = instance.mould_id + turn
                local max_count = dms.count(dms["pve_buff"])
                if mould_id >= 1 and mould_id <= max_count then
                    instance.mould_id = mould_id
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_troops_attribute_ex_turn_terminal)
        state_machine.init()
    end
    init_pve_troops_attribute_ex_terminal()
end

function PveTroopsAttributeEx:onUpdateDraw()
    local root = self.roots[1]
    -- name
    local Text_attribute_name = ccui.Helper:seekWidgetByName(root,"Text_attribute_name")
    local halo_name = dms.string(dms["pve_buff"], self.mould_id, pve_buff.halo_name)
    Text_attribute_name:setString(halo_name)
    
    -- icon
    local Panel_troops_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_troops_attribute_icon")
    Panel_troops_attribute_icon:removeAllChildren(true)
    local cell = state_machine.excute("pve_gain_cell", 0, {self.mould_id,-1,false})
    Panel_troops_attribute_icon:addChild(cell) 

    local talent = dms.string(dms["pve_buff"], self.mould_id, pve_buff.condition)
    local talent_info = zstring.split(talent, ",")

    -- 增益等级
    local lv = 0
    for i, v in pairs(_ED.factor_permanent) do
        for j=1, #talent_info do
            if tonumber(v.mould_id) == tonumber(talent_info[j]) then
                if tonumber(v.factor_cd_time) == -1 and j > lv then
                    lv = j
                end
            end
        end
    end

    local current_attr = 0
    local add_attr = 0
    for i = 1, 3 do
        local Text_troops_attribute_buff_lv = ccui.Helper:seekWidgetByName(root,"Text_troops_attribute_buff_lv_"..i)
        local Text_troops_attribute_effect = ccui.Helper:seekWidgetByName(root,"Text_troops_attribute_effect_"..i)
        local Text_troops_attribute_lock = ccui.Helper:seekWidgetByName(root,"Text_troops_attribute_lock_"..i)
        local talent_id = tonumber(talent_info[i])
        if talent_id ~= nil and talent_id > 0 then
            Text_troops_attribute_buff_lv:setVisible(true)
            Text_troops_attribute_effect:setVisible(true)
            Text_troops_attribute_lock:setVisible(true)
            local lock_dec = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_star_dec)
            local attr_info = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.base_additional), ",")
            add_attr = add_attr + tonumber(attr_info[2])
            Text_troops_attribute_buff_lv:setString(friends_tip_string[12]..i)
            Text_troops_attribute_effect:setString(""..add_attr.."%")
            Text_troops_attribute_lock:setString(lock_dec)
            if lv == i then
                Text_troops_attribute_buff_lv:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                Text_troops_attribute_effect:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                Text_troops_attribute_lock:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                Text_troops_attribute_lock:setString(tipString_info_project_pacific_rim[1])
                current_attr = add_attr
            else
                Text_troops_attribute_buff_lv:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                Text_troops_attribute_effect:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                Text_troops_attribute_lock:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
            end
        else
            Text_troops_attribute_buff_lv:setVisible(false)
            Text_troops_attribute_effect:setVisible(false)
            Text_troops_attribute_lock:setVisible(false)
        end
    end

    -- 描述
    local Text_infor_prompt_t_1 = ccui.Helper:seekWidgetByName(root,"Text_infor_prompt_t_1")
    Text_infor_prompt_t_1:removeAllChildren(true)
    local font_size = Text_infor_prompt_t_1:getFontSize()
    local description = dms.string(dms["pve_buff"], self.mould_id, pve_buff.description)

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    _richText:setContentSize(cc.size(Text_infor_prompt_t_1:getContentSize().width,font_size))
    _richText:setAnchorPoint(0.5, 0.5)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, description..","..tipString_info_project_pacific_rim[2], config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, "+"..current_attr.."%", config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    _richText:formatTextExt()
    _richText:setPosition(cc.p(Text_infor_prompt_t_1:getContentSize().width,Text_infor_prompt_t_1:getContentSize().height/2))
    Text_infor_prompt_t_1:addChild(_richText)

    Image_attribute_arrow_left = ccui.Helper:seekWidgetByName(root, "Image_attribute_arrow_left")
    Image_attribute_arrow_right = ccui.Helper:seekWidgetByName(root, "Image_attribute_arrow_right")
    Image_attribute_arrow_left:setVisible(true)
    Image_attribute_arrow_right:setVisible(true)
    local max_count = dms.count(dms["pve_buff"])
    if self.mould_id <= 1 then
        Image_attribute_arrow_left:setVisible(false)
    end
    if self.mould_id >= max_count then
        Image_attribute_arrow_right:setVisible(false)
    end
end

function PveTroopsAttributeEx:onEnterTransitionFinish()

end

function PveTroopsAttributeEx:onInit( )
    local csbItem = csb.createNode(config_csb.pve.pve_troops_attribute_new)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_attribute_close"), nil, 
    {
        terminal_name = "pve_troops_attribute_ex_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "pve_troops_attribute_ex_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    local Image_attribute_arrow_left = ccui.Helper:seekWidgetByName(root, "Image_attribute_arrow_left")
    local Image_attribute_arrow_right = ccui.Helper:seekWidgetByName(root, "Image_attribute_arrow_right")

    fwin:addTouchEventListener(Image_attribute_arrow_left, nil, 
    {
        terminal_name = "pve_troops_attribute_ex_turn", 
        terminal_state = 0, 
        turn_page = -1,
    }, nil, 1)

    fwin:addTouchEventListener(Image_attribute_arrow_right, nil, 
    {
        terminal_name = "pve_troops_attribute_ex_turn", 
        terminal_state = 0, 
        turn_page = 1,
    }, nil, 1)
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    Image_attribute_arrow_left:stopAllActions()
    Image_attribute_arrow_right:stopAllActions()
    playActions(Image_attribute_arrow_left)
    playActions(Image_attribute_arrow_right)

    self:onUpdateDraw()
end

function PveTroopsAttributeEx:init(params)
    self.mould_id = params[1]
    self:onInit()
    return self
end

function PveTroopsAttributeEx:onExit()
    state_machine.remove("pve_troops_attribute_ex_turn")
end
