-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的宠物强化界面
-------------------------------------------------------------------------------------------------------
PetStrengthenPage = class("PetStrengthenPageClass", Window)

function PetStrengthenPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.action = nil       --本页面动画
	self.shipId = nil       --当前武将Id
	self.ship = nil			--当前武将实例
	self.needPetsInfo = {}	--当前被消耗的武将参数
	self.needMoney = 0		--转化经验所需银币 getOfferOfExp(shipId)
	self.needExp = 0		--转化经验所需银币 getOfferOfExp(shipId)
	self.panel_Add	= {}	--加号的五个层
	self.Button_removes = {}
	self.diff_attribute = {}	--强化前属性
	self.cacheFightArmatures = {}	-- 升级动画效果
	self.currentAttributeText = {} --当前属性文本
	self.nextAttributeText = {} --下一级属性文本
	self.grade_need_exprience = 0
	self.status = true
	self.add_exp = 0 -- 添加饭团后增加的经验
	-- self.getExp = 0
	self.isStopPropertyChange = false -- 因为要等弹出的属性变更信息,出现并消失之后才显示属性栏的数据变更,所以增加此属性,防止属性被立即更新
	self.ArmatureNode_1 = nil  --强化成功动画
	self.ArmatureNodePanel = nil  --
	self.current_strengLeve = 0 -- 当前强化等级
	app.load("client.player.UserInformationHeroStorage")
	app.load("client.cells.ship.ship_body_cell")
	app.load("client.cells.ship.ship_icon_cell")
	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.packs.pet.PetStrengExpAffirm")
    local function init_pet_strengthen_page_terminal()
		--自动添加
		local pet_strengthen_page_open_ex_terminal = {
            _name = "pet_strengthen_page_open_ex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				if instance.status == true then
					state_machine.excute("pet_strengthen_page_clean", 0, "pet_strengthen_page_clean.")
					instance.needPetsInfo = {}
					local captainGrade = tonumber(_ED.user_info.user_grade)	--主角等级
					local AllExp = 0			--可获总经验
					local NeedExp = zstring.tonumber(self.grade_need_exprience) --需要多少经验
					local ship_grade = tonumber(_ED.user_ship[instance.shipId].ship_grade)				  --战船当前等级
					local autoPets = instance:sortPetProps()
					local exps = 0
					for i,v in pairs(autoPets) do
						if v ~= nil and v ~= "" then
							local propData = dms.element(dms["prop_mould"], v.user_prop_template)
							v._isSelect = true
							table.insert(instance.needPetsInfo, v)
							instance.needMoney = instance.needMoney + dms.atoi(propData, prop_mould.use_of_experience)
							
						end
					end
					
					if #instance.needPetsInfo <= 0 then
						if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
							app.load("client.packs.hero.HeroPatchInformationPageGetWay")
							local cell = HeroPatchInformationPageGetWay:createCell()
							cell:init(824, 2)
							fwin:open(cell, fwin._dialog)
						end
						
						return
					end
					state_machine.excute("pet_strengthen_page_update_info", 0, {_datas = {needPetsInfo = instance.needPetsInfo}})
					state_machine.excute("pet_strengthen_page_check_exp", 0, params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--升级成功，清除操作
		local pet_strengthen_page_clean_terminal = {
            _name = "pet_strengthen_page_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.needPetsInfo = {}
				self.needMoney = 0
				for i = 1,5 do
					local panel = instance.panel_Add[i]
					panel:removeAllChildren(true)
				end
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--升级
		local pet_strengthen_page_level_up_terminal = {
            _name = "pet_strengthen_page_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.status = false
				params._NotTipMaxLevel = true
				local function responseSellHeroCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight() 
					_ED.up_streng_reduce_ship = nil
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						pushEffect(formatMusicFile("effect", 9988))
					
						if instance == nil or instance.roots == nil then
							return
						end
						state_machine.excute("pet_strengthen_page_streng_succeed_update", 0, instance.shipId)
							
						--上层列表项中武将信息刷新
						state_machine.excute("pet_list_view_update_cell", 0, instance.shipId)
						state_machine.excute("pet_develop_update_pet", 0, instance.shipId)

						--更新用户银币信息
						state_machine.excute("user_info_hero_storage_update", 0, "user_info_hero_storage_update.")
						
						--移除材料
						state_machine.excute("pet_strengthen_page_clean", 0, "pet_strengthen_page_clean.")
						
						--更新面板
						state_machine.excute("pet_strengthen_page_check_exp", 0, params)
						state_machine.excute("pet_star_up_page_check_update_by_other_page", 0, 0)
						state_machine.excute("pet_train_page_check_update_by_other_page", 0, 0)
						--阵营刷新
						local formatinWindow = fwin:find("FormationClass")
						if formatinWindow ~= nil then 
							state_machine.excute("formation_pet_update_data",0,0)
						end
					end
				end
				local count = 0
				for k,v in pairs(instance.needPetsInfo) do
					if v ~= nil and v ~="" then 
						count = count + 1
					end
				end
				if count == 0 then 
					TipDlg.drawTextDailog(_pet_tipString_info[10])
					instance.status = true
					return
				end
				
				local captainGrade = tonumber(_ED.user_info.user_grade)	--主角等级
				local AllExp = 0			--可获总经验
				local NeedExp = zstring.tonumber(instance.grade_need_exprience) --需要多少经验
				local ship_grade = tonumber(_ED.user_ship[instance.shipId].ship_grade)				  --战船当前等级
				local yellowCount = 0
				local purpleCount = 0
				local blueCount = 0 
				local greenCount = 0 
				for i,v in pairs(instance.needPetsInfo) do
					if v ~= nil and v ~= "" then 
						AllExp = AllExp + instance:getOfferOfExp(v.user_prop_template)
						local prop_quality = dms.int(dms["prop_mould"],v.user_prop_template,prop_mould.prop_quality)
						if prop_quality == 4 then 
							yellowCount = yellowCount + 1
						elseif prop_quality == 3 then 
							purpleCount = purpleCount + 1
						elseif prop_quality == 2 then 
							blueCount = blueCount + 1
						elseif prop_quality == 1 then 
							greenCount = greenCount + 1
						end
					end
				end
				local isFull ,needExp = instance:checkStrengExpOverFlow(AllExp)
				if isFull then
					--满级溢出
					state_machine.excute("pet_streng_exp_affirm_window_open",0,{instance.needPetsInfo,needExp,AllExp,instance.shipId})
					instance.status = true
				else
					protocol_command.pet_escalate.param_list = ""..instance.shipId.."\r\n"..yellowCount.."\r\n" .. purpleCount.. "\r\n".. blueCount.."\r\n".. greenCount
					NetworkManager:register(protocol_command.pet_escalate.code, nil, nil, nil, nil, responseSellHeroCallback, false, nil)
				end
				--刷新加成属性
				state_machine.excute("pet_strengthen_page_check_exp", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择被强化武将
		local pet_strengthen_page_open_been_level_up_hero_terminal = {
            _name = "pet_strengthen_page_been_level_up_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("hero_develop_page_close", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新银币经验
		local pet_strengthen_page_update_cost_terminal = {
            _name = "pet_strengthen_page_update_cost",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 刷新钱币
				instance.needMoney = 0
				for i,v in pairs(instance.needPetsInfo) do
					if v ~= nil and v ~= "" then 
						instance.needMoney = instance.needMoney + instance:getOfferOfExp(v.user_prop_template)
					end
					
				end
				local exprience = zstring.tonumber(_ED.user_ship[self.shipId].exprience)     			--战船当前可获经验
				local grade_need_exprience = zstring.tonumber(instance.grade_need_exprience)    	--战船升级所需经验
				local progressBar = (instance.needMoney + exprience) / grade_need_exprience * 100
				if progressBar < 0 then 
					progressBar = 0
				elseif progressBar > 100 then 
					progressBar = 100
				end
				local LoadingBar_ex = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1_2")
				LoadingBar_ex:setPercent(progressBar)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1_money"):setString(instance.needMoney)
				if tonumber(instance.needMoney) > tonumber(_ED.user_info.user_silver) then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1_money"):setColor(cc.c3b(255, 0, 0))
				else
					if __lua_project_id == __lua_project_pokemon then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1_money"):setColor(cc.c3b(255, 255, 255))
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1_money"):setColor(cc.c3b(0, 0, 0))
					end
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_jingyan"):setString(instance.needMoney)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--接收ChoosePetToStreng传来的数据
		local pet_strengthen_page_update_info_terminal = {
            _name = "pet_strengthen_page_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.needPetsInfo = params._datas.needPetsInfo
				state_machine.excute("pet_strengthen_page_check_exp", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--进入选择英雄列表
		local pet_strengthen_page_enter_choose_hero_terminal = {
            _name = "pet_strengthen_page_enter_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                  
                local autoPets = instance:sortPetProps()
                if #autoPets > 0 then 
                	app.load("client.packs.pet.ChoosePetToStreng")
					local choose_hero_to_streng = ChoosePetToStreng:new()
					choose_hero_to_streng:init(instance.needPetsInfo, instance.shipId)
					fwin:open(choose_hero_to_streng, fwin._windows)
                else
                	if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
                		app.load("client.packs.hero.HeroPatchInformationPageGetWay")
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(824, 2)
						fwin:open(cell, fwin._dialog)
					end	
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--取消一个升级材料的选择
		local pet_strengthen_page_cancel_one_terminal = {
            _name = "pet_strengthen_page_cancel_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local pos = params._datas._pos
				local panel = instance.panel_Add[pos]
				panel:removeAllChildren(true)
				local button = instance.Button_removes[pos]
				button:setVisible(false)
				instance.needPetsInfo[pos] = ""
				-- state_machine.excute("pet_strengthen_page_update_cost", 0, params)
				state_machine.excute("pet_strengthen_page_check_exp", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--判断经验值是否溢出
		local pet_strengthen_page_check_exp_terminal = {
            _name = "pet_strengthen_page_check_exp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 记录当前用户经验,便于提示
				instance._currentExp = zstring.tonumber(_ED.user_ship[instance.shipId].exprience)
				self.needExp = 0
				for i = 1,5 do
					if self.needPetsInfo[i] ~= nil and self.needPetsInfo[i] ~= "" then
						self.needExp = self.needExp + instance:getOfferOfExp(self.needPetsInfo[i].user_prop_template)
					end
				end
				local NeedExp = zstring.tonumber(instance.grade_need_exprience)
				local Exp = zstring.tonumber(_ED.user_ship[self.shipId].exprience)
				if tonumber(_ED.user_ship[self.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
					for i = 1,5 do
						self.needPetsInfo[i] = ""
					end
					
					local LoadingBar_ex = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1_2")
					local progressBar = Exp / NeedExp * 100
					if progressBar < 0 then 
						progressBar = 0
					elseif progressBar > 100 then 
						progressBar = 100
					end
					LoadingBar_ex:setPercent(progressBar)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1_money"):setString(0)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_jingyan"):setString(0)
					
					if params._NotTipMaxLevel ~= true then
						TipDlg.drawTextDailog(_pet_tipString_info[6])
					end	
				else
					state_machine.excute("pet_strengthen_page_update_cost", 0, "pet_strengthen_page_update_cost.")
					--刷新加成属性
				end
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--通过改变其他页面内容更新本类信息
		local pet_strengthen_page_check_updata_by_other_page_terminal = {
            _name = "pet_strengthen_page_check_updata_by_other_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    			if instance ~= nil and instance.roots ~= nil then 
    				instance:onUpdateDraw()
    			end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		--确定升级后成功刷新
		local pet_strengthen_page_streng_succeed_update_terminal = {
            _name = "pet_strengthen_page_streng_succeed_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    			if instance ~= nil and instance.roots ~= nil then 
    				instance:showPropertyChangeTipInfo()
					instance:onUpdateDraw()
					instance:playAwakenAction()
					instance.action:play("pet_jindu_sansuo", false)
					instance.status = true
    			end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pet_strengthen_page_open_ex_terminal)	
        state_machine.add(pet_strengthen_page_level_up_terminal)	
        state_machine.add(pet_strengthen_page_open_been_level_up_hero_terminal)	
        state_machine.add(pet_strengthen_page_open_expence_hero_terminal)	
        state_machine.add(pet_strengthen_page_clean_terminal)	
        state_machine.add(pet_strengthen_page_update_cost_terminal)	
        state_machine.add(pet_strengthen_page_update_info_terminal)	
        state_machine.add(pet_strengthen_page_enter_choose_hero_terminal)	
        state_machine.add(pet_strengthen_page_cancel_one_terminal)	
        state_machine.add(pet_strengthen_page_check_exp_terminal)	
        state_machine.add(pet_strengthen_page_check_updata_by_other_page_terminal)
		state_machine.add(pet_strengthen_page_one_key_terminal)
		state_machine.add(pet_strengthen_page_streng_succeed_update_terminal)
        state_machine.init()
    end
    init_pet_strengthen_page_terminal()
end

--检测升级经验是否溢出 
--只在满级的情况下
function PetStrengthenPage:checkStrengExpOverFlow(AllExp)
	local isFull = false
	local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) 
	local levelExps = dms.searchs(dms["pet_level_requirement"], pet_level_requirement.pet_type, ship_type)
	if levelExps == nil then 
		return
	end
	local petLevel = self.current_strengLeve
	local needExp = self.grade_need_exprience - zstring.tonumber(_ED.user_ship[""..self.shipId].exprience) --升到满级的时候所需要的经验
	for k,v in pairs(levelExps) do
		if self.current_strengLeve + 1 <  tonumber(_ED.user_info.user_grade) then 
			--超过
			if zstring.tonumber(v[3]) > petLevel and zstring.tonumber(v[3]) < tonumber(_ED.user_info.user_grade) then 
				needExp = needExp + zstring.tonumber(v[4])
			end
		end
		if zstring.tonumber(v[3]) >= tonumber(_ED.user_info.user_grade) then 
			break
		end
	end
	if AllExp > needExp then 
		isFull = true
	end		
	return isFull ,needExp
end

--更新选中的宠物
function PetStrengthenPage:onUpdateDrawSelectPets()
	local hasPet = false
	self.add_exp = 0 
	for i = 1,5 do
		local panel = self.panel_Add[i]
		panel:removeAllChildren(true)
		if self.needPetsInfo[i] ~= nil and self.needPetsInfo[i] ~= "" then
			self.Button_removes[i]:setVisible(true)
			local propCell = PropIconCell:createCell()
			local mouldId =self.needPetsInfo[i].user_prop_template
			propCell:init(15,mouldId)
			local cellExp = dms.int(dms["prop_mould"],mouldId,prop_mould.use_of_experience)
			self.add_exp = self.add_exp + cellExp
			panel:addChild(propCell)
			hasPet = true
		else
			self.Button_removes[i]:setVisible(false)
		end
	end
	if hasPet == true then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_1_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_1_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_money"):setString("0")
	end
end

-- 显示属性变更的提示信息
function PetStrengthenPage:showPropertyChangeTipInfo()
	-- 计算两次属性差

	app.load("client.cells.utils.property_change_tip_info_cell") 
	fwin:close(fwin:find("PropertyChangeTipInfoAnimationCellClass"))
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
		-- 强化
	local textData = {}
	local gradeDiff = zstring.tonumber(_ED.user_ship[""..self.shipId].ship_grade) - self.current_strengLeve 
	for i=1,4 do
		table.insert(textData, {property = _property[i], value = zstring.tonumber(self.diff_attribute[i]) * gradeDiff})
	end
	tipInfo:init(2,_pet_tipString_info[11], textData)	
	
	fwin:open(tipInfo, fwin._view)
end

--播放强化动画
function PetStrengthenPage:playAwakenAction()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	
	self.ArmatureNodePanel:setVisible(true)
	self.ArmatureNode_1:setVisible(true)
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNode_1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            self.ArmatureNodePanel:setVisible(false)
            armatureBack:setVisible(false)
        end
    end 
end

function PetStrengthenPage:onUpdateDraw()
	if self == nil or self.roots[1] == nil then
		return
	end
	self:onUpdateDrawSelectPets()
	self.ship 	= fundShipWidthId(self.shipId) 
	local rankLevelFront = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
	
	
	local Text_money = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_money")
	local Panel_down = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_down")
	local Text_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1")

	local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) 
	local shipData = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	
	local petLevel = zstring.tonumber(self.ship.ship_grade)
	self.current_strengLeve = petLevel

	local power = dms.atoi(shipData,ship_mould.initial_power)
	local courage = dms.atoi(shipData,ship_mould.initial_courage)
	local intellect = dms.atoi(shipData,ship_mould.initial_intellect)
	local nimable = dms.atoi(shipData,ship_mould.initial_nimable)

	self.diff_attribute = {}

	table.insert(self.diff_attribute,dms.atoi(shipData,ship_mould.grow_power))
	table.insert(self.diff_attribute,dms.atoi(shipData,ship_mould.grow_courage))
	table.insert(self.diff_attribute,dms.atoi(shipData,ship_mould.grow_intellect))
	table.insert(self.diff_attribute,dms.atoi(shipData,ship_mould.grow_nimable))

	self.currentAttributeText[1]:setString("".. petLevel)
	self.currentAttributeText[2]:setString("".. (power + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_power)))
	self.currentAttributeText[3]:setString("".. (courage + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_courage)))
	self.currentAttributeText[4]:setString("".. (intellect + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_intellect)))
	self.currentAttributeText[5]:setString("".. (nimable + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_nimable)))

	self.nextAttributeText[1]:setString("".. (petLevel + 1))
	self.nextAttributeText[2]:setString("".. (power + (petLevel) * dms.atoi(shipData,ship_mould.grow_power)))
	self.nextAttributeText[3]:setString("".. (courage + (petLevel) * dms.atoi(shipData,ship_mould.grow_courage)))
	self.nextAttributeText[4]:setString("".. (intellect + (petLevel) * dms.atoi(shipData,ship_mould.grow_intellect)))
	self.nextAttributeText[5]:setString("".. (nimable + (petLevel) * dms.atoi(shipData,ship_mould.grow_nimable)))

	local exprience = zstring.tonumber(self.ship.exprience)
	local levelExps = dms.searchs(dms["pet_level_requirement"], pet_level_requirement.pet_type, ship_type)
	if levelExps == nil then 
		return
	end
	Panel_down:setVisible(true)
	Text_1:setVisible(false)
	if petLevel >= zstring.tonumber(_ED.user_info.user_grade) then 
		--不能升星了
		Panel_down:setVisible(false)
		Text_1:setVisible(true)
	end
	for k,v in pairs(levelExps) do
		if zstring.tonumber(v[3]) == petLevel then 
			self.grade_need_exprience = zstring.tonumber(v[4])
			break
		end
	end
	
	local progressBar = (exprience / self.grade_need_exprience) * 100
	if progressBar < 0 then 
		progressBar = 0
	elseif progressBar > 100 then 
		progressBar = 100
	end
	local LoadingBar_1 = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1")
	local Text_jingyan = ccui.Helper:seekWidgetByName(self.roots[1], "Text_jingyan")
	local Text_dengji_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_dengji_0")
	local LoadingBar_1_2 = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1_2")  	-- 经验条
	LoadingBar_1:setVisible(true)
    local totalExp = exprience
	if self.add_exp > 0 then 
	--有增加经验了
		totalExp = exprience + self.add_exp
		local progressBar1 = (totalExp / self.grade_need_exprience) * 100
		if progressBar1 < 0 then 
			progressBar1 = 0
		elseif progressBar1 > 100 then 
			progressBar1 = 100
		end
		LoadingBar_1_2:setPercent(progressBar1)
		self.action:play("pet_jindu_sansuo", true)
	else
		LoadingBar_1_2:setPercent(0)
	end
	LoadingBar_1:setPercent(progressBar)
	Text_dengji_0:setString("".. petLevel)
	Text_jingyan:setString(_pet_tipString_info[9]..totalExp.. "/" ..self.grade_need_exprience)

	if tonumber(_ED.user_info.user_silver) >= tonumber(self.needMoney)   then
		if __lua_project_id == __lua_project_pokemon then
			Text_money:setColor(cc.c3b(255, 255, 255))
		else
			Text_money:setColor(cc.c3b(0, 0, 0))
		end
	else
		Text_money:setColor(cc.c3b(255, 0, 0))
	end
end

function PetStrengthenPage:sortPetProps()
	local petProps = {}
	local arrStarLevelPetsWhite = {}
	local arrStarLevelPetsGreen = {}
	local arrStarLevelPetsBlue = {}
	local arrStarLevelPetsPurple = {}
	local arrStarLevelPetsYellow = {}
	local arrStarLevelPetsRed = {}
	local allProps = {}
	for i, prop in pairs(_ED.user_prop) do
		if prop.user_prop_template ~= nil then
			local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
			if dms.atoi(propData, prop_mould.props_type) == 21 then
				if dms.atoi(propData, prop_mould.prop_quality) == 0 then
					table.insert(arrStarLevelPetsWhite, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 1 then
					table.insert(arrStarLevelPetsGreen, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 2 then
					table.insert(arrStarLevelPetsBlue, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 3 then
					table.insert(arrStarLevelPetsPurple, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 4 then				
					table.insert(arrStarLevelPetsYellow, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 5 then				
					table.insert(arrStarLevelPetsRed, prop)
				end
			end
		end
	end
	for i=1, #arrStarLevelPetsRed do
		table.insert(allProps, arrStarLevelPetsRed[i])
	end
	for i=1, #arrStarLevelPetsYellow do
		table.insert(allProps, arrStarLevelPetsYellow[i])
	end
	for i=1, #arrStarLevelPetsPurple do
		table.insert(allProps, arrStarLevelPetsPurple[i])
	end
	for i=1, #arrStarLevelPetsBlue do
		table.insert(allProps, arrStarLevelPetsBlue[i])
	end
	for i=1, #arrStarLevelPetsGreen do
		table.insert(allProps, arrStarLevelPetsGreen[i])
	end
	for i=1, #arrStarLevelPetsWhite do
		table.insert(allProps, arrStarLevelPetsWhite[i])
	end
	local propCount = 0
	for k,prop in pairs(allProps) do

		for i=1,zstring.tonumber(prop.prop_number) do
			local cell = {}
			--深拷贝
			if propCount >= 5 then 
				break
			end
			cell.user_prop_id = prop.user_prop_id
			cell.user_prop_template = prop.user_prop_template
			cell.prop_number = prop.prop_number
			cell._isSelect = false
			propCount = propCount + 1
			cell._index = propCount
			table.insert(petProps, cell)
			
		end
	end
	return petProps
end

function PetStrengthenPage:onEnterTransitionFinish()

	local csbGeneralsQianghua = csb.createNode("packs/PetStorage/PetStorage_qianghua.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	--root:removeFromParent(false)
	local action = csb.createTimeline("packs/PetStorage/PetStorage_qianghua.csb") 
    csbGeneralsQianghua:runAction(action)
	self.action = action
	
    self:addChild(csbGeneralsQianghua)
    self.ArmatureNodePanel = ccui.Helper:seekWidgetByName(root, "Panel_donghua")   --
    self.ArmatureNode_1 = self.ArmatureNodePanel:getChildByName("ArmatureNode_2")
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNodePanel:setVisible(false)
	table.insert(self.roots, root)
	for i=1,5 do
		local addPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_prop_"..i)
		table.insert(self.panel_Add, addPanel)
		fwin:addTouchEventListener(addPanel, nil, 
		{
			terminal_name = "pet_strengthen_page_enter_choose_hero", 
			_ships = self.needPetsInfo, 
			touch_scale = true
		}, 
		nil, 0)
	end
	
	--防止重复刷新
	local Panel_wujiang = ccui.Helper:seekWidgetByName(root,"Panel_wujiang")
	Panel_wujiang:removeAllChildren(true)
	local shipCell = ShipBodyCell:createCell()
	shipCell:init(self.ship, 0)
	Panel_wujiang:addChild(shipCell)

	self.currentAttributeText = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_ddengji_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_1"),
	}
	self.nextAttributeText = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_ddengji_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_1_0"),
	}

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1_0"), nil, 
	{
		terminal_name = "pet_strengthen_page_open_ex", 
		_ships = self.needPetsInfo, 
		touch_scale = true
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, 
	{
		terminal_name = "pet_strengthen_page_level_up", 
		_ships = self.needPetsInfo, 
		touch_scale = true
	}, 
	nil, 0)
	
	for i = 1, 5 do
		local Button_remove = ccui.Helper:seekWidgetByName(self.roots[1], "Button_s_"..i)
		table.insert(self.Button_removes, Button_remove)
		fwin:addTouchEventListener(Button_remove, nil, 
		{
			terminal_name = "pet_strengthen_page_cancel_one", 
			_pos = i, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end	
	self:onUpdateDraw()
end
function PetStrengthenPage:close()	

	local Panel_wujiang_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang")
	if Panel_wujiang_1 ~= nil then
		Panel_wujiang_1:removeAllChildren(true)		
	end
	
	cacher.destoryRefPools()
	cacher.removeAllTextures()
	cacher.cleanSystemCacher()
	
end
function PetStrengthenPage:onExit()
	state_machine.remove("pet_strengthen_page_open_ex")
	state_machine.remove("pet_strengthen_page_level_up")
	state_machine.remove("pet_strengthen_page_been_level_up_hero")
	state_machine.remove("pet_strengthen_page_clean")
	state_machine.remove("pet_strengthen_page_update_cost")
	state_machine.remove("pet_strengthen_page_update_info")
	state_machine.remove("pet_strengthen_page_enter_choose_hero")
	state_machine.remove("pet_strengthen_page_cancel_one")
	state_machine.remove("pet_strengthen_page_check_exp")
	state_machine.remove("pet_strengthen_page_check_updata_by_other_page")
	state_machine.remove("pet_strengthen_page_one_key")
	state_machine.remove("pet_strengthen_page_streng_succeed_update")
end

function PetStrengthenPage:getOfferOfExp(mouldId)
	local cellExp = dms.int(dms["prop_mould"],mouldId,prop_mould.use_of_experience)
	return cellExp
end

function PetStrengthenPage:init(shipId,types)
	self.shipId = shipId
	self.ship 	= fundShipWidthId(self.shipId) 
	self.types = types
end
