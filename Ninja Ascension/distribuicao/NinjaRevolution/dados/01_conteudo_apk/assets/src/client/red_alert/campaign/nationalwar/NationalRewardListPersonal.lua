-- ----------------------------------------------------------------------------------------------------
-- 国战奖励查询列表（个人）
-- ----------------------------------------------------------------------------------------------------
NationalRewardListPersonal = class("NationalRewardListPersonalClass", Window)

-- 创建列表
local national_reward_list_personal_window_open_terminal = {
    _name = "national_reward_list_personal_window_open",
    _init = function (terminal)
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalRewardListPersonalWindowOpen = fwin:find("NationalRewardListPersonalClass")
        if nil == nationalRewardListPersonalWindowOpen then
            fwin:open(NationalRewardListPersonal:new():init(params), fwin._view)
        else
            state_machine.excute("national_reward_list_personal_window_show", 0, params)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭列表
local national_reward_list_personal_window_close_terminal = {
    _name = "national_reward_list_personal_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalRewardListPersonalClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_reward_list_personal_window_open_terminal)
state_machine.add(national_reward_list_personal_window_close_terminal)
state_machine.init()

function NationalRewardListPersonal:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load加载 对应createcell模块
    app.load("client.red_alert.cells.campaign.nationalwar.national_reward_cell")

    -- Initialize national reward list personal state machine.
    local function init_national_reward_list_personal_terminal()
        --show window
        local national_reward_list_personal_window_show_terminal = {
            _name = "national_reward_list_personal_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --hide window
        local national_reward_list_personal_window_hide_terminal = {
            _name = "national_reward_list_personal_window_hide",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_reward_list_personal_window_show_terminal)
        state_machine.add(national_reward_list_personal_window_hide_terminal)
        state_machine.init()     
    end
    -- call func init national Reward list state machine.
    init_national_reward_list_personal_terminal()

end

function NationalRewardListPersonal:onUpdateDraw(params)
    local root = self.roots[1]
    local listView_reward = ccui.Helper:seekWidgetByName(root,"ListView_national_truce_reward")

    local table_reward_personal = dms.searchs(dms["warfare_order_reward"],warfare_order_reward.type,1)

    for i,v in pairs(table_reward_personal) do
        local reward_info = v[warfare_order_reward.reward_info]
        local cell = state_machine.excute("national_reward_cell_create", 0, {_type = 1, _reward_info = reward_info, _index = i})
        listView_reward:addChild(cell)     
    end
end

function NationalRewardListPersonal:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_reward_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw(params)
end

function NationalRewardListPersonal:init(params)
    self._rootWindows = params._rootWindows
    self:onInit(params)
    return self
end

function NationalRewardListPersonal:onExit()
    state_machine.remove("national_reward_list_personal_window_show")
    state_machine.remove("national_reward_list_personal_window_hide")
end