-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将培养界面
-------------------------------------------------------------------------------------------------------
TrainTime = class("TrainTimeClass", Window)

function TrainTime:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.cells.ship.ship_body_cell")
    local function init_train_time_page_terminal()
		--关闭
		local train_time_page_close_terminal = {
            _name = "train_time_page_close",
            _init = function (terminal)
				affirm = {}
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
			affirm = {}
        }
		state_machine.add(train_time_page_close_terminal)
        state_machine.init()
    end
    init_train_time_page_terminal()
end

function TrainTime:onUpdateDraw()

end

function TrainTime:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_xiliancishu.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
	local action = csb.createTimeline("packs/HeroStorage/generals_xiliancishu.csb")
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    root:runAction(action)

    self:onUpdateDraw()

	-- local Image_yuanbao = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_yuanbao"), nil, {terminal_name = "train_time_page_close", terminal_state = 3}, nil, 0)
end

function TrainTime:onExit()
	state_machine.remove("train_time_page_close")
end

function TrainTime:init()
end