-----------------------------
--魔法宝箱界面
-----------------------------
Fate = class("FateClass", Window)
--打开界面
local fate_window_open_terminal = {
	_name = "fate_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
 		if funOpenDrawTip(77) == true then
            return
        end  	
		if fwin:find("FateClass") == nil then
			fwin:open(Fate:new():init(),fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local fate_window_close_terminal = {
	_name = "fate_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FateClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(fate_window_open_terminal)
state_machine.add(fate_window_close_terminal)
state_machine.init()

function Fate:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	-- load lua file
	app.load("client.red_alert.cells.fate.fate_cell")
	app.load("client.red_alert.fate.FateChoose")
	app.load("client.red_alert.fate.FateChooseInfor")

	--var
	--祭祀类型
	self.page_index = 1
	--位置表
	self.pos_table = {
		{x = 0,y =0},
		{x = 0,y =0},
		{x = 0,y =0},
		{x = 0,y =0},

	}	
	--面板表
	self.panel_tables = {}
	--钻石text
	self.text_gold = nil
	--金币text
	self.text_silver = nil
	--花费祭祀次数
	self.leave_cost_times = 0
	--免费祭祀次数
	self.leave_free_times = 0

	self.fate_get_gemfate_id = 0

	
    -- Initialize Fate machine.
    local function init_fate_terminal()
 		--滚动
        local fate_turn_page_terminal = {
            _name = "fate_turn_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("fate_turn_page",0,"")
            	local turn_type = params[1]
            	if turn_type == "left" then
            		instance:turnLeft()
            		-- print("=====左滑动")
            	elseif turn_type == "right" then
            		instance:turnRight()
            		-- print("=====右滑动")
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

 		--请求祭祀
        local fate_request_terminal = {
            _name = "fate_request",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cost_type = params._datas.cost_type
            	local gold_number = dms.int(dms["gold_beg"],_ED.user_info.user_grade,gold_beg.gold_number)
            	if cost_type == 2 then
            		gold_number = gold_number * 3
            	end
                local function recruitCallBack(response) 
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.checkPageIndex ~= nil then
                            local times = _ED.show_reward_list_group[1].show_reward_list[1].item_value/gold_number
                            if times > 1 then
                            	if times > math.floor(times) then
                            		times = string.format("%0.2f",times)
                            	end
                            	response.node:goldAwardCrit(times)
                            else
                            	state_machine.excute("reward_obtain_window_open",0,{65})
                            end
                            response.node:checkPageIndex()
                        end
                    end
                end
                if self.leave_cost_times == 0 and self.leave_free_times == 0 then
                	TipDlg.drawTextDailog(red_alert_all_str[96])
                	return
                end
                protocol_command.request_fate.param_list = instance.page_index .. "\r\n" .. cost_type .. "\r\n" ..instance.fate_get_gemfate_id
                NetworkManager:register(protocol_command.request_fate.code, nil, nil, nil, instance, recruitCallBack, false, nil)
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fate_get_gemfate_id_terminal = {
            _name = "fate_get_gemfate_id",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

            	instance.fate_get_gemfate_id = params
            	-- print("========self.fate_get_gemfate_id========================",self.fate_get_gemfate_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 向左滚动
        local fate_turn_page_right_terminal = {
            _name = "fate_turn_page_right",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		instance:turnRight()
        		-- print("=====右滑动")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 先向右滚动
        local fate_turn_page_left_terminal = {
            _name = "fate_turn_page_left",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		instance:turnLeft()
        		-- print("=====左滑动")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fate_turn_page_terminal)
        state_machine.add(fate_request_terminal)
        state_machine.add(fate_get_gemfate_id_terminal)
        state_machine.add(fate_turn_page_right_terminal)
        state_machine.add(fate_turn_page_left_terminal)
        state_machine.init()
    end

    -- call func init fate machine.
    init_fate_terminal()
end

--设置面板大小
function Fate:setPanelScale(panel)
	local index = panel.index
	local scale_number = 1
	if index == 1 then
	elseif index == 2 then
		scale_number = 0.85
	elseif index == 3 then
		scale_number = 0.7
	elseif index == 4 then
		scale_number = 0.85
	end
	panel:setScale(scale_number)
end

--刷新页面
function Fate:checkPageIndex()
	local root = self.roots[1]
	local Panel_spend = ccui.Helper:seekWidgetByName(root,"Panel_spend")	--花费祭祀按钮面板
	local Panel_free = ccui.Helper:seekWidgetByName(root,"Panel_free")		--免费祭祀按钮面板
	local Text_no_chance_altar = ccui.Helper:seekWidgetByName(root,"Text_no_chance_altar")		--祭祀次数已用完
	local Text_altar_free_time = ccui.Helper:seekWidgetByName(root,"Text_altar_free_time")		--免费次数
	local Text_diamond_spend_v = ccui.Helper:seekWidgetByName(root,"Text_diamond_spend_v")		--需求钻石数
	local Image_diamond = ccui.Helper:seekWidgetByName(root,"Image_diamond")					--钻石图标
	local Text_altar_spend = ccui.Helper:seekWidgetByName(root,"Text_altar_spend")				--消耗
	for i,panel in pairs(self.panel_tables) do
		if panel.index == 1 then
			self.page_index = i
			panel:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
		else
			panel:setColor(cc.c3b(color_Type[13][1],color_Type[13][2],color_Type[13][3]))
		end
	end
	local need_gems = 0
	local max_times = 0
	local max_free_times = 0
	local param = ""
	local open_level = 0
	-- 1.金币  2.装备  3.宝石  4.星魂
	for i=1,4 do
		local Text_altar_one_time = ccui.Helper:seekWidgetByName(root,"Text_altar_one_time_"..i)
		local Text_altar_free = ccui.Helper:seekWidgetByName(root,"Text_altar_free_"..i)
		Text_altar_one_time:setVisible(false)
		Text_altar_free:setVisible(false)
	end
	local Text_altar_one_time = ccui.Helper:seekWidgetByName(root,"Text_altar_one_time_"..self.page_index)
	local Text_altar_free = ccui.Helper:seekWidgetByName(root,"Text_altar_free_"..self.page_index)
	if self.page_index == 1 then  	--金币祭祀
		max_free_times = dms.int(dms["base_consume"],60,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		max_times = dms.int(dms["base_consume"],61,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		param = dms.string(dms["major_city_config"],4,major_city_config.param)
		open_level = dms.int(dms["fun_open_condition"],107,fun_open_condition.level)

		Text_altar_one_time:setVisible(true)
		Text_altar_free:setVisible(true)
		Text_no_chance_altar:setString(fate_string[1])
	elseif self.page_index == 2 then 	--装备祭祀
		max_free_times = dms.int(dms["base_consume"],62,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		max_times = dms.int(dms["base_consume"],63,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		param = dms.string(dms["major_city_config"],5,major_city_config.param)
		open_level = dms.int(dms["fun_open_condition"],109,fun_open_condition.level)
		Text_altar_one_time:setVisible(true)
		Text_altar_free:setVisible(true)
		Text_no_chance_altar:setString(fate_string[2])
	elseif self.page_index == 3 then 	--宝石祭祀
		max_free_times = dms.int(dms["base_consume"],64,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		max_times = dms.int(dms["base_consume"],65,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		param = dms.string(dms["major_city_config"],6,major_city_config.param)
		open_level = dms.int(dms["fun_open_condition"],108,fun_open_condition.level)
		Text_altar_one_time:setVisible(true)
		Text_altar_free:setVisible(true)
		Text_no_chance_altar:setString(fate_string[3])
	elseif self.page_index == 4 then 	--星魂祭祀
		max_free_times = dms.int(dms["base_consume"],66,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		max_times = dms.int(dms["base_consume"],67,base_consume.vip_0_value + tonumber(_ED.vip_grade))
		param = dms.string(dms["major_city_config"],7,major_city_config.param)
		open_level = dms.int(dms["fun_open_condition"],110,fun_open_condition.level)
		Text_altar_one_time:setVisible(true)
		Text_altar_free:setVisible(true)
		Text_no_chance_altar:setString(fate_string[4])
	end

	if open_level > tonumber(_ED.user_info.user_grade) then
		Panel_spend:setVisible(false)
		Panel_free:setVisible(false)
		return
	end

	param = zstring.split(param,",")
	local cost_times = tonumber(_ED.fate_times[self.page_index].cost_times)
	local free_times = tonumber(_ED.fate_times[self.page_index].free_times)

	self.leave_cost_times = max_times - cost_times
	self.leave_free_times = max_free_times - free_times

	-- print("================",self.leave_free_times,self.leave_cost_times)
	if self.leave_free_times > 0 then
		Panel_spend:setVisible(false)
		Panel_free:setVisible(true)
		Text_altar_free_time:setString(self.leave_free_times)
	elseif self.leave_cost_times > 0 then
		Panel_spend:setVisible(true)
		Text_diamond_spend_v:setVisible(true)
		Image_diamond:setVisible(true)
		Text_altar_spend:setVisible(true)
		Panel_free:setVisible(false)
	elseif self.leave_free_times == 0 and self.leave_cost_times == 0 then
		Panel_spend:setVisible(true)
		Text_diamond_spend_v:setVisible(false)
		Image_diamond:setVisible(false)
		Text_altar_spend:setVisible(false)
		Panel_free:setVisible(false)
		Text_no_chance_altar:setVisible(true)
	end

	Text_diamond_spend_v:setString(param[cost_times + 1])
end

--向左滑动
function Fate:turnLeft()
	local function MoveCallBack()
		self:checkPageIndex()
	end
	local root = self.roots[1]
	local Panel_spend = ccui.Helper:seekWidgetByName(root,"Panel_spend")
	Panel_spend:setVisible(false)
	local Panel_free = ccui.Helper:seekWidgetByName(root,"Panel_free")
	Panel_free:setVisible(false)
	local Text_no_chance_altar = ccui.Helper:seekWidgetByName(root,"Text_no_chance_altar")
	Text_no_chance_altar:setVisible(false)

	local moveIndex = 0
	for i,panel in pairs(self.panel_tables) do
		moveIndex = panel.index + 1
		if moveIndex == 5 then
			moveIndex = 1
		end

		if i ~= #self.panel_tables then
			move = cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y))		
		else
			move = cc.Sequence:create(cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y)),cc.CallFunc:create(MoveCallBack))
		end
		panel:runAction(move)
		panel.index = moveIndex
		
		panel:setLocalZOrder(40 - moveIndex*10)
		self:setPanelScale(panel)
	end
	self.panel_black:setLocalZOrder(25)
end

--向右滑动
function Fate:turnRight()
	local function MoveCallBack()
		self:checkPageIndex()
	end
	local root = self.roots[1]
	local Panel_spend = ccui.Helper:seekWidgetByName(root,"Panel_spend")
	Panel_spend:setVisible(false)
	local Panel_free = ccui.Helper:seekWidgetByName(root,"Panel_free")
	Panel_free:setVisible(false)
	local Text_no_chance_altar = ccui.Helper:seekWidgetByName(root,"Text_no_chance_altar")
	Text_no_chance_altar:setVisible(false)

	local moveIndex = 0
	for i,panel in pairs(self.panel_tables) do
		moveIndex = panel.index - 1
		if moveIndex == 0 then
			moveIndex = 4
		end

		if i ~= #self.panel_tables then
			move = cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y))		
		else
			move = cc.Sequence:create(cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y)),cc.CallFunc:create(MoveCallBack))
		end
		panel:runAction(move)
		panel.index = moveIndex
	
		panel:setLocalZOrder(40 - moveIndex*10)
		self:setPanelScale(panel)
	end
	
	self.panel_black:setLocalZOrder(25)
end

--更新钻石、金币
function Fate:onUpdateDraw()
	local root = self.roots[1]
	--钻石数
	local Text_diamonds = ccui.Helper:seekWidgetByName(root,"Text_diamonds")
	Text_diamonds:setString(_ED.user_info.user_gold)
	self.text_gold = Text_diamonds
	--金币数
	local Text_coins = ccui.Helper:seekWidgetByName(root,"Text_coins")
	Text_coins:setString(_ED.user_info.user_silver)
	self.text_silver = Text_coins
	self:checkPageIndex()
end

--刷新钻石、金币
function Fate:onUpdate()
	if self.text_gold ~= nil and self.text_silver ~= nil then
		--钻石
		if tonumber(_ED.user_info.user_gold) >= 100000 then
	        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
	        self.text_gold:setString(string.format(red_alert_all_str[122],info))
	    else
	        self.text_gold:setString(_ED.user_info.user_gold)
	    end
		--金币
		if tonumber(_ED.user_info.user_silver) >= 100000 then
	        local info = math.floor(tonumber(_ED.user_info.user_silver)/10000)
	        self.text_silver:setString(string.format(red_alert_all_str[122],info))
	    else
	        self.text_silver:setString(_ED.user_info.user_silver)
	    end
	end	
end

-- 播放暴击动画
function Fate:goldAwardCrit(index)
	local root = self.roots[1]
	local action = self.actions[1] 
	-- 暴击倍数
	local BitmapFontLabel_crit = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_crit")
	BitmapFontLabel_crit:setString(string.format(red_alert_all_str[212],index))
	action:play("fate_crit", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "fate_crit_get" then
            state_machine.excute("reward_obtain_window_open",0,{65})
        end
    end)
end

function Fate:init()
	self:onInit()
    return self
end

--初始化界面
function Fate:onInit()
    local csbItem = csb.createNode(config_csb.fate.fate)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.fate.fate)
    table.insert(self.actions, action)
    csbItem:runAction(action)

  	self:initUI()
    self:onUpdateDraw()
end

--初始化UI
function Fate:initUI()
	local root = self.roots[1]
  	local Panel_altar_hide_1 = ccui.Helper:seekWidgetByName(root, "Panel_altar_hide_1")
  	local Panel_altar_hide_2 = ccui.Helper:seekWidgetByName(root, "Panel_altar_hide_2")
  	local Panel_altar_hide_3 = ccui.Helper:seekWidgetByName(root, "Panel_altar_hide_3")
  	local Panel_altar_hide_4 = ccui.Helper:seekWidgetByName(root, "Panel_altar_hide_4")
  	local Panel_black = ccui.Helper:seekWidgetByName(root, "Panel_black")
  	Panel_black:setVisible(true)
  	self.panel_black = Panel_black
  	--阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
  	for i = 1,4 do
  		local Panel_altar_hide = ccui.Helper:seekWidgetByName(root, "Panel_altar_hide_"..i)
  		Panel_altar_hide:removeAllChildren(true)
	  	self.panel_tables[i] = Panel_altar_hide
	  	self.pos_table[i].x,self.pos_table[i].y = self.panel_tables[i]:getPosition()
	  	self.panel_tables[i].index = i 		

	  	local cell = state_machine.excute("fate_create_cell",0,{i})
	  	cell:setAnchorPoint(0.5,0.5)
	  	cell:setPosition(cc.p(Panel_altar_hide:getContentSize().width/2,Panel_altar_hide:getContentSize().height/2))
		self.panel_tables[i]:addChild(cell)
		self:setPanelScale(Panel_altar_hide)	  	
  	end
  	
  	local width = math.abs(tonumber(self.pos_table[1].x) - tonumber(self.pos_table[2].x))
  	-- print("====width=======",width)
    -- 返回主页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "fate_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    -- 免费祭祀
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_altar_free"), nil, 
    {
        terminal_name = "fate_request", 
        terminal_state = 0,
        cost_type = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)
 
    -- 祭祀
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_altar_one_time"), nil, 
    {
        terminal_name = "fate_request", 
        terminal_state = 0,
        cost_type = 2,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0) 

    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_add_gem"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
    }, nil, 0)    

    -- 打开充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_gem"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)
    
    --滑动按钮
    local function PanelTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		
        if ccui.TouchEventType.began == evenType then

        elseif ccui.TouchEventType.moved == evenType then
        	-- print("===============",__mpoint.x - __spoint.x,width/2)
			if __mpoint.x - __spoint.x > width/3 then
				state_machine.excute("fate_turn_page",0,{"right"})
			end

			if __mpoint.x - __spoint.x < -width/3  then
				state_machine.excute("fate_turn_page",0,{"left"})
			end
        elseif ccui.TouchEventType.canceled == evenType then
        	state_machine.unlock("fate_turn_page",0,"")
        elseif ccui.TouchEventType.ended == evenType then
        --注掉，滑动不松开就会一直划。 不注释，松开就不划了
        	state_machine.unlock("fate_turn_page",0,"")
        end
    end
    -- 滑动监听
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_main"), PanelTouchEvent, 
    {
        terminal_name = "", 
        terminal_state = 0,
    },
    nil,0)

    -- 向左滑动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_altar_hide_4_0"), nil, 
    {
        terminal_name = "fate_turn_page_left", 
        terminal_state = 0, 
    }, nil, 0)

    -- 向右滑动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_altar_hide_2_0"), nil, 
    {
        terminal_name = "fate_turn_page_right", 
        terminal_state = 0, 
    }, nil, 0)

end

function Fate:onEnterTransitionFinish()
    
end

--移除状态机
function Fate:onExit()
	state_machine.remove("fate_turn_page")
	state_machine.remove("fate_request")
    state_machine.remove("fate_get_gemfate_id")
    state_machine.remove("fate_turn_page_left")
    state_machine.remove("fate_turn_page_right")
end

