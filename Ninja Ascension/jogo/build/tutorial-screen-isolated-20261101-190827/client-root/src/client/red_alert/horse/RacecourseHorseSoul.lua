-----------------------------
--马魂包裹
-----------------------------
RacecourseHorseSoul = class("RacecourseHorseSoulClass", Window)
--打开
local racecourse_horse_soul_window_open_terminal = {
    _name = "racecourse_horse_soul_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("home_select_action_window_close",0,"")
        local _RacecourseWindow = fwin:find("RacecourseHorseSoulClass")
        if nil == _RacecourseWindow then
            fwin:open(RacecourseHorseSoul:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_horse_soul_window_close_terminal = {
    _name = "racecourse_horse_soul_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseHorseSoulClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_horse_soul_window_open_terminal)
state_machine.add(racecourse_horse_soul_window_close_terminal)
state_machine.init()

function RacecourseHorseSoul:ctor()
    self.super:ctor()
    self.roots = {}
    self._chooseHorseSpirit = nil
    self._chooseHorse = nil
    self._chooseIndex = 0

    -- Initialize racecourse_horse_soul state machine.
    local function init_racecourse_horse_soul_terminal()
        --兑换
        local racecourse_horse_soul_recharge_terminal = {
            _name = "racecourse_horse_soul_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("racecourse_horse_soul_window_close", 0, nil)
                        state_machine.excute("racecourse_ride_change_ship", 0, nil)
                    end
                end
                protocol_command.inlay_horse_spirit.param_list = instance._chooseHorseSpirit.id.."\r\n"..instance._chooseHorse.id.."\r\n"..instance._chooseIndex
                NetworkManager:register(protocol_command.inlay_horse_spirit.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --合成
        local racecourse_horse_soul_composition_terminal = {
            _name = "racecourse_horse_soul_composition",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("racecourse_soul_exchange_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --强化
        local racecourse_horse_soul_strength_terminal = {
            _name = "racecourse_horse_soul_strength",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("racecourse_horse_strength_window_open", 0, {instance._chooseHorseSpirit})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新左侧
        local racecourse_horse_soul_left_prop_draw_terminal = {
            _name = "racecourse_horse_soul_left_prop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawLeftProp(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新列表
        local racecourse_horse_soul_update_draw_terminal = {
            _name = "racecourse_horse_soul_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_horse_soul_recharge_terminal)
        state_machine.add(racecourse_horse_soul_composition_terminal)
        state_machine.add(racecourse_horse_soul_strength_terminal)
        state_machine.add(racecourse_horse_soul_left_prop_draw_terminal)
        state_machine.add(racecourse_horse_soul_update_draw_terminal)
    end
    init_racecourse_horse_soul_terminal()
end

--刷新按钮状态
function RacecourseHorseSoul:onUpdateButtonState( horse_spirit_type, isFullLevel )
    local root = self.roots[1]
    local Button_change = ccui.Helper:seekWidgetByName(root, "Button_change")               --兑换
    local Button_composition = ccui.Helper:seekWidgetByName(root, "Button_composition")     --合成
    local Button_strength = ccui.Helper:seekWidgetByName(root, "Button_strength")           --强化
    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_2:setVisible(true)
    Button_change:setVisible(false)
    Button_composition:setVisible(false)
    Button_strength:setVisible(false)
    if self._chooseHorse ~= nil then
        Button_change:setVisible(true)
    else
        if horse_spirit_type == 3 then
            Button_composition:setVisible(true)
        elseif horse_spirit_type == 1 then
            if isFullLevel == false then
                Button_strength:setVisible(true)
            end
        end
    end
end

function RacecourseHorseSoul:onUpdateDrawLeftProp( horse_spirits )
    self._chooseHorseSpirit = horse_spirits

    local root = self.roots[1]
    --附魔图像
    local Panel_soul_piece = ccui.Helper:seekWidgetByName(root,"Panel_soul_piece")
    Panel_soul_piece:removeBackGroundImage()
    --附魔名称
    local Text_soul_piece = ccui.Helper:seekWidgetByName(root, "Text_soul_piece")
    Text_soul_piece:setString("")

    local Text_now_effice_v = ccui.Helper:seekWidgetByName(root, "Text_now_effice_v")               --当前属性值
    local Text_now_effice = ccui.Helper:seekWidgetByName(root, "Text_now_effice")                   --当前属性名
    local Text_now_effice_v_0 = ccui.Helper:seekWidgetByName(root, "Text_now_effice_v_0")           --下一级属性值
    local Text_next_effice = ccui.Helper:seekWidgetByName(root, "Text_next_effice")                 --下一级属性名
    local Text_experience_pragress = ccui.Helper:seekWidgetByName(root, "Text_experience_pragress") --附魔经验值
    local LoadingBar_experience = ccui.Helper:seekWidgetByName(root, "LoadingBar_experience")       --附魔经验百分比
    Text_now_effice:setString("")
    Text_now_effice_v:setString("")
    Text_next_effice:setString("")
    Text_now_effice_v_0:setString("")
    Text_experience_pragress:setString("")
    LoadingBar_experience:setPercent(0)
    --橙色碎片描述
    local Text_explian = ccui.Helper:seekWidgetByName(root, "Text_explian")
    Text_explian:setVisible(false)
    if self._chooseHorseSpirit == nil then
        Text_soul_piece:setString(_my_gane_name[15])
        Text_soul_piece:setColor(cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]))
        Panel_soul_piece:setBackGroundImage("images/ui/props/props_4021.png")
        Text_explian:setVisible(true)
        Text_explian:setString(_All_tip_string_info_description._horseSoulDescription)
        ccui.Helper:seekWidgetByName(root, "Panel_soul"):setVisible(false)
        self:onUpdateButtonState(3, false)
        return
    end
    --附魔名称(根据品质设置颜色)
    local name = dms.string(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.horse_spirit_name)
    local quality = dms.int(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.quality)
    Text_soul_piece:setString(name)
    Text_soul_piece:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    --附魔图像
    local picIndex = dms.int(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.icon)
    Panel_soul_piece:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
    --附魔类型
    local horse_spirit_type = dms.int(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.horse_spirit_type)
    --描述
    local desc = dms.string(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.desc)
    --升级消耗经验
    local maxExp = dms.int(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.upgrade_cost_exp)
    --属性
    local attributes = dms.string(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.attributes)
    --下一级id
    local next_level_id = dms.int(dms["horse_spirit_mould"], horse_spirits.mould_id, horse_spirit_mould.next_level_id)
    local isFullLevel = false

    if horse_spirit_type == 1 then
        --当前经验/升级所需经验
        Text_experience_pragress:setString(horse_spirits.now_exp.."/"..maxExp)
        LoadingBar_experience:setPercent(tonumber(horse_spirits.now_exp)/maxExp * 100)

        ccui.Helper:seekWidgetByName(root, "Text_next_lv"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_soul"):setVisible(true)
        --当前属性效果
        local attributes_info = zstring.split(attributes, ",")
        Text_now_effice:setString(attribute[tonumber(attributes_info[1]) + 1])
        local is_handred = false
        for i,v in pairs(attribute_hundred) do
            if tonumber(attributes_info[1]) == v then
                is_handred = true
            end
        end
        if is_handred == true then
            Text_now_effice_v:setString("+"..attributes_info[2].."%")
        else
            Text_now_effice_v:setString("+"..attributes_info[2])
        end
        --如果当前附魔不是最大级显示下一级效果
        if next_level_id > 0 then
            local next_attributes = dms.string(dms["horse_spirit_mould"], next_level_id, horse_spirit_mould.attributes)
            local next_attributes_info = zstring.split(next_attributes, ",")
            Text_next_effice:setString(attribute[tonumber(next_attributes_info[1]) + 1])
            if is_handred == true then
                Text_now_effice_v_0:setString("+"..next_attributes_info[2].."%")
            else
                Text_now_effice_v_0:setString("+"..next_attributes_info[2])
            end
        else    --如果当前附魔是最大级显示已满级
            isFullLevel = true
            Text_experience_pragress:setString(tipStringInfo_union_str[70])
            ccui.Helper:seekWidgetByName(root, "Text_next_lv"):setVisible(false)
        end
    else
        Text_explian:setVisible(true)
        Text_explian:setString(desc)
        ccui.Helper:seekWidgetByName(root, "Panel_soul"):setVisible(false)
    end
    self:onUpdateButtonState(horse_spirit_type, isFullLevel)
end

--刷新列表
function RacecourseHorseSoul:onUpdateDraw()
    local root = self.roots[1]
    local Panel_scrollview = ccui.Helper:seekWidgetByName(root, "Panel_scrollview")
    Panel_scrollview:removeAllChildren(true)
    local isShowSui = self._chooseHorse == nil
    state_machine.excute("racecourse_scrollview_window_open", 0, {Panel_scrollview, 2, isShowSui, self._chooseHorse})
end

function RacecourseHorseSoul:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_horse_soul)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "racecourse_horse_soul_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_change"), nil, 
    {
        terminal_name = "racecourse_horse_soul_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_composition"), nil, 
    {
        terminal_name = "racecourse_soul_exchange_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_strength"), nil, 
    {
        terminal_name = "racecourse_horse_soul_strength", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end


function RacecourseHorseSoul:init(params)
    self._chooseHorse = params[1]
    if params[2] ~= nil then
        self._chooseIndex = params[2]
    end
	self:onInit()
    return self
end

function RacecourseHorseSoul:onExit()
    state_machine.remove("racecourse_horse_soul_left_prop_draw")
    state_machine.remove("racecourse_horse_soul_recharge")
    state_machine.remove("racecourse_horse_soul_composition")
    state_machine.remove("racecourse_horse_soul_strength")
    state_machine.remove("racecourse_horse_soul_update_draw")
end