-- ------------------------------------------------------------------------------------------------------------
--  军团pk列表cell
-- ------------------------------------------------------------------------------------------------------------
LegionPKRecordCell = class("LegionPKRecordCellClass", Window)
LegionPKRecordCell.__size = nil

--创建cell
local legion_pk_record_create_cell_terminal = {
    _name = "legion_pk_record_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionPKRecordCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_pk_record_create_cell_terminal)
state_machine.init()

function LegionPKRecordCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0

    app.load("client.red_alert_time.mail.MailPresentationInfo")
    local function init_legion_pk_record_cell_terminal()
        local legion_pk_record_cell_click_terminal = {
            _name = "legion_pk_record_cell_click",
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
                            state_machine.excute("mail_presentation_info_window_open", 0, {response.node._info_data ,tonumber(response.node._info_data.nType)})
                            for i, v in pairs(_ED.city_resource_battle_report[zstring.tonumber(response.node._info_data.nType)]) do
                                if zstring.tonumber(v.time) == zstring.tonumber(response.node._info_data.time) then
                                    _ED.city_resource_battle_report[zstring.tonumber(response.node._info_data.nType)][i].read_type = 1
                                end
                            end
                            response.node:updateDraw()
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

        state_machine.add(legion_pk_record_cell_click_terminal)
        state_machine.init()
    end
    init_legion_pk_record_cell_terminal()
end

function LegionPKRecordCell:updateDraw()
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
    Image_box_bg_hook:setVisible(true)

    Panel_player_head_1:removeAllChildren(true)
    Panel_player_head_2:removeAllChildren(true)
    Panel_fighting_settlement_1:removeBackGroundImage()
    Panel_fighting_settlement_2:removeBackGroundImage()
    Text_vs_fighting_1:removeAllChildren(true)
    Text_vs_fighting_2:removeAllChildren(true)

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
            Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            avatar_info_2._isGray = true
        else
            quality_1 = 6
            quality_2 = 1
            Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            avatar_info_1._isGray = true
        end
    else
        if tonumber(self._info_data.result) == 1 then
            quality_1 = 6
            quality_2 = 1
            Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            avatar_info_1._isGray = true
        else
            quality_1 = 1
            quality_2 = 6
            Panel_fighting_settlement_2:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 2))
            Panel_fighting_settlement_1:setBackGroundImage(string.format(config_res.images.ui.legion.vs_fighting_settlement, 3))
            avatar_info_2._isGray = true
        end
    end
    cell_1:init(avatar_info_1)
    cell_2:init(avatar_info_2)
    Panel_player_head_1:addChild(cell_1)
    Panel_player_head_2:addChild(cell_2)

    local attacker_type = tonumber(attacker[4])
    local defender_type = tonumber(defender[4])
    Text_player_position_1:setString(tip_legion_player_position[attacker_type])
    Text_player_position_1:setColor(cc.c3b(tipStringInfo_union_color[attacker_type][1],tipStringInfo_union_color[attacker_type][2],tipStringInfo_union_color[attacker_type][3]))
    Text_player_position_2:setString(tip_legion_player_position[defender_type])
    Text_player_position_2:setColor(cc.c3b(tipStringInfo_union_color[defender_type][1],tipStringInfo_union_color[defender_type][2],tipStringInfo_union_color[defender_type][3]))

    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    local fontSize = Text_vs_fighting_1:getFontSize()
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_1][1],color_Type[quality_1][2],color_Type[quality_1][3]),255, "("..attacker[6].."%)", config_res.font.font_name,fontSize)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, attacker[1], fontName,fontSize)
    _richText_1:pushBackElement(re2)  
    _richText_1:setContentSize(cc.size(Text_vs_fighting_1:getContentSize().width,fontSize))
    _richText_1:formatTextExt()
    _richText_1:setPosition(cc.p(Text_vs_fighting_1:getContentSize().width,Text_vs_fighting_1:getContentSize().height/2))
    Text_vs_fighting_1:addChild(_richText_1)

    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, defender[1], fontName,fontSize)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_2][1],color_Type[quality_2][2],color_Type[quality_2][3]),255,  "("..defender[6].."%)", config_res.font.font_name,fontSize)
    _richText_2:pushBackElement(re2)
    _richText_2:setContentSize(cc.size(Text_vs_fighting_2:getContentSize().width,fontSize))
    _richText_2:formatTextExt()
    _richText_2:setPosition(cc.p(Text_vs_fighting_2:getContentSize().width,Text_vs_fighting_2:getContentSize().height/2))
    Text_vs_fighting_2:addChild(_richText_2)

    if attacker[1] == _ED.user_info.user_name or defender[1] == _ED.user_info.user_name then
        Image_box_bg_hook:setVisible(true)
    else
        Image_box_bg_hook:setVisible(false)
    end
end

function LegionPKRecordCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_member_vs_fighting_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_box_bg"), nil, 
    {
        terminal_name = "legion_pk_record_cell_click", 
        terminal_state = 0,
        cell = self,
    }, nil, 1)

    if LegionPKRecordCell.__size == nil then
        LegionPKRecordCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionPKRecordCell:onEnterTransitionFinish()

end

function LegionPKRecordCell:clearUIInfo( ... )
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
    end
end

function LegionPKRecordCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionPKRecordCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_member_vs_fighting_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionPKRecordCell:init(info_data, index)
    self._info_data = info_data
    self._index = index 
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(LegionPKRecordCell.__size)
    return self
end

function LegionPKRecordCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_member_vs_fighting_cell, self.roots[1])
end

