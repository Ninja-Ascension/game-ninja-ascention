-----------------------------
--诸神排行
-----------------------------
SmCultivateConstellationRank = class("SmCultivateConstellationRankClass", Window)
SmCultivateConstellationRank.__size = nil

local sm_cultivate_constellation_rank_open_terminal = {
    _name = "sm_cultivate_constellation_rank_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateConstellationRankClass") == nil then
            fwin:open(SmCultivateConstellationRank:new():init(params), fwin._ui)      
        end
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_cultivate_constellation_rank_close_terminal = {
    _name = "sm_cultivate_constellation_rank_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmCultivateConstellationRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_constellation_rank_open_terminal)
state_machine.add(sm_cultivate_constellation_rank_close_terminal)
state_machine.init()

function SmCultivateConstellationRank:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.cultivate.constellation.SmCultivateConstellationRankList")
    local sm_ranking_achieve_view_the_first_place_terminal = {
    _name = "sm_ranking_constellation_view_the_first_place",
    _init = function (terminal)
        app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
        app.load("client.l_digital.union.create.SmUnionInfoWindow")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local datas = _ED.user_constellation_price_rank.other_user[1]
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

function SmCultivateConstellationRank:onUpdateDraw()
    local root = self.roots[1]
    local Panel_phb_listview = ccui.Helper:seekWidgetByName(root, "ListView_phb_listview") 
    if self._constellation_rank == nil then
        self._constellation_rank = state_machine.excute("sm_cultivate_constellation_rank_open_list", 0, {Panel_phb_listview})
    else
        state_machine.excute("sm_cultivate_constellation_rank_open_list_show", 0, nil)
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

    --战斗力
    Text_my_raning:setString(_ED.user_constellation_price_rank.my_info.user_rank)

    if tonumber(_ED.user_constellation_price_rank.my_info.user_rank) < 0 then
        Text_my_raning:setString("0")
    else
        Text_my_raning:setString(_ED.user_constellation_price_rank.my_info.user_rank)
    end
    names = _ED.user_info.user_name
    -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
    Text_my_ranking_info_2:setString(_ED.user_constellation_price_rank.my_info.layer_count)
    Text_my_ranking_info_3:setString(_ED.user_constellation_price_rank.my_info.score)
    if _ED.user_constellation_price_rank.other_user ~= nil and _ED.user_constellation_price_rank.other_user[1] ~= nil then
        names = _ED.user_info.user_name
        Text_my_ranking_info_2:setString(_ED.user_constellation_price_rank.my_info.price)
        Text_my_ranking_info_3:setString(_ED.user_constellation_price_rank.my_info.num)
        local headIcon = nil
        -- DSC添加头像框
        local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
        if fun_is_open == true then
            headIcon = self:getNewHeadIcon()
        else
            headIcon = self:onHeadDraw(_ED.user_constellation_price_rank.other_user[1].user_head_id, _ED.user_constellation_price_rank.other_user[1].user_vip_level)
        end
        Panel_best_player_icon:addChild(headIcon)
        Text_best_info_1:setString(_ED.user_constellation_price_rank.other_user[1].user_name)
        Text_best_info_2:setString(_new_interface_text[103].." ".._ED.user_constellation_price_rank.other_user[1].user_level)
        Text_best_info_3:setString(_new_interface_text[104].." ".._ED.user_constellation_price_rank.other_user[1].user_union_name)
    else
        Text_best_info_1:setString("")
        Text_best_info_2:setString("")
        Text_best_info_3:setString("")
    end

    Text_my_ranking_info_1:setString(names)

    
    -- Text_my_ranking_info_1:removeAllChildren(true)
    -- local _richText2 = ccui.RichText:create()
    -- _richText2:ignoreContentAdaptWithSize(false)
    -- local _width = Text_my_ranking_info_1:getContentSize().width == 0 and tonumber(Text_my_ranking_info_1:getFontSize())*7 or Text_my_ranking_info_1:getContentSize().width
    -- _richText2:setContentSize(cc.size(_width, 0))
    -- _richText2:setAnchorPoint(cc.p(0, 0))
    -- local char_str = names
    -- local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    -- char_str, 
    -- cc.c3b(71, 71, 71),
    -- cc.c3b(71, 71, 71),
    -- 0, 
    -- 0, 
    -- Text_my_ranking_info_1:getFontName(), 
    -- Text_my_ranking_info_1:getFontSize(),
    -- chat_rich_text_color)
    -- _richText2:formatTextExt()
    -- local rsize = _richText2:getContentSize()
    -- _richText2:setPositionY(Text_my_ranking_info_1:getContentSize().height)
    -- if  __lua_project_id == __lua_project_l_pokemon  then
    --     _richText2:setPosition(cc.p(Text_my_ranking_info_1:getPositionX() - _richText2:getContentSize().width / 2+20, Text_my_ranking_info_1:getPositionY() + _richText2:getContentSize().height / 2))
    --     Text_my_ranking_info_1:getParent():addChild(_richText2)
    -- else
    --     Text_my_ranking_info_1:addChild(_richText2)
    -- end
  
end

function SmCultivateConstellationRank:getNewHeadIcon()
    local headIconInfo = {
        headFrameID = _ED.user_constellation_price_rank.other_user[1].headFrameID,
        headFrameStage = _ED.user_constellation_price_rank.other_user[1].headFrameStage,
        headID = _ED.user_constellation_price_rank.other_user[1].user_head_id,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)

    return headIcon
end

function SmCultivateConstellationRank:onHeadDraw(headIndex, vipLevel)
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

function SmCultivateConstellationRank:onUpdate(dt)
    
end

function SmCultivateConstellationRank:onEnterTransitionFinish()

end

function SmCultivateConstellationRank:onInit( )
    local csbItem = csb.createNode("cultivate/constellation_rank.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_phb_back"), nil, 
    {
        terminal_name = "sm_cultivate_constellation_rank_close", 
        terminal_state = 0, 
    }, nil, 0)

    --查看第一名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chakan"), nil, 
    {
        terminal_name = "sm_ranking_constellation_view_the_first_place", 
        terminal_state = 0, 
    }, nil, 0)

    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    if SmCultivateConstellationRank.__size == nil then
        SmCultivateConstellationRank.__size = root:getContentSize()
    end
    self:setContentSize(SmCultivateConstellationRank.__size)

    self:onUpdateDraw()
end

function SmCultivateConstellationRank:init()    
	self:onInit()
    return self
end

function SmCultivateConstellationRank:onExit()
    state_machine.remove("sm_ranking_constellation_view_the_first_place")
end
