UnionFightingOpen = class("UnionFightingOpenClass", Window)

local union_fighting_open_open_terminal = {
	_name = "union_fighting_open_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("UnionFightingOpenClass") == nil then
			fwin:open(UnionFightingOpen:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_open_close_terminal = {
	_name = "union_fighting_open_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingOpenClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_open_open_terminal)
state_machine.add(union_fighting_open_close_terminal)
state_machine.init()

function UnionFightingOpen:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    local function init_union_fighting_open_terminal()
        local union_fighting_open_show_terminal = {
            _name = "union_fighting_open_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then
                	instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        local union_fighting_open_hide_terminal = {
            _name = "union_fighting_open_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                	instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(union_fighting_open_show_terminal)  
        state_machine.add(union_fighting_open_hide_terminal)
        state_machine.init()
    end

    init_union_fighting_open_terminal()
end

function UnionFightingOpen:onInit()
	local csbNode = csb.createNode(config_csb.big_map.map_battle_legion_effice)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local Panel_legion_effice = ccui.Helper:seekWidgetByName(root, "Panel_legion_effice")
    Panel_legion_effice:removeAllChildren(true)
    local baseName = "effect/effect_bpbeida"
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    -- skeletonNode:registerSpineEventHandler(function (event)
    --     event.skeletonAnimation:removeFromParent(true)
    -- end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode:setAnimation(0, "animation", true)
    Panel_legion_effice:addChild(skeletonNode)
end

function UnionFightingOpen:onEnterTransitionFinish()
end

function UnionFightingOpen:init()
    self:onInit()
	return self
end

function UnionFightingOpen:onExit()

end
