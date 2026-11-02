--------------------------------------------------------------------------------------------------------------
--  说明：能量屋的工会成员信息
--------------------------------------------------------------------------------------------------------------
unionEnergyHouseMember = class("unionEnergyHouseMemberClass", Window)
unionEnergyHouseMember.__size = nil
function unionEnergyHouseMember:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0

    self.leave_times = 0
    self.member_leave_times = 0

	app.load("client.cells.ship.ship_head_new_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_energy_house_member_terminal()
        local union_energy_house_member_select_view_training_terminal = {
            _name = "union_energy_house_member_select_view_training",
            _init = function (terminal)
               app.load("client.l_digital.union.meeting.SmUnionEnergyHouseMemberWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                if cell.leave_times == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[194])
                    return
                end
                if cell.member_leave_times == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[203])
                    return
                end
            	state_machine.excute("sm_union_energy_house_member_window_open", 0, cell.member)
            	-- local shipData = zstring.split(self.training_info,",")
           		-- local function responseUnionCreateCallback(response)
                    -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	-- state_machine.excute("sm_union_my_campsite_update_draw_cell", 0, cell.index)
                    	-- state_machine.excute("sm_union_energy_house_select_close", 0, "")
                    -- end
                -- end
           		-- protocol_command.union_ship_train.param_list = cell.index.."\r\n"..cell.ship.ship_id --实例id
                -- NetworkManager:register(protocol_command.union_ship_train.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local union_energy_house_member_see_user_terminal = {
            _name = "union_energy_house_member_see_user",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local userID = params._datas.userID
                
				-- DSC统一玩家详情界面
                OpenOtherUserInformation(userID, nil, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_energy_house_member_select_view_training_terminal)
		state_machine.add(union_energy_house_member_see_user_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_energy_house_member_terminal()

end

function unionEnergyHouseMember:updateDraw()
	local root = self.roots[1]
	local memberInfo = nil
	for i, v in pairs(_ED.union.union_member_list_info) do
		if tonumber(self.member.member_id) == tonumber(v.id) then
			memberInfo = v
			break
		end
	end
	self.member.memberInfo = memberInfo
	--头像
	local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4")
	Panel_4:removeAllChildren(true)

    local headIcon = nil
	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
        headIcon = self:getNewHeadIcon()
        
        if self.unionData ~= nil then
            fwin:addTouchEventListener(Panel_4, nil, 
            {
                terminal_name = "union_the_meeting_place_member_cell_look_info",
                unionData = self.unionData,
                terminal_state = 0,
            }, 
            nil, 0)
        end
    else
        headIcon = self:onHeadDraw(memberInfo.id, memberInfo.quality, memberInfo.user_head, memberInfo.vipLevel)
    end
    if headIcon ~= nil then
        Panel_4:addChild(headIcon)
    end
    -- DSC统一玩家详情界面
    if __lua_project_id == __lua_project_l_digital then
        fwin:addTouchEventListener(Panel_4, nil, 
        {
            terminal_name = "union_energy_house_member_see_user",
            userID = self.member.member_id,
            terminal_state = 0,
        },
        nil,0)
    end

	--名称
	local Text_member_name = ccui.Helper:seekWidgetByName(root,"Text_member_name")
	Text_member_name:setString(memberInfo.name)
	--等级
	local Text_member_lv = ccui.Helper:seekWidgetByName(root,"Text_member_lv")
	Text_member_lv:setString("Lv."..memberInfo.level)

    -- 剩余次数
    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
    local accelerate = zstring.split(my_data[1],",")
    local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
    self.leave_times = tonumber(param[1])-tonumber(accelerate[1])

    -- 被加速剩余次数
    local member_data = zstring.split(self.member.member_data,"|")
    local count_info = zstring.split(member_data[1],",")
    self.member_leave_times = tonumber(param[2]) - tonumber(count_info[2])

    local Button_wtjs = ccui.Helper:seekWidgetByName(root,"Button_wtjs")
    Button_wtjs:setTouchEnabled(true)
    Button_wtjs:setBright(true)
    if self.member_leave_times <= 0 or self.leave_times <= 0 then
        Button_wtjs:setBright(false)
    end
end

function unionEnergyHouseMember:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.member.memberInfo.headFrameID,
        headFrameStage = self.member.memberInfo.headFrameStage,
        headID = self.member.memberInfo.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)

    return headIcon
end

function unionEnergyHouseMember:onHeadDraw(userId, quality, headIndex, vipLevel)
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
    -- if tonumber(vipLevel) > 0 then
    --     ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
    -- end
    
    fwin:addTouchEventListener(Panel_head, nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_look_info",
        unionData = self.unionData,
        terminal_state = 0,
    }, 
    nil, 0)
    return roots
end

function unionEnergyHouseMember:onInit()

	local csbunionEnergyHouseMember= csb.createNode("legion/sm_legion_energy_house_member.csb")
    local root = csbunionEnergyHouseMember:getChildByName("root")
    table.insert(self.roots, root)
	 
    self:addChild(csbunionEnergyHouseMember)
	if unionEnergyHouseMember.__size == nil then
		unionEnergyHouseMember.__size = root:getChildByName("Panel_3"):getContentSize()
	end	
	
	--进入选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wtjs"), nil, 
    {
        terminal_name = "union_energy_house_member_select_view_training", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self
    }, 
    nil, 0)

	self:updateDraw()
end

function unionEnergyHouseMember:onEnterTransitionFinish()

end

function unionEnergyHouseMember:init(member,index)
	self.index = tonumber(index)
	self.member = member
	self:onInit()
	self:setContentSize(unionEnergyHouseMember.__size)
	-- self:onInit()
	return self
end

function unionEnergyHouseMember:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionEnergyHouseMember:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_energy_house_member.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function unionEnergyHouseMember:clearUIInfo( ... )
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
    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4")
    if Panel_4 ~= nil then
        Panel_4:removeAllChildren(true)
    end
end

function unionEnergyHouseMember:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_energy_house_member.csb", self.roots[1])
end

function unionEnergyHouseMember:createCell()
	local cell = unionEnergyHouseMember:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
