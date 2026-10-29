-----------------------------------------------------------------------------------------------
-- 说明：军团聊天主界面--
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatUnionPage = class("ChatUnionPageClass", Window)
    
function ChatUnionPage:ctor()
    self.super:ctor()
    self.roots = {}
    -- self.str = nil   --文字
    self.status = false
    self.startTime = nil
    self.times = nil
    _ED.union_information_count = 0
    app.load("client.chat.ChatSayOtherCell")
    app.load("client.chat.ChatSayMineCell")
    app.load("client.chat.ChatSayOtherCell_new")
    app.load("client.chat.ChatSayMineCell_new")
    app.load("client.chat.ChatBiaoQing")
    self.max_input = 0
    -- Initialize ChatUnionPage page state machine.
    local function init_union_world_page_terminal()
        
        local union_world_page_close_terminal = {
            _name = "union_world_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:detachWithIME()
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local union_world_page_send_message_terminal = {
            _name = "union_world_page_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateSendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_world_page_add_image_terminal = {
            _name = "union_world_page_add_image",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_6_8"):setVisible(false)
                self.status = false
                local str = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1_2_2"):getString()
                ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1_2_2"):setString(str .. "/"..tonumber(params)+100 .."|")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_union_page_updata_terminal = {
            _name = "chat_union_page_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawListCell2()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local chat_union_page_show_terminal = {
            _name = "chat_union_page_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                    if not _ED.chat_lock_state then
                        state_machine.excute("chat_union_page_updata", 0, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_union_page_hide_terminal = {
            _name = "chat_union_page_hide",
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

        state_machine.add(union_world_page_send_message_terminal)
        state_machine.add(union_world_page_add_image_terminal)
        state_machine.add(union_world_page_close_terminal)
        state_machine.add(chat_union_page_updata_terminal)
        state_machine.add(chat_union_page_show_terminal)
        state_machine.add(chat_union_page_hide_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_union_world_page_terminal()
end

function ChatUnionPage:onUpdateDrawListCell()
    if not _ED.chat_lock_state then
        return
    end
    local root = self.roots[1]
    local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_2")
    text:setString("")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        or __lua_project_id == __lua_project_l_naruto
        then
        self:onUpdateDrawListCell2()
        return
    end
    local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_2")
    list:removeAllItems()
    
    -- list:scrollToBottom(0.5,false)
    self.str = ""
    local fontSize = 20
    local widthFactor = 56
    local textWidth = fontSize*widthFactor
    local number = table.getn(_ED.send_information) 
    if number ~= nil and  number - 20 > 0 then
       number = number - 20
    else 
        number= 1
    end
    local function sortTable( a, b )
        return tonumber(a.send_information_time) > tonumber(b.send_information_time)
            or tonumber(a.send_information_time) == tonumber(b.send_information_time) and tonumber(a.send_information_time) < tonumber(b.send_information_time)
    end
    local array = {}
    array = _ED.send_information
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        table.sort(array,sortTable)
        number = 1
    end
    for i,v in pairs(array) do
        if i >= number then
            if tonumber(v.send_information_id) ~= 0 and (tonumber(v.information_type) == 2 or tonumber(v.information_type) == 6)then
                if tonumber(_ED.user_info.user_id) ~= tonumber(v.send_information_id) then
                    local cell = nil
                    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                        or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
                        or __lua_project_id == __lua_project_yugioh 
                        or __lua_project_id == __lua_project_warship_girl_b 
                        then 
                        cell = ChatSayOtherCellNew:createCell()
                        cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
                    else
                        cell = ChatSayOtherCell:createCell()
                        cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type,v)
                    end
                    list:addChild(cell)
                else
                    local cell = nil
                    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                        or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
                        or __lua_project_id == __lua_project_yugioh 
                        or __lua_project_id == __lua_project_warship_girl_b 
                        then 
                        cell = ChatSayMineCellNew:createCell()
                        cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
                    else
                        cell = ChatSayMineCell:createCell()
                        cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type,v)
                    end
                    list:addChild(cell)
                end
            
            end
        end
    end

    list:requestRefreshView()
    -- list:scrollToBottom(0.5,false)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        list:jumpToTop()
    else
        list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
    end
    
end 

function ChatUnionPage:onUpdateDrawListCell2()
    if _ED.chat_lock_state and not self.is_send_info then
        return
    end
    local root = self.roots[1]
    local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_2")
    local listPositionY = list:getInnerContainer():getPositionY()
    list:removeAllItems()
    
    local fontSize = 20
    local widthFactor = 56
    local textWidth = fontSize*widthFactor
    local array = {}
    local number = 0
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if _ED.legion_chat_view_information ~= nil then
            local count = table.getn(_ED.legion_chat_view_information) 
            for i,v in pairs(_ED.legion_chat_view_information) do
                if number > dms.int(dms["mail_config"] , 4 , mail_config.param)-1 then
                    break
                end
                number = number + 1
                local info = _ED.legion_chat_view_information[count + 1 - i]
                if tonumber(info.send_information_id) == 0 and tonumber(info.system_info_id) ~= 47 then
                    local cell = ChatSystemCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type)
                    list:addChild(cell)
                elseif tonumber(_ED.user_info.user_id) ~= tonumber(info.send_information_id) then
                    local cell = ChatSayOtherCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type, info)
                    list:addChild(cell)
                else
                    local cell = ChatSayMineCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type, info)
                    list:addChild(cell)
                end
            end
        end
    else
        number = table.getn(_ED.send_information) 
        if number ~= nil and  number - 20 > 0 then
           number = number - 20
        else 
            number = 1
        end
        local function sortTable( a, b )
            return tonumber(a.send_information_time) > tonumber(b.send_information_time)
                or tonumber(a.send_information_time) == tonumber(b.send_information_time) and tonumber(a.send_information_time) < tonumber(b.send_information_time)
        end
        array = _ED.send_information
        for i,v in pairs(array) do
            if i >= number then
                if tonumber(v.send_information_id) ~= 0 and (tonumber(v.information_type) == 2 or tonumber(v.information_type) == 6) then
                    if tonumber(_ED.user_info.user_id) ~= tonumber(v.send_information_id) then
                        local cell = nil
                        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                            or __lua_project_id == __lua_project_pokemon 
                            or __lua_project_id == __lua_project_rouge 
                            or __lua_project_id == __lua_project_yugioh 
                            or __lua_project_id == __lua_project_warship_girl_b 
                            then 
                            cell = ChatSayOtherCellNew:createCell()
                            cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
                        else
                            cell = ChatSayOtherCell:createCell()
                            cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type,v)
                        end
                        list:addChild(cell)
                    else
                        local cell = nil
                        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                            or __lua_project_id == __lua_project_pokemon 
                            or __lua_project_id == __lua_project_rouge 
                            or __lua_project_id == __lua_project_yugioh 
                            or __lua_project_id == __lua_project_warship_girl_b 
                            then 
                            cell = ChatSayMineCellNew:createCell()
                            cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
                        else
                            cell = ChatSayMineCell:createCell()
                            cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type,v)
                        end
                        list:addChild(cell)
                    end
                
                end
            end
        end
    end
    -- -- list:jumpToBottom()
    -- -- list:scrollToBottom(0.5,false)
    -- list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
    list:requestRefreshView()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        -- list:getInnerContainer():setPositionY(500000)
        if _ED.chat_lock_state == true then
            if math.abs(listPositionY) > math.abs(list:getInnerContainer():getContentSize().height) then
                listPositionY = list:getInnerContainer():getContentSize().height
            end
            list:getInnerContainer():setPositionY(listPositionY) 
        else
            list:jumpToTop()
        end
    else
        list:jumpToBottom()
    end
end 

function ChatUnionPage:onUpdateRefushMsg()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self:onUpdateDrawListCell2()
        return
    end
    local function responseInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.onUpdateDrawListCell2 ~= nil then
                if _ED.union_information_count ~= nil and tonumber(_ED.union_information_count) > 0 then
                    response.node:onUpdateDrawListCell2()
                end
            end
        end
    end

    NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseInitCallback, false, nil)

end

function ChatUnionPage:onUpdate(dt)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        return
    end
    if self:isVisible() == false then
        return
    end
    if missionIsOver() == false then
        state_machine.excute("chat_hide_self", 0, "click chat_hide_self.'")
    else
        if self.times ~= nil then
            if self.times > 0 then
                self.times = self.times - dt
            else
                _ED.union_information_count = 0
                self:onUpdateRefushMsg()
                self.times = 3
            end
            -- local times = math.ceil(os.time() - self.times)
            -- print("self.startTime===",self.startTime,times)
            -- if times > 0 and self.startTime == times then
            --     print("-------------------------------------------")
            --     _ED.union_information_count = 0
            --     self:onUpdateRefushMsg()
            --     self.startTime = times + 3
            -- end
        end 
    end
end

function ChatUnionPage:onUpdateSendInfo()
    local root = self.roots[1]
    local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_2")
    local function responseSendMessageCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
                    or __lua_project_id == __lua_project_l_naruto
                    then
                    self.is_send_info = true
                else
                    response.node:onUpdateDrawListCell()
                end
                response.node:detachWithIME()
                cleanEditBoxString(text)
                text:setString("")
            end
        end
    end

    local str = zstring.exchangeTo(text:getString())
    local length = zstring.utfstrlenServer(str)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local strDatas = zstring.split(str,"&nbsp;")
        local strinfo = ""
        for i,v in pairs(strDatas) do
            strinfo = strinfo..v
        end
        length = zstring.utfstrlenServer(strinfo)
    end
    if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b then
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            if length > 50 then
                TipDlg.drawTextDailog(_string_piece_info[377])
                return
            end 
        end   
    end 
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            if length > 37 then
                TipDlg.drawTextDailog(_string_piece_info[377])
                return
            end 
        end   
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
        local _level = dms.string(dms["fun_open_condition"],89, fun_open_condition.level)
        if tonumber(_ED.user_info.user_grade) <  tonumber(_level) then
            TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 89, fun_open_condition.tip_info))
            return
        end
        -- if length > self.max_input then
        --     TipDlg.drawTextDailog(string.format(_new_interface_text[66],self.max_input))
        --     return
        -- end
    elseif __lua_project_id == __lua_project_gragon_tiger_gate 
	   or __lua_project_id == __lua_project_red_alert
        then
        local _level = dms.string(dms["fun_open_condition"],52, fun_open_condition.level)
        if tonumber(_ED.user_info.user_grade) <  tonumber(_level) then
            TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 52, fun_open_condition.tip_info))
            return
        end 
    end

    if text:getString() ~= "" then
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
            then
            if os.time() - _ED._last_send_chat_time < 10 then
                TipDlg.drawTextDailog(string.format(_new_interface_text[169]))
                return
            end
            _ED._last_send_chat_time = os.time()
            protocol_command.send_message.param_list = str.."\r\n2\r\n0"
        else
            protocol_command.send_message.param_list = str.."\r\n".."2"
        end
        NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
    else
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        else
            TipDlg.drawTextDailog(_string_piece_info[257])
        end
    end
end

function ChatUnionPage:onUpdateDrawPic()
    local root = self.roots[1]
    -- [[绘制滚动层
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_156_2")
    local panel = ccui.Layout:create()
    panel:setContentSize(m_ScrollView:getContentSize())
    
    panel:setPosition(cc.p(285,200))
    panel:removeAllChildren(true)
    m_ScrollView:addChild(panel)
    local sSize = panel:getContentSize()
    local controlSize = m_ScrollView:getInnerContainerSize()
    local cellWidth = sSize.width / 5
    local function addRewardScrollView(_index)
        local tempCell = ChatBiaoQing:createCell()
        tempCell:init(_index,2)
        local cellHeight = tempCell:getContentSize().height
        local cellHeight = 60
        local row = math.floor((_index - 1) / 5 + 1)
        local col = math.floor((_index - 1) % 5)
        local controlHeight = row * cellHeight
        
        if controlHeight < sSize.height then
            controlSize.height = sSize.height
        else
            controlSize.height = controlHeight + cellHeight
        end
        
        m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height/2+150))
        
        local pos = nil
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            pos=cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2+165,
            sSize.height - cellHeight * row-60)
        else
            pos=cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
            sSize.height - cellHeight * row-60)
        end
        tempCell:setPosition(pos)
        panel:addChild(tempCell)
        panel:setPositionY(controlSize.height - sSize.height)
        return tempCell
    end
    

    for i = 1 , 27 do
        addRewardScrollView(i)
    end

end

function ChatUnionPage:onUpdateDrawPic2()
    local root = self.roots[1]
    -- [[绘制滚动层
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_156_2_3")
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())

    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    
    local sSize = panel:getContentSize()
    local controlSize = m_ScrollView:getInnerContainerSize()
    local cellWidth = sSize.width / 5
    local function addRewardScrollView(_index)
        local tempCell = ChatBiaoQing:createCell()
        tempCell:init(_index,2)
        local cellHeight = tempCell:getContentSize().height
        local cellHeight = 60
        local row = 0
        local col = 0
        
        row = math.floor((_index - 1) / 9 + 1)
        col = math.floor((_index - 1) % 9)  
        cellWidth = sSize.width / 9
        cellHeight = 65

        local controlHeight = row * cellHeight
        
        local pos = nil

        pos=cc.p(cellWidth * col,
            sSize.height - cellHeight * row)
        m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))

        tempCell:setPosition(pos)
        panel:addChild(tempCell)
        panel:setPositionY(controlSize.height - sSize.height)
        return tempCell
    end
    
    for i = 1 , 27 do
        addRewardScrollView(i)
    end
end

function ChatUnionPage:onUpdateDraw()
    local root = self.roots[1]
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_123")
    local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_2")
    -- local function setStringTouchEvent(sender, eventType)
        
        -- if eventType == ccui.TouchEventType.began then
            -- text:setString("")
            -- panel:removeAllChildren(true)
            -- self.str = ""
        -- elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            -- self.str = ccui.Helper:seekWidgetByName(root, "TextField_1_2"):getString()
            -- local _richText = ccui.RichText:create();
            -- _richText:ignoreContentAdaptWithSize(false);
            -- _richText:setContentSize(text:getContentSize())
            -- local re1 = ccui.RichElementText:create(1, cc.c3b(0, 255, 0), 255, self.str, "fonts/FZYiHei-M20S.ttf", 30)
            -- local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, "images/ui/biaoqing/1.png")
            -- _richText:pushBackElement(re1)
            -- _richText:pushBackElement(reimg)
            
            -- panel:addChild(_richText)
            -- _richText:setAnchorPoint(cc.p(0, 0))
            -- _richText:setPosition(cc.p(-130, -20))
        -- end
    -- end
    -- ccui.Helper:seekWidgetByName(root, "TextField_1_2"):addTouchEventListener(setStringTouchEvent)
    
end

function ChatUnionPage:detachWithIME()
    local root = self.roots[1]
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1_2_2")
    roleName:didNotSelectSelf()
end

function ChatUnionPage:onEnterTransitionFinish()
    local csbChatUnionPage = csb.createNode("Chat/chat_legion.csb")
    self:addChild(csbChatUnionPage)
    local root = csbChatUnionPage:getChildByName("root")
    table.insert(self.roots, root)
    
    
    local sendMessage = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_4"), nil, 
    {
        func_string = [[state_machine.excute("union_world_page_send_message", 0, "click union_world_page_send_message.'")]],
        isPressedActionEnabled = true
    }, nil, 0)
    
    
    local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            if self.status == false then
                ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(true)
                self.status = true
            elseif self.status == true then
                ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(false)
                self.status = false
            end
        end
    end
    local Button_5_2_2 = ccui.Helper:seekWidgetByName(root, "Button_5_2_2")
    if Button_5_2_2 ~= nil then
        Button_5_2_2:addTouchEventListener(onOpenTouchEvent)
    end
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1_2_2")
    if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b then
        draw:addEditBox(roleName, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_4"), 50, cc.KEYBOARD_RETURNTYPE_DONE)
    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local max_input = zstring.split(dms.string(dms["mail_config"] , 3 , mail_config.param),",")
        if verifySupportLanguage(_lua_release_language_en) == true then
            self.max_input = tonumber(max_input[2])
        else
            self.max_input = tonumber(max_input[1])
        end
        -- DSC重塑
        local isRunChatAction = true
        if __lua_project_id == __lua_project_l_digital then
            isRunChatAction = false
        end
        draw:addEditBox(roleName, string.format(_new_interface_text[66],self.max_input), "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_4"), self.max_input, cc.KEYBOARD_RETURNTYPE_DONE, isRunChatAction)
    elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
        draw:addEditBox(roleName, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_4"), 37, cc.KEYBOARD_RETURNTYPE_DONE)
    else
        draw:addEditBox(roleName, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_4"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
    end 
    local function responseSendMessage2Callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node.onUpdateDrawListCell ~= nil then
                response.node:onUpdateDrawListCell()
            end
        end
    end
    
    -- NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseSendMessage2Callback, false, nil)
    self.times = 3
    -- self.startTime = math.ceil(os.time() - self.times) + 3
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        self:onUpdateDrawPic2()
    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else

        self:onUpdateDrawPic()
    end
    
    -- self:onUpdateDraw()
    
    self:onUpdateRefushMsg()
end

function ChatUnionPage:init( rootWindow )
    self._rootWindows = rootWindow
    return self
end

function ChatUnionPage:onExit()
    state_machine.remove("union_world_page_send_message")
    state_machine.remove("union_world_page_add_image")
    state_machine.remove("union_world_page_close")
    state_machine.remove("chat_union_page_updata")
    state_machine.remove("chat_union_page_show")
    state_machine.remove("chat_union_page_hide")
end
