---------------------------------
---说明：武将信息界面的 基础信息卡
-- 创建时间:2015.03.17
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
---------------------------------

LHeroBaseInformationFormation = class("LHeroBaseInformationFormationClass", Window)
   
function LHeroBaseInformationFormation:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	app.load("client.packs.hero.HeroDevelop")
	self.types = nil
    -- Initialize HeroInformation state machine.
    local function init_HeroBaseInformation_terminal()
	
		-- --升级、突破、培养 按钮响应
		-- local hero_formation_show_Level_up_page_terminal = {
  --           _name = "hero_formation_show_Level_up_page",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
		-- 		local arena_grade=dms.int(dms["fun_open_condition"], 33, fun_open_condition.level)
		-- 		if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
		-- 			local cell = instance.types
		-- 			state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
		-- 			state_machine.excute("hero_information_close", 0, "hero_information_close")
		-- 			if fwin:find("HeroDevelopClass") ~= nil then
		--     			fwin:close(fwin:find("HeroDevelopClass"))
		--     		end					
		-- 			local layer = HeroDevelop:new()
		-- 			layer:init(params._datas._ship_id, cell)
		-- 			fwin:open(layer, fwin._viewdialog)
		-- 			state_machine.excute("hero_storage_hide_window", 0)
		-- 			state_machine.excute("hero_develop_page_manager", 0, 
		-- 				{
		-- 					_datas = {
		-- 						terminal_name = "hero_develop_page_manager", 	
		-- 						next_terminal_name = "hero_develop_page_open_strengthen_page",	
		-- 						current_button_name = "Button_shengji",  	
		-- 						but_image = "", 	
		-- 						terminal_state = 0, 
		-- 						shipId = params._datas._ship_id,
		-- 						openWinId = 33,
		-- 						isPressedActionEnabled = false
		-- 					}
		-- 				}
		-- 			)
		-- 		else
		-- 			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],33, fun_open_condition.tip_info))
		-- 		end
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }	
		
		-- local hero_formation_show_break_page_terminal = {
  --           _name = "hero_formation_show_break_page",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
		-- 		local arena_grade=dms.int(dms["fun_open_condition"], 34, fun_open_condition.level)
		-- 		if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
		-- 			local cell = instance.types
		-- 			state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
		-- 			state_machine.excute("hero_information_close", 0, "hero_information_close")
		-- 			if fwin:find("HeroDevelopClass") ~= nil then
		--     			fwin:close(fwin:find("HeroDevelopClass"))
		--     		end						
		-- 			local layer = HeroDevelop:new()
		-- 			layer:init(params._datas._ship_id, cell)
		-- 			fwin:open(layer, fwin._viewdialog)
		-- 			state_machine.excute("hero_storage_hide_window", 0)
		-- 			state_machine.excute("hero_develop_page_manager", 0, 
		-- 				{
		-- 					_datas = {
		-- 						terminal_name = "hero_develop_page_manager", 	
		-- 						next_terminal_name = "hero_develop_page_open_advanced",	
		-- 						current_button_name = "Button_tupo",  	
		-- 						but_image = "", 	
		-- 						terminal_state = 0, 
		-- 						shipId = params._datas._ship_id,
		-- 						openWinId = 34,
		-- 						isPressedActionEnabled = false
		-- 					}
		-- 				}
		-- 			)
		-- 		else
		-- 			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],34, fun_open_condition.tip_info))
		-- 		end
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }	
		
		-- local hero_formation_show_develop_page_terminal = {
  --           _name = "hero_formation_show_develop_page",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params) 
		-- 		local arena_grade=dms.int(dms["fun_open_condition"], 3, fun_open_condition.level)
		-- 		if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
		-- 			local cell = instance.types
		-- 			state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
		-- 			state_machine.excute("hero_information_close", 0, "hero_information_close")
		-- 			if fwin:find("HeroDevelopClass") ~= nil then
		--     			fwin:close(fwin:find("HeroDevelopClass"))
		--     		end						
		-- 			local layer = HeroDevelop:new()
		-- 			layer:init(params._datas._ship_id, cell)
		-- 			fwin:open(layer, fwin._viewdialog)
		-- 			state_machine.excute("hero_storage_hide_window", 0)
		-- 			state_machine.excute("hero_develop_page_manager", 0, 
		-- 				{
		-- 					_datas = {
		-- 						terminal_name = "hero_develop_page_manager", 	
		-- 						next_terminal_name = "hero_develop_page_open_train_page",	
		-- 						current_button_name = "Button_peiyang",  	
		-- 						but_image = "", 	
		-- 						terminal_state = 0, 
		-- 						shipId = params._datas._ship_id,
		-- 						openWinId = 3,
		-- 						isPressedActionEnabled = false
		-- 					}
		-- 				}
		-- 			)
		-- 		else
		-- 			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],3, fun_open_condition.tip_info))
		-- 		end
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }	
		
		-- state_machine.add(hero_formation_show_Level_up_page_terminal)	
		-- state_machine.add(hero_formation_show_break_page_terminal)	
		-- state_machine.add(hero_formation_show_develop_page_terminal)	
	
  --       state_machine.init()
    end
    
  --   -- call func init hom state machine.
    init_HeroBaseInformation_terminal()
end

function LHeroBaseInformationFormation:onUpdateDraw()
	local root = self.roots[1]
	local Text_dengji_0 = ccui.Helper:seekWidgetByName(root, "Text_dengji_0")		--等级
	local Text_gongji_0 = ccui.Helper:seekWidgetByName(root, "Text_gongji_0")		--攻击
	local Text_wufang_0 = ccui.Helper:seekWidgetByName(root, "Text_wufang_0")		--物防
	local Text_tupodengji_0 = ccui.Helper:seekWidgetByName(root, "Text_tupodengji_0")		--突破等级
	local Text_shengming_0 = ccui.Helper:seekWidgetByName(root, "Text_shengming_0")			--生命
	local Text_fafang_0 = ccui.Helper:seekWidgetByName(root, "Text_fafang_0")				--法防
	
	Text_dengji_0:setString(self.hero.ship_grade)
	Text_gongji_0:setString(self.hero.ship_courage)
	Text_wufang_0:setString(self.hero.ship_intellect)
	Text_tupodengji_0:setString("+" .. dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.initial_rank_level))
	Text_shengming_0:setString(self.hero.ship_health)
	Text_fafang_0:setString(self.hero.ship_quick)
	
end

function LHeroBaseInformationFormation:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_3 = csb.createNode("packs/HeroStorage/generals_information_10.csb")
	local root = csbGeneralsInformation_3:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_3)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_jichuxinxi")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if self.hero == nil then
			return
		end
	end
	self:onUpdateDraw()

end


function LHeroBaseInformationFormation:onExit()
	-- state_machine.remove("hero_formation_show_Level_up_page")
	-- state_machine.remove("hero_formation_show_break_page")
	-- state_machine.remove("hero_formation_show_develop_page")
end

function LHeroBaseInformationFormation:init(hero, types)
	self.hero = hero
	self.types = types
end

function LHeroBaseInformationFormation:createCell()
	local cell = LHeroBaseInformationFormation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end