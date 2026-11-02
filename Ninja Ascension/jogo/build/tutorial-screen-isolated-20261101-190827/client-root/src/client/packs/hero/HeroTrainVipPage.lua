-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将培养界面
-------------------------------------------------------------------------------------------------------
HeroTrainVipPage = class("HeroTrainVipPageClass", Window)

function HeroTrainVipPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

    local function init_hero_train_vip_page_terminal()
		--选择被培养次数
		local hero_train_vip_page_chooes_times_terminal = {
            _name = "hero_train_vip_page_chooes_times",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local chooseTimes = terminal._state
				local userVip = zstring.tonumber(_ED.vip_grade)
				local canBeChoose = 0
				if userVip < 4 then
					canBeChoose = 0
				elseif userVip < 5 then
					canBeChoose = 1
				else 
					canBeChoose = 2
				end
				if chooseTimes > canBeChoose then
					if chooseTimes == 2 then
						TipDlg.drawTextDailog(_string_piece_info[129])
					elseif chooseTimes == 1 then
						TipDlg.drawTextDailog(_string_piece_info[130])
					end
				else
					state_machine.excute("hero_train_page_chooes_times", 2,{_datas = {vipTimes = chooseTimes}})
					state_machine.excute("hero_train_vip_page_close")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--关闭
		local hero_train_vip_page_close_terminal = {
            _name = "hero_train_vip_page_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.actions[1]:play("window_close", false)
				self.actions[1]:setFrameEventCallFunc(
				function (frame)
					if nil == frame then
						return
					end
					local str = frame:getEvent()
					if str == "exit" then
						fwin:close(instance)
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_train_vip_page_chooes_times_terminal)
		state_machine.add(hero_train_vip_page_close_terminal)
        state_machine.init()
    end
    init_hero_train_vip_page_terminal()
end

function HeroTrainVipPage:onUpdateDraw()
	local userVip = zstring.tonumber(_ED.vip_grade)
	local canBeChoose = 0
	local Text_2_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_2_2")
	local Text_2_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_2_1")
	if userVip > 4 then
		canBeChoose = 3
		Text_2_2:setString(_string_piece_info[145])
		Text_2_1:setString(_string_piece_info[145])
		Text_2_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
		Text_2_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	elseif userVip > 3 then
		canBeChoose = 2
		Text_2_1:setString(_string_piece_info[145])
		Text_2_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	else 
		canBeChoose = 1
	end
end

function HeroTrainVipPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_xiliancishu.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
	
	local action = csb.createTimeline("packs/HeroStorage/generals_xiliancishu.csb")
    table.insert(self.actions, action)
	action:play("window_open", false)
    root:runAction(action)
	
	self:onUpdateDraw()
	local Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_4"), nil, 
	{
		terminal_name = "hero_train_vip_page_close", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, 
	{
		terminal_name = "hero_train_vip_page_chooes_times", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"), nil, 
	{
		terminal_name = "hero_train_vip_page_chooes_times", 
		terminal_state = 1,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_3"), nil, 
	{
		terminal_name = "hero_train_vip_page_chooes_times", 
		terminal_state = 2,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
end

function HeroTrainVipPage:onExit()
	state_machine.remove("hero_train_vip_page_chooes_times")
	state_machine.remove("hero_train_vip_page_close")
end

function HeroTrainVipPage:init(shipId)
	self.shipId = shipId
	self.ship = fundShipWidthId(self.shipId)
end