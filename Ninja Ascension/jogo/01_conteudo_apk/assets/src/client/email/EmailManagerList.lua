-- ----------------------------------------------------------------------------------------------------
-- 说明：邮件cell
-- 创建时间	2015-04-23
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EmailManagerList = class("EmailManagerListClass", Window)
    
function EmailManagerList:ctor()
    self.super:ctor()
	self.roots = {}
	self.email = nil
    -- Initialize EmailManager page state machine.
    local function init_email_manager_cell_terminal()
		local email_manager_cell_get_terminal = {
            _name = "email_manager_cell_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				local isOpen_plunder	= tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 15, fun_open_condition.level)
				
				if false == isOpen_plunder then
					TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 15, fun_open_condition.tip_info))
				else
					fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
					app.load("client.home.Menu")
					if fwin:find("MenuClass") == nil then
						fwin:open(Menu:new(), fwin._taskbar)
					end
					state_machine.excute("menu_manager", 0, 
					{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_campaign", 		
								current_button_name = "Button_activity", 		
								but_image = "Image_activity",	
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
					
					state_machine.excute("campaign_show_snatch", 0,"") 
					state_machine.unlock("menu_manager_change_to_page", 0, "")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local email_manager_cell_beat_terminal = {
            _name = "email_manager_cell_beat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				local isOpen_arena  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 16, fun_open_condition.level)
				
				if false == isOpen_arena then
					TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 16, fun_open_condition.tip_info))
				else
					fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
					app.load("client.home.Menu")
					if fwin:find("MenuClass") == nil then
						fwin:open(Menu:new(), fwin._taskbar)
					end
					state_machine.excute("menu_manager", 0, 
					{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_campaign", 		
								current_button_name = "Button_activity", 		
								but_image = "Image_activity",	
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
					
					state_machine.excute("campaign_show_arena", 0,"") 
					state_machine.unlock("menu_manager_change_to_page", 0, "")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local email_activity_rank_button_terminal = {
            _name = "email_activity_rank_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if _ED.active_activity[49] == nil or _ED.active_activity[49] == "" then
					TipDlg.drawTextDailog(_string_piece_info[376])
					return
				end
				state_machine.excute("activity_window_open", 0, {nil, "ActivityFightingRank"})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local email_capture_search_button_terminal = {
            _name = "email_capture_search_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local email = params._datas.cell.email
				if email ~= nil and email.mailInfo ~= nil then
					local infoList = zstring.split(email.mailInfo, ",")
					if #infoList == 3 then
						app.load("client.captureResource.CaptureResourceMain")
						local mapIndex = infoList[1]
						local posx = tonumber(infoList[2] + 1)
						local posy = tonumber(infoList[3] + 1)
                		state_machine.excute("email_manager_back")
						state_machine.excute("capture_resource_open", 0, {mapIndex, posx, posy})
                	end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(email_manager_cell_get_terminal)
		state_machine.add(email_manager_cell_beat_terminal)
		state_machine.add(email_activity_rank_button_terminal)
		state_machine.add(email_capture_search_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_email_manager_cell_terminal()
end


function EmailManagerList:cutStringMain(str, height, fontSize, width fontName)
	local mRoot = ccui.RichText:create()
	fontSize = fontSize or 10
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fontSize=18
	end
	local l = string.len(str)
	mRoot:ignoreContentAdaptWithSize(false)
	local count = 0
	while (l > 0) do
		local f,e = string.find(str, "%%%C-%%")
		if f == nil or e == nil then
			local re = ccui.RichElementText:create(1, cc.c3b(103, 68, 64), 255, str, fontName, fontSize)
			mRoot:pushBackElement(re)
			count = count + zstring.utfstrlen(str)
			break
		end
		if f > 1 then
			local strsub = string.sub(str, 1, f-1)
			count = count + zstring.utfstrlen(strsub)
			local re = ccui.RichElementText:create(1, cc.c3b(103, 68, 64), 255, strsub, fontName, fontSize)
			mRoot:pushBackElement(re)
		end
		local name = string.sub(str, f+1, e-1)
		local f1, e1 = string.find(name, "%d+")
		if name == nil or f1 == nil or e1 == nil then
			mRoot:removeAllChildrenWithCleanup(true)
			break
		end
		local quality = string.sub(name, f1, e1)
		local color = tonumber(quality) + 1
		name = string.sub(name, e1+2, string.len(name))
		count = count + zstring.utfstrlen(name)
		if color == nil or color <= 0 or color > 11 then
			mRoot:removeAllChildrenWithCleanup(true)
			break
		end
		local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, fontName, fontSize)
		mRoot:pushBackElement(re1)
		str = string.sub(str, e+1, l)
		l = string.len(str)
	end
	if width ~= nil and width > 0 then
		mRoot:setContentSize(cc.size(width-15, height+20))
	else
		mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		mRoot:setContentSize(cc.size(width-40, height+20))
	end
	return mRoot, count
end

function EmailManagerList:getDifferDay(times)
	local str = ""
	local hour = math.floor(tonumber(times)/3600)
	local mins = math.floor((tonumber(times)%3600)/60)
	local day = ""
	if times == 0 then
		str = _string_piece_info[290]
	elseif hour < 1 then
		str = mins .. _string_piece_info[289]
	elseif hour >= 1 and hour < 24 then
		str = hour .._string_piece_info[288]
	elseif hour >= 24 then
		day = math.ceil(hour / 24)
		str = day .._string_piece_info[291]
	end
	return str
end

function EmailManagerList:onUpdateDraw()
	local root = self.roots[1]
	local types = ccui.Helper:seekWidgetByName(root, "Text_emil_tt")
	local info = ccui.Helper:seekWidgetByName(root, "Text_2")
	local times = ccui.Helper:seekWidgetByName(root, "Text_423")
	types:setString(_emailTypeAllTip[tonumber(self.email.mailChannelChildType)+1])
	times:setString(self:getDifferDay(tonumber(self.email.mailTime)/1000))
	local _richText,l = self:cutStringMain(self.email.mailContent,tonumber(info:getContentSize().height),24, tonumber(info:getContentSize().width), info:getFontName())
	_richText:setAnchorPoint(cc.p(0, 1))
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		_richText:setPosition(cc.p(info:getPositionX() - info:getContentSize().width/2-28 , info:getPositionY()+20))
	else
		_richText:setPosition(cc.p(info:getPositionX() - info:getContentSize().width/2-40 , info:getPositionY()+20))
	end
	info:addChild(_richText)
	
	if tonumber(self.email.mailChannelType) ==0 then
		ccui.Helper:seekWidgetByName(root, "Button_jj_1"):setVisible(true)
	end
	
	if tonumber(self.email.mailChannelType) ==2 then
		ccui.Helper:seekWidgetByName(root, "Button_db_1"):setVisible(true)
		types:setString(_string_piece_info[292])
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if tonumber(self.email.mailChanneId) == 4 then
			if tonumber(self.email.mailChannelChildType) == 16 or tonumber(self.email.mailChannelChildType) == 17 then
				if ccui.Helper:seekWidgetByName(root, "Button_qd_1_1") ~= nil then
					ccui.Helper:seekWidgetByName(root, "Button_qd_1_1"):setVisible(true)
				end
			elseif tonumber(self.email.mailChannelChildType) == 19 then
				if ccui.Helper:seekWidgetByName(root, "Button_qd_1_2") ~= nil then
					ccui.Helper:seekWidgetByName(root, "Button_qd_1_2"):setVisible(true)
				end
			end
		end
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if tonumber(self.email.mailChannelType) == 12 then
			if _ED.active_activity[49] ~= nil and _ED.active_activity[49] ~= "" then
				if ccui.Helper:seekWidgetByName(root, "Button_qw_1_0") ~= nil then
					ccui.Helper:seekWidgetByName(root, "Button_qw_1_0"):setVisible(true)
				end
			end
			types:setString(_string_piece_info[375])
		end
	end
end

function EmailManagerList:onEnterTransitionFinish()
	local csbEmailManager = csb.createNode("email/email_list.csb")
	self:addChild(csbEmailManager)
	local root = csbEmailManager:getChildByName("root")
	table.insert(self.roots, root)
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("email/email_list.csb")
	    csbEmailManager:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_db_1"), nil, {terminal_name = "email_manager_cell_get", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jj_1"), nil, {terminal_name = "email_manager_cell_beat", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if ccui.Helper:seekWidgetByName(root, "Button_qw_1_0")~= nil then
			local Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qw_1_0"), nil, {terminal_name = "email_activity_rank_button", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
			Button_3:setVisible(false)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Button_qd_1_1 = ccui.Helper:seekWidgetByName(root, "Button_qd_1_1")
		if Button_qd_1_1 ~= nil then
			fwin:addTouchEventListener(Button_qd_1_1, nil, 
			{
				terminal_name = "email_capture_search_button", 
				terminal_state = 0,
				isPressedActionEnabled = true,
				cell = self
			}, nil, 0)
			Button_qd_1_1:setVisible(false)
		end
		local Button_qd_1_2 = ccui.Helper:seekWidgetByName(root, "Button_qd_1_2")
		if Button_qd_1_2 ~= nil then
			fwin:addTouchEventListener(Button_qd_1_2, nil, 
			{
				terminal_name = "email_capture_search_button", 
				terminal_state = 0,
				isPressedActionEnabled = true,
				cell = self
			}, nil, 0)
			Button_qd_1_2:setVisible(false)
		end
	end
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local MySize = Panel_2:getContentSize()
	self:setContentSize(MySize)
	
	-- self:onUpdateDraw()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
end

function EmailManagerList:init(email)
	self.email = email
end

function EmailManagerList:onExit()
	state_machine.remove("email_manager_cell_get")
	state_machine.remove("email_manager_cell_beat")
	state_machine.remove("email_activity_rank_button")
	-- state_machine.remove("email_capture_search_button")
end

function EmailManagerList:createCell()
	local cell = EmailManagerList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
