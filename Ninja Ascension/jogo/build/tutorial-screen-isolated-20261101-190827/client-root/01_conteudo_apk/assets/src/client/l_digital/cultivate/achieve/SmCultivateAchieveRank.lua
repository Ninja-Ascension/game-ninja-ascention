-----------------------------
--战斗力排行
-----------------------------
SmCultivateAchieveRank = class("SmCultivateAchieveRankClass", Window)
SmCultivateAchieveRank.__size = nil

local sm_cultivate_achieve_rank_open_terminal = {
    _name = "sm_cultivate_achieve_rank_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateAchieveRankClass") == nil then
            fwin:open(SmCultivateAchieveRank:new():init(params), fwin._ui)      
        end
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_cultivate_achieve_rank_close_terminal = {
    _name = "sm_cultivate_achieve_rank_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- fwin:close(fwin:find("UserTopInfoAClass"))
        -- state_machine.excute("menu_back_home_page", 0, "") 
        fwin:close(fwin:find("SmCultivateAchieveRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_achieve_rank_open_terminal)
state_machine.add(sm_cultivate_achieve_rank_close_terminal)
state_machine.init()

function SmCultivateAchieveRank:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.cultivate.achieve.SmCultivateAchieveRankList")
    local sm_ranking_achieve_view_the_first_place_terminal = {
    _name = "sm_ranking_achieve_view_the_first_place",
    _init = function (terminal)
        app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
        app.load("client.l_digital.union.create.SmUnionInfoWindow")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local datas = _ED.user_achieve_score_rank.other_user[1]
        if not datas then
            return
        end
        local function responseShowUserInfoCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    local datainfo = datas
                    datainfo.icon = datas.user_head_id
                    datainfo.name = datas.user_name
                    datainfo.level = datas.user_level
                    datainfo.rank = datas.user_rank
                    datainfo.force = datas.user_fight
                    datainfo.vip = datas.user_vip_level
                    datainfo.template = {}
                    datainfo.template[1] = _ED.chat_user_info.formation
                    if datas.user_union_name == "" then
                        datainfo.arame = "?"
                    else
                        datainfo.arame = datas.user_union_name
                    end
                    state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
                end
            end
        end
        protocol_command.see_user_info.param_list = datas.user_id
        NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, instance, responseShowUserInfoCallBack, false, nil)
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_ranking_achieve_view_the_first_place_terminal)
state_machine.init()

end

function SmCultivateAchieveRank:onUpdateDraw()
    local root = self.roots[1]
    local Panel_phb_listview = ccui.Helper:seekWidgetByName(root, "Panel_phb_listview") 
    if self._achieve_rank == nil then
        self._achieve_rank = state_machine.excute("sm_cultivate_achieve_rank_open_list", 0, {Panel_phb_listview})
    else
        state_machine.excute("sm_cultivate_achieve_rank_refresh_list", 0, nil)
    end

    --头像
    local Panel_best_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_best_player_icon")
    Panel_best_player_icon:removeAllChildren(true)
    --文字1
    local Text_best_info_1 = ccui.Helper:seekWidgetByName(root, "Text_best_info_1")
    Text_best_info_1:setString("")
    --文字2
    local Text_best_info_2 = ccui.Helper:seekWidgetByName(root, "Text_best_info_2")
    Text_best_info_2:setString("")
    --文字3
    local Text_best_info_3 = ccui.Helper:seekWidgetByName(root, "Text_best_info_3")
    Text_best_info_3:setString("")

    --自己的排名
    local Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")
    Text_my_raning:setString("")
    --自己的工会图标
    local Panel_my_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_my_gh_icon")
    Panel_my_gh_icon:removeAllChildren(true)
    --自己的名称
    local Text_my_ranking_info_1 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_1")
    Text_my_ranking_info_1:setString("")
    --自己的等级
    local Text_my_ranking_info_2 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_2")
    Text_my_ranking_info_2:setString("")
    --自己的战力，关卡星数，驯兽数，最强卡牌战力，工会战力，
    local Text_my_ranking_info_3 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_3")
    Text_my_ranking_info_3:setString("")
    -- 未上榜的图片
    local Image_wsb = ccui.Helper:seekWidgetByName(root, "Image_wsb")

    --战斗力
    local curRank = _ED.user_achieve_score_rank.my_info.user_rank
    Text_my_raning:setString(curRank)
    if Image_wsb ~= nil then
        Image_wsb:setVisible(curRank <= 0)
        Text_my_raning:setVisible(curRank > 0)
    end
    names = _ED.user_info.user_name
    Text_my_ranking_info_2:setString(_ED.user_info.user_grade)
    Text_my_ranking_info_3:setString(_ED.user_achieve_score_rank.my_info.score)
    local headIcon = nil
    -- DSC添加头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
        headIcon = self:getNewHeadIcon()
    else
        headIcon = self:onHeadDraw(_ED.user_achieve_score_rank.other_user[1].user_head_id, _ED.user_achieve_score_rank.other_user[1].user_vip_level)
    end
    if headIcon ~= nil then
        Panel_best_player_icon:addChild(headIcon)
    end
    Text_best_info_1:setString(_ED.user_achieve_score_rank.other_user[1].user_name)
    Text_best_info_2:setString(_new_interface_text[103].." ".._ED.user_achieve_score_rank.other_user[1].user_level)
    Text_best_info_3:setString(_new_interface_text[104].." ".._ED.user_achieve_score_rank.other_user[1].user_union_name)

    Text_my_ranking_info_1:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    local _width = Text_my_ranking_info_1:getContentSize().width == 0 and tonumber(Text_my_ranking_info_1:getFontSize())*7 or Text_my_ranking_info_1:getContentSize().width
    _richText2:setContentSize(cc.size(_width, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71,71,71)
        color_Type_2 = cc.c3b(71,71,71)
    else
        color_Type_1 = cc.c3b(255, 255, 0)
        color_Type_2 = cc.c3b(255, 255, 0)
    end
    local char_str = names
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    Text_my_ranking_info_1:getFontName(), 
    Text_my_ranking_info_1:getFontSize(),
    chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_my_ranking_info_1:getContentSize().height)
    Text_my_ranking_info_1:addChild(_richText2)
end

function SmCultivateAchieveRank:getNewHeadIcon()
    local headIconInfo = {
        headFrameID = _ED.user_achieve_score_rank.other_user[1].headFrameID,
        headFrameStage = _ED.user_achieve_score_rank.other_user[1].headFrameStage,
        headID = _ED.user_achieve_score_rank.other_user[1].user_head_id,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function SmCultivateAchieveRank:onHeadDraw(headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
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
    Panel_head:setTouchEnabled(false)
    return roots
end

function SmCultivateAchieveRank:onUpdate(dt)
    
end

function SmCultivateAchieveRank:onEnterTransitionFinish()

end

function SmCultivateAchieveRank:onInit( )
    local csbItem = csb.createNode("cultivate/cultivate_achievement_ranking.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_phb_back"), nil, 
    {
        terminal_name = "sm_cultivate_achieve_rank_close", 
        terminal_state = 0, 
    }, nil, 0)

    --查看第一名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chakan"), nil, 
    {
        terminal_name = "sm_ranking_achieve_view_the_first_place", 
        terminal_state = 0, 
    }, nil, 0)

    if SmCultivateAchieveRank.__size == nil then
        SmCultivateAchieveRank.__size = root:getContentSize()
    end
    self:setContentSize(SmCultivateAchieveRank.__size)

    self:onUpdateDraw()
end

function SmCultivateAchieveRank:init()    
	self:onInit()
    return self
end

function SmCultivateAchieveRank:onExit()
    state_machine.remove("sm_ranking_achieve_view_the_first_place")
end
