-- ----------------------------------------------------------------------------------------------------
-- 说明：工会大冒险排行的控件
-------------------------------------------------------------------------------------------------------

UnionAdventureRankListCell = class("UnionAdventureRankListCellClass", Window)
UnionAdventureRankListCell.__size = nil

local union_adventure_rank_list_cell_creat_terminal = {
    _name = "union_adventure_rank_list_cell_creat",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = UnionAdventureRankListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_adventure_rank_list_cell_creat_terminal)
state_machine.init()

    
function UnionAdventureRankListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._index = 0
	self.reward_type = 0

    local function init_union_adventure_rank_list_cell_terminal()
	
		local union_adventure_rank_list_cell_updata_terminal = {
            _name = "union_adventure_rank_list_cell_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas._cell
				cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		local union_adventure_rank_list_cell_check_terminal = {
            _name = "union_adventure_rank_list_cell_check",
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
	
		state_machine.add(union_adventure_rank_list_cell_updata_terminal)
		state_machine.add(union_adventure_rank_list_cell_check_terminal)
        state_machine.init()
    end

    init_union_adventure_rank_list_cell_terminal()
end

function UnionAdventureRankListCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.datas.headFrameID,
        headFrameStage = self.datas.headFrameStage,
        headID = self.datas.user_head_id,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)

    return headIcon
end

function UnionAdventureRankListCell:onHeadDraw(headIndex, vipLevel)
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
    local quality_path = 0
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
    return roots
end

function UnionAdventureRankListCell:onUpdateDraw()
	local root = self.roots[1]
	for i=1, 3 do
        local Image_ranking = ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i)
        Image_ranking:setVisible(false)
    end
    local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
    if tonumber(self.datas.user_rank) < 3 then
        Text_ranking:setString("")
        ccui.Helper:seekWidgetByName(root, "Image_ranking_"..self.datas.user_rank):setVisible(true)
    else
        Text_ranking:setString(self.datas.user_rank)
    end

    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    Panel_player_icon:removeAllChildren(true)
    
    local headIcon = nil
	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
        headIcon = self:getNewHeadIcon()
    else
        headIcon = self:onHeadDraw(self.datas.user_head_id, self.datas.user_vip_level)
    end
    Panel_player_icon:addChild(headIcon)
    
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    Text_player_name:setString(self.datas.user_name)

    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    Text_number:setString(self.datas.number)
    
end

function UnionAdventureRankListCell:onEnterTransitionFinish()

end

function UnionAdventureRankListCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_adventure_rank_list.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if UnionAdventureRankListCell.__size == nil then
		UnionAdventureRankListCell.__size = root:getContentSize()
	end
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_247"), nil, 
    {
        terminal_name = "union_adventure_rank_list_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		userID = self.datas.user_id,
    }, nil, 1)
	self:onUpdateDraw()
end

function UnionAdventureRankListCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_adventure_rank_list.csb", root)
end

function UnionAdventureRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionAdventureRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_adventure_rank_list.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function UnionAdventureRankListCell:clearUIInfo( ... )
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

function UnionAdventureRankListCell:init(params)
    self.datas = params[1]
	self.index = params[2]
	self:onInit()
	self:setContentSize(UnionAdventureRankListCell.__size)
    return self
end
