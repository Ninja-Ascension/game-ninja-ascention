--------------------------------------------------------------------------------------------------------------
--  说明：能量屋的武将选择控件
--------------------------------------------------------------------------------------------------------------
unionEnergyHouseSelectListCell = class("unionEnergyHouseSelectListCellClass", Window)
unionEnergyHouseSelectListCell.__size = nil
function unionEnergyHouseSelectListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.cells.ship.ship_head_new_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_energy_house_select_list_cell_terminal()
        local union_energy_house_select_list_cell_select_ship_terminal = {
            _name = "union_energy_house_select_list_cell_select_ship",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	-- local shipData = zstring.split(self.training_info,",")
           		local function responseUnionCreateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	state_machine.excute("sm_union_my_campsite_update_draw_cell", 0, cell.index)
                    	state_machine.excute("sm_union_energy_house_select_close", 0, "")
                    end
                end
           		protocol_command.union_ship_train.param_list = cell.index.."\r\n"..cell.ship.ship_id --实例id
                NetworkManager:register(protocol_command.union_ship_train.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_energy_house_select_list_cell_select_ship_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_energy_house_select_list_cell_terminal()

end

function unionEnergyHouseSelectListCell:updateDraw()
	local root = self.roots[1]
	
	--头像
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	headPanel:removeAllChildren(true)
	local Text_dengji = ccui.Helper:seekWidgetByName(root, "Text_dengji")
	local hero_head = ShipHeadNewCell:createCell()
	hero_head:init(self.ship,hero_head.enum_type._SHOW_SHIP_WITH_LEVEL_NOT_CHOOSE)
	headPanel:addChild(hero_head)


	--进化形象
	local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	--进化模板id
	local ship_evo = zstring.split(self.ship.evolution_status, "|")
	local evo_mould_id =  evo_info[tonumber(ship_evo[1])]
	local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
	local hero_name = word_info[3]
	--武将

	if getShipNameOrder(tonumber(self.ship.Order)) > 0 then
        hero_name = hero_name.." +"..getShipNameOrder(tonumber(self.ship.Order))
    end
    local quality = shipOrEquipSetColour(tonumber(self.ship.Order))
	Text_dengji:setString(hero_name)
	local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    Text_dengji:setColor(cc.c3b(color_R, color_G, color_B))

    local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
    Panel_strengthen_stye:removeBackGroundImage()
    local camp_preference = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end
    --等级
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    Text_lv:setString("Lv."..self.ship.ship_grade)
    --经验 
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    local LoadingBar_number = ccui.Helper:seekWidgetByName(root, "LoadingBar_number")

   	--找到对应的战船升级的经验
   	--先找模板里的资质
   	local ability = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ability)
   	--再找对应等级在ship_experience_param里的数据
   	local needExp = dms.int(dms["ship_experience_param"], tonumber(self.ship.ship_grade) + 1, ability-13+3)
   	if tonumber(self.ship.exprience) >= needExp then
   		Text_number:setString(self.ship.exprience.."/"..needExp)
   		LoadingBar_number:setPercent(100)
   	else
   		Text_number:setString(self.ship.exprience.."/"..needExp)
   		LoadingBar_number:setPercent(tonumber(self.ship.exprience)/needExp*100)
   	end
end

function unionEnergyHouseSelectListCell:onInit()

	local csbunionEnergyHouseSelectListCell= csb.createNode("legion/sm_legion_energy_house_select_list.csb")
    local root = csbunionEnergyHouseSelectListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionEnergyHouseSelectListCell)
	if unionEnergyHouseSelectListCell.__size == nil then
		unionEnergyHouseSelectListCell.__size = root:getChildByName("Panel_6549"):getContentSize()
	end	
	
	--进入选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xz"), nil, 
    {
        terminal_name = "union_energy_house_select_list_cell_select_ship", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self
    }, 
    nil, 0)

	self:updateDraw()
end

function unionEnergyHouseSelectListCell:onEnterTransitionFinish()

end

function unionEnergyHouseSelectListCell:init(ship,index)
	self.index = tonumber(index)
	self.ship = ship
	self:onInit()
	self:setContentSize(unionEnergyHouseSelectListCell.__size)
	-- self:onInit()
	return self
end

function unionEnergyHouseSelectListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionEnergyHouseSelectListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	headPanel:removeAllChildren(true)
	cacher.freeRef("legion/sm_legion_energy_house_select_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionEnergyHouseSelectListCell:onExit()
	cacher.freeRef("legion/sm_legion_energy_house_select_list.csb", self.roots[1])
end

function unionEnergyHouseSelectListCell:createCell()
	local cell = unionEnergyHouseSelectListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
