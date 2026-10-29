---------------------------------
---说明：武将信息界面的 天命卡
-- 创建时间:2015.03.17
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
---------------------------------

FormationHeroDestiny = class("FormationHeroDestinyClass", Window)
   
function FormationHeroDestiny:ctor()
    self.super:ctor()
	self.hero = nil
	self.types = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
    -- Initialize HeroInformation state machine.
    local function init_FormationHeroDestiny_terminal()
	
		local formation_hero_skill_destiny_terminal = {
            _name = "formation_hero_skill_destiny",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroSkillStrenPage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local arena_grade=dms.int(dms["fun_open_condition"], 4, fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					local cell = instance.types
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						state_machine.excute("hero_develop_page_manager", 0, 
							{
								_datas = {
									terminal_name = "hero_develop_page_manager", 
									next_terminal_name = "hero_develop_page_open_skill_stren_page",	
									current_button_name = "Button_tianming_child",  	
									but_image = "", 	
									terminal_state = 0, 
									shipId = params._datas._ship_id,
									openWinId = 4,
									isPressedActionEnabled = true
								}
							}
						)
					else
						state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
						state_machine.excute("hero_information_close", 0, "hero_information_close")
						local layer = HeroDevelop:new()
						layer:init(params._datas._ship_id, cell)
						fwin:open(layer, fwin._viewdialog)
						state_machine.excute("hero_storage_hide_window", 0)
						if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
							state_machine.excute("hero_develop_page_manager", 0, 
								{
									_datas = {
										terminal_name = "hero_develop_page_manager", 
										next_terminal_name = "hero_develop_page_open_skill_stren_page",	
										current_button_name = "Button_tianming",  	
										but_image = "", 	
										terminal_state = 0, 
										shipId = params._datas._ship_id,
										openWinId = 4,
										isPressedActionEnabled = false
									}
								}
							)
						else
							state_machine.excute("hero_develop_page_manager", 0, 
								{
									_datas = {
										terminal_name = "hero_develop_page_manager", 
										next_terminal_name = "hero_develop_page_open_skill_stren_page",	
										current_button_name = "Button_6",  	
										but_image = "", 	
										terminal_state = 0, 
										shipId = params._datas._ship_id,
										openWinId = 4,
										isPressedActionEnabled = false
									}
								}
							)
						end
						
					end
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 4, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		state_machine.add(formation_hero_skill_destiny_terminal)	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_FormationHeroDestiny_terminal()	

end

function FormationHeroDestiny:onUpdateDraw()
	local root = self.roots[1]
	
	if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
		tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.hero.ship_id) then
		level = _ED.hero_skillstren_info.level
	else
		level = self.hero.ship_skillstren.skill_level
	end
	local Text_tmdj_0 = ccui.Helper:seekWidgetByName(root, "Text_tmdj_0")
	Text_tmdj_0:setString(level)
end

function FormationHeroDestiny:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_5 = csb.createNode("packs/HeroStorage/generals_information_5.csb")
	local root = csbGeneralsInformation_5:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_5)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_tianming")
	local MySize = PanelGeneralsEquipment:getContentSize()
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		self:setContentSize(MySize.width,MySize.height+MySize.height/3)
		PanelGeneralsEquipment:setPosition(PanelGeneralsEquipment:getPositionX(),PanelGeneralsEquipment:getPositionY()+MySize.height/3)
	else
		self:setContentSize(MySize.width,MySize.height)
		PanelGeneralsEquipment:setPosition(PanelGeneralsEquipment:getPositionX(),PanelGeneralsEquipment:getPositionY())
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if self.hero == nil then
			PanelGeneralsEquipment:setPosition(PanelGeneralsEquipment:getPositionX(),PanelGeneralsEquipment:getPositionY() + 4)
			local Text_tmdj_0 = ccui.Helper:seekWidgetByName(root, "Text_tmdj_0")
			Text_tmdj_0:setString(" ")
			return
		end
		self:setContentSize(MySize.width,MySize.height - 10)
		PanelGeneralsEquipment:setPosition(PanelGeneralsEquipment:getPositionX(),PanelGeneralsEquipment:getPositionY() - 6)
	end
	self:onUpdateDraw()
	
	--天命
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil, 
	{
		terminal_name = "formation_hero_skill_destiny",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end


function FormationHeroDestiny:onExit()
	state_machine.remove("formation_hero_skill_destiny")
end

function FormationHeroDestiny:init(hero,types)
	self.hero = hero
	self.types = types
end

function FormationHeroDestiny:createCell()
	local cell = FormationHeroDestiny:new()
	cell:registerOnNodeEvent(cell)
	return cell
end