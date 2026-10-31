--------------------------------------------------------------------------------------------------------------
--  推送的单个cell
--------------------------------------------------------------------------------------------------------------
SetUpPushCell = class("SetUpPushCellClass", Window)
SetUpPushCell.__size = nil
--创建cell
local set_up_push_cell_terminal = {
    _name = "set_up_push_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SetUpPushCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(set_up_push_cell_terminal)
state_machine.init()

function SetUpPushCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.isForbidden = false
    
    local function init_set_up_push_cell_terminal()

        local set_up_push_cell_change_push_terminal = {
            _name = "set_up_push_cell_change_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cells
                local system_local_push_list = cc.UserDefault:getInstance():getStringForKey("system_local_push_list")
                if system_local_push_list == nil or system_local_push_list == "" then
                    showId = {}
                    system_local_push_list = ""
                    for i, v in pairs(_app_push_notification) do
                        if showId[tonumber(v[4])] == nil then
                            showId[tonumber(v[4])] = {}
                            showId[tonumber(v[4])].id = v[4]
                            showId[tonumber(v[4])].name = v[5]
                        end
                    end
                    for i, v in pairs(showId) do
                        if i == #showId then
                            system_local_push_list = system_local_push_list.."0"
                        else
                            system_local_push_list = system_local_push_list.."0"..","
                        end
                    end
                    cc.UserDefault:getInstance():setStringForKey("system_local_push_list", system_local_push_list)
                    cc.UserDefault:getInstance():flush()
                end
                local push_list_info = zstring.split(system_local_push_list ,",")
                system_local_push_list = ""
                local number = 0 
                if cell.isForbidden == false then
                    number = 1
                else
                    number = 0
                end
                for i, v in pairs(push_list_info) do
                    if i == tonumber(cell.id) then
                        if i == #push_list_info then
                            system_local_push_list = system_local_push_list..number
                        else
                            system_local_push_list = system_local_push_list..number..","
                        end
                    else
                        if i == #push_list_info then
                            system_local_push_list = system_local_push_list..push_list_info[i]
                        else
                            system_local_push_list = system_local_push_list..push_list_info[i]..","
                        end
                    end
                end
                if number == 1 then
                    if tonumber(cell.id) == 1 or tonumber(cell.id) == 4 or tonumber(cell.id) == 5 or tonumber(cell.id) ==6 
                        or tonumber(cell.id) == 7 or tonumber(cell.id) == 8 then
                        if tonumber(cell.id) == 1 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 13*10)
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 14*10)
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 15*10)
                        elseif tonumber(cell.id) == 4 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 4*10)
                        elseif tonumber(cell.id) == 5 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 5*10)
                        elseif tonumber(cell.id) == 6 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 6*10)
                        elseif tonumber(cell.id) == 7 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 7*10)
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 8*10)
                        elseif tonumber(cell.id) == 8 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 9*10)
                        end
                    elseif tonumber(cell.id) == 2 or tonumber(cell.id) == 3 then
                        if tonumber(cell.id) == 2 then
                            handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 9999)
                        elseif tonumber(cell.id) == 3 then
                            if _ED.app_push_number[2]~= nil then
                                for i, v in pairs(_ED.app_push_number[2]) do
                                    if type(v) == "table" then
                                        handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 2*10+tonumber(v.pushid))
                                    end
                                end
                            end
                            if _ED.app_push_number[3]~= nil then
                                for i, v in pairs(_ED.app_push_number[3]) do
                                     if type(v) == "table" then
                                        handlePlatformRequest(0, CC_REMOVE_PUSH_NOTIFICATION, 3*10+tonumber(v.pushid))
                                    end
                                end
                            end
                        end
                    end
                end
                cc.UserDefault:getInstance():setStringForKey("system_local_push_list", system_local_push_list)
                cc.UserDefault:getInstance():flush()
                cell:updateDraw()
                -- cc.UserDefault:getInstance():setStringForKey(getKey("system_local_push_list"), server_date)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(set_up_push_cell_change_push_terminal)
        state_machine.init()
    end
    
    init_set_up_push_cell_terminal()
end

function SetUpPushCell:updateDraw()
    local root = self.roots[1]
    local Text_set_up_infor_1_1 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_1_1")
    local Button_set_up_1 = ccui.Helper:seekWidgetByName(root,"Button_set_up_1")
    Text_set_up_infor_1_1:removeAllChildren(true)
    Text_set_up_infor_1_1:setString(self.name)
    local state_info = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
    state_info:setName("state_info")
    state_info:setAnchorPoint(cc.p(0, 0.5))
    state_info:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
    state_info:setPositionX(Text_set_up_infor_1_1:getContentSize().width+10)
    state_info:setPositionY(Text_set_up_infor_1_1:getContentSize().height/2)
    state_info:setTag(100)
    Text_set_up_infor_1_1:addChild(state_info)
    
    state_info:setString(_app_system_text[3])
    local system_local_push = cc.UserDefault:getInstance():getStringForKey("system_local_push")
    local system_local_push_list = cc.UserDefault:getInstance():getStringForKey("system_local_push_list")

    if system_local_push == nil or system_local_push == "" or tonumber(system_local_push) == 0 then
        if system_local_push_list == nil or system_local_push_list == "" then
            self.isForbidden = false
        else
            local push_list_info = zstring.split(system_local_push_list ,",")
            if tonumber(push_list_info[tonumber(self.id)]) == 0 then
                self.isForbidden = false
            else
                self.isForbidden = true        
            end
        end
    else
        self.isForbidden = true   
    end
    if self.isForbidden == true then
        Button_set_up_1:setHighlighted(false)
        Button_set_up_1:setTitleText(_app_system_text[1]) 
        state_info:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        state_info:setString(_app_system_text[4])
    else
        Button_set_up_1:setHighlighted(true)
        Button_set_up_1:setTitleText(_app_system_text[2]) 
        state_info:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
        state_info:setString(_app_system_text[3])
    end
end

function SetUpPushCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.system.set_up_push_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if SetUpPushCell.__size == nil then
        SetUpPushCell.__size = root:getContentSize()
    end
    root:setTouchEnabled(false)

    -- 免打扰
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_1"), nil, 
    {
        terminal_name = "set_up_push_cell_change_push",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cells = self,
    },
    nil,1)

	self:updateDraw()
end

function SetUpPushCell:onEnterTransitionFinish()

end

function SetUpPushCell:init(params)
    self.id = params.id
    self.name = params.name
    self:onInit()

    self:setContentSize(SetUpPushCell.__size)
    return self
end

function SetUpPushCell:clearUIInfo( ... )
    local root = self.roots[1]

end

function SetUpPushCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.system.set_up_push_cell, self.roots[1])
end

function SetUpPushCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SetUpPushCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.system.set_up_push_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end