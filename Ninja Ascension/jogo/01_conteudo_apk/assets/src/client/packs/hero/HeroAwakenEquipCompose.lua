-- ----------------------------------------------------------------------------------------------------
-- 说明：觉醒界面装备合成
-------------------------------------------------------------------------------------------------------
HeroAwakenEquipCompose = class("HeroAwakenEquipComposeClass", Window)

function HeroAwakenEquipCompose:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.current_type = 0
	self.propId = 0
	self.composeThree = nil -- 合成所需3个道具
	self.composeFour = nil   --合成所需4个道具
	self.composeGet = nil -- 获取途径
	self.current_propId = 0  -- 当前需要合成ID
	self.current_selectIndex = 0 --当前选中的索引
	self.composeProps = {}   --展示道具列表ID
	self.topPropsListView = nil
	self.composeButton = nil --合成按钮
	self.backButton = nil --返回按钮
	self.composePropsCounts = 0 --合成所需要的道具数量
	self.enum_type = {
		_AWAKEN_EQUIP_WEAR = 1 ,--穿着
		_AWAKEN_EQUIP_GET = 2 ,--获取
	}
	self.ArmatureNode_1 = nil  --觉醒成功动画
	self.ArmatureNodePanel = nil  --
	self.listViewIndex = -1 --从商店列表中点击合成的索引

	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.awaken_compose_cell")
	app.load("client.packs.equipment.EquipFragmentAcquire")
	

    local function init_hero_awaken_equip_compose_terminal()
		--
		local hero_awaken_equip_compose_get_terminal = {
            _name = "hero_awaken_equip_compose_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    app.load("client.packs.hero.HeroPatchInformationPageGetWay")
  				local getEquipWindow = HeroPatchInformationPageGetWay:new()
  				getEquipWindow:init(instance.current_propId,2)
  				fwin:open(getEquipWindow,fwin._dialog)
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--选择顶端列表刷新
		local hero_awaken_equip_compose_select_update_terminal = {
            _name = "hero_awaken_equip_compose_select_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    instance:onSelectEquipListViewIndex(params)
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择了合成道具 切换页面
		local hero_awaken_equip_compose_select_equip_terminal = {
            _name = "hero_awaken_equip_compose_select_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    instance:addEquip2ListView(params)
			    instance:onUpdateDraw()
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --返回
		local hero_awaken_equip_compose_back_terminal = {
            _name = "hero_awaken_equip_compose_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.current_selectIndex == 1 then 
            		--不能合成直接关闭
            		fwin:close(fwin:find("HeroAwakenEquipComposeClass"))
            		return
            	end
            	local selectIndex = instance.current_selectIndex - 1 
            	
            	instance:onSelectEquipListViewIndex(selectIndex)
            	instance:onUpdateDraw()
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --合成道具
		local hero_awaken_equip_compose_equip_terminal = {
            _name = "hero_awaken_equip_compose_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	local function responseSellHeroCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		        		
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end

	            		if response.node.current_selectIndex == 1 then 
	            			--只有一个的时候，合成成功关闭当前界面，刷新合成信息界面
	            		else
	            			
	            		end
	            		local browseWindow = fwin:find("HeroAwakenPropBrowseClass")
	            		if browseWindow ~= nil then 
	            			--存在浏览界面了需要刷新道具数量
	            			state_machine.excute("hero_awaken_prop_browse_update",0,0)
	            		end
	            		state_machine.excute("hero_awaken_equip_info_compose_succeed_update",0,0)
            			state_machine.excute("hero_awaken_page_check_updata_by_other_page",0,0)		
	            		instance:playAwakenAction()
		            end
				end
				protocol_command.awaken_equipment_form.param_list = instance.current_propId
				NetworkManager:register(protocol_command.awaken_equipment_form.code, nil, nil, nil, instance, responseSellHeroCallback, false, nil)
            	
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(hero_awaken_equip_compose_get_terminal)
        state_machine.add(hero_awaken_equip_compose_select_update_terminal)
        state_machine.add(hero_awaken_equip_compose_select_equip_terminal)
        state_machine.add(hero_awaken_equip_compose_back_terminal)
        state_machine.add(hero_awaken_equip_compose_equip_terminal)
        state_machine.init()
    end
    init_hero_awaken_equip_compose_terminal()
end

function HeroAwakenEquipCompose:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local composeId = dms.int(dms["prop_mould"],self.current_propId,prop_mould.use_of_ship)
	self.composePanel3:setVisible(false)
	self.composePanel4:setVisible(false)	
	if composeId > 0 then 
		local prop1 = dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_equipment_id1)
		if prop1 > 0 then 
			--可以合成
			ccui.Helper:seekWidgetByName(root, "Panel_2314"):setVisible(true)
			self.composeGet:setVisible(false)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        ccui.Helper:seekWidgetByName(root, "Text_28"):setString(setThePropsIcon(self.current_propId)[2])
		    else
				ccui.Helper:seekWidgetByName(root, "Text_28"):setString(dms.string(dms["prop_mould"],self.current_propId,prop_mould.prop_name))
			end
			ccui.Helper:seekWidgetByName(root, "Text_29_0"):setString("" ..dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_silver))
			local currentPanel = ccui.Helper:seekWidgetByName(root, "Panel_28")
			currentPanel:removeAllChildren(true)
			local iconCell = PropIconNewCell:createCell()
			iconCell:init(13, self.current_propId)
			currentPanel:addChild(iconCell)
			self.composeButton:setVisible(true)
			self.backButton:setVisible(false)
			local composePropsId = {
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_equipment_id1),
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_equipment_id2),
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_equipment_id3),
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_equipment_id4),
				}
			local composePropsCounts = {
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_count1),
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_count2),
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_count3),
				dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_count4),
			}
			local composePanel3 = {
				ccui.Helper:seekWidgetByName(root, "Panel_28_0"),
				ccui.Helper:seekWidgetByName(root, "Panel_28_0_0"),
				ccui.Helper:seekWidgetByName(root, "Panel_28_0_0_0"),
			}
			local composePanel4 = {
				ccui.Helper:seekWidgetByName(root, "Panel_28_0_1"),
				ccui.Helper:seekWidgetByName(root, "Panel_28_0_0_1"),
				ccui.Helper:seekWidgetByName(root, "Panel_28_0_0_0_1"),
				ccui.Helper:seekWidgetByName(root, "Panel_28_0_0_0_1_0"),
			}
			local isFour = dms.int(dms["awaken_equipment_mould"], composeId, awaken_equipment_mould.need_equipment_id4) > 0
			local propsCount = 0
			local propPanels = nil
			if isFour == true then 
				self.composePanel3:setVisible(false)
				self.composePanel4:setVisible(true)	
				propsCount = 4
				propPanels = composePanel4
				self.composePropsCounts = propsCount
			else
				self.composePanel3:setVisible(true)
				self.composePanel4:setVisible(false)	
				propsCount = 3
				propPanels = composePanel3
				self.composePropsCounts = 3
			end
		
			for i=1,propsCount do
				
				local propPanle = propPanels[i]
				propPanle:setAnchorPoint(cc.p(0.0, 0.0))
				propPanle:removeAllChildren(true)
				propPanle:setVisible(true)
				
				local iconCell = nil
				if __lua_project_id == __lua_project_warship_girl_b then
					iconCell = PropIconCell:createCell()
					iconCell:init(38,{user_prop_template = composePropsId[i],prop_number = composePropsCounts[i]})
				else
					iconCell = PropIconNewCell:createCell()
					iconCell:init(17,{user_prop_template = composePropsId[i],prop_number = composePropsCounts[i]})
				end
				propPanle:addChild(iconCell)
			end
		else
			--无合成显示获取
			ccui.Helper:seekWidgetByName(root, "Panel_2314"):setVisible(false)
			self.composeGet:setVisible(true)
			self.composeButton:setVisible(false)
			self.backButton:setVisible(true)

			local iconCell = nil
			if __lua_project_id == __lua_project_warship_girl_b then
				iconCell = PropIconCell:createCell()
				iconCell:init(15, self.current_propId)
			else
				iconCell = PropIconNewCell:createCell()
				iconCell:init(16, self.current_propId)
			end

			local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_zijinnang")
			propPanel:removeAllChildren(true)
			propPanel:addChild(iconCell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        ccui.Helper:seekWidgetByName(root, "Text_2"):setString(setThePropsIcon(self.current_propId)[2])
		    else
				ccui.Helper:seekWidgetByName(root, "Text_2"):setString(dms.string(dms["prop_mould"],self.current_propId,prop_mould.prop_name))
			end
			--获取途径
			local listView = ccui.Helper:seekWidgetByName(root, "ListView_2")
			listView:removeAllItems()
			local getWay = dms.string(dms["prop_mould"], self.current_propId, prop_mould.trace_address)
			if getWay ~= nil and zstring.tonumber(getWay) ~= -1 then
				local temp = zstring.split(getWay, ",")
				for i, v in pairs(temp) do
					if tonumber(v) > 0 then 
						local cell = EquipFragmentAcquire:createCell()
						cell:init(v)
						listView:addChild(cell)
					end
				end
			end
		end
	end
end

function HeroAwakenEquipCompose:addEquip2ListView(propId)
	table.insert(self.composeProps,propId)
	self.current_propId = propId
	self.current_selectIndex = #self.composeProps
	self:onUpdateDrawTipProps()
end

function HeroAwakenEquipCompose:onSelectEquipListViewIndex(index)
	if self.current_selectIndex == index then 
		--选中的是同一个
	else
		self.current_selectIndex = index
		local counts = #self.composeProps - self.current_selectIndex
		if counts < 0 then 
			return
		end
		for i=1,counts do
			table.remove(self.composeProps,#self.composeProps)
		end
		self.current_propId = self.composeProps[#self.composeProps]
		self:onUpdateDrawTipProps()
		self:onUpdateDraw()
	end
end

--顶端道具显示
function HeroAwakenEquipCompose:onUpdateDrawTipProps()
	local root = self.roots[1]
	if root == nil or self.topPropsListView == nil then 
		return
	end
	self.topPropsListView:removeAllItems()
	for i,v in pairs(self.composeProps) do
		local cell = AwakenComposeCell:createCell()
		if i == #self.composeProps  then
			--最后一个，选中状态
			cell:init(v, true, false,i)
			self.topPropsListView:addChild(cell)
			
		else
			--显示箭头
			cell:init(v, false, true,i)
			self.topPropsListView:addChild(cell)
		end
	end
	self.topPropsListView:refreshView()
end

--播放合成动画
function HeroAwakenEquipCompose:playAwakenAction()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.ArmatureNodePanel:setVisible(true)
	self.ArmatureNode_1:setVisible(true)
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    if self.composePropsCounts == 3 then 
    	csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    else
    	csb.animationChangeToAction(self.ArmatureNode_1, 1, 1, false)
    end
    
    self.ArmatureNode_1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            self.ArmatureNodePanel:setVisible(false)
            armatureBack:setVisible(false)    
            TipDlg.drawTextDailog(_awaken_tipString_info[3])
            self:onUpdateDraw()
        end
    end 
end

function HeroAwakenEquipCompose:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_juexing_jxzb.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
    self.composePanel3 = ccui.Helper:seekWidgetByName(root, "Panel_he3")
    self.composePanel4 = ccui.Helper:seekWidgetByName(root, "Panel_he4")
    self.topPropsListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    self.topPropsListView:removeAllItems()
    self.composeGet = ccui.Helper:seekWidgetByName(root, "Panel_tujin")

	
	self.ArmatureNodePanel = ccui.Helper:seekWidgetByName(root, "Panel_donghua")  --合成动画
	self.ArmatureNode_1 = self.ArmatureNodePanel:getChildByName("ArmatureNode_1") -- 觉醒动画
	draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
	csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
	self.ArmatureNodePanel:setVisible(false)
	
    self.composeButton = ccui.Helper:seekWidgetByName(root, "Button_17_0")
	self.backButton = ccui.Helper:seekWidgetByName(root, "Button_17_1")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("HeroAwakenEquipComposeClass"))]],   
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
	{
		terminal_name = "hero_awaken_equip_compose_get", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)

    --合成
 	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17_0"), nil, 
	{
		terminal_name = "hero_awaken_equip_compose_equip", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17_1"), nil, 
	{
		terminal_name = "hero_awaken_equip_compose_back", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true,
	},
	nil,0)
	self.composeProps = {}
	table.insert( self.composeProps, self.current_propId)
	self:onUpdateDraw()
	self:onUpdateDrawTipProps()
end


function HeroAwakenEquipCompose:onExit()
	state_machine.remove("hero_awaken_equip_compose_select_update")
	state_machine.remove("hero_awaken_equip_compose_back")
	state_machine.remove("hero_awaken_equip_compose_equip")
	state_machine.remove("hero_awaken_equip_compose_get")	
end

function HeroAwakenEquipCompose:init(propId, types)
	self.propId = propId
	self.current_type = types
	self.current_propId = propId
	self.current_selectIndex = 1
end