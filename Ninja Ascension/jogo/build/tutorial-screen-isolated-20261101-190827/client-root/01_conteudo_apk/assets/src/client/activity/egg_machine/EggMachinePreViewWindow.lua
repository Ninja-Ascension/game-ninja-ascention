EggMachinePreViewWindow = class("EggMachinePreViewWindowClass", Window)

local egg_machine_preview_preview_window_terminal = {
	_name = "egg_machine_preview_preview_window",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("EggMachinePreViewWindowClass") == nil then
			fwin:open(EggMachinePreViewWindow:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local egg_machine_preview_window_close_terminal = {
	_name = "egg_machine_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggMachinePreViewWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_machine_preview_preview_window_terminal)
state_machine.add(egg_machine_preview_window_close_terminal)
state_machine.init()

function EggMachinePreViewWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self._current_page = 0
	self._page_table = {}
	self._rewards = {}

    -- 加载lua文件
    app.load("client.l_digital.shop.SmRecruitPreviewWindowTab")
    app.load("client.activity.egg_machine.EggMachinePreViewList")

    local function init_egg_machine_preview_window_terminal()
        local egg_machine_preview_window_tab_terminal = {
            _name = "egg_machine_preview_window_tab",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local activity = _ED.active_activity[154]
                if activity == nil then
                    return
                end
                instance:onUpdateDraw(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(egg_machine_preview_window_tab_terminal)
        state_machine.init()
    end
    init_egg_machine_preview_window_terminal()
end

function EggMachinePreViewWindow:onUpdateDraw(page)
    local root = self.roots[1]
    local activity_info = _ED.active_activity[154]
    local activityParam = json.decode(activity_info.activity_params)

    if page == self._current_page then
        return
    end
    self._current_page = page

    for i = 7, 8 do
        local Button_tab = ccui.Helper:seekWidgetByName(root, "Button_tab_" .. i)
        if i == page then
            Button_tab:setTouchEnabled(false)
            Button_tab:setHighlighted(true)
        else
            Button_tab:setTouchEnabled(true)
            Button_tab:setHighlighted(false)
        end
    end

    local Panel_yulan = ccui.Helper:seekWidgetByName(root, "Panel_yulan")
    for k, v in pairs(self._page_table) do
        state_machine.excute("egg_machine_preview_list_hide", 0, v)
    end

    if self._page_table[""..page] == nil then
        self._page_table[""..page] = state_machine.excute("egg_machine_preview_list_open", 0, {Panel_yulan, 1, page, self._rewards[page .. ""]})

    else
        state_machine.excute("egg_machine_preview_list_show", 0, self._page_table[""..page])
    end
end

function EggMachinePreViewWindow:getRewords()
	local activity_info = _ED.active_activity[154]
    local activityParam = json.decode(activity_info.activity_params)
    local rewardsProp = zstring.splits(activityParam.detailProp, "~", ",")
    local rewardsEquip = zstring.splits(activityParam.detailEquip, "~", ",")
    -- Pestanas como SmRecruitPreviewWindow y como el arte de la maqueta: 7 = equipo («Weapon Soul»),
    -- 8 = objetos («Item Reward»). Una lista vacia viaja como "0" y zstring.splits nunca da cero
    -- piezas: ese tipo 0 es el hueco, no un premio, y no se pinta (casilla gris sin nombre).
    self._rewards[7 .. ""] = {}
    self._rewards[8 .. ""] = {}
    for page, rewards in pairs({["8"] = rewardsProp, ["7"] = rewardsEquip}) do
        for i, reward in ipairs(rewards) do
            local rewardType = zstring.tonumber(reward[1]) or 0
            if rewardType > 0 then
                table.insert(self._rewards[page], {order = 0, tag = -1, prop_type = rewardType,
                    mould_id = zstring.tonumber(reward[2]), sign = 9})
            end
        end
    end
end

function EggMachinePreViewWindow:onUpdate(dt)
end

function EggMachinePreViewWindow:init(params)
	self:onInit()
    return self
end

function EggMachinePreViewWindow:onInit()
    local csbItem = csb.createNode("shop/sm_recruit_preview_window.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    -- local action = csb.createTimeline("activity/wonderful/sm_vip_chouka.csb")
   	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "egg_machine_preview_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    for i = 1, 6 do
    	local btn = ccui.Helper:seekWidgetByName(root,"Button_tab_" .. i)
    	btn:setVisible(false)
    end
    
    self:getRewords()
    -- Solo las pestanas con premios, de arriba abajo en los huecos de la 7 y la 8: objetos (8)
    -- primero, equipo (7) despues. Se abre la primera.
    local huecos = {ccui.Helper:seekWidgetByName(root, "Button_tab_7"):getPositionY(),
        ccui.Helper:seekWidgetByName(root, "Button_tab_8"):getPositionY()}
    local primera = nil
    for _, i in ipairs({8, 7}) do
        local btn = ccui.Helper:seekWidgetByName(root, "Button_tab_" .. i)
        btn:setVisible(#self._rewards[i .. ""] > 0)
        if btn:isVisible() then
            btn:setPositionY(huecos[primera == nil and 1 or 2])
            primera = primera or i
            fwin:addTouchEventListener(btn, nil,
            {
                terminal_name = "egg_machine_preview_window_tab",
                terminal_state = 0,
                touch_black = true,
                index = i,
            },
            nil,1)
        end
    end
    self:onUpdateDraw(primera or 8)
end

function EggMachinePreViewWindow:onEnterTransitionFinish()
end

function EggMachinePreViewWindow:onExit()
	state_machine.remove("egg_machine_preview_window_update_draw")
	state_machine.remove("egg_machine_preview_window_recruiting")
end

