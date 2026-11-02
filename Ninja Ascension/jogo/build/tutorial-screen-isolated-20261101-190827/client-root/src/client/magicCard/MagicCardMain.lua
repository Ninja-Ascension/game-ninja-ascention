MagicCardMain = class("MagicCardMainClass", Window)

local magic_card_main_open_terminal = {
	_name = "magic_card_main_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local MagicCardMainWindow = fwin:find("MagicCardMainClass")
		if MagicCardMainWindow ~= nil and MagicCardMainWindow:isVisible() == true then
			return true
		end
        state_machine.lock("magic_card_main_open")
		fwin:open(MagicCardMain:new():init(params), fwin._windows)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local magic_card_main_close_terminal = {
	_name = "magic_card_main_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local MagicCardMainWindow = fwin:find("MagicCardMainClass")
		if MagicCardMainWindow ~= nil then
			fwin:close(MagicCardMainWindow)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(magic_card_main_open_terminal)
state_machine.add(magic_card_main_close_terminal)
state_machine.init()

function MagicCardMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.selectedIndex = 0
	self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.magicCard.MagicCardListCell")

    local magic_card_main_close_button_terminal = {
        _name = "magic_card_main_close_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            state_machine.excute("magic_card_main_close", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(magic_card_main_close_button_terminal)
    state_machine.init()
end

function MagicCardMain:init(params)
	self.selectedIndex = params
	return self
end

function MagicCardMain:onUpdate( dt )
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function MagicCardMain:onUpdateDraw( ... )
    local root = self.roots[1]
	if root == nil then
		return
	end

	self.asyncIndex = 1
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    if #self.currentListView:getItems() > 0 then
        self.currentListView:removeAllItems()
    end

    local formations = {}
    if _ED.trapCardInfo ~= nil and _ED.trapCardInfo ~= "" then
        formations = zstring.split(_ED.trapCardInfo, ",")
    end
    --魔陷卡上阵数据
    local trapList = {}
    local baseMoulds = {}
    for i,v in pairs(formations) do
        if v ~= nil and v ~= "" and zstring.tonumber(v) > 0 then 
            trapList[zstring.tonumber(v)] = 1
            local cardInfo = fundMagicCardWithId(v)
            local mouldId = dms.int(dms["magic_trap_card_info"],cardInfo.base_mould,magic_trap_card_info.base_mould)
            table.insert(baseMoulds,mouldId)
        end
    end
    if _ED.user_magic_trap_info ~= nil then 
        for i, prop in pairs(_ED.user_magic_trap_info) do
            if trapList[zstring.tonumber(prop.id)] == nil then 
                local cardType = dms.int(dms["magic_trap_card_info"],prop.base_mould,magic_trap_card_info.card_type)
                local baseMould = dms.int(dms["magic_trap_card_info"],prop.base_mould,magic_trap_card_info.base_mould)
                if cardType ~= nil and cardType == 1 then 
                    local sameType = false
                    for i,v in pairs(baseMoulds) do
                        if v == baseMould then 
                            sameType = true 
                            break
                        end
                    end
                    if sameType == false then 
                        local cell = MagicCardListCell:CreateCell():init(self.asyncIndex, self.selectedIndex, prop)
                        self.currentListView:addChild(cell)
                        self.currentListView:requestRefreshView()
                        self.asyncIndex = self.asyncIndex + 1
                    end
                end
    	    end    
        end
    end
    self.currentListView:jumpToTop()
end

function MagicCardMain:onEnterTransitionFinish()
    local csbMagicCard = csb.createNode("packs/HeroStorage/xianjinka_Choice.csb")
    local root = csbMagicCard:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMagicCard)
    self.currentListView = ccui.Helper:seekWidgetByName(root, "ListView_list")

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fanhui_lwj"), nil, 
    {
        terminal_name = "magic_card_main_close_button",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    self:onUpdateDraw()
    state_machine.unlock("magic_card_main_open")
end

function MagicCardMain:onExit()
	state_machine.remove("magic_card_main_close_button")
end
