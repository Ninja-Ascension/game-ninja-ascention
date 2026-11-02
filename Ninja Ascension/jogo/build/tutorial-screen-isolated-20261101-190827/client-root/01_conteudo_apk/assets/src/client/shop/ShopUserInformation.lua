-- ----------------------------------------------------------------------------------------------------
-- 说明：商城用户信息标题栏
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopUserInformation = class("ShopUserInformationClass", Window)

function ShopUserInformation:ctor()
    self.super:ctor()
	
	self.roots = {}

	self._Text_name 	= nil
	self._Text_vip 		= nil
	self._Text_money 	= nil
	self._Text_money_0 	= nil

    local function init_shop_user_information_terminal()
		local shop_window_update_terminal = {
            _name = "shop_window_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:UIInitInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 用户信息显示
		local shop_user_information_show_all_info_terminal = {
            _name = "shop_user_information_show_all_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.player.PlayerInfomation")
				fwin:open(PlayerInfomation:new(),fwin._windows )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(shop_user_information_show_all_info_terminal)
		state_machine.add(shop_window_update_terminal)
    end
    
    init_shop_user_information_terminal()
end
--加载UI
function ShopUserInformation:ShowUI()
	local csbShopUserInformation = csb.createNode("shop/shop_2.csb")
	local action = csb.createTimeline("shop/shop_2.csb")
	local csbShopUserInformation_root = csbShopUserInformation:getChildByName("root")
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbShopUserInformation:runAction(action)
	table.insert(self.roots, csbShopUserInformation_root)
    self:addChild(csbShopUserInformation)
end
--用户信息框
function ShopUserInformation:UIInitInfo()
	self.user_name = _ED.user_info.user_name			--用户名
	self.vip_grade = _ED.vip_grade						--VIP等级
	self.user_silver = _ED.user_info.user_silver		--用户银币
	self.user_gold = _ED.user_info.user_gold			--元宝
	
	local Text_name 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_name")
	local Text_vip 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_vip")
	local Text_money 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_money")
	local Text_money_0 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_money_0")

	self._Text_name 	= Text_name
	self._Text_vip 		= Text_vip
	self._Text_money 	= Text_money
	self._Text_money_0 	= Text_money_0

	local shipType = 0
	for i, ship in pairs(_ED.user_ship) do
		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			if dms.atoi(shipData, ship_mould.captain_type) == 0 then
				shipType = ship.ship_type + 1
				Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[shipType][1], tipStringInfo_quality_color_Type[shipType][2], tipStringInfo_quality_color_Type[shipType][3]))
				break
			end
		end
	end
	
	Text_name:setString(self.user_name)
	if ___is_open_leadname == true then
		Text_name:setFontName("")
		Text_name:setFontSize(Text_name:getFontSize())
	end
	Text_vip:setString(self.vip_grade)
	Text_money:setString(self.user_silver)
	Text_money_0:setString(self.user_gold)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up"), nil, {func_string = [[state_machine.excute("shop_user_information_show_all_info", 0, "equip_player_infomation_button.'")]]}, nil, 0)
end


function ShopUserInformation:onEnterTransitionFinish()
	--加载UI
	self:ShowUI()
	--用户信息框
	self:UIInitInfo()
end

function ShopUserInformation:onExit()
	state_machine.remove("shop_window_update")
	state_machine.remove("shop_user_information_show_all_info")
end

function ShopUserInformation:onUpdate(dt)

	if self.user_name ~= _ED.user_info.user_name then
		self.user_name = _ED.user_info.user_name
		self._Text_name:setString(self.user_name)
	end
	
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		self._Text_money:setString(self.user_silver)
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		self._Text_money_0:setString(self.user_gold)
	end
	
	if self.vip_grade ~= _ED.vip_grade then
		self.vip_grade = _ED.vip_grade
		self._Text_vip:setString(self.vip_grade)
	end
end
