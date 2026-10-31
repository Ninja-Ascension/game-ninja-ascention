--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅审核申请列表
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingCheckCell = class("UnionTheMeetingCheckCellClass", Window)

UnionTheMeetingCheckCell.__size = nil

function UnionTheMeetingCheckCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.infoData = nil

    self.max = 5
    if __lua_project_id == __lua_project_l_digital then
        self.max = 8
    end
	
	 -- Initialize union the meeting check list cell state machine.
    local function init_union_then_meeting_check_cell_terminal()
		-- 通过审核
		local union_the_meeting_check_cell_yes_terminal = {
            _name = "union_the_meeting_check_cell_yes",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:requestChangePersion(true, params._datas.infoData)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--不通过审核状
		local union_the_meeting_check_cell_no_terminal = {
            _name = "union_the_meeting_check_cell_no",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:requestChangePersion(false, params._datas.infoData)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看玩家信息
         local union_the_meeting_check_cell_look_info_terminal = {
            _name = "union_the_meeting_check_cell_look_info",
            _init = function (terminal)
                -- app.load("client.chat.ChatFriendInfo")
                app.load("client.l_digital.union.meeting.SmUnionPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local infoData = params._datas.infoData
                infoData.vipLevel = infoData.vip
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_union_player_info_window_open", 0, infoData)
                    end
                end
                protocol_command.see_user_info.param_list = params._datas.infoData.id
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, self, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_the_meeting_check_cell_yes_terminal)
        state_machine.add(union_the_meeting_check_cell_no_terminal)
		state_machine.add(union_the_meeting_check_cell_look_info_terminal)
        state_machine.init()
    end
    -- call func init union the meeting check list cell l state machine.
    init_union_then_meeting_check_cell_terminal()

end

function UnionTheMeetingCheckCell:requestChangePersion( isArgree, infoData )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            for k,v in pairs(_ED.union.union_examine_list_info) do
                if v == response.node[2] then
                    table.remove(_ED.union.union_examine_list_info, k)
                    _ED.union.union_examine_list_sum = _ED.union.union_examine_list_sum - 1
                end
            end
            state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_main_window_union_hall")
            state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_main_window_union_examine_apply")
            state_machine.excute("union_the_meeting_check_refresh_info", 0, nil)
            if response.node[1] == true then
                app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceMember")
                state_machine.excute("union_the_meeting_place_member_refresh_info", 0, "")
                -- FURY v47: repintar tambien la lista visible (Informacion Basica).
                state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)

            end    

        end
    end
    local ntype = 0
    if isArgree == true then
        ntype = 1
    else
        ntype = 2
    end
    local persionParam = ""..infoData.id.."\r\n"..ntype
    protocol_command.union_persion_manage.param_list = persionParam
    NetworkManager:register(protocol_command.union_persion_manage.code, nil, nil, nil, {isArgree,infoData}, responseCallback, false, nil)
end

function UnionTheMeetingCheckCell:updateDraw()
    local root = self.roots[1]
    local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
    Panel_13:removeAllChildren(true)
    local Text_3_lv = ccui.Helper:seekWidgetByName(root, "Text_3_lv"):setString("")
    -- local Text_16_zl = ccui.Helper:seekWidgetByName(root, "Text_16_zl"):setString("")
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_12_name"):setString("")
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        
    else
        nameText:setColor(cc.c3b(255, 255, 255))
    end
    if self.infoData == nil then
        return
    end
    local quality = tonumber(self.infoData.quality)
    Panel_13:addChild(self:onHeadDraw(self.infoData.id, quality, self.infoData.user_head, self.infoData.vip))
    Text_3_lv:setString("Lv."..self.infoData.level)
    -- Text_16_zl:setString(""..self.infoData.capactity)
    nameText:setString(self.infoData.name)

    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_legion_pro_shenhe_time")

    Text_time:setString(os.date("%Y"..tipStringInfo_time_info[1]
        .."%m"..tipStringInfo_time_info[2]
        .."%d"..tipStringInfo_time_info[10]
        .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(self.infoData.apply_time)/1000))
    -- nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
end

function UnionTheMeetingCheckCell:onHeadDraw(userId, quality, headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end
    local picIndex = tonumber(headIndex)

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
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
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    
    -- ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(false)

    fwin:addTouchEventListener(Panel_head, nil, 
    {
        terminal_name = "union_the_meeting_check_cell_look_info",     
        infoData = self.infoData,
        terminal_state = 0,
    }, 
    nil, 0)
    return roots
end

function UnionTheMeetingCheckCell:onInit()
    local root = cacher.createUIRef("legion/legion_pro_shenhe_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    if UnionTheMeetingCheckCell.__size == nil then
        UnionTheMeetingCheckCell.__size = root:getContentSize()
    end

    -- local action = csb.createTimeline("legion/legion_pro_shenhe_list.csb")
    -- table.insert(self.actions, action)
    -- root:runAction(action)
    -- action:play("list_view_cell_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0"), nil, 
    {
        terminal_name = "union_the_meeting_check_cell_yes", 
        terminal_state = 0,
        infoData = self.infoData,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0_0"), nil, 
    {
        terminal_name = "union_the_meeting_check_cell_no", 
        terminal_state = 0,
        infoData = self.infoData,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_11"), nil, 
    {
        terminal_name = "union_the_meeting_check_cell_look_info", 
        terminal_state = 0,
        infoData = self.infoData,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    

	self:updateDraw()
end

function UnionTheMeetingCheckCell:onEnterTransitionFinish()
end

function UnionTheMeetingCheckCell:init(infoData, index)
    self.infoData = infoData
    if index ~= nil and index < self.max then
        self:onInit()
    end
    self:setContentSize(UnionTheMeetingCheckCell.__size)
	return self
end

function UnionTheMeetingCheckCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionTheMeetingCheckCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("legion/legion_pro_shenhe_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionTheMeetingCheckCell:clearUIInfo( ... )
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
    end
    local root = self.roots[1]
    local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
    if Panel_13 ~= nil then
        Panel_13:removeAllChildren(true)
    end
end

function UnionTheMeetingCheckCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("legion/legion_pro_shenhe_list.csb", self.roots[1])
end

function UnionTheMeetingCheckCell:createCell()
	local cell = UnionTheMeetingCheckCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
