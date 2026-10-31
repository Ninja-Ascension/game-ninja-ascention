-----------------------------
--战力排行怪物介绍
-----------------------------
SmMonsterIntroduction = class("SmMonsterIntroductionClass", Window)

local sm_monster_introduction_window_open_terminal = {
    _name = "sm_monster_introduction_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmMonsterIntroduction:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_monster_introduction_window_open_terminal)
state_machine.init()

function SmMonsterIntroduction:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_list = {}

    local function init_sm_monster_introduction_terminal()
		--显示界面
		local sm_monster_introduction_show_terminal = {
            _name = "sm_monster_introduction_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_monster_introduction_hide_terminal = {
            _name = "sm_monster_introduction_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		state_machine.add(sm_monster_introduction_show_terminal)	
		state_machine.add(sm_monster_introduction_hide_terminal)

        state_machine.init()
    end
    init_sm_monster_introduction_terminal()
end

function SmMonsterIntroduction:onHide()
    self:setVisible(false)
end

function SmMonsterIntroduction:onShow()
    self:setVisible(true)
end


function SmMonsterIntroduction:onUpdateDraw()
    local root = self.roots[1]
    
    --贴形象
    local Panel_digimon_card = ccui.Helper:seekWidgetByName(root, "Panel_digimon_card")
    

    --贴武将描述
    local Text_digimon_info = ccui.Helper:seekWidgetByName(root, "Text_digimon_info")

    --贴武将大招描述
    local Text_digimon_skill = ccui.Helper:seekWidgetByName(root, "Text_digimon_skill") 


end

function SmMonsterIntroduction:onUpdate(dt)
    
end

function SmMonsterIntroduction:onEnterTransitionFinish()

end

function SmMonsterIntroduction:onInit( )
    local csbItem = csb.createNode("activity/wonderful/sm_fighting_up_tab_4.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self:onUpdateDraw()
end

function SmMonsterIntroduction:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmMonsterIntroduction:onExit()
    state_machine.remove("sm_monster_introduction_show")    
    state_machine.remove("sm_monster_introduction_hide")
end
