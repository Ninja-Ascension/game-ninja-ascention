-- ----------------------------------------------------------------------------------------------------
-- 说明：觉醒界面中道具展示 合成，获取，装备
-------------------------------------------------------------------------------------------------------
HeroAwakenEquipInfo = class("HeroAwakenEquipInfoClass", Window)
function HeroAwakenEquipInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.current_type = 0
	self.propId = 0
	self.wearButton = nil
	self.getButton = nil
	self.composeButton = nil
	self.sureButton = nil
	self.drawIndex = 0
	self.shipId = 0
	self.enum_type = {
		_AWAKEN_EQUIP_WEAR = 1 ,--穿着
		_AWAKEN_EQUIP_GET = 2 ,--获取
		_AWAKEN_BROWSE = 3 ,--道具展示
		_AWAKEN_SHOW = 4 ,--正常展示 只显示确定按钮
	}
	app.load("client.cells.equip.equip_icon_cell")
    local function init_hero_awaken_equip_info_terminal()
		--穿上
		local hero_awaken_equip_info_wear_terminal = {
            _name = "hero_awaken_equip_info_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    local function responseWearCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.baseFightingCount = calcTotalFormationFight()
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end	
            			
            			state_machine.excute("hero_awaken_page_check_updata_by_other_page",0,0)	
            			state_machine.excute("hero_awaken_page_wear_success_update_page",0,response.node.textData)	
            			state_machine.excute("hero_strengthen_page_check_updata_by_other_page",0,0)	
            			state_machine.excute("hero_advanced_page_check_updata_by_other_page",0,0)	
            			fwin:close(fwin:find("HeroAwakenEquipInfoClass"))
		            end
				end
				
				protocol_command.awaken_equipment_adron.param_list =  instance.shipId .. "\r\n".. instance.drawIndex
				NetworkManager:register(protocol_command.awaken_equipment_adron.code, nil, nil, nil, instance, responseWearCallback, false, nil)
            
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--获取
		local hero_awaken_equip_info_get_terminal = {
            _name = "hero_awaken_equip_info_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    app.load("client.packs.hero.HeroPatchInformationPageGetWay")
  				local getEquipWindow = HeroPatchInformationPageGetWay:new()
  				getEquipWindow:init(instance.propId,2)
  				fwin:open(getEquipWindow,fwin._dialog)
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --合成
		local hero_awaken_equip_info_compose_terminal = {
            _name = "hero_awaken_equip_info_compose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    
			    app.load("client.packs.hero.HeroAwakenEquipCompose")
  				local composeWindow = HeroAwakenEquipCompose:new()

  				composeWindow:init(instance.propId,1)
  				fwin:open(composeWindow,fwin._dialog)
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --合成成功后刷新
		local hero_awaken_equip_info_compose_succeed_update_terminal = {
            _name = "hero_awaken_equip_info_compose_succeed_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    instance:onUpdateButtonStates()
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_awaken_equip_info_wear_terminal)
        state_machine.add(hero_awaken_equip_info_get_terminal)
        state_machine.add(hero_awaken_equip_info_compose_terminal)
        state_machine.add(hero_awaken_equip_info_compose_succeed_update_terminal)
        state_machine.init()
    end
    init_hero_awaken_equip_info_terminal()
end

function HeroAwakenEquipInfo:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.wearButton:setVisible(self.current_type == self.enum_type._AWAKEN_EQUIP_WEAR)
	self.getButton:setVisible(self.current_type == self.enum_type._AWAKEN_EQUIP_GET)
	self.composeButton:setVisible(self.current_type == self.enum_type._AWAKEN_EQUIP_GET)
	local equipPanel = ccui.Helper:seekWidgetByName(root, "Panel_28")
	local iconCell = nil
	if __lua_project_id == __lua_project_warship_girl_b then
		iconCell = PropIconCell:createCell()
		iconCell:init(15, self.propId)
	else
		iconCell = PropIconNewCell:createCell()
		iconCell:init(13, self.propId)
	end

	equipPanel:addChild(iconCell)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        ccui.Helper:seekWidgetByName(root, "Text_28"):setString(setThePropsIcon(self.propId)[2])
        ccui.Helper:seekWidgetByName(root, "Text_28_1"):setString(drawPropsDescription(self.propId)) --装备描述
    else
    	ccui.Helper:seekWidgetByName(root, "Text_28"):setString(dms.string(dms["prop_mould"],self.propId,prop_mould.prop_name))
    	ccui.Helper:seekWidgetByName(root, "Text_28_1"):setString(dms.string(dms["prop_mould"],self.propId,prop_mould.remarks)) --装备描述
    end
	
	local propId = dms.int(dms["prop_mould"],self.propId,prop_mould.use_of_ship)
	local equipProperty = dms.string(dms["awaken_equipment_mould"],propId,awaken_equipment_mould.add_attributes1)
	self.textData = equipProperty
	local initialValue = zstring.split(equipProperty,"|")
	for i=1,4 do
		local infoText = ccui.Helper:seekWidgetByName(root, "Text_sx_"..i-1)
		local valueText = ccui.Helper:seekWidgetByName(root, "Text_sx_"..i-1 .. "_0")
		infoText:setString("")
		valueText:setString("")
		if i <= #initialValue then 
			local influenceType = zstring.split("" .. initialValue[i],",")		--每一种属性
			if table.getn(influenceType) >= 2 then 
				local _pType = tonumber(influenceType[1])
				local _pValue = tonumber(influenceType[2])
				infoText:setString(string_equiprety_name_teo[_pType+1])
				valueText:setString("+".._pValue)
			end
		end
	end
	self:onUpdateButtonStates()
end

function HeroAwakenEquipInfo:onUpdateButtonStates()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if self.current_type == 3 then 
		self.getButton:setVisible(true)
	 	self.composeButton:setVisible(true)
	  	self.wearButton:setVisible(false)
	  	self.sureButton:setVisible(false)
	elseif self.current_type == 4 then 
		self.getButton:setVisible(false)
	 	self.composeButton:setVisible(false)
	  	self.wearButton:setVisible(false)
	  	self.sureButton:setVisible(true)
	else
		local propNum = zstring.tonumber(getPropAllCountByMouldId(self.propId))
		if propNum == 0 then 
			--没有这个道具
		 	self.getButton:setVisible(true)
		 	self.composeButton:setVisible(true)
		  	self.wearButton:setVisible(false)
		  	self.sureButton:setVisible(false)
		else
			--
			self.getButton:setVisible(false)
		 	self.composeButton:setVisible(false)
		  	self.wearButton:setVisible(true)
		  	self.sureButton:setVisible(false)
		end
	end
end

function HeroAwakenEquipInfo:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_juexing_hecheng.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)

    self.getButton = ccui.Helper:seekWidgetByName(root, "Button_17")
    self.composeButton = ccui.Helper:seekWidgetByName(root, "Button_17_0")
    self.wearButton = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
    self.sureButton = ccui.Helper:seekWidgetByName(root, "Button_sure")
    fwin:addTouchEventListener(self.getButton, nil, 
	{
		terminal_name = "hero_awaken_equip_info_get", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)
    fwin:addTouchEventListener(self.composeButton, nil, 
	{
		terminal_name = "hero_awaken_equip_info_compose", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("HeroAwakenEquipInfoClass"))]],   
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)

   fwin:addTouchEventListener(self.sureButton, nil, 
	{
		func_string = [[fwin:close(fwin:find("HeroAwakenEquipInfoClass"))]],   
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)

    fwin:addTouchEventListener(self.wearButton, nil, 
	{
		terminal_name = "hero_awaken_equip_info_wear", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)
	self:onUpdateDraw()
end


function HeroAwakenEquipInfo:onExit()
	
end

function HeroAwakenEquipInfo:init(propId, types,index,shipId)
	self.propId = propId
	self.current_type = types
	self.drawIndex = index
	self.shipId = shipId
end