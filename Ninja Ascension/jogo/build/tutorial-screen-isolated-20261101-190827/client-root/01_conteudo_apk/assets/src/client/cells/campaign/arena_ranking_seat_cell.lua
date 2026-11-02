-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场 排行榜seat
-- 创建时间：2015-03-30
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaRankingSeatCell = class("ArenaRankingSeatCellClass", Window)
ArenaRankingSeatCell.__size = nil
function ArenaRankingSeatCell:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.cells.campaign.icon.arena_role_icon_cell")
	
	self.roleInstance = nil
	
	-- role icon
	self.roleIconPanel = nil
	-- 奖励荣誉值
	self.cacheHonorText = nil
	-- 奖励道具数量
	self.cacheItemNumsText = nil
	-- 奖励银币
	self.cacheMoneyText = nil
	-- name text
	self.cacheNameText = nil
	-- lv
	self.cacheLvText = nil
	-- 查看详情
	self.cacheReviewBtn = nil
	-- 排行
	self.cacheRankText = nil
	
    -- Initialize ArenaRankingSeatCell page state machine.
    local function init_arena_ladder_seat_terminal()
	
		-- local arena_back_activity_terminal = {
            -- _name = "arena_back_activity",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
                
				-- fwin:open(Campaign:new(), fwin._view)
				-- fwin:close(instance)

                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(arena_back_activity_terminal)
        -- state_machine.add(arena_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_seat_terminal()
end

function ArenaRankingSeatCell:initDraw()

	local root = self.roots[1]
	local role = self.roleInstance
	local shipTID = self.roleInstance.user_template[1]
	self.roleIconPanel:removeAllChildren(true)
	local icon = ArenaRoleIconCell:createCell()
	local  user_icon = nil 
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if role.user_icon ~= nil and zstring.tonumber(role.user_icon) > 0 then
			user_icon = role.user_icon
		end
	end
	if user_icon ~= nil then
		icon:init(shipTID, 1,user_icon)
	else 
		icon:init(shipTID, 1)
	end
	-- icon:init(tonumber(self.roleInstance.user_icon) + 1000, 1)
	self.roleIconPanel:addChild(icon)
	
	local color = dms.string(dms["ship_mould"], shipTID, ship_mould.ship_type)+1
	
	self.cacheNameText:setString(self.roleInstance.user_name)
	self.cacheNameText:setColor(cc.c3b(color_Type[color][1],
		color_Type[color][2],
		color_Type[color][3]))
	
	if verifySupportLanguage(_lua_release_language_en) == true then
		self.cacheLvText:setString(_string_piece_info[6]..self.roleInstance.user_level)
	else
		self.cacheLvText:setString(self.roleInstance.user_level .. _string_piece_info[6])
	end
	
	ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_1st"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_2st"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_3st"):setVisible(false)
	self.cacheRankText:setString("")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Image_jjc_ph_1_0 = ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_1_0")
		local Image_jjc_ph_1 = ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_1")
		
		if tonumber(self.roleInstance.user_rank) < 4 then
			Image_jjc_ph_1:setVisible(true)
			Image_jjc_ph_1_0:setVisible(false)
		else
			Image_jjc_ph_1:setVisible(false)
			Image_jjc_ph_1_0:setVisible(true)
		end
	end
	if tonumber(self.roleInstance.user_rank) == 1 then
		ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_1st"):setVisible(true)
	elseif tonumber(self.roleInstance.user_rank) == 2 then
		ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_2st"):setVisible(true)
	elseif tonumber(self.roleInstance.user_rank) == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_3st"):setVisible(true)
	else
		self.cacheRankText:setString(self.roleInstance.user_rank)
	end
	
	--显示奖励
	local rewardRow = self:getArenaRewardRowForRank(tonumber(self.roleInstance.user_rank))
	local honor = dms.int(dms["arena_reward_param"], rewardRow, arena_reward_param.arena1_reward_bounty)
	local coin = dms.int(dms["arena_reward_param"], rewardRow, arena_reward_param.arena1_reward_silver)
	local itemNums = dms.int(dms["arena_reward_param"], rewardRow, arena_reward_param.arena1_reward_prop_count)
	self.cacheHonorText:setString(honor)
	self.cacheMoneyText:setString(coin)
	self.cacheItemNumsText:setString(itemNums)
	--> print("hggggggghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", honor)
end

function ArenaRankingSeatCell:getArenaRewardRowForRank(userRank)
	for i, v in ipairs(dms["arena_reward_param"]) do
		local minRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_begin)
		local maxRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_end)
		if userRank >= minRank and userRank <= maxRank then
			return i
		end
	end
	return 0
end

function ArenaRankingSeatCell:onEnterTransitionFinish()
	
end

function ArenaRankingSeatCell:onInit()
	local root = cacher.createUIRef("campaign/ArenaStorage/ArenaStorage_ranking_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if ArenaRankingSeatCell.__size == nil then
	 	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_list")
		local MySize = PanelGeneralsEquipment:getContentSize()

	 	ArenaRankingSeatCell.__size = MySize
	end

    -- local csbArenaRankingSeat = csb.createNode("campaign/ArenaStorage/ArenaStorage_ranking_list.csb")
	-- local root = csbArenaRankingSeat:getChildByName("root")
	-- table.insert(self.roots, root)
    -- self:addChild(csbArenaRankingSeat)
	
	-- 列表控件动画播放
	local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_ranking_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_list")
	-- self:setContentSize(panel:getContentSize())
	-- panel:setSwallowTouches(false)
	
	-- role icon
	self.roleIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_role")
	
	-- 奖励荣誉值
	self.cacheHonorText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_jl_1")
	
	-- 奖励道具数量
	self.cacheItemNumsText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_jl_2")
	
	-- 奖励银币
	self.cacheMoneyText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_jl_3")
	
	-- name text
	self.cacheNameText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_name")
	
	-- lv
	self.cacheLvText = ccui.Helper:seekWidgetByName(root, "Text_7")
	
	-- rank
	self.cacheRankText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_st")
	
	-- 查看详情
	self.cacheReviewBtn = ccui.Helper:seekWidgetByName(root, "Button_jjc_ph_ckzr")
	fwin:addTouchEventListener(self.cacheReviewBtn, 	nil, 
	{
		terminal_name = "arena_ranking_review_opponent", 	
		next_terminal_name = "arena_ranking_review_opponent", 	
		current_button_name = "Button_jjc_ph_ckzr",		
		but_image = "reviwe",
		terminal_state = 0, 
		isPressedActionEnabled = false,
		reviewOpponent = self
	}, 
	nil, 0)
	
	self:initDraw()
end


function ArenaRankingSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRankingSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_ranking_list.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRankingSeatCell:init(role, index)-- 排名 战力值
	if role == -1 then self:setVisible(false) end
	self.roleInstance = role
	
	if index ~= nil and index < 5 then
		self:onInit()
	end
	self:setContentSize(ArenaRankingSeatCell.__size)
	return self
end

function ArenaRankingSeatCell:createCell()
	local cell = ArenaRankingSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function ArenaRankingSeatCell:onExit()
	-- state_machine.remove("arena_back_activity")
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_ranking_list.csb", self.roots[1])
end
