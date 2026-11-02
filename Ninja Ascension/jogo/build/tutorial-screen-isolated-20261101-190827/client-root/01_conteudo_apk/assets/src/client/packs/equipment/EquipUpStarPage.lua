----------------------------------------------------------------------------------------------------
-- 说明：装备升星
-------------------------------------------------------------------------------------------------------

EquipUpStarPage = class("EquipUpStarPageClass", Window)
   
function EquipUpStarPage:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.cells.utils.property_change_tip_info_cell") 
	app.load("client.packs.equipment.EquipUpStarSuccess") 

	self.equipmentInstance = nil
	self._cell = nil
	self._string_type = nil
	self.cacheFightArmature = nil
	self.is_stop = false
	self.is_stops = false
	self.grade = nil
	self.power = nil
	self.lastGrade = 0
	self.lastPower = 0
	self.ArmatureNode_2 = nil  -- 升星成功动画
	self.upConsumeSelect = 1 --选择档位 1 银币 2 金币 3碎片
	self.orderSelectIndex = 1 -- 选择档位索引 根据表中消耗的位置
	
	self.cousumePos = nil -- 1 上 2中 3下
	self.current_star_level = 0 --当前星级
	self.current_star_id = 0 -- 当前星级表中ID
	self.upStarButton = nil  -- 升星按钮
	self.add_attribute_type = 0 -- 加成类型
	self.upStar_add_value = {} --单次强化后增加的值
	self.total_attribute_value = 0 --下一次总共增加的属性值
	self.befor_add_attribute = nil --未升星的属性
	self.befor_luck_value = 0 -- 之前的幸运值
	self.befor_add_attribute_value = 0 --之前的属性价值
	self.consumeText3 = nil --碎片消耗Text
	self.luckColor =  {
		{255,34,0},		----1 高
		{244,0,255},	----2 较高
		{0,145,255},	----3 一般
	}

    local function init_equip_up_star_page_terminal()

		-- 关闭
		local equip_up_star_close_terminal = {
            _name = "equip_up_star_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("equip_up_star_refine_strorage_back", 0, "equip_up_star_refine_strorage_back.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
    	--帮助
        local equip_up_star_to_help_terminal = {
            _name = "equip_up_star_to_help",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.equipment.EquipUpStarHelpInfo")
				local helpWindow = EquipUpStarHelpInfo:new()
				fwin:open(helpWindow,fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

    	--升星
        local equip_up_star_to_up_terminal = {
            _name = "equip_up_star_to_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function recruitCallBack(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then 
							response.node:playSuccessAction()
						end	
					else
						if response.node ~= nil and response.node.roots ~= nil then 
							response.node.upStarButton:setTouchEnabled(true)		
						end
					end
				end
				instance.upStarButton:setTouchEnabled(false)
				protocol_command.equipment_up_star.param_list = instance.equipmentInstance.user_equiment_id.."\r\n" .. instance.upConsumeSelect
				NetworkManager:register(protocol_command.equipment_up_star.code, nil, nil, nil, instance, recruitCallBack, false, nil)
          
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选中消耗
        local equip_up_star_to_select_consume_terminal = {
            _name = "equip_up_star_to_select_consume",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = params._datas.selectIndex
            	local order = params._datas.orderIndex
            	instance:onSelcetConsumeIndex(index,order)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local equip_up_star_change_equip_update_terminal = {
            _name = "equip_up_star_change_equip_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
     
		state_machine.add(equip_up_star_to_help_terminal)
		state_machine.add(equip_up_star_to_up_terminal)
		state_machine.add(equip_up_star_to_select_consume_terminal)
		state_machine.add(equip_up_star_change_equip_update_terminal)
        state_machine.init()
    end
    
    init_equip_up_star_page_terminal()
end

function EquipUpStarPage:onUpdateDrawTwo(data)

	if nil ~= data then
		self:updateAnimation(data)
	else

		local root = self.roots[1]
		local name = {}
		local num = _ED.user_equiment[self.equipmentInstance.user_equiment_id].user_equiment_grade
		local power = _ED.user_equiment[self.equipmentInstance.user_equiment_id].user_equiment_ability
		local equipInfunce = zstring.split(power, "|")
		local equipInfunceStr = zstring.split(equipInfunce[1], ",")
		
		local strengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7")
		local nextStrengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7_1")
		local describeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0")
		local nextDescribeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0_0")
		local money = ccui.Helper:seekWidgetByName(root, "Text_14")
		self.strengthenNum = strengthenNum
		self.describeNum = describeNum
		
		strengthenNum:setString(num .. "/" .. _ED.user_info.user_grade*2)
		nextStrengthenNum:setString((num + 1) .. "/" .. _ED.user_info.user_grade*2)

		describeNum:setString("+"..equipInfunceStr[2])
		local everyLevelAdd = zstring.split(self.equipmentInstance.growup_value,"|")
		local equipInfunceStrAdd = zstring.split(everyLevelAdd[1], ",")
		nextDescribeNum:setString("+" .. equipInfunceStrAdd[2]+equipInfunceStr[2])
		self.grade = self.equipmentInstance.user_equiment_grade
		self.power = equipInfunceStr[2]
		
		--绘制消耗银币 Label_0
		self.needCount = 0 
		local escalateData = zstring.split(dms.string(dms["equipment_level_requirement"], tonumber(self.equipmentInstance.user_equiment_grade)+2, equipment_level_requirement.need_silver),"|")
		
		for i,v in pairs(escalateData) do
			if dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level) + 1 == i then
				local escalateSlive = zstring.split(v,",")	
				for j,slive in pairs(escalateSlive) do
					if dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type) + 1 == j then
						self.needCount = slive
					end
				end
			end
		end
		money:setString(self.needCount)
		if tonumber(_ED.user_info.user_silver) < tonumber(self.needCount) then
			money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		end
	end
end

-- 升星时界面刷新
function EquipUpStarPage:onUpdateDrawStarSuccess()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local totalExp = dms.int(dms["equipment_star"],self.current_star_id,equipment_star.need_exp)
	local parent = math.max(0, math.min(100, self.equipmentInstance.current_star_exp / totalExp * 100))
    
    ccui.Helper:seekWidgetByName(root, "LoadingBar_2"):setPercent(parent)
    ccui.Helper:seekWidgetByName(root, "Text_43"):setString(""..self.equipmentInstance.current_star_exp .. "/" ..totalExp)

    --幸运值计算
    local luckPanel1 = ccui.Helper:seekWidgetByName(root, "Panel_15_0")
	local luckPanel2 = ccui.Helper:seekWidgetByName(root, "Panel_15")
	luckPanel1:setVisible(false)
	luckPanel2:setVisible(false)
	
	local luckValue = zstring.tonumber(self.equipmentInstance.luck_value) -- 幸运值
	local lucks = zstring.split(dms.string(dms["equipment_star"],self.current_star_id,equipment_star.lucky_success_show),"|")
	local luckType = 1
	for k,v in pairs(lucks) do
		local limits = zstring.split(""..v,",")
		if luckValue >= zstring.tonumber(limits[1]) then 
			luckType = zstring.tonumber(limits[2])
		end
	end
	
	if self.current_star_level == 0 then 
		local luckText1 = ccui.Helper:seekWidgetByName(root, "Text_j_1")
		luckText1:setString(_equip_up_star_tip[3 + luckType])
		luckText1:setColor(cc.c3b(self.luckColor[luckType][1],self.luckColor[luckType][2],self.luckColor[luckType][3]))
		luckPanel1:setVisible(true)
	else
		luckPanel2:setVisible(true)
		local luckText1 = ccui.Helper:seekWidgetByName(root, "Text_j")
		luckText1:setString(_equip_up_star_tip[3 + luckType])
		luckText1:setColor(cc.c3b(self.luckColor[luckType][1],self.luckColor[luckType][2],self.luckColor[luckType][3]))
		ccui.Helper:seekWidgetByName(root, "Text_xyz"):setString("".. luckValue .. _equip_up_star_tip[7])
	end

	--当前累计属性
	local currentInfoText1 = ccui.Helper:seekWidgetByName(root, "Text_69")
	local currentInfoText2 = ccui.Helper:seekWidgetByName(root, "Text_69_0")

	if self.equipmentInstance.add_attribute == "" then 
		currentInfoText1:setString(_influence_type[self.add_attribute_type+1])
		currentInfoText2:setString("+0")
		self.befor_add_attribute_value = 0
		ccui.Helper:seekWidgetByName(root, "Text_40_0"):setString("+"..self.upStar_add_value[self.orderSelectIndex])
	else
		local adds = zstring.split(self.equipmentInstance.add_attribute,",")
		currentInfoText1:setString(_influence_type[zstring.tonumber(adds[1])+1])
		currentInfoText2:setString("+"..adds[2])
		local diffValue = self.total_attribute_value - zstring.tonumber(adds[2]) 
		local addsExp = zstring.split(dms.string(dms["equipment_star"],self.current_star_id,equipment_star.add_exp),"|")
		local isPass = false
		
		local diffExp = totalExp - zstring.tonumber(self.equipmentInstance.current_star_exp)
		if diffValue >= self.upStar_add_value[self.orderSelectIndex] and diffValue > 0 then
			--下次升星的没有超过上限
			ccui.Helper:seekWidgetByName(root, "Text_40_0"):setString("+"..self.upStar_add_value[self.orderSelectIndex])	
		else
			isPass = true
		end
		
		if addsExp[self.orderSelectIndex] ~= nil 
		and zstring.tonumber(addsExp[self.orderSelectIndex]) > 0 
		and diffExp <= zstring.tonumber(addsExp[self.orderSelectIndex]) then 
			isPass = true
		end
		if isPass == true then 
			ccui.Helper:seekWidgetByName(root, "Text_40_0"):setString("+"..diffValue)
		end

		self.befor_add_attribute_value = zstring.tonumber(adds[2])
	end

	--再次强化增加属性
	ccui.Helper:seekWidgetByName(root, "Text_40"):setString(_influence_type[self.add_attribute_type+1])

	--消耗碎片
	if self.consumeText3 ~= nil then 
		local props = getPropAllCountByMouldId(self.consumeText3.__consumeMouldId)
		self.consumeText3:setString(self.consumeText3.__consumeNum .. "/"..props)
	end
end

--播放升星动画 
function EquipUpStarPage:playSuccessAction()
	local ArmaturePanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_zb_qh")
	local ArmatureNode_2 = ArmaturePanel:getChildByName("ArmatureNode_2")
	
	
	--计算是否升星失败 播放文字信息动画
	self:showPropertyChangeTipInfo()
	ArmatureNode_2:setVisible(true)
	draw.initArmature(ArmatureNode_2, nil, -1, 0, 1)
    csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)
    ArmatureNode_2._invoke = function(armatureBack)
	    if armatureBack:isVisible() == true then
	        armatureBack:setVisible(false)
	        self.upStarButton:setTouchEnabled(true)
	        if _ED.equipment_up_star_result.is_upLevel == 1 then 
	        	--升级动画
	        	local successPage = EquipUpStarSuccess:new()
				successPage:init(self.equipmentInstance,self.befor_add_attribute,self.current_star_level,self.total_attribute_value)
				fwin:open(successPage, fwin._ui)
				self:getEquipMentData()
				self:onUpdateDraw()
				state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = self._cell}})
				state_machine.excute("equip_icon_cell_star_up_update", 0, {_datas = {_cell = self._cell}})
	        else
	        	self:getEquipMentData()
	        	self:onUpdateDrawStarSuccess()
	    	end
	    end
    end  

end

--提示属性增加
function EquipUpStarPage:showPropertyChangeTipInfo()

	local tipInfoWindow = PropertyChangeTipInfoAnimationCell:createCell()
	local titleString = ""
	local titleType = 13
	local textData = {}
	fwin:close(fwin:find("PropertyChangeTipInfoAnimationCellClass"))
	if self.befor_luck_value ~= zstring.tonumber(_ED.user_equiment[self.equipmentInstance.user_equiment_id].luck_value) 
		and self.current_star_level == zstring.tonumber(_ED.user_equiment[self.equipmentInstance.user_equiment_id].current_star_level)
		then 
		--升星失败只添加幸运值
		titleString = _equip_up_star_tip[9]
		local diff = zstring.tonumber(_ED.user_equiment[self.equipmentInstance.user_equiment_id].luck_value) - self.befor_luck_value
		table.insert(textData, {property = _equip_up_star_tip[10], value = diff})
	else
		--升星成功
		titleString = _equip_up_star_tip[8]
		local adds = zstring.split("" .._ED.user_equiment[self.equipmentInstance.user_equiment_id].add_attribute , ",")
		local multipeType = _ED.equipment_up_star_result.multipe

		if multipeType == 3 then 
			--大暴击
			titleType = 12
			titleString = _equip_up_star_tip[12]
		elseif multipeType == 2 then 
			--小暴击
			titleString = _equip_up_star_tip[11]
			titleType = 12
		end
		if _ED.equipment_up_star_result.add_attribute_value > 0 then 
			table.insert(textData, {property = _influence_type[zstring.tonumber(adds[1])+1], value = _ED.equipment_up_star_result.add_attribute_value})
		end
		if _ED.equipment_up_star_result.add_exe_value > 0 then 
			table.insert(textData, {property = _equip_up_star_tip[13], value = _ED.equipment_up_star_result.add_exe_value})
		end
	end
	tipInfoWindow:init(titleType,titleString, textData)	
	fwin:open(tipInfoWindow, fwin._ui)	
end

--获取最新的装备数据
function EquipUpStarPage:getEquipMentData()
	self.equipmentInstance = _ED.user_equiment[self.equipmentInstance.user_equiment_id]
	self.befor_add_attribute = _ED.user_equiment[self.equipmentInstance.user_equiment_id].add_attribute
	self.befor_luck_value = zstring.tonumber(_ED.user_equiment[self.equipmentInstance.user_equiment_id].luck_value)
end

function EquipUpStarPage:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local name = ccui.Helper:seekWidgetByName(root, "Text_1")
	local allPic = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local startPanel = ccui.Helper:seekWidgetByName(root, "Panel")
	local maxStartPanel = ccui.Helper:seekWidgetByName(root, "Panel1")
	maxStartPanel:setVisible(false)
	startPanel:setVisible(false)
	local equipName = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name)
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
	local picIndex = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
	local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
		
	self.befor_add_attribute = self.equipmentInstance.add_attribute
	self.befor_luck_value = zstring.tonumber(self.equipmentInstance.luck_value)


	local currentStar = zstring.tonumber(self.equipmentInstance.current_star_level)
	self.current_star_level = currentStar
	local startIndex = 1
	if maxStar == 3 then 
		startIndex = 2
	else
		startIndex = 1
	end
	for i=1,5 do
		local ImageStarOpen = ccui.Helper:seekWidgetByName(root, "Image_o_"..i)
		local ImageStarClose = ccui.Helper:seekWidgetByName(root, "Image_c_"..i)
		ImageStarOpen:setVisible(false)
		ImageStarClose:setVisible(false)
		if startIndex == 2 then 
			if i >= startIndex and i <= 4 then 
				ImageStarClose:setVisible(true)
			end
			if i >= startIndex and i <= currentStar + 1 then 
				ImageStarOpen:setVisible(true)
			end
		else
			if i <= maxStar then 
				ImageStarClose:setVisible(true)
			end
			if i <= currentStar then 
				ImageStarOpen:setVisible(true)
			end
		end
		
	end
	local isMaxStar = currentStar >= maxStar
	name:setString(equipName)
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	allPic:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", picIndex))
	fwin:addTouchEventListener(allPic, nil, {func_string = [[state_machine.excute("equip_up_star_close", 0, "click equip_up_star_close.'")]]}, nil, 0)

	local totalUpIds = {}  -- 从0级开始到当前升星的表-总IDS
	local currentStarId = 1 -- 当前升星表中索引
	self.add_attribute_type = 0 -- 此升星增加的属性类型 --只能通过0星的时候算出来

	local startIndex = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.skill_mould)
	local startUps = dms.searchs(dms["equipment_star"], equipment_star.group_id, startIndex)
	if startUps == nil then 
		return
	end
	for k,v in pairs(startUps) do
		if k == 1 then 
			local add_attributes = zstring.split(dms.string(dms["equipment_star"],v[1],equipment_star.add_attribute_values),",")
			self.add_attribute_type = zstring.tonumber(add_attributes[1])
		end
		--计算之前升级的表中ID
		if currentStar > zstring.tonumber(v[3]) then 
			table.insert(totalUpIds,zstring.tonumber(v[1]))	
		end
		
		if zstring.tonumber(v[3]) == currentStar then 
			currentStarId = zstring.tonumber(v[1])
			break
		end
	end
	self.current_star_id = currentStarId
	local nextUpStartId = 1 -- 升星到下一星ID

	if isMaxStar == true then 
		maxStartPanel:setVisible(true)
		startPanel:setVisible(false)
			--当前累计属性
		local currentInfoText1 = ccui.Helper:seekWidgetByName(root, "Text_69")
		local currentInfoText2 = ccui.Helper:seekWidgetByName(root, "Text_69_0")
		local adds = zstring.split(self.equipmentInstance.add_attribute,",")
		currentInfoText1:setString(_influence_type[zstring.tonumber(adds[1])+1])
		currentInfoText2:setString("+"..adds[2])

		return
	else
		nextUpStartId = dms.int(dms["equipment_star"],currentStarId,equipment_star.next_star_id)
		local nextStar = dms.int(dms["equipment_star"],nextUpStartId,equipment_star.current_star)
		ccui.Helper:seekWidgetByName(root, "Text_68"):setString(string.format(_equip_up_star_tip[3],nextStar))
		local currentInfoText2_1 = ccui.Helper:seekWidgetByName(root, "Text_70")
		local currentInfoText2_2 = ccui.Helper:seekWidgetByName(root, "Text_70_0")
		local currentInfoText2_3 = ccui.Helper:seekWidgetByName(root, "Text_70_0_0")
		self.total_attribute_value = dms.int(dms["equipment_star"],currentStarId,equipment_star.add_total_attribute)
		for i,v in pairs(totalUpIds) do
			self.total_attribute_value = self.total_attribute_value + dms.int(dms["equipment_star"],v,equipment_star.add_total_attribute) + dms.int(dms["equipment_star"],v,equipment_star.add_extra_attribute)
		end

		currentInfoText2_1:setString(_influence_type[self.add_attribute_type+1])
		currentInfoText2_2:setString("+".. self.total_attribute_value)
		currentInfoText2_3:setString("+" ..dms.int(dms["equipment_star"],currentStarId,equipment_star.add_extra_attribute))
	end
	startPanel:setVisible(true)
	local cousumeProps = zstring.split(dms.string(dms["equipment_star"],currentStarId,equipment_star.cost_items),"|")
	local attributes = zstring.split(dms.string(dms["equipment_star"],currentStarId,equipment_star.add_attribute_values),"|")
	local consumeCounts = #cousumeProps  --消耗个数
	local consumePanel1 = ccui.Helper:seekWidgetByName(root, "Panel_consume_1")
	local consumePanel2 = ccui.Helper:seekWidgetByName(root, "Panel_consume_2")
	local consumePanel3 = ccui.Helper:seekWidgetByName(root, "Panel_consume_3")
	consumePanel1:setVisible(false)
	consumePanel2:setVisible(false)
	consumePanel3:setVisible(false)
	--获取消耗panel索引
	local function getConsumIndex(index)
		if index == 6 then 
			return 3
		end
		return index
	end
	
	self.upStar_add_value = {}

	local firstIndex = 1 -- 记录第一个Panel索引
	self.consumeText3 = nil
	if consumeCounts == 1 then
		for k,v in pairs(cousumeProps) do
			local moneys = zstring.split(v,",")
			local consumeIndex = getConsumIndex(zstring.tonumber(moneys[1]))
			if k == 1 then 
				firstIndex = consumeIndex
			end
			local panel = ccui.Helper:seekWidgetByName(root, "Panel_consume_".. consumeIndex)
			ccui.Helper:seekWidgetByName(root, "Text_consume_".. consumeIndex):setString(moneys[3])
			panel:setPositionY(self.cousumePos[2])
			panel:setVisible(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_consume_"..consumeIndex), nil, 
			{
				terminal_name = "equip_up_star_to_select_consume", 
				terminal_state = 0, 
				selectIndex = consumeIndex,
				orderIndex = k,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end
		for i,v in ipairs(attributes) do
			local attribute = zstring.split(v,",")
			table.insert(self.upStar_add_value,zstring.tonumber(attribute[2]))
		end
		state_machine.excute("equip_up_star_to_select_consume", 0, 
		{
			_datas = {
				terminal_name = "equip_up_star_to_select_consume", 	
				terminal_state = 0, 
				_instance = self,
				selectIndex = firstIndex,
				orderIndex = 1,
				isPressedActionEnabled = false
			}
		})	
	elseif consumeCounts == 2 then 

		for k,v in pairs(cousumeProps) do
			local moneys = zstring.split(v,",")
			local consumeIndex = getConsumIndex(zstring.tonumber(moneys[1]))
			if k == 1 then 
				firstIndex = consumeIndex
			end
			local panel = ccui.Helper:seekWidgetByName(root, "Panel_consume_".. consumeIndex)
			if consumeIndex == 3 then 
				local props = getPropAllCountByMouldId(moneys[2])
				local text3 = ccui.Helper:seekWidgetByName(root, "Text_consume_".. consumeIndex)
				text3:setString(moneys[3] .. "/" .. props)
				self.consumeText3 = text3
				self.consumeText3.__consumeNum = moneys[3]
				self.consumeText3.__consumeMouldId = moneys[2]
			else	
				ccui.Helper:seekWidgetByName(root, "Text_consume_".. consumeIndex):setString(moneys[3])
			end
			
			for i,v in ipairs(attributes) do
				local attribute = zstring.split(v,",")
				table.insert(self.upStar_add_value,zstring.tonumber(attribute[2]))
			end

			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_consume_"..consumeIndex), nil, 
			{
				terminal_name = "equip_up_star_to_select_consume", 
				terminal_state = 0, 
				selectIndex = consumeIndex,
				orderIndex = k,
				isPressedActionEnabled = true
			}, 
			nil, 0)
			if k == 1 then 
				panel:setPositionY(self.cousumePos[1] - 10)
			else
				panel:setPositionY(self.cousumePos[3] + 10)
			end
			panel:setVisible(true)
		end
		
		state_machine.excute("equip_up_star_to_select_consume", 0, 
		{
			_datas = {
				terminal_name = "equip_up_star_to_select_consume", 	
				terminal_state = 0, 
				_instance = self,
				selectIndex = firstIndex,
				orderIndex = 1,
				isPressedActionEnabled = false
			}
		})	
	elseif consumeCounts == 3 then 
		for k,v in pairs(cousumeProps) do
			local moneys = zstring.split(v,",")
			local consumeIndex = getConsumIndex(zstring.tonumber(moneys[1]))
			if k == 1 then 
				firstIndex = consumeIndex
			end
			local panel = ccui.Helper:seekWidgetByName(root, "Panel_consume_".. consumeIndex)
			if consumeIndex == 3 then 
				local props = getPropAllCountByMouldId(moneys[2])
				local text3 = ccui.Helper:seekWidgetByName(root, "Text_consume_".. consumeIndex)
				text3:setString(moneys[3] .. "/" .. props)
				self.consumeText3 = text3
				self.consumeText3.__consumeNum = moneys[3]
				self.consumeText3.__consumeMouldId = moneys[2]
			else	
				ccui.Helper:seekWidgetByName(root, "Text_consume_".. consumeIndex):setString(moneys[3])
			end
			
			panel:setPositionY(self.cousumePos[k])
			panel:setVisible(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_consume_"..consumeIndex), nil, 
			{
				terminal_name = "equip_up_star_to_select_consume", 
				terminal_state = 0, 
				selectIndex = consumeIndex,
				orderIndex = k,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end

		for i,v in ipairs(attributes) do
			local attribute = zstring.split(v,",")
			table.insert(self.upStar_add_value,zstring.tonumber(attribute[2]))
		end
		state_machine.excute("equip_up_star_to_select_consume", 0, 
		{
			_datas = {
				terminal_name = "equip_up_star_to_select_consume", 	
				terminal_state = 0, 
				_instance = self,
				selectIndex = firstIndex,
				orderIndex = 1,
				isPressedActionEnabled = false
			}
		})	
	end
	self:onUpdateDrawStarSuccess()
end

--选中某个消耗类型进行升星
function EquipUpStarPage:onSelcetConsumeIndex(selectIndex,orderIndex)
	local root = self.roots[1]
	for i=1,3 do
		local selectImage = ccui.Helper:seekWidgetByName(root, "Image_select_"..i)
		selectImage:setVisible(false)
		if i == selectIndex then 
			selectImage:setVisible(true)
			self.upConsumeSelect = selectIndex
			self.orderSelectIndex = orderIndex
			if self.equipmentInstance.add_attribute == "" then 
				ccui.Helper:seekWidgetByName(root, "Text_40_0"):setString("+"..self.upStar_add_value[self.orderSelectIndex])	
			else
				local adds = zstring.split(self.equipmentInstance.add_attribute,",")
				local diffValue = self.total_attribute_value - zstring.tonumber(adds[2]) 
				local addsExp = zstring.split(dms.string(dms["equipment_star"],self.current_star_id,equipment_star.add_exp),"|")
				local isPass = false
				if diffValue >= self.upStar_add_value[self.orderSelectIndex] and diffValue > 0 then
					--下次升星的没有超过上限
					ccui.Helper:seekWidgetByName(root, "Text_40_0"):setString("+"..self.upStar_add_value[self.orderSelectIndex])	
				else
					isPass = true	
				end
				local totalExp = dms.int(dms["equipment_star"],self.current_star_id,equipment_star.need_exp)
				local diffExp = totalExp - zstring.tonumber(self.equipmentInstance.current_star_exp)
		
				if addsExp[self.orderSelectIndex] ~= nil 
				and zstring.tonumber(addsExp[self.orderSelectIndex]) > 0 
				and diffExp <= zstring.tonumber(addsExp[self.orderSelectIndex]) then 
					isPass = true
				end
				if isPass == true then 
					if diffValue < 0 then 
						diffValue = 0
					end
					isPass = true
					ccui.Helper:seekWidgetByName(root, "Text_40_0"):setString("+"..diffValue)
				end
			end
		end
	end
end

function EquipUpStarPage:onEnterTransitionFinish()
    local csbEquipUpStarPage = csb.createNode("packs/EquipStorage/equipment_strengthen_3.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_strengthen_3.csb")
    csbEquipUpStarPage:runAction(action)
	self:addChild(csbEquipUpStarPage)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		action:play("tubiao_ing", true)
	else
		action:play("window_open", false)
	end

	local root = csbEquipUpStarPage:getChildByName("root")
	root:setTouchEnabled(true)
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		app.load("client.player.EquipPlayerInfomation")
		if fwin:find("EquipPlayerInfomationClass") == nil then
			fwin:open(EquipPlayerInfomation:new(),fwin._windows)
		end
		state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
	end
	
	self.cousumePos = {
		ccui.Helper:seekWidgetByName(root, "Panel_consume_1"):getPositionY(),
		ccui.Helper:seekWidgetByName(root, "Panel_consume_2"):getPositionY(),
		ccui.Helper:seekWidgetByName(root, "Panel_consume_3"):getPositionY(),
	}

	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil, 
	{
		terminal_name = "equip_up_star_to_help", 
		terminal_state = 0, 
		
		isPressedActionEnabled = true
	}, 
	nil, 0)
	self.upStarButton = ccui.Helper:seekWidgetByName(root, "Button_11")
	
	fwin:addTouchEventListener(self.upStarButton, nil, 
	{
		terminal_name = "equip_up_star_to_up", 
		terminal_state = 0, 
		
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function EquipUpStarPage:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		if fwin:find("EquipPlayerInfomationClass") ~= nil then
			fwin:close(fwin:find("EquipPlayerInfomationClass"))
		end
	end
end

function EquipUpStarPage:onExit()
	state_machine.remove("equip_up_star_five")
	state_machine.remove("equip_up_star_once")
	state_machine.remove("equip_up_star_close")
	state_machine.remove("equip_up_star_update")
	state_machine.remove("equip_up_star_btn_restore")
	state_machine.remove("equip_up_star_all")
	state_machine.remove("equip_up_star_change_equip_update")
end

function EquipUpStarPage:init(equipmentInstance,_cell,_string_type)
	self.equipmentInstance = equipmentInstance
	self._cell = _cell
	self._string_type = _string_type
end
