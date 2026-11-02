-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的宠物训练界面
-------------------------------------------------------------------------------------------------------
PetTrainPage = class("PetTrainPageClass", Window)

function PetTrainPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	app.load("client.packs.pet.PetTrainBrowse")
	app.load("client.packs.hero.HeroPatchInformationPageGetWay")

	self._petId = 0        --当前武将Id
	self._pet = nil		--当前武将信息
	self.currentStars = {}
	self.nextStars = {}
	self.ArmatureNode_1 = nil  --升星成功动画
	self.ArmatureNodePanel = nil  --
	
	self.isregister = false  --是否开始发请求
	self._blueNum = 0 -- 蓝色材料
	self._purpleNum = 0 -- 紫色材料
	self._orangeNum = 0 -- 橙色材料
	self._current_train_level = 0 -- 当前训练等级
	self._one = false
	self._two = false
	self._three = false
	self._isFullLevel = false -- 是否满级
	
    local function init_pet_train_page_terminal()
		local pet_train_page_browse_terminal = {
            _name = "pet_train_page_browse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local datas = params._datas
            	local ship = datas._self._pet
            	state_machine.excute("pet_train_browse_window_open", 0, ship)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 蓝色训练
		local pet_train_page_blue_terminal = {
            _name = "pet_train_page_blue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local function responseTrainBlue(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					instance.isregister = false
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
						instance:playTrainAction(1)	
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+25"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						
						state_machine.excute("pet_train_page_check_update_by_other_page",0,0)
						state_machine.excute("pet_list_view_update_cell",0,instance._petId)
						
						if self._blueNum == nil or self._blueNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xl_1"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_shuzi_1"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self._blueNum ~= nil and self._blueNum > 0 then
					instance.isregister = true
					local str = instance._pet.ship_id .. "\r\n" .. 2
					protocol_command.pet_train.param_list = str
					NetworkManager:register(protocol_command.pet_train.code, nil, nil, nil, instance, responseTrainBlue, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[25], 2)
						fwin:open(cell, fwin._windows)
						self._one = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 紫色训练
		local pet_train_page_purple_terminal = {
            _name = "pet_train_page_purple",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local function responseTrainPurple(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					instance.isregister = false
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
						instance:playTrainAction(2)	
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+50"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						
						state_machine.excute("pet_train_page_check_update_by_other_page",0,0)
						state_machine.excute("pet_list_view_update_cell",0,instance._petId)
						
						if self._purpleNum == nil or self._purpleNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xl_2"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_shuzi_2"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self._purpleNum ~= nil and self._purpleNum > 0 then
					instance.isregister = true
					local str = instance._pet.ship_id .. "\r\n" .. 1
					protocol_command.pet_train.param_list = str
					NetworkManager:register(protocol_command.pet_train.code, nil, nil, nil, instance, responseTrainPurple, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[24], 2)
						fwin:open(cell, fwin._windows)
						self._two = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 橙色训练
		local pet_train_page_orange_terminal = {
            _name = "pet_train_page_orange",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local function responseTrainOrange(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					instance.isregister = false
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
						instance:playTrainAction(3)	
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+100"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						
						state_machine.excute("pet_train_page_check_update_by_other_page",0,0)
						state_machine.excute("pet_list_view_update_cell",0,instance._petId)
						if self._orangeNum == nil or self._orangeNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xl_3"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_shuzi_3"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self._orangeNum ~= nil and self._orangeNum > 0 then
					instance.isregister = true
					local str = instance._pet.ship_id .. "\r\n" .. 0
					protocol_command.pet_train.param_list = str
					NetworkManager:register(protocol_command.pet_train.code, nil, nil, nil, instance, responseTrainOrange, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[23], 2)
						fwin:open(cell, fwin._windows)
						self._three = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --通过改变其他页面内容更新本类信息
		local pet_train_page_check_update_by_other_page_terminal = {
            _name = "pet_train_page_check_update_by_other_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    			if instance ~= nil and instance.roots ~= nil then 
    				local level = zstring.tonumber(_ED.user_ship["" .. self._petId].train_level)
    				if level ~= 0 and level ~= instance._current_train_level then 
    					--升阶动画
    					instance:playTrainAction(4)	
    					--阵营刷新
						local formatinWindow = fwin:find("FormationClass")
						if formatinWindow ~= nil then 
							state_machine.excute("formation_pet_update_data",0,0)
						end
    				end
    				instance:onUpdateDraw()
    			end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pet_train_page_browse_terminal)
        state_machine.add(pet_train_page_blue_terminal)
        state_machine.add(pet_train_page_purple_terminal)
        state_machine.add(pet_train_page_orange_terminal)
        state_machine.add(pet_train_page_check_update_by_other_page_terminal)
        state_machine.init()
    end
    init_pet_train_page_terminal()
end


--播放强化动画
function PetTrainPage:playTrainAction(index)

	local root = self.roots[1]
	if root == nil then 
		return
	end
	local paneName = {"Panel_pet_lan","Panel_pet_zi","Panel_pet_cheng","Panel_pet_bao"}
	local anmationName = {"ArmatureNode_pet_lan","ArmatureNode_pet_zi","ArmatureNode_pet_cheng","ArmatureNode_pet_bao"}
	local panle= ccui.Helper:seekWidgetByName(root,paneName[index])
	local ArmatureNode_1 = panle:getChildByName(anmationName[index])
	panle:setVisible(true)
	ArmatureNode_1:setVisible(true)
    draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(ArmatureNode_1, index-1, index-1, false)
    ArmatureNode_1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            panle:setVisible(false)
            armatureBack:setVisible(false)
        end
    end 
end

function PetTrainPage:onUpdate(dt)
	if self.isregister == true or self._isFullLevel == true then
		return
	end
	if self._one == true then
		state_machine.excute("pet_train_page_blue", 0, {_datas = {_equip = self._pet,_cell = self._cell,isPressedActionEnabled = true}})
	elseif self._two == true then
		state_machine.excute("pet_train_page_purple", 0, {_datas = {_equip = self._pet,_cell = self._cell,isPressedActionEnabled = true}})
	elseif self._three == true then
		state_machine.excute("pet_train_page_orange", 0, {_datas = {_equip = self._pet,_cell = self._cell,isPressedActionEnabled = true}})
	end
end

function PetTrainPage:onUpdateDraw()
	local root = self.roots[1]
	self._pet = _ED.user_ship["" .. self._petId]
	if root == nil or self._pet == nil then 
		return
	end

	local shipData = dms.element(dms["ship_mould"], self._pet.ship_template_id)
	local pet_id = dms.atoi(shipData, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
	local trains = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
	if trains == nil then 
		return
	end
	-- 23 24 25 高中底
	self._current_train_level = zstring.tonumber(self._pet.train_level)
	local currentTrainId = nil
	for i,v in pairs(trains) do
		if dms.atoi(v, pet_train_experience.train_level) == self._current_train_level then 
			currentTrainId = dms.atoi(v, pet_train_experience.id)
			break
		end
	end
	if currentTrainId == nil then 
		--找不到数据
		return
	end
	local trainProps = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	local prop = nil
	--蓝色 低级材料
	local propBlueId = zstring.tonumber(trainProps[25])
	prop = fundPropWidthId(propBlueId)
	count1 = 0
	if prop ~= nil then
		count1 = zstring.tonumber(prop.prop_number)
	end
	local sz1Text = ccui.Helper:seekWidgetByName(root, "Text_shuzi_1")
	local tp1Image = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_1")
	if count1 == 0 then 
		sz1Text:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		tp1Image:setColor(cc.c3b(130, 130, 130))
	else
		sz1Text:setColor(cc.c3b(255,255,255))
		tp1Image:setColor(cc.c3b(255,255,255))
	end
	sz1Text:setString(""..count1)
	
	ccui.Helper:seekWidgetByName(root, "Text_jingyann_1"):setString("+"..dms.int(dms["prop_mould"],propBlueId,prop_mould.use_of_experience))

	self._blueNum = zstring.tonumber(count1)

	--紫色 中级材料
	local propPrurpleId = zstring.tonumber(trainProps[24])
	prop = fundPropWidthId(propPrurpleId)
	count2 = 0
	if prop ~= nil then
		count2 = zstring.tonumber(prop.prop_number)
	end

	local sz2Text = ccui.Helper:seekWidgetByName(root, "Text_shuzi_2")
	local tp2Image = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_2")
	if count2 == 0 then 
		sz2Text:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		tp2Image:setColor(cc.c3b(130, 130, 130))
	else
		sz2Text:setColor(cc.c3b(255,255,255))
		tp2Image:setColor(cc.c3b(255,255,255))
	end
	sz2Text:setString(""..count2)
	ccui.Helper:seekWidgetByName(root, "Text_jingyann_2"):setString("+"..dms.int(dms["prop_mould"],propPrurpleId,prop_mould.use_of_experience))
	self._purpleNum = zstring.tonumber(count2)

	--橙色 高级材料
	local propOrangeId = zstring.tonumber(trainProps[23])
	prop = fundPropWidthId(propOrangeId)
	count3 = 0
	if prop ~= nil then
		count3 = zstring.tonumber(prop.prop_number)
	end
	local sz3Text = ccui.Helper:seekWidgetByName(root, "Text_shuzi_3")
	local tp3Image = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_3")
	if count3 == 0 then 
		sz3Text:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		tp3Image:setColor(cc.c3b(130, 130, 130))
	else
		sz3Text:setColor(cc.c3b(255,255,255))
		tp3Image:setColor(cc.c3b(255,255,255))
	end
	sz3Text:setString(""..count3)
	ccui.Helper:seekWidgetByName(root, "Text_jingyann_3"):setString("+"..dms.int(dms["prop_mould"],propOrangeId,prop_mould.use_of_experience))
	self._orangeNum = zstring.tonumber(count3)

	local cururentTrainData = dms.element(dms["pet_train_experience"], currentTrainId)
	local need_experience = dms.atoi(cururentTrainData,pet_train_experience.need_experience)
	ccui.Helper:seekWidgetByName(root, "Text_zsx_0"):setString("".. self._current_train_level .. _pet_tipString_info[21])
	ccui.Helper:seekWidgetByName(root, "Text_dengji_0"):setString("".. self._current_train_level .. _string_piece_info[46])
	ccui.Helper:seekWidgetByName(root, "Text_jingyan"):setString("".. self._pet.train_experience .. "/" ..need_experience)

	local LoadingBar = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1")
	local progressBar = zstring.tonumber(self._pet.train_experience ) / need_experience * 100
	if progressBar < 0 then 
		progressBar = 0
	elseif progressBar > 100 then 
		progressBar = 100
	end
	LoadingBar:setPercent(progressBar)
	
	self:onUpdateTrainInfo(1,cururentTrainData)
	local need_level = dms.int(dms["pet_train_experience"],currentTrainId,pet_train_experience.open_level)
	local needLevelPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_next_lv")
	needLevelPanel:setVisible(false)
	
	local buttonOne = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_1")
	local buttonTwo = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_2")
	local buttonThree = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_3")
	buttonOne:setTouchEnabled(true)
	buttonTwo:setTouchEnabled(true)
	buttonThree:setTouchEnabled(true)
	local Text_lv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_lv")
	Text_lv:setColor(cc.c3b(255, 255, 255))
	self._isFullLevel = false -- 是否满级
	if zstring.tonumber(self._pet.ship_grade) < need_level then 
		--级别不满足不能升星
		needLevelPanel:setVisible(true)
		Text_lv:setString("".. need_level)
		Text_lv:setColor(cc.c3b(255, 0, 0))
		self._isFullLevel = true -- 是否满级
		self._one = false
		self._two = false
		self._three = false
	end
	
	--下一阶数据刷新
	local nextTrainId = dms.int(dms["pet_train_experience"],currentTrainId,pet_train_experience.train_next_level)

	local youPanel = ccui.Helper:seekWidgetByName(root, "Panel_you")
	local infoPanel = ccui.Helper:seekWidgetByName(root, "Panel_x")
	local maxPanel = ccui.Helper:seekWidgetByName(root, "Panel_max")
	infoPanel:setVisible(true)
	youPanel:setVisible(true)
	maxPanel:setVisible(false)
	if nextTrainId == -1 then 
		--满级了
		self._isFullLevel = true -- 是否满级
		youPanel:setVisible(false)
		maxPanel:setVisible(true)
		infoPanel:setVisible(false)
		return
	end
	local nextTrainData = dms.element(dms["pet_train_experience"], nextTrainId)
	ccui.Helper:seekWidgetByName(root, "Text_ysx_0"):setString("".. self._current_train_level + 1 .. _pet_tipString_info[21])
	self:onUpdateTrainInfo(2,nextTrainData)
end

--刷新加成前后数据
-- @ index 1 前 2 后
-- @ data　加层数据
function PetTrainPage:onUpdateTrainInfo(index,data)
	local counts = 0
	local imageName = {"Image_zw1_","Image_zw1_1_"}
	local textName = {"Text_zsx_","Text_ysx_"}
	local textValueName = {"Text_zsx_1_","Text_ysx_1_"}
	local root = self.roots[1]
    for i=1,6 do
    	local image = ccui.Helper:seekWidgetByName(root, "" ..imageName[index] ..i)
		local attribute = dms.atos(data,pet_train_experience.need_experience + i)

        local lenghtAdd = string.len(attribute)
        local value = 1
        local indexValue = 1
        if lenghtAdd > 2 then 
        -- 有加层
        	image:setVisible(true)
    		local info = zstring.split("".. attribute,"|")
        	if info ~= nil and #info == 2 then
        		--两种属性 必然是防御 物理防御，法术防御
        		indexValue = 40
        		value = zstring.tonumber(zstring.split(""..info[1],",")[2])
          	end
         	if info ~= nil and #info == 1 then 
                --一种属性
                local addAttribute = zstring.split("".. info[1],",")
                indexValue = zstring.tonumber(addAttribute[1]) + 1
                value = zstring.tonumber(addAttribute[2])
           	end
            counts = counts + 1
            local nameText = ccui.Helper:seekWidgetByName(root, "" ..textName[index] ..counts)
            nameText:setString("" ..i .. " " .. string_equiprety_name[indexValue])
            local valueText = ccui.Helper:seekWidgetByName(root, "" ..textValueName[index] ..counts)
            valueText:setString( value ..string_equiprety_name_vlua_type[indexValue])
        end
    end
end

function PetTrainPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/PetStorage/PetStorage_xunlian.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
	
	--防止重复刷新
	local Panel_wujiang = ccui.Helper:seekWidgetByName(root,"Panel_wujiang")
	Panel_wujiang:removeAllChildren(true)
	local shipCell = ShipBodyCell:createCell()
	shipCell:init(self._pet, 0)
	Panel_wujiang:addChild(shipCell)
	self.ArmatureNodePanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pet_bao")   --
    self.ArmatureNode_1 = self.ArmatureNodePanel:getChildByName("ArmatureNode_pet_bao")
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNodePanel:setVisible(false)

	if self.types == "formation" then
		app.load("client.player.UserInformationHeroStorage")
		local seq = fwin:find("UserInformationHeroStorageClass")
		if seq == nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
		state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
	end
	if fwin:find("UserInformationHeroStorageClass") == nil then
		if fwin:find("HeroFormationChoiceWearClass") ~= nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
	end

	self:onUpdateDraw()
	ccui.Helper:seekWidgetByName(root, "Button_1_0"):setVisible(false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "pet_train_page_browse", 
		_self = self
	}, nil, 0)

	local buttonOne = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_1")
	local buttonTwo = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_2")
	local buttonThree = ccui.Helper:seekWidgetByName(self.roots[1], "Button_xl_3")
	local function buttonOneTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			if self._isFullLevel == true then 
				self._one = false
			else
				self._one = true
			end
		elseif ccui.TouchEventType.moved == evenType then
		elseif ccui.TouchEventType.ended == evenType then
			self._one = false
			self._two = false
			self._three = false
			if self._isFullLevel == true then 
				TipDlg.drawTextDailog(_pet_tipString_info[25])
			end
		end
	end
	buttonOne:addTouchEventListener(buttonOneTouchEvent)
	
	
	local function buttonTwoTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()	
		if ccui.TouchEventType.began == evenType then
			if self._isFullLevel == true then 
				self._two = false
			else
				self._two = true
			end
		elseif ccui.TouchEventType.moved == evenType then
		elseif ccui.TouchEventType.ended == evenType then
			self._one = false
			self._two = false
			self._three = false
			if self._isFullLevel == true then 
				TipDlg.drawTextDailog(_pet_tipString_info[25])
			end
		end
	end
	buttonTwo:addTouchEventListener(buttonTwoTouchEvent)

	
	local function buttonThreeTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()	
		if ccui.TouchEventType.began == evenType then
			if self._isFullLevel == true then 
				self._three = false
			else
				self._three = true
			end
		elseif ccui.TouchEventType.moved == evenType then
		elseif ccui.TouchEventType.ended == evenType then
			self._one = false
			self._two = false
			self._three = false
			if self._isFullLevel == true then 
				TipDlg.drawTextDailog(_pet_tipString_info[25])
			end
		end
	end
	buttonThree:addTouchEventListener(buttonThreeTouchEvent)
end

function PetTrainPage:close()
	local Panel_wujiang_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang")
	if Panel_wujiang_1 ~= nil then
		Panel_wujiang_1:removeAllChildren(true)		
	end
end

function PetTrainPage:onExit()
	state_machine.remove("pet_train_page_browse")
	state_machine.remove("pet_train_page_check_update_by_other_page")
end

function PetTrainPage:init(shipId, types)
	self._petId = shipId
	self._pet = _ED.user_ship["" .. self._petId]
	self.types = types
end