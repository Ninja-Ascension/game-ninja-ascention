-----------------------------
-- 当前拥有的合金矩阵
-----------------------------
AlloyMatrixFormation = class("AlloyMatrixFormationClass", Window)

function AlloyMatrixFormation:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationCell")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationChange")
    
    local function init_alloy_matrix_formation_terminal()
        local alloy_matrix_choose_cell_terminal = {
            _name = "alloy_matrix_choose_cell",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local parent = params[2]
                parent:setCellHook(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_formation_change_terminal = {
            _name = "alloy_matrix_formation_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
                state_machine.excute("alloy_matrix_formation_change_open", 0, {cell.index, cell._choose_ship, cell.panel_cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_formation_update_terminal = {
            _name = "alloy_matrix_formation_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
                cell.dh_metal = params[2]
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(alloy_matrix_choose_cell_terminal)
        state_machine.add(alloy_matrix_formation_change_terminal)
        state_machine.add(alloy_matrix_formation_update_terminal)
        state_machine.init()
    end
    init_alloy_matrix_formation_terminal()
end

function AlloyMatrixFormation:onUpdateDraw()
	local root = self.roots[1]
	self.formation = _ED.user_ship[self._choose_ship.ship_id].alloyMatrix.mmi[self.index .. ""]

	local max_num = 4
	local path = "Panel_famation_primary_icon_%d"
    local Panel_famation_change_dh = nil
	local change_btn = nil
	if self.index == 1 then
		max_num = 4
		path = "Panel_famation_primary_icon_%d"
        Panel_famation_change_dh = ccui.Helper:seekWidgetByName(root,"Panel_famation_pri_change_dh")
	elseif self.index == 2 then
		max_num = 6
		path = "Panel_famation_middle_icon_%d"
        Panel_famation_change_dh = ccui.Helper:seekWidgetByName(root,"Panel_famation_mid_change_dh")
	else
		max_num = 8
		path = "Panel_famation_high_icon_%d"
        Panel_famation_change_dh = ccui.Helper:seekWidgetByName(root,"Panel_famation_high_change_dh")
	end
    local Panel_famation_dh = ccui.Helper:seekWidgetByName(root,"Panel_famation_dh")
    Panel_famation_dh:removeAllChildren(true)
    local jsonFile = "images/ui/effice/effect_gh/effect_gh.json" 
    local atlasFile = "images/ui/effice/effect_gh/effect_gh.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_famation_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)

    Panel_famation_change_dh:setVisible(self.is_strengh == 1)

	fwin:addTouchEventListener(Panel_famation_change_dh, nil, 
    {
        terminal_name = "alloy_matrix_formation_change", 
        terminal_state = 0,
        _cell= self,
        touch_black = true,
    }, nil, 3)

	self:setAlloyMatrixCell(max_num, path)
end

function AlloyMatrixFormation:setAlloyMatrixCell(max_num, path)
	local root = self.roots[1]
    local lock_levels = zstring.split(dms.string(dms["ship_config"], 39, ship_config.param), "!")[self.index]
    local lock_level = zstring.splits(lock_levels, "|", ":")
	for i=1,max_num do
		local matrix_id = nil
		if self.formation then matrix_id = self.formation[i..""] end
		local panel = ccui.Helper:seekWidgetByName(root, string.format(path, i))
		panel:removeAllChildren(true)

		local cell = AlloyMatrixFormationCell:createCell()
	    cell:init({matrix_id, true, self.is_strengh, self.index, self._choose_ship,self})
	    cell:setName("cell_info")
	    panel:addChild(cell)

        if self.dh_metal and matrix_id and tonumber(self.dh_metal) == tonumber(matrix_id) then
            local Panel_az_dh = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_az_dh")
            Panel_az_dh:removeAllChildren(true)
            local jsonFile = "images/ui/effice/effect_az/effect_az.json" 
            local atlasFile = "images/ui/effice/effect_az/effect_az.atlas" 
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation.animationNameList = {"animation"}
            sp.initArmature(animation, false)
            local function changeActionCallback( ... )
                Panel_az_dh:removeAllChildren(true)
            end
            animation._invoke = changeActionCallback
            Panel_az_dh:addChild(animation)
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation, 0, 0, false)
        end
        if tonumber(lock_level[i][2]) > tonumber(_ED.user_info.user_grade) then
            local Text_alloy_matrix_lv_lack = ccui.Helper:seekWidgetByName(cell.roots[1], "Text_alloy_matrix_lv_lack")
            Text_alloy_matrix_lv_lack:setString(string.format(tipStringInfo_alloy_matrix_tips[12], tonumber(lock_level[i][2])))
            Text_alloy_matrix_lv_lack:setVisible(true)

            local Panel_alloy_matirix_box = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_alloy_matirix_box")
            Panel_alloy_matirix_box:setTouchEnabled(false)

            local Image_alloy_matrix_add = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_alloy_matrix_add")
            Image_alloy_matrix_add:setVisible(false)
        end
	    if self.is_strengh == 2 then
		    local Panel_alloy_matirix_box = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_alloy_matirix_box")
		    Panel_alloy_matirix_box:setTouchEnabled(true)
		    Panel_alloy_matirix_box.matrix_id = matrix_id
		    Panel_alloy_matirix_box.pos = i
		    Panel_alloy_matirix_box.panel = panel
		    Panel_alloy_matirix_box:addTouchEventListener(handler(self, self.removeMatrix))
		else
			local Panel_alloy_matirix_box = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_alloy_matirix_box")
		    Panel_alloy_matirix_box:setTouchEnabled(false)
		end
	end
end

function AlloyMatrixFormation:removeMatrix( sender, eventType )
	local __spoint = sender:getTouchBeganPosition()
    local __mpoint = sender:getTouchMovePosition()
    local __epoint = sender:getTouchEndPosition()  

    local matrix_id = sender.matrix_id
    local pos = sender.pos

    if eventType == ccui.TouchEventType.began then
        began_pos = cc.p(sender:getPosition())
        parent_node = sender.panel
        parent_parent_node = sender:getParent():getParent()
        default_zorlder = sender:getLocalZOrder()
        parent_zorlder = parent_node:getLocalZOrder()
        parent_parent_zorlder = parent_parent_node:getLocalZOrder()

        sender:setLocalZOrder(1000000)
        parent_node:setLocalZOrder(1000000)
        parent_parent_node:setLocalZOrder(1000000)

    elseif eventType == ccui.TouchEventType.moved then
        if nil ~= sender then
            sender:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor  + began_pos.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_pos.y))
        end
    elseif eventType == ccui.TouchEventType.ended 
        or eventType == ccui.TouchEventType.canceled
        then
        local move_x = math.abs(__epoint.x - __spoint.x)
        local move_y = math.abs(__epoint.x - __spoint.x)
        local size = sender:getContentSize()
        if move_x >= size.width/2 or move_y >= size.height/2 then
        	local params = {}
	        params.set_type = 0
	        params.matrix_info = -1 .. "," .. pos
            params.matrix_id = matrix_id
	        sender:setLocalZOrder(default_zorlder)
	        parent_node:setLocalZOrder(parent_zorlder)

        	state_machine.excute("alloy_matrix_formation_set",0,params)
        else
	        sender:setPosition(began_pos)
	        sender:setLocalZOrder(default_zorlder)
	        parent_node:setLocalZOrder(parent_zorlder)
	        parent_parent_node:setLocalZOrder(parent_parent_zorlder)
        end
    end
end

function AlloyMatrixFormation:setCellHook( cell )
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

function AlloyMatrixFormation:onUpdate( dt )
    
end

function AlloyMatrixFormation:init(chooseIndex, _choose_ship, is_strengh)
	self.index = chooseIndex
	self._choose_ship = _choose_ship
	self.is_strengh = is_strengh
	self:onInit()
    return self
end

function AlloyMatrixFormation:onInit()
	local path = "cultivate/alloy_matrix_famation_primary_cell.csb"
	if self.index == 1 then
		path = "cultivate/alloy_matrix_famation_primary_cell.csb"
	elseif self.index == 2 then
		path = "cultivate/alloy_matrix_famation_middle_cell.csb"
	else
		path = "cultivate/alloy_matrix_famation_high_cell.csb"
	end
    local csbItem = csb.createNode(path)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_formation_box"):setTouchEnabled(false)

    self:onUpdateDraw()
end

function AlloyMatrixFormation:onEnterTransitionFinish()
end

function AlloyMatrixFormation:createCell()
	local cell = AlloyMatrixFormation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AlloyMatrixFormation:onExit()
    state_machine.remove("tab_btn_change")
end
