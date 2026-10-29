-----------------------------
--宝石融合 卸下 选择 界面
-----------------------------
EquipmentGemAttribute = class("EquipmentGemAttributeClass", Window)

local equipment_gem_attribute_window_open_terminal = {
    _name = "equipment_gem_attribute_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("EquipmentGemAttributeClass") then
            local equip = params[1]
            local index = params[2]
            local gem_id = params[3]
            fwin:open(EquipmentGemAttribute:new():init(equip,index,gem_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_gem_attribute_window_close_terminal = {
    _name = "equipment_gem_attribute_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentGemAttributeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_gem_attribute_window_open_terminal)
state_machine.add(equipment_gem_attribute_window_close_terminal)
state_machine.init()

function EquipmentGemAttribute:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.equip = nil
    self.index = nil
    self.gem_id = nil
    -- Initialize equipment_gem_attribute state machine.
    local function init_equipment_gem_attribute_terminal()

        --卸下
        local equipment_gem_attribute_to_down_terminal = {
            _name = "equipment_gem_attribute_to_down",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_inlay_gems",0,"")
                        state_machine.excute("equipment_gem_attribute_close",0,"")
                        playEffect(formatMusicFile("effect", 10005))
                    end
                end

                protocol_command.gem_inlay_down.param_list = self.gem_id .. "\r\n" .. self.equip.user_equiment_id .. "\r\n" .. self.index
                NetworkManager:register(protocol_command.gem_inlay_down.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --升级
        local equipment_gem_attribute_to_level_up_terminal = {
            _name = "equipment_gem_attribute_to_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("equipment_gem_guse_window_open",0,{self.index,self.gem_id,self.equip})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新
        local equipment_gem_attribute_to_update_terminal = {
            _name = "equipment_gem_attribute_to_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --关闭界面
        local equipment_gem_attribute_close_terminal = {
            _name = "equipment_gem_attribute_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(equipment_gem_attribute_to_down_terminal)	
        state_machine.add(equipment_gem_attribute_to_level_up_terminal)
        state_machine.add(equipment_gem_attribute_to_update_terminal)
        state_machine.add(equipment_gem_attribute_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_gem_attribute_terminal()
end


function EquipmentGemAttribute:onUpdateDraw()
    local root = self.roots[1]
    local gem = _ED.user_gems[""..self.gem_id]
    local gem_mould_id = gem.mould_id
    local gem_data = dms.element(dms["gems_mould"],gem_mould_id)
    local next_mould_id = dms.atoi(gem_data,gems_mould.next_mould_id)
    local up_need_exp = dms.atoi(gem_data,gems_mould.up_need_exp)
    local add_attribute  = dms.atos(gem_data,gems_mould.add_attribute)
    add_attribute = zstring.split(add_attribute,",")

    local text_title = tonumber(add_attribute[1]) + 1
    text_title = attribute[text_title]
    local text_str = tonumber(add_attribute[2])
    text_str = "  +" .. text_str

    local name = dms.atos(gem_data,gems_mould.name)
    local quatily = dms.atoi(gem_data,gems_mould.quality)
    local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon")
    Panel_gem_icon:removeAllChildren(true)
    local data = 
    {   
        item_value = 1,
        prop_type = 34,
        prop_item = gem_mould_id
    }
    local cell = state_machine.excute("all_resource_create_cell",0,{7,data,gem,8,0})
    Panel_gem_icon:addChild(cell)

    local Text_gem_name = ccui.Helper:seekWidgetByName(root,"Text_gem_name")
    Text_gem_name:setString(name)
    Text_gem_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quatily+1][1],tipStringInfo_quality_color_Type[quatily+1][2],tipStringInfo_quality_color_Type[quatily+1][3]))

    local LoadingBar_experience = ccui.Helper:seekWidgetByName(root,"LoadingBar_experience")
    local Text_experience = ccui.Helper:seekWidgetByName(root,"Text_experience")

    local persent = math.floor(tonumber(gem.exp) / up_need_exp * 100)
    LoadingBar_experience:setPercent(persent)
    Text_experience:setString(tonumber(gem.exp) .. "/" .. up_need_exp)

    local Text_next_lv = ccui.Helper:seekWidgetByName(root,"Text_next_lv")
    local Text_now_effice = ccui.Helper:seekWidgetByName(root,"Text_now_effice")
    local Text_next_effice = ccui.Helper:seekWidgetByName(root,"Text_next_effice")
    Text_now_effice:setString(text_title)
    Text_next_effice:setString(text_title)

    local Text_now_effice_v = ccui.Helper:seekWidgetByName(root,"Text_now_effice_v")
    local Text_now_effice_v_0 = ccui.Helper:seekWidgetByName(root,"Text_now_effice_v_0")
    Text_now_effice_v:setString(text_str)
    if next_mould_id ~= -1 then
        local add_attribute_next = dms.string(dms["gems_mould"],next_mould_id,gems_mould.add_attribute)
        add_attribute_next = zstring.split(add_attribute_next,",")
        Text_now_effice_v_0:setString("  +"..add_attribute_next[2])
    else
        Text_next_lv:setString("")
        Text_experience:setString(tipStringInfo_union_str[70])
        Text_now_effice_v_0:setString("")
        Text_next_effice:setString("")
        ccui.Helper:seekWidgetByName(root, "Button_mix"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root, "Button_mix"):setBright(false)
        ccui.Helper:seekWidgetByName(root, "Text_mix"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_mix_full"):setVisible(true)
        
    end
end

function EquipmentGemAttribute:onEnterTransitionFinish()

end

-- 关闭宝石属性界面
function EquipmentGemAttribute:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("equipment_gem_attribute_window_close", 0, "")
        end
    end)
end

function EquipmentGemAttribute:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_gem_attribute)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.packs.equipstorage.equipment_gem_attribute)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
        end
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "equipment_gem_attribute_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_gem_attribute"), nil, 
    {
        terminal_name = "equipment_gem_attribute_close", 
        terminal_state = 0, 
    }, nil, 0)

    --卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_load_down"), nil, 
    {
        terminal_name = "equipment_gem_attribute_to_down", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mix"), nil, 
    {
        terminal_name = "equipment_gem_attribute_to_level_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end


function EquipmentGemAttribute:init(equip,index,gem_id)
    self.equip = equip
    self.index = index
    self.gem_id = gem_id
	self:onInit()
    return self
end

function EquipmentGemAttribute:onExit()
    state_machine.remove("equipment_gem_attribute_to_down") 
    state_machine.remove("equipment_gem_attribute_to_level_up")
    state_machine.remove("equipment_gem_attribute_to_update")
    state_machine.remove("equipment_gem_attribute_close")
end
