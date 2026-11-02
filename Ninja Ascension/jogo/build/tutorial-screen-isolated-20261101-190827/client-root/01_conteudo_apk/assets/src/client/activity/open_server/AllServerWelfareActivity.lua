----------------------------------------------------------------------------------------------------
-- 说明：全民福利活动
-------------------------------------------------------------------------------------------------------

AllServerWelfareActivity = class("AllServerWelfareActivityClass", Window)
    
function AllServerWelfareActivity:ctor()
    self.super:ctor()
    self.roots = {}
    self.refresh_time = os.time() + 30
    self.resultList = {}
    -- Initialize all server welfare activity page state machine.
    local function init_all_server_welfare_activity_terminal()
        local all_server_welfare_activity_goto_buy_page_terminal = {
            _name = "all_server_welfare_activity_goto_buy_page",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("open_server_activity_manager", 0, {
                    _datas = {
                        terminal_name = "open_server_activity_manager",     
                        next_terminal_name = "open_server_activity_servers_fund",     
                        current_button_name = "Button_kf_7",
                        but_image = "Image_kf_7",       
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local all_server_welfare_activity_refresh_count_terminal = {
            _name = "all_server_welfare_activity_refresh_count",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseServerFundInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- state_machine.excute("gain_reward_news_send", 0, {response.node, response.node.example})
                        if response.node ~= nil then
                            response.node:updateBuyUserCount()
                        end
                    end
                end
                protocol_command.server_fund_init.param_list = ""..instance.activity.activity_id
                NetworkManager:register(protocol_command.server_fund_init.code, nil, nil, nil, instance, responseServerFundInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local all_server_welfare_activity_update_draw_terminal = {
            _name = "all_server_welfare_activity_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if fwin:find("AllServerWelfareActivityClass") ~= nil then
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(all_server_welfare_activity_update_draw_terminal)
        state_machine.add(all_server_welfare_activity_goto_buy_page_terminal)
        state_machine.add(all_server_welfare_activity_refresh_count_terminal)
        state_machine.init()
    end
    
    -- call func init all server welfare activity state machine.
    init_all_server_welfare_activity_terminal()
end

function AllServerWelfareActivity:updateBuyUserCount()
    local root = self.roots[1]
end

function AllServerWelfareActivity:loading_cell()
    if AllServerWelfareActivity.cacheListView == nil then
        return 
    end
    local activity = _ED.active_activity[28]
    local cell = self.resultList[AllServerWelfareActivity.asyncIndex]
    if cell ~= nil then
        AllServerWelfareActivity.cacheListView:addChild(cell)
        cell:release()
        AllServerWelfareActivity.asyncIndex = AllServerWelfareActivity.asyncIndex + 1
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            AllServerWelfareActivity.cacheListView:requestRefreshView()
        end
    end
end

function AllServerWelfareActivity:initActivityListViewEX()
    local root = self.roots[1]
    app.load("client.cells.activity.open_server_list_cell")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_kf_5")
    local activity = _ED.active_activity[41]
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}

    self.resultList = {}
    cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    AllServerWelfareActivity.asyncIndex = 1
    AllServerWelfareActivity.cacheListView = listView

    if activity ~= nil then
        for i, v in pairs(activity.activity_Info) do
            local cell = OpenServerListCell:createCell()
            local tcell, drawState = cell:init(2, listView, activity, v, i - 1, nil, v.activityInfo_isReward)
            cell:retain()
            if drawState == 0 then
                table.insert(uncompItems, cell)
            elseif drawState == 1 then
                table.insert(drawItems, cell)
            elseif drawState == 2 then
                table.insert(closeItems, cell)
            end
        end
        for i, v in pairs(drawItems) do
            table.insert(self.resultList, v)
        end
        for i, v in pairs(uncompItems) do
            table.insert(self.resultList, v)
        end
        for i, v in pairs(closeItems) do
            table.insert(self.resultList, v)
        end
        for k,v in pairs(self.resultList) do
            cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
        end
        listView:requestRefreshView()
    end
end

function AllServerWelfareActivity:initActivityListView()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        self:initActivityListViewEX()
        return
    end
    local root = self.roots[1]
    app.load("client.cells.activity.open_server_list_cell")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_kf_5")
    local activity = _ED.active_activity[41]
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    for i, v in pairs(activity.activity_Info) do
        local cell = OpenServerListCell:createCell()
        local tcell, drawState = cell:init(2, listView, activity, v, i - 1, nil, v.activityInfo_isReward)
        -- listView:addChild(cell)
        if drawState == 0 then
            table.insert(uncompItems, cell)
        elseif drawState == 1 then
            table.insert(drawItems, cell)
        elseif drawState == 2 then
            table.insert(closeItems, cell)
        end
    end
    for i, v in pairs(drawItems) do
        listView:addChild(v)
    end
    for i, v in pairs(uncompItems) do
        listView:addChild(v)
    end
    for i, v in pairs(closeItems) do
        listView:addChild(v)
    end
    listView:requestRefreshView()
end

function AllServerWelfareActivity:onUpdateDraw()
    local root = self.roots[1]
    local chars = {}--{"0", "0", "0", "0"}
	local charNames = {}
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		charNames = {
			"BitmapFontLabel_fl_1_2",
			"BitmapFontLabel_fl_2_4",
			"BitmapFontLabel_fl_3_6",
			"BitmapFontLabel_fl_4_8",
		}
	else
		charNames = {
			"BitmapFontLabel_fl_1_2",
			"BitmapFontLabel_fl_3_6",
			"BitmapFontLabel_fl_4_8",
			"BitmapFontLabel_fl_2_4",
		}
	end	
    local activity = _ED.active_activity[41]
    local buyCount = activity.activity_buy_count
    for i=1, 4 - #buyCount do
        buyCount = "0"..buyCount
    end
    while buyCount ~= nil and #buyCount > 0 do
        local _char = string.sub(buyCount, 0, 1)
        buyCount = string.sub(buyCount, 2)
        table.insert(chars, _char)
        if #chars > 3 then
            break
        end
    end
    for i = 1, 4 do
        -- print(i, charNames[i], chars[i])
        ccui.Helper:seekWidgetByName(root, charNames[i]):setString(chars[i] or "0")
    end

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_kf_5")

    -- 更新列表的状态
    local items = listView:getItems()
    for i, v in pairs(items) do
        state_machine.excute("open_server_list_cell_update_draw", 0, v)
    end
end

function AllServerWelfareActivity:onEnterTransitionFinish()
    local csbAllServerWelfareActivity = csb.createNode("activity/wonderful/open_service_fund_2.csb")
    self:addChild(csbAllServerWelfareActivity)

    local root = csbAllServerWelfareActivity:getChildByName("root")
    table.insert(self.roots, root)

    self:initActivityListView()

    self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)

    -- 前往购买开服基金的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_015_2"),       nil, 
    {
        terminal_name = "all_server_welfare_activity_goto_buy_page",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local rechargeButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quanfu_cz"),       nil, 
        {
            terminal_name = "shortcut_open_recharge_window",     
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity_recharge",
        _widget = rechargeButton,
        _invoke = nil,
        _interval = 0.5,})        
    end    
end


function AllServerWelfareActivity:onExit()
	state_machine.remove("all_server_welfare_activity_update_draw")
end

function AllServerWelfareActivity:init()
end

function AllServerWelfareActivity:createCell()
    local cell = AllServerWelfareActivity:new()
    cell:registerOnNodeEvent(cell)
    return cell
end