-- ------------------------------------------------------------------------------------------------------------
--  说明：阵营对决奖励
-- ------------------------------------------------------------------------------------------------------------
CampPkReward = class("CampPkRewardClass", Window)

--打开界面
local camp_pk_reward_open_terminal = {
    _name = "camp_pk_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = CampPkReward:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_reward_open_terminal)
state_machine.init()

function CampPkReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._current_page = 0
    self._pages = {}
    self._buttons = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    local function init_camp_pk_reward_terminal()
        local camp_pk_reward_show_terminal = {
            _name = "camp_pk_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                state_machine.excute("camp_pk_reward_request_update_draw", 0, instance._current_page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_reward_hide_terminal = {
            _name = "camp_pk_reward_hide",
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

        -- 切换页面
        local camp_pk_reward_change_page_terminal = {
            _name = "camp_pk_reward_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求最新的排行榜数据刷新
        local camp_pk_reward_request_update_draw_terminal = {
            _name = "camp_pk_reward_request_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params
                local function responseCallback2(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:changeSelectPage(page)
                        end
                    end
                end

                local function responseCallback1(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            protocol_command.camp_duel_rank_list_get.param_list = "1"
                            NetworkManager:register(protocol_command.camp_duel_rank_list_get.code, nil, nil, nil, response.node, responseCallback2, false, nil)
                        end
                    end
                end
                
                protocol_command.camp_duel_rank_list_get.param_list = "0"
                NetworkManager:register(protocol_command.camp_duel_rank_list_get.code, nil, nil, nil, instance, responseCallback1, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_reward_show_terminal)
        state_machine.add(camp_pk_reward_hide_terminal)
        state_machine.add(camp_pk_reward_change_page_terminal)
        state_machine.add(camp_pk_reward_request_update_draw_terminal)
        state_machine.init()
    end
    init_camp_pk_reward_terminal()
end

function CampPkReward:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_rebel_reward_box_tab = ccui.Helper:seekWidgetByName(root, "Panel_rebel_reward_box_tab")
    local Text_camp_pk_meritorious_me_t = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_meritorious_me_t")
    local Text_camp_pk_meritorious_me_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_meritorious_me_n")
    local Text_camp_pk_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_rank_me_n")
    local Text_camp_pk_finsh_t = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_finsh_t")
    local Text_camp_pk_finsh_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_finsh_n")
    local Image_camp_pk_rank_bar = ccui.Helper:seekWidgetByName(root, "Image_camp_pk_rank_bar")
    local Text_camp_pk_rank_me_t = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_rank_me_t")
    Text_camp_pk_meritorious_me_n:setString("")
    Text_camp_pk_finsh_t:setVisible(false)
    Text_camp_pk_finsh_n:setString("")
    Text_camp_pk_finsh_n:setVisible(true)
    Image_camp_pk_rank_bar:setVisible(true)
    Text_camp_pk_rank_me_t:setVisible(true)
    Text_camp_pk_rank_me_n:setVisible(true)
    local rank_me = 0
    if page == 1 then
        Text_camp_pk_meritorious_me_t:setString(tipStringInfo_campaign_info[48])
        Text_camp_pk_meritorious_me_n:setString(_ED.camp_pk_user_info.current_con)
        if _ED.camp_pk_rank_info ~= nil 
            and _ED.camp_pk_rank_info["0"] ~= nil then
            for k, v in pairs(_ED.camp_pk_rank_info["0"]) do
                if v.user_id == tonumber(_ED.user_info.user_id) then
                    rank_me = k
                    break
                end
            end
        end
    elseif page == 2 then
        if _ED.camp_pk_rank_info ~= nil 
            and _ED.camp_pk_rank_info["1"] ~= nil then
            for k, v in pairs(_ED.camp_pk_rank_info["1"]) do
                if v.user_id == tonumber(_ED.user_info.user_id) then
                    rank_me = k
                    break
                end
            end
        end
        Text_camp_pk_meritorious_me_t:setString(tipStringInfo_campaign_info[49].._ED.camp_pk_user_info.win_times)
    else
        Text_camp_pk_finsh_t:setVisible(true)
        Text_camp_pk_meritorious_me_t:setString(tipStringInfo_campaign_info[50])
        Text_camp_pk_finsh_n:setString(_ED.camp_pk_user_info.join_times)
        Image_camp_pk_rank_bar:setVisible(false)
        Text_camp_pk_rank_me_t:setVisible(false)
        Text_camp_pk_rank_me_n:setVisible(false)
    end
    if rank_me == 0 then
        Text_camp_pk_rank_me_n:setString(tipStringInfo_campaign_info[4])
        Text_camp_pk_rank_me_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_camp_pk_rank_me_n:setString(rank_me)
        Text_camp_pk_finsh_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
    
    for k,v in pairs(self._buttons) do
        if page == k then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    for k,v in pairs(self._pages) do
        v:setVisible(false)
    end
    if self._pages[""..page] == nil then
        self._pages[""..page] = state_machine.excute("camp_pk_reward_list_open", 0, {Panel_rebel_reward_box_tab, page})
        if page == 3 then
            self._pages[""..page]:setPositionY(Image_camp_pk_rank_bar:getContentSize().height)
        end
    else
        self._pages[""..page]:setVisible(true)
    end
end

function CampPkReward:onInit(params)
    local csbItem = csb.createNode(string.format(config_csb.campaign.camp_pk_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_meritorious_reward"),
                    ccui.Helper:seekWidgetByName(root, "Button_straight_reward"),
                    ccui.Helper:seekWidgetByName(root, "Button_active_reward")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "camp_pk_reward_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    local page = 1
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        page = tonumber(params._datas._page)
    end
    state_machine.excute("camp_pk_reward_request_update_draw", 0, page)
end

function CampPkReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit(params)
    return self
end

function CampPkReward:onExit()
    state_machine.remove("camp_pk_reward_show")
    state_machine.remove("camp_pk_reward_hide")
    state_machine.remove("camp_pk_reward_change_page")
    state_machine.remove("camp_pk_reward_request_update_draw")
end