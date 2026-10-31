-- ----------------------------------------------------------------------------------------------------
-- 说明：折扣贩售
-------------------------------------------------------------------------------------------------------
ActivityDiscountSale = class("ActivityDiscountSaleClass", Window)
    
function ActivityDiscountSale:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_discount_sale_list_cell")
	self.roots = {}
	self.loaded = false
	self._Text_32 = nil
	
	self.examples = {}
	
    -- Initialize ActivityDiscountSale state machine.
    local function init_activity_discount_sale_terminal()
		--帮助
		local activity_discount_sale_help_terminal = {
            _name = "activity_discount_sale_help",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.activity.ActivityDiscountSaleHelp")
				state_machine.excute("activity_discount_sale_help_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_discount_sale_help_terminal)
        state_machine.init()
    end
    -- call func init ActivityDiscountSale state machine.
    init_activity_discount_sale_terminal()
end

function ActivityDiscountSale:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[76]--
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		-- _tip_info_activity[62][2]
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[76][1])
		end
		countText:setString(_tip_info_activity[76][2])
		
		local activityStartTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动开始时间
		activityStartTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.activity_start_day)))
		
		
		-- FURY: cuenta atras en vez de la fecha absoluta de INICIO que
		-- pintaba la linea de arriba. Ver `updateDrawActivityTime`.
		self._Text_32 = activityStartTime
		self:updateDrawActivityTime()
		
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--活动截止时间
		-- FURY: `activityEndTime` no esta en landed_gifts.csb de este proyecto; sin la guarda esto moria en el primer metodo sobre nil.
		if activityEndTime ~= nil then
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.activity_login_day)))
		end

		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		rewardListView:removeAllItems()
		for i, v in ipairs(self.examples) do
			local cell = ActivityDiscountSaleListCell:createCell()
			cell:init(v,i)
			rewardListView:addChild(cell)
		end
	end
end

-- FURY: EL RELOJ DEL EVENTO, copiado del 28
-- (ActivityExchangeProp.lua:231-245). `Text_32` de `landed_gifts.csb`
-- viene con "00:00:00" y justo al lado el cartel `yyhd_djs.png`
-- («cuenta regresiva del evento»): ese hueco es una CUENTA ATRAS, no
-- una fecha. Lo alimenta `activity_login_day`, que es el PRIMER token
-- del bloque y YA VIAJA -el parser lo guarda como
-- `os.time() + restante/1000`, ProtocolParserCopy.lua:4664-4665-, asi
-- que no faltaba ningun token: faltaba el refresco.
function ActivityDiscountSale:updateDrawActivityTime()
	if self._Text_32 == nil then
		return
	end
	local activity = _ED.active_activity[76]
	if activity == nil then
		return
	end
	local surplus = zstring.tonumber(activity.activity_login_day)
					- (os.time() + _ED.time_add_or_sub)
	self._Text_32:setString(tostring(surplus < 0 and _string_piece_info[305]
								 or getRedAlertTimeActivityFormat(surplus)))
end

function ActivityDiscountSale:onUpdate(dt)
	self:updateDrawActivityTime()
end

function ActivityDiscountSale:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
	-- FURY: `Button_help` no esta en landed_gifts.csb de este proyecto.
	local Button_help = ccui.Helper:seekWidgetByName(root, "Button_help")
	if Button_help ~= nil then
		Button_help:setVisible(true)
		fwin:addTouchEventListener(Button_help, nil, 
		{
			terminal_name = "activity_discount_sale_help", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)
	end
end

function ActivityDiscountSale:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityDiscountSale:unload()
	self._Text_32 = nil
	self:unregisterOnNoteUpdate(self)
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}

end

function ActivityDiscountSale:onEnterTransitionFinish()
	
end

function ActivityDiscountSale:onExit()
end

function ActivityDiscountSale:init()
	local activity = _ED.active_activity[76]--
	self.examples = zstring.split(activity.activity_extra_prame, "\\r\\n")
	if _ED.discount_sale_exchang_times == nil or _ED.discount_sale_exchang_times == "" then
		_ED.discount_sale_exchang_times = zstring.split(activity.activity_extra_prame2, ",")
	end
end

function ActivityDiscountSale:createCell()
	local cell = ActivityDiscountSale:new()
	cell:registerOnNodeEvent(cell)
	return cell
end