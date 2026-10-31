-- ----------------------------------------------------------------------------------------------------
-- 说明：首页顶部用户初略信息
-- 创建时间
-- 作者：胡文轩
-- 修改记录：
-- 【修改人】刘迎 【修改内容】添加user_information_refresh_all_info_terminal状态机 刷新主界面顶部所有数据
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------
UserInformation = class("UserInformationClass", Window, true)
    
function UserInformation:ctor()
    self.super:ctor()
	self.roots = {}
	-- La cabecera de la ciudad se abre en fwin._frameview, la misma capa
	-- donde viven Home (_zorder = 1, el que trae la rejilla de iconos de
	-- eventos) y Menu (_zorder = 2). No declaraba _zorder, asi que entraba
	-- con z 0 y los ~48 iconos de la ciudad se pintaban encima del avatar y
	-- de la barra de experiencia. No se mueve de sitio: solo sube de capa.
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		self._zorder = 3
	end
	self.user_name		= ""	--用户名
	self.user_grade		= 0		--用户等级
	self.user_silver 	= 0		--用户银币
	self.user_gold 		= 0			--元宝
	self.vip_grade 		= 0					--VIP等级
	self.user_experience 				= 9999		--当前经验
	self.user_grade_need_experience 	= 99999		--升级所需经验
	self.user_food 		= 0			--当前体力
	self.max_user_food 	= 0	--体力上限
	self.endurance 		= 0			--当前耐力
	self.max_endurance 	= 0	--耐力上限
	self.fight_capacity = 0	--战斗力
	self.user_grade = 0
	self.init_user_data = false

	self._health = nil
	self._shen = nil
	self._money = nil
	self._bao = nil
	self._LoadingBar_1 = nil
	self._BitmapFontLabel_5 = nil
	self._name = nil
	self._VIP = nil
	self._Level = nil
	self._head = nil

	self._last_time = 0

	self._title = 0
	
    -- Initialize Home page state machine.
    local function init_user_information_terminal()
	
		-- 用户信息显示
		local user_information_show_all_info_terminal = {
            _name = "user_information_show_all_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		app.load("client.l_digital.player.SmPlayerInfomation")
            		state_machine.excute("sm_player_infomation_window_open",0,"sm_player_infomation_window_open.")
            	else
					app.load("client.player.PlayerInfomation")
					fwin:open(PlayerInfomation:new(),fwin._windows )
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新顶部所有显示信息 自身等级 体力 耐力 银币 元宝 vip等级 战斗力
		local user_information_refresh_all_info_terminal = {
            _name = "user_information_refresh_all_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local root = self.roots[1]
				local health = ccui.Helper:seekWidgetByName(root, "Label_279")
				local shen = ccui.Helper:seekWidgetByName(root, "Label_279_1")
				local money = ccui.Helper:seekWidgetByName(root, "Label_money")
				local bao = ccui.Helper:seekWidgetByName(root, "Label_energy")
				local BitmapFontLabel_5 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_5")
				local VIP = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_vip")
				local Level = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_LV")
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					VIP = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip")
				end
				
				-- health:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
				
				if health ~= nil then
					if zstring.tonumber( _ED.user_info.user_food) > 1000000 then
						health:setString(math.floor(_ED.user_info.user_food/10000)..string_equiprety_name[38] .."/".._ED.user_info.max_user_food)
					else
						health:setString(_ED.user_info.user_food .. "/" .._ED.user_info.max_user_food)
					end
				end
				
				-- shen:setString(_ED.user_info.endurance .. "/" .._ED.user_info.max_endurance)
				if shen ~= nil then
					if zstring.tonumber( _ED.user_info.endurance) > 10000  or zstring.tonumber( _ED.user_info.max_endurance) > 10000 then
						shen:setString(math.floor(_ED.user_info.endurance/1000)..string_equiprety_name[40] .."/".._ED.user_info.max_endurance)
					else
						shen:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
					end
				end
				
				if zstring.tonumber( _ED.user_info.user_gold)> 1000000 then
					if bao ~= nil then
						bao:setString(math.floor(_ED.user_info.user_gold / 1000) .. string_equiprety_name[40])
					end
				else
					if BitmapFontLabel_5 ~= nil then
						BitmapFontLabel_5:setString(_ED.user_info.fight_capacity)
					end
				end
				
				if money ~= nil then
					-- if zstring.tonumber( _ED.user_info.user_silver) > 100000000 then
					-- 	money:setString(math.floor(_ED.user_info.user_silver/ 100000000) .. string_equiprety_name[39])
					-- else
					if zstring.tonumber( _ED.user_info.user_silver)> 10000 then
						money:setString(math.floor(_ED.user_info.user_silver / 1000) .. string_equiprety_name[40])
					else
						money:setString(_ED.user_info.user_silver)
					end
				end
				
				if bao ~= nil then
					-- if zstring.tonumber( _ED.user_info.user_gold) > 100000000 then
					-- 	bao:setString(math.floor(_ED.user_info.user_gold / 100000000) .. string_equiprety_name[39])
					-- else
					if zstring.tonumber( _ED.user_info.user_gold)> 1000000 then
						bao:setString(math.floor(_ED.user_info.user_gold / 1000) .. string_equiprety_name[40])
					else
						bao:setString(_ED.user_info.user_gold)
					end
				end
				
				if BitmapFontLabel_5 ~= nil then
					-- if zstring.tonumber( _ED.user_info.fight_capacity) > 100000000 then
					-- 	BitmapFontLabel_5:setString(math.floor(_ED.user_info.fight_capacity / 100000000) .. string_equiprety_name[39])
					-- else
					if zstring.tonumber( _ED.user_info.fight_capacity)> 10000 then
						BitmapFontLabel_5:setString(math.floor(_ED.user_info.fight_capacity / 1000) .. string_equiprety_name[40])
					else
						BitmapFontLabel_5:setString(_ED.user_info.fight_capacity)
					end
				end
				
				if __lua_project_id == __lua_project_l_naruto then
				elseif __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
					VIP:setString(_ED.vip_grade)
					Level:setString(self.user_grade)
				else
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						VIP:setString(_ED.vip_grade)
					else
						VIP:setString(_emailTypeSystemTip[2].." ".._ED.vip_grade)
						Level:setString(_string_piece_info[68]..self.user_grade)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 隐藏界面
        local user_information_hide_event_terminal = {
            _name = "user_information_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local user_information_show_event_terminal = {
            _name = "user_information_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新vip
        local user_information_update_vip_terminal = {
            _name = "user_information_update_vip",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDrawVip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新头像
        local user_information_update_head_terminal = {
            _name = "user_information_update_head",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDrawHead()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --首页上的充值
		local user_information_home_recharge_button_terminal = {
            _name = "user_information_home_recharge_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
				app.load("client.shop.recharge.RechargeDialog")
				if fwin:find("RechargeDialogClass") == nil then
					local Recharge = RechargeDialog:new()
					Recharge:init(4)
					fwin:open(Recharge , fwin._windows)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --邮件
		local user_information_home_click_email_manager_terminal = {
            _name = "user_information_home_click_email_manager",
            _init = function (terminal)
				app.load("client.email.EmailManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    local function responsePropCompoundCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if fwin:find("EmailManagerClass") == nil then
                               fwin:open(EmailManager:new(), fwin._view) 
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                else
				    fwin:open(EmailManager:new(), fwin._view) 
                end
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local user_information_update_role_head_info_terminal = {
            _name = "user_information_update_role_head_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	                instance:updateRoleHeadInfo()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 更新头像红点显示
        local user_information_update_role_head_red_dot_terminal = {
            _name = "user_information_update_role_head_red_dot",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	                instance:updateHeadInfoRedDot()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(user_information_show_all_info_terminal)
		state_machine.add(user_information_refresh_all_info_terminal)
		state_machine.add(user_information_hide_event_terminal)
		state_machine.add(user_information_show_event_terminal)
		state_machine.add(user_information_update_vip_terminal)
		state_machine.add(user_information_update_head_terminal)
		state_machine.add(user_information_home_recharge_button_terminal)
		state_machine.add(user_information_home_click_email_manager_terminal)
		state_machine.add(user_information_update_role_head_info_terminal)
		state_machine.add(user_information_update_role_head_red_dot_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_user_information_terminal()
end

-- 更新头像红点显示
function UserInformation:updateHeadInfoRedDot()
	local Image_red_xr1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_xr1")
	if Image_red_xr1 then
		local isShowRedDot = getPlayerAllHeadFrameState()
		Image_red_xr1:setVisible(isShowRedDot)
	end
end

-- 返回老的头像框
function UserInformation:getOldHeadFrame()
	local quality_path = ""
	local oldHeadFrame = nil

	if tonumber(_ED.vip_grade) > 0 then
		quality_path = "images/ui/quality/player_1.png"
	else
		quality_path = "images/ui/quality/player_2.png"
	end

	if true == cc.FileUtils:getInstance():isFileExist(quality_path) then
		oldHeadFrame = cc.Sprite:create(quality_path)
	end

	return oldHeadFrame
end

-- 返回老的头像
function UserInformation:getOldHeadIcon()
	local headIcon = nil

	local big_icon_path = ""
	local pic = tonumber(_ED.user_info.user_head)
	if pic >= 9 then
		big_icon_path = string.format("images/ui/props/props_%d.png", pic)
	else
		big_icon_path = string.format("images/ui/home/head_%d.png", pic)
	end
	
	if true == cc.FileUtils:getInstance():isFileExist(big_icon_path) then
		headIcon = cc.Sprite:create(big_icon_path)
	end

	return headIcon
end

-- 绘制老版的头像内容
function UserInformation:drawOldHead()
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_12") 
	head:removeAllChildren(true)
	
	local oldHeadIcon = self:getOldHeadIcon()
	local oldHeadFrame = self:getOldHeadFrame()

	if oldHeadFrame ~= nil then
		oldHeadFrame:setAnchorPoint(cc.p(0.5, 0.5))
		oldHeadFrame:setPosition(cc.p(head:getContentSize().width / 2, head:getContentSize().height / 2))
		head:addChild(oldHeadFrame)
	end
	
	if oldHeadIcon ~= nil then
		oldHeadIcon:setAnchorPoint(cc.p(0.5, 0.5))
		oldHeadIcon:setPosition(cc.p(head:getContentSize().width / 2, head:getContentSize().height / 2))
		head:addChild(oldHeadIcon)
	end
end

function UserInformation:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = _ED.user_info.head_frame.curHeadFrameID,
        headFrameStage = _ED.user_info.head_frame.curHeadFrameStage,
        headID = _ED.user_info.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function UserInformation:updateDrawHead()
	local root = self.roots[1]
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_12") 
	head:removeAllChildren(true)
	head:removeBackGroundImage()
	
	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		local headIcon = self:getNewHeadIcon()
		if headIcon ~= nil then
			head:addChild(headIcon)
		end
    else
		self:drawOldHead()
	end

end

function UserInformation:onHide()
	for i, v in pairs(self.roots) do
		v:setVisible(false)
	end
end

function UserInformation:setLocalPower(total)
    self.fight_capacity=tostring(total)
    if self._BitmapFontLabel_5 and not tolua.isnull(self._BitmapFontLabel_5) then
        local value=tonumber(total) or 0
        local suffix=string_equiprety_name and string_equiprety_name[40] or 'K'
        self._BitmapFontLabel_5:setString(value>10000 and (tostring(math.floor(value/1000))..suffix) or tostring(value))
    end
end
function UserInformation:onShow()
    require("shop_local").refreshPower()
	for i, v in pairs(self.roots) do
		v:setVisible(true)
	end
end

function UserInformation:updateRoleHeadInfo( ... )
	if self._head == nil then
		return
	end
	self._head:removeAllChildren(true)

	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		local headIcon = self:getNewHeadIcon()
		if headIcon ~= nil then
			self._head:addChild(headIcon, 0)
		end
	else
		self:drawOldHead()
	end
    
	
end

function UserInformation:updateDrawVip()
	local root = self.roots[1]
	local VIP = ccui.Helper:seekWidgetByName(self.roots[1], "BitmapFontLabel_vip")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		VIP = ccui.Helper:seekWidgetByName(self.roots[1], "AtlasLabel_vip")
	end
	if VIP ~= nil then
		VIP:setString(_ED.vip_grade)
	end
end

function UserInformation:onEnterTransitionFinish()
	local csbUserInfomation = csb.createNode("player/user_information.csb")
	local root = csbUserInfomation:getChildByName("root")

	-- ipad适配
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		local winsize = cc.Director:getInstance():getWinSize()
		if winsize.width / winsize.height < 1.56 then
			local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
			Panel_13:setScale(0.9)
			Panel_13:setPositionY(65)

			local Panel_zuo_2 = ccui.Helper:seekWidgetByName(root, "Panel_zuo_2_xr1")
			Panel_zuo_2:setScale(0.9)
			Panel_zuo_2:setPositionY(65)

			local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
			Panel_14:setScale(0.9)
			Panel_14:setPosition(cc.p(85, 65))
		end
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		-- 隐藏这个csb上的首充
		local Button_chongzhi = ccui.Helper:seekWidgetByName(root, "Button_chongzhi")
		if Button_chongzhi then
			Button_chongzhi:setVisible(false)

			local ArmatureNode_cz = Button_chongzhi:getParent():getChildByName("ArmatureNode_cz")
			if ArmatureNode_cz then
				ArmatureNode_cz:setVisible(false)
			end
		end
	end

	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self._Text_dg_time = ccui.Helper:seekWidgetByName(root, "Text_dg_time")
	else
		local action = csb.createTimeline("player/user_information.csb")
	    csbUserInfomation:runAction(action)
		self.action = action
	end
	self:addChild(csbUserInfomation)

	local user_information_panel_inflution = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "user_information"), nil, {func_string = [[state_machine.excute("user_information_show_all_info", 0, "user_information_show_all_info.'")]]}, nil, 0)
	
	local health = ccui.Helper:seekWidgetByName(self.roots[1], "Label_279")
	local shen = ccui.Helper:seekWidgetByName(self.roots[1], "Label_279_1")
	local money = ccui.Helper:seekWidgetByName(self.roots[1], "Label_money")
	local bao = ccui.Helper:seekWidgetByName(self.roots[1], "Label_energy")
	local LoadingBar_1 = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1")
	local BitmapFontLabel_5 = ccui.Helper:seekWidgetByName(self.roots[1], "BitmapFontLabel_5")
	local name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_5")
	local VIP = ccui.Helper:seekWidgetByName(self.roots[1], "BitmapFontLabel_vip")
	local Level = ccui.Helper:seekWidgetByName(self.roots[1], "BitmapFontLabel_LV")
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_12")
	
	self._health = health
	self._shen = shen
	self._money = money
	self._bao = bao
	self._LoadingBar_1 = LoadingBar_1
	self._BitmapFontLabel_5 = BitmapFontLabel_5
	self._name = name
	self._VIP = VIP
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		VIP = ccui.Helper:seekWidgetByName(self.roots[1], "AtlasLabel_vip")
		self._VIP = ccui.Helper:seekWidgetByName(self.roots[1], "AtlasLabel_vip")
	end
	self._Level = Level
	self._head = head

	if self.init_user_data ~= true then
		self.user_name	= _ED.user_info.user_name	--用户名
		self.user_grade	= _ED.user_info.user_grade or 0		--用户等级
		self.user_silver = _ED.user_info.user_silver or 0		--用户银币
		self.user_gold 		= _ED.user_info.user_gold or 0			--元宝
		self.vip_grade 	= _ED.vip_grade or 0					--VIP等级
		self.user_experience 			= zstring.tonumber(_ED.user_info.user_experience) or 9999		--当前经验
		self.user_grade_need_experience 	= zstring.tonumber(_ED.user_info.user_grade_need_experience) or 99999		--升级所需经验
		self.user_food 		= _ED.user_info.user_food or 0			--当前体力
		self.max_user_food 	= _ED.user_info.max_user_food or 0	--体力上限
		self.endurance 		= _ED.user_info.endurance or 0			--当前耐力
		self.max_endurance 	= _ED.user_info.max_endurance or 0	--耐力上限
		self.fight_capacity 	= _ED.user_info.fight_capacity or 0	--战斗力
		self.init_user_data = true
	end
	-- BitmapFontLabel_5:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
	local shipType = 0
	for i, ship in pairs(_ED.user_ship) do
		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			if dms.atoi(shipData, ship_mould.captain_type) == 0 then
				shipType = ship.ship_type + 1
				name:setColor(cc.c3b(tipStringInfo_quality_color_Type[shipType][1],tipStringInfo_quality_color_Type[shipType][2],tipStringInfo_quality_color_Type[shipType][3]))
				break
			end
		end
	end
	
	-- health:setString(self.user_food.."/"..self.max_user_food)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
		local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
		Label_power_left:setString(_ED.user_info.user_food)
		Label_power_right:setString(self.max_user_food)
		if tonumber(_ED.user_info.user_food) > tonumber(self.max_user_food) then
			-- DSC重塑
			if __lua_project_id == __lua_project_l_digital then
				Label_power_left:setColor(cc.c3b(61,217,101))
			else
				Label_power_left:setColor(cc.c3b(26,157,0))
				-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
				-- 	Label_power_left:setColor(cc.c3b(26,157,0))
				-- end
			end
		else
			Label_power_left:setColor(cc.c3b(255,255,255))
			-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		 -- 		Label_power_left:setColor(cc.c3b(26,157,0))
		 -- 	end
		end
	else
		if zstring.tonumber( _ED.user_info.user_food) > 10000  then
			health:setString(math.floor(_ED.user_info.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
		else
			health:setString(_ED.user_info.user_food .. "/" ..self.max_user_food)
		end
	end
	
	if shen ~= nil then
		if zstring.tonumber( self.endurance) > 10000  or zstring.tonumber( self.max_endurance) > 10000 then
			shen:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
		else
			shen:setString(self.endurance.."/"..self.max_endurance)
		end
	end
	
	-- if zstring.tonumber( self.user_silver) > 100000000 then
	-- 	money:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if zstring.tonumber( self.user_silver)> 10000 then
		money:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		money:setString(self.user_silver)
	end
	
	-- bao:setString(self.user_gold)
	-- if zstring.tonumber(self.user_gold) > 100000000 then
	-- 	bao:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if zstring.tonumber( self.user_gold)> 1000000 then
		bao:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		bao:setString(self.user_gold)
	end
	
	-- if zstring.tonumber( self.fight_capacity) > 100000000 then
	-- 	BitmapFontLabel_5:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
	-- else
	if zstring.tonumber(self.fight_capacity)> 10000 then
		BitmapFontLabel_5:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
	else
		BitmapFontLabel_5:setString(self.fight_capacity)
	end
	if Level == nil then
		name:setString(self.user_name.." Lv"..self.user_grade)
	else
		name:setString(self.user_name)
		Level:setString(_string_piece_info[68]..self.user_grade)
	end
	if ___is_open_leadname == true then
		name:setFontName("")
		name:setFontSize(name:getFontSize())
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		VIP:setString(self.vip_grade)
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then			--龙虎门项目控制
			VIP:setString(self.vip_grade)
			Level:setString(self.user_grade)
		else
			VIP:setString(_emailTypeSystemTip[2].." "..self.vip_grade)
			Level:setString(_string_piece_info[68]..self.user_grade)
		end
		LoadingBar_1:setPercent(self.user_experience/self.user_grade_need_experience *100)
	end

	local ship = fundShipWidthId(_ED.user_formetion_status[1])
	
	local playerIconStr = ""
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		local headIcon = self:getNewHeadIcon()
		if headIcon ~= nil then
			head:addChild(headIcon)
		end
		state_machine.excute("user_information_update_role_head_red_dot", 0, nil)
	elseif  __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_digital
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		
		self:drawOldHead()
	    
		playerIconStr = ""
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		if ship ~= nil and ship._head ~= nil then
			playerIconStr = string.format("images/ui/home/head_%s.png", ship._head)
		else 
			playerIconStr = string.format("images/ui/home/head_%s.png", _ED.user_info.user_head)
		end
	elseif __lua_project_id == __lua_project_adventure then
	elseif __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_yugioh 
		then
		if ship ~= nil then
			local map = _user_information_head_index
			
			local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型
			local level = zstring.tonumber(ship.ship_type) -- 品质等级
			playerIconStr = string.format("images/ui/home/head_%s.png", map[ptype][level])
		else 
			playerIconStr = string.format("images/ui/home/head_%s.png", _ED.user_info.user_head)
		end
		local fashionEquip, pic = getUserFashion()
		if fashionEquip ~= nil and pic ~= nil then
			playerIconStr = string.format("images/ui/home/head_%s.png", pic)
		end
	else
		local map = _user_information_head_index
		
		local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型
		local level = zstring.tonumber(ship.ship_type)+1 -- 品质等级
		playerIconStr = string.format("images/ui/home/head_%s.png", map[ptype][level])
	end
	if playerIconStr ~= "" then
		head:setBackGroundImage(playerIconStr)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.Panel_bg_view = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bg_view")
		if self.Panel_bg_view ~= nil and _ED.user_rank_title_info then
			self._title = zstring.tonumber(_ED.user_rank_title_info._current_title) or 0
			if self._title > 0 then
				self.Panel_bg_view:setVisible(true)
				self.Panel_bg_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], self._title, title_param.pic_index)))
			else
				self.Panel_bg_view:setVisible(false)
			end
		end

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zuanshi_add"), nil, 
	    {
	        terminal_name = "activity_home_recharge_button", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuySilverCoins")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jinbi_add"), nil, 
	    {
	        terminal_name = "sm_buy_silver_coinsopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
		app.load("client.utils.SmBuyPhysical")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tili_add"), nil, 
	    {
	        terminal_name = "sm_buy_physicalopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)

	    local Button_chongzhi = ccui.Helper:seekWidgetByName(root,"Button_chongzhi")
	    if Button_chongzhi ~= nil then
	    	fwin:addTouchEventListener(Button_chongzhi, nil, 
		    {
		        terminal_name = "user_information_home_recharge_button", 
		        terminal_state = 0, 
		        touch_black = true,
		    }, nil, 0)
	    end

	    local Button_mail = ccui.Helper:seekWidgetByName(root,"Button_mail")
	    if Button_mail ~= nil then
	    	fwin:addTouchEventListener(Button_mail, nil, 
		    {
		        terminal_name = "user_information_home_click_email_manager", 
		        terminal_state = 0, 
		        touch_black = true,
		    }, nil, 0)
		    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_mall_all",
	    	_widget = ccui.Helper:seekWidgetByName(root, "Button_mail"),
	    	_invoke = nil,
	    	_interval = 0.5,})
	    end
	    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then   -- 1评审, 其他非
	    	Button_mail:setVisible(false)
	    end
	end
	
end

function UserInformation:action(labelName, ANumber, BNumber)
	local changeNumber = math.floor((BNumber - ANumber)/6)
	local label = ccui.Helper:seekWidgetByName(self.roots[1], labelName)
	
	local function change()
		label:setString(ANumber + changeNumber)
		ANumber = ANumber + changeNumber
	end
	
	local function changeend()
		label:setString(BNumber)
	end
	local ScaleSave = label:getScale()
    local seq = cc.Sequence:create(
		cc.ScaleTo:create(0.2, 1.5),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(change),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(change),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(change),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(change),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(change),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(change),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(changeend),
		cc.ScaleTo:create(0.2, ScaleSave))
	label:runAction(seq)
end

--给一个时间如:153000,得到今天15:30:00的时间戳 
function UserInformation:getIntervalByTime( time )
	local temp = os.date("*t",getBaseGTM8Time(time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)

	local timeString = m_hour ..":".. m_min ..":".. m_sec

    return timeString
end

function UserInformation:onUpdate(dt)
    local power=require('shop_local').totalPower
    if power~=nil then
        _ED.user_info.fight_capacity=tostring(power)
        if self.fight_capacity~=tostring(power) then self:setLocalPower(power) end
    end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if self.roots == nil or self.roots[1] == nil then
			return
		end
	end

	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		if self._money ~= nil then
			-- if zstring.tonumber( self.user_silver) > 100000000 then
			-- 	self._money:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
			-- else
			if zstring.tonumber( self.user_silver)> 10000 then
				self._money:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
			else
				self._money:setString(self.user_silver)
			end
		end
	end
	
	if self.user_name ~= _ED.user_info.user_name then
		self.user_name = _ED.user_info.user_name
		if self._Level == nil then
			self._name:setString(self.user_name.." Lv"..self.user_grade)
		else
			self._name:setString(self.user_name)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local shipType = 0
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
				if dms.atoi(shipData, ship_mould.captain_type) == 0 then
					shipType = ship.ship_type + 1
					self._name:setColor(cc.c3b(tipStringInfo_quality_color_Type[shipType][1],tipStringInfo_quality_color_Type[shipType][2],tipStringInfo_quality_color_Type[shipType][3]))
					break
				end
			end
		end
	end
	if self.user_grade ~= _ED.user_info.user_grade then
		self.user_grade = _ED.user_info.user_grade
		if __lua_project_id == __lua_project_gragon_tiger_gate
			-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then			--龙虎门项目控制
			if self._Level ~= nil then
				self._Level:setString(self.user_grade)
			end
		else
			if self._Level ~= nil then
				self._Level:setString(_string_piece_info[68]..self.user_grade)
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
			-- if zstring.tonumber( _ED.user_info.user_food) > 1000000  then
			-- 	self._health:setString(math.floor(_ED.user_info.user_food/10000)..string_equiprety_name[38] .."/"..self.max_user_food)
			-- else
			-- 	self._health:setString(_ED.user_info.user_food .. "/" ..self.max_user_food)
			-- end
		end
		if self._Level == nil then
			self._name:setString(self.user_name.." Lv"..self.user_grade)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		if self._bao ~= nil then
			-- if zstring.tonumber(self.user_gold) > 100000000 then
			-- 	self._bao:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
			-- else
			if zstring.tonumber( self.user_gold)> 1000000 then
				self._bao:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
			else
				self._bao:setString(self.user_gold)
			end
		end
	end
	if self.vip_grade ~= _ED.vip_grade then
		self.vip_grade = _ED.vip_grade
		if __lua_project_id == __lua_project_l_naruto then
			-- NARUTO (27-sep, LDPlayer): esta rama venia VACIA de fabrica y la
			-- cabecera se quedaba en «V 0» despues de recargar hasta reentrar
			-- (el S2C 60 si sube _ED.vip_grade). Su etiqueta es AtlasLabel_vip,
			-- la misma que pinta updateDrawVip().
			self:updateDrawVip()
		elseif __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then
			self._VIP:setString(self.vip_grade)
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
				self._VIP:setString(self.vip_grade)
			else
				self._VIP:setString(_emailTypeSystemTip[2].." "..self.vip_grade)
			end
		end	
	end
	
	if self.user_experience ~= _ED.user_info.user_experience then
		self.user_experience = _ED.user_info.user_experience
		if self._LoadingBar_1 ~= nil then
			self._LoadingBar_1:setPercent(self.user_experience/self.user_grade_need_experience *100)
		end
	end
	
	if self.user_grade_need_experience ~= _ED.user_info.user_grade_need_experience then
		self.user_grade_need_experience = _ED.user_info.user_grade_need_experience
		if self._LoadingBar_1 ~= nil then
			self._LoadingBar_1:setPercent(self.user_experience/self.user_grade_need_experience *100)
		end
	end
	
	if self.user_food ~= _ED.user_info.user_food then
		self.user_food = _ED.user_info.user_food
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
			local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
			Label_power_left:setString(_ED.user_info.user_food)
			Label_power_right:setString(self.max_user_food)
			if tonumber(_ED.user_info.user_food) > tonumber(self.max_user_food) then
			 	Label_power_left:setColor(cc.c3b(26,157,0))
			 	-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			 	-- 	Label_power_left:setColor(cc.c3b(26,157,0))
			 	-- end
			else
				Label_power_left:setColor(cc.c3b(255,255,255))
				-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			 -- 		Label_power_left:setColor(cc.c3b(26,157,0))
			 -- 	end
			end
		else
			-- health:setString(self.user_food.."/"..self.max_user_food)
			if zstring.tonumber( _ED.user_info.user_food) > 10000  then
				self._health:setString(math.floor(_ED.user_info.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
			else
				self._health:setString(_ED.user_info.user_food .. "/" ..self.max_user_food)
			end
		end
	end
	
	if self.endurance ~= _ED.user_info.endurance then
		self.endurance = _ED.user_info.endurance
		if zstring.tonumber( self.endurance) > 10000  or zstring.tonumber( self.max_endurance) > 10000 then
			if self._shen ~= nil then
				self._shen:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
			end
		else
			if self._shen ~= nil then
				self._shen:setString(self.endurance.."/"..self.max_endurance)
			end
		end
	
	end
	
	if self.max_endurance ~= _ED.user_info.max_endurance then
		self.max_endurance = _ED.user_info.max_endurance
		if zstring.tonumber( self.endurance) > 10000  or zstring.tonumber( self.max_endurance) > 10000 then
			if self._shen ~= nil then
				self._shen:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
			end
		else
			if self._shen ~= nil then
				self._shen:setString(self.endurance.."/"..self.max_endurance)
			end
		end
	
	end
	
	if self.fight_capacity ~= _ED.user_info.fight_capacity then
		self.fight_capacity = _ED.user_info.fight_capacity
		-- if zstring.tonumber( self.fight_capacity) > 100000000 then
		-- 	self._BitmapFontLabel_5:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
		-- else
		if zstring.tonumber(self.fight_capacity)> 10000 then
			if verifySupportLanguage(_lua_release_language_en) == true then
				self._BitmapFontLabel_5:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
			else
				self._BitmapFontLabel_5:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
			end
		else
			self._BitmapFontLabel_5:setString(self.fight_capacity)
		end
	end
	
	-- if self.action ~= nil then
		-- self.action:gotoFrameAndPlay(0, self.action:getDuration(), false)
		-- self.action = nil
	-- end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local new_time = tonumber(_ED.system_time) + (os.time() - tonumber(_ED.native_time))
	    if self._last_time ~= new_time then
	    	if self._Text_dg_time ~= nil then
		        self._Text_dg_time:setString(self:getIntervalByTime(new_time))
		    end
	    end
	    if self.Panel_bg_view ~= nil then
	    	if _ED.user_rank_title_info then
		    	if self._title ~= zstring.tonumber(_ED.user_rank_title_info._current_title) then
		    		self._title = zstring.tonumber(_ED.user_rank_title_info._current_title) or 0
					if self._title > 0 then
						self.Panel_bg_view:setVisible(true)
						self.Panel_bg_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], self._title, title_param.pic_index)))
					else
						self.Panel_bg_view:setVisible(false)
					end
				end
			end
		end
    end
end

function UserInformation:onExit()
	state_machine.remove("user_information_show_all_info")
	state_machine.remove("user_information_refresh_all_info")
	state_machine.remove("user_information_hide_event")
	state_machine.remove("user_information_show_event")
	state_machine.remove("user_information_update_vip")
	state_machine.remove("user_information_update_head")
	state_machine.remove("user_information_update_role_head_info")
	state_machine.remove("user_information_update_role_head_red_dot")
	
end
