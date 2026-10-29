-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将天命离开提示界面
-------------------------------------------------------------------------------------------------------
HeroSkillStrenLevelTip = class("HeroSkillStrenLevelTipClass", Window)

function HeroSkillStrenLevelTip:ctor()
    self.super:ctor()
	self.roots = {}
	self.name = nil
	self.but = nil
	self.id = nil
	self.num = nil
    local function init_hero_skill_stren_success_terminal()
		--关闭
		local hero_skill_stren_tip_close_terminal = {
            _name = "hero_skill_stren_tip_close",
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
		
		--离开
		local hero_skill_stren_tip_level_terminal = {
            _name = "hero_skill_stren_tip_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:find("HeroSkillStrenPageClass").status = false
				if self.num == nil then
					state_machine.excute("hero_develop_page_manager", 0, 
						{
							_datas = {
								terminal_name = "hero_develop_page_manager", 	
								next_terminal_name = self.name, 
								current_button_name = self.but,
								but_image = "", 		
								heroInstance = self.id,
								terminal_state = 0,
								openWinId = 4,
								isPressedActionEnabled = false
							}
						}
					)
				else
					state_machine.excute("hero_develop_page_close", 0, nil)
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.init()
		state_machine.add(hero_skill_stren_tip_level_terminal)	
		state_machine.add(hero_skill_stren_tip_close_terminal)	
    end
    init_hero_skill_stren_success_terminal()
end



function HeroSkillStrenLevelTip:onUpdateDraw()
	local root = self.roots[1]

	
end

function HeroSkillStrenLevelTip:onEnterTransitionFinish()
	local csbHeroSkillStrenLevelTip = csb.createNode("packs/HeroStorage/generals_tianming_prom.csb")
    local root = csbHeroSkillStrenLevelTip:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
	self:onUpdateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_32"), nil, {func_string = [[state_machine.excute("hero_skill_stren_tip_level", 0, "click hero_skill_stren_tip_level.'")]],isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_34"), nil, {func_string = [[state_machine.excute("hero_skill_stren_tip_close", 0, "click hero_skill_stren_tip_close.'")]],isPressedActionEnabled = true}, nil, 2)
end

function HeroSkillStrenLevelTip:onExit()
	state_machine.remove("hero_skill_stren_tip_level")
	state_machine.remove("hero_skill_stren_tip_close")

end

function HeroSkillStrenLevelTip:init(name,but,id,num)
	self.name = name
	self.but = but
	self.id = id
	self.num = num
end
