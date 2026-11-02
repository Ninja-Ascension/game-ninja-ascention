-----------------------------
--邀请好友(活动类型14)
-----------------------------
InvitationFriend = class("InvitationFriendClass", Window)

local invitation_friend_window_open_terminal = {
    _name = "invitation_friend_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("InvitationFriendClass") then
            local panel = InvitationFriend:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(invitation_friend_window_open_terminal)
state_machine.init()

function InvitationFriend:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    self._height = 0
    -- Initialize invitation_friend state machine.
    local function init_invitation_friend_terminal()
	
		--刷新
		local invitation_friend_set_positiony_terminal = {
            _name = "invitation_friend_set_positiony",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local height = instance._list_view:getContentSize().height
                if instance._height > height then
                    instance._list_view:getInnerContainer():setPositionY(height - instance._height)
                else
                    instance._list_view:getInnerContainer():setPositionY(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(invitation_friend_set_positiony_terminal)	
        state_machine.init()
    end
    
    -- call func init invitation_friend state machine.
    init_invitation_friend_terminal()
end

function InvitationFriend:onUpdateDraw()
    local root = self.roots[1]
    local ListView_invitation_friend = ccui.Helper:seekWidgetByName(root, "ListView_invitation_friend") 
    ListView_invitation_friend:removeAllItems()

    local result1 = {}
    local result2 = {}
    local result3 = {}
    for k,v in pairs(_ED.activity_info["14"].activity_data[1]) do
        if tonumber(v.achieve_state) == 1 then
            table.insert(result1, v)
        elseif tonumber(v.achieve_state) == 0 then
            table.insert(result2, v)
        elseif tonumber(v.achieve_state) == 2 then
            table.insert(result3, v)
        end
    end
    for k,v in pairs(result2) do
        table.insert(result1, v)
    end
    for k,v in pairs(result3) do
        table.insert(result1, v)
    end
    
    for i, v in pairs(result1) do
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"14",i,1})
        ListView_invitation_friend:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_invitation_friend:requestRefreshView()
    self._list_view = ListView_invitation_friend
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function InvitationFriend:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function InvitationFriend:onEnterTransitionFinish()

end

function InvitationFriend:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.invitation_friend)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    -- --关闭
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wonderful_close"), nil, 
    -- {
    --     terminal_name = "wonderful_window_close", 
    --     terminal_state = 0, 
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    -- }, nil, 0)

	self:onUpdateDraw()
    -- debug.print_r(_ED.activity_info["5"])
end

function InvitationFriend:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function InvitationFriend:onExit()
    state_machine.remove("invitation_friend_set_positiony")
end
