-----------------------------
-- 批量兑换
-----------------------------
ComExchange = class("ComExchangeClass", Window)

--打开界面
local com_exchange_use_open_terminal = {
	_name = "com_exchange_use_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("ComExchangeClass") == nil then
			fwin:open(ComExchange:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
--关闭界面
local com_exchange_use_close_terminal = {
	_name = "com_exchange_use_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ComExchangeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(com_exchange_use_open_terminal)
state_machine.add(com_exchange_use_close_terminal)
state_machine.init()

function ComExchange:ctor()
	self.super:ctor()
	self.roots = {}
    self.prop = {}
    self.id = 0
    self.oneCell = {}
    self.formCell = ""
    self._select_num = 1
    self._max_select_num = 1

    self.ADDOPERATIONNUM = 1            -- 增加一个
    self.REDUCEOPERATIONNUM = -1        -- 减少一个

    local function init_com_exchange_use_terminal()
        local com_exchange_use_set_min_terminal = {
            _name = "com_exchange_use_set_min",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setSelectNum(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local com_exchange_use_set_max_terminal = {
            _name = "com_exchange_use_set_max",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setSelectNum(instance._max_select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local com_exchange_use_update_terminal = {
            _name = "com_exchange_use_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Slider_number_xz = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_number_xz")
                local select_num = math.ceil(tonumber(Slider_number_xz:getPercent()) * instance._max_select_num / 100)
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local com_exchange_is_use_terminal = {
            _name = "com_exchange_is_use",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.formCell == "treasure_shop_cell" then       --秘宝积分批量兑换
                    instance:changeTreasuresShop(instance)
                elseif instance.formCell == "april_fools_day_prop_exchange_cell" then   --节日活动道具批量兑换
                    instance:changeAprilFoolsDay(instance)
                elseif instance.formCell == "sm_battle_of_kings_exchange_list_cell" then    --王者之战/公会战 批量兑换
                    instance:changeBattleOfKings(instance)
                elseif instance.formCell == "half_price_restriction_cell" then              --活动-碎片兑换-批量兑换
                    instance:changeHalfPrice(instance,params)
                elseif instance.formCell == "sm_battle_of_cross_kings_exchange_list_cell" then              --跨服王者批量兑换
                    instance:changeCrossBattleOfKings(instance,params)
                elseif instance.formCell == "emblem_limit_time_exchange_cell" then              --124活动兑换
                    instance:changeEmblemLimit(instance)
                elseif instance.formCell == "sm_total_war_exchange_list_cell" then      
                    instance:changeTotalWar(instance)
                elseif instance.formCell == "secret_shop_prop_buy_cell" then        --杂货商店
                    instance:changeSecret(instance)
                elseif instance.formCell == "arena_shop_prop_buy_cell" then         --演武商店
                    instance:changeArena(instance)
                elseif instance.formCell == "glories_shop_prop_buy_cell" then       --试炼商店
                    instance:changeGlories(instance)
                elseif instance.formCell == "union_shop_prop_buy_cell" then         --组织商店
                    instance:changeUnion(instance)
                elseif instance.formCell == "cross_server_battel_prop_buy_list_cell" then       --跨服资源战商店
                    instance:changecCrossSeverFight(instance)
                elseif instance.formCell == "pray_activity_list_cell" then  -- 限时祈福任务批量购买
                    instance:changePray(instance)
                elseif instance.formCell ==  "christmas_romance_shop_cell" then -- 圣诞奇缘批量修改
                    instance:changeChristmasRomance(instance)
                elseif instance.formCell ==  "new_recruit_shop_cell" then -- 新招募商店兑换
                    instance:changeNewRecruit(instance)
                elseif instance.formCell ==  "construction_order_shop" then -- 战令商店兑换
                    instance:changeConstructionOrder(instance)
                elseif instance.formCell == "lim_summon_cell" then          -- 限时召唤up池
                    instance:changeLimSummon(instance)
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(com_exchange_use_set_min_terminal)
        state_machine.add(com_exchange_use_set_max_terminal)
        state_machine.add(com_exchange_use_update_terminal)
        state_machine.add(com_exchange_is_use_terminal)
        state_machine.init()
    end
    init_com_exchange_use_terminal()
end
--秘宝商店碎片批量兑换
function ComExchange:changeTreasuresShop(instance)
    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd, fwin._ui)

            if response.node ~= nil then
--                response.node:initData()
--                response.node:onUpdateDraw()
                app.load("client.activity.treasure.TreasureShopWindow")
                local p =  response.node:getParent()
                if p ~= nil then
                    state_machine.excute("treasure_shop_refresh",0,p) --刷新
                end
            end
        end
    end

    local req = {}
    req.itemId = instance.id
    req.buyCount = instance._select_num
    local str = json.encode(req)
    protocol_command.treasures_shop_buy.param_list = str
    NetworkManager:register(protocol_command.treasures_shop_buy.code, nil, nil, nil, instance.oneCell, callback, false, nil)
    fwin:close(fwin:find("TreasureShopBuyClass"))
end
--节日活动道具批量兑换
function ComExchange:changeAprilFoolsDay(instance)
    local function responseExchangeCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd, fwin._ui)
            if response.node ~= nil then
                response.node:onUpdateDraw(true)
            end
            state_machine.excute("april_fools_day_prop_exchange_activity_refresh_cost_prop", 0, nil)
        end
    end
    local cell = instance.oneCell
    protocol_command.get_activity_reward.param_list = cell.activity.activity_id.."\r\n" .. ""..tonumber(cell.index - 1).."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)
end
--王者之战/公会战 批量兑换
function ComExchange:changeBattleOfKings(instance)
    local cell = instance.oneCell
    local function responseCallback(response)
        state_machine.unlock("sm_battle_of_kings_exchange_list_cell_exchange", 0, "")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if nil ~= response.node and nil ~= response.node.roots then
                response.node:updateButtonDraw()
                state_machine.excute("sm_battleof_kings_exchange_update_need_prop_number",0 ,"")
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(11)
                fwin:open(getRewardWnd, fwin._ui)
            end
        end
    end
    state_machine.lock("sm_battle_of_kings_exchange_list_cell_exchange", 0, "")
    protocol_command.shop_buy.param_list = cell._element[1].."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.shop_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
end

--跨服王者之战批量兑换
function ComExchange:changeCrossBattleOfKings(instance)
    local cell = instance.oneCell
    local function responseCallback(response)
        state_machine.unlock("sm_cross_server_battle_of_kings_exchange_list_cell_exchange", 0, "")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if nil ~= response.node and nil ~= response.node.roots then
                response.node:updateButtonDraw()
                state_machine.excute("sm_cross_server_battleof_kings_exchange_update_need_prop_number",0 ,"")
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(11)
                fwin:open(getRewardWnd, fwin._ui)
            end
        end
    end
    state_machine.lock("sm_cross_server_battle_of_kings_exchange_list_cell_exchange", 0, "")
    protocol_command.shop_buy.param_list = cell._element[1].."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.shop_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
end

-- 跨服忍界
function ComExchange:changeTotalWar(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        state_machine.unlock("cross_total_war_shop_buy", 0, "")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(_new_interface_text[92])
            if response.node ~= nil then
                cell.shopInfo.purchasedTimes = tonumber(cell.shopInfo.purchasedTimes) + cell._select_num
                cell:initData()
                cell:onUpdateDraw()
                state_machine.excute("cross_total_war_fresh_coin",0,"")
                fwin:close(instance)
            end
        end
    end
    state_machine.lock("cross_total_war_shop_buy", 0, "")
    protocol_command.cross_arena_shop_buy.param_list = cell.id.."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.cross_arena_shop_buy.code, nil, nil, nil, self, responseBuyPropCallback, false, nil)

    -- local function responseCallback(response)
    --     state_machine.unlock("cross_total_war_shop_buy", 0, "")
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --         if nil ~= response.node and nil ~= response.node.roots then
    --             response.node:updateButtonDraw()
    --             state_machine.excute("sm_cross_server_battleof_kings_exchange_update_need_prop_number",0 ,"")
    --             app.load("client.reward.DrawRareReward")
    --             local getRewardWnd = DrawRareReward:new()
    --             getRewardWnd:init(11)
    --             fwin:open(getRewardWnd, fwin._ui)
    --         end
    --     end
    -- end
    -- state_machine.lock("cross_total_war_shop_buy", 0, "")
    -- protocol_command.shop_buy.param_list = cell._element[1].."\r\n"..instance._select_num
    -- NetworkManager:register(protocol_command.shop_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
end

function ComExchange:changeSecret(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(_new_interface_text[92])
            -- Fury: si el escaparate se rehizo (relogin) mientras volaba la compra, el hueco ya no existe.
            local good = _ED.secret_shop_init_info.goods_info[tonumber(cell.index)]
            if good ~= nil then
                good.remain_times = tonumber(good.remain_times)-tonumber(cell._select_num)
            end
            state_machine.excute("sm_shop_tab_update", 0, "sm_shop_tab_update.")

            if nil ~= fwin:find("ShopPropBuyListViewClass") then
                state_machine.excute("sm_shop_prop_buy_list_refush", 0, cell)
            end

            if nil ~= fwin:find("SecretShopClass") then
                state_machine.excute("sm_secret_shop_prop_buy_list_refush", 0, cell)
            end

            if response.node ~= nil then
                fwin:close(instance)
            end
        end
    end

    protocol_command.secret_shop_exchange.param_list = ""..(cell.index - 1).."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

function ComExchange:changeArena(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num


    local function responseArenaShopInitCallback(response)
        TipDlg.drawTextDailog(_new_interface_text[92])
        state_machine.excute("sm_shop_tab_update", 0, "sm_shop_tab_update.")

        if nil ~= fwin:find("ShopPropBuyListViewClass") then
            state_machine.excute("sm_shop_prop_buy_list_refush", 0, cell)
        end

        if nil ~= fwin:find("SecretShopClass") then
            state_machine.excute("sm_secret_shop_prop_buy_list_refush", 0, cell)
        end

        if response.node ~= nil then
            fwin:close(instance)
        end
    end

    local function callback(response)
        protocol_command.arena_shop_init.param_list = "0\r\n0"
        NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, response.node, responseArenaShopInitCallback, false, nil)
    end

    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            callback(response)
        end
    end
    protocol_command.arena_shop_exchange.param_list = ""..cell.index.."\r\n"..instance._select_num
	NetworkManager:register(protocol_command.arena_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

function ComExchange:changeGlories(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num

    local function responseGloriesShopInitCallback(response)
        TipDlg.drawTextDailog(_new_interface_text[92])
        -- _ED.glories_shop_info[tonumber(cell.index)].goods_exchange_times = tonumber(_ED.glories_shop_info[tonumber(cell.index)].goods_exchange_times) + tonumber(cell._select_num)
        state_machine.excute("sm_shop_tab_update", 0, "sm_shop_tab_update.")

        if nil ~= fwin:find("ShopPropBuyListViewClass") then
            state_machine.excute("sm_shop_prop_buy_list_refush", 0, cell)
        end

        if nil ~= fwin:find("SecretShopClass") then
            state_machine.excute("sm_secret_shop_prop_buy_list_refush", 0, cell)
        end

        if response.node ~= nil then
            fwin:close(instance)
        end
    end

    local function callback(response)
        NetworkManager:register(protocol_command.glories_shop_init.code, nil, nil, nil, self, responseGloriesShopInitCallback, false, nil)
    end

    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            callback(response)
        end
    end
    protocol_command.glories_shop_exchange.param_list = ""..cell.index.."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.glories_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

function ComExchange:changeUnion(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num

    local function responseUnionShopInitCallBack(response)
        TipDlg.drawTextDailog(_new_interface_text[92])
        state_machine.excute("sm_shop_tab_update", 0, "sm_shop_tab_update.")

        if nil ~= fwin:find("ShopPropBuyListViewClass") then
            state_machine.excute("sm_shop_prop_buy_list_refush", 0, cell)
        end

        if nil ~= fwin:find("SecretShopClass") then
            state_machine.excute("sm_secret_shop_prop_buy_list_refush", 0, cell)
        end

        if response.node ~= nil then
            fwin:close(instance)
        end
    end

    local function callback(response)
        NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, response.node, responseUnionShopInitCallBack, false, nil)
    end

    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            callback(response)
        end
    end
    protocol_command.union_shop_exchange.param_list = ""..(cell.index - 1).."\r\n".."2".."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

function ComExchange:changecCrossSeverFight(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(_new_interface_text[92])
            if response.node ~= nil then
                cell:initData()
                cell:onUpdateDraw()
                fwin:close(instance)
            end
        end
    end
    protocol_command.cross_mine_user_shop_buy.param_list = cell.id .. "\r\n" .. "2" .."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.cross_mine_user_shop_buy.code, nil, nil, nil, cell, responseBuyPropCallback, false, nil)
end
--活动-碎片兑换-批量兑换
function ComExchange:changeHalfPrice(instance,params)
    local mCell = instance.oneCell
    mCell._select_num = instance._select_num
    mCell.command_param_list = ""..tonumber(instance.id).."\r\n"..mCell.activity_id.."\r\n"..instance._select_num
    if mCell.maxcount > 1 then
        app.load("client.activity.ActivityVarietyShopForDrawSelectAward")
        fwin:open(ActivityVarietyShopForDrawSelectAward:new():init(params), fwin._dview)
    else
        local function responseExchangeCallback(response)
            if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and params.status ~= nil then
                state_machine.excute("use_diamond_confirm_tip_close",0,"")
            end
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil then
                    response.node:rewadDraw(response.node.prop.id,response.node._select_num)
                end
            end
        end
        if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
                and ___is_open_diamond_confirm == true and params.status == nil and mCell.needGolds > 0 then
            app.load("client.utils.UseDiamondConfirmTip")
            local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
            if window_terminal.unopen ~= true then
                local str1 = string.format(tipStringInfo_use_diamond[1],mCell.needGolds)
                local str2 = tipStringInfo_use_diamond[5]
                state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={instance,nil,str1.."|"..str2 ,params}})
                return
            else
                protocol_command.activity_superchange_exchange.param_list = mCell.command_param_list.."\r\n".."1"
                NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, mCell, responseExchangeCallback, false, nil)
            end
        else
            protocol_command.activity_superchange_exchange.param_list = mCell.command_param_list.."\r\n".."1"
            NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, mCell, responseExchangeCallback, false, nil)
        end
    end
end

--ID = 124活动道具批量兑换
function ComExchange:changeEmblemLimit(instance)
    local function responseExchangeCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd, fwin._ui)

            app.load("client.cells.activity.emblem_limit_time_exchange_cell")
            state_machine.excute("activity_emblem_limit_time_exchange_update_draw", 0, nil)
        end
    end
    local cell = instance.oneCell
    -- Fury: si la lista del 124 se repinto con esta ventana abierta, la celda esta liberada y sus
    -- campos dan nil; el hueco elegido sigue en self.id (prop.id = cell.index) y la actividad en _ED.
    local activity = cell.activity or _ED.active_activity[124]
    local index = tonumber(cell.index) or tonumber(instance.id)
    if activity == nil or index == nil then
        return
    end
    protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n" .. ""..tonumber(index - 1).."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)
end

-- 限时祈福批量兑换
function ComExchange:changePray(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd,fwin._ui)
            
            if nil ~= fwin:find("PrayActivityWindowClass") then
                state_machine.excute("pray_activity_window_refush_view",0,"")
            end
            if response.node ~= nil then
                fwin:close(instance)
            end
        end
    end

    protocol_command.limit_blessing_buy_prop.param_list = cell._mInfo.taskId.."\r\n"..instance._select_num
    NetworkManager:register(protocol_command.limit_blessing_buy_prop.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

-- 圣诞奇缘批量修改
function ComExchange:changeChristmasRomance(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd,fwin._ui)
            
            if nil ~= fwin:find("ChristmasRomanceShopClass") then
                state_machine.excute("christmas_romance_shop_refrush",0,"")
            end
            if response.node ~= nil then
                fwin:close(instance)
            end

        end
    end

    protocol_command.lucky_turntable_buy_prop.param_list = cell._type .. "\r\n" .. cell._infos.id .. "\r\n" .. instance._select_num
    NetworkManager:register(protocol_command.lucky_turntable_buy_prop.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

-- 限时召唤up池积分兑换
function ComExchange:changeLimSummon(instance)
    local cell = instance.oneCell
    
    local idActivity = cell.idActivity
    local indexProp = cell.indexProp
    local count = instance._select_num

    app.load("client.activity.lim_summon.LimSummonMgr")

    local function callback()
        app.load("client.reward.DrawRareReward")
        local getRewardWnd = DrawRareReward:new()
        getRewardWnd:init(7)
        fwin:open(getRewardWnd,fwin._ui)
        
        state_machine.excute("lim_summon_view_shop_refresh", 0, "")
        state_machine.excute("lim_summon_view_main_refresh_reddot", 0, "")
        LimSummonMgr:GetInstance():noticeRefreshMainReddot()

        fwin:close(instance)
    end

    LimSummonMgr:GetInstance():RequestBuy(idActivity, indexProp, count, callback)
end

-- 新招募系统商店兑换
function ComExchange:changeNewRecruit(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd,fwin._ui)
            
            if nil ~= fwin:find("NewRecruitShopClass") then
                state_machine.excute("new_recruit_shop_refresh",0,"")
                state_machine.excute("new_recruit_main_update_redDot",0,"")
            end
            if response.node ~= nil then
                fwin:close(instance)
            end

        end
    end

    protocol_command.new_recruitment_shop_buy.param_list = cell.propInfo.idx .. "\r\n" .. instance._select_num
    NetworkManager:register(protocol_command.new_recruitment_shop_buy.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

-- 建号战令商店兑换
function ComExchange:changeConstructionOrder(instance)
    local cell = instance.oneCell
    cell._select_num = instance._select_num
    local function responseBuyPropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd,fwin._ui)
            
            fwin:close(fwin:find("ConstructionOrderShopListSpecialInfoClass"))
            state_machine.excute("construction_order_shop_view_refresh",0,"")
            if response.node ~= nil then
                fwin:close(instance)
            end

        end
    end
    -- print(cell.shopType, "+===cell.shopType", cell.productID, "====cell.index", instance._select_num)
    protocol_command.user_build_war_order_buy.param_list = cell.shopType .. "\r\n" .. cell.productID .. "\r\n" .. instance._select_num
    NetworkManager:register(protocol_command.user_build_war_order_buy.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
end

function ComExchange:updateOperationBtn()
    local maxSelectNums = self._max_select_num
    local curSelectNums = self._select_num
    local function operationCallbcak(changeNums, isLongPress, trigger)
        -- 如果选中数值有修改
        if changeNums ~= nil then
            local haveCount = self._select_num + changeNums
            if haveCount >= 1 and haveCount <= maxSelectNums then
                -- 刷新进度条
                self._select_num = haveCount
                local percent = math.floor(self._select_num / maxSelectNums*100)
                self:updateSliderInfo(percent)
            end
            if isLongPress then
                if self._select_num <= 1 or self._select_num >= maxSelectNums then
                    trigger:stopAllActions()
                end
            end
        else
            -- 如果没修改则返回当前选择的数量和最大选择数量
            return self._select_num, self._max_select_num
        end
    end
    BatchUseBtnRegisterTouchEvent(self.Button_1, self.ADDOPERATIONNUM, operationCallbcak)
    BatchUseBtnRegisterTouchEvent(self.Button_2, self.REDUCEOPERATIONNUM, operationCallbcak)
end

function ComExchange:init(params)
    local cell = params
    self.prop = cell.prop
    self.id = cell.prop.id
    self.oneCell = cell
    self.formCell = cell.form_cell
    self:onInit()
    return self
end

function ComExchange:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end
    local percent = math.floor(self._select_num / self._max_select_num*100)
    self:updateSliderInfo(percent)
end

function ComExchange:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
    
    self._current_silder = percent

    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1
    end
    Slider_number_xz:setPercent(self._current_silder)
    --数量
    local Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")
    Text_packs_use_n:setString(self._select_num.."/"..self.prop.prop_number)

end

function ComExchange:onInit()
    local csbItem = csb.createNode("packs/sm_warehouse_batch_use.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "com_exchange_use_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    --设置最小
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_min"), nil, 
    {
        terminal_name = "com_exchange_use_set_min", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    --设置最大
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_max"), nil, 
    {
        terminal_name = "com_exchange_use_set_max", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    local Button_use = ccui.Helper:seekWidgetByName(root,"Button_use")
    --兑换道具
    fwin:addTouchEventListener( Button_use, nil,
    {
        terminal_name = "com_exchange_is_use", 
        terminal_state = 0, 
        touch_black = true,

    }, nil, 0)

    local Image_up_quality = ccui.Helper:seekWidgetByName(root, "Image_up_quality")
    local Image_buy = ccui.Helper:seekWidgetByName(root, "Image_buy")
    local Image_change = ccui.Helper:seekWidgetByName(root, "Image_change")
    local Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")
    local Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
    local Text_packs_use = ccui.Helper:seekWidgetByName(root, "Text_packs_use")
    if self.formCell == "sm_total_war_exchange_list_cell" then
        Image_buy:setVisible(true)
        Image_up_quality:setVisible(false)
        Image_change:setVisible(false)
        Text_title:setVisible(false)
        Text_title_1:setVisible(true)
        Text_packs_use:setString(_new_interface_text[324]..":")
    else
        Image_buy:setVisible(false)
        Image_up_quality:setVisible(false)
        Image_change:setVisible(true)
        Text_title:setVisible(true)
        Text_title_1:setVisible(false)
        Text_title:setString(_new_interface_text[318].._new_interface_text[319])
        Text_packs_use:setString(_new_interface_text[319]..":")
    end
    local quality = zstring.tonumber(self.prop.prop_quality)
    --头像
    local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
    Panel_packs_props_icon:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    local propType = tonumber(self.prop.type)
    if propType == 7 then
        cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id), nil, nil, nil, true, nil, {equipQuality = quality})
    elseif propType == 13 then
        cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id), nil, nil, nil, true, nil, {shipStar = quality})
    else
        cell:init(tonumber(self.prop.type), 0, tonumber(self.prop.mould_id), nil, nil, nil, true)
    end
    Panel_packs_props_icon:addChild(cell)
    Panel_packs_props_icon:setVisible(true)
    Panel_packs_props_icon:setTouchEnabled(false)
     --名称
    local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
    local name = self.prop.mould_name
    Text_packs_props_name:setString(name)
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital and dark_text_color then
        Text_packs_props_name:setColor(cc.c3b(dark_text_color[quality+1][1], dark_text_color[quality+1][2], dark_text_color[quality+1][3]))
    else
        Text_packs_props_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
    end

    --计算最大值
    self._max_select_num = self.prop.prop_number
    
    -- local Slider_buy_num
    -- 滑动选择
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("com_exchange_use_update", 0, {sender:getPercent()})
        end
    end
    Slider_number_xz:addEventListener(percentChangedEvent)
    
    self:setSelectNum(self._max_select_num)

    -- 减少按钮
    self.Button_2 = ccui.Helper:seekWidgetByName(root,"Button_2")
    -- 逐渐增加按钮
    self.Button_1 = ccui.Helper:seekWidgetByName(root,"Button_1")

    if self.Button_1 ~= nil and self.Button_2 ~= nil then
        self:updateOperationBtn()
    end
end

function ComExchange:onEnterTransitionFinish()
    
end


function ComExchange:onExit()
    state_machine.remove("com_exchange_use_set_min")
    state_machine.remove("com_exchange_use_set_max")
    state_machine.remove("com_exchange_use_update")
    state_machine.remove("com_exchange_is_use")
end

