MagicCardTrupList = class("MagicCardTrupListClass", Window)

function MagicCardTrupList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.selectedIndex = 0
	self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    self._empty = nil

    local magic_card_trup_update_terminal = {
        _name = "magic_card_trup_update",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

     --需要删除列表中的卡片刷新
    local magic_card_trup_remove_card_update_terminal = {
        _name = "magic_card_trup_remove_card_update",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if instance ~= nil and instance.roots ~= nil and instance.currentListView ~= nil then
                instance:removeConsumeMagicCards()
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(magic_card_main_close_button_terminal)
    state_machine.add(magic_card_trup_remove_card_update_terminal)
    state_machine.init()
end

function MagicCardTrupList:init()
	return self
end

--删除消耗卡牌
function MagicCardTrupList:removeConsumeMagicCards()
    if _ED.magic_card_remove_ids ~= nil and _ED.magic_card_remove_ids ~= "" then 
        --需要开始删除了
        local removeCards = zstring.split("".. _ED.magic_card_remove_ids,",")  
        if removeCards ~= nil and self.currentListView ~= nil then 
            for i,v in pairs(removeCards) do
                self:removeItemForId(zstring.tonumber(v))
            end
            self:onUpdateDrawMagicListCounts()
        end
    end
end

--从列表中删除单个Item
function MagicCardTrupList:removeItemForId(removeId)
    if self.currentListView ~= nil then 
        local items = self.currentListView:getItems()
        for i,v in pairs(items) do
            if v.cardId == removeId then 
                local cell = self.currentListView:getItem(i-1)
                self.currentListView:removeItem(i-1)
                break
            end
        end
    end
end

function MagicCardTrupList:onUpdate( dt )
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

function MagicCardTrupList:onUpdateDraw( ... )
    local root = self.roots[1]
	if root == nil then
		return
	end

    if self._empty ~= nil then
        self._empty:removeFromParent(true)
        self._empty = nil
    end

	self.asyncIndex = 1
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    if #self.currentListView:getItems() > 0 then
        self.currentListView:removeAllItems()
    end

    local isEmpty = true
    if _ED.user_magic_trap_info ~= nil then 
        for k,prop in pairs(_ED.user_magic_trap_info) do
            local cardType = dms.int(dms["magic_trap_card_info"],prop.base_mould,magic_trap_card_info.card_type)
            if cardType == 1  then 
                isEmpty = false
                local cell = MagicTrupCardCell:CreateCell():init(self.asyncIndex, 2, prop,false)
                cell.cardId = zstring.tonumber(prop.id)
                self.currentListView:addChild(cell)
                self.currentListView:requestRefreshView()
                self.asyncIndex = self.asyncIndex + 1
            end
        end
    end
    
    if isEmpty == true then
        local cell = StorageDialog:createCell()
        cell:init(6)
        self:addChild(cell)
        self._empty = cell
    end

    ccui.Helper:seekWidgetByName(root, "Panel_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Panel_m"):setVisible(false) 
    local Label_shuliang1 = ccui.Helper:seekWidgetByName(root, "Label_5075")
    local config = zstring.split(dms.string(dms["pirates_config"], 6, pirates_config.param), ",")
    Label_shuliang1:setString("".. self.asyncIndex -1 .. "/" .. config[8])
    self.currentListView:jumpToTop()
end

function MagicCardTrupList:onUpdateDrawMagicListCounts()
    if self.currentListView ~= nil then 
        local itmes = self.currentListView:getItems()
        local Label_shuliang1 = ccui.Helper:seekWidgetByName(self.roots[1], "Label_5075")
        local config = zstring.split(dms.string(dms["pirates_config"], 6, pirates_config.param), ",")
        Label_shuliang1:setString("".. #itmes .. "/" .. config[8])     
    end
end

function MagicCardTrupList:onEnterTransitionFinish()
    local csbTrupCard = csb.createNode("packs/magic_card_listview.csb")
    local root = csbTrupCard:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbTrupCard)
    self.currentListView = ccui.Helper:seekWidgetByName(root, "ListView_1")

    self:onUpdateDraw()
end

function MagicCardTrupList:onExit()
end
