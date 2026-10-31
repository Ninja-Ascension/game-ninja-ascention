-----------------------------
--马场属性
-----------------------------
RacecourseAttribute = class("RacecourseAttributeClass", Window)
--打开
local racecourse_attribute_window_open_terminal = {
    _name = "racecourse_attribute_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _RacecourseAttributeWindow = fwin:find("RacecourseAttributeClass")
        if nil == _RacecourseAttributeWindow then
            fwin:open(RacecourseAttribute:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_attribute_window_close_terminal = {
    _name = "racecourse_attribute_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseAttributeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_attribute_window_open_terminal)
state_machine.add(racecourse_attribute_window_close_terminal)
state_machine.init()

function RacecourseAttribute:ctor()
    self.super:ctor()
    self.roots = {}
    self._horse = nil
    self._index = 0
    -- load lua file
    app.load("client.red_alert.horse.RacecourseSoulUp")

    local function init_racecourse_attribute_terminal()
        local racecourse_attribute_give_up_spirit_terminal = {
            _name = "racecourse_attribute_give_up_spirit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("racecourse_attribute_window_close", 0, nil)
                        state_machine.excute("racecourse_ride_change_ship", 0, nil)
                    end
                end
                protocol_command.inlay_horse_spirit.param_list = "0\r\n"..instance._horse.id.."\r\n"..instance._index
                NetworkManager:register(protocol_command.inlay_horse_spirit.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local racecourse_attribute_strength_spirit_terminal = {
            _name = "racecourse_attribute_strength_spirit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local horse_spilits_id = instance._horse.horse_spirits[instance._index]
                state_machine.excute("racecourse_horse_strength_window_open", 0, {_ED.horse_spirits[""..horse_spilits_id]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新属性
        local racecourse_attribute_update_draw_terminal = {
            _name = "racecourse_attribute_update_draw",
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

        -- 觉醒
        local racecourse_attribute_soul_up_terminal = {
            _name = "racecourse_attribute_soul_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local horse_spilits_id = instance._horse.horse_spirits[instance._index]
                state_machine.excute("racecourse_soul_up_window_open", 0, {_ED.horse_spirits[""..horse_spilits_id],instance._index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_attribute_give_up_spirit_terminal)
        state_machine.add(racecourse_attribute_strength_spirit_terminal)
        state_machine.add(racecourse_attribute_update_draw_terminal)
        state_machine.add(racecourse_attribute_soul_up_terminal)
        state_machine.init()
    end
    init_racecourse_attribute_terminal()
end 

function RacecourseAttribute:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_treasure_piece = ccui.Helper:seekWidgetByName(root, "Panel_treasure_piece")             --附魔图像
    local Text_treasure_piece_name = ccui.Helper:seekWidgetByName(root, "Text_treasure_piece_name")     --附魔名称
    local LoadingBar_experience = ccui.Helper:seekWidgetByName(root, "LoadingBar_experience")           --附魔经验百分比
    local Text_treasure_expreience = ccui.Helper:seekWidgetByName(root, "Text_treasure_expreience")     --附魔经验值
    local Text_now_effice = ccui.Helper:seekWidgetByName(root, "Text_now_effice")                       --当前属性名
    local Text_now_effice_v = ccui.Helper:seekWidgetByName(root, "Text_now_effice_v")                   --当前属性值
    local Text_next_effice = ccui.Helper:seekWidgetByName(root, "Text_next_effice")                     --下一级属性名
    local Text_now_effice_v_0 = ccui.Helper:seekWidgetByName(root, "Text_now_effice_v_0")               --下一级属性值
    Text_now_effice:setString("")
    Text_now_effice_v:setString("")
    Text_next_effice:setString("")
    Text_now_effice_v_0:setString("")
    Text_treasure_expreience:setString("")
    LoadingBar_experience:setPercent(0)

    local house_spirits = _ED.horse_spirits[""..self._horse.horse_spirits[self._index]]
    --附魔名称(根据品质设置颜色)
    local name = dms.string(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.horse_spirit_name)
    local quality = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.quality)
    Text_treasure_piece_name:setString(name)
    Text_treasure_piece_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    --附魔图像
    local picIndex = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.icon)
    Panel_treasure_piece:removeBackGroundImage()
    Panel_treasure_piece:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
    --附魔类型
    local horse_spirit_type = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.horse_spirit_type)
    --升级消耗经验
    local maxExp = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.upgrade_cost_exp)
    --属性
    local attributes = dms.string(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.attributes)
    --下一级id
    local next_level_id = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.next_level_id)

    ccui.Helper:seekWidgetByName(root, "Text_next_lv"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Button_strength"):setVisible(true)
    --当前经验值
    Text_treasure_expreience:setString(house_spirits.now_exp.."/"..maxExp)
    LoadingBar_experience:setPercent(tonumber(house_spirits.now_exp)/maxExp * 100)
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
    else  --如果当前附魔是最大级显示已满级
        isFullLevel = true
        Text_treasure_expreience:setString(tipStringInfo_union_str[70])
        ccui.Helper:seekWidgetByName(root, "Text_next_lv"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_strength"):setVisible(false)
    end

    -- 觉醒
    local Button_up = ccui.Helper:seekWidgetByName(root, "Button_up")
    local awakening_id = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.awakening_id)
    if awakening_id > 0 and funOpenDrawTip(139,false) == false then    -- 可以觉醒显示觉醒按钮不能则隐藏
        Button_up:setVisible(true)
    else
        Button_up:setVisible(false)
    end
end

function RacecourseAttribute:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_soul_attribution)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "racecourse_attribute_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_strength"), nil, 
    {
        -- func_string = [[funOpenDrawTip(64)]], 
        terminal_name = "racecourse_attribute_strength_spirit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --卸载
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_unload"), nil, 
    {
        terminal_name = "racecourse_attribute_give_up_spirit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 进阶
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up"), nil, 
    {
        terminal_name = "racecourse_attribute_soul_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

    self:onUpdateDraw()
end

function RacecourseAttribute:init(params)
    self._horse = params[1]
    self._index = params[2]
	self:onInit()
    return self
end

function RacecourseAttribute:onExit()
    state_machine.remove("racecourse_attribute_give_up_spirit")
    state_machine.remove("racecourse_attribute_strength_spirit")
    state_machine.remove("racecourse_attribute_update_draw")
    state_machine.remove("racecourse_attribute_soul_up")
end