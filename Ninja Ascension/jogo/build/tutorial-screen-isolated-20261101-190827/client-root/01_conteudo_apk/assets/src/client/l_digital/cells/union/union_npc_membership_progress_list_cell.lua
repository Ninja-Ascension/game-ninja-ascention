--------------------------------------------------------------------------------------------------------------
--  说明：公会会员进度list
--------------------------------------------------------------------------------------------------------------
UnionNpcMembershipProgressListCell = class("UnionNpcMembershipProgressListCellClass", Window)
UnionNpcMembershipProgressListCell.__size = nil
function UnionNpcMembershipProgressListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
    
	 -- Initialize union rank list cell state machine.
    local function init_union_npc_membership_progress_list_cell_terminal()

        local union_npc_membership_progress_list_cell_see_user_terminal = {
            _name = "union_npc_membership_progress_list_cell_see_user",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local userID = params._datas.userID
                
				-- DSC统一玩家详情界面
                if __lua_project_id == __lua_project_l_digital then
				    OpenOtherUserInformation(userID, nil, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_npc_membership_progress_list_cell_see_user_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_npc_membership_progress_list_cell_terminal()

end

function UnionNpcMembershipProgressListCell:updateDraw()
	local root = self.roots[1]
	local Panel_wj_icon = ccui.Helper:seekWidgetByName(root, "Panel_wj_icon")
	Panel_wj_icon:removeAllChildren(true)
	local headIcon = nil
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		headIcon = self:getNewHeadIcon()
	else
		headIcon = self:onHeadDraw(1, 1, self.example.user_head, self.example.vipLevel)
	end
	Panel_wj_icon:addChild(headIcon)
	local Text_wj_name = ccui.Helper:seekWidgetByName(root, "Text_wj_name")
	Text_wj_name:setString(self.example.name)
	local Text_wj_lv = ccui.Helper:seekWidgetByName(root, "Text_wj_lv")
	Text_wj_lv:setString("Lv."..self.example.level)
	local Text_wj_zhiwei = ccui.Helper:seekWidgetByName(root, "Text_wj_zhiwei")
	if tonumber(self.example.post) >2 then
		Text_wj_zhiwei:setString(union_job_title[3])
	else
		Text_wj_zhiwei:setString(union_job_title[tonumber(self.example.post)])
	end
	local maxBattleNumber = dms.int(dms["union_config"], 21, union_config.param)
	local Text_wj_jd = ccui.Helper:seekWidgetByName(root, "Text_wj_jd")
	Text_wj_jd:setString(tonumber(self.example.guild_battle).."/"..maxBattleNumber)

	if tonumber(self.example.guild_battle) == 3 then
        Text_wj_jd:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then

        else
            Text_wj_jd:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
	end
	for i=1, 3 do
		ccui.Helper:seekWidgetByName(root, "Image_jd_"..i):setVisible(false)
	end

	for i=1, tonumber(self.example.guild_battle) do
		ccui.Helper:seekWidgetByName(root, "Image_jd_"..i):setVisible(true)
	end
end

function UnionNpcMembershipProgressListCell:getNewHeadIcon()
    
	local headIconInfo = {
        headFrameID = self.example.headFrameID,
        headFrameStage = self.example.headFrameStage,
        headID = self.example.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function UnionNpcMembershipProgressListCell:onHeadDraw(userId, quality, headIndex, vipLevel)
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
    
    -- fwin:addTouchEventListener(Panel_head, nil, 
    -- {
    --     terminal_name = "union_the_meeting_place_member_cell_look_info",
    --     unionData = self.unionData,
    --     terminal_state = 0,
    -- }, 
    -- nil, 0)
    return roots
end

function UnionNpcMembershipProgressListCell:onInit()

	local csbUnionNpcMembershipProgressListCell= csb.createNode("legion/sm_legion_pve_window_progress_list.csb")
    local root = csbUnionNpcMembershipProgressListCell:getChildByName("root")
    table.insert(self.roots, root)
	 
    self:addChild(csbUnionNpcMembershipProgressListCell)
	if UnionNpcMembershipProgressListCell.__size == nil then
		UnionNpcMembershipProgressListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

    -- DSC统一玩家详情界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_wj_icon"), nil, 
    {
        terminal_name = "union_npc_membership_progress_list_cell_see_user",
        userID = self.example.id,
        terminal_state = 0,
    },
    nil,0)
	self:updateDraw()
end

function UnionNpcMembershipProgressListCell:onEnterTransitionFinish()

end

function UnionNpcMembershipProgressListCell:init(example,index,last)
	self.example = example
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(UnionNpcMembershipProgressListCell.__size)
	-- self:onInit()
	return self
end

function UnionNpcMembershipProgressListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionNpcMembershipProgressListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_pve_window_progress_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionNpcMembershipProgressListCell:clearUIInfo( ... )
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
	local Panel_wj_icon = ccui.Helper:seekWidgetByName(root, "Panel_wj_icon")
    if Panel_wj_icon ~= nil then
        Panel_wj_icon:removeAllChildren(true)
    end
end

function UnionNpcMembershipProgressListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_pve_window_progress_list.csb", self.roots[1])
end

function UnionNpcMembershipProgressListCell:createCell()
	local cell = UnionNpcMembershipProgressListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
