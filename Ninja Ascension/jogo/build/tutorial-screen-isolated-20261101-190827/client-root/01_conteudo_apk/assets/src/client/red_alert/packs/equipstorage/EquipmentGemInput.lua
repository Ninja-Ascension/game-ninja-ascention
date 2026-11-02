-----------------------------
--宝石镶嵌界面
-----------------------------
EquipmentGemInput = class("EquipmentGemInputClass", Window)

local equipment_gem_input_window_open_terminal = {
    _name = "equipment_gem_input_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil ==  fwin:find("EquipmentGemInputClass") then
            local index = params[1]
            local equip = params[2]
            fwin:open(EquipmentGemInput:new():init(index,equip), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_gem_input_window_close_terminal = {
    _name = "equipment_gem_input_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentGemInputClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_gem_input_window_open_terminal)
state_machine.add(equipment_gem_input_window_close_terminal)
state_machine.init()

function EquipmentGemInput:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.prop_numbers = nil
    self.gem = nil
    self.equip = nil
    self.index = nil
    self.user_gems = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil
    self.text_table = {}


    -- Initialize DuplicateTitle state machine.
    local function init_equipment_wear_terminal()

        --镶嵌
        local equipment_gem_input_to_inlay_terminal = {
            _name = "equipment_gem_input_to_inlay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local text_table = instance.text_table
                local index = instance.index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_inlay_gems",0,"")
                        state_machine.excute("equipment_gem_input_close",0,"")
                        state_machine.excute("add_number_window_open",0,{index+8,text_table})
                        playEffect(formatMusicFile("effect", 10004))
                    end
                end
                if instance.gem == nil then
                    TipDlg.drawTextDailog(red_alert_all_str[83])
                    return 
                end

                protocol_command.gem_inlay.param_list = instance.gem.id .. "\r\n" .. instance.equip.user_equiment_id .. "\r\n" .. instance.index
                NetworkManager:register(protocol_command.gem_inlay.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --更新左侧绘图
        local equipment_gem_input_update_left_draw_terminal = {
            _name = "equipment_gem_input_update_left_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawLeftProp(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --取消所有选中
        local equipment_gem_input_un_set_selected_terminal = {
            _name = "equipment_gem_input_un_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setUnSelecet()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --关闭界面
        local equipment_gem_input_close_terminal = {
            _name = "equipment_gem_input_close",
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

		state_machine.add(equipment_gem_input_to_inlay_terminal)	
        state_machine.add(equipment_gem_input_update_left_draw_terminal)
        state_machine.add(equipment_gem_input_un_set_selected_terminal)
        state_machine.add(equipment_gem_input_close_terminal) 
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_wear_terminal()
end

function EquipmentGemInput:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_gem_input = ccui.Helper:seekWidgetByName(root,"ScrollView_gem_input")
    for i,v in pairs(ScrollView_gem_input:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
            return
        end
    end
end

function EquipmentGemInput:onUpdateDrawLeftProp(data)
    local  root = self.roots[1]    
    local prop_show_type = data[1]
    local prop_data = data[2]
    local prop = data[3]
    local prop_from_type = data[4]
    self.gem = prop   
    if prop == nil then
        return
    end 

    local gem_mould_id = prop.mould_id
    local gem_data = dms.element(dms["gems_mould"],prop.mould_id)
    local next_mould_id = dms.atoi(gem_data,gems_mould.next_mould_id)
    local up_need_exp = dms.atoi(gem_data,gems_mould.up_need_exp)
    local add_attribute  = dms.atos(gem_data,gems_mould.add_attribute)
    add_attribute = zstring.split(add_attribute,",")
    self.text_table = {}
    local text_title = tonumber(add_attribute[1]) + 1
    text_title = attribute[text_title]
    local text_str = tonumber(add_attribute[2])
    text_str = "  +" .. text_str
    table.insert(self.text_table,text_title .. text_str)
    local name = dms.atos(gem_data,gems_mould.name)
    local quatily = dms.atoi(gem_data,gems_mould.quality)
    local Panel_gem_input_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_input_icon")
    Panel_gem_input_icon:removeAllChildren(true)

    local cell = state_machine.excute("all_resource_create_cell",0,{7,prop_data,prop,8,0})
    Panel_gem_input_icon:addChild(cell)

    local Text_gem_input_name = ccui.Helper:seekWidgetByName(root,"Text_gem_input_name")
    Text_gem_input_name:setString(name)
    Text_gem_input_name:setColor(cc.c3b(color_Type[quatily+1][1],color_Type[quatily+1][2],color_Type[quatily+1][3]))

    local LoadingBar_gem_input_lv = ccui.Helper:seekWidgetByName(root,"LoadingBar_gem_input_lv")
    local Text_gem_input_lv = ccui.Helper:seekWidgetByName(root,"Text_gem_input_lv")
    local persent = math.floor(tonumber(prop.exp) / up_need_exp * 100)
    LoadingBar_gem_input_lv:setPercent(persent)
    Text_gem_input_lv:setString(tonumber(prop.exp) .. "/" .. up_need_exp)
    local Text_next_lv = ccui.Helper:seekWidgetByName(root,"Text_next_lv")
    local Text_now_effice = ccui.Helper:seekWidgetByName(root,"Text_now_effice")
    local Text_next_effice = ccui.Helper:seekWidgetByName(root,"Text_next_effice")
    Text_now_effice:setString(text_title)
    Text_next_effice:setString(text_title)

    local Text_now_effice_v = ccui.Helper:seekWidgetByName(root,"Text_now_effice_v")
    local Text_next_effice_v = ccui.Helper:seekWidgetByName(root,"Text_next_effice_v")
    Text_now_effice_v:setString(text_str)
    Text_now_effice_v:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
    Text_next_effice_v:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
    if next_mould_id ~= -1 then
        local add_attribute_next = dms.string(dms["gems_mould"],next_mould_id,gems_mould.add_attribute)
        add_attribute_next = zstring.split(add_attribute_next,",")
        Text_next_effice_v:setString("  +"..add_attribute_next[2])
    else
        Text_next_lv:setString("")
        Text_next_effice_v:setString("")
        Text_next_effice:setString("")
        Text_gem_input_lv:setString(tipStringInfo_union_str[70])
    end

end

function EquipmentGemInput:onUpdateDraw()
    local root = self.roots[1]
    local function sortGemsLevel( a, b )
        return tonumber(a.prop.level) > tonumber(b.prop.level)
    end
    table.sort(self.user_gems, sortGemsLevel)
    local ScrollView_gem_input = ccui.Helper:seekWidgetByName(root,"ScrollView_gem_input")
    ScrollView_gem_input:removeAllChildren(true)
    local width = ScrollView_gem_input:getContentSize().width
    local height = ScrollView_gem_input:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.user_gems[i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    if index % 4 == 0 then
        scroll_height = index / 4
    else
        scroll_height = math.floor(index / 4) + 1
    end

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end
    for i = 1,10000 do
        local v = self.user_gems[i]
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end

        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        local cell = nil
        if v == nil then
            cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
        else
            cell = state_machine.excute("all_resource_create_cell",0,{5,v.prop_data,v.prop,10,height_n})
        end

        if i == 1 then
            state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = cell }})
        end
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*92))
        ScrollView_gem_input:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_gem_input:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_gem_input:jumpToTop()

    self.scroll_view = ScrollView_gem_input
    self.scroll_view_poy = ScrollView_gem_input:getInnerContainer():getPositionY()

end


function EquipmentGemInput:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function EquipmentGemInput:getAllGems( )
    local result = {}
    self.prop_numbers = 0
    local table_gem_type = {}
    
    for i,v in pairs(self.equip.jewelrys) do
        if tonumber(v) ~= 0 then
            local gem = _ED.user_gems[""..v]
            local gem_type = dms.int(dms["gems_mould"],gem.mould_id,gems_mould.gem_type)
            table.insert(table_gem_type,gem_type)
        end
    end

    for i,v in pairs(_ED.user_gems) do
        local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
        local have_type = false

        for i,v in pairs(table_gem_type) do
            if gem_type == v then
                have_type = true
                break
            end
        end

        if tonumber(v.equip_id) > 0 or have_type == true then
        else
            local data = 
            {
                prop_data = 
                {
                    item_value = 1,
                    prop_type = 34,
                    prop_item = v.mould_id,
                },
                prop = v ,
            }
            self.prop_numbers = self.prop_numbers + 1
            table.insert(result,data)
        end
    end    
    self.user_gems = result
end

function EquipmentGemInput:onEnterTransitionFinish()

end

-- 关闭宝石镶嵌界面
function EquipmentGemInput:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("equipment_gem_input_window_close", 0, "")
        end
    end)
end

function EquipmentGemInput:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_gem_input)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.packs.equipstorage.equipment_gem_input)
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
    
    --镶嵌
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gem_input"), nil, 
    {
        terminal_name = "equipment_gem_input_to_inlay", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gem_input_close"), nil, 
    {
        terminal_name = "equipment_gem_input_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end


function EquipmentGemInput:init(index,equip)
    self.index = index
    self.equip = equip
    self:getAllGems()
	self:onInit()
    return self
end

function EquipmentGemInput:onExit()
    state_machine.remove("equipment_gem_input_to_inlay")    
    state_machine.remove("equipment_gem_input_update_left_draw")
    state_machine.remove("equipment_gem_input_un_set_selected")
    state_machine.remove("equipment_gem_input_close")
end
