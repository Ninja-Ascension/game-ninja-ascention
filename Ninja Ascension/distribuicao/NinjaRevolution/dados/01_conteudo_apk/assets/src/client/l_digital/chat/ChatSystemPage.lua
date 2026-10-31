-----------------------------------------------------------------------------------------------
-- 说明：系统聊天主界面--
-------------------------------------------------------------------------------------------------------

ChatSystemPage = class("ChatSystemPageClass", Window)
    
function ChatSystemPage:ctor()
    self.super:ctor()
    self.roots = {}
    self.times = nil
    _ED.system_information_count = 0
    app.load("client.l_digital.chat.ChatSystemCell")
    local function init_chat_system_page_terminal()
        
        local chat_system_page_close_terminal = {
            _name = "chat_system_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_system_page_updata_terminal = {
            _name = "chat_system_page_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawListCell(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_system_page_show_terminal = {
            _name = "chat_system_page_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                    if not _ED.chat_lock_state then
                        state_machine.excute("chat_system_page_updata", 0, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_system_page_hide_terminal = {
            _name = "chat_system_page_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if not _ED.chat_lock_state then
                        local list = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_chat_1_2")
                        list:removeAllItems()
                        list:jumpToTop()
                    end
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(chat_system_page_close_terminal)
        state_machine.add(chat_system_page_updata_terminal)
        state_machine.add(chat_system_page_show_terminal)
        state_machine.add(chat_system_page_hide_terminal)
        state_machine.init()
    end
    init_chat_system_page_terminal()
end

function ChatSystemPage:onUpdateDrawListCell( isnotTop )
    if _ED.chat_lock_state then
        return
    end
    local root = self.roots[1]
    local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_2")
    local listPositionY = list:getInnerContainer():getPositionY()
    list:removeAllItems()
    
    local number = 0
    if _ED.send_information_system ~= nil then
        local count = table.getn(_ED.send_information_system) 
        for i,v in pairs(_ED.send_information_system) do
            if number > dms.int(dms["mail_config"] , 4 , mail_config.param)-1 then
                break
            end
            number = number + 1
            local info = _ED.send_information_system[count + 1 - i]
            if zstring.tonumber(info.system_info_id) == 45 then
                if tonumber(_ED.user_info.user_id) ~= tonumber(info.send_information_id) then
                    local cell = ChatSayOtherCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type, info)
                    list:addChild(cell)
                else
                    local cell = ChatSayMineCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type, info)
                    list:addChild(cell)
                end
            else
                local cell = ChatSystemCell:createCell()
                cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type)
                list:addChild(cell)
            end
        end
    end
    list:requestRefreshView()
    -- if isnotTop == true then
    -- else
    --     list:jumpToTop()
    -- end
    if _ED.chat_lock_state == true then
        if math.abs(listPositionY) > math.abs(list:getInnerContainer():getContentSize().height) then
            listPositionY = list:getInnerContainer():getContentSize().height
        end
        list:getInnerContainer():setPositionY(listPositionY) 
    else
        list:jumpToTop()
    end
end 

function ChatSystemPage:onUpdateRefushMsg()
    self:onUpdateDrawListCell( true )
    -- local function responseInitCallback(response)
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --         if response.node ~= nil and response.node.onUpdateDrawListCell ~= nil then
    --             if _ED.system_information_count ~= nil and tonumber(_ED.system_information_count) > 0 then
    --                 response.node:onUpdateDrawListCell( true )
    --             end
    --         end
    --     end
    -- end

    -- NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseInitCallback, false, nil)

end

-- function ChatSystemPage:onUpdate(dt)
--     if self:isVisible() == false then
--         return
--     end
--     if self.times ~= nil then
--         if self.times > 0 then
--             self.times = self.times - dt
--         else
--             _ED.system_information_count = 0
--             self:onUpdateRefushMsg()
--             self.times = 3
--         end
--     end 
-- end

function ChatSystemPage:onEnterTransitionFinish()
    local csbChatSystemPage = csb.createNode("Chat/chat_system.csb")
    self:addChild(csbChatSystemPage)
    local root = csbChatSystemPage:getChildByName("root")
    table.insert(self.roots, root)
    
    local function responseSendMessage2Callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node.onUpdateDrawListCell ~= nil then
                response.node:onUpdateDrawListCell()
            end
        end
    end
    
    -- NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseSendMessage2Callback, false, nil)
    self.times = 3
    
    self:onUpdateRefushMsg()
end


function ChatSystemPage:onExit()
    state_machine.remove("chat_system_page_close")
    state_machine.remove("chat_system_page_updata")
    state_machine.remove("chat_system_page_show")
    state_machine.remove("chat_system_page_hide")
end
