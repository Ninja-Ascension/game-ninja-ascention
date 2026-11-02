--------------------------------------------------------------------------------------------------------------
--  说明：节日红包发送cell
--------------------------------------------------------------------------------------------------------------
red_packet_send_list_cell = class("red_packet_send_list_cellClass", Window)
red_packet_send_list_cell.__size = nil

--创建cell
local red_packet_send_list_cell_terminal = {
    _name = "red_packet_send_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = red_packet_send_list_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_packet_send_list_cell_terminal)
state_machine.init()

function red_packet_send_list_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    self.isopen = false  --是否打开红包详情界面
    self.posy = nil
    app.load("client.cells.campaign.icon.arena_role_icon_cell")
    app.load("client.activity.redpacket.RedPacketWindow")
    app.load("client.activity.redpacket.RedPacketDrawInfo")

    local function init_draw_red_packet_cell_terminal()
        local draw_red_packet_cell_terminal = {
            _name = "draw_red_packet",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                            local Button_qiang = ccui.Helper:seekWidgetByName(cells.roots[1],"Button_qiang")
                            Button_qiang:setBright(false)
                            Button_qiang:setTouchEnabled(false)
                        end
                        state_machine.excute("update_red_packet_state", 0,nil)
                    end
                end
                protocol_command.activity_draw_red_packet.param_list = cells.activity.id
                NetworkManager:register(protocol_command.activity_draw_red_packet.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(draw_red_packet_cell_terminal) 
        state_machine.init()
    end 
    init_draw_red_packet_cell_terminal()

end

function red_packet_send_list_cell:updateDrawInfo()
    if not self.activity then
        return
    end
    local root = self.roots[1]
   
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name") --name
    Text_player_name:setString(self.activity.senderName)
    self.posy = Text_player_name:getPositionY()
    
    local counts = 0
    local count = 0
    counts,count = self:judgeIsOver()
    local Text_red_packet_num = ccui.Helper:seekWidgetByName(root, "Text_red_packet_num")   --领取次数
    Text_red_packet_num:setString(count.."/"..counts)
    local Panel_red_packet_icon = ccui.Helper:seekWidgetByName(root, "Panel_red_packet_icon")  --头像
    Panel_red_packet_icon:removeAllChildren(true)
    local icon = ArenaRoleIconCell:createCell()
    icon:init(tonumber(self.activity.senderPic), 1)
    Panel_red_packet_icon:addChild(icon)
end

function red_packet_send_list_cell:onUpdate(dt)
    
end

function red_packet_send_list_cell:judgeIsOver()
    local counts = 0
    local count = 0
    local Image_special_list = ccui.Helper:seekWidgetByName(self.roots[1], "Image_special_list")  --特殊红包
    local Text_red_packet_legion = ccui.Helper:seekWidgetByName(self.roots[1], "Text_red_packet_legion")   --工会名称
    Text_red_packet_legion:setString("")
    local Panel_special_effect = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_special_effect")   --特殊红包动画容器
    local Text_player_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_player_name")  --玩家名字
    local Image_legion_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_legion_bg")   --工会名图片
    Image_legion_bg:setVisible(false)
    local Text_red_packet_num = ccui.Helper:seekWidgetByName(self.roots[1], "Text_red_packet_num")  
    
    local jsonFile = "images/ui/effice/spirte_jrhbbk/spirte_jrhbbk.json"        
    local atlasFile = "images/ui/effice/spirte_jrhbbk/spirte_jrhbbk.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
   
    if self.activity.type == 1 then
       counts = zstring.split(_ED.active_activity[155].need_recharge_count,":")[5] 
       Image_special_list:setVisible(false)
       Text_player_name:setPositionY(Text_red_packet_num:getPositionY())
    else
        Panel_special_effect:removeAllChildren(true) 
        Panel_special_effect:addChild(animation)
        Text_player_name:setPositionY(Text_red_packet_num:getPositionY())
        if self.activity.type == 2 then
            Text_red_packet_legion:setString(self.activity.unionName)
            Image_legion_bg:setVisible(true)
            Text_player_name:setPositionY(69)
        end
        counts = zstring.split(_ED.active_activity[155].need_recharge_count,":")[6] 
        Image_special_list:setVisible(true)
    end
    if not self.activity.drawInfo then
        count = 0
    else
       for k,v in pairs(self.activity.drawInfo) do
        count = count + 1
       end
    end
    return counts,count
end

function red_packet_send_list_cell:updateButton()
    if not self.activity then
        return
    end
    local info = _ED.red_packet_enter_info
    local counts = 0
    local count = 0
    counts,count = self:judgeIsOver()
    local Button_qiang = ccui.Helper:seekWidgetByName(self.roots[1],"Button_qiang")
    Button_qiang:setBright(true)
    Button_qiang:setTouchEnabled(true)
  
    if self.activity.drawInfo then
        for k,v in pairs(self.activity.drawInfo) do
           if tonumber(v.id) == tonumber(_ED.user_info.user_id)then
                Button_qiang:setBright(false)
                Button_qiang:setTouchEnabled(false)
                self.isopen = true
                break
           end
        end
    end
 
    if count == counts then
        local Image_yqw = ccui.Helper:seekWidgetByName(self.roots[1],"Image_yqw")
        Image_yqw:setVisible(true)
    end
end

function red_packet_send_list_cell:onInit()
    local root = cacher.createUIRef("activity/wonderful/red_packet_list_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if red_packet_send_list_cell.__size == nil then
        red_packet_send_list_cell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qiang"), nil, 
    {
        terminal_name = "draw_red_packet", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

    local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
            -- sender.isMoving = false
        elseif eventType == ccui.TouchEventType.moved then 
            -- sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__epoint.y - __spoint.y) <= 8 then
               if self.isopen == true then
                  state_machine.excute("red_packet_draw_open",0,{self.activity})
               end
            end
        end
    end
    root:addTouchEventListener(fourOpenTouchEvent)
 
    self:clearUIInfo()
	self:updateDrawInfo()
    self:updateButton()
end

function red_packet_send_list_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function red_packet_send_list_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Text_red_packet_num = ccui.Helper:seekWidgetByName(root, "Text_red_packet_num")
    local Panel_red_packet_icon = ccui.Helper:seekWidgetByName(root, "Panel_red_packet_icon")  --头像
    if Panel_red_packet_icon then
        Panel_red_packet_icon:removeAllChildren(true)
        Text_player_name:setString("")
        Text_red_packet_num:setString("")
    end
end

function red_packet_send_list_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function red_packet_send_list_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/red_packet_list_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function red_packet_send_list_cell:init(params)
    self.activity = params[1]
	self:onInit()
    self:setContentSize(red_packet_send_list_cell.__size)
    return self
end

function red_packet_send_list_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/red_packet_list_cell.csb", self.roots[1])
end