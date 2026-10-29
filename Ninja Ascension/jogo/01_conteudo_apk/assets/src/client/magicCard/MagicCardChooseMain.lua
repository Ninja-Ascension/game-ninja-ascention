MagicCardChooseMain = class("MagicCardChooseMainClass", Window)

local magic_card_main_choose_open_terminal = {
	_name = "magic_card_main_choose_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local MagicCardChooseMainWindow = fwin:find("MagicCardChooseMainClass")
		if MagicCardChooseMainWindow ~= nil and MagicCardChooseMainWindow:isVisible() == true then
			return true
		end
        state_machine.lock("magic_card_main_choose_open")
		fwin:open(MagicCardChooseMain:new():init(params), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local magic_card_main_choose_close_terminal = {
	_name = "magic_card_main_choose_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:cleanView(fwin._view)
        if fwin:find("HomeClass") == nil then
            state_machine.excute("menu_manager", 0, 
                {
                    _datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_show_home_page", 
                        current_button_name = "Button_home",
                        but_image = "Image_home",       
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                }
            )
        end
        state_machine.excute("menu_back_home_page", 0, "")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(magic_card_main_choose_open_terminal)
state_machine.add(magic_card_main_choose_close_terminal)
state_machine.init()

function MagicCardChooseMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.chooseIndex = 1
    self.group = {}

    app.load("client.magicCard.MagicCardMagicList")
    app.load("client.magicCard.MagicCardTrupList")
    app.load("client.magicCard.MagicTrupCardCell")
    app.load("client.utils.StorageDialog")

    local magic_card_main_choose_close_button_terminal = {
        _name = "magic_card_main_choose_close_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            for i, v in pairs(instance.group) do
                if v ~= nil then
                    fwin:close(v)
                end
            end
            if fwin:find("UserInformationHeroStorageClass") ~= nil then
                fwin:close(fwin:find("UserInformationHeroStorageClass"))
            end
            fwin:close(self)
            state_machine.excute("magic_card_main_choose_close", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local magic_card_main_choose_sell_button_terminal = {
        _name = "magic_card_main_choose_sell_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            app.load("client.magicCard.MagicCardSell")
            fwin:open(MagicCardSell:new():init(instance.chooseIndex),fwin._dialog)
            
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --出售成功后刷新列表
    local magic_card_main_choose_sell_ok_update_terminal = {
        _name = "magic_card_main_choose_sell_ok_update",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            instance:updateListCell(params)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local magic_card_main_choose_magic_button_terminal = {
        _name = "magic_card_main_choose_magic_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            instance:changeSelect(0)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local magic_card_main_choose_trup_button_terminal = {
        _name = "magic_card_main_choose_trup_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            instance:changeSelect(1)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(magic_card_main_choose_close_button_terminal)
    state_machine.add(magic_card_main_choose_sell_button_terminal)
    state_machine.add(magic_card_main_choose_magic_button_terminal)
    state_machine.add(magic_card_main_choose_trup_button_terminal)
    state_machine.add(magic_card_main_choose_sell_ok_update_terminal)
    state_machine.init()
end

function MagicCardChooseMain:changeSelect( selectIndex )

    local root = self.roots[1]
    local Button_magic = ccui.Helper:seekWidgetByName(root, "Button_magic")
    local Button_turp = ccui.Helper:seekWidgetByName(root, "Button_turp")
    if selectIndex == 0 then
        Button_magic:setHighlighted(true)
        Button_turp:setHighlighted(false)
    else
        Button_magic:setHighlighted(false)
        Button_turp:setHighlighted(true)
    end
    if self.chooseIndex == selectIndex then
        return
    end
    self.chooseIndex = selectIndex
    if self.chooseIndex == 0 then
        if self.group.magicList == nil then
            self.group.magicList = MagicCardMagicList:new():init()
            fwin:open(self.group.magicList, fwin._background)
        else
            self.group.magicList:setVisible(true)
        end
        if self.group.trupList ~= nil then
            self.group.trupList:setVisible(false)
        end
    else
        if self.group.trupList == nil then
            self.group.trupList = MagicCardTrupList:new():init()
            fwin:open(self.group.trupList, fwin._background)
        else
            self.group.trupList:setVisible(true)
        end
        if self.group.magicList ~= nil then
            self.group.magicList:setVisible(false)
        end
    end
end

function MagicCardChooseMain:updateListCell(index)
    if index == 2 then 
        --魔法卡
        if self.group.magicList ~= nil then 
            self.group.magicList:onUpdateDraw()
        end
    else
        --陷阱卡
        if self.group.trupList ~= nil then 
            self.group.trupList:onUpdateDraw()
        end

    end
end

function MagicCardChooseMain:init()
	return self
end

function MagicCardChooseMain:onEnterTransitionFinish()
    local csbMagicChooseCard = csb.createNode("packs/magic_card_list.csb")
    local root = csbMagicChooseCard:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMagicChooseCard)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sell"), nil, 
    {
        terminal_name = "magic_card_main_choose_sell_button",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "magic_card_main_choose_close_button",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_magic"), nil, 
    {
        terminal_name = "magic_card_main_choose_magic_button",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_turp"), nil, 
    {
        terminal_name = "magic_card_main_choose_trup_button",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    app.load("client.player.UserInformationHeroStorage")
    fwin:open(UserInformationHeroStorage:new(), fwin._ui)

    self:changeSelect(0)
    state_machine.unlock("magic_card_main_choose_open")
end

function MagicCardChooseMain:onExit()
	state_machine.remove("magic_card_main_choose_close_button")
    state_machine.remove("magic_card_main_choose_sell_button")
    state_machine.remove("magic_card_main_choose_magic_button")
    state_machine.remove("magic_card_main_choose_trup_button")
end
