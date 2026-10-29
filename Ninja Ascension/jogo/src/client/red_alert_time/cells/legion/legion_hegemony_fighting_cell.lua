-- ------------------------------------------------------------------------------------------------------------
--  军团争霸战况cell
-- ------------------------------------------------------------------------------------------------------------
LegionHegemonyFightingCell = class("LegionHegemonyFightingCellClass", Window)
LegionHegemonyFightingCell.__size = nil

--创建cell
local legion_hegemony_fighting_cell_create_terminal = {
    _name = "legion_hegemony_fighting_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionHegemonyFightingCell:new()
        local index = params[1]
        local info = params[2]
        local from_type = params[3]
        local isInit = params[4]
        cell:init(index, info, from_type, isInit)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_hegemony_fighting_cell_create_terminal)
state_machine.init()

function LegionHegemonyFightingCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info_data = nil
    self._index = 0
    self._isInit = false

    self._report_type = 0

    local function init_legion_hegemony_fighting_cell_terminal()
        local legion_hegemony_fighting_cell_show_info_terminal = {
            _name = "legion_hegemony_fighting_cell_show_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            app.load("client.red_alert_time.mail.MailPresentationInfo")
                            state_machine.excute("mail_presentation_info_window_open", 0, {response.node._info_data, tonumber(response.node._info_data.nType)})
                            for i, v in pairs(_ED.city_resource_battle_report[zstring.tonumber(response.node._info_data.nType)]) do
                                if zstring.tonumber(v.time) == zstring.tonumber(response.node._info_data.time) then
                                    _ED.city_resource_battle_report[zstring.tonumber(response.node._info_data.nType)][i].read_type = 1
                                end
                            end
                            response.node:updateDraw2()
                        end
                    end
                end
                protocol_command.battlefield_report_details_get.param_list = cell._info_data.nType.."\r\n"..cell._info_data.time
                NetworkManager:register(protocol_command.battlefield_report_details_get.code, nil, nil, nil, cell, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(legion_hegemony_fighting_cell_show_info_terminal)
    end
    
    init_legion_hegemony_fighting_cell_terminal()
end

function LegionHegemonyFightingCell:playMemberVsEffect(isNewReport)
    if isNewReport == false then
        return
    end

    local root = self.roots[1]
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_member_vs)
    local armature = ccs.Armature:create("effect_member_vs")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(root:getContentSize().width / 2, root:getContentSize().height / 2))
    armature:setTag(1000)
    root:addChild(armature)
end


function LegionHegemonyFightingCell:updateDraw1(isNewReport)
    local root = self.roots[1]
    local Text_hegemony_fighting_infor = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fighting_infor")
    local Image_box_bg_hook = ccui.Helper:seekWidgetByName(root, "Image_box_bg_hook")
    Text_hegemony_fighting_infor:removeAllChildren(true)
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)
    Image_box_bg_hook:setVisible(false)

    local fontSize = Text_hegemony_fighting_infor:getFontSize()
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    if self._info_data.isNpc ~= nil and self._info_data.isNpc == true then
        fontName = config_res.font.font_name
    end
    local param_info =  zstring.split(self._info_data.param, "|")
    local info = zstring.split(param_info[2], ",")
    if self._report_type == 2 then -- 连胜
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_union_str[120], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]),255, info[1], fontName,fontSize)
        _richText_1:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_union_str[121], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re3)  
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]),255, info[2], fontName,fontSize)
        _richText_1:pushBackElement(re4)  
        local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, string.format(tipStringInfo_union_str[122], tonumber(info[3])), config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re5)
    elseif self._report_type == 3 then -- 军团淘汰
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]),255, info[1], fontName,fontSize)
        _richText_1:pushBackElement(re1)
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_union_str[123], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re2)  
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]),255, info[2], fontName,fontSize)
        _richText_1:pushBackElement(re3)  
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_union_str[124], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re4)
        local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]),255, info[3], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re5)  
        local re6 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_union_str[125], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re6)
    elseif self._report_type == 4 then -- 军团战结束
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_union_str[126], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]),255, info[1], fontName,fontSize)
        _richText_1:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_union_str[127], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re3)  
    elseif self._report_type == 5 then
        local result = tonumber(info[1])
        local top_legion = info[2]
        local info_str = tipStringInfo_campaign_info[59 + result]
        info_str =  string.gsub(info_str, "!x@", top_legion)
        local rt, count, text = draw.richTextCollectionMethod(_richText_1, 
            info_str, 
            cc.c3b(255, 255, 255),
            cc.c3b(255, 255, 255),
            0, 
            0, 
            config_res.font.font_name, 
            20,
            chat_rich_text_color)   
    end

    if self._from_type == 2 or self._from_type == 3 then
        Image_box_bg_hook:setVisible(true)
    end

    _richText_1:setPosition(cc.p(Text_hegemony_fighting_infor:getContentSize().width/2,Text_hegemony_fighting_infor:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_hegemony_fighting_infor:getContentSize().width, Text_hegemony_fighting_infor:getContentSize().height))
    Text_hegemony_fighting_infor:addChild(_richText_1)
end

function LegionHegemonyFightingCell:updateDraw2(isNewReport)
    local root = self.roots[1]
    local Panel_player_head_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_head_1")
    local Text_player_position_1 = ccui.Helper:seekWidgetByName(root, "Text_player_position_1")
    local Panel_player_head_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_head_2")
    local Text_player_position_2 = ccui.Helper:seekWidgetByName(root, "Text_player_position_2")
    local Text_vs_time = ccui.Helper:seekWidgetByName(root, "Text_vs_time")
    local Text_vs_fighting_1 = ccui.Helper:seekWidgetByName(root, "Text_vs_fighting_1")
    local Text_vs_fighting_2 = ccui.Helper:seekWidgetByName(root, "Text_vs_fighting_2")
    local Panel_fighting_settlement_1 = ccui.Helper:seekWidgetByName(root, "Panel_fighting_settlement_1")
    local Panel_fighting_settlement_2 = ccui.Helper:seekWidgetByName(root, "Panel_fighting_settlement_2")
    local Image_box_bg_hook = ccui.Helper:seekWidgetByName(root, "Image_box_bg_hook")
    local BitmapFontLabel_settlement_1 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_settlement_1")
    local BitmapFontLabel_settlement_2 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_settlement_2")
    Panel_player_head_1:removeAllChildren(true)
    Panel_player_head_2:removeAllChildren(true)
    Panel_fighting_settlement_1:removeBackGroundImage()
    Panel_fighting_settlement_2:removeBackGroundImage()
    Text_vs_fighting_1:removeAllChildren(true)
    Text_vs_fighting_2:removeAllChildren(true)
    BitmapFontLabel_settlement_1:setString("")
    BitmapFontLabel_settlement_2:setString("")

    -- 时间
    local time_info = os.date("%H:%M", zstring.exchangeFrom(zstring.tonumber(self._info_data.time)/1000))
    Text_vs_time:setString(time_info)

    local param = zstring.split(self._info_data.param, "|")
    local attacker = zstring.split(param[2], ",")   -- 攻击方信息
    local defender = zstring.split(param[3], ",")   -- 防守方信息

    local cell_1 = PlayerHeadIcon:createCell()
    local avatar_info_1 = {}
    avatar_info_1.object = param[4]
    avatar_info_1.vip = 0
    avatar_info_1._type = 0

    local cell_2 = PlayerHeadIcon:createCell()
    local avatar_info_2 = {}
    avatar_info_2.object = param[5]
    avatar_info_2.vip = 0
    avatar_info_2._type = 0

    local quality_1 = 1
    local quality_2 = 1
    if tonumber(param[1]) == 0 then 
        if tonumber(self._info_data.result) == 1 then
            quality_1 = 1
            quality_2 = 6
            if zstring.tonumber(attacker[5]) > 1 then
                BitmapFontLabel_settlement_1:setString(attacker[5])
                Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 1))
            else
                Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            end
            Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            avatar_info_2._isGray = true
        else
            quality_1 = 6
            quality_2 = 1
            if zstring.tonumber(defender[5]) > 1 then
                BitmapFontLabel_settlement_2:setString(defender[5])
                Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 1))
            else
                Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            end
            Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            avatar_info_1._isGray = true
        end
    else
        if tonumber(self._info_data.result) == 1 then
            quality_1 = 6
            quality_2 = 1
            if zstring.tonumber(defender[5]) > 1 then
                BitmapFontLabel_settlement_2:setString(defender[5])
                Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 1))
            else
                Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            end
            Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            avatar_info_1._isGray = true
        else
            quality_1 = 1
            quality_2 = 6
            if zstring.tonumber(attacker[5]) > 1 then
                BitmapFontLabel_settlement_1:setString(attacker[5])
                Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 1))
            else
                Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            end
            Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            avatar_info_2._isGray = true
        end
    end
    cell_1:init(avatar_info_1)
    cell_2:init(avatar_info_2)
    Panel_player_head_1:addChild(cell_1)
    Panel_player_head_2:addChild(cell_2)

    Text_player_position_1:setString(attacker[1])
    Text_player_position_2:setString(defender[1])

    local font_size = Text_vs_fighting_1:getFontSize()
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    local fontSize2 = Text_player_position_1:getFontSize()
    Text_player_position_1:setFontName(fontName)
    Text_player_position_1:setFontSize(fontSize2)
    Text_player_position_2:setFontName(fontName)
    Text_player_position_2:setFontSize(fontSize2)
    local _richText_1 = ccui.RichText:create()
    _richText_1:setContentSize(cc.size(Text_vs_fighting_1:getContentSize().width, font_size))
    _richText_1:ignoreContentAdaptWithSize(false)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_1][1],color_Type[quality_1][2],color_Type[quality_1][3]),255, "("..attacker[4].."%)", config_res.font.font_name,font_size)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, attacker[2], fontName,font_size)
    _richText_1:pushBackElement(re2)
    _richText_1:formatTextExt()
    _richText_1:setPosition(cc.p(Text_vs_fighting_1:getContentSize().width,Text_vs_fighting_1:getContentSize().height))
    Text_vs_fighting_1:addChild(_richText_1)

    local _richText_2 = ccui.RichText:create()
    _richText_2:setContentSize(cc.size(Text_vs_fighting_2:getContentSize().width,font_size))
    _richText_2:ignoreContentAdaptWithSize(false)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, defender[2], fontName,font_size)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_2][1],color_Type[quality_2][2],color_Type[quality_2][3]),255,  "("..defender[4].."%)", config_res.font.font_name,font_size)
    _richText_2:pushBackElement(re2)
    _richText_2:formatTextExt()
    _richText_2:setPosition(cc.p(Text_vs_fighting_2:getContentSize().width,Text_vs_fighting_2:getContentSize().height))
    Text_vs_fighting_2:addChild(_richText_2)

    if self._from_type <= 3 then
        if attacker[2] == _ED.union.union_info.union_name or defender[2] == _ED.union.union_info.union_name then
            Image_box_bg_hook:setVisible(true)
        else
            Image_box_bg_hook:setVisible(false)
        end
    elseif self._from_type <= 5 then
        if attacker[1] == _ED.user_info.user_name or defender[1] == _ED.user_info.user_name then
            Image_box_bg_hook:setVisible(true)
        else
            Image_box_bg_hook:setVisible(false)
        end
    end

    self:playMemberVsEffect(isNewReport)
end

function LegionHegemonyFightingCell:onInit(isNewReport)
    local root = nil
    if self._report_type < 2 then
        root = cacher.createUIRef(config_csb.cells.legion.legion_member_vs_fighting_cell, "root")
        table.insert(self.roots, root)
        self:addChild(root)

        if isNewReport == true then
            local action = csb.createTimeline(config_csb.cells.legion.legion_member_vs_fighting_cell)
            table.insert(self.actions, action)
            root:runAction(action)
            action:play("legion_memeber_vs", false)
        end

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_box_bg"), nil, 
        {
            terminal_name = "legion_hegemony_fighting_cell_show_info", 
            terminal_state = 0,
            cell = self,
        }, nil, 1)
        self:updateDraw2(isNewReport)
    else
        root = cacher.createUIRef(config_csb.cells.legion.legion_hegemony_fighting_cell, "root")
        table.insert(self.roots, root)
        self:addChild(root)

        self:updateDraw1(isNewReport)
    end

    if LegionHegemonyFightingCell.__size == nil then
        LegionHegemonyFightingCell.__size = root:getContentSize()
    end
end

function LegionHegemonyFightingCell:onEnterTransitionFinish()

end

function LegionHegemonyFightingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit(false)
end

function LegionHegemonyFightingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    if self._report_type < 2 then
        cacher.freeRef(config_csb.cells.legion.legion_member_vs_fighting_cell, root)
    else
        cacher.freeRef(config_csb.cells.legion.legion_hegemony_fighting_cell, root)
    end
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function LegionHegemonyFightingCell:clearUIInfo( ... )
    local root = self.roots[1]
    if self._report_type < 2 then
        local Panel_player_head_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_head_1")
        local Text_player_position_1 = ccui.Helper:seekWidgetByName(root, "Text_player_position_1")
        local Panel_player_head_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_head_2")
        local Text_player_position_2 = ccui.Helper:seekWidgetByName(root, "Text_player_position_2")
        local Text_vs_time = ccui.Helper:seekWidgetByName(root, "Text_vs_time")
        local Text_vs_fighting_1 = ccui.Helper:seekWidgetByName(root, "Text_vs_fighting_1")
        local Text_vs_fighting_2 = ccui.Helper:seekWidgetByName(root, "Text_vs_fighting_2")
        local Panel_fighting_settlement_1 = ccui.Helper:seekWidgetByName(root, "Panel_fighting_settlement_1")
        local Panel_fighting_settlement_2 = ccui.Helper:seekWidgetByName(root, "Panel_fighting_settlement_2")
        local Image_box_bg_hook = ccui.Helper:seekWidgetByName(root, "Image_box_bg_hook")
        local BitmapFontLabel_settlement_1 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_settlement_1")
        local BitmapFontLabel_settlement_2 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_settlement_2")
        if Panel_player_head_1 ~= nil then
            Panel_player_head_1:removeAllChildren(true)
            Panel_player_head_2:removeAllChildren(true)
            Panel_fighting_settlement_1:removeBackGroundImage()
            Panel_fighting_settlement_2:removeBackGroundImage()
            Text_player_position_1:setString("")
            Text_player_position_2:setString("")
            Text_vs_time:setString("")
            Text_vs_fighting_1:setString("")
            Text_vs_fighting_2:setString("")
            Text_vs_fighting_1:removeAllChildren(true)
            Text_vs_fighting_2:removeAllChildren(true)
            Image_box_bg_hook:setVisible(false)
            BitmapFontLabel_settlement_1:setString("")
            BitmapFontLabel_settlement_2:setString("")
            if root:getChildByTag(1000) ~= nil then
                root:removeChildByTag(1000)
            end
        end
    else
        local Text_hegemony_fighting_infor = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fighting_infor")
        local Image_box_bg_hook = ccui.Helper:seekWidgetByName(root, "Image_box_bg_hook")
        if Text_hegemony_fighting_infor ~= nil then
            Text_hegemony_fighting_infor:removeAllChildren(true)
            Image_box_bg_hook:setVisible(false)
        end
    end
end

function LegionHegemonyFightingCell:init(index, info, from_type, isInit)
    self._index = index 
    self._info_data = info
    self._from_type = from_type
    self._isInit = isInit
    self._info_data.isShowed = true

    local param_info = zstring.split(self._info_data.param, "|")
    self._report_type = tonumber(param_info[1])

    if self._isInit == true then
        if index ~= nil and index <= 8 then
            self:onInit(false)
        end
    else
        self:onInit(true)
    end
    self:setContentSize(LegionHegemonyFightingCell.__size)
    return self
end

function LegionHegemonyFightingCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    if self._report_type < 2 then
        cacher.freeRef(config_csb.cells.legion.legion_member_vs_fighting_cell, root)
    else
        cacher.freeRef(config_csb.cells.legion.legion_hegemony_fighting_cell, root)
    end
end

