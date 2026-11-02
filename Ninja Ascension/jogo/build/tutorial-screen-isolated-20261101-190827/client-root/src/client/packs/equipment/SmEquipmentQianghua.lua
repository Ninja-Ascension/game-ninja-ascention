-- ----------------------------------------------------------------------------------------------------
-- 说明：装备强化界面
-------------------------------------------------------------------------------------------------------
SmEquipmentQianghua = class("SmEquipmentQianghuaClass", Window)

local sm_equipment_qianghua_open_terminal = {
    _name = "sm_equipment_qianghua_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentQianghuaClass")
        if nil == _homeWindow then
            local panel = SmEquipmentQianghua:new():init(params)
            fwin:open(panel)
        end
        if fwin:find("FormationTigerGateClass") ~= nil then
            fwin:find("FormationTigerGateClass"):setVisible(false)
            fwin:find("HeroIconListViewClass"):setVisible(false)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_equipment_qianghua_close_terminal = {
    _name = "sm_equipment_qianghua_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentQianghuaClass")
        if nil ~= _homeWindow then
            if fwin:find("FormationTigerGateClass") ~= nil then
                fwin:find("FormationTigerGateClass"):setVisible(true)
                fwin:find("HeroIconListViewClass"):setVisible(true)
            end
    		fwin:close(fwin:find("SmEquipmentQianghuaClass"))
        end
        state_machine.excute("formation_update_ship_info", 0, {isChange = true})
        --刷新武将列表界面装备推送
        state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
        state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
        --state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_icon")
        state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
        --state_machine.excute("notification_center_update",0,"push_notification_center_formation_replacement_equipment")
        state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
        -- 返回界面刷新装备信息
        state_machine.excute("hero_develop_page_update",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_equipment_qianghua_open_terminal)
state_machine.add(sm_equipment_qianghua_close_terminal)
state_machine.init()
    
function SmEquipmentQianghua:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    self.equipInfo = {}
    self._current_page = 0
    self._qianghua = nil
    self._juexing = nil
    self.oldLv = {}
    app.load("client.packs.equipment.SmEquipmentTabUpProduct")
    app.load("client.packs.equipment.SmEquipmentTabAwakening")
    app.load("client.packs.EquipStorage.SmEquipmentQunenchingHandle")
    app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3Window1")
    app.load("client.cells.ship.hero_icon_list_cell")
    self.equipIconArray = {}

    local function init_sm_equipment_qianghua_terminal()
        -- 显示界面
        local sm_equipment_qianghua_display_terminal = {
            _name = "sm_equipment_qianghua_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmEquipmentQianghuaWindow = fwin:find("SmEquipmentQianghuaClass")
                if SmEquipmentQianghuaWindow ~= nil then
                    SmEquipmentQianghuaWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_equipment_qianghua_hide_terminal = {
            _name = "sm_equipment_qianghua_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmEquipmentQianghuaWindow = fwin:find("SmEquipmentQianghuaClass")
                if SmEquipmentQianghuaWindow ~= nil then
                    SmEquipmentQianghuaWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_equipment_qianghua_change_page_terminal = {
            _name = "sm_equipment_qianghua_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开升品
        local sm_equipment_qianghua_open_up_product_terminal = {
            _name = "sm_equipment_qianghua_open_up_product",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                -- Panel_strengthen_tab:removeAllChildren(true)
                -- state_machine.excute("sm_equipment_qianghua_up_product_open",0,{Panel_strengthen_tab,instance.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        ---点击武将刷新界面
        local sm_equipment_qianghua_update_ship_terminal = {
            _name = "sm_equipment_qianghua_update_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.shipId = params.ship_id
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 刷新
        local sm_equipment_qianghua_update_ship_info_terminal = {
            _name = "sm_equipment_qianghua_update_ship_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance.ship_id = params[1]
                if fwin:find("SmEquipmentTabUpProductClass") ~= nil then
                    state_machine.excute("sm_equipment_tab_up_product_change_ship",0,instance.equipInfo[tonumber(instance.m_index)])
                end

                if fwin:find("SmEquipmentTabAwakeningClass") ~= nil then
                    state_machine.excute("sm_equipment_tab_awakening_change_ship",0,instance.equipInfo[tonumber(instance.m_index)])
                end

                -- 装备淬炼
                if fwin:find("SmEquipmentQianghuaTab3Window1Class") ~= nil then
                    state_machine.excute("sm_equipment_qianghua_tab3_window1_change_ship",0,instance.equipInfo[tonumber(instance.m_index)])
                end
                -- if fwin:find("SmEquipmentQianghuaUpProductClass") ~= nil then
                --     state_machine.excute("sm_equipment_qianghua_up_product_change_ship",0,instance.ship_id)
                -- end
                -- if fwin:find("SmEquipmentQianghuaUpgradeClass") ~= nil then
                --     state_machine.excute("sm_equipment_qianghua_up_grade_change_ship",0,instance.ship_id)
                -- end
                -- if fwin:find("SmEquipmentQianghuaRisingStarClass") ~= nil then
                --     state_machine.excute("sm_equipment_qianghua_rising_star_change_ship",0,instance.ship_id)
                -- end
                -- instance:onUpdateDraw()
                -- local m_type = tonumber(params[2])
                -- if m_type ~= nil then
                --     if m_type == 1 then
                --         state_machine.excute("sm_equipment_qianghua_up_product_update_draw",0,"")
                --     elseif m_type == 2 then
                --         state_machine.excute("sm_equipment_qianghua_up_grade_update_draw",0,"")
                --     elseif m_type == 3 then
                --         state_machine.excute("sm_equipment_qianghua_rising_star_update_draw",0,"")
                --     end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        ---设置头像高亮
        local sm_equipment_qianghua_to_highlighted_terminal = {
            _name = "sm_equipment_qianghua_to_highlighted",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setIndex(params)
                state_machine.excute("sm_equipment_qianghua_to_select",0,{_datas = {index = instance.m_index}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        ---设置
        local sm_equipment_qianghua_to_select_terminal = {
            _name = "sm_equipment_qianghua_to_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if index < 5 then
                        if funOpenDrawTip(96) == true then
                            return
                        end
                    else
                        if funOpenDrawTip(159) == true then
                            return
                        end
                    end
                end
                instance.m_index = index
                for i=1, 6 do
                    ccui.Helper:seekWidgetByName(self.roots[1], "Image_equ_props_hook_"..i):setVisible(false)
                end
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_equ_props_hook_"..index):setVisible(true)
                --刷新强化或者其他界面
                if fwin:find("SmEquipmentTabUpProductClass") ~= nil then
                    state_machine.excute("sm_equipment_tab_up_product_change_ship",0,instance.equipInfo[tonumber(index)])
                end

                if fwin:find("SmEquipmentTabAwakeningClass") ~= nil then
                    state_machine.excute("sm_equipment_tab_awakening_change_ship",0,instance.equipInfo[tonumber(index)])
                end

                -- 淬炼刷新
                if fwin:find("SmEquipmentQianghuaTab3Window1Class") ~= nil then
                    state_machine.excute("sm_equipment_qianghua_tab3_window1_change_ship",0,instance.equipInfo[tonumber(index)])
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- ---打开强化
        -- local sm_equipment_qianghua_to_open_strengthen_terminal = {
        --     _name = "sm_equipment_qianghua_to_open_strengthen",
        --     _init = function (terminal) 
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         local Panel_equ_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_equ_tab")
        --         state_machine.excute("sm_equipment_tab_up_product_open",0,{Panel_equ_tab})
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- } 

        ---刷新界面
        local sm_equipment_qianghua_to_update_equip_icon_terminal = {
            _name = "sm_equipment_qianghua_to_update_equip_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params~= nil then
                    instance:drawEquipIcon(params)
                else
                    instance:drawEquipIcon()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --刷新等级
        local sm_equipment_qianghua_to_update_lv_terminal = {
            _name = "sm_equipment_qianghua_to_update_lv",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = tonumber(params[1])
                local lv = tonumber(params[2])
                local Text_equ_up_lv_ = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_up_lv_"..index)
                Text_equ_up_lv_:setString("+"..lv)
                self.oldLv[index] = lv
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新头像推送
        local sm_equipment_qianghua_update_hero_icon_push_terminal = {
            _name = "sm_equipment_qianghua_update_hero_icon_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_qianghua_line")
                local items = listView:getItems()
                for i , v in pairs(items) do
                    state_machine.excute("hero_icon_list_cell_equip_strength_hero_icon_push_updata",0,v)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新装备推送
        local sm_equipment_qianghua_update_equip_icon_push_terminal = {
            _name = "sm_equipment_qianghua_update_equip_icon_push",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.equipIconArray ~= nil then
                    for i ,v in pairs(instance.equipIconArray) do
                        state_machine.excute("equip_icon_cell_update_push",0,v)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭并打开进阶
        local sm_equipment_qianghua_open_hero_devolop_terminal = {
            _name = "sm_equipment_qianghua_open_hero_devolop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("HeroDevelopClass") == nil then
                    local ship = _ED.user_ship[""..instance.shipId]
                    instance:openHeroDevelop(ship,0)
                else
                    local features_1_id = 0
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        features_1_id = 100
                    else
                        features_1_id = 33
                    end
                    local terminal = state_machine.find("hero_develop_page_manager")
                    
                    state_machine.excute("sm_role_strengthen_tab_up_product_close",0,{})
                    terminal.last_terminal_name = nil
                    state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = "hero_develop_page_open_strengthen_page",           
                    current_button_name = "Button_shengji",     
                    but_image = "",     
                    shipId = instance.shipId,
                    terminal_state = 0, 
                    openWinId = features_1_id,
                    isPressedActionEnabled = true}})
                end
                state_machine.excute("sm_equipment_qianghua_close",0,{})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_equipment_qianghua_display_terminal)
        state_machine.add(sm_equipment_qianghua_hide_terminal)
        state_machine.add(sm_equipment_qianghua_open_up_product_terminal)
        state_machine.add(sm_equipment_qianghua_update_ship_info_terminal)
        state_machine.add(sm_equipment_qianghua_update_ship_terminal)
        state_machine.add(sm_equipment_qianghua_to_highlighted_terminal)
        state_machine.add(sm_equipment_qianghua_to_select_terminal)
        -- state_machine.add(sm_equipment_qianghua_to_open_strengthen_terminal)
        state_machine.add(sm_equipment_qianghua_to_update_equip_icon_terminal)
        state_machine.add(sm_equipment_qianghua_change_page_terminal)
        state_machine.add(sm_equipment_qianghua_to_update_lv_terminal)
        state_machine.add(sm_equipment_qianghua_update_hero_icon_push_terminal)
        state_machine.add(sm_equipment_qianghua_update_equip_icon_push_terminal)
        state_machine.add(sm_equipment_qianghua_open_hero_devolop_terminal)

        
        state_machine.init()
    end
    init_sm_equipment_qianghua_terminal()
end

function SmEquipmentQianghua:openHeroDevelop(ship,m_type)
    enter_type = "learn"
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        if fwin:find("HeroIconListViewClass") == nil then
            app.load("client.packs.hero.HeroIconListView")
            state_machine.excute("hero_icon_listview_open",0,ship)
            fwin:find("HeroIconListViewClass"):setVisible(false)
        end
    end
    app.load("client.packs.hero.HeroDevelop")
    if fwin:find("HeroDevelopClass") ~= nil then
        state_machine.excute("formation_set_ship",0,ship)
        return
        -- fwin:close(fwin:find("HeroDevelopClass"))
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        state_machine.excute("hero_storage_return_home_page",0,"")
        _ED.ship_warehouse_enter = true
    end
    local heroDevelopWindow = HeroDevelop:new()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        ship.shengming = zstring.tonumber(ship.ship_health)
        ship.gongji = zstring.tonumber(ship.ship_courage)
        ship.waigong = zstring.tonumber(ship.ship_intellect)
        ship.neigong = zstring.tonumber(ship.ship_quick)
    end
    -- print("=======11=====",enter_type)
    if enter_type ~= "learn" and enter_type ~= "pack" then
        enter_type = "formation"
    end
    for i,v in pairs(_ED.user_formetion_status) do
        if zstring.tonumber(v) == tonumber(ship.ship_id) then
            enter_type = "formation"
        end
    end
    heroDevelopWindow:init(ship.ship_id, "pack",m_type)
    fwin:open(heroDevelopWindow, fwin._view)


    
    -- fwin:close(fwin:find("HeroListViewClass"))
    -- fwin:close(fwin:find("HeroStorageClass"))
end

function SmEquipmentQianghua:setIndex(cell)
    if self.lastcell ~= nil then
        self.lastcell.ishow = false
        self.lastcell:setSelected(false)
    end
    cell:setSelected(true)
    cell.ishow = true
    self.lastcell = cell
end

function SmEquipmentQianghua:firstIconIndex(ship)
    --todo 设置第一次的底框 和listvew位置
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_qianghua_line")
    local items = listView:getItems()
    local index = 1
    local itemsnumber = #items
    local height = 0
    for i,v in pairs(items) do
        if v.ship == ship then
            v:setSelected(true)
            v.ishow = true
            self.lastcell = v
            index = i 
            height = v:getContentSize().height
            break
        end
    end
    -- listView:getInnerContainer():setPositionY((index-1)*height)
end

function SmEquipmentQianghua:getSortedHeroes()
    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end
    --上阵
    local tSortedHeroes = {}
    --未上阵
    local arrBusyHeroes = {}
    --全部
    local allHeroes = {}
    for j, q in pairs(_ED.user_ship) do
        if zstring.tonumber(q.formation_index) > 0 then
            table.insert(tSortedHeroes, q)
        else
            table.insert(arrBusyHeroes, q)
        end
    end 
    table.sort(tSortedHeroes, fightingCapacity)
    table.sort(arrBusyHeroes, fightingCapacity)
    for i=1, #tSortedHeroes do
        table.insert(allHeroes, tSortedHeroes[i])
    end

    if __lua_project_id == __lua_project_l_naruto
        then
        if self._isPacks == true then
            for i=1, #arrBusyHeroes do
                table.insert(allHeroes, arrBusyHeroes[i])
            end
        end
    else
        for i=1, #arrBusyHeroes do
            table.insert(allHeroes, arrBusyHeroes[i])
        end
    end

    return allHeroes
end

function SmEquipmentQianghua:shipListDraw()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_qianghua_line")
    listView:removeAllItems()
    local addmouldId = {}
    local push_type = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        push_type = 3
    end
    for i, v in pairs(self:getSortedHeroes()) do
        local cell = HeroIconListCell:createCell()
        if zstring.tonumber(v.formation_index) > 0 then
            cell:init(v, i,true,1 ,push_type)
        else
            cell:init(v, i,false,1 ,push_type)
        end
        if #addmouldId == 0 then
            table.insert(addmouldId, v.ship_template_id)
            -- cell.roots[1]:setPositionY(-15)
            listView:addChild(cell)
        else
            local isAdd = true
            for j,q in pairs(addmouldId) do
                if tonumber(v.ship_template_id) == tonumber(q) then
                    isAdd = false
                end
            end
            if isAdd == true then
                table.insert(addmouldId, v.ship_template_id)
                -- cell.roots[1]:setPositionY(-15)
                listView:addChild(cell)
            end
        end
        
    end
    listView:requestRefreshView()
    self:firstIconIndex(fundShipWidthId(self.shipId))
end

function SmEquipmentQianghua:changeSelectPage( page )
    local root = self.roots[1]
    if root == nil then 
        return
    end

    -- 装备淬炼是否开启
    if self.Button_cuilian then 
        self.Button_rule:setVisible(false)
        if funOpenDrawTip(198,false) then 
            self.Button_cuilian:setVisible(false)
        else
            self.Button_cuilian:setVisible(true)
        end
    end
    local Panel_equ_tab = ccui.Helper:seekWidgetByName(root,"Panel_equ_tab")
    local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
    local Button_juexing = ccui.Helper:seekWidgetByName(root, "Button_juexing")
    local Button_cuilian = ccui.Helper:seekWidgetByName(root, "Button_cuilian")
    if page == self._current_page then
        if page == 1 then
            Button_qianghua:setHighlighted(true)
        elseif page == 2 then
            Button_juexing:setHighlighted(true)
        elseif page == 3 then 
            Button_cuilian:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_qianghua:setHighlighted(false)
    Button_juexing:setHighlighted(false)
    Button_cuilian:setHighlighted(false)
    self.Image_24_0:setVisible(false)
    self.Image_24_0_0:setVisible(false)
    state_machine.excute("sm_equipment_tab_up_product_hide", 0, nil)
    state_machine.excute("sm_equipment_tab_awakening_hide", 0, nil)
    state_machine.excute("sm_equipment_qianghua_tab3_window1_hide", 0, nil)
    if page == 1 then
        Button_qianghua:setHighlighted(true)
        Button_qianghua:setTouchEnabled(false)
        Button_juexing:setTouchEnabled(true)
        Button_cuilian:setTouchEnabled(true)
        self.Image_24_0:setVisible(true)
        if self._qianghua == nil then
            self._qianghua = state_machine.excute("sm_equipment_tab_up_product_open", 0, {Panel_equ_tab})
        else
            state_machine.excute("sm_equipment_tab_up_product_display", 0, nil)
        end
        state_machine.excute("sm_equipment_qianghua_to_select",0,{_datas = {index = self.m_index}})
    elseif page == 2 then
        Button_juexing:setHighlighted(true)
        Button_juexing:setTouchEnabled(false)
        Button_qianghua:setTouchEnabled(true)
        Button_cuilian:setTouchEnabled(true)
        self.Image_24_0:setVisible(true)
         if self._juexing == nil then
            self._juexing = state_machine.excute("sm_equipment_tab_awakening_open", 0, {Panel_equ_tab})
        else
            state_machine.excute("sm_equipment_tab_awakening_display", 0, nil)
        end
        state_machine.excute("sm_equipment_qianghua_to_select",0,{_datas = {index = self.m_index}})      
    elseif page == 3 then   --装备淬炼
        Button_cuilian:setHighlighted(true)
        Button_cuilian:setTouchEnabled(false)
        Button_juexing:setTouchEnabled(true)
        Button_qianghua:setTouchEnabled(true)
        self.Image_24_0_0:setVisible(true)
        self.Button_rule:setVisible(true)
         if self._cuilian == nil then
            self._cuilian = state_machine.excute("sm_equipment_qianghua_tab3_window1_window_open", 0, {Panel_equ_tab})
        else
            state_machine.excute("sm_equipment_qianghua_tab3_window1_show", 0, nil)
        end
        state_machine.excute("sm_equipment_qianghua_to_select",0,{_datas = {index = self.m_index}}) 
    end 
    -- 装备淬炼推送
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening_page_tips")
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_up_grade_page_tips")
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips") 
end

function SmEquipmentQianghua:drawEquipIcon(m_index)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.equipInfo = {}
    local shipInfo = _ED.user_ship[""..self.shipId]
    --武将装备数据（等级|品质|经验|星级|模板）
    local shipEquip = zstring.split(shipInfo.equipInfo, "|")
    --初始装备
    local equipAll = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.treasureSkill)
    local equipData = zstring.split(shipEquip[5], ",")
    local equipStar = zstring.split(shipEquip[4], ",")

    for i=1, 6 do
        --装备图标
        local Panel_equ_up_quality_box = ccui.Helper:seekWidgetByName(root, "Panel_equ_up_quality_box_"..i)
        Panel_equ_up_quality_box:removeAllChildren(true)
        local equipMouldId = equipData[i]
        local equip = {}
        --装备模板id
        if tonumber(equipStar[i]) == 0 then
            local equipMouldData = zstring.split(equipAll, ",")
            equip.user_equiment_template = equipMouldData[i]
        else
            equip.user_equiment_template = equipMouldId
        end
        --装备等级
        local equipLevelData = zstring.split(shipEquip[1], ",")
        equip.user_equiment_grade = equipLevelData[i]
        --所属战船
        equip.ship_id = shipInfo.ship_id
        --所属编号
        equip.m_index = i
        equip.isShowLv = false
        local cell = self:createEquipHead(1,equip)

        if cell and cell.roots and cell.roots[1] then
            local Panel_prop = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
            Panel_prop:setTouchEnabled(false)
        end

        Panel_equ_up_quality_box:addChild(cell)
        self.equipIconArray[i] = cell
        -- DSC重塑不进行坐标偏移
        if __lua_project_id == __lua_project_l_digital then

        else
            cell:setPosition(cell:getPositionX()-8,cell:getPositionY()-6)
        end
        local starts = zstring.split(shipEquip[4], ",")
        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), tonumber(starts[tonumber(i)]))
        --等级
        local Text_equ_up_lv = ccui.Helper:seekWidgetByName(root, "Text_equ_up_lv_"..i)
        if m_index == nil then
            self.oldLv[i] = equipLevelData[i]
            Text_equ_up_lv:setString("+"..equipLevelData[i])
        end

        --可以升级
        local Panel_arrow = ccui.Helper:seekWidgetByName(root, "Panel_arrow_"..i)
        Panel_arrow:setVisible(false)
        --判断最高可以升到多少级
        local newGrade = zstring.split(shipEquip[2], ",")
        local maxLvData = nil
        if i > 4 then
            maxLvData = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.id, tonumber(newGrade[i])+1)
        else
            maxLvData = dms.searchs(dms["equipment_level_param"], equipment_level_param.is_up_product, 1)
        end
        local maxLv = 0
        for j=1, #maxLvData do
            if i > 4 then
                if tonumber(equipLevelData[i]) <= tonumber(maxLvData[j][2]) then
                    maxLv = tonumber(maxLvData[j][2])
                    break
                end
            else
                if tonumber(equipLevelData[i]) <= tonumber(maxLvData[j][2]) and tonumber(newGrade[i]) <= tonumber(maxLvData[j][13]) then
                    maxLv = tonumber(maxLvData[j][2])
                    break
                end
            end
        end
        --暂时屏蔽
        -- if tonumber(equipLevelData[i]) < tonumber(maxLv) then
        --     Panel_arrow:setVisible(true)
        -- end

        self.equipInfo[i] = equip
    end
end


function SmEquipmentQianghua:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.shipId]
    --画人物
    local Panel_hero_110 = ccui.Helper:seekWidgetByName(root, "Panel_hero_110")
    Panel_hero_110:removeAllChildren(true)
    
    local quality = dms.int(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.ship_type)
    ----------------------新的数码的形象------------------------    
    --进化模板id
    local evo_mould_id = smGetSkinEvoIdChange(shipInfo)
    --新的形象编号
    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    
    draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_hero_110, nil, nil, cc.p(0.5, 0))
    local armature_hero = sp.spine_sprite(Panel_hero_110, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    armature_hero:setScaleX(-1)
    self.armature_hero = armature_hero
    armature_hero.animationNameList = spineAnimations
    sp.initArmature(self.armature_hero, true)

    --攻防技
    local Panel_role_stye = ccui.Helper:seekWidgetByName(root, "Panel_role_stye")
    Panel_role_stye:removeBackGroundImage()
    local camp_preference = dms.int(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_role_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end
    --名称
    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local getPersonName = word_info[3]
    if getShipNameOrder(tonumber(shipInfo.Order)) > 0 then
        Text_role_name:setString(getPersonName.." +"..getShipNameOrder(tonumber(shipInfo.Order)))
    else
        Text_role_name:setString(getPersonName)
    end

    local quality = 1
    quality = shipOrEquipSetColour(tonumber(shipInfo.Order))
    local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    Text_role_name:setColor(cc.c3b(color_R, color_G, color_B))

    local Button_juexing = ccui.Helper:seekWidgetByName(root, "Button_juexing")
    Button_juexing:setVisible(true)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        if funOpenDrawTip(99,false) == true then
            Button_juexing:setVisible(false)
        end
    end
    self:drawEquipIcon()
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment_up_grade_page_tips",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_qianghua"),
    _invoke = nil,
    _interval = 0.5,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment_awakening_page_tips",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_juexing"),
    _invoke = nil,
    _interval = 0.5,})
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_up_grade_page_tips")
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening_page_tips")

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment_harden_page_tips",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_cuilian"),
    _invoke = nil,
    _interval = 0.5,})
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips")

end

function SmEquipmentQianghua:createEquipHead(objectType,ship)
    local cell = EquipIconCell:createCell()
    cell:init(objectType,ship)
    return cell
end


function SmEquipmentQianghua:init(params)
    self.shipId = params.ship_id
    self.m_index = params.m_index
    self._isPacks = false
    if params.isPacks ~= nil and params.isPacks == true then
        self._isPacks = true
    end
    self:onInit()
    return self
end

function SmEquipmentQianghua:onInit()
    local csbSmEquipmentQianghua = csb.createNode("packs/EquipStorage/sm_equipment_qianghua.csb")
    local root = csbSmEquipmentQianghua:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmEquipmentQianghua)
    

    self.Button_cuilian = ccui.Helper:seekWidgetByName(root,"Button_cuilian")
    if self.Button_cuilian then
        -- 打开淬炼
        self.Button_cuilian:setVisible(false)
        local isOpen  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 198, fun_open_condition.level)
        if isOpen then 
            self.Button_cuilian:setVisible(true)
        end
        fwin:addTouchEventListener(self.Button_cuilian, nil, 
        {
            terminal_name = "sm_equipment_qianghua_change_page",
            terminal_state = 0,
            _page = 3,
            touch_black = true,
        },
        nil,0)
    end

    self.Image_24_0 = ccui.Helper:seekWidgetByName(root,"Image_24_0")

    self.Image_24_0_0 = ccui.Helper:seekWidgetByName(root,"Image_24_0_0")


    self:onUpdateDraw()
    self:shipListDraw()
    
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_qianghua_back"), nil, 
    {
        terminal_name = "sm_equipment_qianghua_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 打开强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_qianghua"), nil, 
    {
        terminal_name = "sm_equipment_qianghua_change_page",
        terminal_state = 0,
        _page = 1,
        touch_black = true,
    },
    nil,0)

    -- 打开觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_juexing"), nil, 
    {
        terminal_name = "sm_equipment_qianghua_change_page",
        terminal_state = 0,
        _page = 2,
        touch_black = true,
    },
    nil,0)

    -- 跳转到进阶
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jingjie"), nil, 
    {
        terminal_name = "sm_equipment_qianghua_open_hero_devolop",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil,0)
    
    --选择
    for i=1,6 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equ_up_quality_icon_"..i), nil, 
        {
            terminal_name = "sm_equipment_qianghua_to_select",
            terminal_state = 0,
            index = i,
            touch_black = true,
        },
        nil,0)
    end

    -- 规则按钮
    self.Button_rule = ccui.Helper:seekWidgetByName(root, "Button_rule")
    if self.Button_rule then 
        self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil,
        {
            terminal_name = "equipment_qunenching_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true,
        }, nil, 0)	
    end
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    -- {
        -- terminal_name = "red_alert_time_mine_help_info_close",
        -- terminal_state = 0,
    -- },
    -- nil,3)
	self:changeSelectPage(1)
end

function SmEquipmentQianghua:onExit()
    state_machine.remove("sm_equipment_qianghua_display")
    state_machine.remove("sm_equipment_qianghua_hide")
    state_machine.remove("sm_equipment_qianghua_change_page")
    state_machine.remove("sm_equipment_qianghua_open_up_product")
    state_machine.remove("sm_equipment_qianghua_update_ship_info")
    state_machine.remove("sm_equipment_qianghua_update_ship")
    state_machine.remove("sm_equipment_qianghua_to_highlighted")
    state_machine.remove("sm_equipment_qianghua_to_select")
    state_machine.remove("sm_equipment_qianghua_to_update_equip_icon")
    state_machine.remove("sm_equipment_qianghua_update_hero_icon_push")
    state_machine.remove("sm_equipment_qianghua_update_equip_icon_push")
    state_machine.remove("sm_equipment_qianghua_to_update_lv")
end