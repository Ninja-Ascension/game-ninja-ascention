-- ----------------------------------------------------------------------------------------------------
-- 说明：获得途径
-- 创建时间2014-03-02 22:07
-- 作者：周义文
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipAcquire = class("EquipAcquireClass", Window)

function EquipAcquire:ctor()
    self.super:ctor()
	self.roots = {}
	self.moldId = nil
	self.IconType = nil
	self.OpenStr = nil
	app.load("client.cells.battle.battle_function_open_cell")
	app.load("client.cells.equip.equip_icon_new_cell")
	
	app.load("client.cells.ship.ship_head_new_cell")
	app.load("client.cells.prop.prop_icon_new_cell")
    local function init_EquipAcquire_terminal()
		local to_get_equip_close_terminal = {
            _name = "to_get_equip_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(to_get_equip_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_EquipAcquire_terminal()
end

function EquipAcquire:upDataDraw()
	local root = self.roots[1]
	local GetEquipIcon = ccui.Helper:seekWidgetByName(root,"Panel_3")	--icon图标
	local GetEquipName = ccui.Helper:seekWidgetByName(root,"Text_ptl1")	--名字
	local GetEquipNumber = ccui.Helper:seekWidgetByName(root,"Text_ptl2")	--数量
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if tonumber(self.IconType) == 0 then				--道具
		local _name = dms.string(dms["prop_mould"],self.moldId,prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            _name = setThePropsIcon(self.moldId)[2]
        end
		local quality = tonumber(dms.string(dms["prop_mould"], self.moldId, prop_mould.prop_quality))+1
		GetEquipName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		GetEquipName:setString(_name)
		local iconCell = PropIconNewCell:createCell()
		iconCell:init(11, {mould_id = self.moldId})
		GetEquipIcon:addChild(iconCell)
		local propCount = 0
		for i,v in pairs(_ED.user_prop) do
			if tonumber(v.user_prop_template) == tonumber(self.moldId) then
				propCount = v.prop_number
			end
		end
		GetEquipNumber:setString(propCount)
		
		local GetEquipTab = zstring.split(self.OpenStr,",")
		for i , v in pairs(GetEquipTab) do
			local cell = BattleFunctionOpenCell:createCell()
			cell:init(v)
			myListView:addChild(cell)
		end
	elseif tonumber(self.IconType) == 1 then				--武将
		local quality = tonumber(dms.string(dms["ship_mould"], self.moldId, ship_mould.ship_type))
		local propNameString = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], self.moldId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.moldId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
        	propNameString = word_info[3]
	    else
			propNameString = dms.string(dms["ship_mould"], self.moldId, ship_mould.captain_name)
		end

		GetEquipName:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		GetEquipName:setString(propNameString)
		local shipCount = 0
		for i,v in pairs(_ED.user_ship) do
			if tonumber(v.ship_template_id) == tonumber(self.moldId) then
				shipCount = shipCount + 1
			end
		end
		GetEquipNumber:setString(shipCount)
		local iconCell = ShipHeadNewCell:createCell()
		iconCell:init(nil,5,self.moldId)
		GetEquipIcon:addChild(iconCell)
	
		
		local GetEquipTab = zstring.split(self.OpenStr,",")
		for i , v in pairs(GetEquipTab) do
			local cell = BattleFunctionOpenCell:createCell()
			cell:init(v)
			myListView:addChild(cell)
		end
	elseif tonumber(self.IconType) == 2 then				--装备
		local iconCell = EquipIconNewCell:createCell()
		iconCell:init(6,{user_equiment_template = self.moldId})
		GetEquipIcon:addChild(iconCell)
		
		local EquipName = dms.string(dms["equipment_mould"],self.moldId,equipment_mould.equipment_name)
		local quality = dms.int(dms["equipment_mould"], self.moldId, equipment_mould.grow_level) + 1
		GetEquipName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		GetEquipName:setString(EquipName)
		local equipCount = 0
		for i,v in pairs(_ED.user_equiment) do
			if tonumber(v.user_equiment_template) == tonumber(self.moldId) then
				equipCount = equipCount + 1
			end
		end
		GetEquipNumber:setString(equipCount)

		
		local GetEquipTab = zstring.split(self.OpenStr,",")
		for i , v in pairs(GetEquipTab) do
			local cell = BattleFunctionOpenCell:createCell()
			cell:init(v)
			myListView:addChild(cell)
		end
	end
end
function EquipAcquire:onEnterTransitionFinish()
    local csbEquipAcquire = csb.createNode("packs/to_get.csb")
    self:addChild(csbEquipAcquire)
	local root = csbEquipAcquire:getChildByName("root")
	table.insert(self.roots, root)
	self:upDataDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
		{
			terminal_name = "to_get_equip_close", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,2)	
	
end

function EquipAcquire:init(IconType,moldId,OpenStr)
	self.IconType = IconType
	self.moldId = moldId
	self.OpenStr = OpenStr
end


function EquipAcquire:createCell()
	local cell = EquipAcquire:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function EquipAcquire:onExit()
	state_machine.remove("to_get_equip_close")
end