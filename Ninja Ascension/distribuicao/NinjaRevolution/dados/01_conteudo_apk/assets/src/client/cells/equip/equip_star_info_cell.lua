---------------------------------
---说明：装备升星信息描述

EquipStarInfoCell = class("EquipStarInfoCellClass", Window)
   
function EquipStarInfoCell:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.page = nil
	self.texts = {}
	self.cell = nil 
	self.equipInfo = nil --装备数据
  	local function equip_star_info_cell_terminal()
  		local equip_star_info_cell_to_up_star_terminal = {
            _name = "equip_star_info_cell_to_up_star",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureStrengthenPanel")
				app.load("client.packs.treasure.TreasureControllerPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
				equipStrengthenRefineStrorageWindow:init(params._datas._equip, "4",params._datas._cell,params._datas._string_type)
				fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
				state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
				state_machine.excute("formation_cell_on_hide", 0, "formation_cell_on_hide.")
				state_machine.excute("equip_formation_choice_hide", 0, "equip_formation_choice_hide.")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_star_info_cell_to_up_star_terminal)
        state_machine.init()
    end
  	equip_star_info_cell_terminal()
end

function EquipStarInfoCell:onEnterTransitionFinish()
    local csbEquipInfoStrengthenListCell = csb.createNode("packs/EquipStorage/equipment_information_list_9.csb")
	local root = csbEquipInfoStrengthenListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	self:onUpdateDraw()
end

function EquipStarInfoCell:onUpdateDraw()
	local root = self.roots[1]
	local maxStar = dms.int(dms["equipment_mould"], self.equipInfo.user_equiment_template, equipment_mould.star_level)
	if maxStar == -1 then 
		return 
	end
	local currentStar = zstring.tonumber(self.equipInfo.current_star_level)
	for i=1,5 do
		local ImageStarOpen = ccui.Helper:seekWidgetByName(root, "Image_o_"..i)
		local ImageStarClose = ccui.Helper:seekWidgetByName(root, "Image_c_"..i)
		if ImageStarOpen ~= nil then
			ImageStarOpen:setVisible(false)
			ImageStarClose:setVisible(false)
			if i <= maxStar then 
				ImageStarClose:setVisible(true)
			end
			if i <= currentStar then 
				ImageStarOpen:setVisible(true)
			end
		end
	end

	local starButton = ccui.Helper:seekWidgetByName(root, "Button_qh")
	if starButton ~= nil then
		if currentStar < maxStar then 
			fwin:addTouchEventListener(starButton, nil, 
			{
				terminal_name = "equip_star_info_cell_to_up_star", 
				terminal_state = 0, 
				_equip = self.equipInfo, 
				_string_type = self._string_type,
				_cell = self.cell,
				isPressedActionEnabled = true
			}, 
			nil, 0)
			starButton:setTouchEnabled(true)
		else
			starButton:setTouchEnabled(false)
			starButton:setColor(cc.c3b(150, 150, 150))
		end
	end
	local describe = ccui.Helper:seekWidgetByName(root, "Text_4")
	local number = ccui.Helper:seekWidgetByName(root, "Text_5")
	
	local adds = self.equipInfo.add_attribute

	if adds == "" then 
		local equipInfunce = zstring.split(self.equipInfo.user_equiment_ability, "|")
		local equipInfunceStr = zstring.split(equipInfunce[1], ",")
		describe:setString(_equiprety_name[equipInfunceStr[1]+1])
		number:setString("+0")
	else
		local addsAfter = zstring.split(self.equipInfo.add_attribute,",")
		describe:setString(_equiprety_name[zstring.tonumber(addsAfter[1])+1])
		number:setString("+"..addsAfter[2])
	end
end

function EquipStarInfoCell:onExit()

end

function EquipStarInfoCell:init(equipInfo,string_type,cell)
	self.equipInfo = equipInfo
	self._string_type = string_type
	self.cell = cell
end

function EquipStarInfoCell:createCell()
	local cell = EquipStarInfoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end