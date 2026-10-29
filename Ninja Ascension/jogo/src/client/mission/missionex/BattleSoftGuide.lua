-- ----------------------------------------------------------------------------------------------------
-- 战斗中的非强制指引
-- -----------------------------------------------------------------------------------------------------
BattleSoftGuide = class("BattleSoftGuideClass", Window)

local battle_soft_guide_window_open_terminal = {
    _name = "battle_soft_guide_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	state_machine.excute("battle_soft_guide_window_close", 0, 0)
        local _battleSoftGuide = BattleSoftGuide:new():init(params)
        fwin:open(_battleSoftGuide, fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_soft_guide_window_close_terminal = {
    _name = "battle_soft_guide_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleSoftGuideClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_soft_guide_window_open_terminal)
state_machine.add(battle_soft_guide_window_close_terminal)
state_machine.init()

function BattleSoftGuide:ctor()
    self.super:ctor()
	self.roots = {}
end

function BattleSoftGuide:init(params)
    self._rootWindows = params
    return self
end

function BattleSoftGuide:onEnterTransitionFinish()
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local panel = ccui.Layout:create()
		panel:setContentSize(cc.size(176, 136))
		self:addChild(panel)
		panel:setPosition(cc.p(69,120))
		local panel_image = ccui.Layout:create()
		panel_image:setAnchorPoint(cc.p(0.5,0.5))
		panel_image:setContentSize(cc.size(297, 180))
		panel:addChild(panel_image)
		panel_image:setPosition(cc.p(-5.6,89.95))
		panel_image:setBackGroundImage("images/ui/decorative/xiaozhushou_battle.png")
		local relationName = ccui.TextField:create()
		relationName:setString("请点击释放技能")
		relationName:setFontName("fonts/FZYiHei-M20S.ttf")-->设置字体名字
		relationName:setFontSize(18)-->设置字体大小
		relationName:setAnchorPoint(CCPoint(0.5, 0.5))-->设置锚点
		panel:addChild(relationName)
		relationName:setPosition(cc.p(73, 70))
		relationName:setColor(cc.c3b(color_Type[9][1],color_Type[9][2],color_Type[9][3]))
	else
		local csbBattleSoftGuide = csb.createNode(config_csb.Chat.battle_teaching_chat)
		self:addChild(csbBattleSoftGuide)
		local root = csbBattleSoftGuide:getChildByName("root")
		table.insert(self.roots, root)

		local action = csb.createTimeline(config_csb.Chat.battle_teaching_chat)
		self.action = action
		csbBattleSoftGuide:runAction(action)
		action:gotoFrameAndPlay(0, action:getDuration(), true)
	end
end

function BattleSoftGuide:onExit()

end