--------------------------------------------------------------------------------------------------------------
--  说明：老虎机排行榜
--------------------------------------------------------------------------------------------------------------
unionSlotMachineLuckDrawRank = class("unionSlotMachineLuckDrawRankClass", Window)
unionSlotMachineLuckDrawRank.__size = nil
function unionSlotMachineLuckDrawRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.cells.utils.resources_icon_cell")

	 -- Initialize union rank list cell state machine.
    local function init_union_slot_machine_luck_draw_rank_terminal()
		local union_slot_machine_luck_draw_rank_check_terminal = {
            _name = "union_slot_machine_luck_draw_rank_check",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local userID = params._datas.useID
                -- DSC统一玩家详情界面
                if __lua_project_id == __lua_project_l_digital then
                    OpenOtherUserInformation(userID, nil, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(union_slot_machine_luck_draw_rank_check_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_slot_machine_luck_draw_rank_terminal()

end

function unionSlotMachineLuckDrawRank:updateDraw()
	local root = self.roots[1]

	--排行
	local Text_ranking = ccui.Helper:seekWidgetByName(root,"Text_ranking")
	for i=1,3 do
		ccui.Helper:seekWidgetByName(root,"Image_ranking_"..i):setVisible(false)
	end
	if self.index <=3 then
		ccui.Helper:seekWidgetByName(root,"Image_ranking_"..self.index):setVisible(true)
		Text_ranking:setString("")
	else
		Text_ranking:setString(self.index)
	end

	--头像
	local Panel_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_icon")
	Panel_player_icon:removeAllChildren(true)

    local headIcon = nil
	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
        headIcon = self:getNewHeadIcon()
    else
        headIcon = self:onHeadDraw(0, self.rankData.user_head, self.rankData.vipLevel)
    end
	Panel_player_icon:addChild(headIcon)

	--名称
	local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name")
	Text_player_name:setString(self.rankData.user_name)
	--道具
	local Panel_reward_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_reward_icon_2")
	Panel_reward_icon_2:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    cell:init(6, 0, 19,nil,nil)
    Panel_reward_icon_2:addChild(cell)
	--数量
	local Text_reward_n = ccui.Helper:seekWidgetByName(root,"Text_reward_n")
	Text_reward_n:setString("x"..self.rankData.max_number)
	--次数
	local Text_number = ccui.Helper:seekWidgetByName(root,"Text_number")
	Text_number:setString(self.rankData.get_number)
end

function unionSlotMachineLuckDrawRank:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.rankData.headFrameID,
        headFrameStage = self.rankData.headFrameStage,
        headID = self.rankData.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)

    return headIcon
end

function unionSlotMachineLuckDrawRank:onHeadDraw(quality, headIndex, vipLevel)
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
    
    fwin:addTouchEventListener(Panel_head, nil, 
    {
        terminal_name = "",
        unionData = self.unionData,
        terminal_state = 0,
    }, 
    nil, 0)
    return roots
end

function unionSlotMachineLuckDrawRank:onInit()

	local csbunionSlotMachineLuckDrawRank= csb.createNode("legion/sm_legion_luck_draw_rank_list.csb")
    local root = csbunionSlotMachineLuckDrawRank:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionSlotMachineLuckDrawRank)
	if unionSlotMachineLuckDrawRank.__size == nil then
		unionSlotMachineLuckDrawRank.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_247"), nil, 
    {
        terminal_name = "union_slot_machine_luck_draw_rank_check", 
        terminal_state = 0, 
        touch_black = true,
        useID = self.rankData.user_id
    }, nil, 1)
	self:updateDraw()
end

function unionSlotMachineLuckDrawRank:onEnterTransitionFinish()

end

function unionSlotMachineLuckDrawRank:init(datas,index)
	self.rankData = datas
	self.index = tonumber(index)
	self:onInit()
	self:setContentSize(unionSlotMachineLuckDrawRank.__size)
	-- self:onInit()
	return self
end

function unionSlotMachineLuckDrawRank:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionSlotMachineLuckDrawRank:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_luck_draw_rank_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function unionSlotMachineLuckDrawRank:clearUIInfo( ... )
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
	local Panel_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_icon")
    if Panel_player_icon ~= nil then
        Panel_player_icon:removeAllChildren(true)
    end
end

function unionSlotMachineLuckDrawRank:onExit()
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("legion/sm_legion_luck_draw_rank_list.csb", self.roots[1])
end

function unionSlotMachineLuckDrawRank:createCell()
	local cell = unionSlotMachineLuckDrawRank:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
