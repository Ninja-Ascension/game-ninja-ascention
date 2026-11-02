-- ----------------------------------------------------------------------------------------------------
-- 说明：武将出售界面提示框2
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroSellTipTwo = class("HeroSellTipTwoClass", Window)
   
function HeroSellTipTwo:ctor()
    self.super:ctor()
	self.hero = nil
	self.roots = {}
	self.price = 0
    -- Initialize Home page state machine.
	local function init_hero_sell_tip_two_terminal()
		--跳转到分解界面
		local hero_sell_tip_two_to_resolve_terminal = {
            _name = "hero_sell_tip_two_to_resolve",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 				
				fwin:close(instance)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            	    local isopen,tip = getFunopenLevelAndTip(10)
                    if isopen == true then	
	                    state_machine.excute("hero_storage_close_all_window",0,"")
						local refiningFurnaceWindow = RefiningFurnace:new()
						fwin:cover(refiningFurnaceWindow, fwin._ui, true)
						fwin:uncover(refiningFurnaceWindow, {"MenuClass"})
						refiningFurnaceWindow = fwin:open(refiningFurnaceWindow, fwin._view)
						state_machine.excute("refining_furnace_manager", 0, 
							{
								_datas = {
									terminal_name = "refining_furnace_manager", 	
									next_terminal_name = "refining_furnace_show_hero_resolve_view",	
									current_button_name = "Button_wjfj",  	
									but_image = "", 	
									terminal_state = 0, 
									isPressedActionEnabled = false
								}
							}
						)
                    else
                        TipDlg.drawTextDailog(tip)
                    end
                else				
					local refiningFurnaceWindow = RefiningFurnace:new()
					fwin:cover(refiningFurnaceWindow, fwin._ui, true)
					fwin:uncover(refiningFurnaceWindow, {"MenuClass"})
					refiningFurnaceWindow = fwin:open(refiningFurnaceWindow, fwin._view)
					state_machine.excute("refining_furnace_manager", 0, 
						{
							_datas = {
								terminal_name = "refining_furnace_manager", 	
								next_terminal_name = "refining_furnace_show_hero_resolve_view",	
								current_button_name = "Button_wjfj",  	
								but_image = "", 	
								terminal_state = 0, 
								isPressedActionEnabled = false
							}
						}
					)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--继续出售
		local hero_sell_tip_two_to_sell_terminal = {
            _name = "hero_sell_tip_two_to_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroSellTip = HeroSellTip:new()
				heroSellTip:init(instance.hero)
				fwin:open(heroSellTip, fwin._dialog)
				
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--返回
		local hero_sell_tip_two_to_return_terminal = {
            _name = "hero_sell_tip_two_to_return",
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
		
		state_machine.add(hero_sell_tip_two_to_resolve_terminal)
		state_machine.add(hero_sell_tip_two_to_sell_terminal)
		state_machine.add(hero_sell_tip_two_to_return_terminal)

        state_machine.init()
    end
    
    init_hero_sell_tip_two_terminal()
end


function HeroSellTipTwo:onEnterTransitionFinish()
    local csbHeroSellTip = csb.createNode("packs/HeroStorage/generals_sell_prompt.csb")
	local action = csb.createTimeline("packs/HeroStorage/generals_sell_prompt.csb")
	csbHeroSellTip:runAction(action)
    self:addChild(csbHeroSellTip)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	local root = csbHeroSellTip:getChildByName("root")
	table.insert(self.roots, root)
	ccui.Helper:seekWidgetByName(root, "Text_5"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Panel_5"):setVisible(false)
	
	
	local return_hero = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("hero_sell_tip_two_to_resolve", 0, "click hero_sell_tip_two_to_resolve.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	local okButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("hero_sell_tip_two_to_sell", 0, "click hero_sell_tip_two_to_sell.'")]], 
									isPressedActionEnabled = true}, nil, 0)

	local buttonBack = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("hero_sell_tip_two_to_return", 0, "click hero_sell_tip_two_to_return.'")]]}, nil, 0)
end


function HeroSellTipTwo:onExit()
	state_machine.remove("hero_sell_tip_two_to_resolve")
	state_machine.remove("hero_sell_tip_two_to_sell")
	state_machine.remove("hero_sell_tip_two_to_return")
end

function HeroSellTipTwo:init(hero)
	self.hero = hero
end
