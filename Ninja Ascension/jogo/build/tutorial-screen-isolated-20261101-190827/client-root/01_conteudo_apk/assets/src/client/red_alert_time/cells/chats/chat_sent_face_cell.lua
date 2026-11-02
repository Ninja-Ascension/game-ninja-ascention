-----------------------------
--聊天表情cell
-----------------------------
ChatSentFaceCell = class("ChatSentFaceCellClass", Window)
--创建cell
local chat_sent_face_create_cell_terminal = {
    _name = "chat_sent_face_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local id = params[1]
        local types = params[2]
        local cell = ChatSentFaceCell:new()
        cell:init(id,types)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(chat_sent_face_create_cell_terminal)
state_machine.init()

function ChatSentFaceCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._chat_info = nil

    local function init_chat_sent_face_cell_terminal()
        local chat_sent_face_icon_terminal = {
            _name = "chat_sent_face_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local types = params._datas._type
                local id = params._datas._id
				if tonumber(types) == 10 then
					state_machine.excute("write_an_email_chat_sent_add_image", 0, id)
                elseif tonumber(types) == 11 then
                    state_machine.excute("legion_mail_write_chat_sent_add_image", 0, id)
                elseif tonumber(types) == 12 then
                    state_machine.excute("enemy_strike_chat_cell_add_image", 0, id)
				else
					-- state_machine.excute("red_alert_time_chat_sent_add_image", 0, id)
					state_machine.excute("red_alert_time_chat_sent_cell_add_image", 0, id)
				end       
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(chat_sent_face_icon_terminal)
        state_machine.init()
    end

    init_chat_sent_face_cell_terminal()
end

function ChatSentFaceCell:onEnterTransitionFinish()

end

function ChatSentFaceCell:init(id,types)
    self.id = id
    self.types = types          --1为世界聊天 10：写邮件 11：军团邮件
    self:onInit()
    return self
end

function ChatSentFaceCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.chats.chat_sent_face_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    self:setContentSize(root:getContentSize())
    local Panel_face_icon = ccui.Helper:seekWidgetByName(root, "Panel_face_icon")  
    Panel_face_icon:removeBackGroundImage()
    Panel_face_icon:setBackGroundImage(string.format("images/ui/chat/face_icon_%d.png", tonumber(self.id)))
    -- local sprite = cc.Sprite:createWithSpriteFrameName(string.format("images/ui/chat/face_icon_%d.png", tonumber(self.id)))
    -- Panel_face_icon:addChild(sprite)
    fwin:addTouchEventListener(Panel_face_icon, nil, 
    {
        terminal_name = "chat_sent_face_icon",    
        _id = self.id,
        _type = self.types,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,  
    }, 
    nil, 0)
end

function ChatSentFaceCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChatSentFaceCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.chats.chat_sent_face_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ChatSentFaceCell:onExit()
    cacher.freeRef(config_csb.cells.chats.chat_sent_face_cell, self.roots[1])
end
