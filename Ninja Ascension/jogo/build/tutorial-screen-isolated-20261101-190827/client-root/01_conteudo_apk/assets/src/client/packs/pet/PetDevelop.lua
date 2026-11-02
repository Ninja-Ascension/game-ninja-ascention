-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的宠物各种强化界面
-------------------------------------------------------------------------------------------------------
PetDevelop = class("PetDevelopClass", Window)

function PetDevelop:ctor()
    self.super:ctor()
	self.roots = {}
	self.group = {
		_strengthen = nil, --强化
		_awaken = nil,	   --升星
		_train = nil       --训练
	}
	self.types = nil
	app.load("client.player.UserInformationHeroStorage")	
	self.shipId = "1"                   --当前武将ID
    self.hero = nil

	self.armature_effic = nil
	self.normal_armature_effic = nil
	self.animation_index = nil
	self.effic_id = nil

    local function init_pet_develop_page_terminal()
		local pet_develop_page_manager_terminal = {
            _name = "pet_develop_page_manager",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance == nil then
        			return
        		end
				-- set select ui button is highlighted
				local arena_grade=dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level)
				if arena_grade == nil or arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					
					if terminal.last_terminal_name ~= params._datas.next_terminal_name then
						for i, v in pairs(instance.group) do
							if v ~= nil then
								v:setVisible(false)
							end
						end
						terminal.last_terminal_name = params._datas.next_terminal_name
						state_machine.excute(params._datas.next_terminal_name, 0, params)
					end
					if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
						terminal.select_button:setHighlighted(false)
						terminal.select_button:setTouchEnabled(true)
					end
					
					if terminal.select_button == nil and params._datas.current_button_name ~= nil then
						terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				
					else
						terminal.select_button = params
					end
					
					if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
						terminal.select_button:setHighlighted(true)
						terminal.select_button:setTouchEnabled(false)
					end
					if tonumber(_ED.user_ship[""..instance.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_zhanchong"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_zhanchong"):setTouchEnabled(false)
					end
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关闭当前窗口
		local pet_develop_page_close_terminal = {
            _name = "pet_develop_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance == nil then
        			return
        		end
				for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				
				fwin:close(fwin:find("PetDevelopClass"))
				state_machine.excute("pet_storage_show_window", 0, params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--1.升级 
		local pet_develop_page_open_strengthenpage_terminal = {
            _name = "pet_develop_page_open_strengthen_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._strengthen == nil then
					app.load("client.packs.pet.PetStrengthenPage")
					instance.group._strengthen = PetStrengthenPage:new()
					instance.group._strengthen:init(instance.shipId,instance.types)
					fwin:open(instance.group._strengthen, fwin._view)
				end
				
				instance.group._strengthen:setVisible(true)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--3.训练
		local pet_develop_page_open_train_terminal = {
            _name = "pet_develop_page_open_train_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.group._train == nil then
					app.load("client.packs.pet.PetTrainPage")
					instance.group._train = PetTrainPage:new()
					instance.group._train:init(instance.shipId)
					fwin:open(instance.group._train, fwin._view)
				end
				instance.group._train:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--2.升星
		local pet_develop_page_open_juexin_terminal = {
            _name = "pet_develop_page_open_juexin",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		if instance.group._starUp == nil then
					app.load("client.packs.pet.PetStarUpPage")
					instance.group._starUp = PetStarUpPage:new()
					instance.group._starUp:init(instance.shipId, instance.types)
					fwin:open(instance.group._starUp, fwin._view)
				end
				instance.group._starUp:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --刷新宠物数据
		local pet_develop_update_pet_terminal = {
            _name = "pet_develop_update_pet",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
	            	instance:onUpdateDraw()
	            end
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(pet_develop_page_manager_terminal)	
        state_machine.add(pet_develop_page_close_terminal)	
        state_machine.add(pet_develop_page_open_strengthenpage_terminal)
        state_machine.add(pet_develop_page_open_advanced_terminal)
        state_machine.add(pet_develop_page_open_train_terminal)
        state_machine.add(pet_develop_page_open_skill_stren_terminal)
        state_machine.add(pet_develop_page_open_juexin_terminal)
        state_machine.add(pet_develop_page_update_terminal)
        state_machine.add(pet_develop_update_pet_terminal)
        state_machine.init()
    end
    init_pet_develop_page_terminal()
end

function PetDevelop:changeHeroAnimation(play_type)
	
end

function PetDevelop:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.hero = _ED.user_ship["" .. self.shipId]
    local zhanliText = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
    zhanliText:setString(""..self.hero.hero_fight)
    local ship_template_id = _ED.user_ship["" .. self.shipId].ship_template_id
    local jinjieLevel = dms.int(dms["ship_mould"],ship_template_id,ship_mould.initial_rank_level)
    for i=1,5 do
        local starImage = ccui.Helper:seekWidgetByName(root, "Image_x_"..i)
        starImage:setVisible(false)
        if i <= jinjieLevel then 
            starImage:setVisible(true)
        end
    end
    local ship_type = dms.string(dms["ship_mould"],ship_template_id,ship_mould.ship_type) +1
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Text_name:setString(self.hero.captain_name)
    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
end

function PetDevelop:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/PetStorage/PetStorage_list_1.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
	
    self:onUpdateDraw()
    app.load("client.player.EquipPlayerInfomation")
    if fwin:find("EquipPlayerInfomationClass") == nil then
        fwin:open(EquipPlayerInfomation:new(),fwin._windows)
    end
    local tempIsPressedActionEnabled = true
    if __lua_project_id == __lua_project_pokemon then
    	tempIsPressedActionEnabled = false
    end
	local Button_fanhui = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_back"), nil, 
	{
		terminal_name = "pet_develop_page_close", 
		shipId = self.shipId,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
    --升级
	local Button_shengji = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanchong"), nil, 
	{
		terminal_name = "pet_develop_page_manager", 	
		next_terminal_name = "pet_develop_page_open_strengthen_page", 			
		current_button_name = "Button_zhanchong", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = 56,
		isPressedActionEnabled = tempIsPressedActionEnabled
	}, 
	nil, 0)
	
    --升星
	local Button_tupo = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_suipian"), nil, 
	{
		terminal_name = "pet_develop_page_manager", 	
		next_terminal_name = "pet_develop_page_open_juexin", 			
		current_button_name = "Button_suipian", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = 57,
		isPressedActionEnabled = tempIsPressedActionEnabled
	},
	nil, 0)
	
    --训练
	local Button_peiyang = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_pieces_tujian"), nil, 
	{
		terminal_name = "pet_develop_page_manager", 	
		next_terminal_name = "pet_develop_page_open_train_page", 			
		current_button_name = "Button_pieces_tujian", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = 58,
		isPressedActionEnabled = tempIsPressedActionEnabled
	}, 
	nil, 0)
end

function PetDevelop:close()
    local playerInfoWindow = fwin:find("EquipPlayerInfomationClass")
    if playerInfoWindow ~= nil then 
        fwin:close(playerInfoWindow)
    end
end

function PetDevelop:onExit()
	state_machine.remove("pet_develop_page_manager")
	state_machine.remove("pet_develop_page_close")
	state_machine.remove("pet_develop_page_open_strengthen_page")
	state_machine.remove("pet_develop_page_open_advanced")
	state_machine.remove("pet_develop_page_open_train_page")
	state_machine.remove("pet_develop_page_open_skill_stren_page")
	state_machine.remove("pet_develop_page_open_juexin")
	state_machine.remove("pet_develop_page_update")
    state_machine.remove("pet_develop_update_hero")
    state_machine.remove("pet_develop_update_pet")
end

function PetDevelop:init(shipId, types)
	self.shipId = shipId
	self.types = types
end