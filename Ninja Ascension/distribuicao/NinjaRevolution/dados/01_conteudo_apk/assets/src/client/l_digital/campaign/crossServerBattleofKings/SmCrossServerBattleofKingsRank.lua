-----------------------------
-- 跨服王者之战排行榜主界面
-----------------------------
SmCrossServerBattleofKingsRank = class("SmCrossServerBattleofKingsRankClass", Window)

--打开界面
local sm_cross_server_ranking_open_terminal = {
	_name = "sm_cross_server_ranking_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(168) == true then
            return false
        end
		if fwin:find("SmCrossServerBattleofKingsRankClass") == nil then
			fwin:open(SmCrossServerBattleofKingsRank:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cross_server_ranking_close_terminal = {
	_name = "sm_cross_server_ranking_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCrossServerBattleofKingsRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cross_server_ranking_open_terminal)
state_machine.add(sm_cross_server_ranking_close_terminal)
state_machine.init()

function SmCrossServerBattleofKingsRank:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._combat_power = nil
    self._check_mark = nil
    self._tame_beast = nil
    self._digital_beast = nil
    self._guild = nil
    self._king_of_the_war= nil

    app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleKingsRanking")
    app.load("client.cells.ship.hero_icon_list_cell")


    local function init_sm_cross_server_ranking_terminal()
        --打开排行榜
        local sm_cross_server_ranking_open_rank_terminal = {
            _name = "sm_cross_server_ranking_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:UpdateDrawLeftInterface()
                        end
                    end
                end
                protocol_command.the_kings_battle_self_battle_rank.param_list = "1".."\r\n".."10"
                
                NetworkManager:register(protocol_command.the_kings_battle_self_battle_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看第一名
        local sm_ranking_union_view_the_first_place_terminal = {
            _name = "sm_ranking_union_view_the_first_place",
            _init = function (terminal)
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local datas = _ED.cross_server_battle_kings_score_rank.other_user[1]
                if datas == nil then
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
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_cross_server_ranking_open_rank_terminal)
        state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_cross_server_ranking_terminal()
end

--画左边的界面
function SmCrossServerBattleofKingsRank:UpdateDrawLeftInterface()
    local root = self.roots[1]

    local Panel_phb_listview = ccui.Helper:seekWidgetByName(root, "Panel_phb_listview")
    -- 注入排行数据

    self._consumables = state_machine.excute("sm_cross_server_rank_king_of_the_war_open", 0, {Panel_phb_listview})

    for i=1,6 do 
        ccui.Helper:seekWidgetByName(root, "Image_title_bar_"..i):setVisible(false)
    end
    ccui.Helper:seekWidgetByName(root, "Image_title_bar_"..tonumber(6)):setVisible(true)

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

    Text_my_ranking_info_1:getParent():removeChildByName("_richText2")

    --自己的等级
    local Text_my_ranking_info_2 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_2")
    Text_my_ranking_info_2:setString("")
    --自己的战力，关卡星数，驯兽数，最强卡牌战力，工会战力，
    local Text_my_ranking_info_3 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_3")
    Text_my_ranking_info_3:setString("")
    --自己的工会名称
    local Text_my_gh_name = ccui.Helper:seekWidgetByName(root, "Text_my_gh_name")
    Text_my_gh_name:setString("")
    --自己的工会等级
    local Text_my_gh_lv = ccui.Helper:seekWidgetByName(root, "Text_my_gh_lv")
    Text_my_gh_lv:setString("")
    --自己的最强卡牌头像
    local Panel_my_digimon = ccui.Helper:seekWidgetByName(root, "Panel_my_digimon")
    Panel_my_digimon:removeAllChildren(true)
    local names = ""
    if nil == _ED.cross_server_battle_kings_score_rank then
        Text_my_raning:setString("0")
        Text_best_info_1:setString("")
        Text_best_info_2:setString("")
        Text_best_info_3:setString("")
    else
        if tonumber(_ED.cross_server_battle_kings_score_rank.my_info.user_rank) < 0 then
            Text_my_raning:setString("0")
        else
            Text_my_raning:setString(_ED.cross_server_battle_kings_score_rank.my_info.user_rank)
        end
        names = _ED.user_info.user_name
        -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
        Text_my_ranking_info_2:setString(_ED.cross_server_battle_kings_score_rank.my_info.layer_count)
        Text_my_ranking_info_3:setString(_ED.cross_server_battle_kings_score_rank.my_info.score)
        if _ED.cross_server_battle_kings_score_rank.other_user ~= nil and _ED.cross_server_battle_kings_score_rank.other_user[1] ~= nil then
            Panel_best_player_icon:addChild(self:onHeadDraw(_ED.cross_server_battle_kings_score_rank.other_user[1].user_head_id, _ED.cross_server_battle_kings_score_rank.other_user[1].user_vip_level))
            Text_best_info_1:setString(_ED.cross_server_battle_kings_score_rank.other_user[1].user_name)
            Text_best_info_2:setString(_new_interface_text[103].." ".._ED.cross_server_battle_kings_score_rank.other_user[1].user_level)
            --Text_best_info_3:setString(_new_interface_text[104].." ".._ED.cross_server_battle_kings_score_rank.other_user[1].user_union_name)
        else
            Text_best_info_1:setString("")
            Text_best_info_2:setString("")
            Text_best_info_3:setString("")
        end
         
        Text_my_ranking_info_1:removeAllChildren(true)
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        local _width = Text_my_ranking_info_1:getContentSize().width == 0 and tonumber(Text_my_ranking_info_1:getFontSize())*7 or (Text_my_ranking_info_1:getContentSize().width+50)
        _richText2:setContentSize(cc.size(_width, 0))
        _richText2:setAnchorPoint(cc.p(0, 0))
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            color_Type_1 = cc.c3b(71,71,71)
            color_Type_2 = cc.c3b(71,71,71)
        else
            color_Type_1 = cc.c3b(255, 255, 0)
            color_Type_2 = cc.c3b(255, 255, 0)
        end
        local char_str = names.."("..SmCrossServerBattleKingsHandler.getServerName(_ED.cross_server_kings_battle.my_server_number)..")"
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
    
        _richText2:setPosition(cc.p(Text_my_ranking_info_1:getPositionX() - _richText2:getContentSize().width / 2, Text_my_ranking_info_1:getPositionY() + _richText2:getContentSize().height / 2))
        _richText2:setName("_richText2")
        Text_my_ranking_info_1:getParent():addChild(_richText2)
    end
    

    
end

function SmCrossServerBattleofKingsRank:onHeadDraw(headIndex, vipLevel)
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
    Panel_head:setTouchEnabled(false)
    return roots
end

function SmCrossServerBattleofKingsRank:init(params)
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmCrossServerBattleofKingsRank:onInit()
    local csbItem = csb.createNode("campaign/BattleofKingsX/battle_of_kings_x_rank.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    ccui.Helper:seekWidgetByName(root,"Button_chakan"):setVisible(false)
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_phb_back"), nil, 
    {
        terminal_name = "sm_cross_server_ranking_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --跨服王者之战排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_6"), nil, 
    {
        terminal_name = "sm_cross_server_ranking_open_rank", 
        terminal_state = 0, 
    }, nil, 0)
    
    --查看第一名
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chakan"), nil, 
    -- {
    --     terminal_name = "sm_ranking_union_view_the_first_place", 
    --     terminal_state = 0, 
    -- }, nil, 0)
    for i=1,6 do
        local Button_rank_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_"..i)
        Button_rank_tab_1:setVisible(false)
    end
    state_machine.excute("sm_cross_server_ranking_open_rank", 0, "")

    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._view)

    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
        local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
        Panel_effec:addChild(animation2)
    end
end

function SmCrossServerBattleofKingsRank:onEnterTransitionFinish()
    
end

function SmCrossServerBattleofKingsRank:clearUIInfo( ... )
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
    local Panel_best_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_best_player_icon")
    Panel_best_player_icon:removeAllChildren(true)
    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function SmCrossServerBattleofKingsRank:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
	state_machine.remove("sm_cross_server_ranking_open_rank")
end

