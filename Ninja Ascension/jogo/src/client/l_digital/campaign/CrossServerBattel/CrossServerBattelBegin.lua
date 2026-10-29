-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战底图主界面
-------------------------------------------------------------------------------------------------------
CrossServerBattelBegin = class("CrossServerBattelBeginClass", Window)

local cross_server_battel_begin_window_open_terminal = {
    _name = "cross_server_battel_begin_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:open(CrossServerBattelBegin:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local cross_server_battel_begin_window_close_terminal = {
    _name = "cross_server_battel_begin_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
	    fwin:close(fwin:find("CrossServerBattelBeginClass"))
        fwin:close(fwin:find("CrossServerBattelMapClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_begin_window_open_terminal)
state_machine.add(cross_server_battel_begin_window_close_terminal)
state_machine.init()


function CrossServerBattelBegin:ctor()
    self.super:ctor()
    self.roots = {}
	self._armature = nil
    self.left_time = nil

	-- load lua file
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelRule")
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShop")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelRank")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelFormation")
    app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_sever_list_cell")
	
    -- Initialize Arena page state machine.
 --    local function init_cross_server_battel_begin_terminal()
	-- 	local cross_server_battel_begin_window_update_terminal = {
	-- 	    _name = "cross_server_battel_begin_window_update",
	-- 	    _init = function (terminal) 
		        
	-- 	    end,
	-- 	    _inited = false,
	-- 	    _instance = self,
	-- 	    _state = 0,
	-- 	    _invoke = function(terminal, instance, params)
	-- 	     	local mapType =  params
	-- 	    	instance:onUpdateDraw(mapType)
	-- 	        return true
	-- 	    end,
	-- 	    _terminal = nil,
	-- 	    _terminals = nil
	-- 	}

	-- 	state_machine.add(cross_server_battel_begin_window_update_terminal)
	-- 	state_machine.init()
	-- end
	-- init_cross_server_battel_begin_terminal()
end

function CrossServerBattelBegin:onUpdate(dt)
    if nil ~= self.left_time then
        self.left_time = self.left_time - dt
        if self.left_time <= 0 then
            self.left_time = nil
        else
            self.Text_cross_begin_time:setString(self:formatTimeString(self.left_time))
        end
    end
end

function CrossServerBattelBegin:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%d", math.floor(tonumber(_time)/3600/24)) .. tipStringInfo_cross_server_battel_tips[28]
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)/3600)%24)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossServerBattelBegin:onUpdateDraw()
	local root = self.roots[1]
    self.Text_cross_begin_time = ccui.Helper:seekWidgetByName(root, "Text_cross_begin_time")

    local serverList = {} 
    local all_servers = _ED.cross_server_battel_map_close_info.tempServerGroup
    if all_servers and table.nums(all_servers) > 0 then
        for _, v in pairs(all_servers) do
            local serverID = tonumber(v)
            local server_name = _ED.cross_server_battel_all_servers[serverID]
            if server_name ~= nil then
                table.insert(serverList, server_name)
            end
        end
    end

    local ListView_begin_1 = ccui.Helper:seekWidgetByName(root, "ListView_begin_1")
    if ListView_begin_1 then
        ListView_begin_1:removeAllItems()
        for i, v in ipairs(serverList) do
            local cell = state_machine.excute("sm_cross_service_sever_list_cell_create",0,{sever_name = v})
            ListView_begin_1:addChild(cell)
        end
        ListView_begin_1:jumpToTop()
        ListView_begin_1:requestRefreshView()
    else
        for i = 1, 4 do
            local Text_severs_num = ccui.Helper:seekWidgetByName(root, "Text_severs_num_" .. i)
            local server_name = serverList[i]
            if server_name then
                local getStr1 = string.match(server_name, "-")
                local getStr2 = string.match(server_name, "_")
                if getStr1 and getStr1 ~= "" then
                    server_name = zstring.split(server_name, "-")[1]
                elseif getStr2 and getStr2 ~= "" then
                    server_name = zstring.split(server_name, "_")[1]
                end
                Text_severs_num:setString(server_name)
                Text_severs_num:setVisible(true)
            else
                Text_severs_num:setString("")
                Text_severs_num:setVisible(false)
            end
        end
    end
end

function CrossServerBattelBegin:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/cross_service/cross_service_begin.csb")
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

    ccui.Helper:seekWidgetByName(root, "Button_zhanbao"):setVisible(fasle)
    --战报
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanbao"), nil, 
    -- {
    --     terminal_name = "cross_server_battel_report_open", 
    --     isPressedActionEnabled = true
    -- },
    -- nil,0)

    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking"), nil, 
    {
        terminal_name = "cross_server_battel_rank_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    --布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_line"), nil, 
    {
        terminal_name = "cross_server_battel_formation_open",
        _type = 1,
        notGetAdd = -1, --获取鼓舞加成
        isPressedActionEnabled = true
    },
    nil,0)


	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_begin_back"), nil, 
    {
        terminal_name = "cross_server_battel_begin_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)
    self:registerOnNoteUpdate(self, 1)

    
    local left_time = zstring.tonumber(_ED.cross_server_battel_map_close_info.nextOpenTime)/1000 - (_ED.system_time + (os.time() - _ED.native_time))
    if left_time >= 0 then self.left_time = left_time end

    local Panel_begin_dh = ccui.Helper:seekWidgetByName(root, "Panel_begin_dh")
    
    local jsonFile = "images/ui/effice/effect_kfwxskq/effect_kfwxskq.json" 
    local atlasFile = "images/ui/effice/effect_kfwxskq/effect_kfwxskq.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation", "animation2"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_begin_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 1, false)

    self:onUpdateDraw()
    -- state_machine.excute("cross_server_battel_over_window_open", 0, "")
end

function CrossServerBattelBegin:init()
end

function CrossServerBattelBegin:onExit()
    self:unregisterOnNoteUpdate(self)
	-- state_machine.remove("cross_server_battel_begin_window_update")
end