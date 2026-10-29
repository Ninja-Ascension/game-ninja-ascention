-- ----------------------------------------------------------------------------------------------------
-- 国家城池排行信息列表
-- ----------------------------------------------------------------------------------------------------
NationalRankListNational = class("NationalRankListNationalClass", Window)

-- 创建列表
local national_rank_list_national_window_open_terminal = {
    _name = "national_rank_list_national_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalRankListNationalWindow = fwin:find("NationalRankListNationalClass")
        if nil == nationalRankListNationalWindow then
            fwin:open(NationalRankListNational:new():init(params), fwin._view)
        else
            state_machine.excute("national_rank_list_national_window_show", 0, params)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭列表
local national_rank_list_national_window_close_terminal = {
    _name = "national_rank_list_national_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalRankListNationalClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_rank_list_national_window_open_terminal)
state_machine.add(national_rank_list_national_window_close_terminal)
state_machine.init()

function NationalRankListNational:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load
    app.load("client.red_alert.cells.campaign.nationalwar.national_rank_cell")
    app.load("client.red_alert.campaign.nationalwar.NationalRank")

    -- Initialize national rank list national state machine.
    local function init_national_rank_list_national_terminal()
        --show window
        local national_rank_list_national_window_show_terminal = {
            _name = "national_rank_list_national_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("national_rank_me_window_hide", 0, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --hide window
        local national_rank_list_national_window_hide_terminal = {
            _name = "national_rank_list_national_window_hide",
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

        state_machine.add(national_rank_list_national_window_show_terminal)
        state_machine.add(national_rank_list_national_window_hide_terminal)
        state_machine.init()     
    end

    -- call func init national rank list national state machine.
    init_national_rank_list_national_terminal()
end

function NationalRankListNational:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_rank_son_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local rank_league_city_sum = 0
    local rank_list_sorted = self:sortRankList(_ED.war_rank_info.country)

    -- 绘制各个国家信息
    for i, v in pairs(rank_list_sorted) do
        local Panel_national_truce_rank_camp = ccui.Helper:seekWidgetByName(root, "Panel_national_truce_rank_camp_" .. i)
        local Text_national_truce_rank_number = ccui.Helper:seekWidgetByName(root, "Text_national_truce_rank_number_" .. i)
        -- 阵营icon
        Panel_national_truce_rank_camp:setBackGroundImage("images/ui/quality/camp_".. v.rank_camp ..".png")
        Text_national_truce_rank_number:setString(v.rank_city_num)

        -- 计算同盟城池总数
        if tonumber(v.rank_league) >0 then
            rank_league_city_sum = rank_league_city_sum + tonumber(v.rank_city_num)
        end

        local rank_order = v.rank_order
        local Panel_national_truce_ranking = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_ranking_"..i)
        Panel_national_truce_ranking:setBackGroundImage("images/ui/text/phb_"..rank_order.."st.png")
    end

    -- 绘制同盟信息
    for i,v in pairs(rank_list_sorted) do
        if tonumber(v.rank_league) >0 then
            local Panel_balance = ccui.Helper:seekWidgetByName(root,"Panel_balance_"..i)
            Panel_balance:setVisible(true)

            -- 盟字
            local Image_meng = ccui.Helper:seekWidgetByName(root,"Image_meng_"..i)
            Image_meng:setVisible(true)            

            -- 阵营名字 和 阵营城池总数量
            local Text_national_truce_camp_name = ccui.Helper:seekWidgetByName(root, "Text_national_camp_" .. i)
            local Text_national_truce_camp_sum = ccui.Helper:seekWidgetByName(root, "Text_national_truce_build_v_" .. i)
            local camp_index = tonumber(v.rank_league)
            -- print("red_alert_hero_camp[camp_index]-----------",red_alert_hero_camp[camp_index])
            Text_national_truce_camp_name:setString(red_alert_hero_camp[camp_index])
            Text_national_truce_camp_sum:setString(tostring(rank_league_city_sum))
        end
    end
end

function NationalRankListNational:sortRankList(rank_list_data)
    local max_city_num = 0
    local rank_list_sorted = {} 
    for i, v in pairs(rank_list_data) do
        if tonumber(v.rank_league) >0 then
            if max_city_num < tonumber(v.rank_city_num) then
                max_city_num = tonumber(v.rank_city_num)
                table.insert(rank_list_sorted, 1, v)
            else
                table.insert(rank_list_sorted, v)           
            end
        else
            table.insert(rank_list_sorted, v)
        end
    end
    return rank_list_sorted
end

function NationalRankListNational:init(params)
    self._rootWindows = params._rootWindows
    self:onInit()
    return self
end

function NationalRankListNational:onExit()
    state_machine.remove("national_rank_list_national_window_show")
    state_machine.remove("national_rank_list_national_window_hide")
end

