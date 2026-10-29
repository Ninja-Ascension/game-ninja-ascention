-- ----------------------------------------------------------------------------------------------------
-- 说明：武将出售界面提示框
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroSellTip = class("HeroSellTipClass", Window)
   
function HeroSellTip:ctor()
    self.super:ctor()
	self.hero = nil
	self.roots = {}
	self.price = 0
	self.index = 1 -- 出售武将 2 出售魔法卡陷阱卡 3出售陷阱卡
    -- Initialize Home page state machine.
    local function init_hero_sell_tip_terminal()
		--确定
		local hero_sell_tip_to_ok_terminal = {
            _name = "hero_sell_tip_to_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		state_machine.lock("hero_sell_tip_to_ok")
            	end
				local function responseSellHeroCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.price == nil then
	            			return
	            		end
						TipDlg.drawTextDailog(_string_piece_info[93]..instance.price)
						state_machine.excute("hero_sell_true_update_cell_status", 0, "hero_sell_true_update_cell_status.")
						fwin:close(instance)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							state_machine.unlock("hero_sell_tip_to_ok")
						end
					else
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							state_machine.unlock("hero_sell_tip_to_ok")
						end
					end
				end
				
				local temp = nil
				for i, v in pairs(instance.hero) do
					if i == 1 then
						temp = v.ship_id .. ","
					else
						temp = temp .. v.ship_id .. ","
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("hero_list_view_remove_cell",0,instance.hero)
				end
				protocol_command.ship_sell.param_list = temp
				NetworkManager:register(protocol_command.ship_sell.code, nil, nil, nil, instance, responseSellHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local magic_card_sell_tip_to_ok_terminal = {
            _name = "magic_card_sell_tip_to_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				local function responseSellMagicCardCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
	            		if response.node == nil or response.node.price == nil then
	            			return
	            		end
						TipDlg.drawTextDailog(_string_piece_info[93]..instance.price)
						state_machine.excute("magic_card_sell_true_update_cell_status", 0, 0)
						state_machine.excute("magic_card_main_choose_sell_ok_update", 0, self.index)
						fwin:close(instance)
						
					else
						state_machine.unlock("hero_sell_tip_to_return")
					end
				end
				
				local temp = ""
				for i, v in pairs(instance.hero) do
					
					if temp ~= "" then
						temp = temp .. "\r\n"
					end
					temp = temp..v.user_prop_id.."\r\n".."1"
				end
				
				protocol_command.prop_sell.param_list = temp .. "\r\n" 
				NetworkManager:register(protocol_command.prop_sell.code, nil, nil, nil, instance, responseSellMagicCardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回
		local hero_sell_tip_to_return_terminal = {
            _name = "hero_sell_tip_to_return",
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
		
		state_machine.add(hero_sell_tip_to_ok_terminal)
		state_machine.add(hero_sell_tip_to_return_terminal)
		state_machine.add(magic_card_sell_tip_to_ok_terminal)
		

        state_machine.init()
    end
    
    init_hero_sell_tip_terminal()
end


function HeroSellTip:onEnterTransitionFinish()
    local csbHeroSellTip = csb.createNode("packs/EquipStorage/equipment_sell_prompt.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_sell_prompt.csb")
	csbHeroSellTip:runAction(action)
    self:addChild(csbHeroSellTip)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	local root = csbHeroSellTip:getChildByName("root")
	table.insert(self.roots, root)
	ccui.Helper:seekWidgetByName(root, "Text_5"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_5"):setVisible(true)
	self.price = 0
	if self.index == 1 then 
		local num = 0
		for i, v in pairs(self.hero) do
			num = num + 1
			self.price = self.price + dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.sell_get_money)
		end
		
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[25]..num.._string_piece_info[32].._string_piece_info[33]..",".."\r\n".._string_piece_info[27]..self.price.._string_piece_info[28])
		local okButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {func_string = [[state_machine.excute("hero_sell_tip_to_ok", 0, "click hero_sell_tip_to_ok.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	else
		local num = 0
		for i, v in pairs(self.hero) do
			num = num + 1
			self.price = self.price + dms.int(dms["prop_mould"], v.user_prop_template, prop_mould.silver_price)
		end
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[25]..num.._string_piece_info[32].._magic_card_tip[3]..",".."\r\n".._string_piece_info[27]..self.price.._string_piece_info[28])
		local okButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {func_string = [[state_machine.excute("magic_card_sell_tip_to_ok", 0, "click hero_sell_tip_to_ok.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	end
	local return_hero = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {func_string = [[state_machine.excute("hero_sell_tip_to_return", 0, "click hero_sell_tip_to_return.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	local buttonBack = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("hero_sell_tip_to_return", 0, "click hero_sell_tip_to_return.'")]]}, nil, 0)
end


function HeroSellTip:onExit()
	state_machine.remove("hero_sell_tip_to_ok")
	state_machine.remove("hero_sell_tip_to_return")
	state_machine.remove("magic_card_sell_tip_to_ok")
end

function HeroSellTip:init(hero,index)
	self.hero = hero
	if index == nil then 
		self.index = 1
	else
		--出售魔法卡 2 魔法卡 3陷阱卡
		self.index = index
	end
end
