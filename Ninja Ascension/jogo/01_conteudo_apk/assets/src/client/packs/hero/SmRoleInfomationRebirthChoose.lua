-----------------------------
-- 
SmRoleInfomationRebirthChoose = class("SmRoleInfomationRebirthChooseClass", Window)

local sm_role_infomation_rebirth_choose_window_open_terminal = {
	_name = "sm_role_infomation_rebirth_choose_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRoleInfomationRebirthChooseClass") == nil then
			fwin:open(SmRoleInfomationRebirthChoose:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_role_infomation_rebirth_choose_window_close_terminal = {
	_name = "sm_role_infomation_rebirth_choose_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRoleInfomationRebirthChooseClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_role_infomation_rebirth_choose_window_open_terminal)
state_machine.add(sm_role_infomation_rebirth_choose_window_close_terminal)
state_machine.init()

function SmRoleInfomationRebirthChoose:ctor()
	self.super:ctor()
	self.roots = {}

    self._choose_ship = nil

    app.load("client.cells.utils.multiple_list_view_cell")
    app.load("client.cells.ship.hero_formation_wear_list_cell")
end

function SmRoleInfomationRebirthChoose:onUpdateDraw()
    local root = self.roots[1]
    local listview = ccui.Helper:seekWidgetByName(root, "ListView_tab")
    listview:removeAllItems()

    local result = {}
    for i,v in pairs(_ED.user_ship) do
        if v ~= self._choose_ship then
            table.insert(result, v)
        end
    end
    local function sortFunction(a, b)
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortFunction)

    local preMultipleCell = nil
    local multipleCell = nil
    for i,v in pairs(result) do
        local cell = HeroFormationWearListCell:createCell()
        cell:init(v, cell.enum_type._THE_REBIRTH_CHOOSE, 0, i)
        -- table.insert(self.roots, cell.roots[1])
        if multipleCell == nil then
            multipleCell = MultipleListViewCell:createCell()
            multipleCell:init(listview, HeroFormationWearListCell.__size)
            listview:addChild(multipleCell)
            multipleCell.prev = preMultipleCell
            if preMultipleCell ~= nil then
                preMultipleCell.next = multipleCell
            end
        end
        multipleCell:addNode(cell)
        if multipleCell.child2 ~= nil then
            preMultipleCell = multipleCell
            multipleCell = nil
        end
    end
    listview:requestRefreshView()
    self.currentListView = listview
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function SmRoleInfomationRebirthChoose:onUpdate(dt)
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
            if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmRoleInfomationRebirthChoose:init(params)
    self._choose_ship = params[1]
	self:onInit()
    return self
end

function SmRoleInfomationRebirthChoose:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/generals_rebirth_choice.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fanhui_lwj"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_choose_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

	self:onUpdateDraw()
end

function SmRoleInfomationRebirthChoose:onEnterTransitionFinish()
end

function SmRoleInfomationRebirthChoose:onExit()
end
