-- ----------------------------------------------------------------------------------------------------
-- 说明：装备碎片主界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipFragmentInfomation = class("EquipFragmentInfomationClass", Window)
   
function EquipFragmentInfomation:ctor()
	
	closeLastWindow("EquipFragmentInfomationClass")
	
    self.super:ctor()
	self.roots = {}
	self.prop = nil
	self.types = nil
	self.sell = nil
	self.treasure = nil
	app.load("client.packs.equipment.EquipParticulars")
	app.load("client.packs.equipment.EquipParticularsTwo")
	app.load("client.packs.equipment.EquipFragmentQuality")
    -- Initialize Home page state machine.
    local function init_equip_information_terminal()
		local duplicate_show_list_1_terminal = {
            _name = "touch_colose",
            _init = function (terminal)          
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:close(fwin:find("EquipFragmentInfomationClass"))
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --左侧的按钮响应,上翻页	
		local equip_pageview_to_up_terminal = {
            _name = "equip_pageview_to_up",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:ChangePageView("up")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --右侧的按钮响应,下翻页
        local equip_pageview_to_down_terminal = {
            _name = "equip_pageview_to_down",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:ChangePageView("down")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(duplicate_show_list_1_terminal)
		state_machine.add(equip_pageview_to_up_terminal)
		state_machine.add(equip_pageview_to_down_terminal)
        state_machine.init()
    end
    
    init_equip_information_terminal()
end



function EquipFragmentInfomation:ChangePageView(whereButton)
	--上下按钮的响应
	local  _PageView = ccui.Helper:seekWidgetByName(self.roots[1],"PageView_1")
	local upbtn = ccui.Helper:seekWidgetByName(self.roots[1],"Button_7")
	local downbtn = ccui.Helper:seekWidgetByName(self.roots[1],"Button_8")
	local  _items = _PageView:getPages()
	local  _pagenumber = #_items
	-- for i ,v in pairs(_items) do
	-- 	_pagenumber= _pagenumber +1
	-- end
	local  pageindex = _PageView:getCurPageIndex()
	if whereButton == "up" then
		if pageindex ~= 0 then
			_PageView:scrollToPage(pageindex-1)
		end
	elseif whereButton == "down" then
		if pageindex ~= _pagenumber-1  then --ps:pageindex从0开始索引的
			_PageView:scrollToPage(pageindex+1)
		end
	end

	local  pageIndexAfterMove = _PageView:getCurPageIndex()
	

	if pageIndexAfterMove == 0 then
		upbtn:setVisible(false)
	else
		upbtn:setVisible(true)
	end

	if pageIndexAfterMove == _pagenumber-1  then --ps:pageindex从0开始索引的
		downbtn:setVisible(false)
	else
		downbtn:setVisible(true)
	end

	if whereButton == "init" then
		if pageindex == _pagenumber - 1 then --ps:pageindex从0开始索引的
			downbtn:setVisible(false)
		end
		if pageindex == 0 then --ps:pageindex从0开始索引的
			upbtn:setVisible(false)
		end
	end
end

function EquipFragmentInfomation:onUpdateDraw()
	local root = self.roots[1]
	local Panel3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local Panel_wj = ccui.Helper:seekWidgetByName(root, "Panel_wj")
	local Panel_bw = ccui.Helper:seekWidgetByName(root, "Panel_bw")
	Panel3:setVisible(true)
	Panel_wj:setVisible(false)
	Panel_bw:setVisible(false)
	local ImageTab1 = ccui.Helper:seekWidgetByName(root, "Image_tab_3_0")
	local ImageTab2 = ccui.Helper:seekWidgetByName(root, "Image_tab_3")
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "PageView_1")
	
	local cellList = {}
	if self.sell == 2 then		--装备
		local equip = dms.searchs(dms["prop_mould"], prop_mould.change_of_equipment, self.prop)
		local id = nil
		if equip ~= nil then
			for i, v in pairs(equip) do
				if tonumber(v[9]) == 1 then
					id = v[1]
					break
				end
			end
		end
		if id ~= nil then
			local FragmentQualityCell = EquipFragmentQuality:createCell()
			FragmentQualityCell:init(id,2)
			Panel_2:addPage(FragmentQualityCell)
			table.insert(cellList, FragmentQualityCell)
		else
			ccui.Helper:seekWidgetByName(root, "Image_tab_1"):setVisible(true)
		end
		
		if self.prop ~= nil then
			local FragmentParticulars = EquipParticulars:createCell()
			FragmentParticulars:init(self.prop)
			Panel_2:addPage(FragmentParticulars)
			table.insert(cellList, FragmentParticulars)
		else
			ccui.Helper:seekWidgetByName(root, "Image_tab_1_0"):setVisible(true)
		end
		ImageTab1:setVisible(true)
		local function pageViewEvent(sender, eventType)
			if eventType == ccui.PageViewEventType.turning then
				local currentPageIndex = sender:getCurPageIndex()	--当前页数
				if ccui.Helper:seekWidgetByName(root, "Image_tab_1"):isVisible() == true then
				
				else
					if currentPageIndex == 0 then
						ImageTab1:setVisible(false)
						ImageTab2:setVisible(true)
					elseif currentPageIndex == 1 then
						ImageTab1:setVisible(true)
						ImageTab2:setVisible(false)
					end
				end
			end
		end 
		
		Panel_2:addEventListener(pageViewEvent)
		if ccui.Helper:seekWidgetByName(root, "Image_tab_1"):isVisible() == false then
			Panel_2:scrollToPage(1)
		end
	elseif self.sell == 3 then		--宝物(传入的是宝物模板id)(出售界面)
		Panel3:setVisible(false)
		Panel_bw:setVisible(true)
		local ImageTab1 = ccui.Helper:seekWidgetByName(root, "Image_tab_3_0_bw")
		local ImageTab2 = ccui.Helper:seekWidgetByName(root, "Image_tab_3_bw")
		local equip = dms.searchs(dms["prop_mould"], prop_mould.change_of_equipment, self.prop)
		local id = nil
		if equip ~= nil then
			for i, v in pairs(equip) do
				if tonumber(v[9]) == 4 then
					id = v[1]
					break
				end
			end
		end
		
		if id ~= nil then
			local FragmentQualityCell = EquipFragmentQuality:createCell()
			if self.treasure == nil then			--宝物碎片(没有的话默认为碎片一)
				FragmentQualityCell:init(id,2)
			else
				FragmentQualityCell:init(self.treasure,2)
			end
			Panel_2:addPage(FragmentQualityCell)
			table.insert(cellList, FragmentQualityCell)
		else
			ccui.Helper:seekWidgetByName(root, "Image_tab_1"):setVisible(true)
		end
		
		if self.prop ~= nil then
			local FragmentParticulars = EquipParticularsTwo:createCell()
			FragmentParticulars:init(self.prop)
			Panel_2:addPage(FragmentParticulars)
			table.insert(cellList, FragmentParticulars)
		else
			ccui.Helper:seekWidgetByName(root, "Image_tab_1_0"):setVisible(true)
		end
		ImageTab1:setVisible(true)
		local function pageViewEvent(sender, eventType)
			if eventType == ccui.PageViewEventType.turning then
				local currentPageIndex = sender:getCurPageIndex()	--当前页数
				if ccui.Helper:seekWidgetByName(root, "Image_tab_1"):isVisible() == true then
				
				else
					if currentPageIndex == 0 then
						ImageTab1:setVisible(false)
						ImageTab2:setVisible(true)
					elseif currentPageIndex == 1 then
						ImageTab1:setVisible(true)
						ImageTab2:setVisible(false)
					end
				end
			end
		end 
		
		Panel_2:addEventListener(pageViewEvent)
		if ccui.Helper:seekWidgetByName(root, "Image_tab_1"):isVisible() == false then
			Panel_2:scrollToPage(1)
		end
	else
		
		--写这里,是为了 通过一个碎片的模板id,拼凑出一个道具对象
		if type(self.prop) == "string" or type(self.prop) == "number" then
			local pmid = self.prop
			self.prop = {
				user_prop_template = pmid,
				prop_number = getPropAllCountByMouldId(pmid),
			}
		end
		local equipId = dms.string(dms["prop_mould"],self.prop.user_prop_template,prop_mould.change_of_equipment)
		-- [[ 碎片信息页面加载
			local FragmentQualityCell = EquipFragmentQuality:createCell()
			FragmentQualityCell:init(self.prop)
			Panel_2:addPage(FragmentQualityCell)
			table.insert(cellList, FragmentQualityCell)
		--]]
		-- [[ 装备信息页面加载
			local FragmentParticulars = EquipParticulars:createCell()
			FragmentParticulars:init(equipId)
			Panel_2:addPage(FragmentParticulars)
			table.insert(cellList, FragmentParticulars)
		-- ]]
		local function pageViewEvent(sender, eventType)
			if eventType == ccui.PageViewEventType.turning then
				local currentPageIndex = sender:getCurPageIndex()
				if currentPageIndex == 0 then
					ImageTab1:setVisible(false)
					ImageTab2:setVisible(true)
				elseif currentPageIndex == 1 then
					ImageTab1:setVisible(true)
					ImageTab2:setVisible(false)
				end
			end
		end 

		Panel_2:addEventListener(pageViewEvent)
	end
	
	
	if self.sell ~= 2 and self.sell ~= 3 then
		ImageTab1:setVisible(false)
		ImageTab2:setVisible(true)
	end
	if self.types == 2 then
		Panel_2:scrollToPage(1)
	end
	
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local index = 0
		local function repetBack( ... )
			index = index + 1
			if index > #cellList then
				self:stopAllActions()
				return
			end
			local v = cellList[index]
			if v ~= nil then
				v:onLoad()
			end
		end
		repetBack()
		self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(repetBack))))
	end
end

function EquipFragmentInfomation:onEnterTransitionFinish()
   local csbEquipFragmentInfomation = csb.createNode("packs/Detailed_information.csb")
   local action = csb.createTimeline("packs/Detailed_information.csb")
	local root = csbEquipFragmentInfomation:getChildByName("root")
	csbEquipFragmentInfomation:runAction(action)
	table.insert(self.roots, root)
    self:addChild(csbEquipFragmentInfomation)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "button_close_1"), nil, {terminal_name = "touch_colose", terminal_state = 0, 
									isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {terminal_name = "touch_colose", terminal_state = 0}, nil, 0)

	self:onUpdateDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local button_7 = ccui.Helper:seekWidgetByName(root, "Button_7")
		local button_8 = ccui.Helper:seekWidgetByName(root, "Button_8")
		fwin:addTouchEventListener(button_7,nil,
		{
			terminal_name = "equip_pageview_to_up", 
			terminal_state = 0
		},
		nil,0)
		fwin:addTouchEventListener(button_8,nil,
		{
			terminal_name = "equip_pageview_to_down", 
			terminal_state = 0
		},
		nil,0)	
		self:ChangePageView("init")--初始化按钮的状态
	end


end


function EquipFragmentInfomation:onExit()
	state_machine.remove("touch_colose")
	state_machine.remove("equip_pageview_to_up")
	state_machine.remove("equip_pageview_to_down")
end

function EquipFragmentInfomation:init(prop,types,sell,treasure)
	self.prop = prop
	self.types = types
	self.sell = sell       --装备出售界面(参数一为装备模板id)
	self.treasure = treasure       --针对于夺宝界面
end

function EquipFragmentInfomation:createCell()
	local cell = EquipFragmentInfomation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
