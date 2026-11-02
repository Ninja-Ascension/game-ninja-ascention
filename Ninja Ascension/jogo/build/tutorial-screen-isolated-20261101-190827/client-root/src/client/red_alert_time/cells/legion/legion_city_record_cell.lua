-----------------------------
--战地争霸的战报列表的cell
-----------------------------
LegionCityRecordCell = class("LegionCityRecordCellClass", Window)
LegionCityRecordCell.__size = nil

local legion_city_record_cell_create_terminal = {
    _name = "legion_city_record_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionCityRecordCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_record_cell_create_terminal)
state_machine.init()

function LegionCityRecordCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._info = nil
    
    app.load("client.red_alert_time.mail.MailPresentationInfo")
    
    -- app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    
    local function init_legion_city_record_cell_terminal()
        local legion_city_record_cell_response_terminal = {
            _name = "legion_city_record_cell_response",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("mail_presentation_info_window_open", 0, {response.node._info ,tonumber(response.node._info.nType)})
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
    
        state_machine.add(legion_city_record_cell_response_terminal)
        state_machine.init()
    end
    init_legion_city_record_cell_terminal()           
end


function LegionCityRecordCell:onUpdateDraw()
    local root = self.roots[1]
    --攻守显示
    local Text_city_record_t = ccui.Helper:seekWidgetByName(root, "Text_city_record_t")
    --标题信息
    local Text_legion_city_record_infor = ccui.Helper:seekWidgetByName(root, "Text_legion_city_record_infor")
    Text_legion_city_record_infor:removeAllChildren(true)
    local attachedInfo = zstring.split(self._info.param, "|")
    local attackInfo = zstring.split(attachedInfo[2], ",")
    local defenceInfo = zstring.split(attachedInfo[3], ",")
    local result = tonumber(self._info.result)
    if tonumber(defenceInfo[4]) == tonumber(_ED.union.union_info.union_id) then
        local temp = attackInfo
        attackInfo = defenceInfo
        defenceInfo = temp

        if tonumber(self._info.nType) == 10007 then
            if result == 1 then
                result = 0
            else
                result = 1
            end
        end
    end

    local other_info = zstring.split(attachedInfo[4], ",")
    local open_state = zstring.tonumber(other_info[3])
    local record_type = zstring.tonumber(other_info[4])

    -- 城市名
    local Text_legion_city_record_name = ccui.Helper:seekWidgetByName(root, "Text_legion_city_record_name")
    local world_city_name = dms.string(dms["world_city_mould"], other_info[1], world_city_mould.name)
    Text_legion_city_record_name:setString(world_city_name)

    local info = ""
    local color_index = 0
    local state_info = ""
    if record_type == 0 then
        -- 战斗报告
        local result_type = 0
        local defence_type = 0

        if result == 1 then        -- 胜利
            result_type = 1
            state_info = world_city_tip_str[35]
            color_index = 2
            if open_state > 0 and tonumber(other_info[2]) == 0 then
                defence_type = 1
                state_info = world_city_tip_str[37]
            end
        else
            result_type = 2
            state_info = world_city_tip_str[36]
            color_index = 6
            if open_state > 0 and tonumber(other_info[2]) == 0 then
                defence_type = 2
                state_info = world_city_tip_str[38]
            end
        end

        if tonumber(self._info.nType) == 10007 then         -- 军团战报
            result_type = result_type + 2
        end

        info = string.gsub(world_city_tip_str[result_type + 38], "!x@", attackInfo[1])
        info = string.gsub(info, "!y@", defenceInfo[1])
        info = string.gsub(info, "!z@", defenceInfo[2])

        if defence_type > 0 then
            info = info..","..world_city_tip_str[defence_type + 42]
            info = string.gsub(info, "!x@", world_city_name)
            info = string.gsub(info, "!y@", defenceInfo[2])
        end
    else
        local attackInfo = zstring.split(attachedInfo[2], ",")
        if tonumber(attackInfo[4]) == tonumber(_ED.union.union_info.union_id) then         -- 掠夺资源
            info = string.gsub(world_city_tip_str[45], "!x@", attackInfo[1])
            info = string.gsub(info, "!y@", world_city_name)
            state_info = world_city_tip_str[35]
            color_index = 2
        else                        -- 被掠夺资源
            info = string.gsub(world_city_tip_str[46], "!x@", world_city_name)
            info = string.gsub(info, "!y@", attackInfo[1])
            info = string.gsub(info, "!z@", attackInfo[2])
            state_info = world_city_tip_str[36]
            color_index = 6
        end
    end
    Text_city_record_t:setString(state_info)
    Text_city_record_t:setColor(cc.c3b(color_Type[color_index][1], color_Type[color_index][2], color_Type[color_index][3]))

    local font_size = Text_legion_city_record_infor:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        info, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)   
    _richText:setPosition(cc.p(Text_legion_city_record_infor:getContentSize().width/2,Text_legion_city_record_infor:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_legion_city_record_infor:getContentSize().width, Text_legion_city_record_infor:getContentSize().height))
    Text_legion_city_record_infor:addChild(_richText)

    --已读和未读的
    local Image_city_record = ccui.Helper:seekWidgetByName(root, "Image_city_record")
    local Image_city_record_read = ccui.Helper:seekWidgetByName(root, "Image_city_record_read")
    local Image_city_record_line = ccui.Helper:seekWidgetByName(root,"Image_city_record_line")
    local Image_city_record_line_read = ccui.Helper:seekWidgetByName(root,"Image_city_record_line_read")
    Image_city_record_line:setVisible(false)
    Image_city_record_line_read:setVisible(false)
    Image_city_record:setVisible(false)
    Image_city_record_read:setVisible(false)
    local image_name = ""
    local image_bg = ""
    if zstring.tonumber(self._info.read_type) == 0 then
        --未读
        Image_city_record:setVisible(true)
        Image_city_record_line:setVisible(true)
    else
        --已读
        Image_city_record_read:setVisible(true)
        Image_city_record_line_read:setVisible(true)
    end
    
    --时间
    local Text_legion_city_record_time = ccui.Helper:seekWidgetByName(root, "Text_legion_city_record_time")
    Text_legion_city_record_time:setString(self:getTimeFormatYMDHMS(tonumber(self._info.time)/1000))
end

function LegionCityRecordCell:getTimeFormatYMDHMS( m_time )
    local temp = os.date("*t",getBaseGTM8Time(m_time))

    local m_month   = string.format("%02d", temp.month)
    local m_day     = string.format("%02d", temp.day)
    local m_hour    = string.format("%02d", temp.hour)
    local m_min     = string.format("%02d", temp.min)
    local m_sec     = string.format("%02d", temp.sec)


    local timeString = temp.year .."-".. m_month .."-".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec
    return timeString
end

function LegionCityRecordCell:onEnterTransitionFinish()

end

function LegionCityRecordCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_record_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionCityRecordCell.__size == nil then
        LegionCityRecordCell.__size = root:getContentSize()
    end
    
    --查看
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "legion_city_record_cell_response", 
        terminal_state = 0, 
        cells = self,
    }, nil, 1)

    self:onUpdateDraw()
end

function LegionCityRecordCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_city_record_t = ccui.Helper:seekWidgetByName(root, "Text_city_record_t")
    local Text_legion_city_record_infor = ccui.Helper:seekWidgetByName(root, "Text_legion_city_record_infor")
    local Text_legion_city_record_name = ccui.Helper:seekWidgetByName(root, "Text_legion_city_record_name")
    local Text_legion_city_record_time = ccui.Helper:seekWidgetByName(root, "Text_legion_city_record_time")
    if Text_city_record_t ~= nil then
        Text_city_record_t:setString("")
        Text_legion_city_record_infor:removeAllChildren(true)
        Text_legion_city_record_name:setString("")
        Text_legion_city_record_time:setString("")
    end
end

function LegionCityRecordCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_record_cell, root)
end

function LegionCityRecordCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCityRecordCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_record_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityRecordCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index ~= nil and self._index <= 6 then
        self:onInit()
    end
    self:setContentSize(LegionCityRecordCell.__size)
    return self
end

