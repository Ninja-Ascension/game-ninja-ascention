-- ----------------------------------------------------------------------------------------------------
-- 国战排行榜界面
-- ----------------------------------------------------------------------------------------------------
NationalRank = class("NationalRankClass", Window)

-- 打开窗口
local national_rank_window_open_terminal = {
    _name = "national_rank_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalRankWindow = fwin:find("NationalRankClass")
        if nil == nationalRankWindow then
            local function responseNationalRankCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(NationalRank:new():init(params._datas or params), fwin._view)
                end
            end
            protocol_command.get_warfare_ranking.param_list = ""
            NetworkManager:register(protocol_command.get_warfare_ranking.code, nil, nil, nil, nil, responseNationalRankCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local national_rank_window_close_terminal = {
    _name = "national_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_rank_window_open_terminal)
state_machine.add(national_rank_window_close_terminal)
state_machine.init()

function NationalRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- app load
    app.load("client.red_alert.campaign.nationalwar.NationalRankListNational")
    app.load("client.red_alert.campaign.nationalwar.NationalRankListPersonal")
    app.load("client.red_alert.campaign.nationalwar.NationalRankPersonalPop")
    app.load("client.red_alert.campaign.nationalwar.NationalReward")
    app.load("client.red_alert.cells.campaign.nationalwar.national_rank_cell")

    -- rank_me_panel 显示个人排名
    self._rank_me_panel = nil

    -- Initialize national rank state machine.
    local function init_national_rank_terminal()
        --管理
        local national_rank_manager_terminal = {
            _name = "national_rank_manager",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    -- hide child window
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end 
                if terminal.select_item ~= nil then
                    terminal.select_item:getChildByName(terminal.select_item._datas.current_image_name):setVisible(false)
                end
                terminal.select_item = params
                terminal.select_item:getChildByName(terminal.select_item._datas.current_image_name):setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换到国家城池排行榜界面
        local national_rank_change_to_national_terminal = {
            _name = "national_rank_change_to_national",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("national_rank_list_national_window_open", 0, params._datas)
                state_machine.excute("national_rank_personal_pop_window_hide", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换到个人荣誉标签切换
        local national_rank_change_to_personal_terminal = {
            _name = "national_rank_change_to_personal",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("national_rank_personal_pop_window_open", 0, params._datas)
                state_machine.excute("national_rank_list_national_window_hide", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 个人排名信息显示
        local national_rank_me_window_show_terminal = {
            _name = "national_rank_me_window_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self._rank_me_panel:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 个人排名信息隐藏
        local national_rank_me_window_hide_terminal = {
            _name = "national_rank_me_window_hide",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self._rank_me_panel:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(national_rank_manager_terminal)
        state_machine.add(national_rank_change_to_national_terminal)
        state_machine.add(national_rank_change_to_personal_terminal)
        state_machine.add(national_rank_me_window_show_terminal)
        state_machine.add(national_rank_me_window_hide_terminal)
        state_machine.init()     
    end

    -- call func init national rank state machine.
    init_national_rank_terminal()
end

function NationalRank:init(params)
    self:onInit()
    return self
end

function NationalRank:onUpdateDraw()
    local root = self.roots[1]
    self._rank_me_panel = ccui.Helper:seekWidgetByName(root,"Panel_rank_me")
    if  (_ED.war_rank_info.rankme.rank_camp and _ED.war_rank_info.rankme.rank_camp ~= {}) then
        _ED.war_rank_info.rankme.index = tonumber(_ED.war_rank_info.rankme.rank_stand)
        _ED.war_rank_info.rankme.mycamp = true
        _ED.war_rank_info.rankme.pageIndex = tonumber(_ED.war_rank_info.rankme.rank_camp)
        local cell_rankme = state_machine.excute("national_rank_cell_create",0,{_ED.war_rank_info.rankme,0})
        self._rank_me_panel:setVisible(false)
        self._rank_me_panel:addChild(cell_rankme)
    end
end


function NationalRank:onInit()
    -- 初始标签为1、国家城池 2、个人荣誉
    local currentPageIndex =  1

    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_rank)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_close"), nil, 
    {
        terminal_name = "national_rank_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)


    --国家城池
    local Panel_truce_cell_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_truce_cell_1"), nil, 
    {
        terminal_name = "national_rank_manager",     
        next_terminal_name = "national_rank_change_to_national", 
        current_image_name = "Image_rank_cell_left_light",
        terminal_state = 0,
        isPressedActionEnabled = false,
        _rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_ranking"),
    }, nil, 3)

    --个人荣誉
    local Panel_truce_cell_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_truce_cell_2"), nil, 
    {
        terminal_name = "national_rank_manager",     
        next_terminal_name = "national_rank_change_to_personal", 
        current_image_name = "Image_rank_cell_left_light", 
        terminal_state = 0,
        isPressedActionEnabled = false,
        _rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_truce_cell_2"),
        _listView_rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_ranking"),
    }, nil, 3)

    --查看奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_rank_reward"), nil, 
    {
        terminal_name = "national_reward_window_open", 
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    if currentPageIndex == 1 then
        fwin.touch(Panel_truce_cell_1, ccui.TouchEventType.ended)
    else
        fwin.touch(Panel_truce_cell_2, ccui.TouchEventType.ended)
    end

    self:onUpdateDraw()
end

function NationalRank:onExit()
    state_machine.remove("national_rank_manager")
    state_machine.remove("national_rank_change_to_national")
    state_machine.remove("national_rank_change_to_personal")
    state_machine.remove("national_rank_me_window_show")
    state_machine.remove("national_rank_me_window_hide")
end

