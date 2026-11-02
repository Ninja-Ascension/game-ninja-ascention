----------------------------------------------------------------------------------------------------
-- 说明：时装信息界面下滑列(强化)
-------------------------------------------------------------------------------------------------------
FashionInfoStrengthenListCell = class("FashionInfoStrengthenListCellClass", Window)
 
function FashionInfoStrengthenListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.cell = nil	
	self.types = nil
	self.equip_mould =nil
    local function fashion_info_strengthen_list_cell_terminal()
		local fashion_info_strengthen_list_terminal = {
            _name = "fashion_info_strengthen_list",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.fashion.FashionDevelop")
				-- fwin:close(instance)
				local equip = params._datas._equip
				local equipId = nil
				if equip ~= nil then
					equipId = equip.user_equiment_template
				else
					equipId = params._datas._equip_mould
				end
				state_machine.excute("fashion_information_close", 0,"")
				local FashionDevelopWindow = fwin:find("FashionDevelopClass")
				if FashionDevelopWindow ~= nil then
					state_machine.excute("fashion_develop_open_strengthen_page", 0,{_datas= {_mouldeID= equipId}})
				else
					state_machine.excute("fashion_develop_open", 0,{_datas= {_pageType = 2,_mouldeID= equipId}})
				end
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(fashion_info_strengthen_list_terminal)
        state_machine.init()
    end
    
    fashion_info_strengthen_list_cell_terminal()
end


function FashionInfoStrengthenListCell:onEnterTransitionFinish()
    local csbFashionInfoStrengthenListCell = csb.createNode("packs/EquipStorage/equipment_information_list_1.csb")
	local root = csbFashionInfoStrengthenListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	local level = ccui.Helper:seekWidgetByName(root, "Text_3")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_4")
	local number = ccui.Helper:seekWidgetByName(root, "Text_5")
	
	local equipId = nil
	local AddDatas = {}
	local equip_lv = 1
	if self.equipmentInstance ~= nil then
		-- local equipInfunce = zstring.split(self.equipmentInstance.user_equiment_ability, "|")
		-- AddDatas = equipInfunce
		equipId =self.equipmentInstance.user_equiment_template
		equip_lv = zstring.tonumber(self.equipmentInstance.user_equiment_grade)
	else
		equip_lv = 1
		equipId = self.equip_mould
	end
	-- local equipInfunceStr = zstring.split(equipInfunce[1], ",")

	-- if self.equipmentInstance == nil then
		local everyLevel = dms.string(dms["equipment_mould"],equipId,equipment_mould.grow_value)
	    local everyLevelAdd = zstring.split(everyLevel,"|")
    	AddDatas = everyLevelAdd

    -- end


	-- local everyLevelAdd = zstring.split(everyLevel,"|")
	for i,v in pairs(AddDatas) do

		local influenceType = zstring.split(v,",")      --每一种属性 强化属性
		if table.getn(influenceType) >= 2 then
			local _pType = tonumber(influenceType[1])
			local _pValue = tonumber(influenceType[2])
		
			if i==1 then
				ccui.Helper:seekWidgetByName(root, "Text_4"):setString(_influence_type[_pType+1])
				if _pType >= 4 then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString("+".._pValue*(equip_lv-1).."%")
				else
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString("+".._pValue*(equip_lv-1))
				end
			elseif i==2 then
				ccui.Helper:seekWidgetByName(root, "Text_4_0"):setString(_influence_type[_pType+1])
				if _pType >= 4 then
					ccui.Helper:seekWidgetByName(root, "Text_5_0"):setString("+".._pValue*(equip_lv-1).."%")
				else
					ccui.Helper:seekWidgetByName(root, "Text_5_0"):setString("+".._pValue*(equip_lv-1))
				end
			
			elseif i==3 then
				ccui.Helper:seekWidgetByName(root, "Text_4_1"):setString(_influence_type[_pType+1])
				if _pType >= 4 then
					ccui.Helper:seekWidgetByName(root, "Text_5_1"):setString("+".._pValue*(equip_lv-1).."%")
				else
					ccui.Helper:seekWidgetByName(root, "Text_5_1"):setString("+".._pValue*(equip_lv-1))
				end
			elseif i==4 then
				ccui.Helper:seekWidgetByName(root, "Text_4_0_0"):setString(_influence_type[_pType+1])
				if _pType >= 4  then
					ccui.Helper:seekWidgetByName(root, "Text_5_0_0"):setString("+".._pValue*(equip_lv-1).."%")
				else
					ccui.Helper:seekWidgetByName(root, "Text_5_0_0"):setString("+".._pValue*(equip_lv-1))
				end
			end
		
		end
	end
	

	
	level:setString(equip_lv .. "/" .. _ED.user_info.user_grade*2)
	
	if self.equipmentInstance ~= nil then
		ccui.Helper:seekWidgetByName(root, "Button_qh"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "Button_qh"):setBright(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qh"), nil, 
		{
			terminal_name = "fashion_info_strengthen_list", 
			terminal_state = 0, 
			_equip = self.equipmentInstance, 
			_equip_mould = self.equip_mould,
			isPressedActionEnabled = true
			
		}, 
		nil, 0)
	else
		ccui.Helper:seekWidgetByName(root, "Button_qh"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "Button_qh"):setBright(false)
	end

end


function FashionInfoStrengthenListCell:onExit()
	-- state_machine.remove("fashion_info_strengthen_list")
end

function FashionInfoStrengthenListCell:init(equipmentInstance,mouldid,cell,types)
	self.equipmentInstance = equipmentInstance
	self.equip_mould = mouldid
	self.cell = cell
	self.types = types
end

function FashionInfoStrengthenListCell:createCell()
	local cell = FashionInfoStrengthenListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end