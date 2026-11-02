-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物信息面板显示
-------------------------------------------------------------------------------------------------------

PetInformation = class("PetInformationClass", Window)

PetInformation.__userHeroFontName = nil
local pet_information_open_window_terminal = {
    _name = "pet_information_open_window",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local ship = params[1]
    	local enter_type = params[2]
		if ship == nil then
			ship = params
		end
		local heroInfo = PetInformation:new()
		heroInfo:init(ship,enter_type)
		fwin:open(heroInfo, fwin._ui) 
		
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(pet_information_open_window_terminal)	
state_machine.init()
    
function PetInformation:ctor()
    self.super:ctor()
	
	app.load("client.cells.pet.pet_base_information_cell")
	app.load("client.cells.pet.pet_star_information_cell")
	app.load("client.cells.pet.pet_skill_information_cell")
	app.load("client.cells.pet.pet_train_information_cell")
	app.load("client.cells.pet.pet_describe_information_cell")
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}

	self.hero = nil
	
	self.current_type = 0
	self.enum_type = {
		_LISTVIEW_FORMATION = 1,				--宠物列表中弹出战宠信息
		_FORMATION = 2,			-- 阵容中
	}
	
    -- Initialize PetInformation state machine.
    local function init_PetInformation_terminal()
		local pet_information_close_terminal = {
            _name = "pet_information_close",
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
		
        local pet_formation_update_terminal = {
            _name = "pet_formation_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        --更换
        local pet_information_change_terminal = {
            _name = "pet_information_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if instance ~= nil and instance.roots ~= nil then 
            		app.load("client.packs.pet.PetFormationChoiceWear")
            		local petChooseWindow = PetFormationChoiceWear:new()
            		petChooseWindow:init(instance.current_type)
            		fwin:open(petChooseWindow, fwin._ui)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --卸下
        local pet_information_off_terminal = {
            _name = "pet_information_off",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local function responsePetUpCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil then 
							return
						end
						response.node:onUpdateDraw()
						if zstring.tonumber(response.node.current_type) == response.node.enum_type._LISTVIEW_FORMATION then 
							--宠物列表中进来的
							state_machine.excute("pet_list_view_update_formation", 0,0)
						else
							--阵容界面
							state_machine.excute("formation_hero_change_pet_update", 0,-1)
						end
					end
					state_machine.excute("pet_information_close",0,0)
				end
            	local shipId = params._datas._ship.ship_id
				protocol_command.pet_change_formation.param_list = "" ..shipId .."\r\n".. "1"
				NetworkManager:register(protocol_command.pet_change_formation.code, nil, nil, nil, instance, responsePetUpCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --上阵
        local pet_information_up_terminal = {
            _name = "pet_information_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
             	local function responsePetUpCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil then 
							return
						end
						response.node:onUpdateDraw()
						if zstring.tonumber(response.node.current_type) == response.node.enum_type._LISTVIEW_FORMATION then 
							--宠物列表中进来的
							state_machine.excute("pet_list_view_update_formation", 0,0)
						end
					end
				end

            	local shipId = params._datas._ship.ship_id
				protocol_command.pet_change_formation.param_list = "" ..shipId .."\r\n".. "0"
				NetworkManager:register(protocol_command.pet_change_formation.code, nil, nil, nil, instance, responsePetUpCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_information_close_terminal)	
		state_machine.add(pet_formation_update_terminal)
		state_machine.add(pet_information_off_terminal)
		state_machine.add(pet_information_up_terminal)
		state_machine.add(pet_information_change_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_PetInformation_terminal()
end

function PetInformation:formatData()

	local data = {}
	
	data.quality = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ship_type)
	data.camp = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.capacity)
	data.heroType = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.camp_preference)
	data.ability = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ability)
	data.rankLevelFront = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.initial_rank_level)
	data.AllIcon = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.All_icon)
	data.captain_type = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_type)
	data.relationship_count = self.hero.relationship_count	
	data.talent_count = self.hero.talent_count	
	return data
end

function PetInformation:onUpdateDraw()
	local root = self.roots[1]
	
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_3")			--武将名字
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")			--ListView
	local panelWujiang = ccui.Helper:seekWidgetByName(root, "Panel_4")
	
	local data = self:formatData()
	local quality = data.quality
	local camp = data.camp
	local heroType = data.heroType
	local ability = data.ability
	local rankLevelFront = data.rankLevelFront
	local AllIcon = data.AllIcon
	local captain_type = data.captain_type
	local level=data.ship_grade

	Text_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

	Text_name:setString(self.hero.captain_name)

	panelWujiang:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
	local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
	Text_zhanli:setString(self.hero.hero_fight)
	ListView_1:removeAllItems()

	local currentLevel =  dms.int(dms["ship_mould"],self.hero.ship_template_id,ship_mould.initial_rank_level)
	for i=1,5 do
		local starImage = ccui.Helper:seekWidgetByName(root, "Image_star_".. i.. "_0")
		starImage:setVisible(false)
		if i <= currentLevel then 
			starImage:setVisible(true)
		end
	end
	
	for i =1, 6 do
		if i == 1 then
			local cell = PetBaseInformation:createCell()
			cell:init(self.hero)
			ListView_1:addChild(cell)
		elseif i == 2 then
			local cell = PetStarInformation:createCell()
			cell:init(self.hero)
			ListView_1:addChild(cell)
		elseif i == 3 then
			local cell = PetInformationSkill:createCell()
			cell:init(self.hero)
			ListView_1:addChild(cell)
		elseif i == 4 then
			local cell = PetTrainInformation:createCell()
			cell:init(self.hero)
			ListView_1:addChild(cell)
		elseif i == 5 then
			local cell = PetDescribeformation:createCell()
			cell:init(self.hero)
			ListView_1:addChild(cell)
		 end
	end

	local Panel_change = ccui.Helper:seekWidgetByName(root, "Panel_change")
	local Panel_up = ccui.Helper:seekWidgetByName(root, "Panel_up")
	local Panel_down = ccui.Helper:seekWidgetByName(root, "Panel_down")
	Panel_change:setVisible(false)
	Panel_up:setVisible(false)
	Panel_down:setVisible(false)
	
	if _ED.formation_pet_id == nil or _ED.formation_pet_id == 0  then 
		--没有上阵的
		Panel_up:setVisible(true)
	else
		--上阵了
		if _ED.formation_pet_id == zstring.tonumber(self.hero.ship_id) then 
			--上阵的是自己
			Panel_change:setVisible(true)
		else
			Panel_up:setVisible(true)
		end
	end
	
	local Panel_pinz = ccui.Helper:seekWidgetByName(root, "Panel_pinz")
	Panel_pinz:setBackGroundImage(string.format("images/ui/text/xspz_%d.png", quality))
end

function PetInformation:onEnterTransitionFinish()
    local csbGeneralsInformation_1 = csb.createNode("packs/PetStorage/pet_information.csb")
	local root = csbGeneralsInformation_1:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "pet_information_close",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, 
	nil, 0)
    
    --卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
	{
		terminal_name = "pet_information_off",
		terminal_state = 0,
		_ship = self.hero,
		isPressedActionEnabled = true
	}, 
	nil, 0)

    --更换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
	{
		terminal_name = "pet_information_change",
		terminal_state = 0,
		_ship = self.hero,
		isPressedActionEnabled = true
	}, 
	nil, 0)

    --上阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_0"), nil, 
	{
		terminal_name = "pet_information_up",
		terminal_state = 0,
		_ship = self.hero,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	self:onUpdateDraw()
end

function PetInformation:close()

end

function PetInformation:onExit()
	state_machine.remove("pet_information_close")
	state_machine.remove("pet_formation_update")
	state_machine.remove("pet_information_off")
	state_machine.remove("pet_information_up")
	state_machine.remove("pet_information_change")
end

--在抢夺中,调用这里的武将信息查看,是在另一张表里.所以修改下参数,传个表的类型进来
--mould_type : int 表名类型
function PetInformation:init(hero, mould_type)
	self.hero = hero
	if nil == mould_type then
		mould_type = 1
	end
	self.current_type = mould_type
end

