--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅修改公告
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceNoticeCell = class("UnionTheMeetingPlaceNoticeCellClass", Window)

--打开界面
local union_the_meeting_place_notice_open_terminal = {
    _name = "union_the_meeting_place_notice_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingPlaceNoticeWindow = fwin:find("UnionTheMeetingPlaceNoticeCellClass")
        if unionTheMeetingPlaceNoticeWindow ~= nil and unionTheMeetingPlaceNoticeWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_place_notice_open", 0, "")
        fwin:open(UnionTheMeetingPlaceNoticeCell:createCell():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_notice_close_terminal = {
    _name = "union_the_meeting_place_notice_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlaceNoticeCell:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}       
state_machine.add(union_the_meeting_place_notice_open_terminal)
state_machine.add(union_the_meeting_place_notice_close_terminal)
state_machine.init()

function UnionTheMeetingPlaceNoticeCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.type = 0

	 -- Initialize union the meeting  trends list cell state machine.
    local function init_union_the_meeting_place_notice_cell_terminal()
    	-- 取消修改公告
		local union_the_meeting_place_notice_cancel_announcement_terminal = {
            _name = "union_the_meeting_place_notice_cancel_announcement",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:closeCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    	-- 点击修改公告
		local union_the_meeting_place_notice_change_announcement_terminal = {
            _name = "union_the_meeting_place_notice_change_announcement",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                mcell:sendinfo()
                -- local root = instance.roots[1]
                -- local text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi")
                -- local str = zstring.exchangeTo(text:getString())
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         print("tonumber(instance.type)====",tonumber(instance.type))
                --         if tonumber(instance.type) == 1 then
                --             _ED.union.union_info.watchword = zstring.exchangeFrom(str)
                --             print("===============_ED.union.union_info.watchword====",_ED.union.union_info.watchword)
                --         else
                --             _ED.union.union_info.bulletin = zstring.exchangeFrom(str)
                --             print("================= _ED.union.union_info.bulletin====", _ED.union.union_info.bulletin)
                --         end
                --         instance:closeCell()
                --         state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                --     end
                -- end
                -- local contentInfo = ""..str.."\r\n"..instance.type
                -- protocol_command.union_content_update.param_list = contentInfo
                -- NetworkManager:register(protocol_command.union_content_update.code, nil, nil, nil, nil, responseCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_place_notice_cancel_announcement_terminal)
		state_machine.add(union_the_meeting_place_notice_change_announcement_terminal)
        state_machine.init()
    end
    -- call func init union the meeting  trends list cell state machine.
    init_union_the_meeting_place_notice_cell_terminal()

end
function UnionTheMeetingPlaceNoticeCell:sendinfo( ... )
    local root = self.roots[1]
    if root ==nil then
        return
    end
    local text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi")
    local str = zstring.exchangeTo(text:getString())
    local str2 = string.gsub(text:getString(), " ", "")
    if text:getString() ~= "" and str2 ~= "" then
        if self:filter_spec_chars(str2) == true then
            TipDlg.drawTextDailog(_new_interface_text[45])
            return
        end
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil then
                    response.node:closeCell()
                end
                state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
            end
        end
        local contentInfo = ""..str.."\r\n"..self.type
        protocol_command.union_content_update.param_list = contentInfo
        NetworkManager:register(protocol_command.union_content_update.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        TipDlg.drawTextDailog(tipStringInfo_union_str[51])
    end
    
end

function UnionTheMeetingPlaceNoticeCell:filter_spec_chars(s)  
    local k = 1
    while k <= #s do
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2      
                end  
            end  
        else
            return true  
        end 
        k = k + 1 
    end  
    return false
end  

function UnionTheMeetingPlaceNoticeCell:updateDraw()
	local root = self.roots[1]
	if self.type == 1 then
		ccui.Helper:seekWidgetByName(root, "Text_123_title"):setString(tipStringInfo_union_str[2])
	else
		ccui.Helper:seekWidgetByName(root, "Text_123_title"):setString(tipStringInfo_union_str[1])
	end
end

function UnionTheMeetingPlaceNoticeCell:onInit()
	self:updateDraw()
end

function UnionTheMeetingPlaceNoticeCell:onEnterTransitionFinish()
	
end

function UnionTheMeetingPlaceNoticeCell:init(type)
	self.type = type

	local csbUnionTheMeetingPlaceCell = csb.createNode("legion/legion_gg_xiugai.csb")
    local root = csbUnionTheMeetingPlaceCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceCell)

    local xianz = ccui.Helper:seekWidgetByName(root, "Text_zishu_xz")
    xianz:setString("")
    local totalCount = 1
    if self.type == 1 then
        local config = zstring.split(dms.string(dms["pirates_config"], 199, pirates_config.param), ",")
        totalCount = config[1]
        xianz:setString(string.format(tipStringInfo_union_str[56],totalCount))
    else
        local config = zstring.split(dms.string(dms["pirates_config"], 194, pirates_config.param), ",")
        totalCount = config[2]
        xianz:setString(string.format(tipStringInfo_union_str[56],totalCount))
    end
    local text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi")
    draw:addEditBox(text, "", "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_5_bc"), tonumber(totalCount), cc.KEYBOARD_RETURNTYPE_DONE)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_qx"),  nil, 
    {
        terminal_name = "union_the_meeting_place_notice_cancel_announcement",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_bc"),  nil, 
    {
        terminal_name = "union_the_meeting_place_notice_change_announcement",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)

	self:onInit()
    state_machine.unlock("union_the_meeting_place_notice_open", 0, "")
	return self
end

function UnionTheMeetingPlaceNoticeCell:onExit()
	state_machine.remove("union_the_meeting_place_notice_cancel_announcement")
	state_machine.remove("union_the_meeting_place_notice_change_announcement")
end

function UnionTheMeetingPlaceNoticeCell:createCell()
	local cell = UnionTheMeetingPlaceNoticeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function UnionTheMeetingPlaceNoticeCell:closeCell( ... )
    local unionTheMeetingPlaceNoticeWindow = fwin:find("UnionTheMeetingPlaceNoticeCellClass")
    if unionTheMeetingPlaceNoticeWindow == nil then
        return
    end
    fwin:close(unionTheMeetingPlaceNoticeWindow)
end
