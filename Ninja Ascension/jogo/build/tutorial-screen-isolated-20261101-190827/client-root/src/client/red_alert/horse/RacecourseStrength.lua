-----------------------------
--马魂升级
-----------------------------
RacecourseHorseStrength = class("RacecourseHorseStrengthClass", Window)
--打开
local racecourse_horse_strength_window_open_terminal = {
    _name = "racecourse_horse_strength_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _RacecourseHorseStrengthWindow = fwin:find("RacecourseHorseStrengthClass")
        if nil == _RacecourseHorseStrengthWindow then
            fwin:open(RacecourseHorseStrength:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_horse_strength_window_close_terminal = {
    _name = "racecourse_horse_strength_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseHorseStrengthClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_horse_strength_window_open_terminal)
state_machine.add(racecourse_horse_strength_window_close_terminal)
state_machine.init()

function RacecourseHorseStrength:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.horse_spilits = nil
    self.user_spilits = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil
    self.select_table_id = {}

    local function init_racecourse_horse_strength_terminal()
        --升级
        local racecourse_horse_strength_level_up_terminal = {
            _name = "racecourse_horse_strength_level_up",
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
                            state_machine.excute("racecourse_horse_soul_update_draw", 0, nil)
                            state_machine.excute("racecourse_attribute_update_draw", 0, "")
                            state_machine.excute("racecourse_horse_strength_update_all")
                            state_machine.excute("racecourse_ride_change_ship")
                            state_machine.excute("racecourse_horse_strength_update_left",0,"")
                            response.node:playActions()
                            pushEffect(formatMusicFile("effect", 10006))
                            response.node.select_table_id = {}
                            response.node:unLockAll()
                        else
                            state_machine.unlock("racecourse_horse_strength_level_up")
                            state_machine.unlock("racecourse_horse_strength_add_item")
                            state_machine.unlock("racecourse_horse_strength_remove_item")
                            state_machine.unlock("racecourse_horse_strength_select")
                        end
                    else
                        state_machine.unlock("racecourse_horse_strength_level_up")
                        state_machine.unlock("racecourse_horse_strength_add_item")
                        state_machine.unlock("racecourse_horse_strength_remove_item")
                        state_machine.unlock("racecourse_horse_strength_select")
                    end
                end
                local gem_numbers = #instance.select_table_id
                if gem_numbers == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[249])
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
                protocol_command.horse_spirit_level_up.param_list = instance.horse_spilits.id .. "\r\n" .. str
                NetworkManager:register(protocol_command.horse_spirit_level_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新左侧
        local racecourse_horse_strength_update_left_terminal = {
            _name = "racecourse_horse_strength_update_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --增加
        local racecourse_horse_strength_add_item_terminal = {
            _name = "racecourse_horse_strength_add_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local add_id = tonumber(params[1])
                table.insert(instance.select_table_id,add_id)
                instance:onUpdateExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        --减少
        local racecourse_horse_strength_remove_item_terminal = {
            _name = "racecourse_horse_strength_remove_item",
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
                instance:onUpdateExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        
        --自动选择
        local racecourse_horse_strength_select_terminal = {
            _name = "racecourse_horse_strength_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:autoSelect()
                instance:onUpdateExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local racecourse_horse_strength_update_all_terminal = {
            _name = "racecourse_horse_strength_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:getAll()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --关闭界面
        local racecourse_horse_strength_close_terminal = {
            _name = "racecourse_horse_strength_close",
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
        state_machine.add(racecourse_horse_strength_level_up_terminal)
        state_machine.add(racecourse_horse_strength_update_left_terminal)
        state_machine.add(racecourse_horse_strength_add_item_terminal)
        state_machine.add(racecourse_horse_strength_remove_item_terminal)
        state_machine.add(racecourse_horse_strength_select_terminal)
        state_machine.add(racecourse_horse_strength_update_all_terminal)
        state_machine.add(racecourse_horse_strength_close_terminal)
    end
    init_racecourse_horse_strength_terminal()
end

function RacecourseHorseStrength:lockAll()
    state_machine.lock("racecourse_horse_strength_level_up")
    state_machine.lock("racecourse_horse_strength_add_item")
    state_machine.lock("racecourse_horse_strength_remove_item")
    state_machine.lock("racecourse_horse_strength_select")
end

function RacecourseHorseStrength:unLockAll()
    state_machine.unlock("racecourse_horse_strength_level_up")
    state_machine.unlock("racecourse_horse_strength_add_item")
    state_machine.unlock("racecourse_horse_strength_remove_item")
    state_machine.unlock("racecourse_horse_strength_select")
end

function RacecourseHorseStrength:unsetSelectAll()
    for i,cell in pairs(self.scroll_view:getChildren()) do
        if cell.selected == true then
            cell.selected = false
            cell:setSelected()
        end
    end
end

function RacecourseHorseStrength:setSelectAll()
    for i,cell in pairs(self.scroll_view:getChildren()) do
        for j,spilit_id in pairs(self.select_table_id) do
            if cell.setSelected ~= nil then
                if tonumber(cell.prop.id) == tonumber(spilit_id) then
                    cell.selected = true
                    cell:setSelected() 
                end
            end
        end
    end
end

--自动选择
function RacecourseHorseStrength:autoSelect()
    self:unsetSelectAll()
    self.select_table_id = {}
    local gem_mould_id = self.horse_spilits.mould_id
    local horse_spirit_data = dms.element(dms["horse_spirit_mould"], self.horse_spilits.mould_id)
    local up_need_exp = dms.atoi(horse_spirit_data, horse_spirit_mould.upgrade_cost_exp)
    local now_exp = tonumber(self.horse_spilits.now_exp)
    --当前升级所需经验
    local need_exp = up_need_exp - now_exp
    --如果增加经验大于等于当前升级所需经验停止添加
    local add_exp = 0
    for i,v in pairs(self.user_spilits) do
        table.insert(self.select_table_id,tonumber(v.prop.id))
        add_exp = add_exp + v.exp
        if add_exp >= need_exp then
            break
        end
    end
    self:setSelectAll()
end

--刷新左侧
function RacecourseHorseStrength:onUpdateDrawInfo()
    local root = self.roots[1]
    local mould_id = self.horse_spilits.mould_id
    local horse_spirit_data = dms.element(dms["horse_spirit_mould"], self.horse_spilits.mould_id)
    local up_need_exp = dms.atoi(horse_spirit_data, horse_spirit_mould.upgrade_cost_exp)            --升级消耗经验
    local add_attribute = dms.atos(horse_spirit_data, horse_spirit_mould.attributes)                --属性
    add_attribute = zstring.split(add_attribute,",")
    --属性名
    local text_title = tonumber(add_attribute[1]) + 1
    text_title = attribute[text_title]
    --增加属性值
    local text_str = tonumber(add_attribute[2])
    local is_handred = false
    for i,v in pairs(attribute_hundred) do
        if tonumber(add_attribute[1]) == v then
            is_handred = true
        end
    end
    if is_handred == true then
        text_str = "  +" .. text_str.."%"
    else
        text_str = "  +" .. text_str
    end
    local name = dms.atos(horse_spirit_data, horse_spirit_mould.horse_spirit_name)                  --名称
    local quality = dms.atoi(horse_spirit_data, horse_spirit_mould.quality)                         --品质
    local Panel_treasure_soul_icon = ccui.Helper:seekWidgetByName(root, "Panel_treasure_soul_icon") --附魔icon
    Panel_treasure_soul_icon:removeAllChildren(true)
    local data = 
    {
        item_value = 1,
        prop_type = 36,
        prop_item = self.horse_spilits.mould_id
    }
    local cell = state_machine.excute("all_resource_create_cell", 0, {5, data, self.horse_spilits, 15, 0})
    Panel_treasure_soul_icon:addChild(cell)

    ccui.Helper:seekWidgetByName(root,"Panel_treasure_strength_infor_2"):setVisible(true)
    --附魔名称(根据品质设置颜色)
    local Text_treasure_soul_name = ccui.Helper:seekWidgetByName(root,"Text_treasure_soul_name")
    Text_treasure_soul_name:setString(name)
    Text_treasure_soul_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    --当前附魔经验
    local LoadingBar_treasure_strength = ccui.Helper:seekWidgetByName(root,"LoadingBar_treasure_strength")
    local Text_treasure_strength_loading_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_loading_v")
    local persent = math.floor(tonumber(self.horse_spilits.now_exp) / up_need_exp * 100)
    LoadingBar_treasure_strength:setPercent(persent)
    if up_need_exp > 0 then
        Text_treasure_strength_loading_v:setString(tonumber(self.horse_spilits.now_exp) .. "/" .. up_need_exp)
    else
        Text_treasure_strength_loading_v:setString(tipStringInfo_union_str[70])
    end
    --属性名
    local Text_treasure_strength_infor = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_infor")
    local Text_treasure_strength_infor_up = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_infor_up")
    Text_treasure_strength_infor:setString(text_title)
    Text_treasure_strength_infor_up:setString(text_title)
    --增加属性值
    local Text_treasure_strength_infor_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_infor_v")
    local Text_treasure_strength_infor_up_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_infor_up_v")
    Text_treasure_strength_infor_v:setString(text_str)
    Text_treasure_strength_infor_up_v:setString(text_str)
    --等级
    local Text_treasure_strength_lv_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_lv_v")
    local Text_treasure_strength_lv_up_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_lv_up_v")

    local level = dms.atoi(horse_spirit_data, horse_spirit_mould.level)
    local next_level_id = dms.atoi(horse_spirit_data, horse_spirit_mould.next_level_id)
    Text_treasure_strength_lv_v:setString(""..level)
    --如果附魔未到最大等级显示下一等级
    if next_level_id > 0 then
        Text_treasure_strength_lv_up_v:setString(""..level)
    else --如果附魔达到最大等级隐藏强化后层
        ccui.Helper:seekWidgetByName(root,"Panel_treasure_strength_infor_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_strength"):setVisible(false)
    end
end

--刷新经验
function RacecourseHorseStrength:onUpdateExp()
    local root = self.roots[1]
    --获得经验值
    local get_exp = 0
    for i,spilit_id in pairs(self.select_table_id) do
        local exp = tonumber(_ED.horse_spirits[""..spilit_id].now_exp) + 
            dms.int(dms["horse_spirit_mould"], _ED.horse_spirits[""..spilit_id].mould_id, horse_spirit_mould.make_exp) 
        get_exp = get_exp + exp
    end
    --当前增加属性值
    local add_attribute  = dms.string(dms["horse_spirit_mould"],self.horse_spilits.mould_id,horse_spirit_mould.attributes)
    add_attribute = zstring.split(add_attribute,",")
    local text_str = tonumber(add_attribute[2])
    local is_handred = false
    for i,v in pairs(attribute_hundred) do
        if tonumber(add_attribute[1]) == v then
            is_handred = true
        end
    end
    if is_handred == true then
        text_str = "  +" .. text_str.."%"
    else
        text_str = "  +" .. text_str
    end
    local Text_treasure_strength_infor_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_infor_v")
    Text_treasure_strength_infor_v:setString(text_str)
    --经验值
    local LoadingBar_treasure_strength = ccui.Helper:seekWidgetByName(root,"LoadingBar_treasure_strength")
    local Text_treasure_strength_loading_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_loading_v")
    local up_need_exp = dms.int(dms["horse_spirit_mould"],self.horse_spilits.mould_id,horse_spirit_mould.upgrade_cost_exp)
    local persent = math.min(100,math.floor((tonumber(get_exp)+tonumber(self.horse_spilits.now_exp))/ up_need_exp * 100))
    LoadingBar_treasure_strength:setPercent(persent)
    if up_need_exp > 0 then
        Text_treasure_strength_loading_v:setString(tonumber(get_exp)+tonumber(self.horse_spilits.now_exp) .. "/" .. up_need_exp)
    else
        Text_treasure_strength_loading_v:setString(tipStringInfo_union_str[70])
    end
    local next_mould_id = self:checkLevelUp(get_exp, tonumber(self.horse_spilits.now_exp),tonumber(self.horse_spilits.mould_id))
    --下一级附魔等级
    local next_level = dms.int(dms["horse_spirit_mould"],next_mould_id,horse_spirit_mould.level)
    local Text_treasure_strength_lv_up_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_lv_up_v")
    Text_treasure_strength_lv_up_v:setString(next_level)
    --下一级附魔增加属性
    local add_attribute_next = dms.string(dms["horse_spirit_mould"],next_mould_id,horse_spirit_mould.attributes)
    add_attribute_next = zstring.split(add_attribute_next,",")
    local text_str_next = tonumber(add_attribute_next[2])
    if is_handred == true then
        text_str_next = "  +" .. text_str_next.."%"
    else
        text_str_next = "  +" .. text_str_next
    end
    local Text_treasure_strength_infor_up_v = ccui.Helper:seekWidgetByName(root,"Text_treasure_strength_infor_up_v")
    Text_treasure_strength_infor_up_v:setString(text_str_next)
end

--检测升级状态
function RacecourseHorseStrength:checkLevelUp(get_exp,now_exp,now_mould_id)
    local up_need_exp = dms.int(dms["horse_spirit_mould"],now_mould_id,horse_spirit_mould.upgrade_cost_exp)
    local leave_exp = 0
    --如果获得经验和拥有经验大于等于升级所需经验
    if get_exp + now_exp >= up_need_exp then
        local next_mould_id = dms.int(dms["horse_spirit_mould"],now_mould_id,horse_spirit_mould.next_level_id)
        --如果已达到最大等级返回当前等级id
        if next_mould_id == -1 then
            return now_mould_id
        else --如果未达到最大等级返回剩下经验值下一级附魔id
            leave_exp = get_exp + now_exp - up_need_exp
            return self:checkLevelUp(leave_exp,0,next_mould_id)
        end
    else  --如果获得经验和拥有经验小于升级所需经验返回当前等级id
        return now_mould_id    
    end
end

--初始化附魔列表
function RacecourseHorseStrength:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_treasure_strength = ccui.Helper:seekWidgetByName(root,"ScrollView_treasure_strength")
    ScrollView_treasure_strength:removeAllChildren(true)
    local width = ScrollView_treasure_strength:getContentSize().width
    local height = ScrollView_treasure_strength:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.user_spilits[i]
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
        local v = self.user_spilits[i]
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
            cell = state_machine.excute("all_resource_create_cell",0,{7, v.prop_data, v.prop, 16, height_n})
        end

        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*92))
        ScrollView_treasure_strength:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_treasure_strength:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_treasure_strength:jumpToTop()

    self.scroll_view = ScrollView_treasure_strength
    self.scroll_view_poy = ScrollView_treasure_strength:getInnerContainer():getPositionY()
end

--刷新列表
function RacecourseHorseStrength:onUpdate(dt) 
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

function RacecourseHorseStrength:getAll( )
    local result = {}
    for i,v in pairs(_ED.horse_spirits) do
        if tonumber(v.horse_id) == 0 
            and tonumber(v.id) ~= tonumber(self.horse_spilits.id)
            -- and tonumber(v.mould_id) ~= 702 
            then
            local data = 
            {
                prop_data = 
                {
                    item_value = 1,
                    prop_type = 36,
                    prop_item = v.mould_id,
                },
                prop = v ,
                quality = dms.int(dms["horse_spirit_mould"], v.mould_id, horse_spirit_mould.quality),
                exp = tonumber(v.now_exp) + dms.int(dms["horse_spirit_mould"], v.mould_id, horse_spirit_mould.make_exp)
            }
            table.insert(result, data)
        end
    end

    local function sortType( a, b )
       return tonumber(a.quality) < tonumber(b.quality) or 
              tonumber(a.quality) == tonumber(b.quality) and tonumber(a.exp) < tonumber(b.exp)
    end
    table.sort(result, sortType)    
    self.user_spilits = result
end

--升级播放动画
function RacecourseHorseStrength:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function actionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        -- state_machine.excute("racecourse_horse_strength_update_all")
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

--播放动画
function RacecourseHorseStrength:playBoxActions()
    local root = self.roots[1]
    local Panel_box_effice = ccui.Helper:seekWidgetByName(root,"Panel_box_effice")
    Panel_box_effice:removeAllChildren(true)
    local jsonPath = "images/ui/effice/effice_forging/effice_forging.json"
    local atlasPath = "images/ui/effice/effice_forging/effice_forging.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_box_effice:getContentSize().width/2,Panel_box_effice:getContentSize().height/2))
    Panel_box_effice:addChild(animation)
end

-- 关闭附魔强化界面
function RacecourseHorseStrength:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("racecourse_horse_strength_window_close", 0, "")
        end
    end)
end

function RacecourseHorseStrength:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_soul_strength)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.horse.treasure_soul_strength)
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
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_strength"), nil, 
    {
        terminal_name = "racecourse_horse_strength_level_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "racecourse_horse_strength_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --自动选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_treasure_strength_chose"), nil, 
    {
        terminal_name = "racecourse_horse_strength_select", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDrawInfo()
    self:onUpdateDraw() 
end

function RacecourseHorseStrength:init(params)
    self.horse_spilits = params[1]
    self:getAll()
    self:onInit()
    self:playBoxActions()
    return self
end

function RacecourseHorseStrength:onExit()
    state_machine.remove("racecourse_horse_strength_level_up")
    state_machine.remove("racecourse_horse_strength_update_left")
    state_machine.remove("racecourse_horse_strength_add_item")
    state_machine.remove("racecourse_horse_strength_remove_item")
    state_machine.remove("racecourse_horse_strength_select")
    state_machine.remove("racecourse_horse_strength_update_all")
    state_machine.remove("racecourse_horse_strength_close")
end