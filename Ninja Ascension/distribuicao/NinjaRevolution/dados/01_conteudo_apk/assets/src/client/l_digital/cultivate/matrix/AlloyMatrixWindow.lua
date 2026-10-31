-----------------------------
-- 合金矩阵主界面
-----------------------------
AlloyMatrixWindow = class("AlloyMatrixWindowClass", Window)

local alloy_matrix_window_open_terminal = {
	_name = "alloy_matrix_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if true == funOpenDrawTip(126) then
            return
        end
        if fwin:find("AlloyMatrixWindowClass") == nil then
            fwin:open(AlloyMatrixWindow:new():init(params), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_window_close_terminal = {
	_name = "alloy_matrixn_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local _self = params._datas._self
        if fwin:find("HeroDevelopClass") ~= nil then
            state_machine.excute("hero_develop_page_strength_to_update_ship", 0, 1)
        else
            for i, v in pairs(_ED.user_formetion_status) do
                if _self.default_ship and tonumber(v) == tonumber(_self.default_ship.ship_id) then
                    state_machine.excute("formation_set_ship", 0, 1)
                    break
                end
            end
        end
		fwin:close(fwin:find("AlloyMatrixWindowClass"))
        fwin:close(fwin:find("AlloyMatrixTopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_window_open_terminal)
state_machine.add(alloy_matrix_window_close_terminal)
state_machine.init()

function AlloyMatrixWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentIndex = 1

    self._choose_ship = nil

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixInformation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixStrengthenOne")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixGetReword")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFusion")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixTop")
    app.load("client.packs.hero.HeroDevelop")
    app.load("client.formation.FormationTigerGate") 

    
    app.load("client.cells.ship.hero_icon_list_cell")
    
    local function init_alloy_matrix_terminal()
        local alloy_matrix_ship_choose_terminal = {
            _name = "alloy_matrix_ship_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setIndex(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_tab_change_terminal = {
            _name = "alloy_matrix_tab_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local chooseIndex = params._datas._index

                local lock_levels = zstring.split(dms.string(dms["ship_config"], 39, ship_config.param), "!")[chooseIndex]
                local lock_level = zstring.splits(lock_levels, "|", ":")
                if tonumber(lock_level[1][2]) > tonumber(_ED.user_info.user_grade) then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_alloy_matrix_tips[12], tonumber(lock_level[1][2])))
                    return
                end
                instance.currentIndex = chooseIndex
                instance:changeTabViewShow(chooseIndex)
                state_machine.excute("alloy_matrix_strengthen_one_show_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_ship_update_terminal = {
            _name = "alloy_matrix_ship_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._choose_ship = params
                    instance:onUpdateDraw()
                    instance:changeTabViewShow(instance.currentIndex)
                    -- Cartel de "+N poder", igual que Growth, artefacto, cartas e
                    -- ilustracion. Este terminal es el punto comun por el que pasan
                    -- TODAS las respuestas que cambian el poder en la matriz
                    -- (equipar, quitar todo, colocar desde fusion y reforzar todo),
                    -- asi que basta llamarlo aqui. El toque que solo cambia de heroe
                    -- (hero_icon_list_cell) tambien entra, pero no altera el poder y
                    -- smFightingChange no hace nada si el valor no ha cambiado.
                    smFightingChange()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local open_constellation_rank_terminal = {
            _name = "alloy_matrix_redot_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateHjcqRedot()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- local alloy_matrix_ship_redot_update_terminal = {
        --     _name = "alloy_matrix_ship_redot_update",
        --     _init = function (terminal)
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         instance:showShipRedot()
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }

        state_machine.add(alloy_matrix_ship_choose_terminal)
        state_machine.add(alloy_matrix_tab_change_terminal)
        state_machine.add(alloy_matrix_ship_update_terminal)
        state_machine.add(open_constellation_rank_terminal)
        -- state_machine.add(alloy_matrix_ship_redot_update_terminal)
        state_machine.init()
    end
    init_alloy_matrix_terminal()
end

function AlloyMatrixWindow:updateHjcqRedot(  )
    local root = self.roots[1]
    local Image_hjcq_tip = ccui.Helper:seekWidgetByName(root, "Image_hjcq_tip")
    if tonumber(_ED.alloy_matrix_recruit.goldFreeNum) == 1 or tonumber(_ED.alloy_matrix_recruit.diamonFreeNum) == 1 then
        Image_hjcq_tip:setVisible(true)
    else
        Image_hjcq_tip:setVisible(false)
    end
end

function AlloyMatrixWindow:changeTabViewShow( chooseIndex )
    local root = self.roots[1]
    local Button_alloy_primary = ccui.Helper:seekWidgetByName(root,"Button_alloy_primary")
    local Button_alloy_middle = ccui.Helper:seekWidgetByName(root,"Button_alloy_middle")
    local Button_alloy_high = ccui.Helper:seekWidgetByName(root,"Button_alloy_high")
    local Panel_alloy_matrix_famation_box = ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_famation_box")
    Panel_alloy_matrix_famation_box:removeAllChildren(true)

    if chooseIndex == 1 then
        Button_alloy_primary:setHighlighted(true)
        Button_alloy_primary:setTouchEnabled(false)

        Button_alloy_middle:setHighlighted(false)
        Button_alloy_middle:setTouchEnabled(true)

        Button_alloy_high:setHighlighted(false)
        Button_alloy_high:setTouchEnabled(true)
    elseif chooseIndex == 2 then
        Button_alloy_primary:setHighlighted(false)
        Button_alloy_primary:setTouchEnabled(true)

        Button_alloy_middle:setHighlighted(true)
        Button_alloy_middle:setTouchEnabled(false)

        Button_alloy_high:setHighlighted(false)
        Button_alloy_high:setTouchEnabled(true)
    else
        Button_alloy_primary:setHighlighted(false)
        Button_alloy_primary:setTouchEnabled(true)

        Button_alloy_middle:setHighlighted(false)
        Button_alloy_middle:setTouchEnabled(true)

        Button_alloy_high:setHighlighted(true)
        Button_alloy_high:setTouchEnabled(false)
    end
    self.currentIndex = chooseIndex
    local panel_cell = AlloyMatrixFormation:createCell()
    panel_cell:init(chooseIndex, self._choose_ship, 1)
    Panel_alloy_matrix_famation_box:addChild(panel_cell)
    state_machine.excute("alloy_matrix_information_update", 0, self.currentIndex)
end

function AlloyMatrixWindow:onUpdateDraw()
    local root = self.roots[1]
    self:updateHjcqRedot()

    self:showShipRedot()
    --红点和锁
    local Button_alloy_primary = ccui.Helper:seekWidgetByName(root, "Button_alloy_primary")
    local Button_alloy_middle = ccui.Helper:seekWidgetByName(root, "Button_alloy_middle")
    local Button_alloy_high = ccui.Helper:seekWidgetByName(root, "Button_alloy_high")

    local Image_cjjz_tip_0 = ccui.Helper:seekWidgetByName(root, "Image_cjjz_tip_0")
    local Image_zjjz_tip_0_0 = ccui.Helper:seekWidgetByName(root, "Image_zjjz_tip_0_0")
    local Image_gjjz_tip_0_1 = ccui.Helper:seekWidgetByName(root, "Image_gjjz_tip_0_1")

    local Image_1_0_0_0 = ccui.Helper:seekWidgetByName(root, "Image_1_0_0_0")
    local Image_1_0 = ccui.Helper:seekWidgetByName(root, "Image_1_0")
    local Image_1_0_0 = ccui.Helper:seekWidgetByName(root, "Image_1_0_0")

    local all_btn = {Button_alloy_primary, Button_alloy_middle, Button_alloy_high}
    local all_red = {Image_cjjz_tip_0, Image_zjjz_tip_0_0, Image_gjjz_tip_0_1}
    local all_lock = {Image_1_0_0_0, Image_1_0, Image_1_0_0}

    for i,btn in ipairs(all_btn) do
        local lock_levels = zstring.split(dms.string(dms["ship_config"], 39, ship_config.param), "!")[i]
        local lock_level = zstring.splits(lock_levels, "|", ":")
        --锁
        if tonumber(lock_level[1][2]) > tonumber(_ED.user_info.user_grade) then
            --锁
            all_lock[i]:setVisible(true)
        else
            --不锁
            all_lock[i]:setVisible(false)
        end

        --红点
        local have = 0
        local use = 0
        for k,v in ipairs(lock_level) do
            if tonumber(lock_level[k][2]) <= tonumber(_ED.user_info.user_grade) then
                have = have + 1
            end
        end
        local alloyMatrix = _ED.user_ship[self._choose_ship.ship_id].alloyMatrix
        if alloyMatrix and alloyMatrix.mmi[i .. ""] then
            use = table.nums(alloyMatrix.mmi[i .. ""])
        end
        if use < have then
            --有红点
            all_red[i]:setVisible(true)
        else
            --没有红点
            all_red[i]:setVisible(false)
        end
    end


    local Text_alloy_name = ccui.Helper:seekWidgetByName(root, "Text_alloy_name")
    local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
    local Panel_alloy_attr_infor_box = ccui.Helper:seekWidgetByName(root, "Panel_alloy_attr_infor_box")
    Panel_alloy_attr_infor_box:removeAllChildren(true)

    local info_cell = AlloyMatrixInformation:createCell()
    info_cell:init(self._choose_ship, self.currentIndex)
    info_cell:setVisible(true)
    info_cell:setLocalZOrder(1)
    Panel_alloy_attr_infor_box:addChild(info_cell)

    local strengthen_cell =  AlloyMatrixStrengthenOne:createCell()
    strengthen_cell:init(self._choose_ship, self.currentIndex)
    strengthen_cell:setVisible(false)
    strengthen_cell:setLocalZOrder(2)
    Panel_alloy_attr_infor_box:addChild(strengthen_cell)

    Panel_strengthen_stye:removeBackGroundImage()
    local camp_preference = dms.int(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end

    local evo_mould_id = smGetSkinEvoIdChange(self._choose_ship)
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]
    if getShipNameOrder(tonumber(self._choose_ship.Order)) > 0 then
        name = name.." +"..getShipNameOrder(tonumber(self._choose_ship.Order))
    end
    Text_alloy_name:setString(name)
    local quality = shipOrEquipSetColour(tonumber(self._choose_ship.Order))
    local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    Text_alloy_name:setColor(cc.c3b(color_R, color_G, color_B))
end

function AlloyMatrixWindow:updateIconList()
    local function fightingCapacity(a,b)
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end

    local tSortedHeroes = {}
    local arrBusyHeroes = {}
    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            if zstring.tonumber(ship.formation_index) > 0 then
                table.insert(arrBusyHeroes, ship)
            else
                table.insert(tSortedHeroes, ship)
            end
        end
    end

    table.sort(arrBusyHeroes, fightingCapacity)
    table.sort(tSortedHeroes, fightingCapacity)
    local root = self.roots[1]
    local ListView_list = ccui.Helper:seekWidgetByName(root, "ListView_alloy_role_icon")
    ListView_list:removeAllItems()

    local index = 0
    local temp_ship = nil 
    for k,v in pairs(arrBusyHeroes) do
        index = index + 1
        if index == 1 then temp_ship = v end
        local cell = HeroIconListCell:createCell()
        cell.ship = v
        cell:init(v, index, true, 101, false, true)
        ListView_list:addChild(cell)
    end

    for k,v in pairs(tSortedHeroes) do
        index = index + 1
        local cell = HeroIconListCell:createCell()
        cell.ship = v
        cell:init(v, index, false, 101, false, true)
        ListView_list:addChild(cell)
    end

    ListView_list:refreshView()
    self.ship_list = ListView_list

    for i, item in pairs(self.ship_list:getItems()) do
        local ball = cc.Sprite:create("images/ui/bar/tips.png")
        ball:setAnchorPoint(cc.p(1, 1))
        ball:setName("ball")
        ball:setPosition(cc.p(item:getContentSize().width-ball:getContentSize().width*0.5 - 5, item:getContentSize().height-ball:getContentSize().height*0.5))
        item:addChild(ball)
    end

    if not self._choose_ship and temp_ship then self._choose_ship = temp_ship end
    self:firstIconIndex(self._choose_ship)
end

function AlloyMatrixWindow:showShipRedot()
    function isShowRedot( ship )
        for i=1,3 do
            local lock_levels = zstring.split(dms.string(dms["ship_config"], 39, ship_config.param), "!")[i]
            local lock_level = zstring.splits(lock_levels, "|", ":")
            local have = 0
            local use = 0
            for k,v in ipairs(lock_level) do
                if tonumber(lock_level[k][2]) <= tonumber(_ED.user_info.user_grade) then
                    have = have + 1
                end
            end
            local alloyMatrix = _ED.user_ship[ship.ship_id].alloyMatrix
            if alloyMatrix and alloyMatrix.mmi and alloyMatrix.mmi[i .. ""] then
                use = table.nums(alloyMatrix.mmi[i .. ""])
            end
            if use < have then
                return true
            end
        end
        return false
    end

    for i, item in pairs(self.ship_list:getItems()) do
        if item and item:getChildByName("ball") then
            item:getChildByName("ball"):setVisible(isShowRedot(item.ship))
        end
    end
end

function AlloyMatrixWindow:setIndex(cell)
    if self.lastcell ~= nil then
        self.lastcell.ishow = false
        if self.lastcell.setSelected ~= nil then
            self.lastcell:setSelected(false)
        end
    end
    cell:setSelected(true)
    cell.ishow = true
    self.lastcell = cell
end

function AlloyMatrixWindow:firstIconIndex(ship)
    local root = self.roots[1]
    local ListView_list = ccui.Helper:seekWidgetByName(root, "ListView_alloy_role_icon")
    local index = 1
    local height = 0
    for i,v in pairs(ListView_list:getItems()) do
        if v.ship.ship_id == ship.ship_id then
            v:setSelected(true)
            v.ishow = true
            self.lastcell = v
            v:onUpdateDraw()
            index = i
            height = v:getContentSize().height
            break
        end
    end
    listviewPositioningMoves(ListView_list, index, 0)
end

function AlloyMatrixWindow:onUpdate( dt )
    
end

function AlloyMatrixWindow:init(params)
    self._choose_ship = params[1]
    self.default_ship = params[1]
	self:onInit()
    return self
end

function AlloyMatrixWindow:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_back"), nil, 
    {
        terminal_name = "alloy_matrixn_window_close", 
        terminal_state = 0, 
        _self = self,
        touch_black = true,
    }, nil, 3)

    --初级矩阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_primary"), nil, 
    {
        terminal_name = "alloy_matrix_tab_change", 
        terminal_state = 0,
        _index = 1,
        touch_black = true,
    }, nil, 3)

    --中级矩阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_middle"), nil, 
    {
        terminal_name = "alloy_matrix_tab_change", 
        terminal_state = 0,
        _index = 2,
        touch_black = true,
    }, nil, 3)

    --高级矩阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_high"), nil, 
    {
        terminal_name = "alloy_matrix_tab_change", 
        terminal_state = 0,
        _index = 3,
        touch_black = true,
    }, nil, 3)

     --抽合金
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hjcq"), nil, 
    {
        terminal_name = "alloy_matrix_get_reword_window_open", 
        terminal_state = 0,
        touch_black = true,
        is_fun_open = false,
    }, nil, 3)

    --熔炼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hjrl"), nil, 
    {
        terminal_name = "alloy_matrix_fusion_open", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3) 

    local Panel_hjrl_dh = ccui.Helper:seekWidgetByName(root,"Panel_hjrl_dh")
    Panel_hjrl_dh:setTouchEnabled(false)
    Panel_hjrl_dh:removeAllChildren(true)
    local jsonFile = "images/ui/effice/effect_hjfj/effect_hjfj.json" 
    local atlasFile = "images/ui/effice/effect_hjfj/effect_hjfj.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_hjrl_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)

    local Panel_hjcq_dh = ccui.Helper:seekWidgetByName(root,"Panel_hjcq_dh")
    Panel_hjcq_dh:removeAllChildren(true)
    local jsonFile = "images/ui/effice/effect_hjcq/effect_hjcq.json" 
    local atlasFile = "images/ui/effice/effect_hjcq/effect_hjcq.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_hjcq_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)

    
    self:updateIconList()
    self:onUpdateDraw()
    self:changeTabViewShow(1)

    -- iphone刘海适配
    local ListView_alloy_role_icon = ccui.Helper:seekWidgetByName(root, "ListView_alloy_role_icon")
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
        if ListView_alloy_role_icon then 
            ListView_alloy_role_icon:setPositionX(ListView_alloy_role_icon:getPositionX()+50)
        end
        if Image_1 then 
            Image_1:setPositionX(Image_1:getPositionX()+50)
        end
    end

    local userinfo = AlloyMatrixTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

function AlloyMatrixWindow:onEnterTransitionFinish()
end

function AlloyMatrixWindow:onExit()
    state_machine.remove("tab_btn_change")
end
