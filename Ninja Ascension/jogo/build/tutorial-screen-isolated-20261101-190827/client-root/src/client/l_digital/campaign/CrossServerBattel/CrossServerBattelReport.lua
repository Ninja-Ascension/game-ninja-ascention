-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战战报
-------------------------------------------------------------------------------------------------------

CrossServerBattelReport = class("CrossServerBattelReportClass", Window)

local cross_server_battel_report_open_terminal = {
    _name = "cross_server_battel_report_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseCrossServerBattelReportInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local CrossServerBattelReportWindow = fwin:find("CrossServerBattelReportClass")
                if CrossServerBattelReportWindow == nil then
                    fwin:open(CrossServerBattelReport:new():init(params), fwin._view)
                end
            end
        end
        local max_num = dms.int(dms["gvg_config"], 24, gvg_config.param)
        protocol_command.cross_mine_load_all_loot_info.param_list = 1 .. "\r\n" .. max_num --初始化
        NetworkManager:register(protocol_command.cross_mine_load_all_loot_info.code, nil, nil, nil, nil, responseCrossServerBattelReportInitCallback, false, nil)
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(cross_server_battel_report_open_terminal)
state_machine.init()

function CrossServerBattelReport:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 2
	self.currentScrollView = nil
	self.currentScrollViewInnerContainer = nil
	self.currentScrollViewInnerContainerPosY = 0

	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_report_cell")

	local function init_cross_server_battel_report_terminal()
		--
		local cross_server_battel_report_close_terminal = {
            _name = "cross_server_battel_report_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("CrossServerBattelReportClass"))
				fwin:close(fwin:find("CrossServerBattelShopTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_report_revenge_count_update_terminal = {
            _name = "cross_server_battel_report_revenge_count_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Text_report_revenge_time_n = ccui.Helper:seekWidgetByName(root, "Text_report_revenge_time_n")
                local Button_time_add = ccui.Helper:seekWidgetByName(root, "Button_time_add")
                local max_num = dms.int(dms["gvg_config"], 13, gvg_config.param)
                Text_report_revenge_time_n:setString(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime .. "/" .. max_num)
                Button_time_add:setVisible(zstring.tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime) <= 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_revenge_num_add_terminal = {
            _name = "cross_server_battel_revenge_num_add",
            _init = function (terminal)
                app.load("client.utils.BuyConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime) <= 0 then
                    local needData = zstring.split(dms.string(dms["gvg_config"], 14, gvg_config.param), ",")
                    local buy_times = zstring.tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.buyCount)
                    local _price = 0
                    if buy_times > #needData then
                        _price = tonumber(needData[#needData])
                    else
                        _price = needData[buy_times + 1]
                    end
                    local callback = "cross_server_battel_revenge_num_add_buy_confirm"
                    state_machine.excute("buy_confirm_tip_open", 0, {1, _price, tipStringInfo_cross_server_battel_tips[20], callback, params._datas, tipStringInfo_cross_server_battel_tips[31]})
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_revenge_num_add_buy_confirm_terminal = {
            _name = "cross_server_battel_revenge_num_add_buy_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCrossServerBattelInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_string_piece_info[76])
                        state_machine.excute("cross_server_battel_report_revenge_count_update",0,"")
                    end
                end
                protocol_command.cross_mine_buy_loot_or_revenge.param_list = 2
                NetworkManager:register(protocol_command.cross_mine_buy_loot_or_revenge.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(cross_server_battel_report_close_terminal)
        state_machine.add(cross_server_battel_report_revenge_count_update_terminal)
        state_machine.add(cross_server_battel_revenge_num_add_terminal)
        state_machine.add(cross_server_battel_revenge_num_add_buy_confirm_terminal)
        state_machine.init()
	end
	init_cross_server_battel_report_terminal()
end

function CrossServerBattelReport:onUpdateDraw()
	local root = self.roots[1]
    local Text_report_revenge_time_n = ccui.Helper:seekWidgetByName(root, "Text_report_revenge_time_n")
    local Button_time_add = ccui.Helper:seekWidgetByName(root, "Button_time_add")
    local max_num = dms.int(dms["gvg_config"], 13, gvg_config.param)
    Text_report_revenge_time_n:setString(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime .. "/" .. max_num)
    -- if tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime) >= 0 then
    --     Text_report_revenge_time_n:setColor(cc.c3b(0,198,255))
    -- else
    --     Text_report_revenge_time_n:setColor(cc.c3b(255,0,0))
    -- end
    Button_time_add:setVisible(zstring.tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime) <= 0)
	self:createScollView()
end

function CrossServerBattelReport:createScollView(infos)
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_zhanbao")
	m_ScrollView:removeAllChildren(true)
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
    local wPosition = sWidth/3
    local Hlindex = 0
    local num = table.nums(_ED.cross_server_battel_report_info)
    local m_number = math.ceil(num/3)
    cellHeight = m_number*265
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    -- local max_num = dms.int(dms["gvg_config"], 24, gvg_config.param)
    local newReports = _ED.cross_server_battel_report_info
    local function sortReports()
        local reports = {}
        for k, info in pairs(newReports) do
            info.id = k
            table.insert(reports, info)
        end
        table.sort(reports, function ( a, b )
            return tonumber(a.lootTimeStemp) > tonumber(b.lootTimeStemp)
        end)
        return reports
    end

    for k, info in ipairs(sortReports()) do
        if info then
            local cell = CrossServiceReportCell:createCell()
    		cell:init({info.id, info})	
            panel:addChild(cell)
            cell_height = cell:getContentSize().height
            tWidth = tWidth + wPosition
            if (index-1)%3 ==0 then
                Hlindex = Hlindex+1
                tWidth = 0
                tHeight = sHeight - cell_height*Hlindex  
            end
            if index <= 3 then
                tHeight = sHeight - cell_height
            end
            cell:setPosition(cc.p(tWidth,tHeight))
            index = index + 1
        end
    end
  --   for j, v in pairs(infos) do
  --       local cell = ArenaWarReportSeatCell:createCell()
		-- cell:init(v, j)	
  --       panel:addChild(cell)
  --       cell_height = cell:getContentSize().height
  --       tWidth = tWidth + wPosition
  --       if (index-1)%3 ==0 then
  --           Hlindex = Hlindex+1
  --           tWidth = 0
  --           tHeight = sHeight - cell_height*Hlindex  
  --       end
  --       if index <= 3 then
  --           tHeight = sHeight - cell_height
  --       end
  --       cell:setPosition(cc.p(tWidth,tHeight))
  --       index = index + 1
  --   end

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()

    m_ScrollView:jumpToTop()
end

function CrossServerBattelReport:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentScrollViewInnerContainer ~= nil then
	    local size = self.currentScrollView:getContentSize()
	    local posY = self.currentScrollViewInnerContainer:getPositionY()
	    if self.currentScrollViewInnerContainerPosY == posY then
	        return
	    end
	    self.currentScrollViewInnerContainerPosY = posY
	    local items = self.currentScrollView:getChildren()
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

function CrossServerBattelReport:onInit()
	local csbCrossServerShop = csb.createNode("campaign/cross_service/cross_service_report.csb")
	local root = csbCrossServerShop:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbCrossServerShop)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_report_back"), nil, 
	{
		terminal_name = "cross_server_battel_report_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)

    --复仇次数增加
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_time_add"), nil, 
    {
        terminal_name = "cross_server_battel_revenge_num_add", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 2)
	
	self:onUpdateDraw()

	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop")                   --顶部用户信息
    local userinfo = CrossServerBattelShopTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function CrossServerBattelReport:init(params)
	self.index = params
	self:onInit()
	return self
end

function CrossServerBattelReport:onExit()
	state_machine.remove("cross_server_battel_revenge_num_add")
    state_machine.remove("cross_server_battel_revenge_num_add_buy_confirm")
    state_machine.remove("cross_server_battel_report_revenge_count_update")
end

