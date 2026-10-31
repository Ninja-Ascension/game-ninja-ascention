--------------------------------------------------------------------------------------------------------------
--  说明：黑名单cell
--------------------------------------------------------------------------------------------------------------
PlayerSystemSetBackListCell = class("PlayerSystemSetBackListCellClass", Window)
PlayerSystemSetBackListCell.__size = nil
function PlayerSystemSetBackListCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.index = 0
	 -- Initialize union duplicate clearance reward list cell state machine.
    local function init_player_system_set_backList_cell_terminal()
        --移除
        local player_system_set_backList_remove_terminal = {
            _name = "player_system_set_backList_remove",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                state_machine.excute("sm_playersystem_set_backList_remove",0,cell.friend.user_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(player_system_set_backList_remove_terminal)
        state_machine.init()
    end
    init_player_system_set_backList_cell_terminal()

end

function PlayerSystemSetBackListCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.friend.headFrameID,
        headFrameStage = self.friend.headFrameStage,
        headID = self.friend.lead_mould_id,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function PlayerSystemSetBackListCell:updateDraw()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    Panel_player_icon:removeAllChildren(true)

    
	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		local headIcon = self:getNewHeadIcon()
		if headIcon ~= nil then
			Panel_player_icon:addChild(headIcon)
		end
    else
        -- local csbItem = csb.createNode("icon/item.csb")
        -- local roots = csbItem:getChildByName("root")
        local roots = cacher.createUIRef("icon/item.csb", "root")
        table.insert(self.roots, roots)
        roots:removeFromParent(true)
        self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
        if self.item_order_level._x == nil then
            self.item_order_level._x = self.item_order_level:getPositionX()
        end
    
        local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
        local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
        local quality_path = ""
        if tonumber(self.friend.vip_grade) > 0 then
            quality_path = "images/ui/quality/quality_frame_14.png"
        else
            quality_path = "images/ui/quality/quality_frame_1.png"
        end
    
        local big_icon_path = nil
        local picIndex = self.friend.lead_mould_id
        if tonumber(picIndex) < 9 then
            big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
        else
            big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
        end
        Panel_kuang:setBackGroundImage(quality_path)
        Panel_head:setBackGroundImage(big_icon_path)
        
        Panel_player_icon:addChild(roots)
    end
    --名字
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    Text_player_name:setString(self.friend.name)
    --等级
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n")
    Text_player_lv_n:setString(self.friend.grade)
end

function PlayerSystemSetBackListCell:onInit()
    local root = cacher.createUIRef("player/role_information_blacklist_list.csb","root")
    table.insert(self.roots, root)
    self:addChild(root)
    if PlayerSystemSetBackListCell.__size == nil then
        local Panel_22 = ccui.Helper:seekWidgetByName(root, "Panel_22")
        PlayerSystemSetBackListCell.__size = Panel_22:getContentSize()
    end
    local Button_del = ccui.Helper:seekWidgetByName(root, "Button_del")
    fwin:addTouchEventListener(Button_del,  nil, 
    {
        terminal_name = "player_system_set_backList_remove",
        terminal_state = 0,
        _cell = self,
    }, 
    nil, 0)
    
	self:updateDraw()
end

function PlayerSystemSetBackListCell:onEnterTransitionFinish()

end

function PlayerSystemSetBackListCell:init(friend)
    self.friend = friend
	self:onInit()
    self:setContentSize(PlayerSystemSetBackListCell.__size)
	return self
end

function PlayerSystemSetBackListCell:clearUIInfo( ... )
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
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    if Panel_player_icon ~= nil then
        Panel_player_icon:removeAllChildren(true)
    end
end

function PlayerSystemSetBackListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("player/role_information_blacklist_list.csb", self.roots[1])
end

function PlayerSystemSetBackListCell:createCell()
	local cell = PlayerSystemSetBackListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
