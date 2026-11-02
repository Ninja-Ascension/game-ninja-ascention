-----------------------------
--战地争霸的战报列表的cell
-----------------------------
ArenaRecordCell = class("ArenaRecordCellClass", Window)
ArenaRecordCell.__size = nil

local arena_record_cell_terminal = {
    _name = "arena_record_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaRecordCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_record_cell_terminal)
state_machine.init()

function ArenaRecordCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	
	app.load("client.red_alert_time.mail.MailPresentationInfo")
	
	-- app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	
 	local function init_arena_record_cell_terminal()
		local arena_record_cell_response_terminal = {
            _name = "arena_record_cell_response",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance:setVisible(false)
				-- print("1111111111111111111")
				local cell = params._datas.cells
				local function responseCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							state_machine.excute("mail_presentation_info_window_open", 0, {response.node._info ,tonumber(response.node._info.nType)})
							state_machine.excute("notification_center_update", 0, "push_notification_arena_record")
                            for i, v in pairs(_ED.city_resource_battle_report[zstring.tonumber(response.node._info.nType)]) do
								if zstring.tonumber(v.time) == zstring.tonumber(response.node._info.time) then
									_ED.city_resource_battle_report[zstring.tonumber(response.node._info.nType)][i].read_type = 1
								end
							end
							response.node:onUpdateDraw()
						end	
					end
				end
				protocol_command.battlefield_report_details_get.param_list = cell._info.nType.."\r\n"..cell._info.time
				NetworkManager:register(protocol_command.battlefield_report_details_get.code, nil, nil, nil, cell, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(arena_record_cell_response_terminal)
        state_machine.init()
    end
	init_arena_record_cell_terminal()        	
end


function ArenaRecordCell:onUpdateDraw()
	local root = self.roots[1]
	--攻守显示
	local Text_record_state = ccui.Helper:seekWidgetByName(root, "Text_record_state")
	local Text_record_rank_n = ccui.Helper:seekWidgetByName(root, "Text_record_rank_n")
	--标题信息
	local Text_record_battle_infor = ccui.Helper:seekWidgetByName(root, "Text_record_battle_infor")
	Text_record_battle_infor:removeAllChildren(true)
	local attachedInfo = zstring.split(self._info.param, "|")
	if tonumber(attachedInfo[4]) < 0 then
		Text_record_rank_n:setString(attachedInfo[4])
        Text_record_rank_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		Text_record_rank_n:setString("+"..attachedInfo[4])
        Text_record_rank_n:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
	end
	if tonumber(attachedInfo[1]) == 0 then 
		--攻
		if tonumber(self._info.result) == 1 then
			Text_record_state:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			Text_record_state:setString(arena_tip_text[2]) --胜利
		else
			Text_record_state:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
			Text_record_state:setString(arena_tip_text[3]) --失败
		end
		local _richText1 = ccui.RichText:create()
		_richText1:ignoreContentAdaptWithSize(false)
		local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
		local re1 = nil
		local re2 = nil
		if tonumber(self._info.nType) == 11 then
			re1 =ccui.RichElementText:create(1, color1,255, arena_tip_text[6], config_res.font.font_name,20)
			re2 =ccui.RichElementText:create(1, color2,255, self._info.userName..string.format(red_alert_all_str[13], ""..self._info.userLevel), config_res.font.font_name,20)
			_richText1:pushBackElement(re1)
			_richText1:pushBackElement(re2)
		else
			local attackInfo = zstring.split(attachedInfo[2], ",")
			local defendInfo = zstring.split(attachedInfo[3], ",")
			
			re1 =ccui.RichElementText:create(1, color2,255, attackInfo[1]..string.format(red_alert_all_str[13], ""..attackInfo[3]), config_res.font.font_name,20)
			re2 =ccui.RichElementText:create(1, color1,255, arena_tip_text[11], config_res.font.font_name,20)
			re3 =ccui.RichElementText:create(1, color2,255, defendInfo[1]..string.format(red_alert_all_str[13], ""..defendInfo[3]), config_res.font.font_name,20)
			
			_richText1:pushBackElement(re1)
			_richText1:pushBackElement(re2)
			_richText1:pushBackElement(re3)
		end
		
		_richText1:setContentSize(cc.size(Text_record_battle_infor:getContentSize().width,Text_record_battle_infor:getContentSize().height))
		_richText1:setAnchorPoint(0,0.5)
		_richText1:setPosition(cc.p(-Text_record_battle_infor:getContentSize().width/2,Text_record_battle_infor:getContentSize().height/2))
		Text_record_battle_infor:addChild(_richText1)		
	else
		if tonumber(self._info.result) == 1 then
			Text_record_state:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			Text_record_state:setString(arena_tip_text[4]) --胜利
		else
			Text_record_state:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
			Text_record_state:setString(arena_tip_text[5]) --失败
		end
		--守
		local _richText1 = ccui.RichText:create()
		_richText1:ignoreContentAdaptWithSize(false)
		local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
		local re1 = nil
		local re2 = nil
		if tonumber(self._info.nType) == 11 then
			re1 = ccui.RichElementText:create(1, color1,255, arena_tip_text[7], config_res.font.font_name,20)
			re2 = ccui.RichElementText:create(1, color2,255, self._info.userName..string.format(red_alert_all_str[13], ""..self._info.userLevel), config_res.font.font_name,20)
			_richText1:pushBackElement(re2)
			_richText1:pushBackElement(re1)
		else
			local attackInfo = zstring.split(attachedInfo[2], ",")
			local defendInfo = zstring.split(attachedInfo[3], ",")
			re1 =ccui.RichElementText:create(1, color2,255, attackInfo[1]..string.format(red_alert_all_str[13], ""..attackInfo[3]), config_res.font.font_name,20)
			re2 =ccui.RichElementText:create(1, color1,255, arena_tip_text[11], config_res.font.font_name,20)
			re3 =ccui.RichElementText:create(1, color2,255, defendInfo[1]..string.format(red_alert_all_str[13], ""..defendInfo[3]), config_res.font.font_name,20)
			
			_richText1:pushBackElement(re3)
			_richText1:pushBackElement(re2)
			_richText1:pushBackElement(re1)
		end
		_richText1:setContentSize(cc.size(Text_record_battle_infor:getContentSize().width,Text_record_battle_infor:getContentSize().height))
		_richText1:setAnchorPoint(0,0.5)
		_richText1:setPosition(cc.p(-Text_record_battle_infor:getContentSize().width/2,Text_record_battle_infor:getContentSize().height/2))
		Text_record_battle_infor:addChild(_richText1)
	end
	
	--已读和未读的
	local Panel_mail_icon = ccui.Helper:seekWidgetByName(root, "Panel_mail_icon")
	local Image_line_bg = ccui.Helper:seekWidgetByName(root, "Image_line_bg")
	local Image_line_icon_read = ccui.Helper:seekWidgetByName(root, "Image_line_icon_read")
	local Image_mail_line = ccui.Helper:seekWidgetByName(root,"Image_mail_line")
    local Image_mail_line_read = ccui.Helper:seekWidgetByName(root,"Image_mail_line_read")
    Image_mail_line:setVisible(false)
    Image_mail_line_read:setVisible(false)
	Panel_mail_icon:removeBackGroundImage()
	Image_line_bg:setVisible(false)
	Image_line_icon_read:setVisible(false)
	local image_name = ""
	local image_bg = ""
	if zstring.tonumber(self._info.read_type) == 0 then
		--未读
	    Image_line_bg:setVisible(true)
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
	Text_record_battle_time:setString(self:getTimeFormatYMDHMS(tonumber(self._info.time)/1000))
end

function ArenaRecordCell:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",getBaseGTM8Time(m_time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year .."-".. m_month .."-".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

function ArenaRecordCell:onEnterTransitionFinish()

end

function ArenaRecordCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_record_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if ArenaRecordCell.__size == nil then
		ArenaRecordCell.__size = root:getContentSize()
	end
	
	--查看
	fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "arena_record_cell_response", 
        terminal_state = 0, 
        cells = self,
    }, nil, 1)

	self:onUpdateDraw()
end

function ArenaRecordCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_record_state = ccui.Helper:seekWidgetByName(root, "Text_record_state")
	local Text_record_battle_infor = ccui.Helper:seekWidgetByName(root, "Text_record_battle_infor")
	local Panel_mail_icon = ccui.Helper:seekWidgetByName(root, "Panel_mail_icon")
	local Image_line_bg = ccui.Helper:seekWidgetByName(root, "Image_line_bg")
	local Text_record_battle_time = ccui.Helper:seekWidgetByName(root, "Text_record_battle_time")
	if Text_record_state ~= nil then
		Text_record_battle_infor:removeAllChildren(true)
		Panel_mail_icon:removeBackGroundImage()
		Image_line_bg:removeAllChildren(true)
		Text_record_state:setString("")
		Text_record_battle_time:setString("")
	end
end

function ArenaRecordCell:onExit()
    local root = self.roots[1]
	self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_record_cell, root)
end

function ArenaRecordCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRecordCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_record_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRecordCell:init(params)
	self._info = params[1]
    self._index = params[2]
	if self._index ~= nil and self._index <= 9 then
        self:onInit()
    end
	self:setContentSize(ArenaRecordCell.__size)
	return self
end

