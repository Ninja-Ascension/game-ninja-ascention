-- ----------------------------------------------------------------------------------------------------
-- 说明：一次探索一个任务
-------------------------------------------------------------------------------------------------------
FileIslandOneFinishOpenBox = class("FileIslandOneFinishOpenBoxClass", Window)

local fileIsland_one_finish_open_box_window_open_terminal = {
    _name = "fileIsland_one_finish_open_box_open_box_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FileIslandOneFinishOpenBoxClass") == nil then
            fwin:open(FileIslandOneFinishOpenBox:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fileIsland_one_finish_open_box_window_close_terminal = {
    _name = "fileIsland_one_finish_open_box_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("FileIslandOneFinishOpenBoxClass") then
            fwin:close(fwin:find("FileIslandOneFinishOpenBoxClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_one_finish_open_box_window_open_terminal)
state_machine.add(fileIsland_one_finish_open_box_window_close_terminal)
state_machine.init()

function FileIslandOneFinishOpenBox:ctor()
    self.super:ctor()
    self.roots = {}
    
    local function init_fileIsland_one_finish_open_box_terminal()
        local fileIsland_one_finish_open_box_sure_terminal = {
            _name = "fileIsland_one_finish_open_box_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local max_num = dms.int(dms["play_config"], 104, play_config.param)
                local buyTimes = _ED.eventIds[3][1].buyTimes
                if buyTimes >= max_num then
                    TipDlg.drawTextDailog(tipStringInfo_file_island_tips[1])
                    return
                end

                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local rewardInfo = getSceneReward(7) 
                        if rewardInfo ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(nil, rewardInfo)
                            fwin:open(getRewardWnd, fwin._ui)
                            instance:onUpdateDraw()
                        end
                    end
                end

                local data = {}
                for i,v in ipairs(_ED.eventIds[3]) do
                    data[i] = {}
                    data[i].resultIndex = v.index
                    data[i].openTimes = 1
                end
                local req = json.encode(data)
                protocol_command.fileIslandRewardBoxBuy.param_list = req
                NetworkManager:register(protocol_command.fileIslandRewardBoxBuy.code, nil, nil, nil, nil, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_one_finish_open_box_cancel_terminal = {
            _name = "fileIsland_one_finish_open_box_cancel",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                NetworkManager:register(protocol_command.file_island_finish_search_result.code, nil, nil, nil, nil, callback, false, nil)
                state_machine.excute("fileIsland_one_finish_open_box_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_one_finish_open_box_cancel_terminal)
        state_machine.add(fileIsland_one_finish_open_box_sure_terminal)
        state_machine.init()
    end
    
    init_fileIsland_one_finish_open_box_terminal()
end

function FileIslandOneFinishOpenBox:init(params)
    return self
end

function FileIslandOneFinishOpenBox:onUpdate(dt)

end

function FileIslandOneFinishOpenBox:onUpdateDraw()
    local root = self.roots[1]
    -- self.initData()
    local Text_zuanshi_t = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_t")
    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
    local Image_zs_icon = ccui.Helper:seekWidgetByName(root, "Image_zs_icon")
    local Text_zuanshi_time_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_time_n")
    local max_num = dms.int(dms["play_config"], 104, play_config.param)
    local buyTimes = _ED.eventIds[3][1].buyTimes
    if buyTimes < max_num then
        local cost = zstring.split(dms.string(dms["play_config"], 105, play_config.param), ",")[buyTimes + 1]
        Text_zuanshi_n:setString(cost)
    end
    Text_zuanshi_t:setVisible(buyTimes < max_num)
    Text_zuanshi_n:setVisible(buyTimes < max_num)
    Image_zs_icon:setVisible(buyTimes < max_num)
    Text_zuanshi_time_n:setString((max_num - buyTimes) .. "/" .. max_num)
end

function FileIslandOneFinishOpenBox:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/explore/explore_box_open.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open"), nil, 
    {
        terminal_name = "fileIsland_one_finish_open_box_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

     -- 关闭
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
     {
         terminal_name = "fileIsland_one_finish_open_box_cancel", 
         isPressedActionEnabled = true
     },
     nil, 0)

    self:onUpdateDraw()
end

function FileIslandOneFinishOpenBox:onExit()

end
