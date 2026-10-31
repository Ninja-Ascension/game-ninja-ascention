-----------------------------
--宝石升级界面
-----------------------------
EquipmentGemFuse = class("EquipmentGemFuseClass", Window)

local equipment_gem_guse_window_open_terminal = {
    _name = "equipment_gem_guse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil ==  fwin:find("EquipmentGemFuseClass") then
            local index = params[1]
            local gem_id = params[2]
            local equip = params[3]
            fwin:open(EquipmentGemFuse:new():init(index,gem_id,equip), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_gem_guse_window_close_terminal = {
    _name = "equipment_gem_guse_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentGemFuseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_gem_guse_window_open_terminal)
state_machine.add(equipment_gem_guse_window_close_terminal)
state_machine.init()

function EquipmentGemFuse:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.prop_numbers = nil
    self.gem = nil
    self.user_gems = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil
    self.select_table_id = {}

    -- Initialize equipment_gem_guse state machine.
    local function init_equipment_gem_guse_terminal()

        --升级
        local equipment_gem_guse_to_level_up_terminal = {
            _name = "equipment_gem_guse_to_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:lockAll()
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.playActions ~= nil then
                            state_machine.excute("equipment_gem_guse_update_all")
                            state_machine.excute("equipment_inlay_gems",0,"")
                            response.node:playActions()
                            pushEffect(formatMusicFile("effect", 10006))
                            state_machine.excute("equipment_gem_attribute_to_update",0,"")
                            state_machine.excute("equipment_gem_guse_update_gem_left",0,"")
                            response.node.select_table_id = {}
                            response.node:unLockAll()
                        else
                            state_machine.unlock("equipment_gem_guse_to_level_up")
                            state_machine.unlock("equipment_gem_guse_select")
                            state_machine.unlock("equipment_gem_guse_remove_item")
                            state_machine.unlock("equipment_gem_guse_add_item")
                        end
                    else
                        state_machine.unlock("equipment_gem_guse_to_level_up")
                        state_machine.unlock("equipment_gem_guse_select")
                        state_machine.unlock("equipment_gem_guse_remove_item")
                        state_machine.unlock("equipment_gem_guse_add_item")
                    end
                end
                local gem_numbers = #instance.select_table_id
                if gem_numbers == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[83])
                    instance:unLockAll()
                    return
                end

                local str = ""
                for i,v in pairs(instance.select_table_id) do
                    if i == gem_numbers then
                        str =  str .. v
                    else
                        str =  str .. v .. ","
                    end
                end
                
                -- local get_exp = 0
                -- for i,gem_id in pairs(instance.select_table_id) do
                --     local exp = tonumber(_ED.user_gems[""..gem_id].exp) + dms.int(dms["gems_mould"],_ED.user_gems[""..gem_id].mould_id,gems_mould.have_exp) 
                --     get_exp = get_exp + exp
                -- end


                protocol_command.gem_level_up.param_list = self.gem.id .. "\r\n" .. str
                NetworkManager:register(protocol_command.gem_level_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --更新左侧绘图
        local equipment_gem_guse_update_gem_left_terminal = {
            _name = "equipment_gem_guse_update_gem_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawGems()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --增加
        local equipment_gem_guse_add_item_terminal = {
            _name = "equipment_gem_guse_add_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local add_id = tonumber(params[1])
                table.insert(instance.select_table_id,add_id)
                instance:onUpdateGemsExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        --减少
        local equipment_gem_guse_remove_item_terminal = {
            _name = "equipment_gem_guse_remove_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local remove_id = tonumber(params[1])
                for i,v in pairs(instance.select_table_id) do
                    if v == remove_id then
                        table.remove(instance.select_table_id,i)   
                    end
                end
                instance:onUpdateGemsExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        
        --自动选择
        local equipment_gem_guse_select_terminal = {
            _name = "equipment_gem_guse_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:autoSelectGems()
                instance:onUpdateGemsExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        
        --刷新宝石
        local equipment_gem_guse_update_all_terminal = {
            _name = "equipment_gem_guse_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:getAllGems()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --关闭界面
        local equipment_gem_guse_close_terminal = {
            _name = "equipment_gem_guse_close",
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

        state_machine.add(equipment_gem_guse_to_level_up_terminal)
        state_machine.add(equipment_gem_guse_update_gem_left_terminal)
        state_machine.add(equipment_gem_guse_add_item_terminal)
        state_machine.add(equipment_gem_guse_remove_item_terminal)
        state_machine.add(equipment_gem_guse_select_terminal)
        state_machine.add(equipment_gem_guse_update_all_terminal)
        state_machine.add(equipment_gem_guse_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_gem_guse_terminal()
end

function EquipmentGemFuse:lockAll()
    state_machine.lock("equipment_gem_guse_to_level_up")
    state_machine.lock("equipment_gem_guse_select")
    state_machine.lock("equipment_gem_guse_remove_item")
    state_machine.lock("equipment_gem_guse_add_item")
end

function EquipmentGemFuse:unLockAll()
    state_machine.unlock("equipment_gem_guse_to_level_up")
    state_machine.unlock("equipment_gem_guse_select")
    state_machine.unlock("equipment_gem_guse_remove_item")
    state_machine.unlock("equipment_gem_guse_add_item")
end

function EquipmentGemFuse:playActions()
    -- self:getAllGems()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function actionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        -- state_machine.excute("equipment_gem_guse_update_all")
        -- state_machine.excute("equipment_gem_guse_update_gem_left",0,"")
        -- state_machine.excute("equipment_inlay_gems",0,"")
    end
    local jsonPath = "images/ui/effice/effice_gem_input/effice_gem_input.json"
    local atlasPath = "images/ui/effice/effice_gem_input/effice_gem_input.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = actionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

function EquipmentGemFuse:unsetSelectAllGems()
    for i,cell in pairs(self.scroll_view:getChildren()) do
        if cell.selected == true then
            cell.selected = false
            cell:setSelected()
        end
    end
end

function EquipmentGemFuse:setSelectAllGems()
    for i,cell in pairs(self.scroll_view:getChildren()) do
        for j,gem_id in pairs(self.select_table_id) do
            if cell.setSelected ~= nil then
                if tonumber(cell.prop.id) == tonumber(gem_id) then
                    cell.selected = true
                    cell:setSelected() 
                end
            end
        end
    end
end

function EquipmentGemFuse:autoSelectGems()
    self:unsetSelectAllGems()
    self.select_table_id = {}
    local gem_mould_id = self.gem.mould_id
    local gem_data = dms.element(dms["gems_mould"],self.gem.mould_id)
    local up_need_exp = dms.atoi(gem_data,gems_mould.up_need_exp)
    local now_exp = tonumber(self.gem.exp)

    local need_exp = up_need_exp - now_exp

    local add_exp = 0
    for i,v in pairs(self.user_gems) do
        table.insert(self.select_table_id,tonumber(v.prop.id))
        add_exp = add_exp + v.exp
        if add_exp >= need_exp then
            break
        end
    end
    self:setSelectAllGems()
end

function EquipmentGemFuse:onUpdateDrawGems()
    local root = self.roots[1]
    local gem_mould_id = self.gem.mould_id
    local gem_data = dms.element(dms["gems_mould"],self.gem.mould_id)
    local up_need_exp = dms.atoi(gem_data,gems_mould.up_need_exp)
    local add_attribute  = dms.atos(gem_data,gems_mould.add_attribute)
    add_attribute = zstring.split(add_attribute,",")

    local text_title = tonumber(add_attribute[1]) + 1
    text_title = attribute[text_title]
    local text_str = tonumber(add_attribute[2])
    text_str = "  +" .. text_str

    local name = dms.atos(gem_data,gems_mould.name)
    local quatily = dms.atoi(gem_data,gems_mould.quality)
    local Panel_fuse_icon = ccui.Helper:seekWidgetByName(root,"Panel_fuse_icon")
    Panel_fuse_icon:removeAllChildren(true)
    local data = 
    {
        item_value = 1,
        prop_type = 34,
        prop_item = gem_mould_id
    }
    local cell = state_machine.excute("all_resource_create_cell",0,{7,data,self.gem,8,0})
    Panel_fuse_icon:addChild(cell)

    local Text_fuse_icon_name = ccui.Helper:seekWidgetByName(root,"Text_fuse_icon_name")
    Text_fuse_icon_name:setString(name)
    Text_fuse_icon_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quatily+1][1],tipStringInfo_quality_color_Type[quatily+1][2],tipStringInfo_quality_color_Type[quatily+1][3]))

    local Image_fuse_laod = ccui.Helper:seekWidgetByName(root,"Image_fuse_laod")
    local LoadingBar_fuse = ccui.Helper:seekWidgetByName(root,"LoadingBar_fuse")
    local Text_fuse_loading_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_loading_v")
    if up_need_exp > 0 then
        local persent = math.floor(tonumber(self.gem.exp) / up_need_exp * 100)
        LoadingBar_fuse:setPercent(persent)
        Text_fuse_loading_v:setString(tonumber(self.gem.exp) .. "/" .. up_need_exp)
    else
        Text_fuse_loading_v:setString(tipStringInfo_union_str[70])
    end
    
    local Text_fuse_infor = ccui.Helper:seekWidgetByName(root,"Text_fuse_infor")
    local Text_fuse_infor_up = ccui.Helper:seekWidgetByName(root,"Text_fuse_infor_up")
    Text_fuse_infor:setString(text_title)
    Text_fuse_infor_up:setString(text_title)

    local Text_fuse_infor_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_infor_v")
    local Text_fuse_infor_up_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_infor_up_v")
    Text_fuse_infor_v:setString(text_str)
    Text_fuse_infor_up_v:setString(text_str)

    local Text_fuse_lv_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_lv_v")
    local Text_fuse_lv_up_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_lv_up_v")
    Text_fuse_lv_v:setString(self.gem.level)
    Text_fuse_lv_up_v:setString(self.gem.level)
end

function EquipmentGemFuse:onUpdateGemsExp()
    local root = self.roots[1]

    local get_exp = 0
    for i,gem_id in pairs(self.select_table_id) do
        local gem = _ED.user_gems[""..gem_id]
        local exp = zstring.tonumber(gem.exp) + dms.int(dms["gems_mould"], gem.mould_id, gems_mould.have_exp) 
        get_exp = get_exp + exp
    end
    
    local add_attribute  = dms.string(dms["gems_mould"],self.gem.mould_id,gems_mould.add_attribute)
    add_attribute = zstring.split(add_attribute,",")
    local text_str = tonumber(add_attribute[2])
    text_str = "  +" .. text_str

    local LoadingBar_fuse = ccui.Helper:seekWidgetByName(root,"LoadingBar_fuse")
    local Text_fuse_loading_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_loading_v")

    local up_need_exp = dms.int(dms["gems_mould"],self.gem.mould_id,gems_mould.up_need_exp)
    if up_need_exp > 0 then
        local persent = math.min(100,math.floor((tonumber(get_exp)+tonumber(self.gem.exp))/ up_need_exp * 100))
        LoadingBar_fuse:setPercent(persent)
        Text_fuse_loading_v:setString(tonumber(get_exp)+tonumber(self.gem.exp) .. "/" .. up_need_exp)
    else
        Text_fuse_loading_v:setString(tipStringInfo_union_str[70])
    end
    local Text_fuse_infor_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_infor_v")
    
    Text_fuse_infor_v:setString(text_str)
    
    local next_mould_id = self:checkLevelUp(get_exp,tonumber(self.gem.exp),tonumber(self.gem.mould_id))
    local next_level = dms.int(dms["gems_mould"],next_mould_id,gems_mould.level)

    local add_attribute_next = dms.string(dms["gems_mould"],next_mould_id,gems_mould.add_attribute)
    add_attribute_next = zstring.split(add_attribute_next,",")
    local text_str_next = tonumber(add_attribute_next[2])
    text_str_next = "  +" .. text_str_next

    local Text_fuse_lv_up_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_lv_up_v")
    Text_fuse_lv_up_v:setString(next_level)

    local Text_fuse_infor_up_v = ccui.Helper:seekWidgetByName(root,"Text_fuse_infor_up_v")
    Text_fuse_infor_up_v:setString(text_str_next)
end

function EquipmentGemFuse:checkLevelUp(get_exp,now_exp,now_mould_id)
    local up_need_exp = dms.int(dms["gems_mould"],now_mould_id,gems_mould.up_need_exp)
    local leave_exp = 0
    if get_exp + now_exp >= up_need_exp then
        local next_mould_id = dms.int(dms["gems_mould"],now_mould_id,gems_mould.next_mould_id)
        if next_mould_id == -1 then
            return now_mould_id
        else
            leave_exp = get_exp + now_exp - up_need_exp
            return self:checkLevelUp(leave_exp,0,next_mould_id)
        end
    else
        return now_mould_id    
    end 
    
end

function EquipmentGemFuse:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_fuse = ccui.Helper:seekWidgetByName(root,"ScrollView_fuse")
    ScrollView_fuse:removeAllChildren(true)
    local width = ScrollView_fuse:getContentSize().width
    local height = ScrollView_fuse:getContentSize().height
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
            cell = state_machine.excute("all_resource_create_cell",0,{7,v.prop_data,v.prop,11,height_n})
        end

        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*92))
        ScrollView_fuse:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_fuse:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_fuse:jumpToTop()

    self.scroll_view = ScrollView_fuse
    self.scroll_view_poy = ScrollView_fuse:getInnerContainer():getPositionY()

end


function EquipmentGemFuse:onUpdate(dt) 
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

function EquipmentGemFuse:getAllGems( )
    local result = {}
    self.prop_numbers = 0
    local now_gem_type = dms.int(dms["gems_mould"],self.gem.mould_id,gems_mould.gem_type)
    for i,v in pairs(_ED.user_gems) do
        local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
        if tonumber(v.equip_id) == 0 and gem_type == now_gem_type then
            local data = 
            {
                prop_data = 
                {
                    item_value = 1,
                    prop_type = 34,
                    prop_item = v.mould_id,
                },
                prop = v ,
                quality = dms.int(dms["gems_mould"],v.mould_id,gems_mould.quality),
                exp = tonumber(v.exp) + dms.int(dms["gems_mould"],v.mould_id,gems_mould.have_exp)
            }
            self.prop_numbers = self.prop_numbers + 1
            table.insert(result,data)
        end
    end

    local function sortType( a, b )
       return tonumber(a.quality) < tonumber(b.quality) or 
              tonumber(a.quality) == tonumber(b.quality) and tonumber(a.exp) < tonumber(b.exp)
    end

    table.sort(result, sortType)    
    self.user_gems = result
end

function EquipmentGemFuse:onEnterTransitionFinish()

end

--播放动画
function EquipmentGemFuse:playBoxActions()
    local root = self.roots[1]
    local Panel_box_effice = ccui.Helper:seekWidgetByName(root,"Panel_box_effice")
    Panel_box_effice:removeAllChildren(true)
    local jsonPath = "images/ui/effice/effice_forging/effice_forging.json"
    local atlasPath = "images/ui/effice/effice_forging/effice_forging.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_box_effice:getContentSize().width/2,Panel_box_effice:getContentSize().height/2))
    Panel_box_effice:addChild(animation)
end

-- 关闭宝石升级界面
function EquipmentGemFuse:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("equipment_gem_guse_window_close", 0, "")
        end
    end)
end

function EquipmentGemFuse:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_gem_fuse)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.packs.equipstorage.equipment_gem_fuse)
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

    --升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fuse"), nil, 
    {
        terminal_name = "equipment_gem_guse_to_level_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fuse_close"), nil, 
    {
        terminal_name = "equipment_gem_guse_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --自动选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fuse_chose"), nil, 
    {
        terminal_name = "equipment_gem_guse_select", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:onUpdateDrawGems()
	self:onUpdateDraw()	
end


function EquipmentGemFuse:init(index,gem_id,equip)
    self.index = index
    self.gem_id = gem_id
    self.gem = _ED.user_gems[""..self.gem_id]
    self.equip = equip
    self:getAllGems()
	self:onInit()
    self:playBoxActions()
    return self
end

function EquipmentGemFuse:onExit()
    state_machine.remove("equipment_gem_guse_to_level_up")
    state_machine.remove("equipment_gem_guse_update_gem_left")
    state_machine.remove("equipment_gem_guse_add_item")
    state_machine.remove("equipment_gem_guse_remove_item")
    state_machine.remove("equipment_gem_guse_select")    
    state_machine.remove("equipment_gem_guse_update_all")
    state_machine.remove("equipment_gem_guse_close")
end
