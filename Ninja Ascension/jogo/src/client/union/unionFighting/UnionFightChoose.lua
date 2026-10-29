UnionFightChoose = class("UnionFightChooseClass", Window)

local union_fight_choose_open_terminal = {
	_name = "union_fight_choose_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightChooseClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        state_machine.lock("union_fight_choose_open")
		fwin:open(UnionFightChoose:new():init(params), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fight_choose_close_terminal = {
	_name = "union_fight_choose_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightChooseClass")
		if window ~= nil then
			fwin:close(window)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fight_choose_open_terminal)
state_machine.add(union_fight_choose_close_terminal)
state_machine.init()

function UnionFightChoose:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.selectRole = nil
	self.mapIndex = 0
	self.chooseCamp = 0
	self.formationIndex = 0
	self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    local function init_union_fight_choose_terminal()
		local union_fight_choose_return_terminal = {
            _name = "union_fight_choose_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fight_choose_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_choose_update_terminal = {
            _name = "union_fight_choose_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                	instance:updateRoleInfo(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_fight_choose_return_terminal)
		state_machine.add(union_fight_choose_update_terminal)
        state_machine.init()
    end
	
    init_union_fight_choose_terminal()
end

function UnionFightChoose:updateRoleInfo( selectRole )
	if self.currentListView ~= nil then
		local items = self.currentListView:getItems()
		for k,v in pairs(items) do
			if tonumber(v.roleInfo.userId) == tonumber(selectRole.userId) then
				v:updateDraw()
			end
		end
	end
end

function UnionFightChoose:updateDraw()
	local root = self.roots[1]
	if root == nil or _ED.union_fight_member_list == nil then
		return
	end

	self.asyncIndex = 1
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    if #self.currentListView:getItems() > 0 then
        self.currentListView:removeAllItems()
    end

    local mapData = dms.element(dms["union_fight_campsite_mould"], self.mapIndex)
    local campsite_index = dms.atos(mapData, union_fight_campsite_mould.campsite_index)        
    local currentCount = 0
    local totalCount = table.nums(_ED.union_fight_member_list)
    
    for i=1,table.nums(_ED.union_fight_member_list) do
        local infoData = _ED.union_fight_member_list[i]
        local cell = UnionFightChooseCell:createCell():init(infoData, self.asyncIndex, self.mapIndex, self.formationIndex, self.chooseCamp, self.selectRole)

        self.currentListView:addChild(cell)
        self.currentListView:requestRefreshView()
        self.asyncIndex = self.asyncIndex + 1

        if infoData ~= nil then
	        local roleId = infoData.userMapIndexs[tonumber(campsite_index)]
	        if roleId ~= nil and tonumber(roleId) ~= nil and tonumber(roleId) ~= 0 then
	        	currentCount = currentCount + 1
	        end
	    end
    end

    self.currentListView:jumpToTop()

    ccui.Helper:seekWidgetByName(root, "Text_chanzan"):setString(currentCount.."/"..totalCount)
    ccui.Helper:seekWidgetByName(root, "Text_legion_name_1"):setString(_ED.union.union_info.union_name)
end

function UnionFightChoose:onUpdate( dt )
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

function UnionFightChoose:onInit()
	local csbUnion = csb.createNode("legion/legion_pve_line.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    self.currentListView = ccui.Helper:seekWidgetByName(root, "ListView_line")

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_fight_choose_return",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        	if response.node ~= nil and response.node.roots ~= nil then
				response.node:updateDraw()
			end
        end
    end
    if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
        protocol_command.unino_formation_menber_list.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
        NetworkManager:register(protocol_command.unino_formation_menber_list.code, _ED.union_fight_url, nil, nil, self, responseCallback, false, nil)
    end

    state_machine.unlock("union_fight_choose_open")
end

function UnionFightChoose:onEnterTransitionFinish()
end

function UnionFightChoose:init(params)
	self.mapIndex = params[1]
	self.selectRole = params[2]
	self.chooseCamp = params[3]
	self.formationIndex = params[4]
	self:onInit()
	return self
end

function UnionFightChoose:onExit()
	state_machine.remove("union_fight_choose_return")
	state_machine.remove("union_fight_choose_update")
end
