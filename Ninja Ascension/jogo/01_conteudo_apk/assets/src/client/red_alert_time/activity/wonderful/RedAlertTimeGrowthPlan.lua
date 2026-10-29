-----------------------------
--成长计划(活动类型9)
-----------------------------
RedAlertTimeGrowthPlan = class("RedAlertTimeGrowthPlanClass", Window)

local red_alert_time_growth_plan_window_open_terminal = {
    _name = "red_alert_time_growth_plan_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeGrowthPlanClass") then
            local panel = RedAlertTimeGrowthPlan:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_growth_plan_window_open_terminal)
state_machine.init()

function RedAlertTimeGrowthPlan:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._Image_investment_plan_arrow_down = nil
    self._Image_investment_plan_arrow_up = nil
    -- load lua file
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
    -- Initialize red_alert_time_growth_plan state machine.
    local function init_red_alert_time_growth_plan_terminal()
    
        --购买
        local red_alert_time_growth_plan_buy_terminal = {
            _name = "red_alert_time_growth_plan_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local need_infos = _ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_complete_count
                local need_gems = tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_other_info)
                need_infos = zstring.split(need_infos,"/")
                need_infos = tonumber(need_infos[2])
                -- print("======",_ED.vip_grade,need_infos)
                if tonumber(_ED.vip_grade) >= need_infos then
                    if need_gems > tonumber(_ED.user_info.user_gold) then
                        TipDlg.drawTextDailog(red_alert_all_str[79])
                        return
                    end
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:updateBuyButton() 
                                response.node:onUpdateDraw()
                                TipDlg.drawTextDailog(activity_str_tip[60])
                            end
                        end
                    end
                    protocol_command.grow_up_activity_buy.param_list = "" .. self.activity_type
                    NetworkManager:register(protocol_command.grow_up_activity_buy.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    TipDlg.drawTextDailog(red_alert_all_str[154])
                    state_machine.excute("recharge_dialog_window_open",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local red_alert_time_growth_plan_update_draw_terminal = {
			_name = "red_alert_time_growth_plan_update_draw",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)  
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
    				instance:onUpdateDraw()
                end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

        state_machine.add(red_alert_time_growth_plan_buy_terminal)
        state_machine.add(red_alert_time_growth_plan_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init up_level state machine.
    init_red_alert_time_growth_plan_terminal()
end

function RedAlertTimeGrowthPlan:onUpdateDraw()
    local root = self.roots[1]
    -- debug.print_r(_ED.activity_info["9"])
    -- local Text_red_alert_time_growth_plan_gem = ccui.Helper:seekWidgetByName(root, "Text_red_alert_time_growth_plan_gem") 
    -- Text_red_alert_time_growth_plan_gem:setString("1")
    -- local Text_red_alert_time_growth_plan_get_gem = ccui.Helper:seekWidgetByName(root, "Text_red_alert_time_growth_plan_get_gem") 
    -- Text_red_alert_time_growth_plan_get_gem:setString("4000")
    -- local Text_red_alert_time_growth_plan_vip = ccui.Helper:seekWidgetByName(root, "Text_red_alert_time_growth_plan_vip") 
    -- Text_red_alert_time_growth_plan_vip:setString("VIP2")
    local ListView_investment_plan_charge = ccui.Helper:seekWidgetByName(root, "ListView_investment_plan_charge") 
    self._list_view = ListView_investment_plan_charge
    ListView_investment_plan_charge:removeAllItems()
	local index = 1
	for i=1, #_ED.activity_info[""..self.activity_type].activity_data[2] do
	-- for i,v in pairs(_ED.activity_info["9"].activity_data[2]) do
	--	print("i======"..i)
		-- local rewardinfo = zstring.split(v.achieve_reward, ",")
		-- v.achieve_reward = "1,2,"..rewardinfo[3]
		local cell = state_machine.excute("red_alert_time_act_share_create_cell",0,{_ED.activity_info[""..self.activity_type].activity_data[2][i],index,self.activity_type,2})
        ListView_investment_plan_charge:addChild(cell)
		index = index + 1 
	end
	ListView_investment_plan_charge:requestRefreshView()
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	
	local datas = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_complete_count, "/")
    local Button_investment_plan_charge = ccui.Helper:seekWidgetByName(root,"Button_investment_plan_charge")
    local Button_investment_plan_buy = ccui.Helper:seekWidgetByName(root,"Button_investment_plan_buy")
	if tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_state) == 2 then
		Button_investment_plan_charge:setVisible(false)
		Button_investment_plan_buy:setVisible(false)
	else
		if tonumber(datas[2]) > tonumber(_ED.vip_grade) then
			Button_investment_plan_charge:setVisible(true)
            Button_investment_plan_buy:setVisible(false)
		else
			Button_investment_plan_charge:setVisible(false)
            Button_investment_plan_buy:setVisible(true)
		end
	end

    local Text_act_investment_plan_lv_2 = ccui.Helper:seekWidgetByName(root,"Text_act_investment_plan_lv_2")
    Text_act_investment_plan_lv_2:setString(string.format(red_alert_all_str[117],_ED.user_info.user_grade))
    -- ccui.Helper:seekWidgetByName(root, "Image_growth_title_1"):setVisible(true)
    -- ccui.Helper:seekWidgetByName(root, "Image_growth_title_2"):setVisible(false)
    -- ccui.Helper:seekWidgetByName(root, "Image_growth_title_3"):setVisible(false)

    -- for i = 1,10 do
        -- local Panel_recive = ccui.Helper:seekWidgetByName(root,"Panel_recive_"..i) -- 可领取状态
        -- Panel_recive:setVisible(false)
        -- local Panel_get = ccui.Helper:seekWidgetByName(root,"Panel_get_"..i)       -- 已领取状态
        -- Panel_get:setVisible(false)
        -- local achieve_state = tonumber(_ED.activity_info["9"].activity_data[2][i].achieve_state)
        -- if achieve_state == 1 then
            -- Panel_recive:setVisible(true)
        -- elseif achieve_state == 2 then
            -- Panel_get:setVisible(true)
        -- end
        -- -- 需要达到等级
        -- local Text_day_number = ccui.Helper:seekWidgetByName(root,"Text_day_number_"..i)       
        -- local achieve_mould_dec = _ED.activity_info["9"].activity_data[2][i].achieve_mould_dec
        -- Text_day_number:setString(achieve_mould_dec)
        -- -- 获得数量
        -- local Text_props_n = ccui.Helper:seekWidgetByName(root,"Text_props_n_"..i)     
        -- local achieve_reward = _ED.activity_info["9"].activity_data[2][i].achieve_reward
        -- local achieve_reward = zstring.split(achieve_reward,",")  
        -- Text_props_n:setString(string.format(red_alert_all_str[242],achieve_reward[3]))
    -- end
end

function RedAlertTimeGrowthPlan:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_investment_plan_arrow_down:setVisible(true)
        else
            self._Image_investment_plan_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_investment_plan_arrow_up:setVisible(true)
        else
            self._Image_investment_plan_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

-- 按钮状态
function RedAlertTimeGrowthPlan:updateBuyButton()
    local root = self.roots[1]
    local Button_investment_plan_buy = ccui.Helper:seekWidgetByName(root,"Button_investment_plan_buy")      -- 购买按钮
    -- local Image_geted = ccui.Helper:seekWidgetByName(root,"Image_geted")    -- 已购买
    -- local Text_buy = ccui.Helper:seekWidgetByName(root,"Text_buy") 
    -- local Panel_kgm = ccui.Helper:seekWidgetByName(root,"Panel_kgm")        -- 可购买光效
    -- Panel_kgm:setVisible(false)
    -- if tonumber(_ED.activity_info["9"].activity_data[1][1].achieve_state) >= 1 then
        -- Button_buy:setVisible(false)
        -- Image_geted:setVisible(true)
    -- else
        -- if tonumber(_ED.vip_grade) >= 2 then
            -- Panel_kgm:setVisible(true)
            -- Text_buy:setString(red_alert_all_str[225])
        -- end
        -- Button_buy:setVisible(true)
        -- Image_geted:setVisible(false)
    -- end
    -- local ListView_red_alert_time_growth_plan = ccui.Helper:seekWidgetByName(root, "ListView_act_share") 
    -- for i, cell in pairs(ListView_red_alert_time_growth_plan:getItems()) do
        -- cell:updateDrawButtons()
    -- end
end

function RedAlertTimeGrowthPlan:onEnterTransitionFinish()

end

function RedAlertTimeGrowthPlan:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_investment_plan_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_investment_plan_buy"), nil, 
    {
        terminal_name = "red_alert_time_growth_plan_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--充值
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_investment_plan_charge"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 领取
    -- for i=1,10 do
        -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_sday_"..i), nil, 
        -- {
            -- terminal_name = "red_alert_time_growth_plan_get_reward", 
            -- terminal_state = 0, 
            -- touch_scale = true,
            -- touch_scale_xy = 0.95, 
            -- index = i, 
        -- }, nil, 1)
    -- end
    self._Image_investment_plan_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_investment_plan_arrow_down")
    self._Image_investment_plan_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_investment_plan_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_investment_plan_arrow_down:stopAllActions()
    self._Image_investment_plan_arrow_up:stopAllActions()
    playActions(self._Image_investment_plan_arrow_down)
    playActions(self._Image_investment_plan_arrow_up)
    self._Image_investment_plan_arrow_down:setVisible(false)
    self._Image_investment_plan_arrow_up:setVisible(false)

    self:onUpdateDraw()
    self:updateBuyButton()
end

function RedAlertTimeGrowthPlan:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeGrowthPlan:onExit()
    state_machine.remove("red_alert_time_growth_plan_buy")
    state_machine.remove("red_alert_time_growth_plan_get_reward")
    
end
