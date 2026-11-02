UnionFightChooseCell = class("UnionFightChooseCellClass", Window)

UnionFightChooseCell.__size = nil
function UnionFightChooseCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.roleInfo = nil
    self.mapIndex = 0
    self.selectRole = nil
    self.chooseCamp = 0
    self.formationIndex = nil

    local function init_union_fight_choose_cell_terminal()
		 local union_fight_choose_cell_use_terminal = {
            _name = "union_fight_choose_cell_use",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell == nil then
                    return
                end
                local chooseId = cell.roleInfo.userId
                local mapIndex = cell.mapIndex
                local napData = dms.element(dms["union_fight_campsite_mould"], mapIndex)
                local campsite_index = dms.atos(napData, union_fight_campsite_mould.campsite_index)
                local function responseCallback( response )
                    -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    --     if response.node ~= nil then
                    --         response.node.roleInfo.userMapIndexs[tonumber(campsite_index)] = response.node.mapIndex
                    --         response.node:updateDraw(response.node.roleInfo)
                    --         local selectRole = response.node.selectRole
                    --         if selectRole ~= nil then
                    --             selectRole.userMapIndexs[tonumber(campsite_index)] = 0
                    --             state_machine.excute("union_fight_choose_update", 0, selectRole)
                    --         end
                    --     end
                    -- end
                    state_machine.excute("union_fight_choose_close", 0, nil)
                end
                if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                    protocol_command.unino_set_formation.param_list = "0\r\n"..chooseId.."\r\n"..mapIndex.."\r\n"..cell.formationIndex.."\r\n".._ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
                    NetworkManager:register(protocol_command.unino_set_formation.code, _ED.union_fight_url, nil, nil, cell, responseCallback, true, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_fight_choose_cell_use_terminal)
        state_machine.init()
    end
    
    init_union_fight_choose_cell_terminal()
end

function UnionFightChooseCell:updateDraw()
    local root = self.roots[1]
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_1")
    local levelText = ccui.Helper:seekWidgetByName(root, "Text_4")
    local fightText = ccui.Helper:seekWidgetByName(root, "Text_4_0")
    local Text_fangzhi = ccui.Helper:seekWidgetByName(root, "Text_fangzhi")
    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    local shipData = dms.element(dms["ship_mould"], self.roleInfo.userHeadId)
    local icon = dms.atos(shipData, ship_mould.head_icon)
    local quality = dms.atos(shipData, ship_mould.ship_type) + 1
    nameText:setString(self.roleInfo.userName)
    nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
    levelText:setString(""..self.roleInfo.userLevel)
    fightText:setString(""..self.roleInfo.userFighting)

    local big_icon_path = string.format("images/ui/props/props_%s.png", icon)
    Panel_2:setBackGroundImage(big_icon_path)
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality))
    Panel_1:setBackGroundImage(quality_path)

    local currentMapData = dms.element(dms["union_fight_campsite_mould"], self.mapIndex)
    local current_campsite_index = dms.atos(currentMapData, union_fight_campsite_mould.campsite_index)
    local formationMapId = self.roleInfo.userMapIndexs[tonumber(current_campsite_index)]
    Text_fangzhi:setString("")

    if formationMapId ~= nil and formationMapId ~= "" and tonumber(formationMapId) ~= 0 then
        local mapData = dms.element(dms["union_fight_campsite_mould"], formationMapId)
        local owner_map_info = _ED.union_fight_owner_map_info[""..formationMapId]
        local campsite_name = dms.atos(mapData, union_fight_campsite_mould.campsite_name)
        local fight_formations = zstring.split(dms.atos(mapData, union_fight_campsite_mould.fight_formation), "|")
        local states = zstring.split(fight_formations[2], ",")
        for k1,v1 in pairs(owner_map_info.defenders) do
            if tonumber(self.roleInfo.userId) == tonumber(v1.userId) then
                if tonumber(states[tonumber(v1.pos)]) == 0 then
                    Text_fangzhi:setString(tipStringInfo_union_str[60]..campsite_name.."-"..tipStringInfo_union_str[61])
                else
                    Text_fangzhi:setString(tipStringInfo_union_str[60]..campsite_name.."-"..tipStringInfo_union_str[62])
                end
            end
        end
    end
end

function UnionFightChooseCell:onInit()
    local root = cacher.createUIRef("legion/legion_pve_line_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    if UnionFightChooseCell.__size == nil then
        UnionFightChooseCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fangzhi"), nil, 
    {
        terminal_name = "union_fight_choose_cell_use", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:updateDraw(self.roleInfo)
end

function UnionFightChooseCell:onEnterTransitionFinish()
end

function UnionFightChooseCell:init(roleInfo, index, mapIndex, formationIndex, chooseCamp, selectRole)
    self.roleInfo = roleInfo
    self.mapIndex = mapIndex
    self.formationIndex = formationIndex
    self.chooseCamp = chooseCamp
    self.selectRole = selectRole
    if index ~= nil and index < 8 then
        self:onInit()
    end
    self:setContentSize(UnionFightChooseCell.__size)
	return self
end

function UnionFightChooseCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionFightChooseCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("legion/legion_pve_line_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionFightChooseCell:onExit()
    cacher.freeRef("legion/legion_pve_line_list.csb", self.roots[1])
end

function UnionFightChooseCell:createCell()
	local cell = UnionFightChooseCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
