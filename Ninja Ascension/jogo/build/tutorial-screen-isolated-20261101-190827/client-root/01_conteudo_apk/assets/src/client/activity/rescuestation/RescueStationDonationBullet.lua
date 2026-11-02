--[[ ----------------------------------------------------------------------------
-- 道具捐赠弹窗
--]] ----------------------------------------------------------------------------
RescueStationDonationBullet = class("RescueStationDonationBulletClass", Window)

-- 打开窗口
local rescue_station_donation_bullet_window_open_terminal = {
	_name = "rescue_station_donation_bullet_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationDonationBulletClass") then
			fwin:open(RescueStationDonationBullet:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_donation_bullet_window_close_terminal = {
	_name = "rescue_station_donation_bullet_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationDonationBulletClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_donation_bullet_window_open_terminal)
state_machine.add(rescue_station_donation_bullet_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationDonationBullet:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._select_num = 1
	self._have_num = 0
    app.load("client.cells.utils.resources_icon_cell")
	app.load("client.activity.rescuestation.RescueStationDonation")
	app.load("client.activity.rescuestation.RescueStation")
	local function init_rescue_station_donation_bullet_terminal()
		-- 打开角色创建窗口
		local rescue_station_donation_bullet_open_terminal = {
			_name = "rescue_station_donation_bullet_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local rescue_station_donation_bullet_close_terminal = {
			_name = "rescue_station_donation_bullet_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local rescue_station_donation_bullet_show_terminal = {
			_name = "rescue_station_donation_bullet_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local rescue_station_donation_bullet_hide_terminal = {
			_name = "rescue_station_donation_bullet_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		 local rescue_station_donation_bullet_set_min_terminal = {
            _name = "rescue_station_donation_bullet_set_min",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._select_num > 1 then
                	instance:setSelectNum(instance._select_num -1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rescue_station_donation_bullet_set_max_terminal = {
            _name = "rescue_station_donation_bullet_set_max",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if  instance._select_num < instance._max_select_num then
                	instance:setSelectNum(instance._select_num +1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local rescue_station_donation_bullet_update_terminal = {
            _name = "rescue_station_donation_bullet_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Slider_number_xz = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_bullet_number")
                local select_num = math.ceil(tonumber(Slider_number_xz:getPercent()) * instance._max_select_num / 100)
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rescue_station_donation_bullet_is_use_terminal = {
            _name = "rescue_station_donation_bullet_is_use",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(tipStringInfo_rescue_station[7])
                    end
                end
                protocol_command.activity_pockmon_rescue_donation_item.param_list = instance._idex.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.activity_pockmon_rescue_donation_item.code, nil, nil, nil, instance, callBack, false, nil)
                
                local function rankcallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	state_machine.excute("rescue_station_uptate_info",0, "")
	                    state_machine.excute("rescue_station_donation_bullet_tool_update",0,nil)
				        state_machine.excute("rescue_station_donation_bullet_window_close",0,nil)
                    end
                end
                protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (1).."\r\n"..10
                NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, rankcallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(rescue_station_donation_bullet_open_terminal)
		state_machine.add(rescue_station_donation_bullet_close_terminal)
		state_machine.add(rescue_station_donation_bullet_show_terminal)
		state_machine.add(rescue_station_donation_bullet_hide_terminal)
    	state_machine.add(rescue_station_donation_bullet_set_min_terminal)
    	state_machine.add(rescue_station_donation_bullet_set_max_terminal)
    	state_machine.add(rescue_station_donation_bullet_update_terminal)
    	state_machine.add(rescue_station_donation_bullet_is_use_terminal)
		state_machine.init()
	end
	init_rescue_station_donation_bullet_terminal()
end

-- 对象初始化
function RescueStationDonationBullet:init(params)
	self._info = params[1]._info
    self._info = zstring.split(self._info, ",") 
	self._idex = params[1]._idex
	self._score = params[1]._score
	self._have_num = tonumber(params[1]._have_num)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationDonationBullet:setSelectNum(select_num)
	local root = self.roots[1]
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end
    local percent = math.floor(self._select_num / self._max_select_num*100)
	self:updateSliderInfo(percent)

	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_shuzi1")
	Text_1:setVisible(true)
	--捐赠所需数量和拥有量
	local rescue_datas =dms.string(dms["role_rescue_exchange"],tonumber(self._idex),2)
	local rescue_prop_item = zstring.split(rescue_datas,",")
	local rescue_prop_num = tonumber(rescue_prop_item[3])
	local need_total_num = tonumber(rescue_prop_num * tonumber(self._select_num))
	if nil ~= self._have_num then 
		if self._have_num >= need_total_num then
		Text_1:setColor(cc.c3b(40,197,15))
		else
			Text_1:setColor(cc.c3b(127,127,127))
		end
		Text_1:setString(self._have_num.."/"..need_total_num)
	end
	
end

function RescueStationDonationBullet:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_bullet_number")
    
    self._current_silder = percent

    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1     
    end
    Slider_number_xz:setPercent(self._current_silder)
   
    local Text_bullet_donation_n = ccui.Helper:seekWidgetByName(root, "Text_bullet_donation_n")
    Text_bullet_donation_n:setString(self._select_num)

    local Text_bullet_obtain_n = ccui.Helper:seekWidgetByName(root, "Text_bullet_obtain_n")
    Text_bullet_obtain_n:setString(self._select_num*self._score)

    
    -- local Text_bullet_obtain = ccui.Helper:seekWidgetByName(root, "Text_bullet_obtain")
    -- local posX_bo =  Text_bullet_obtain:getPositionX()
    -- local width_bo = Text_bullet_obtain_n:getContentSize().width
    -- Text_bullet_obtain_n:setPositionX(posX_bo+width_bo)


    local posX = Text_bullet_obtain_n:getPositionX()
    local Text_bullet_integral = ccui.Helper:seekWidgetByName(root, "Text_bullet_integral")
    local width_txt = Text_bullet_obtain_n:getContentSize().width
	Text_bullet_integral:setPositionX(width_txt+posX+40)

end


function RescueStationDonationBullet:onUpdateDraw()
	local root = self.roots[1]
     
	-- 捐赠数量
	self.Text_bullet_donation_n = ccui.Helper:seekWidgetByName(root, "Text_bullet_donation_n")

	-- 捐赠获得积分
	self.Text_bullet_obtain_n = ccui.Helper:seekWidgetByName(root, "Text_bullet_obtain_n")

	-- 道具图标
	self.Panel_bullet_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_bullet_prop_box")
    self.Panel_bullet_prop_box:removeAllChildren(true)
    local rewards = self._info  -- 奖励
    local rewardType = zstring.tonumber(rewards[1])
    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
            table.shipStar = tonumber(rewards[4])
        end
        cell:init(rewardType, -1, tonumber(rewards[2]),nil,nil,true,true,1,table)
    else
        cell:init(rewardType,-1, tonumber(rewards[2]),nil,nil,true,true,1)
    end
    cell:showName(tonumber(rewards[2]),rewardType)
    self.Panel_bullet_prop_box:addChild(cell)
end

function RescueStationDonationBullet:onEnterTransitionFinish()
	-- 加载RescueStationDonationBulletWindow界面资源.
	-- res.activity.rescue_station_donation_bullet = res/activity/rescue_station_donation_bullet.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_donation_bullet.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 捐赠按钮
	self.Button_bullet_donation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bullet_donation"), nil,
	{
		terminal_name = "rescue_station_donation_bullet_is_use",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消捐赠
	self.Button_bullet_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bullet_cancel"), nil,
	{
		terminal_name = "rescue_station_donation_bullet_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_bullet_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bullet_closed"), nil,
	{
		terminal_name = "rescue_station_donation_bullet_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
     
     --增加
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_bullet_Minus"), nil, 
    {
        terminal_name = "rescue_station_donation_bullet_set_min", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    --减少
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_bullet_plus"), nil, 
    {
        terminal_name = "rescue_station_donation_bullet_set_max", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    
    local max_tl = 0

    if tonumber(self._info[1]) == 6  then
    	max_tl = tonumber(fundPropWidthId(self._info[2]).prop_number)  
    else
	    local haveNumber = 0
	    for i , v in pairs(_ED.user_equiment) do
	        if tonumber(v.user_equiment_template) == tonumber(self._info[2]) then
	            haveNumber = haveNumber + 1
	        end
	    end
    	max_tl= haveNumber
    end

    local info =  json.decode(_ED.active_activity[159].activity_params)
    local donation_time = dms.int(dms["activity_config"], 48, activity_config.param)
    local max_tl_one = donation_time - info.donation_count

    self._max_select_num = ((max_tl < max_tl_one) and {max_tl} or {max_tl_one})[1]

    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_bullet_number")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("rescue_station_donation_bullet_update", 0, {sender:getPercent()})
        end
    end
    Slider_number_xz:addEventListener(percentChangedEvent)
	
	self:onUpdateDraw()
    self:setSelectNum(self._max_select_num)

	
end

function RescueStationDonationBullet:onExit()
	-- 释放RescueStationDonationBulletWindow界面资源.
	state_machine.remove("rescue_station_donation_bullet_open")
	state_machine.remove("rescue_station_donation_bullet_close")
	state_machine.remove("rescue_station_donation_bullet_show")
	state_machine.remove("rescue_station_donation_bullet_hide")
end

function RescueStationDonationBullet:close()
	-- window event : close.
	
end

function RescueStationDonationBullet:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
