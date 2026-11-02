-- ----------------------------------------------------------------------------------------------------
-- 说明：双倍或者折扣活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityDoubleDiscount = class("ActivityDoubleDiscountClass", Window)
    
function ActivityDoubleDiscount:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	self._tick_time = 0
	self._endtime = nil

	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.prop.prop_icon_cell")
    -- Initialize ActivityDoubleDiscount state machine.
    local function init_ActivityDoubleDiscount_terminal()
		local activity_double_discount_button_terminal = {
            _name = "activity_double_discount_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local typeIndex = params._datas._typeIndex
				if nil ~=  typeIndex then
					instance:gotoPage(typeIndex)
				end
				
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(activity_double_discount_button_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityDoubleDiscount state machine.
    init_ActivityDoubleDiscount_terminal()

    self._load_over = false
	self:onLoad()
end


function ActivityDoubleDiscount:gotoPage(typeIndex)
	if typeIndex == 43 then -- 竞技场
		
		local isOpen_arena  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 16, fun_open_condition.level)
		
		if false == isOpen_arena then
			TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 16, fun_open_condition.tip_info))
			return
		end
	
	
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
		fwin:open(Arena:new(), fwin._view) 
	elseif typeIndex == 44 then -- 副本
		app.load("client.home.Menu")
		if fwin:find("MenuClass") == nil then
			fwin:open(Menu:new(), fwin._taskbar)
		end
		state_machine.excute("menu_manager", 0, 
			{
				_datas = {
					terminal_name = "menu_manager", 	
					next_terminal_name = "menu_show_duplicate",  	
					current_button_name = "Button_duplicate", 	
					but_image = "Image_duplicate", 	
					terminal_state = 0, 
					isPressedActionEnabled = true
				}
			}
		)
		state_machine.excute("duplicate_controller_copy_page", 0, "")
		
	elseif typeIndex == 46 then -- 神将
		if fwin:find("MenuClass") == nil then
			fwin:open(Menu:new(), fwin._taskbar)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
					    terminal_name = "menu_manager",     
		                next_terminal_name = "menu_show_shop",          
		                current_button_name = "Button_zhaomu",
		                but_image = "Image_shop",       
		                terminal_state = 0,
		                shop_type = "zhaomu",
		                isPressedActionEnabled = true
					}
				}
			)			

		else
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_shop", 			
						current_button_name = "Button_shop", 		
						but_image = "Image_shop", 		
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			state_machine.excute("shop_manager", 0, 
				{
					_datas = {
						terminal_name = "shop_manager",     
						next_terminal_name = "shop_ship_recruit",
						current_button_name = "Button_tavern",  
						but_image = "recruit",      
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			local heroRecruitGeneralViewWindow = HeroRecruitGeneralView:new()
			heroRecruitGeneralViewWindow:init(2,1)
			fwin:open(heroRecruitGeneralViewWindow,fwin._ui)
		end

	elseif typeIndex == 65 then -- 世界海战
		local isOpen_trialtower = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 14, fun_open_condition.level)
		if false == isOpen_trialtower then
			TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 14, fun_open_condition.tip_info))
			return
		end
	
		local function responseKingdomsCallback(response)
						
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots[1] ~= nil then
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
					fwin:open(TrialTower:new(), fwin._view) 
				end	
			end
		end
		NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, self, responseKingdomsCallback, false, nil)
	end

end

function ActivityDoubleDiscount:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_icon_jl")
	listview:removeAllItems()
	
	if self.typeIndex == 43 then -- 竞技场
		ccui.Helper:seekWidgetByName(root, "Panel_303"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_diaoluo"):setVisible(true)
		
		-- props_4004 x2
		local cell = propMoneyIcon:createCell()
		cell:init("3",0,_All_tip_string_info._reputation,nil,true)
		listview:addChild(cell)
		
	elseif self.typeIndex == 44 then -- 副本
		ccui.Helper:seekWidgetByName(root, "Panel_303"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_diaoluo"):setVisible(true)
		
		-- props_3002 x2
		local cell = PropIconCell:createCell()
		cell:init(31, "2")
		listview:addChild(cell)
		
	elseif self.typeIndex == 46 then -- 神将
		ccui.Helper:seekWidgetByName(root, "Panel_303"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_diaoluo"):setVisible(false)
	elseif self.typeIndex == 65 then -- 世界海战
		ccui.Helper:seekWidgetByName(root, "Panel_303"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_diaoluo"):setVisible(true)
		local cell = propMoneyIcon:createCell()
		cell:init("6",0,_All_tip_string_info._glories,nil,true)
		listview:addChild(cell)
	end
end

function ActivityDoubleDiscount:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
end

function ActivityDoubleDiscount:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self._tick_time = 0
	self._endtime = nil
end

function ActivityDoubleDiscount:onEnterTransitionFinish()

end

function ActivityDoubleDiscount.onImageLoaded(texture)
	
end

function ActivityDoubleDiscount:onArmatureDataLoad(percent)
	
end

function ActivityDoubleDiscount:onArmatureDataLoadEx(percent)

end

function ActivityDoubleDiscount:onLoad()

end

function ActivityDoubleDiscount:onUpdate( dt )
    if self._endtime == nil then
        return
    end
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
    	self._tick_time = 0
    end
	self._endtime:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function ActivityDoubleDiscount:onInit()
    local csbActivityDoubleDiscount = csb.createNode("activity/wonderful/build_discount.csb")
    local root = csbActivityDoubleDiscount:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityDoubleDiscount)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
	else
		self:onUpdateDraw()
	end
	local title = ccui.Helper:seekWidgetByName(root, "Text_1")
	local text = ccui.Helper:seekWidgetByName(root, "Text_2")
	local endtime = ccui.Helper:seekWidgetByName(root, "Text_4")
	
	local activity = _ED.active_activity[self.typeIndex]
	if activity ~= nil then
		if title ~= nil then
			title:setString(_tip_info_activity[self.typeIndex][1])
		end
		
		local str = _tip_info_activity[self.typeIndex][2]
		
		if self.typeIndex == 46 then 
			str = string.format(str,activity.discount)

			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				local zhekou = countActivityHeroDiscount()
				ccui.Helper:seekWidgetByName(root, "Text_zekoujia1"):setString("".. zhekou.one)
				ccui.Helper:seekWidgetByName(root, "Text_zekoujia2"):setString("".. zhekou.ten)
          	end
		end
		
		text:setString(str)
		self._tick_time = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
			or __lua_project_id == __lua_project_l_naruto
			then
			self._endtime = endtime
			local Text_date = ccui.Helper:seekWidgetByName(root, "Text_date")
			-- FURY: misma correccion que en `SmActivityLimitedWindow`:
			-- el rango por el ayudante compartido, que trae el ano.
			--
			-- Y OJO CON EL 43 Y EL 44: el parser NO les rellena
			-- `begin_time` ni `end_time`. Su rama de cola es la de
			-- ProtocolParserCopy.lua:4703-4715, que solo trae
			-- `activity_over_time` (fin del evento) y
			-- `activity_draw_over_time` (fin del plazo de cobro); la
			-- rama de cinco tokens que si trae las dos fechas es el
			-- `else` de mas abajo y este `elseif` gana. Con nil,
			-- `zstring.tonumber` devuelve CERO y el rango salia en 1970
			-- con la cuenta atras a cero. Se cae al campo que SI llega.
			local fury_end = activity.end_time
			if fury_end == nil or fury_end == "" then
				fury_end = activity.activity_over_time
			end
			if activity.begin_time ~= nil and activity.begin_time ~= "" then
				Text_date:setString(
					getRedAlertTimeActivityFormat(zstring.tonumber(activity.begin_time)/1000, 1).."-"..
					getRedAlertTimeActivityFormat(zstring.tonumber(fury_end)/1000, 1))
			else
				-- Sin inicio no hay rango: se pinta solo el final, que es
				-- el dato que el evento si manda.
				Text_date:setString(
					getRedAlertTimeActivityFormat(zstring.tonumber(fury_end)/1000, 1))
			end
			self._tick_time = zstring.tonumber(fury_end)/1000 - (os.time() + _ED.time_add_or_sub)
			endtime:setString(getRedAlertTimeActivityFormat(self._tick_time))
		else
			-- endtime:setString(zstring.exchangeFrom(activity.activity_draw_over_time))
			endtime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_draw_over_time)/1000)))	
		
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
				{
					terminal_name = "activity_double_discount_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true,
					_typeIndex = self.typeIndex
				},
				nil,0)
		end
	end
end

function ActivityDoubleDiscount:onExit()
	state_machine.remove("activity_double_discount_button")
end

function ActivityDoubleDiscount:init(typeIndex)
	self.typeIndex = tonumber(typeIndex)
end


function ActivityDoubleDiscount:createCell()
	local cell = ActivityDoubleDiscount:new()
	cell:registerOnNodeEvent(cell)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		cell:registerOnNoteUpdate(cell, 0.5)
	end
	return cell
end