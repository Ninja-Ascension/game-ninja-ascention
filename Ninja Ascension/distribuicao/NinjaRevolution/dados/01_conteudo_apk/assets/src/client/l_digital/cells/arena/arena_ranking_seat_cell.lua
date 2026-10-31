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
	-- self.cacheHonorText = nil
	-- 奖励道具数量
	-- self.cacheItemNumsText = nil
	-- 奖励银币
	-- self.cacheMoneyText = nil
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
	
		local arena_ladder_seat_show_info_terminal = {
            _name = "arena_ladder_seat_show_info",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cell
				
				-- DSC统一玩家详情界面
				if __lua_project_id == __lua_project_l_digital then
					local userID = tonumber(cells.roleInstance.user_id)
					local robotData = cells:getRobotData(cells.roleInstance)
					OpenOtherUserInformation(userID, robotData, nil)
				else
					cells.roleInstance.arame = cells.roleInstance.user_army_name
					cells.roleInstance.template = cells.roleInstance.user_template
					cells.roleInstance.icon = cells.roleInstance.user_icon
					cells.roleInstance.name = cells.roleInstance.user_name
					cells.roleInstance.level = cells.roleInstance.user_level
					cells.roleInstance.rank = cells.roleInstance.user_rank
					cells.roleInstance.force = cells.roleInstance.user_force
					cells.roleInstance.vip = cells.roleInstance.user_vip
					cells.roleInstance.speed = cells.roleInstance.user_speed
					state_machine.excute("sm_arena_player_info_window_open",0,cells.roleInstance)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(arena_ladder_seat_show_info_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_seat_terminal()
end

-- 初始化机器人数据
function ArenaRankingSeatCell:getRobotData(roleInstance)
	local info = {}
	info.user_id = -1
	info.army = ""
	info.name = roleInstance.user_name
	info.vip_grade = 0
	info.lead_mould_id = roleInstance.user_icon
	info.grade = roleInstance.user_level
	info.fighting = roleInstance.user_force
	info.headFrameID = -1
	info.headFrameStage = -1
	info.formation = roleInstance.user_template[1]
	info.imageID = dms.int(dms["user_config"], 23, user_config.param)

	return info
end

function ArenaRankingSeatCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.roleInstance.headFrameID,
        headFrameStage = self.roleInstance.headFrameStage,
        headID = self.roleInstance.user_icon,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function ArenaRankingSeatCell:initDraw()

	local root = self.roots[1]
	local role = self.roleInstance
	local shipTID = self.roleInstance.user_template[1]
	local headIcon = nil
	self.roleIconPanel:removeAllChildren(true)

	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		headIcon = self:getNewHeadIcon()
	else
		headIcon = ArenaRoleIconCell:createCell()
		-- local  user_icon = nil 
		-- user_icon = role.user_icon
		-- if user_icon ~= nil then
		-- 	icon:init(shipTID, 1,user_icon)
		-- else 
		-- 	icon:init(shipTID, 1)
		-- end
		headIcon:init(tonumber(self.roleInstance.user_icon), 1)
	end
	self.roleIconPanel:addChild(headIcon)
	
	
	self.cacheNameText:setString(self.roleInstance.user_name)
	-- self.cacheNameText:setColor(cc.c3b(color_Type[color][1],
	-- 	color_Type[color][2],
	-- 	color_Type[color][3]))
	
	self.cacheLvText:setString(self.roleInstance.user_force)
	
	-- ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_1st"):setVisible(false)
	-- ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_2st"):setVisible(false)
	-- ccui.Helper:seekWidgetByName(root, "Image_jjc_ph_3st"):setVisible(false)
	self.cacheRankText:setString("")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local Image_sl_ph_1_0 = ccui.Helper:seekWidgetByName(root, "Image_sl_ph_1_0")
		local Image_sl_ph_1 = ccui.Helper:seekWidgetByName(root, "Image_sl_ph_1")
		
		if tonumber(self.roleInstance.user_rank) < 4 then
			Image_sl_ph_1:setVisible(true)
			Image_sl_ph_1_0:setVisible(false)
		else
			Image_sl_ph_1:setVisible(false)
			Image_sl_ph_1_0:setVisible(true)
		end
	end

	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		for i = 1,3 do 
			local Image_ranking = ccui.Helper:seekWidgetByName(root,"Image_ranking_"..i)
			if Image_ranking then 
				if tonumber(self.roleInstance.user_rank) == i then 
					Image_ranking:setVisible(true)
				else
					Image_ranking:setVisible(false)
				end
			end
		end
    end

	local Panel_sl_ph_st = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_st")
	Panel_sl_ph_st:removeBackGroundImage()
	if tonumber(self.roleInstance.user_rank) == 1 
		or tonumber(self.roleInstance.user_rank) == 2
		or tonumber(self.roleInstance.user_rank) == 3
		then
			local imgPath = "images/ui/play/arena/jjc_phb_pic_"..self.roleInstance.user_rank..".png"
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then 
            imgPath = "image/common/jjc_phb_pic_"..self.roleInstance.user_rank..".png"
        end
        Panel_sl_ph_st:setBackGroundImage(imgPath)
	else
		self.cacheRankText:setString(self.roleInstance.user_rank)
	end

	--工会名称
	local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
	if role.user_army_name ~= "?" then
		Text_jifen:setString(role.user_army_name)
	else
		Text_jifen:setString(tipStringInfo_union_str[69])
	end
	-- --显示奖励
	-- local rewardRow = self:getArenaRewardRowForRank(tonumber(self.roleInstance.user_rank))
	-- local honor = dms.int(dms["arena_reward_param"], rewardRow, arena_reward_param.arena1_reward_bounty)
	-- local coin = dms.int(dms["arena_reward_param"], rewardRow, arena_reward_param.arena1_reward_silver)
	-- local itemNums = dms.int(dms["arena_reward_param"], rewardRow, arena_reward_param.arena1_reward_prop_count)
	-- self.cacheHonorText:setString(honor)
	-- self.cacheMoneyText:setString(coin)	
	-- self.cacheItemNumsText:setString(itemNums)
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
	local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_ranking_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if ArenaRankingSeatCell.__size == nil then
	 	ArenaRankingSeatCell.__size = root:getContentSize()
	end

	-- role icon
	self.roleIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_role")
	self.roleIconPanel:setSwallowTouches(false)
	-- 奖励荣誉值
	-- self.cacheHonorText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_jl_1")
	
	-- 奖励道具数量
	-- self.cacheItemNumsText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_jl_2")
	
	-- 奖励银币
	-- self.cacheMoneyText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_jl_3")
	
	-- name text
	self.cacheNameText = ccui.Helper:seekWidgetByName(root, "Text_sl_ph_name")
	
	-- lv
	self.cacheLvText = ccui.Helper:seekWidgetByName(root, "Text_best_floor")
	
	-- rank
	self.cacheRankText = ccui.Helper:seekWidgetByName(root, "Text_sl_ph_st")
	
	-- 查看详情
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_list"), 	nil, 
	{
		terminal_name = "arena_ladder_seat_show_info", 	
		terminal_state = 0, 
		isPressedActionEnabled = false,
		cell = self,
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
	self:clearUIInfo()
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_ranking_list.csb", root)
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

function ArenaRankingSeatCell:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_sl_ph_role = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_role")
	local Panel_sl_ph_st = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_st")
	if Panel_sl_ph_role ~= nil then
		Panel_sl_ph_role:removeAllChildren(true)
	end
	if Panel_sl_ph_st ~= nil then
		Panel_sl_ph_st:removeBackGroundImage()
	end
end

function ArenaRankingSeatCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_ranking_list.csb", self.roots[1])
end
