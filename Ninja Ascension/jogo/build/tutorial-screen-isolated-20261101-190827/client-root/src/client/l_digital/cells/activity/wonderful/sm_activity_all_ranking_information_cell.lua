--------------------------------------------------------------------------------------------------------------
--  说明：所有排行排行cell
--------------------------------------------------------------------------------------------------------------
SmActivityAllRankingInformationCell = class("SmActivityAllRankingInformationCellClass", Window)
SmActivityAllRankingInformationCell.__size = nil

--创建cell
local sm_activity_all_ranking_information_cell_terminal = {
    _name = "sm_activity_all_ranking_information_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityAllRankingInformationCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_all_ranking_information_cell_terminal)
state_machine.init()

function SmActivityAllRankingInformationCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    
	 -- Initialize sm_activity_all_ranking_information_cell state machine.
    local function init_sm_activity_all_ranking_information_cell_terminal()
        local sm_activity_all_ranking_information_cell_check_terminal = {
            _name = "sm_activity_all_ranking_information_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                if not cells.activity.user_name and tonumber(cells.m_type) ~= 5 then
                    return false
                end
                if tonumber(cells.m_type) == 1 or tonumber(cells.m_type) == 2 or tonumber(cells.m_type) == 3 or tonumber(cells.m_type) == 7 or tonumber(cells.m_type) == 8 or tonumber(cells.m_type) == 9 then
                     -- DSC统一玩家详情界面
                     local userID = cells.activity.user_id
                     if __lua_project_id == __lua_project_l_digital then
                        OpenOtherUserInformation(userID)
                    else
                        local function responseShowUserInfoCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                   
                                    local datainfo = response.node.activity
                                    datainfo.icon = response.node.activity.user_head_id
                                    datainfo.name = response.node.activity.user_name
                                    datainfo.level = _ED.chat_user_info.grade
                                    datainfo.rank = response.node.activity.user_rank
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
                elseif tonumber(cells.m_type) == 4 then
                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                app.load("client.packs.hero.SmRoleInformation")
                                state_machine.excute("sm_role_information_open", 0, {response.node.activity.ship_id,-1})
                            end
                        end
                    end
                    protocol_command.get_other_user_ship_info.param_list = cells.activity.user_id.."\r\n"..cells.activity.ship_id
                    NetworkManager:register(protocol_command.get_other_user_ship_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
                elseif tonumber(cells.m_type) == 5 then
                    cells.example = {}
                    cells.example.union_icon = cells.activity.nuion_icon
                    cells.example.union_kuang = 1
                    cells.example.union_name = cells.activity.union_name
                    cells.example.union_president_name = cells.activity.union_president_name
                    cells.example.union_id = cells.activity.union_id
                    cells.example.union_rank = cells.activity.union_rank
                    cells.example.union_level = cells.activity.union_level
                    cells.example.union_member = cells.activity.union_member
                    cells.example.union_watchword = cells.activity.watchword
                    cells.example.union_science_num = cells.activity.union_science_num
                    state_machine.excute("sm_union_info_window_window_open", 0, cells.example)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_all_ranking_information_cell_check_terminal) 

        state_machine.init()
    end 
    -- call func sm_activity_all_ranking_information_cell create state machine.
    init_sm_activity_all_ranking_information_cell_terminal()

end

function SmActivityAllRankingInformationCell:updateDraw()
    local root = self.roots[1]

    for i=1,3 do
        ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(false)
    end
    local ranks = 0
    if self.m_type == 5 then
        ranks = tonumber(self.activity.union_rank)
    else
        ranks = tonumber(self.activity.user_rank)
    end
    if ranks <=3 then
        ccui.Helper:seekWidgetByName(root, "Image_ranking_"..ranks):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_my_raning"):setString("")
    else
        ccui.Helper:seekWidgetByName(root, "Text_my_raning"):setString(ranks)
    end
    --公会图标
    local Panel_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_gh_icon")
    Panel_gh_icon:removeAllChildren(true)
    --名称
    local Text_ranking_info_1 = ccui.Helper:seekWidgetByName(root, "Text_ranking_info_1")
    Text_ranking_info_1:setString("")
    --等级
    local Text_ranking_info_2 = ccui.Helper:seekWidgetByName(root, "Text_ranking_info_2")
    Text_ranking_info_2:setString("")
    --战力，关卡星数，卡牌数，最强卡牌战力，公会战力，王者积分
    local Text_ranking_info_3 = ccui.Helper:seekWidgetByName(root, "Text_ranking_info_3")
    Text_ranking_info_3:setString("")
    --工会名称
    local Text_gh_name = ccui.Helper:seekWidgetByName(root, "Text_gh_name")
    Text_gh_name:setString("")
    --工会等级
    local Text_gh_lv = ccui.Helper:seekWidgetByName(root, "Text_gh_lv") 
    Text_gh_lv:setString("")
    --最强卡牌形象
    local Panel_digimon = ccui.Helper:seekWidgetByName(root, "Panel_digimon") 
    Panel_digimon:removeAllChildren(true)

    -- 头衔
    local Panel_title_view = ccui.Helper:seekWidgetByName(root, "Panel_title_view") 
    local titleIndex = tonumber(self.activity.user_rank_title_name)
    if nil ~= titleIndex and titleIndex > 0 then
        Panel_title_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], titleIndex, title_param.pic_index)))
        Panel_title_view:setVisible(true)
    else
        Panel_title_view:setVisible(false)
    end

    if self.m_type == 1 then
        Text_ranking_info_1:setString(self.activity.user_name)
        Text_ranking_info_2:setString(self.activity.user_level)
        Text_ranking_info_3:setString(self.activity.user_fight)
    elseif self.m_type == 2 then
        Text_ranking_info_1:setString(self.activity.user_name)
        Text_ranking_info_2:setString(self.activity.user_level)
        Text_ranking_info_3:setString(self.activity.npc_count)
    elseif self.m_type == 3 then
        Text_ranking_info_1:setString(self.activity.user_name)
        Text_ranking_info_2:setString(self.activity.user_speed)
        Text_ranking_info_3:setString(self.activity.card_count)
    elseif self.m_type == 4 then
        Text_ranking_info_1:setString(self.activity.user_name)
        --模板id:等级:进阶数据:星级:品阶:战力:皮肤
        local shipData = zstring.split(self.activity.ship_info, ":")
        local cell = HeroIconListCell:createCell()
        local ship = {}
        ship.ship_template_id = shipData[1]
        ship.evolution_status = shipData[3]
        ship.Order = shipData[5]
        ship.StarRating = shipData[4]
        ship.ship_grade = shipData[2]
        ship.ship_id = -1
        ship.skin_id = shipData[7]
        cell:init(ship, i,true)
        Panel_digimon:addChild(cell)
        Text_ranking_info_3:setString(self.activity.ship_fight)
    elseif self.m_type == 5 then
        local cellOne = CnionLogoIconCell:createCell()
        cellOne:init(1,tonumber(self.activity.nuion_icon),2)
        Panel_gh_icon:addChild(cellOne)
        Text_gh_name:setString(self.activity.union_name)
        Text_gh_lv:setString("Lv."..self.activity.union_level)
        Text_ranking_info_2:setString(self.activity.union_president_name)
        Text_ranking_info_3:setString(self.activity.union_fight)
    elseif self.m_type == 8 then
        Text_ranking_info_1:setString(self.activity.user_name)
        Text_ranking_info_2:setString(self.activity.user_level)
        Text_ranking_info_3:setString(self.activity.score)
    elseif self.m_type == 9 then
        Text_ranking_info_1:setString(self.activity.user_name)
        Text_ranking_info_2:setString(self.activity.price)
        Text_ranking_info_3:setString(self.activity.num)
    elseif self.m_type == 10 then                        --跨服王者之战
        if self.activity.user_server_number then
            Text_ranking_info_1:setString(self.activity.user_name.."  "..SmCrossServerBattleKingsHandler.getServerName(self.activity.user_server_number))
            Text_ranking_info_2:setString(self.activity.layer_count)
            Text_ranking_info_3:setString(self.activity.score)
        else
            Text_ranking_info_1:setString("")
            Text_ranking_info_2:setString("")
            Text_ranking_info_3:setString("")
        end
        
    else
        Text_ranking_info_1:setString(self.activity.user_name)
        Text_ranking_info_2:setString(self.activity.score)
        Text_ranking_info_3:setString(self.activity.layer_count)
    end
    -- local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    -- Text_player_name:setString(self.activity.user_name)
    -- local Text_player_lv = ccui.Helper:seekWidgetByName(root, "Text_player_lv")
    -- Text_player_lv:setString(self.activity.user_level)
    -- local Text_player_fighting = ccui.Helper:seekWidgetByName(root, "Text_player_fighting")
    -- Text_player_fighting:setString(self.activity.user_fighting)
    
    local Image_no_people = ccui.Helper:seekWidgetByName(root, "Image_no_people")
    Image_no_people:setVisible(false)
    if (self.m_type ~= 5 and (not self.activity.user_name))
        or (self.m_type == 5 and (not self.activity.union_name))
        then
        Image_no_people:setVisible(true)
    end
    
end

function SmActivityAllRankingInformationCell:onUpdate(dt)
    
end

function SmActivityAllRankingInformationCell:onInit()
    local root = cacher.createUIRef("system/sm_ranking_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityAllRankingInformationCell.__size == nil then
        SmActivityAllRankingInformationCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_3"):getContentSize()
    end
    --跨服王者禁止点击查看个人信息
    if 10 ~= tonumber(self.m_type) then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_3"), nil, 
        {
            terminal_name = "sm_activity_all_ranking_information_cell_check", 
            terminal_state = 0, 
            touch_black = true,
    		cells = self,
        }, nil, 1)
    end

	self:updateDraw()
end

function SmActivityAllRankingInformationCell:onEnterTransitionFinish()
    
end

function SmActivityAllRankingInformationCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_digimon = ccui.Helper:seekWidgetByName(root, "Panel_digimon")
    local Panel_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_gh_icon")
    if Panel_digimon ~= nil then
        Panel_digimon:removeAllChildren(true)
    end
    if Panel_gh_icon ~= nil then
        Panel_gh_icon:removeAllChildren(true)
    end
end

function SmActivityAllRankingInformationCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityAllRankingInformationCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("system/sm_ranking_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmActivityAllRankingInformationCell:init(params)
    self.activity = params[1]
    self.m_type = tonumber(params[2])
	self:onInit()
    self:setContentSize(SmActivityAllRankingInformationCell.__size)
    return self
end

function SmActivityAllRankingInformationCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("system/sm_ranking_list.csb", self.roots[1])
end