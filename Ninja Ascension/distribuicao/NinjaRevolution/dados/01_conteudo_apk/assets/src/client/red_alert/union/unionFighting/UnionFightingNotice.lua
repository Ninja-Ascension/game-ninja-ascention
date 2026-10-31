UnionFightingNotice = class("UnionFightingNoticeClass", Window)

local union_fighting_notice_open_terminal = {
	_name = "union_fighting_notice_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("LoginClass") ~= nil 
			or fwin:find("BattleMapClass") ~= nil then
			return
		end
		fwin:open(UnionFightingNotice:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_notice_close_terminal = {
	_name = "union_fighting_notice_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingNoticeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_notice_open_terminal)
state_machine.add(union_fighting_notice_close_terminal)
state_machine.init()

function UnionFightingNotice:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function UnionFightingNotice:onInit(params)
	local csbNode = csb.createNode(config_csb.big_map.map_legion_battle_text)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline(config_csb.big_map.map_legion_battle_text)
    table.insert(self.actions, action)

    csbNode:runAction(action)

    action:play("map_legion_battle_t", false)

    if tonumber(params[1]) == 6 then
    	ccui.Helper:seekWidgetByName(root, "Text_df"):setString(params[2])
    else
    	ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_time"):setString(params[2])
    end

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "map_legion_battle_t _over" then
		    state_machine.excute("union_fighting_notice_close", 0, nil)
        end
    end)
end

function UnionFightingNotice:onEnterTransitionFinish()
end

function UnionFightingNotice:init(params)
    self:onInit(params)
	return self
end

function UnionFightingNotice:onExit()

end
