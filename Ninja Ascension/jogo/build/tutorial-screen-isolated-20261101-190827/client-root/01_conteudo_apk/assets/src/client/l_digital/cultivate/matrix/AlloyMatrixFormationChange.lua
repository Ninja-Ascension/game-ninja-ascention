-----------------------------
-- 合金矩阵主界面
-----------------------------
AlloyMatrixFormationChange = class("AlloyMatrixFormationChangeClass", Window)

local alloy_matrix_formation_change_open_terminal = {
	_name = "alloy_matrix_formation_change_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixFormationChangeClass") == nil then
            fwin:open(AlloyMatrixFormationChange:new():init(params), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_formation_change_close_terminal = {
	_name = "alloy_matrix_formation_change_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AlloyMatrixFormationChangeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_formation_change_open_terminal)
state_machine.add(alloy_matrix_formation_change_close_terminal)
state_machine.init()

function AlloyMatrixFormationChange:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentIndex = 1

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationCell")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixHold")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixInformation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationReword")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixTop")
    
    local function init_alloy_matrix_terminal()
        local alloy_matrix_formation_change_swich_terminal = {
            _name = "alloy_matrix_formation_change_swich",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local click_type = params._datas._type
                if click_type == 1 then
                    instance.currentIndex = instance.currentIndex - 1
                else
                    instance.currentIndex = instance.currentIndex + 1
                end
                instance:changePageViewShow(instance.currentIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_formation_set_terminal = {
            _name = "alloy_matrix_formation_set",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship_id = instance.ship.ship_id
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("alloy_matrix_formation_update",0,{instance.panel_cell, params.id})
                            state_machine.excute("alloy_matrix_ship_update",0,response.node.ship)
                            response.node:drawMatrixInfo()
                            if params.cell and params.matrix_id then
                                -- 更换
                                local Panel_alloy_matrix_lv_ing1 = ccui.Helper:seekWidgetByName(params.cell.roots[1],"Panel_alloy_matrix_lv_ing") 
                                Panel_alloy_matrix_lv_ing1:setVisible(true)

                                local cell = instance.list_all[params.matrix_id]
                                local Panel_alloy_matrix_lv_ing2 = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_alloy_matrix_lv_ing")
                                Panel_alloy_matrix_lv_ing2:setVisible(false) 
                            elseif params.cell then
                                --放置
                                local Panel_alloy_matrix_lv_ing1 = ccui.Helper:seekWidgetByName(params.cell.roots[1],"Panel_alloy_matrix_lv_ing") 
                                Panel_alloy_matrix_lv_ing1:setVisible(true)
                            elseif params.matrix_id then
                                --卸下
                                --可能由于第一次延时加载 会找不到节点，做个延时处理
                                local cell = instance.list_all[params.matrix_id]
                                if not cell then
                                    instance:runAction(cc.Sequence:create({cc.DelayTime:create(instance.need_time), cc.CallFunc:create(function (sender)
                                        local cell = instance.list_all[params.matrix_id]
                                        local Panel_alloy_matrix_lv_ing = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_alloy_matrix_lv_ing")
                                        Panel_alloy_matrix_lv_ing:setVisible(false)
                                        instance.need_time = 0
                                    end)}))
                                else
                                    local Panel_alloy_matrix_lv_ing = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_alloy_matrix_lv_ing")
                                    Panel_alloy_matrix_lv_ing:setVisible(false)
                                end
                            end
                            -- response.node:onUpdateDraw(response.node.currentIndex)
                        end 
                    end
                end
                protocol_command.ship_metal_set.param_list = ship_id.."\r\n"..instance.index.."\r\n"..params.set_type.."\r\n".. params.matrix_info
                NetworkManager:register(protocol_command.ship_metal_set.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_information_change_open_select_formation_terminal = {
            _name = "alloy_matrix_information_change_open_select_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("alloy_matrix_select_formation_open", 0, {cell.index, cell.ship, cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --矩阵奖励红点
        local alloy_matrix_change_formation_reword_redot_terminal = {
            _name = "alloy_matrix_change_formation_reword_redot",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationListReword()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        state_machine.add(alloy_matrix_formation_change_swich_terminal)
        state_machine.add(alloy_matrix_information_change_open_select_formation_terminal)
        state_machine.add(alloy_matrix_formation_set_terminal)
        state_machine.add(alloy_matrix_change_formation_reword_redot_terminal)
        state_machine.init()
    end
    init_alloy_matrix_terminal()
end

function AlloyMatrixFormationChange:onUpdateDraw(pageIndex)
    local root = self.roots[1]
    self:updateIconList()
    self:formationListReword()

    local Panel_alloy_matrix_icon = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_icon")
    Panel_alloy_matrix_icon:removeAllChildren(true)
    local cell = HeroIconListCell:createCell()
    cell:init(self.ship, index, true, 101, false, true)
    Panel_alloy_matrix_icon:addChild(cell)

    self:drawMatrixInfo()

    self._listView = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_formation_change")

    self.content_panel = ccui.Helper:seekWidgetByName(root, "content_panel")
    self.content_panel:removeAllChildren(true)

    self.list_all = {}
    local index = 0
    local page_index = 0
    self.all_pages = math.ceil(table.nums(self.matrix_info)/12)
    local root_cell = nil
    local page_cell_temp = csb.createNode("cultivate/alloy_matrix_formation_change_cell.csb")
    local temp_root = page_cell_temp:getChildByName("root")
    self:addChild(page_cell_temp)
    temp_root:setVisible(false)
    self.root_size = temp_root:getContentSize()

    self.content_panel:setContentSize(cc.size(self.root_size.width*self.all_pages, self.root_size.height))
    self:stopAllActions()

    --创建所有的panel
    for i=1,self.all_pages do
        root_cell = nil
        root_cell = temp_root:clone()
        root_cell:setVisible(true)
        root_cell:setAnchorPoint(cc.p(0, 0))
        root_cell:setPosition(cc.p(self.root_size.width*page_index, 0))
        root_cell:setTag(10000+i)
        self.content_panel:addChild(root_cell)
        page_index = page_index + 1
    end

    self.need_time = (table.nums(self.matrix_info) + 1)*0.01
    for k, metal in ipairs(self.matrix_info) do
        self:runAction(cc.Sequence:create({cc.DelayTime:create(k*0.01), cc.CallFunc:create(function (sender)
            local cell_index = (k-1)%12 + 1
            local root_cell = self.content_panel:getChildByTag(10000+math.ceil(k/12))
            local panel_cell = root_cell:getChildByName("Panel_alloy_serial_list_change_frame_" .. cell_index)--ccui.Helper:seekWidgetByName(root_cell,"Panel_alloy_serial_list_change_frame_" .. cell_index)
            local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
            panel_cell:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
            panel_cell:removeAllChildren(true)

            local cell = AlloyMatrixFormationCell:createCell()
            cell:init({metal.id, false})
            self.list_all[metal.id] = cell
            local Panel_alloy_matrix_lv_ing = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_alloy_matrix_lv_ing")
            if tonumber(metal.shipId) > 0 then
                Panel_alloy_matrix_lv_ing:setVisible(true)
            else
                Panel_alloy_matrix_lv_ing:setVisible(false)
            end 
            panel_cell:addChild(cell)
            panel_cell:setSwallowTouches(false)
            panel_cell:addTouchEventListener(handler(self,self.cellTouchEvent))
            panel_cell._datas = metal

        end)}))
    end

    --创建右边的矩阵
    local Panel_alloy_matrix_famation_box = ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_famation_box")
    Panel_alloy_matrix_famation_box:removeAllChildren(true)
    local panel_cell = AlloyMatrixFormation:createCell()
    panel_cell:init(self.index, self.ship, 2)
    self.current_pad = {}
    local Panel_alloy_matrix_formation_box = ccui.Helper:seekWidgetByName(panel_cell.roots[1],"Panel_alloy_matrix_formation_box")
    Panel_alloy_matrix_formation_box:setTouchEnabled(false)
    local paths = {"Panel_famation_primary_icon_", "Panel_famation_middle_icon_", "Panel_famation_high_icon_"}
    for i = 1, table.nums(Panel_alloy_matrix_formation_box:getChildren()) do
    table.insert(self.current_pad, ccui.Helper:seekWidgetByName(panel_cell.roots[1],paths[self.index] .. i))
    end
    Panel_alloy_matrix_famation_box:addChild(panel_cell)
    self.panel_cell = panel_cell


    self:changePageViewShow(pageIndex)
end

function AlloyMatrixFormationChange:drawMatrixInfo()
    local root = self.roots[1]
    self.alloyMatrix = _ED.user_ship[self.ship.ship_id].alloyMatrix
    self.formation = self.alloyMatrix.mmi[self.index .. ""]
    local metal_info = self.alloyMatrix.mmi[self.index .. ""]
    for i = 1, (self.index + 1)*2 do
        local Panel_alloy_up_add_icon = ccui.Helper:seekWidgetByName(root,"Panel_alloy_up_add_icon_" .. i)
        Panel_alloy_up_add_icon:removeBackGroundImage()
        if metal_info and table.nums(metal_info) ~= 0 and metal_info[i .. ""] and _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])] then
            local user_metal = _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])]
            local metal_type = dms.int(dms["ship_metal_mould"], user_metal.metalMould, ship_metal_mould.mould_type)
            Panel_alloy_up_add_icon:setBackGroundImage(string.format("images/ui/text/smhj/hj_%d.png", metal_type))
        end
    end


    local Text_alloy_serial_cue_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_serial_cue_n")
    local Text_alloy_serial_cue = ccui.Helper:seekWidgetByName(root, "Text_alloy_serial_cue")
    local matrix = self.alloyMatrix.ma[self.index .. ""]
    if matrix and table.nums(matrix) ~= 0 then
        local id = table.keys(matrix)[1]
        local quality = table.values(matrix)[1]
        --获取装备名称索引
        local nameindex = dms.int(dms["ship_matrix_mould"], id, ship_matrix_mould.name)
        --通过索引找到word_mould
        local word_info = dms.element(dms["word_mould"], nameindex)
        local name = word_info[3]
        Text_alloy_serial_cue_n:setString(name)
    else
        Text_alloy_serial_cue:setString("")
        Text_alloy_serial_cue_n:setString("")
    end
end

function AlloyMatrixFormationChange:cellTouchEvent( sender, eventType )
    local __spoint = sender:getTouchBeganPosition()
    local __mpoint = sender:getTouchMovePosition()
    local __epoint = sender:getTouchEndPosition()    
    local pic_id = dms.int(dms["ship_metal_mould"], sender._datas.metalMould, ship_metal_mould.pic_id)
    if eventType == ccui.TouchEventType.began then
        if sender ~= nil then
            sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create((function ( sender )
                local cell = AlloyMatrixHold:new()
                  cell:init(66, sender._datas, sender)
                  fwin:open(cell, fwin._windows)
            end))))
        end

        prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic_id))
        sender:addChild(prop_icon)
        began_pos = cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2)
        prop_icon:setPosition(began_pos)

        local e_position = fwin:convertToWorldSpace(prop_icon, began_pos) -- heroSprite:convertToWorldSpace(cc.p(0, 0))
        e_position = self.roots[1]:convertToNodeSpace(cc.p(e_position.x, e_position.y))
        began_pos = e_position
        prop_icon:removeFromParent(true)
        prop_icon:setPosition(cc.p(e_position.x, e_position.y))
        self.roots[1]:addChild(prop_icon)

        prop_icon:setLocalZOrder(1000000)

    elseif eventType == ccui.TouchEventType.moved then
        if nil ~= prop_icon then
            prop_icon:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor  + began_pos.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_pos.y))
        
            if (__mpoint.x - __spoint.x) / app.scaleFactor >= 15 or (__mpoint.y - __spoint.y) / app.scaleFactor >= 15 then
                sender:stopAllActions()
                fwin:close(fwin:find("AlloyMatrixHoldClass"))
            end
        end
    elseif eventType == ccui.TouchEventType.ended 
        or eventType == ccui.TouchEventType.canceled
        then
        -- Fury: un ended/canceled sin began propio (el icono ya se solto) no
        -- trae icono que soltar: `prop_icon` es global y ya es nil (4-oct, rol 196).
        if nil ~= prop_icon then
        local temp = cc.p(0, 0)
        local e_position = prop_icon:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
        for i, panel in ipairs(self.current_pad) do
            local bPosition = panel:convertToNodeSpaceAR(e_position)
            if ( bPosition.x >0 and bPosition.x <=  panel:getContentSize().width and 
               bPosition.y > 0 and bPosition.y <= panel:getContentSize().height) then
                self:canAddMatrix(sender._datas, i, panel)
            end
        end
        end
        sender:stopAllActions()
        fwin:close(fwin:find("AlloyMatrixHoldClass"))
        if prop_icon then
            prop_icon:removeFromParent(true)
            prop_icon = nil
            began_pos = nil 
        end
    end
end

function AlloyMatrixFormationChange:canAddMatrix( metal_info, pos, panel)
    local pos_matrix_id = nil
    if self.formation then pos_matrix_id = self.formation[pos .. ""] end
    local can_add = true
    local have_same = false

    local lock_level = ccui.Helper:seekWidgetByName(panel:getChildByName("cell_info").roots[1], "Text_alloy_matrix_lv_lack")
    if lock_level:isVisible() then
        TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[13])
        return false
    end

    function haveSameType( metal_info, formation )
        for k,v in pairs(formation) do
            if v then
                local info = _ED.user_alloy_matrix[tonumber(v)]
                local matrix_big_type1 = dms.int(dms["ship_metal_mould"], info.metalMould, 3)
                local matrix_big_type2 = dms.int(dms["ship_metal_mould"], metal_info.metalMould, 3)
                if info and info.metalMould == metal_info.metalMould then
                    can_add = false
                    break
                end
                if matrix_big_type1 == 2 and matrix_big_type2 == 2 then
                    have_same = true
                    break
                end
            end
        end

        if not can_add then
            TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[3])
            return false
        else
            if have_same then
                TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[4])
                return false
            else
                return true
            end
        end
    end

    local cell = self.list_all[metal_info.id]
    local Panel_alloy_matrix_lv_ing = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_alloy_matrix_lv_ing") 

    if self.formation and table.nums(self.formation) > 0 then
        local formation = {}
        table.merge(formation, self.formation)
        if pos_matrix_id then
            for k,v in pairs(self.formation) do
                if tonumber(v) ==  tonumber(pos_matrix_id) then
                    formation[k] = nil
                end
            end    
        end
        if haveSameType(metal_info, formation) then
            local params = {}
            params.set_type = 0
            params.matrix_info = metal_info.id .. "," .. pos
            params.cell = cell
            params.matrix_id = pos_matrix_id
            params.id = metal_info.id
            state_machine.excute("alloy_matrix_formation_set",0,params)
        end
    else
        local params = {}
        params.set_type = 0
        params.matrix_info = metal_info.id .. "," .. pos
        params.cell = cell
        params.id = metal_info.id
        state_machine.excute("alloy_matrix_formation_set",0,params)
    end 
end

function AlloyMatrixFormationChange:changePageViewShow( index )
    local root = self.roots[1]
    local Button_xz_shux_left = ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_left")
    local Button_xz_shux_right = ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_right")
    if self._listView and self.content_panel and index <= self.all_pages then
        self.content_panel:stopAllActions()
        local move_x = self.root_size.width*(1 - index)
        self.content_panel:runAction(cc.Sequence:create(
            {cc.MoveTo:create(0.2, cc.p(move_x, 0)), 
                cc.CallFunc:create(function ( sender )
        end)}))

        if index > 1 then
            Button_xz_shux_left:setVisible(true)
        else
            Button_xz_shux_left:setVisible(false)
        end

        if index < self.all_pages then
            Button_xz_shux_right:setVisible(true)
        else
            Button_xz_shux_right:setVisible(false)
        end
    end
end

function AlloyMatrixFormationChange:updateIconList()
    local function fightingCapacity(a,b)
        local quality1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.quality)
        local quality2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.quality)

        local mould_type1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.mould_type)
        local mould_type2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.mould_type)

        local add_type1 = dms.int(dms["ship_metal_mould"], a.metalMould, ship_metal_mould.add_type)
        local add_type2 = dms.int(dms["ship_metal_mould"], b.metalMould, ship_metal_mould.add_type)
        if quality1 > quality2 then
            return true
        elseif quality1 == quality2 then
            if mould_type1 < mould_type2 then
                return true
            elseif mould_type1 == mould_type2 then
                if add_type1 < add_type2 then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    end
    self.matrix_info = {}
    --过滤已经放置的合金
    for k,metal in pairs(_ED.user_alloy_matrix) do
        if metal then
            table.insert(self.matrix_info, metal)
        end
    end
    table.sort(self.matrix_info, fightingCapacity)
end

--矩阵列表红点
function AlloyMatrixFormationChange:formationListReword()
    local root = self.roots[1]
    local Image_hjcq_tip = ccui.Helper:seekWidgetByName(root,"Image_hjcq_tip")
    local reword = _ED.user_ship[self.ship.ship_id].alloyMatrix.mr
    Image_hjcq_tip:setVisible(false)
    if reword and table.nums(reword) > 0 then
        local state = table.values(reword)
        for i,v in ipairs(state) do
            if tonumber(v) == 0 then
                Image_hjcq_tip:setVisible(true)
                break
            end
        end
    else
        Image_hjcq_tip:setVisible(false)
    end
end

function AlloyMatrixFormationChange:onUpdate( dt )
    
end

function AlloyMatrixFormationChange:init(params)
    self.index = params[1]
    self.ship = params[2]

    self.formation = self.ship.alloyMatrix.mmi[self.index .. ""]
	self:onInit()
    return self
end

function AlloyMatrixFormationChange:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix_formation_change.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_back"), nil, 
    {
        terminal_name = "alloy_matrix_formation_change_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --右箭头
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_right"), nil, 
    {
        terminal_name = "alloy_matrix_formation_change_swich", 
        terminal_state = 0,
        _type = 2,
        touch_black = true,
    }, nil, 3)

    -- 左箭头
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_left"), nil, 
    {
        terminal_name = "alloy_matrix_formation_change_swich", 
        terminal_state = 0,
        _type = 1,
        touch_black = true,
    }, nil, 3)

    --一键卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_down"), nil, 
    {
        terminal_name = "alloy_matrix_to_down_all", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    }, nil, 3)
    
    --一键放置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_formation_change_lay"), nil, 
    {
        terminal_name = "alloy_matrix_information_change_open_select_formation", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    }, nil, 3)

    --矩阵列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_attr_formation_list"), nil, 
    {
        terminal_name = "alloy_matrix_formation_reword_open", 
        terminal_state = 0,
        _ship = self.ship,
        touch_black = true,
    }, nil, 3)
    
    
    self:onUpdateDraw(1)
    local userinfo = AlloyMatrixTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

function AlloyMatrixFormationChange:onEnterTransitionFinish()
end

function AlloyMatrixFormationChange:onExit()
    state_machine.remove("tab_btn_change")
    -- Fury: AlloyMatrixFormationReword tambien se abre desde AlloyMatrixInformation y, al reclamar,
    -- llamaba a esta ventana ya cerrada (formationListReword nil).
    state_machine.remove("alloy_matrix_change_formation_reword_redot")
end
