-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP权限list
-- 创建时间2015-05-05
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
VipPrivilegeListThree = class("VipPrivilegeListThreeClass", Window)

function VipPrivilegeListThree:ctor()
    self.super:ctor()
    self.roots = {}
	self.id = nil
    -- Initialize VipPrilige page state machine.
    local function init_vip_privilege_list_three_terminal()
		--关掉VIP界面
		local vip_privilege_list_three_terminal = {
            _name = "vip_privilege_list_three",
            _init = function (terminal) 

				app.load("client.duplicate.DuplicateController")
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local user_grade=dms.int(dms["fun_open_condition"], 19, fun_open_condition.level)
				if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					fwin:removeAll()
					app.load("client.home.Menu")
					if fwin:find("MenuClass") == nil then
						fwin:open(Menu:new(), fwin._taskbar)
					end
					-- state_machine.excute("menu_clean_page_state", 0,"") 
					state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_duplicate_everyday", 
								current_button_name = "Button_duplicate",
								but_image = "Image_duplicate", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
					state_machine.unlock("menu_manager_change_to_page", 0, "")
					state_machine.excute("pve_daily_activity_copy_change_to_page", 0, params._datas._id - 1)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 19, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(vip_privilege_list_three_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_vip_privilege_list_three_terminal()
end

function VipPrivilegeListThree:onUpdateDraw()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_2"):setString("V" .. " " .. self.textNum)
	local data = dms.searchs(dms["daily_instance_mould"], daily_instance_mould.need_viplevel, self.textNum)
	local title = data[1][2]
	ccui.Helper:seekWidgetByName(root, "Text_1030"):setString(title)
	ccui.Helper:seekWidgetByName(root, "Panel_358"):setBackGroundImage(string.format("images/ui/pve_sn/gameActivity/richang_tuanka_icon_%d.png", tonumber(data[1][4])))
	ccui.Helper:seekWidgetByName(root, "Text_2478"):setString(_string_piece_info[322] .. self.textNum .. _string_piece_info[323] .. title)
	self.id = data[1][1]
end

function VipPrivilegeListThree:onEnterTransitionFinish()
	local csbVipPrivilegeListThree = csb.createNode("player/vip_privileges_list_3.csb")
    self:addChild(csbVipPrivilegeListThree)
	
	local root = csbVipPrivilegeListThree:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_228"):getContentSize().width, ccui.Helper:seekWidgetByName(root, "Panel_228"):getContentSize().height+10)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_4879"), nil, 
	{
		-- func_string = [[state_machine.excute("vip_privilege_list_three", 0, "click vip_privilege_list_three.'")]]
		terminal_name = "vip_privilege_list_three", 
		terminal_state = 0,
		_id = self.id,
	}, nil, 0)
end

function VipPrivilegeListThree:onExit()
	state_machine.remove("vip_privilege_list_three")
end

function VipPrivilegeListThree:init(textNum)
	self.textNum = textNum
end

function VipPrivilegeListThree:createCell()
	local cell = VipPrivilegeListThree:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
