-- ----------------------------------------------------------------------------------------------------
-- 说明：公会工会副本会员进度
-------------------------------------------------------------------------------------------------------
SmUnionMembershipProgress = class("SmUnionMembershipProgressClass", Window)

local sm_union_membership_progress_open_terminal = {
    _name = "sm_union_membership_progress_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionMembershipProgressClass")
        if nil == _homeWindow then
            local panel = SmUnionMembershipProgress:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_membership_progress_close_terminal = {
    _name = "sm_union_membership_progress_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionMembershipProgressClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionMembershipProgressClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_membership_progress_open_terminal)
state_machine.add(sm_union_membership_progress_close_terminal)
state_machine.init()
    
function SmUnionMembershipProgress:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.cells.union.union_npc_membership_progress_list_cell")
    local function init_sm_union_membership_progress_terminal()
        -- 显示界面
        local sm_union_membership_progress_display_terminal = {
            _name = "sm_union_membership_progress_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionMembershipProgressWindow = fwin:find("SmUnionMembershipProgressClass")
                if SmUnionMembershipProgressWindow ~= nil then
                    SmUnionMembershipProgressWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_membership_progress_hide_terminal = {
            _name = "sm_union_membership_progress_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionMembershipProgressWindow = fwin:find("SmUnionMembershipProgressClass")
                if SmUnionMembershipProgressWindow ~= nil then
                    SmUnionMembershipProgressWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_membership_progress_display_terminal)
        state_machine.add(sm_union_membership_progress_hide_terminal)

        state_machine.init()
    end
    init_sm_union_membership_progress_terminal()
end

function SmUnionMembershipProgress:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local arry = _ED.union.union_member_list_info
    local arrys = {}
    local haveARank = {}
    local noRank = {}
    for i, v in pairs(arry) do
        if tonumber(v.post) < 3 then
            table.insert(haveARank,v)
        else
            table.insert(noRank,v)
        end
    end

    local function sortfunction( a,b )
        local result = false
        if tonumber(a.post) < tonumber(b.post)  then
            return true
        end 
        return result
    end

    local function contributionfunction( a,b )
        local result = false
        if tonumber(a.total_contribution) > tonumber(b.total_contribution)  then
            return true
        end 
        return result
    end
    table.sort(haveARank, sortfunction)
    table.sort(noRank, contributionfunction)

    for i=1 ,#haveARank do
        table.insert(arrys,haveARank[i])
    end
    for i=1, #noRank do
        table.insert(arrys,noRank[i])
    end

    self.gradListView = ccui.Helper:seekWidgetByName(root, "ListView_hyjd")
    self.gradListView:removeAllItems()
    self.cacheListView = self.gradListView
    self.currentListView = self.cacheListView
    self.currentInnerContainer = self.cacheListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    local index = 0
    local union_position = 0
    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local infoData = arrys[i]
        index = index + 1
        local cell = UnionNpcMembershipProgressListCell:createCell()
        cell:init(infoData,index)
        self.cacheListView:addChild(cell)
        self.cacheListView:requestRefreshView()
    end
end

function SmUnionMembershipProgress:init()
    self:onInit()
    return self
end

function SmUnionMembershipProgress:onUpdate(dt)

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

function SmUnionMembershipProgress:onInit()
    local csbSmUnionMembershipProgress = csb.createNode("legion/sm_legion_pve_window_progress.csb")
    local root = csbSmUnionMembershipProgress:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionMembershipProgress)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_membership_progress_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionMembershipProgress:onExit()
    state_machine.remove("sm_union_membership_progress_display")
    state_machine.remove("sm_union_membership_progress_hide")
end