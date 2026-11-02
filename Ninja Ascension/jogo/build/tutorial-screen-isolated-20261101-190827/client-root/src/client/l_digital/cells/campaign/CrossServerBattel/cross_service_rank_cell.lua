--------------------------------------------------------------------------------------------------------------
--  说明：所有排行排行cell
--------------------------------------------------------------------------------------------------------------
CrossServerBattelRankCell = class("CrossServerBattelRankCellClass", Window)
CrossServerBattelRankCell.__size = nil

--创建cell
local cross_server_battel_rank_cell_terminal = {
    _name = "cross_server_battel_rank_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CrossServerBattelRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_rank_cell_terminal)
state_machine.init()

function CrossServerBattelRankCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
	 -- Initialize cross_server_battel_rank_cell state machine.
    local function init_cross_server_battel_rank_cell_terminal()
        local cross_server_battel_rank_cell_check_terminal = {
            _name = "cross_server_battel_rank_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
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
                protocol_command.see_user_info.param_list = cells.activity.userInfo.userId
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
                

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(cross_server_battel_rank_cell_check_terminal) 
        state_machine.init()
    end 
    -- call func cross_server_battel_rank_cell create state machine.
    init_cross_server_battel_rank_cell_terminal()
end

function CrossServerBattelRankCell:updateDraw()
    local root = self.roots[1]
    local Image_ghz_gr_rank_k = ccui.Helper:seekWidgetByName(root, "Image_ghz_gr_rank_k")
    ccui.Helper:seekWidgetByName(root, "Text_raning"):setString(self.rank)
    
    Image_ghz_gr_rank_k:setVisible(false)
    --头像
    local Panel_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_gh_icon")
    Panel_gh_icon:removeAllChildren(true)
    
    --名称
    local Text_gh_name = ccui.Helper:seekWidgetByName(root, "Text_gh_name")
    Text_gh_name:setString("")
    Text_gh_name:removeAllChildren(true)
    --服务器
    local Text_gh_service = ccui.Helper:seekWidgetByName(root, "Text_gh_service")
    Text_gh_service:setString("")
    --等级
    local Text_gh_lv = ccui.Helper:seekWidgetByName(root, "Text_gh_lv")
    Text_gh_lv:setString("")
    --类型
    local Text_gh_type = ccui.Helper:seekWidgetByName(root, "Text_gh_type")
    Text_gh_type:setString("")

    if self.activity then
        Panel_gh_icon:addChild(self:onHeadDraw(self.activity.userInfo.headPic, self.activity.userInfo.vipLevel))
        Text_gh_lv:setString(self.activity.userInfo.level)
        local server_name = _ED.cross_server_battel_all_servers[self.activity.serverId]
        local getStr1 = string.match(server_name, "-")
        local getStr2 = string.match(server_name, "_")
        if getStr1 and getStr1 ~= "" then
            server_name = zstring.split(server_name, "-")[1]
        elseif getStr2 and getStr2 ~= "" then
            server_name = zstring.split(server_name, "_")[1]
        end
        Text_gh_service:setString(server_name)

        if self.m_type == 1 then
            Text_gh_type:setString(self.activity.maxCombat)
        elseif self.m_type == 2 then
            Text_gh_type:setString(self.activity.feedScore)
        end

        names = self.activity.userInfo.nickName

        local c3bColorList = {71, 71, 71}
        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_digital then
            c3bColorList = {255, 255, 0}
        end

        Text_gh_name:removeAllChildren(true)
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        local _width = Text_gh_name:getContentSize().width == 0 and tonumber(Text_gh_name:getFontSize())*7 or Text_gh_name:getContentSize().width
        _richText2:setContentSize(cc.size(_width, 0))
        _richText2:setAnchorPoint(cc.p(0, 0))
        local char_str = names
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(c3bColorList[1], c3bColorList[2], c3bColorList[3]),
        cc.c3b(c3bColorList[1], c3bColorList[2], c3bColorList[3]),
        0, 
        0, 
        Text_gh_name:getFontName(), 
        Text_gh_name:getFontSize(),
        chat_rich_text_color)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPositionY(_richText2:getContentSize().height/2)
        Text_gh_name:addChild(_richText2)
    else
        Image_ghz_gr_rank_k:setVisible(true)
    end
end

function CrossServerBattelRankCell:onHeadDraw(headIndex, vipLevel)
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

function CrossServerBattelRankCell:onUpdate(dt)
    
end

function CrossServerBattelRankCell:onInit()
    local root = cacher.createUIRef("campaign/cross_service/cross_service_rank_rank.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CrossServerBattelRankCell.__size == nil then
        CrossServerBattelRankCell.__size = ccui.Helper:seekWidgetByName(root, "Image_rank"):getContentSize()
    end
    -- if tonumber(self.m_type) == 0 then
    -- 	--
    local Image_rank = ccui.Helper:seekWidgetByName(root, "Image_rank")
    -- Image_rank:setTouchEnabled(true)
    Image_rank:setSwallowTouches(false)
    fwin:addTouchEventListener(Image_rank, nil, 
    {
        terminal_name = "cross_server_battel_rank_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)
    -- end

	self:updateDraw()
end

function CrossServerBattelRankCell:onEnterTransitionFinish()
    
end

function CrossServerBattelRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_gh_icon")
    if Panel_gh_icon ~= nil then
        Panel_gh_icon:removeAllChildren(true)
    end
end

function CrossServerBattelRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function CrossServerBattelRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_rank_rank.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function CrossServerBattelRankCell:init(params)
    self.rank = tonumber(params[1])
    self.activity = params[2]
    self.m_type = tonumber(params[3])
	self:onInit()
    self:setContentSize(CrossServerBattelRankCell.__size)
    return self
end

function CrossServerBattelRankCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_rank_rank.csb", self.roots[1])
end