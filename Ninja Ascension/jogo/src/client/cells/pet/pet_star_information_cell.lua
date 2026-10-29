---------------------------------
---说明：宠物星数信息界面的 基础信息卡
---------------------------------

PetStarInformation = class("PetStarInformationClass", Window)
   
function PetStarInformation:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	app.load("client.packs.pet.PetDevelop")
	self.types = nil
    -- Initialize HeroInformation state machine.
    local function init_PetStarInformation_terminal()
		--升级
		local pet_formation_show_star_up_page_terminal = {
            _name = "pet_formation_show_star_up_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = instance.types
				local fun_id = 57
			    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			        fun_id = 61
			    end
				if dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level) > zstring.tonumber(_ED.user_info.user_grade) then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
					return
				end
				if fwin:find("PetDevelopClass") ~= nil then
	    			fwin:close(fwin:find("PetDevelopClass"))
	    		end					
				local layer = PetDevelop:new()
				layer:init(params._datas._ship_id, cell)
				fwin:open(layer, fwin._viewdialog)
				state_machine.excute("pet_storage_hide_window", 0)
				state_machine.excute("pet_develop_page_manager", 0, 
				{
					_datas = {
						terminal_name = "pet_develop_page_manager", 	
						next_terminal_name = "pet_develop_page_open_juexin", 
						current_button_name = "Button_suipian",
						but_image = "", 		
						heroInstance = instance.ship,
						terminal_state = 0,
						openWinId = 57,
						isPressedActionEnabled = false
					}
				})
				state_machine.excute("pet_information_close", 0,0)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        --获取
		local pet_formation_find_to_get_terminal = {
            _name = "pet_formation_find_to_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local petId = dms.int(dms["ship_mould"] ,self.hero.ship_template_id,ship_mould.base_mould2)
				local proprId = dms.int(dms["pet_mould"] ,petId,pet_mould.prop_piece_id)
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(proprId,5)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		state_machine.add(pet_formation_show_star_up_page_terminal)	
		state_machine.add(pet_formation_find_to_get_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_PetStarInformation_terminal()
end

function PetStarInformation:onUpdateDraw()
	local root = self.roots[1]
	local Text_jindu = ccui.Helper:seekWidgetByName(root, "Text_26")		--进度
	local shipData = dms.element(dms["ship_mould"], self.hero.ship_template_id)
	
	Text_jindu:setString("")
	local pet_mould_id = zstring.tonumber(self.hero.ship_template_id)
	local currentLevel =  dms.int(dms["ship_mould"],pet_mould_id,ship_mould.initial_rank_level)
	for i=1,5 do
		local starImage = ccui.Helper:seekWidgetByName(root, "Image_x_".. i)
		starImage:setVisible(false)
		if i <= currentLevel then 
			starImage:setVisible(true)
		end
	end
	local pet_star_id = dms.atoi(shipData,ship_mould.required_material_id)
	local petStarData = dms.element(dms["pet_star_param"], pet_star_id)
	local need_same_piece_count = dms.atoi(petStarData, pet_star_param.need_same_piece_count)
	local upStarButton = ccui.Helper:seekWidgetByName(root, "Button_qh")
	local starPanel = ccui.Helper:seekWidgetByName(root, "Panel_4")
	local Text_mj = ccui.Helper:seekWidgetByName(root, "Text_mj")
	Text_mj:setVisible(false)
	starPanel:setVisible(true)
	if currentLevel >= 5 then 
		--满星
		upStarButton:setTouchEnabled(false)
		upStarButton:setColor(cc.c3b(150, 150, 150))
		starPanel:setVisible(false)
		Text_mj:setVisible(true)
		return
	end
	local base_mould2 = dms.atoi(shipData, ship_mould.base_mould2)
	local prop_piece_id = dms.int(dms["pet_mould"], base_mould2, pet_mould.prop_piece_id)
	prop = fundPropWidthId(prop_piece_id)
	
	count = 0
	if prop ~= nil then
		count = prop.prop_number
	end
	Text_jindu:setString("".. count.."/"..need_same_piece_count)
	local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	local progressBar = count / need_same_piece_count * 100
	if progressBar < 0 then 
		progressBar = 0
	elseif progressBar > 100 then 
		progressBar = 100
	end
	LoadingBar_1:setPercent(progressBar)
end

function PetStarInformation:onEnterTransitionFinish()

    --获取 宠物碎片选项卡 美术资源
    local csbGeneralsInformation_3 = csb.createNode("packs/PetStorage/PetStorage_information_list_2.csb")
	local root = csbGeneralsInformation_3:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_3)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()

	local upButton = ccui.Helper:seekWidgetByName(root, "Button_qh")
	fwin:addTouchEventListener(upButton, nil, 
	{
		terminal_name = "pet_formation_show_star_up_page",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "pet_formation_find_to_get",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
end

function PetStarInformation:onExit()
	state_machine.remove("pet_formation_show_star_up_page")
end

function PetStarInformation:init(hero, types)
	self.hero = hero
	self.types = types
end

function PetStarInformation:createCell()
	local cell = PetStarInformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end