-- ---------------------------
-- 远征战报cell
-- ---------------------------
ExpeditionRecordCell = class("ExpeditionRecordCellClass", Window)
ExpeditionRecordCell.__size = nil

--创建cell
local expedition_record_create_cell_terminal = {
    _name = "expedition_record_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ExpeditionRecordCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(expedition_record_create_cell_terminal)
state_machine.init()

function ExpeditionRecordCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0

    app.load("client.red_alert_time.mail.MailPresentationInfo")
    local function init_expedition_record_cell_terminal()
        local expedition_record_cell_click_terminal = {
            _name = "expedition_record_cell_click",
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

        state_machine.add(expedition_record_cell_click_terminal)
        state_machine.init()
    end
    init_expedition_record_cell_terminal()
end

function ExpeditionRecordCell:updateDraw()
	local root = self.roots[1]
	--攻守显示
	local Text_record_state = ccui.Helper:seekWidgetByName(root, "Text_record_state")
	--标题信息   
	local Text_record_battle_infor = ccui.Helper:seekWidgetByName(root, "Text_record_battle_infor")
	Text_record_battle_infor:removeAllChildren(true)
	local Text_record_battleintegral = ccui.Helper:seekWidgetByName(root, "Text_record_battleintegral")
	Text_record_battleintegral:removeAllChildren(true)
	local attachedInfo = zstring.split(self._info_data.param, "|")

	local _richText1 = ccui.RichText:create()
	_richText1:ignoreContentAdaptWithSize(false)
	local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
	local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
	local re1 = nil
	local re2 = nil
	if tonumber(self._info_data.nType) == 11 then
		re1 = ccui.RichElementText:create(1, color1,255, arena_tip_text[7], config_res.font.font_name,20)
		re2 = ccui.RichElementText:create(1, color2,255, self._info_data.userName..string.format(red_alert_all_str[13], ""..self._info_data.userLevel), config_res.font.font_name,20)
		_richText1:pushBackElement(re2)
		_richText1:pushBackElement(re1)
	else
		local attackInfo = zstring.split(attachedInfo[2], ",")
		local defendInfo = zstring.split(attachedInfo[3], ",")
		re1 = ccui.RichElementText:create(1, color1,255, string.format(mail_tip_text[24],(attachedInfo[4]+1)), config_res.font.font_name,20)
		re2 = ccui.RichElementText:create(1, color2,255, defendInfo[1]..string.format(red_alert_all_str[13], ""..defendInfo[3]), config_res.font.font_name,20)
		
		_richText1:pushBackElement(re1)
		_richText1:pushBackElement(re2)
	end
	_richText1:setContentSize(cc.size(Text_record_battle_infor:getContentSize().width,Text_record_battle_infor:getContentSize().height))
	_richText1:setAnchorPoint(0,0.5)
	_richText1:setPosition(cc.p(-Text_record_battle_infor:getContentSize().width/2,Text_record_battle_infor:getContentSize().height/2))
	Text_record_battle_infor:addChild(_richText1)
	local attached_integral = "0,0,0"
	if attachedInfo[5] ~= nil then
		attached_integral = zstring.split(attachedInfo[5], ",")
	end
	local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, mail_tip_text[25], "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, "+"..zstring.tonumber(attached_integral[3]), "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re2)
    _richText_2:setPosition(cc.p(Text_record_battleintegral:getContentSize().width/2,Text_record_battleintegral:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_record_battleintegral:getContentSize().width,20))
    Text_record_battleintegral:addChild(_richText_2)

	if tonumber(attachedInfo[1]) == 0 then 
		--攻
		if tonumber(self._info_data.result) == 1 then
			Text_record_state:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			Text_record_state:setString(arena_tip_text[28]) --胜利
		else
			Text_record_state:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
			Text_record_state:setString(arena_tip_text[29]) --失败
		end
	else
		if tonumber(self._info_data.result) == 1 then
			Text_record_state:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			Text_record_state:setString(arena_tip_text[4]) --胜利
		else
			Text_record_state:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
			Text_record_state:setString(arena_tip_text[5]) --失败
		end
	end
	
	--已读和未读的
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root, "Panel_mail_icon")
    local Image_line_icon = ccui.Helper:seekWidgetByName(root, "Image_line_icon")
    local Image_line_icon_read = ccui.Helper:seekWidgetByName(root, "Image_line_icon_read")
    local Image_mail_line = ccui.Helper:seekWidgetByName(root,"Image_mail_line")
    local Image_mail_line_read = ccui.Helper:seekWidgetByName(root,"Image_mail_line_read")
    Image_mail_line:setVisible(false)
    Image_mail_line_read:setVisible(false)
    Panel_mail_icon:removeBackGroundImage()
    Image_line_icon:setVisible(false)
    Image_line_icon_read:setVisible(false)
    local image_name = ""
    local image_bg = ""
    if zstring.tonumber(self._info_data.read_type) == 0 then
        --未读
        Image_line_icon:setVisible(true)
        Image_mail_line:setVisible(true)
        image_name = string.format(config_res.images.ui.share.world_implement_icon, 10)
    else
        --已读
        Image_line_icon_read:setVisible(true)
        Image_mail_line_read:setVisible(true)
        image_name = string.format(config_res.images.ui.share.world_implement_icon, 9)
    end
    Panel_mail_icon:setBackGroundImage(image_name)
	
	--时间
	local Text_record_battle_time = ccui.Helper:seekWidgetByName(root, "Text_record_battle_time")
	local time_info = os.date("%Y-%m-%d".." ".."%H:%M:%S", zstring.exchangeFrom(zstring.tonumber(self._info_data.time)/1000))
    Text_record_battle_time:setString(time_info)
end

function ExpeditionRecordCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.expedition_record_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "expedition_record_cell_click", 
        terminal_state = 0,
        cell = self,
    }, nil, 1)

    if ExpeditionRecordCell.__size == nil then
        ExpeditionRecordCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function ExpeditionRecordCell:onEnterTransitionFinish()

end

function ExpeditionRecordCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_record_state = ccui.Helper:seekWidgetByName(root, "Text_record_state")
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root, "Panel_mail_icon")
    local Text_record_battle_infor = ccui.Helper:seekWidgetByName(root, "Text_record_battle_infor")
    local Text_record_battle_time = ccui.Helper:seekWidgetByName(root, "Text_record_battle_time")
    local Text_record_battleintegral = ccui.Helper:seekWidgetByName(root, "Text_record_battleintegral")
    if Text_record_state ~= nil then
        Text_record_state:setString("")
        Panel_mail_icon:removeAllChildren(true)
        Text_record_battle_infor:removeAllChildren(true)
        Text_record_battle_time:setString("")
        Text_record_battleintegral:removeAllChildren(true)
    end
end

function ExpeditionRecordCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExpeditionRecordCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.expedition_record_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ExpeditionRecordCell:init(info_data, index)
    self._info_data = info_data
    self._index = index 
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(ExpeditionRecordCell.__size)
    return self
end

function ExpeditionRecordCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.expedition_record_cell, self.roots[1])
end

