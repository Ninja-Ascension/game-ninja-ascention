--[[ ----------------------------------------------------------------------------
-- 救助站道具捐赠界面列表控件
--]] ----------------------------------------------------------------------------
RescueStationDonationCell = class("RescueStationDonationCellClass", Window)
RescueStationDonationCell.__size = nil

-- 创建Cell实例
local rescue_station_donation_cell_create_terminal = {
	_name = "rescue_station_donation_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RescueStationDonationCell then
			local cell = RescueStationDonationCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_donation_cell_create_terminal)
state_machine.init()

-- 构造器
function RescueStationDonationCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self._info = {}
	self._idex = 0
	self._have_num = 0
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.rescuestation.RescueStationDonationBullet")
	local function init_rescue_station_donation_cell_terminal()
	    --捐赠
		local rescue_station_donation_cell_body_terminal = {
			_name = "rescue_station_donation_cell_body",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
			    local info =  json.decode(_ED.active_activity[159].activity_params)
				local donation_time = dms.int(dms["activity_config"], 48, activity_config.param)
			    if tonumber(info.donation_count)>=donation_time then
			    	TipDlg.drawTextDailog(tipStringInfo_rescue_station[11]) 
			    else
		    	 	state_machine.excute("rescue_station_donation_bullet_window_open",0,{params._datas._cell})
			    end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(rescue_station_donation_cell_body_terminal)
		state_machine.init()
	end
	init_rescue_station_donation_cell_terminal()
end

-- 对象初始化
function RescueStationDonationCell:init(params)
	self._info = params[2]
    self._idex = params[1]
	self._score = params[3]
	self:onInit(params)
	self:setContentSize(RescueStationDonationCell.__size)
	return self
end

function RescueStationDonationCell:onUpdateDraw()
	local root = self.roots[1]

	-- 道具图标
	self.Panel_station_donation_icon = ccui.Helper:seekWidgetByName(root, "Panel_station_donation_icon")
	self.Panel_station_donation_icon:removeAllChildren(true)
	
    local rewards = zstring.split(self._info, ",")    -- 奖励
    local nums = 0
    local rewardType = zstring.tonumber(rewards[1])

    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
            table.shipStar = tonumber(rewards[4])
        end
        cell:init(rewardType,-1, tonumber(rewards[2]),nil,nil,true,true,1,table)
    else
    	if rewardType == 6 then
    	    nums = tonumber(getPropAllCountByMouldId(tonumber(rewards[2])))
    	elseif rewardType == 7 then
	    	local haveNumber = 0
		    for i , v in pairs(_ED.user_equiment) do
		        if tonumber(v.user_equiment_template) ==tonumber(rewards[2]) then
		            haveNumber = haveNumber + 1
		        end
		    end
            nums = haveNumber
    	end
        cell:init(rewardType,nums, tonumber(rewards[2]),nil,nil,true,true,1)
	end
	self._have_num = nums
    self.Panel_station_donation_icon:addChild(cell)

	-- 获得积分
	self.Text_donation_cell_obtained_n = ccui.Helper:seekWidgetByName(root, "Text_donation_cell_obtained_n")
    self.Text_donation_cell_obtained_n:setString(string.format(tipStringInfo_rescue_station[5], tonumber(self._score)))
end

function RescueStationDonationCell:onEnterTransitionFinish()
	
end

function RescueStationDonationCell:onInit(params)
	local root = cacher.createUIRef("activity/rescue_station/rescue_station_donation_cell.csb", "root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RescueStationDonationCell.__size == nil then
		RescueStationDonationCell.__size = root:getContentSize()
	end

	-- 增加按钮
	self.Button_donation_cell_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_donation_cell_add"), nil,
	{
		terminal_name = "rescue_station_donation_cell_body",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_cell = self
	}, nil, 0)	


	self:onUpdateDraw()
end

function RescueStationDonationCell:onExit()
	-- 释放RescueStationDonationCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/ue_station_donation_cell.csb", root)
	-- ]]
end

function RescueStationDonationCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RescueStationDonationCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/ue_station_donation_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
