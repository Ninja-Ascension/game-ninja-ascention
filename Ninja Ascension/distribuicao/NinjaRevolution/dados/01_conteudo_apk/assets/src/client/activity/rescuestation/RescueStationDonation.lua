--[[ ----------------------------------------------------------------------------
-- 道具捐赠界面
--]] ----------------------------------------------------------------------------
RescueStationDonation = class("RescueStationDonationClass", Window)

-- 打开窗口
local rescue_station_donation_window_open_terminal = {
	_name = "rescue_station_donation_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationDonationClass") then
			fwin:open(RescueStationDonation:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_donation_window_close_terminal = {
	_name = "rescue_station_donation_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationDonationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_donation_window_open_terminal)
state_machine.add(rescue_station_donation_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationDonation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._info = {}
    self._scroll_view_pox = 0
    app.load("client.cells.activity.rescue_station_donation_cell")
    
	local function init_rescue_station_donation_terminal()
		-- 打开角色创建窗口
		local rescue_station_donation_open_terminal = {
			_name = "rescue_station_donation_open",
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
		local rescue_station_donation_close_terminal = {
			_name = "rescue_station_donation_close",
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
		local rescue_station_donation_show_terminal = {
			_name = "rescue_station_donation_show",
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
		local rescue_station_donation_hide_terminal = {
			_name = "rescue_station_donation_hide",
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

		--道具捐赠 刷新
		local rescue_station_donation_bullet_tool_update_terminal = {
			_name = "rescue_station_donation_bullet_tool_update",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
  			    instance:chooseBullet()
  			    instance:onUpdateDraw()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(rescue_station_donation_open_terminal)
		state_machine.add(rescue_station_donation_close_terminal)
		state_machine.add(rescue_station_donation_show_terminal)
		state_machine.add(rescue_station_donation_hide_terminal)
		state_machine.add(rescue_station_donation_bullet_tool_update_terminal)
		state_machine.init()
	end
	-- call func init rescue station donation state machine.
	init_rescue_station_donation_terminal()
end

-- 对象初始化
function RescueStationDonation:init(params)
    self._info = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end


function RescueStationDonation:chooseBullet()
	local all = table.nums(dms["role_rescue_exchange"])
	local donation_info = {}
	for i=3,all do
		local infos = dms.searchs(dms["role_rescue_exchange"],1,i) 
		info = zstring.split(infos[1][2],",")
        if (tonumber(info[1]) == 6  and fundPropWidthId(tonumber(info[2]))) or (tonumber(info[1]) == 7 and fundEquipWidthId(tonumber(info[2]))) then
        	table.insert(donation_info,infos[1])
        end
	end
	self._info = donation_info
end


function RescueStationDonation:onUpdateDraw()
	local root = self.roots[1]
    local info =  json.decode(_ED.active_activity[159].activity_params)
    local donation_time = dms.int(dms["activity_config"], 48, activity_config.param)
    
	-- 本届活动已捐物品数及上限数
	self.Text_donation_props_n = ccui.Helper:seekWidgetByName(root, "Text_donation_props_n")
    self.Text_donation_props_n:setString(info.donation_count.."/"..donation_time)
    
	-- 当前积分
	self.Text_donation_integral_n = ccui.Helper:seekWidgetByName(root, "Text_donation_integral_n")
    if _ED.rescue_station_rank_info.myRank then
		self.Text_donation_integral_n:setString(_ED.rescue_station_rank_info.myRank.info.score)
    else
    	self.Text_donation_integral_n:setString(0)
	end

    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_donation_box")
    m_ScrollView:removeAllChildren(true)

    local Text_donation_no = ccui.Helper:seekWidgetByName(root, "Text_donation_no")
    Text_donation_no:setVisible(false)

    if next(self._info) == nil then
    	Text_donation_no:setVisible(true)
    	return
    end
  

    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/2
    local Hlindex = 0
    local number = table.nums(self._info)
    local m_number = math.ceil(number/2) + 1

    --101 cell的高度，暂时写死 50分割线的高度
    cellHeight = m_number*101
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    for j, v in pairs(self._info) do
        local cell = state_machine.excute("rescue_station_donation_cell_create",0,self._info[j])  
     --  cell:init(v, 2, j)
        panel:addChild(cell)
        cell_height = cell:getContentSize().height
        tWidth = tWidth + wPosition
            if (index-1)%2 ==0 then
                Hlindex = Hlindex+1
                tWidth = 0
                tHeight = sHeight - cell_height*Hlindex  
            end
            if index <= 2 then
                tHeight = sHeight - cell_height
            end
      
        cell:setPosition(cc.p(tWidth,tHeight))
        index = index + 1
    end
    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()

end

function RescueStationDonation:onEnterTransitionFinish()
	-- 加载RescueStationDonationWindow界面资源.
	-- res.activity.rescue_station_donation = res/   rescue_station_donation
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_donation.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_donation_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_donation_back"), nil,
	{
		terminal_name = "rescue_station_donation_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

    self:chooseBullet()
	self:onUpdateDraw()
end

function RescueStationDonation:onExit()
	-- 释放RescueStationDonationWindow界面资源.
	state_machine.remove("rescue_station_donation_open")
	state_machine.remove("rescue_station_donation_close")
	state_machine.remove("rescue_station_donation_show")
	state_machine.remove("rescue_station_donation_hide")
	-- Lo llama la respuesta de la donacion (RescueStationDonationBullet:207) aunque esta ventana ya no este.
	state_machine.remove("rescue_station_donation_bullet_tool_update")
end

function RescueStationDonation:close()
	-- window event : close.
	
end

function RescueStationDonation:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
