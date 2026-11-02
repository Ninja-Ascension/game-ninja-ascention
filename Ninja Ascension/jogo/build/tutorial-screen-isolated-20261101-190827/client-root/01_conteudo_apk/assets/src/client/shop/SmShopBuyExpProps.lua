-- ----------------------------------------------------------------------------------------------------
-- 说明：购买经验药水
-------------------------------------------------------------------------------------------------------

SmShopBuyExpProps = class("SmShopBuyExpPropsClass", Window)

local sm_shop_buy_exp_props_open_terminal = {
    _name = "sm_shop_buy_exp_props_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		-- Pulsacion larga sobre una celda ya liberada: cells.prop llega nil.
		if params == nil or params[1] == nil then return false end
		local _homeWindow = fwin:find("SmShopBuyExpPropsClass")
        if nil == _homeWindow then
            local panel = SmShopBuyExpProps:createCell()
            panel:init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_shop_buy_exp_props_close_terminal = {
    _name = "sm_shop_buy_exp_props_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmShopBuyExpPropsClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmShopBuyExpPropsClass"))
        end
        state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
        state_machine.unlock("formation_back_to_home_activity", 0, "")
        state_machine.unlock("hero_listview_set_index", 0, "")
        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
        state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_shop_buy_exp_props_open_terminal)
state_machine.add(sm_shop_buy_exp_props_close_terminal)
state_machine.init()

function SmShopBuyExpProps:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.cell = {}
	self.prop_id = 0
	self._select_num = 1
	self._max_select_num = nil
	self.onePrice = 0
	self.isTouch = false
	self.currtype = 0
    self.shop_goods_id = 0
    self.touchBeginTime = 0
    self.touchEndTime = 0
    self.isTouch = false
    self.currTime = 0

	local function init_Shop_vip_prop_terminal()
		-- 购买
        local sm_shop_buy_exp_props_request_terminal = {
            _name = "sm_shop_buy_exp_props_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responsebuyCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(tipStringInfo_prop_buy_tip[2])
                        state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw",0,"sm_role_strengthen_tab_up_grade_update_draw.")
                    	state_machine.excute("sm_shop_buy_exp_props_close", 0,"sm_shop_buy_exp_props_close.")
                    end
                end
                protocol_command.shop_buy.param_list = instance.shop_goods_id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.shop_buy.code, nil, nil, nil, instance, responsebuyCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改数量
        local sm_shop_buy_exp_props_change_number_terminal = {
            _name = "sm_shop_buy_exp_props_change_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currtype = params._datas.currtype
                if currtype == 1 then
                    instance._select_num = instance._select_num + 1
                    if instance._select_num > instance._max_select_num then
                        instance._select_num = instance._max_select_num
                    end
                elseif currtype == 2 then
                    instance._select_num = instance._select_num - 1
                    if instance._select_num < 1 then
                        instance._select_num = 1
                    end
                else
                	instance._select_num = instance._max_select_num
                end
                instance:drawNumberInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(sm_shop_buy_exp_props_request_terminal)
		state_machine.add(sm_shop_buy_exp_props_change_number_terminal)
        state_machine.init()
	end
	init_Shop_vip_prop_terminal()
end
function SmShopBuyExpProps:drawNumberInfo()
	local root = self.roots[1]
	--总价
	local Text_buy_7 = ccui.Helper:seekWidgetByName(root,"Text_buy_7")
	Text_buy_7:setString(self._select_num * self.onePrice)
	--数量
	local Text_buy_12 = ccui.Helper:seekWidgetByName(root,"Text_buy_12")
	Text_buy_12:setString(self._select_num)
end

function SmShopBuyExpProps:onUpdateDraw()
	local root = self.roots[1]
	local Panel_dj_tx = ccui.Helper:seekWidgetByName(root,"Panel_dj_tx")
	Panel_dj_tx:removeAllChildren(true)
	local cell = PropIconNewCell:createCell()
	cell:init(cell.enum_type._USE_CONSUMPTION, self.prop_id)
	Panel_dj_tx:addChild(cell)
	--名称
	local Text_buy_1 = ccui.Helper:seekWidgetByName(root,"Text_buy_1")
	local prop_data = dms.element(dms["prop_mould"] , self.prop_id)
	local prop_name = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        prop_name = setThePropsIcon(self.prop_id)[2]
    else
        prop_name = zstring.exchangeFrom(dms.atos(prop_data , prop_mould.prop_name))
    end
	Text_buy_1:setString(prop_name)
	--介绍
	local Text_info = ccui.Helper:seekWidgetByName(root,"Text_info")
	Text_info:setString(self.prop_dec)

	self._max_select_num = dms.int(dms["ship_config"], 8 , ship_config.param)

    local prop_data = dms.searchs(dms["avatar_shop"], avatar_shop.shop_type, 0)--经验药购买类型0
    for i , v in pairs(prop_data) do
        local prop_info = zstring.split(v[avatar_shop.prop] , ",")
        if tonumber(prop_info[2]) == self.prop_id then
            self.shop_goods_id = v[avatar_shop.id]
            local cost_info = zstring.split(v[avatar_shop.cost_gold] , ",")
            self.onePrice = tonumber(cost_info[3])
            break
        end
    end

	self:drawNumberInfo()
end

function SmShopBuyExpProps:onUpdate( dt )
    self.currTime = self.currTime + dt
    if self.touchEndTime ~= 0 and self.touchEndTime - self.touchBeginTime == 0 then
        self.touchEndTime = 0
        state_machine.excute("sm_shop_buy_exp_props_change_number", 0 , { _datas = { currtype = self.currtype } } )
    else 
        if self.isTouch == true then
            if self.currTime - self.touchBeginTime > 0.5 then
                state_machine.excute("sm_shop_buy_exp_props_change_number", 0 , { _datas = { currtype = self.currtype } } )
            end
    	end
    end
end

function SmShopBuyExpProps:onEnterTransitionFinish()

end


function SmShopBuyExpProps:init(params)
	self.prop_id = tonumber(params[1])
	self.prop_dec = params[2]
	self:onInit()
end

function SmShopBuyExpProps:onInit()
    local csbSmRoleStrengthenUniversal = csb.createNode(config_csb.shop.buy_exp_props)
    local root = csbSmRoleStrengthenUniversal:getChildByName("root")
    table.insert(self.roots, root)
    local action = csb.createTimeline(config_csb.shop.buy_exp_props)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbSmRoleStrengthenUniversal:runAction(action)
    self:addChild(csbSmRoleStrengthenUniversal)

    --购买请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gmdj_2"), nil, 
    {
        terminal_name = "sm_shop_buy_exp_props_request", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local function addOnTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if ccui.TouchEventType.began == evenType then
			self.touchBeginTime = os.time()
            self.currTime = self.touchBeginTime
			self.currtype = 1
            self.isTouch = true
		elseif ccui.TouchEventType.moved == evenType then
			if __mpoint.x - __spoint.x > 80 
				or __mpoint.x - __spoint.x < -80 
				or __mpoint.y - __spoint.y > 50 
				or __mpoint.y - __spoint.y < -50 
				then
				self.touchEndTime = os.time()
                self.isTouch = false
			end
		elseif ccui.TouchEventType.ended == evenType then
            self.touchEndTime = os.time()
            self.isTouch = false
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_jia"):addTouchEventListener(addOnTouchEvent)

	local function sumOnTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if ccui.TouchEventType.began == evenType then
			self.touchBeginTime = os.time()
            self.currTime = self.touchBeginTime
			self.currtype = 2
            self.isTouch = true
		elseif ccui.TouchEventType.moved == evenType then
			if __mpoint.x - __spoint.x > 80 
				or __mpoint.x - __spoint.x < -80 
				or __mpoint.y - __spoint.y > 50 
				or __mpoint.y - __spoint.y < -50 
				then
				self.touchEndTime = os.time()
                self.isTouch = false
			end
		elseif ccui.TouchEventType.ended == evenType then
			self.touchEndTime = os.time()
            self.isTouch = false
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_jian"):addTouchEventListener(sumOnTouchEvent)

    --最大数量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_max"), nil, 
    {
        terminal_name = "sm_shop_buy_exp_props_change_number", 
        terminal_state = 0,
        currtype = 3,
        isPressedActionEnabled = true,
    }, 
    nil, 0)
    --关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "sm_shop_buy_exp_props_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function SmShopBuyExpProps:createCell()
    local cell = SmShopBuyExpProps:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function SmShopBuyExpProps:onExit()
	state_machine.remove("sm_shop_buy_exp_props_change_number")
	state_machine.remove("sm_shop_buy_exp_props_request")
end
