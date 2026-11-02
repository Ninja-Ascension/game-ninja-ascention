SmFriendBlackList = class("SmFriendBlackListClass", Window)

local sm_friend_black_list_open_terminal = {
    _name = "sm_friend_black_list_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmFriendBlackList:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_friend_black_list_open_terminal)
state_machine.init()

function SmFriendBlackList:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0
    self.currPage = 1               -- 当前页数

    app.load("client.l_digital.cells.friend.sm_friend_cell")

    local function init_sm_friend_black_list_terminal()
        local sm_friend_black_list_show_terminal = {
            _name = "sm_friend_black_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil then
                    instance:setVisible(true)
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_black_list_hide_terminal = {
            _name = "sm_friend_black_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil then
                    instance.ListView_15:jumpToTop()
                    instance.ListView_15:removeAllItems()
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_black_list_update_terminal = {
            _name = "sm_friend_black_list_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance.currPage = 1
                    instance:updateDrawUI()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_black_list_change_page_terminal = {
            _name = "sm_friend_black_list_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil then
                    local currType = params._datas._type
                    local page = instance.currPage + currType
                    if page < 1 then
                        return
                    end
                    if page > instance.maxPage then
                        return
                    end
                    instance.currPage = page
                    instance:updateDrawUI()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_friend_black_list_show_terminal)   
        state_machine.add(sm_friend_black_list_hide_terminal)
        state_machine.add(sm_friend_black_list_update_terminal)
        state_machine.add(sm_friend_black_list_change_page_terminal)
        state_machine.init()
    end
    init_sm_friend_black_list_terminal()
end

function SmFriendBlackList:getOnePageNumber()
    local onePageNumber = dms.int(dms["friend_config"], 5, friend_config.param)
    return onePageNumber
end

function SmFriendBlackList:updateDrawPage()
    local onePageNumber = self:getOnePageNumber()

end

function SmFriendBlackList:drawBlackFriendList()
    self.ListView_15:removeAllItems()

    local onePageNumber = self:getOnePageNumber()
    local startIndex = (self.currPage - 1) * onePageNumber + 1
    local endIndex = self.currPage * onePageNumber
    if tonumber(_ED.black_user_num) > 0 then
        for i = startIndex, endIndex do
            if _ED.black_user[i] ~= nil then
                -- debug.print_r(_ED.black_user[i], "====_ED.black_user[i]")
                local blackData = _ED.black_user[i]
                if blackData.lead_mould_id == nil or blackData.lead_mould_id == "" then
                    blackData.lead_mould_id = blackData.head_pic
                end
                local cell = state_machine.excute("sm_friend_cell", 0, {4, _ED.black_user[i]})
                self.ListView_15:addChild(cell)
            end
        end
    end
    
    self.ListView_15:jumpToTop()
    self.ListView_15:requestRefreshView()
end

function SmFriendBlackList:updateDrawUI()
    local max_black_friend_number = dms.int(dms["friend_config"], 2, friend_config.param)
    self.Text_friend_n:setString(_ED.black_user_num .. "/" .. max_black_friend_number)

    local onePageNumber = self:getOnePageNumber()
    self.maxPage = math.ceil(tonumber(_ED.black_user_num)/onePageNumber)
    self.maxPage = math.max(self.maxPage, 1)
    self.Text_page_n:setString(self.currPage.."/"..self.maxPage)

    self.Text_tip:setVisible(tonumber(_ED.black_user_num) == 0 )

    self:drawBlackFriendList()
end


function SmFriendBlackList:onUpdateDraw()
    local root = self.roots[1]
    self.ListView_15 = ccui.Helper:seekWidgetByName(root,"ListView_15")
    self.Text_friend_n = ccui.Helper:seekWidgetByName(root,"Text_friend_n")
    self.Text_page_n = ccui.Helper:seekWidgetByName(root,"Text_page_n")
    self.Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")

    self:updateDrawUI()
end

function SmFriendBlackList:onUpdate( dt )
end

function SmFriendBlackList:onInit(params)
    local csbItem = csb.createNode("friend/friend_black.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_left"), nil, 
    {
        terminal_name = "sm_friend_black_list_change_page", 
        terminal_state = 0, 
        _type = -1,
        isPressedActionEnabled = true
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_right"), nil, 
    {
        terminal_name = "sm_friend_black_list_change_page", 
        terminal_state = 0, 
        _type = 1,
        isPressedActionEnabled = true
    }, nil, 1)
    
    self:onUpdateDraw()
end

function SmFriendBlackList:onEnterTransitionFinish()
end

function SmFriendBlackList:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function SmFriendBlackList:onExit()
    state_machine.remove("sm_friend_black_list_show")
    state_machine.remove("sm_friend_black_list_hide")
    state_machine.remove("sm_friend_black_list_update")
    state_machine.remove("sm_friend_black_list_change_page")
    
end