---------------------------------
---说明：宠物信息界面的 基础信息卡
---------------------------------

PetBaseInformation = class("PetBaseInformationClass", Window)
   
function PetBaseInformation:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	app.load("client.packs.pet.PetDevelop")
	self.types = nil
    -- Initialize HeroInformation state machine.
    local function init_PetBaseInformation_terminal()
		--强化
		local pet_formation_show_Level_up_page_terminal = {
            _name = "pet_formation_show_Level_up_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
					local cell = instance.types
					local fun_id = 56
	                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
	                    fun_id = 60
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
							next_terminal_name = "pet_develop_page_open_strengthen_page", 
							current_button_name = "Button_zhanchong",
							but_image = "", 		
							heroInstance = instance.hero,
							terminal_state = 0,
							openWinId = 33,
							isPressedActionEnabled = false
						}
					}
				)
				state_machine.excute("pet_information_close", 0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		state_machine.add(pet_formation_show_Level_up_page_terminal)	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_PetBaseInformation_terminal()
end

function PetBaseInformation:onUpdateDraw()
	local root = self.roots[1]
	local Text_gongji_0 = ccui.Helper:seekWidgetByName(root, "Text_3")		--攻击
	local Text_wufang_0 = ccui.Helper:seekWidgetByName(root, "Text_5")		--物防
	local Text_shengming_0 = ccui.Helper:seekWidgetByName(root, "Text_8")			--生命
	local Text_fafang_0 = ccui.Helper:seekWidgetByName(root, "Text_9")				--法防

	Text_gongji_0:setString(self.hero.ship_courage)
	Text_wufang_0:setString(self.hero.ship_intellect)
	Text_shengming_0:setString(self.hero.ship_health)
	Text_fafang_0:setString(self.hero.ship_quick)
end

function PetBaseInformation:onEnterTransitionFinish()

    --获取 宠物碎片选项卡 美术资源
    local csbGeneralsInformation_3 = csb.createNode("packs/PetStorage/PetStorage_information_list_1.csb")
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
		terminal_name = "pet_formation_show_Level_up_page",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	local fun_id = 56
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        fun_id = 60
    end
	local qhLevel = dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level)
	local pet_level = zstring.tonumber(self.hero.ship_grade)
	if pet_level >= zstring.tonumber(_ED.user_info.user_grade) then 
		--强化满级了
		upButton:setTouchEnabled(false)
		upButton:setColor(cc.c3b(150, 150, 150))
	else
		upButton:setTouchEnabled(true)
		upButton:setColor(cc.c3b(255, 255, 255))
	end
end

function PetBaseInformation:onExit()
	state_machine.remove("pet_formation_show_Level_up_page")
end

function PetBaseInformation:init(hero, types)
	self.hero = hero
	self.types = types
end

function PetBaseInformation:createCell()
	local cell = PetBaseInformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end