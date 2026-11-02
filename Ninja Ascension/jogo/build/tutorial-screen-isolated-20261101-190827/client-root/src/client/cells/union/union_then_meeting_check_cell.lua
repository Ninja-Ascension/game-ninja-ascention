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
		state_machine.add(union_the_meeting_check_cell_yes_terminal)
		state_machine.add(union_the_meeting_check_cell_no_terminal)
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
            state_machine.excute("union_the_meeting_check_refresh_info", 0, nil)
            if response.node[1] == true then
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceMember")
                else
                    app.load("client.union.meeting.UnionTheMeetingPlaceMember")
                end
                state_machine.excute("union_the_meeting_place_member_refresh_info", 0, "")

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
    local Text_16_zl = ccui.Helper:seekWidgetByName(root, "Text_16_zl"):setString("")
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_12_name"):setString("")
    nameText:setColor(cc.c3b(255, 255, 255))
    if self.infoData == nil then
        return
    end
    local quality = tonumber(self.infoData.quality)
    Panel_13:addChild(self:onHeadDraw(self.infoData.id, quality, self.infoData.user_head, self.infoData.vip))
    Text_3_lv:setString(""..self.infoData.level)
    Text_16_zl:setString(""..self.infoData.capactity)
    nameText:setString(self.infoData.name)
    nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
end

function UnionTheMeetingCheckCell:onHeadDraw(userId, quality, headIndex, vipLevel)
    local csbItem = csb.createNode("icon/item.csb")
    local roots = csbItem:getChildByName("root")
    roots:removeFromParent(true)
    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        if Panel_head ~= nil then
            Panel_head:removeAllChildren(true)
            Panel_head:removeBackGroundImage()
        end
        if Panel_kuang ~= nil then
            Panel_kuang:removeAllChildren(true)
            Panel_kuang:removeBackGroundImage()
        end
    end
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
    local big_icon_path = string.format("images/ui/props/props_%s.png", tonumber(picIndex))
    Panel_kuang:setBackGroundImage(quality_path)
    Panel_head:setBackGroundImage(big_icon_path)
    
    ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(false)
    if tonumber(vipLevel) > 0 then
        ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
    end

    fwin:addTouchEventListener(Panel_head, nil, 
    {
        terminal_name = "fame_hall_list_show_info",     
        _id = userId,
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

    local action = csb.createTimeline("legion/legion_pro_shenhe_list.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("list_view_cell_open", false)

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

	self:updateDraw()
end

function UnionTheMeetingCheckCell:onEnterTransitionFinish()
end

function UnionTheMeetingCheckCell:init(infoData, index)
    self.infoData = infoData
    if index ~= nil and index < 5 then
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
    cacher.freeRef("legion/legion_pro_shenhe_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionTheMeetingCheckCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
    if Panel_13 ~= nil then
        Panel_13:removeAllChildren(true)
    end
end

function UnionTheMeetingCheckCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("legion/legion_pro_shenhe_list.csb", self.roots[1])
end

function UnionTheMeetingCheckCell:createCell()
	local cell = UnionTheMeetingCheckCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
