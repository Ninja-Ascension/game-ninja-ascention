-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战底图主界面
-------------------------------------------------------------------------------------------------------
CrossServerBattelMap = class("CrossServerBattelMapClass", Window)

local cross_server_battel_map_window_open_terminal = {
    _name = "cross_server_battel_map_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:open(CrossServerBattelMap:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local cross_server_battel_map_window_close_terminal = {
    _name = "cross_server_battel_map_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	if fwin:find("CrossServerBattelOpenClass") and fwin:find("CrossServerBattelOpenClass"):isVisible() then
	    	state_machine.excute("cross_server_battel_open_window_close", 0, "")
	    end
	    if fwin:find("CrossServerBattelOverClass") and fwin:find("CrossServerBattelOverClass"):isVisible() then
	    	state_machine.excute("cross_server_battel_over_window_close", 0, "")
	    end
	    fwin:close(fwin:find("CrossServerBattelMapClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_map_window_open_terminal)
state_machine.add(cross_server_battel_map_window_close_terminal)
state_machine.init()


function CrossServerBattelMap:ctor()
    self.super:ctor()
    self.roots = {}
	self._armature = nil

	-- load lua file
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelOpen")
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelOver")
    
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelRule")
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShop")
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelReport")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelRank")
	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_map_cell")
	
    -- Initialize Arena page state machine.
    local function init_cross_server_battel_map_terminal()
		local cross_server_battel_map_window_update_terminal = {
		    _name = "cross_server_battel_map_window_update",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		     	local mapType =  params
		    	instance:onUpdateDraw(mapType)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

        local cross_server_battel_map_window_open_update_terminal = {
            _name = "cross_server_battel_map_window_open_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:selectJoinTo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(cross_server_battel_map_window_update_terminal)
        state_machine.add(cross_server_battel_map_window_open_update_terminal)
		state_machine.init()
	end
	init_cross_server_battel_map_terminal()
end

function CrossServerBattelMap:onUpdate(dt)
end

function CrossServerBattelMap:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%01d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossServerBattelMap:onUpdateDraw(mapType)
	local root = self.roots[1]
	self:stopAllActions()
	for i=1,11 do
		local panel_cell = ccui.Helper:seekWidgetByName(root, "Panel_cross_p_" .. i)
		panel_cell:removeAllChildren(true)
	end

    self.my_index = -1
	local map_infos = tonumber(mapType) == 1 and _ED.cross_server_battel_map_info.lunch_list or _ED.cross_server_battel_map_info.top_list
    
    table.sort( map_infos, function ( a, b )
        return tonumber(a.mineId) < tonumber(b.mineId)
    end )
    if map_infos and table.nums(map_infos) ~= 0 then
		for i = 1, 11 do
            if map_infos[i] and table.nums(map_infos[i]) ~= 0 then
    			self:runAction(cc.Sequence:create({cc.DelayTime:create((i-1)*0.3), cc.CallFunc:create(function ( sender )
    					local panel_cell = ccui.Helper:seekWidgetByName(root, "Panel_cross_p_" .. i)
    					panel_cell:removeAllChildren(true)
    					local cell = CrossServiceMapCell:createCell()
    					cell:init({mapType, map_infos[i]})
    					panel_cell:addChild(cell)
    				end)}))
                if tonumber(map_infos[i].userInfo.serverId) == tonumber(_ED.cross_server_battel_map_info.realServerId) and 
                tonumber(map_infos[i].userInfo.userId) == tonumber(_ED.user_info.user_id) then
                    self.my_index = i
                end
            end
		end
	end
    if mapType == 1 and self.my_index ~= -1 then
    	local my_panel = ccui.Helper:seekWidgetByName(root, "Panel_cross_p_" .. self.my_index)
    	self:scrollToMe(my_panel)
    end
end

function CrossServerBattelMap:scrollToMe(myCell)
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_cross")
	local myCell_X, myCell_Y = myCell:getPosition()
	local baseWidth = m_ScrollView:getContentSize().width
	local baseHeight = m_ScrollView:getContentSize().height
    local movePosX = baseWidth/2 - myCell_X
    local movePosY = baseHeight/2 - myCell_Y
    local maxSize = m_ScrollView:getInnerContainer():getContentSize()
    movePosX = math.min(0, movePosX)
    movePosX = math.max(-maxSize.width + baseWidth, movePosX)
    movePosY = math.min(0, movePosY)
    movePosY = math.max(-maxSize.height + baseHeight, movePosY)
    m_ScrollView:getInnerContainer():setPosition(cc.p(movePosX, movePosY))
end

function CrossServerBattelMap:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/cross_service/cross_service_map.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_rule"), nil, 
    {
        terminal_name = "cross_server_battel_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    --商城
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop"), nil, 
    {
        terminal_name = "cross_server_battel_shop_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    
    --战报
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanbao"), nil, 
    {
        terminal_name = "cross_server_battel_report_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking"), nil, 
    {
        terminal_name = "cross_server_battel_rank_open", 
        isPressedActionEnabled = true
    },
    nil,0)

	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_report_back"), nil, 
    {
        terminal_name = "cross_server_battel_map_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    self:selectJoinTo()
    -- state_machine.excute("cross_server_battel_over_window_open", 0, "")
end

function CrossServerBattelMap:selectJoinTo()
    local root = self.roots[1]
    self:stopAllActions()
    if root then
        for i=1,11 do
            local panel_cell = ccui.Helper:seekWidgetByName(root, "Panel_cross_p_" .. i)
            panel_cell:removeAllChildren(true)
        end
        local Button_zhanbao = ccui.Helper:seekWidgetByName(root, "Button_zhanbao")
        Button_zhanbao:setVisible(_ED.cross_server_battel_is_open == 1)
    end
    -- 跨服矿战  开始、结束UI
    local Panel_cross_map_bg = ccui.Helper:seekWidgetByName(root, "Panel_cross_map_bg")
    if _ED.cross_server_battel_is_open == 0 then
        Panel_cross_map_bg:setVisible(true)
        state_machine.excute("cross_server_battel_over_window_open", 0, "")
    else
        Panel_cross_map_bg:setVisible(false)
        state_machine.excute("cross_server_battel_open_window_open", 0, "")
    end
    -- 
end

function CrossServerBattelMap:init()
end

function CrossServerBattelMap:onExit()
	state_machine.remove("cross_server_battel_map_window_update")
    state_machine.remove("cross_server_battel_map_window_open_update")
end