--------------------------------------------------------------------------------------------------------------
--  说明：数码试炼排行控件
--------------------------------------------------------------------------------------------------------------
SmTrialTowerRankingListCell = class("SmTrialTowerRankingListCellClass", Window)
SmTrialTowerRankingListCell.__size = nil

--创建cell
local sm_trial_tower_ranking_list_cell_terminal = {
    _name = "sm_trial_tower_ranking_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmTrialTowerRankingListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_trial_tower_ranking_list_cell_terminal)
state_machine.init()

function SmTrialTowerRankingListCell:ctor()
	self.super:ctor()
	self.roots = {}

    -- load lua file

    -- var
    self.index = 0
    self.rank_info = nil

    self.Image_sl_ph = nil

	local function init_sm_trial_tower_ranking_list_cell_check_terminal()
        local sm_trial_tower_ranking_list_cell_check_terminal = {
            _name = "sm_trial_tower_ranking_list_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                local userID = tonumber(cells.rank_info.user_id)
                -- DSC统一玩家详情界面
                if __lua_project_id == __lua_project_l_digital then
                    OpenOtherUserInformation(userID, nil, nil)
                else
                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                local datainfo = response.node.rank_info
                                datainfo.icon = response.node.rank_info.user_head_id
                                datainfo.name = response.node.rank_info.user_name
                                datainfo.level = _ED.chat_user_info.grade
                                datainfo.rank = response.node.rank_info.user_rank
                                datainfo.force = _ED.chat_user_info.fighting
                                datainfo.vip = _ED.chat_user_info.vip_grade
                                datainfo.template = {}
                                datainfo.template[1] = _ED.chat_user_info.formation
                                if _ED.chat_user_info.army == "" then
                                    datainfo.arame = "?"
                                else
                                    datainfo.arame = _ED.chat_user_info.army
                                end
                                state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
                            end
                        end
                    end
                    protocol_command.see_user_info.param_list = userID
                    NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_ranking_list_cell_check_terminal) 
        state_machine.init()
    end
    init_sm_trial_tower_ranking_list_cell_check_terminal()
end

function SmTrialTowerRankingListCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.rank_info.headFrameID,
        headFrameStage = self.rank_info.headFrameStage,
        headID = self.rank_info.user_head_id,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function SmTrialTowerRankingListCell:onHeadDraw(headIndex, vipLevel)
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

function SmTrialTowerRankingListCell:updateDraw()
    local root = self.roots[1]
    -- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		for i = 1,3 do 
			local Image_ranking = ccui.Helper:seekWidgetByName(root,"Image_ranking_"..i)
			if Image_ranking then 
				if tonumber(self.rank_info.user_rank) == i then 
					Image_ranking:setVisible(true)
				else
					Image_ranking:setVisible(false)
				end
			end
		end
    end
    
    local Text_sl_ph_st = ccui.Helper:seekWidgetByName(root, "Text_sl_ph_st")
    Text_sl_ph_st:setString("")
    local Panel_sl_ph_st = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_st")
    Panel_sl_ph_st:removeBackGroundImage()
    if tonumber(self.rank_info.user_rank) == 1 
        or tonumber(self.rank_info.user_rank) == 2
        or tonumber(self.rank_info.user_rank) == 3
        then
        local imgPath = "images/ui/play/arena/jjc_phb_pic_"..self.rank_info.user_rank..".png"
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then 
            imgPath = "image/common/jjc_phb_pic_"..self.rank_info.user_rank..".png"
        end
        Panel_sl_ph_st:setBackGroundImage(imgPath)
    else
        Text_sl_ph_st:setString(self.rank_info.user_rank)
    end

    local Panel_sl_ph_role = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_role")
    Panel_sl_ph_role:removeAllChildren(true)
	local headIcon = nil
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		headIcon = self:getNewHeadIcon()
	else
		headIcon = self:onHeadDraw(self.rank_info.user_head_id, self.rank_info.user_vip_level)
	end
    Panel_sl_ph_role:addChild(headIcon)
    
    local Text_sl_ph_name = ccui.Helper:seekWidgetByName(root, "Text_sl_ph_name")
    Text_sl_ph_name:setString(self.rank_info.user_name)

    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
    Text_jifen:setString("" .. self.rank_info.score)


    local Text_best_floor = ccui.Helper:seekWidgetByName(root, "Text_best_floor")
    Text_best_floor:setString("" .. self.rank_info.layer_count)
end

function SmTrialTowerRankingListCell:onUpdate(dt)
    
end

function SmTrialTowerRankingListCell:onInit()
    local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_ranking_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmTrialTowerRankingListCell.__size == nil then
        SmTrialTowerRankingListCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_list"), nil, 
    {
        terminal_name = "sm_trial_tower_ranking_list_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

	self:updateDraw()
end

function SmTrialTowerRankingListCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmTrialTowerRankingListCell:clearUIInfo( ... )
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
        
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then 
            for i = 1,3 do 
                local Image_ranking = ccui.Helper:seekWidgetByName(root,"Image_ranking_"..i)
                if Image_ranking ~= nil then
                    Image_ranking:setVisible(false)
                end
            end
        end

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
    local Panel_sl_ph_role = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_role")
    local Panel_sl_ph_st = ccui.Helper:seekWidgetByName(root, "Panel_sl_ph_st")
    if Panel_sl_ph_role ~= nil then
        Panel_sl_ph_role:removeAllChildren(true)
    end
    if Panel_sl_ph_st ~= nil then
        Panel_sl_ph_st:removeBackGroundImage()
    end
end

function SmTrialTowerRankingListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmTrialTowerRankingListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_ranking_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmTrialTowerRankingListCell:init(params)
    self.index = params[1]
    self.rank_info = params[2]
    if self.index < 6 then
	   self:onInit()
    end

    self:setContentSize(SmTrialTowerRankingListCell.__size)
    return self
end

function SmTrialTowerRankingListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_ranking_list.csb", self.roots[1])
end