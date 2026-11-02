-----------------------------
--数码邮件cell
-----------------------------
EmailManagerList = class("EmailManagerListClass", Window)
EmailManagerList.__size = nil

local email_manager_list_cell_terminal = {
    _name = "email_manager_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EmailManagerList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(email_manager_list_cell_terminal)
state_machine.init()

function EmailManagerList:ctor()
    self.super:ctor()
	self.roots = {}		
    self.email = nil
	
	app.load("client.l_digital.email.email_infomation")
	app.load("client.cells.utils.resources_icon_cell")

 	local function init_email_manager_list_cell_terminal()
        --打开邮件信息
		local email_manager_list_cell_open_info_terminal = {
            _name = "email_manager_list_cell_open_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local _rewardId = cell.email._reward_centre_id
                local data_type = cell.email.data_type
                if fwin:find("EmailInfomationClass") == nil then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            --没奖励的邮件第一次读存到本地
                            local email, index = fundEmailById(_rewardId, data_type)
                            if email ~= nil then
                                if tonumber(email.read_type) == 0 and tonumber(email._reward_item_count) == 0 then
                                    email.read_type = 1
                                    _ED._reward_centre[index].read_type = 1
                                end
                            end
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                            end

                            local emailInfoWin = EmailInfomation:createCell()
                            emailInfoWin:init(email)
                            fwin:open(emailInfoWin,fwin._view)
                            state_machine.excute("email_manager_email_number_show",0,"email_manager_email_number_show.")
                            state_machine.excute("notification_center_update", 0, "push_notification_center_mall_all")
                        end
                    end
                    if tonumber(data_type) == 1 then
                        protocol_command.user_read_mail.param_list = cell.email._reward_centre_id.."\r\n".."1"
                    else
                        protocol_command.user_read_mail.param_list = cell.email._reward_centre_id.."\r\n".."0"
                    end
                    NetworkManager:register(protocol_command.user_read_mail.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(email_manager_list_cell_open_info_terminal)
        state_machine.init()
    end
	init_email_manager_list_cell_terminal()        	
end

function EmailManagerList:onHeadDraw(object)
    local big_icon_path = cc.Sprite:create(string.format("images/ui/props/props_%d.png", tonumber(self.email.head)))
    local quality_path = cc.Sprite:create("images/ui/quality/quality_frame_1.png")

    local layer2 = cc.Layer:create()
    layer2:removeAllChildren(true)
    layer2:setContentSize(cc.size(object:getContentSize().width, object:getContentSize().height))
    layer2:setAnchorPoint(object:getAnchorPoint())
    layer2:setPosition(cc.p(0,0))
    big_icon_path:setPosition(cc.p(layer2:getContentSize().width/2,layer2:getContentSize().height/2))
    layer2:addChild(big_icon_path) 
    object:addChild(layer2)

    local layer = cc.Layer:create()
    layer:removeAllChildren(true)
    layer:setContentSize(cc.size(object:getContentSize().width, object:getContentSize().height))
    layer:setAnchorPoint(object:getAnchorPoint())
    layer:setPosition(cc.p(0,0))
    quality_path:setPosition(cc.p(layer:getContentSize().width/2,layer:getContentSize().height/2))
    layer:addChild(quality_path)

    object:addChild(layer)
end

function EmailManagerList:getTime( time )
    return os.date("%Y".."-".."%m".."-".."%d" , getBaseGTM8Time(time))
end

function EmailManagerList:onUpdateDraw()
	local root = self.roots[1]
    --头像
	local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    Panel_4:removeAllChildren(true)
    self:onHeadDraw(Panel_4)
    Panel_4:setTouchEnabled(false)
    --主题
    local Text_emil_tt_n = ccui.Helper:seekWidgetByName(root, "Text_emil_tt_n")
    Text_emil_tt_n:setString(self.email.title)
    --发件人
    local Text_emil_from_n = ccui.Helper:seekWidgetByName(root, "Text_emil_from_n")
    Text_emil_from_n:setString(self.email.form)
    --日期
    local Text_emil_time_n = ccui.Helper:seekWidgetByName(root, "Text_emil_time_n")
    Text_emil_time_n:setString(self:getTime(self.email._reward_time))
    --读取状态
    local Image_email_not_read = ccui.Helper:seekWidgetByName(root, "Image_email_not_read")
    local Image_email_read = ccui.Helper:seekWidgetByName(root, "Image_email_read")
    Image_email_not_read:setVisible(false)
    Image_email_read:setVisible(false)
    if tonumber(self.email.read_type) == 0 then
        Image_email_not_read:setVisible(true)
    else
        Image_email_read:setVisible(true)
    end

end

function EmailManagerList:onEnterTransitionFinish()

end

function EmailManagerList:onInit()
	local root = cacher.createUIRef("email/email_list.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    Panel_2:setScale(1)
    Panel_2:setTouchEnabled(true)
    Panel_2:setSwallowTouches(false)
	if EmailManagerList.__size == nil then
		EmailManagerList.__size = root:getContentSize()
	end

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
                sender:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.03, 1.05),
                    cc.ScaleTo:create(0.02, 1)
                ))
                state_machine.excute("email_manager_list_cell_open_info",0,{ _datas = { _cell = sender._self }})
            end
        end
    end
    Panel_2._self = self
    Panel_2:addTouchEventListener(fourOpenTouchEvent)
	self:onUpdateDraw()
end

function EmailManagerList:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("email/email_list.csb", root)
end

function EmailManagerList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EmailManagerList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("email/email_list.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function EmailManagerList:clearUIInfo( ... )
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local root = self.roots[2]
        local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
        local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
        local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
        local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
        local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
        local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
        local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
        local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
        local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
        local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
        local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
        local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
        local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
        local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
        local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
        local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
        if Image_double ~= nil then
            Image_double:setVisible(false)
        end
        if Image_xuanzhong ~= nil then
            Image_xuanzhong:setVisible(false)
        end
        if Image_3 ~= nil then
            Image_3:setVisible(false)
        end
        if Label_l_order_level ~= nil then 
            Label_l_order_level:setVisible(true)
            Label_l_order_level:setString("")
        end
        if Label_name ~= nil then
            Label_name:setString("")
            Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
            Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
            Label_shuxin:setString("")
        end
        if Panel_prop ~= nil then
            Panel_prop:removeAllChildren(true)
            Panel_prop:removeBackGroundImage()
        end
        if Panel_kuang ~= nil then
            Panel_kuang:removeAllChildren(true)
            Panel_kuang:removeBackGroundImage()
        end
        if Panel_ditu ~= nil then
            Panel_ditu:removeAllChildren(true)
            Panel_ditu:removeBackGroundImage()
        end
        if Panel_star ~= nil then
            Panel_star:removeAllChildren(true)
            Panel_star:removeBackGroundImage()
        end
        if Panel_props_right_icon ~= nil then
            Panel_props_right_icon:removeAllChildren(true)
            Panel_props_right_icon:removeBackGroundImage()
        end
        if Panel_props_left_icon ~= nil then
            Panel_props_left_icon:removeAllChildren(true)
            Panel_props_left_icon:removeBackGroundImage()
        end
        if Panel_num ~= nil then
            Panel_num:removeAllChildren(true)
            Panel_num:removeBackGroundImage()
        end
        if Panel_4 ~= nil then
            Panel_4:removeAllChildren(true)
            Panel_4:removeBackGroundImage()
        end
        if Text_1 ~= nil then
            Text_1:setString("")
        end
    end
    local root = self.roots[1]
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    local Text_emil_tt_n = ccui.Helper:seekWidgetByName(root, "Text_emil_tt_n")
    local Text_emil_from_n = ccui.Helper:seekWidgetByName(root, "Text_emil_from_n")
    local Text_emil_time_n = ccui.Helper:seekWidgetByName(root, "Text_emil_time_n")
    if Panel_4 ~= nil then
        Panel_4:removeAllChildren(true)
        Text_emil_tt_n:setString("")
        Text_emil_from_n:setString("")
        Text_emil_time_n:setString("")
    end
end

function EmailManagerList:init(params)
	self.email = params[1]
    self._index = params[2]
	
    if self._index ~= nil and self._index < 5 then
        self:onInit()
    end
	self:setContentSize(EmailManagerList.__size)
    return self
end

