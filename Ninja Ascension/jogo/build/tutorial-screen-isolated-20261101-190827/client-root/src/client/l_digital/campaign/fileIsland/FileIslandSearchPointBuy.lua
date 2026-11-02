-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛购买探索点
-------------------------------------------------------------------------------------------------------
FileIslandSearchPointBuy = class("FileIslandSearchPointBuyClass", Window)

local FileIslandSearchPointBuy_open_terminal = {
    _name = "FileIslandSearchPointBuy_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("FileIslandSearchPointBuyClass")
        if nil == _homeWindow then
            local panel = FileIslandSearchPointBuy:new():init(params)
            fwin:open(panel, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(FileIslandSearchPointBuy_open_terminal)
state_machine.init()
    
function FileIslandSearchPointBuy:ctor()
    self.roots = {}
    app.load("client.shop.recharge.RechargeDialog")
    local FileIslandSearchPointBuy_close_terminal = {
        _name = "FileIslandSearchPointBuy_close",
        _init = function (terminal) 
        
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local _homeWindow = fwin:find("FileIslandSearchPointBuyClass")
            if nil ~= _homeWindow then
                fwin:close(fwin:find("FileIslandSearchPointBuyClass"))
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local FileIslandSearchPointBuy_recharge_terminal = {
        _name = "FileIslandSearchPointBuy_recharge",
        _init = function (terminal) 
        
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            state_machine.excute("recharge_dialog_window_open", 0, 0)
            local _homeWindow = fwin:find("FileIslandSearchPointBuyClass")
            if nil ~= _homeWindow then
                fwin:close(fwin:find("FileIslandSearchPointBuyClass"))
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    

    local FileIslandSearchPointBuy_buy_terminal = {
        _name = "FileIslandSearchPointBuy_buy",
        _init = function (terminal) 
        
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 刷新探索点和计时
                        state_machine.excute("exploration_window_onUpdateDraw", 0, "") 

                        local node = params._datas.node
                        node:onUpdateDraw()
                    end
                end
                protocol_command.pokemon_explore_search_point_buy.param_list = ""
                NetworkManager:register(protocol_command.pokemon_explore_search_point_buy.code, nil, nil, nil, nil, callback, false, nil)
            else
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 刷新探索点和计时
                        state_machine.excute("fileIsland_window_onUpdateDraw", 0, "") 

                        local node = params._datas.node
                        node:onUpdateDraw()
                    end
                end
                protocol_command.fileIslandSearchPointBuy.param_list = ""
                NetworkManager:register(protocol_command.fileIslandSearchPointBuy.code, nil, nil, nil, nil, callback, false, nil)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(FileIslandSearchPointBuy_close_terminal)
    state_machine.add(FileIslandSearchPointBuy_buy_terminal)
    state_machine.add(FileIslandSearchPointBuy_recharge_terminal)
    state_machine.init()

end

function FileIslandSearchPointBuy:onUpdateDraw()

    local root = self.roots[1]
    if root == nil then 
        return
    end

    if _ED.fileIsland == nil then
        return
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if _ED.pokemonExplore == nil then
            return
        end
    end 

    local numbers = dms.element(dms["base_consume"], 68)
    local nCount = dms.atoi(numbers, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    local consumeList = zstring.split(dms.string(dms["play_config"], 87, play_config.param), ",")
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        consumeList = zstring.split(dms.string(dms["play_config"], 115, play_config.param), ",")
    end
    local todayBuyTimes = _ED.fileIsland.todayBuyTimes
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        todayBuyTimes = _ED.pokemonExplore.todayBuyTimes
    end
    if todayBuyTimes < nCount then
        self.Panel_eplore_buy:setVisible(true)
        self.Panel_eplore_buy_top:setVisible(false)
        self.Panel_eplore_buy_not_p:setVisible(false)
        self.Text_eplore_buy_n_1:setString(todayBuyTimes .. "/" .. nCount)
        self.Text_eplore_buy_n_2:setString(consumeList[todayBuyTimes + 1])
    else
        self.Panel_eplore_buy:setVisible(false)
    
        if tonumber(_ED.vip_grade) == 18 then
            self.Panel_eplore_buy_top:setVisible(true)
            self.Panel_eplore_buy_not_p:setVisible(false)
        else
            self.Panel_eplore_buy_top:setVisible(false)
            self.Panel_eplore_buy_not_p:setVisible(true)
        end

    end

end

function FileIslandSearchPointBuy:init(params)
    self.data = params or {}
    self:onInit()
    return self
end

function FileIslandSearchPointBuy:onInit()
    local node = csb.createNode("campaign/explore/explore_buy_dia.csb")
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        node = nil
        node = csb.createNode("campaign/exploration/exploration_buy_dia.csb")
    end
    local root = node:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(node)


    self.Panel_eplore_buy = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_eplore_buy")
    -- 已经购买次数
    self.Text_eplore_buy_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_eplore_buy_n_1")
    -- 需要消耗的钻石
    self.Text_eplore_buy_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_eplore_buy_n_2")

    self.Panel_eplore_buy_top = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_eplore_buy_top")

    self.Panel_eplore_buy_not_p = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_eplore_buy_not_p")
	
    self:onUpdateDraw()

    -- 购买
    local Button_eplore_buy = ccui.Helper:seekWidgetByName(self.roots[1], "Button_eplore_buy")
    fwin:addTouchEventListener(Button_eplore_buy, nil, 
    {
        terminal_name = "FileIslandSearchPointBuy_buy", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        node = self,
    }, 
    nil, 0)

    -- 确定
    local Button_eplore_buy_top = ccui.Helper:seekWidgetByName(self.roots[1], "Button_eplore_buy_top")
    fwin:addTouchEventListener(Button_eplore_buy_top, nil, 
    {   
        terminal_name = "FileIslandSearchPointBuy_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        node = self,
    }, 
    nil, 0)

    local Button_eplore_queding = ccui.Helper:seekWidgetByName(self.roots[1], "Button_eplore_queding")
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        fwin:addTouchEventListener(Button_eplore_queding, nil, 
        {
            terminal_name = "FileIslandSearchPointBuy_recharge", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            node = self,
        }, 
        nil, 0)
    else
        fwin:addTouchEventListener(Button_eplore_queding, nil, 
        {
            terminal_name = "FileIslandSearchPointBuy_close", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            node = self,
        }, 
        nil, 0)
    end

    local Button_eplore_buy_close = ccui.Helper:seekWidgetByName(self.roots[1], "Button_eplore_buy_close")
    fwin:addTouchEventListener(Button_eplore_buy_close, nil, 
    {
        terminal_name = "FileIslandSearchPointBuy_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        node = self,
    }, 
    nil, 0)
	
end

function FileIslandSearchPointBuy:onExit()
    state_machine.remove("FileIslandSearchPointBuy_close") 
    state_machine.remove("FileIslandSearchPointBuy_buy")
end