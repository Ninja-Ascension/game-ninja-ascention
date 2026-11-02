
SmFriendCell = class("SmFriendCellClass", Window)
SmFriendCell.__size = nil

local sm_friend_cell_terminal = {
    _name = "sm_friend_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = SmFriendCell:new():init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_friend_cell_terminal)
state_machine.init()

function SmFriendCell:ctor()
    self.super:ctor()
	self.roots = {}
    self._info = nil
    self.types = 0
	
    local function init_sm_friend_cell_terminal()
	    local sm_friend_cell_send_food_terminal = {
            _name = "sm_friend_cell_send_food",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function respondCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[54])
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    else
                        state_machine.excute("sm_friend_list_request_refresh", 0, nil)
                    end
                end
                protocol_command.present_endurance.param_list = cell._info.user_id .."\r\n".."1"
                NetworkManager:register(protocol_command.present_endurance.code, nil, nil, nil, cell, respondCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_friend_cell_click_head_terminal = {
            _name = "sm_friend_cell_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currCell = params._datas._cell
                local types = params._datas._cell.types
                local userInfo = currCell._info
                if types == 1 then
                    types = 2
                elseif types == 2 then
                    types = 1
                end
                if fwin:find("ChatFriendInfoClass") ~= nil then
                    return
                end
                local user_id = userInfo.user_id
                if zstring.tonumber(userInfo.shield_user_id) ~= 0 then
                    user_id = userInfo.shield_user_id
                end
                
                -- DSC统一玩家详情界面
                if __lua_project_id == __lua_project_l_digital then
                    OpenOtherUserInformation(user_id, nil, nil)
                else
                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                local cell = ChatFriendInfo:createCell()
                                cell:init(currCell._info.user_id, types, currCell)
                                fwin:open(cell, fwin._windows)
                            end
                        end
                    end
                    protocol_command.see_user_info.param_list = user_id
                    NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, currCell, responseShowUserInfoCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --领取耐力
        local sm_friend_cell_recived_food_terminal = {
            _name = "sm_friend_cell_recived_food",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local draw_number = 0
                for i, v in pairs(_ED.endurance_init_info.get_info) do
                    if tonumber(v.draw_state) == 1 then
                        draw_number = draw_number + 1
                    end
                end
                local max_draw_strength = tonumber(zstring.split(dms.string(dms["friend_config"], 4, friend_config.param), ",")[1])
                if draw_number >= max_draw_strength then
                    TipDlg.drawTextDailog(_string_piece_info[326])
                    return
                end
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_endurance")
                        state_machine.excute("sm_friend_list_update_other_info", 0, nil)
                    else
                        state_machine.excute("sm_friend_list_request_refresh", 0, nil)
                    end
                end
                protocol_command.draw_endurance.param_list = cell._info.id.."\r\n".."1"
                NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --同意
        local sm_friend_cell_argee_friend_terminal = {
            _name = "sm_friend_cell_argee_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_friend_apply_update", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_apply")
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
                    end
                end
                protocol_command.friend_pass.param_list = cell._info.user_id .."\r\n".."1"
                NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --拒绝
        local sm_friend_cell_refrue_terminal = {
            _name = "sm_friend_cell_refrue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_apply")
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
                        state_machine.excute("sm_friend_apply_update", 0, nil)
                    end
                end
                protocol_command.friend_pass.param_list = cell._info.user_id .."\r\n".."2"
                NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --申请好友
        local sm_friend_cell_request_friend_terminal = {
            _name = "sm_friend_cell_request_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local name = cell._info.name
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            TipDlg.drawTextDailog(_string_piece_info[259].._string_piece_info[260])
                            response.node._info.isApplyEd = true
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.friend_request.param_list = cell._info.user_id .."\r\n".."1"
                NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --恢复好友
        local sm_friend_cell_recovery_friend_terminal = {
            _name = "sm_friend_cell_recovery_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local userID = cell._info.shield_user_id
                for i, v in pairs(_ED.black_user) do
                    if tonumber(v.shield_user_id) == tonumber(userID) then
                        local function responseRemoveBlackManCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                _ED.black_user[i] = nil
                                local remainNum = tonumber(_ED.black_user_num) - 1
                                _ED.black_user_num = remainNum and remainNum < 0 and 0 or remainNum
                                state_machine.excute("sm_friend_black_list_update", 0, nil)
                                state_machine.excute("sm_friend_list_request_refresh", 0, nil)
                            end
                        end
                        protocol_command.remove_black.param_list = ""..userID
                        NetworkManager:register(protocol_command.remove_black.code, nil, nil, nil, cell, responseRemoveBlackManCallback, false, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_friend_cell_send_food_terminal)
        state_machine.add(sm_friend_cell_click_head_terminal)
        state_machine.add(sm_friend_cell_recived_food_terminal)
        state_machine.add(sm_friend_cell_argee_friend_terminal)
        state_machine.add(sm_friend_cell_refrue_terminal)
        state_machine.add(sm_friend_cell_request_friend_terminal)
        state_machine.add(sm_friend_cell_recovery_friend_terminal)
        state_machine.init()
    end
	init_sm_friend_cell_terminal()        	
end

function SmFriendCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self._info.headFrameID,
        headFrameStage = self._info.headFrameStage,
        headID = self._info.lead_mould_id,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function SmFriendCell:onHeadDraw()
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)

    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end

    local quality_path = ""
    local big_icon_path = ""
    local picIndex = self._info.lead_mould_id
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    if tonumber(self._info.vip_grade) > 0 then
        quality_path = "images/ui/quality/icon_enemy_5.png"
    else
        quality_path = "images/ui/quality/icon_enemy_1.png"
    end
    if __lua_project_id == __lua_project_l_digital then
        Panel_head:setBackGroundImage(big_icon_path)
        if Panel_ditu ~= nil then
            Panel_ditu:setBackGroundImage(quality_path)
        end
    else
        Panel_kuang:setBackGroundImage(big_icon_path)
        Panel_head:setBackGroundImage(quality_path)
    end
    
    Panel_head:setSwallowTouches(false)
    local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then 
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__epoint.y - __spoint.y) <= 8 then
                if nil ~= sender._self._info then
                    state_machine.excute("sm_friend_cell_click_head",0,{_datas = {_cell = sender._self}})
                end
            end
        end
    end
    Panel_head:addTouchEventListener(fourOpenTouchEvent)    
    Panel_head._self = self
    return roots
end

function SmFriendCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_name_vip_lv = ccui.Helper:seekWidgetByName(root, "Text_name_vip_lv")
    Text_name_vip_lv:setString("")
    Text_name_vip_lv:removeAllChildren(true)

    -- DSC重塑使用UI配置的文本颜色
    if __lua_project_id == __lua_project_l_digital then
        local infoStr = self._info.name
        if tonumber(self._info.vip_grade) > 0 then
            infoStr = infoStr .. "  " .. string.format(_new_interface_text[46], tonumber(self._info.vip_grade))
        end
        infoStr = infoStr .. "  " .. string.format(red_alert_all_str[117], self._info.grade)

        Text_name_vip_lv:setString(infoStr)
    else
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)

        local color1 = cc.c3b(255, 255, 255)
        local color2 = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
        if __lua_project_id == __lua_project_l_naruto then
            color1 = cc.c3b(_naruto_tips_color[1][1], _naruto_tips_color[1][2], _naruto_tips_color[1][3])
            color2 = cc.c3b(_naruto_tips_color[2][1], _naruto_tips_color[2][2], _naruto_tips_color[2][3])
        end
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            color1 = cc.c3b(71, 71, 71)
            color2 = cc.c3b(254,205,61)
        end

        local fontName = Text_name_vip_lv:getFontName()
        local fontSize = Text_name_vip_lv:getFontSize()
        local re0 = ccui.RichElementText:create(1, color1, 255, self._info.name.."  ", fontName, fontSize)
        local re1 = nil
        if tonumber(self._info.vip_grade) > 0 then
            if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and zstring.tonumber(_ED.server_review) == 1 then
            else
                re1 = ccui.RichElementText:create(1, color2, 255, string.format(_new_interface_text[46],tonumber(self._info.vip_grade)), fontName, fontSize)
            end
        end
        local re2 = ccui.RichElementText:create(1, color1, 255, "  "..string.format(red_alert_all_str[117], self._info.grade), fontName, fontSize)

        _richText:pushBackElement(re0)
        if re1 ~= nil then
            _richText:pushBackElement(re1)
        end
        _richText:pushBackElement(re2)

        _richText:setContentSize(Text_name_vip_lv:getContentSize())
        _richText:setAnchorPoint(cc.p(0, 0))
        if _ED.is_can_use_formatTextExt == false then
            _richText:setPosition( cc.p(-_richText:getContentSize().width / 2 , -_richText:getContentSize().height / 2))
        else
            _richText:formatTextExt()
            _richText:setPosition(cc.p(0, 0))
        end
        local bsize = Text_name_vip_lv:getContentSize()
        Text_name_vip_lv:addChild(_richText)
    end

    local recommendFight = tonumber(self._info.fighting)
    if recommendFight >= 10000 then
        recommendFight = math.floor(recommendFight / 1000).. "K"
    end
    ccui.Helper:seekWidgetByName(root, "Text_16"):setString(recommendFight)

    local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
    Panel_13:removeAllChildren(true)
    Panel_13:setTouchEnabled(false)
    
	local headIcon = nil
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		headIcon = self:getNewHeadIcon()
	else
		headIcon = self:onHeadDraw()
	end
    Panel_13:addChild(headIcon)

    if self.types ~= 4 then
        local times = self._info.leave_time + os.time() - self._info.begin_time
        local str = ""
        local hour = math.floor(tonumber(times)/3600)
        local mins = math.floor((tonumber(times)%3600)/60)
        local day = ""
        if tonumber(times) == 0 or (mins < 1 and hour == 0) then
            str = _string_piece_info[268]
        elseif hour < 1 then
            str = _string_piece_info[269] .. mins .. _string_piece_info[270]
        elseif hour >= 1 and hour < 24 then
            str = _string_piece_info[269] .. hour .._string_piece_info[271]
        elseif hour >= 24 and hour < 168 then
            str = _string_piece_info[269] .. math.ceil(hour / 24) .._string_piece_info[231]
        elseif hour >= 168 then
            str = _string_piece_info[269] .. 1 .._string_piece_info[272]
        end
        ccui.Helper:seekWidgetByName(root, "Text_13"):setString(str)
    end

    ccui.Helper:seekWidgetByName(root, "Panel_list_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_list_2"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_198"):setVisible(false)
    -- 黑名单容器
    local Panel_list_3 = ccui.Helper:seekWidgetByName(root, "Panel_list_3")
    if Panel_list_3 ~= nil then
        Panel_list_3:setVisible(false)
    end

    if self.types == 1 then
        ccui.Helper:seekWidgetByName(root, "Panel_list_1"):setVisible(true)
        local Button_106 = ccui.Helper:seekWidgetByName(root, "Button_106")
        local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
        local Image_203 = ccui.Helper:seekWidgetByName(root, "Image_203")
        if tonumber(self._info.is_send) == 0 then
            Button_11:setVisible(true)
            Button_106:setVisible(false)
            Image_203:setVisible(false)
        else
            Button_11:setVisible(false)
            Image_203:setVisible(true)
            Button_106:setVisible(false)
        end
        for i, v in pairs(_ED.endurance_init_info.get_info) do
            if tonumber(v.user_id) == tonumber(self._info.user_id) then
                self._info.id = v.id
                if tonumber(v.draw_state) == 0 then
                    Button_106:setVisible(true)
                end
            end
        end
    elseif self.types == 2 then
        ccui.Helper:seekWidgetByName(root, "Panel_list_2"):setVisible(true)
        local Button_apply = ccui.Helper:seekWidgetByName(root, "Button_apply")
        local Image_applied = ccui.Helper:seekWidgetByName(root, "Image_applied")
        if self._info.isApplyEd == true then
            Image_applied:setVisible(true)
            Button_apply:setVisible(false)
        else
            Image_applied:setVisible(false)
            Button_apply:setVisible(true)
        end
    elseif self.types == 3 then
        ccui.Helper:seekWidgetByName(root, "Panel_198"):setVisible(true)
        local Button_106_0_0_0 = ccui.Helper:seekWidgetByName(root, "Button_106_0_0_0")
        local Button_106_0_0 = ccui.Helper:seekWidgetByName(root, "Button_106_0_0")
        Button_106_0_0_0:setVisible(true)
        Button_106_0_0:setVisible(true)
    elseif self.types == 4 then
        -- 此时为黑名单
        Panel_list_3:setVisible(true)
        local Button_shielding = ccui.Helper:seekWidgetByName(root, "Button_shielding")
        Button_shielding:setVisible(true)
    end
end

function SmFriendCell:onEnterTransitionFinish()

end

function SmFriendCell:onInit()
	local root = cacher.createUIRef("friend/friend_list.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if SmFriendCell.__size == nil then
		SmFriendCell.__size = root:getContentSize()
	end

    root:setTouchEnabled(true)
    root:setSwallowTouches(false)

    local function touchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then 
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__epoint.y - __spoint.y) <= 8 then
                state_machine.excute("sm_friend_cell_click_head", 0, {_datas = {_cell = self}})
            end
        end
    end
    root:addTouchEventListener(touchEvent)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106"), nil, 
    {
        terminal_name = "sm_friend_cell_recived_food", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
    {
        terminal_name = "sm_friend_cell_send_food",
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_apply"), nil, 
    {
        terminal_name = "sm_friend_cell_request_friend", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0_0"), nil, 
    {
        terminal_name = "sm_friend_cell_refrue", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0"), nil, 
    {
        terminal_name = "sm_friend_cell_argee_friend", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shielding"), nil, 
    {
        terminal_name = "sm_friend_cell_recovery_friend", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)

	self:onUpdateDraw()
end

function SmFriendCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("friend/friend_list.csb", root)
end

function SmFriendCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmFriendCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("email/friend_list.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function SmFriendCell:clearUIInfo( ... )
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
        if Label_l_order_level._x then
            Label_l_order_level:setPositionX(Label_l_order_level._x)
        end
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
    root = self.roots[1]
    local Text_name_vip_lv = ccui.Helper:seekWidgetByName(root, "Text_name_vip_lv")
    if Text_name_vip_lv ~= nil then
        Text_name_vip_lv:setString("")
        Text_name_vip_lv:removeAllChildren(true)
    end
    local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
    if Panel_13 ~= nil then
        Panel_13:removeAllChildren(true)
    end
end

function SmFriendCell:init(params)
	self.types = params[1]
    self._info = params[2]
    -- if params[3] ~= nil and params[3] < 5 then
        self:onInit()
    -- end
	self:setContentSize(SmFriendCell.__size)
    return self
end

