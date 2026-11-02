-----------------------------
--跨服矿战排行
-----------------------------
CrossServerBattelRank = class("CrossServerBattelRankClass", Window)
CrossServerBattelRank.__size = nil

local cross_server_battel_rank_open_terminal = {
    _name = "cross_server_battel_rank_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if fwin:find("CrossServerBattelRankClass") == nil then
            fwin:open(CrossServerBattelRank:new():init(params), fwin._ui)      
        end
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local cross_server_battel_rank_close_terminal = {
    _name = "cross_server_battel_rank_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CrossServerBattelRankClass"))
        fwin:close(fwin:find("CrossServerBattelShopTopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_rank_open_terminal)
state_machine.add(cross_server_battel_rank_close_terminal)
state_machine.init()

function CrossServerBattelRank:ctor()
    self.super:ctor()
    self.roots = {}
    self._current_page = -1

    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelPersonalRankList")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelServerRankList")
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

    --打开排行榜
    local cross_server_battel_interface_open_rank_terminal = {
        _name = "cross_server_battel_interface_open_rank",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params) 
            local page = tonumber(params._datas._page)
            local m_type = params._datas.m_type
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        response.node:changeSelectPage(page)
                        response.node:onUpdateDraw()
                    end
                end
            end
            protocol_command.cross_mine_order_info.param_list = "1".."\r\n".."10".."\r\n".. m_type
            NetworkManager:register(protocol_command.cross_mine_order_info.code, nil, nil, nil, instance, responseCallback, false, nil)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(cross_server_battel_interface_open_rank_terminal)
    state_machine.init()
end

function CrossServerBattelRank:onUpdateDraw()
    local root = self.roots[1]
    self.currentInfo = self._current_page == 1 and _ED.cross_server_battel_personal_rank_info or _ED.cross_server_battel_server_rank_info


    --自己的排名
    local Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")
    Text_my_raning:setString("")
    --图标
    local Panel_my_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_my_gh_icon")
    Panel_my_gh_icon:removeAllChildren(true)
    --自己的名称
    local Text_my_gh_name = ccui.Helper:seekWidgetByName(root, "Text_my_gh_name")
    Text_my_gh_name:setString("")
    --自己的等级
    local Text_my_gh_lv = ccui.Helper:seekWidgetByName(root, "Text_my_gh_lv")
    Text_my_gh_lv:setString("")
    --服务器，
    local Text_my_gh_service = ccui.Helper:seekWidgetByName(root, "Text_my_gh_service")
    Text_my_gh_service:setString("")

    --类型，
    local Text_my_gh_type = ccui.Helper:seekWidgetByName(root, "Text_my_gh_type")
    Text_my_gh_type:setString("")

    --未上榜
    local Panel_my_rank_icon = ccui.Helper:seekWidgetByName(root, "Panel_my_rank_icon")
    Panel_my_rank_icon:removeBackGroundImage()
    --排名
    Text_my_raning:setString(self.currentInfo.myRankInfo.rank)

    if tonumber(self.currentInfo.myRankInfo.rank) <= 0 then
        Panel_my_rank_icon:setBackGroundImage("images/ui/text/cross_service/rank_wsb.png")
        Panel_my_rank_icon:setVisible(true)
        Text_my_raning:setString("0")
        Text_my_raning:setVisible(false)
    else
        Text_my_raning:setString(self.currentInfo.myRankInfo.rank)
        Panel_my_rank_icon:setVisible(false)
        Text_my_raning:setVisible(true)
    end

    Panel_my_gh_icon:addChild(self:onHeadDraw(self.currentInfo.myRankInfo.userInfo.headPic, self.currentInfo.myRankInfo.userInfo.vipLevel))
    Text_my_gh_lv:setString(self.currentInfo.myRankInfo.userInfo.level)
    local server_name = _ED.cross_server_battel_all_servers[self.currentInfo.myRankInfo.userInfo.serverId]
    local getStr1 = string.match(server_name, "-")
    local getStr2 = string.match(server_name, "_")
    if getStr1 and getStr1 ~= "" then
        server_name = zstring.split(server_name, "-")[1]
    elseif getStr2 and getStr2 ~= "" then
        server_name = zstring.split(server_name, "_")[1]
    end
    Text_my_gh_service:setString(server_name)

    if self._current_page == 1 then
        Text_my_gh_type:setString(self.currentInfo.myRankInfo.maxCombat)
    else
        Text_my_gh_type:setString(self.currentInfo.myRankInfo.feedScore)
    end

    names = self.currentInfo.myRankInfo.userInfo.nickName

    local c3bColorList = {71, 71, 71}
    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_digital then
        c3bColorList = {255, 255, 0}
    end

    Text_my_gh_name:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    local _width = Text_my_gh_name:getContentSize().width == 0 and tonumber(Text_my_gh_name:getFontSize())*7 or Text_my_gh_name:getContentSize().width
    _richText2:setContentSize(cc.size(_width, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local char_str = names
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    cc.c3b(c3bColorList[1], c3bColorList[2], c3bColorList[3]),
    cc.c3b(c3bColorList[1], c3bColorList[2], c3bColorList[3]),
    0, 
    0, 
    Text_my_gh_name:getFontName(), 
    Text_my_gh_name:getFontSize(),
    chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(_richText2:getContentSize().height/2)
    Text_my_gh_name:addChild(_richText2)
end

function CrossServerBattelRank:changeSelectPage( page )
    local root = self.roots[1]
    local Image_cross_service_rank_t_2 = ccui.Helper:seekWidgetByName(root, "Image_cross_service_rank_t_2")
    local Image_cross_service_rank_t_1 = ccui.Helper:seekWidgetByName(root, "Image_cross_service_rank_t_1")
    Image_cross_service_rank_t_1:setVisible(page == 1)
    Image_cross_service_rank_t_2:setVisible(page == 2)

    local Panel_phb_listview = ccui.Helper:seekWidgetByName(root, "Panel_cross_service_rank")
    local Button_rank_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_cross_service_rank")
    local Button_rank_tab_2 = ccui.Helper:seekWidgetByName(root, "Button_cross_service_contrbution_rank")
    if page == self._current_page then
        if page == 1 then
            Button_rank_tab_1:setHighlighted(true)
        elseif page == 2 then
            Button_rank_tab_2:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_rank_tab_1:setHighlighted(false)
    Button_rank_tab_2:setHighlighted(false)
    state_machine.excute("cross_server_battel_server_rank_open_list_hide", 0, nil)
    state_machine.excute("cross_server_battel_personal_rank_open_list_hide", 0, nil)
    if page == 1 then
        Button_rank_tab_1:setHighlighted(true)
        if self.personal_rank == nil then
            self.personal_rank = state_machine.excute("cross_server_battel_personal_rank_open_list", 0, {Panel_phb_listview})
        else
            state_machine.excute("cross_server_battel_personal_rank_open_list_show", 0, nil)
        end
    elseif page == 2 then
        Button_rank_tab_2:setHighlighted(true)
        if self.server_rank == nil then
            self.server_rank = state_machine.excute("cross_server_battel_server_rank_open_list", 0, {Panel_phb_listview})
        else
            state_machine.excute("cross_server_battel_server_rank_open_list_show", 0, nil)
        end 
    end
end

function CrossServerBattelRank:onHeadDraw(headIndex, vipLevel)
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

function CrossServerBattelRank:onUpdate(dt)
    
end

function CrossServerBattelRank:onEnterTransitionFinish()

end

function CrossServerBattelRank:onInit( )
    local csbItem = csb.createNode("campaign/cross_service/cross_service_rank.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cross_service_report_back"), nil, 
    {
        terminal_name = "cross_server_battel_rank_close", 
        terminal_state = 0, 
    }, nil, 0)

    --个人排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cross_service_rank"), nil, 
    {
        terminal_name = "cross_server_battel_interface_open_rank", 
        terminal_state = 0, 
        _page = 1,
        m_type = 1,
    }, nil, 0)
    
    --贡献排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cross_service_contrbution_rank"), nil, 
    {
        terminal_name = "cross_server_battel_interface_open_rank", 
        terminal_state = 0, 
        _page = 2,
        m_type = 2,
    }, nil, 0)

    --查看第一名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chakan"), nil, 
    {
        terminal_name = "sm_ranking_constellation_view_the_first_place", 
        terminal_state = 0, 
    }, nil, 0)

    state_machine.excute("cross_server_battel_interface_open_rank",0,{_datas = {_page = 1, m_type = 1}})

    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop")                    --顶部用户信息
    local userinfo = CrossServerBattelShopTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    if CrossServerBattelRank.__size == nil then
        CrossServerBattelRank.__size = root:getContentSize()
    end
    self:setContentSize(CrossServerBattelRank.__size)
end

function CrossServerBattelRank:init()    
	self:onInit()
    return self
end

function CrossServerBattelRank:onExit()
    state_machine.remove("sm_ranking_constellation_view_the_first_place")
end
