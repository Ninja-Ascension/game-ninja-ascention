-----------------------------
--阵营选择
-----------------------------
CampChose = class("CampChoseClass", Window)
--打开界面
local camp_chose_window_open_terminal = {
	_name = "camp_chose_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            return true
        end
		if fwin:find("CampChoseClass") == nil and zstring.tonumber(_ED.user_info.user_force) == 0 then
			fwin:open(CampChose:new():init(),fwin._notification)		
		end

		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local camp_chose_window_close_terminal = {
	_name = "camp_chose_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CampChoseClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(camp_chose_window_open_terminal)
state_machine.add(camp_chose_window_close_terminal)
state_machine.init()

function CampChose:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- load lua file
	app.load("client.red_alert.login.JoinCampSuceess")
	
	-- var
	--选择类型     1部落   2天灾   3联盟    4随机
	self.select_index = 0
	--是否确认
	self.is_sure = false

    -- Initialize CampChose machine.
    local function init_camp_chose_terminal()
        -- select 选择阵营
        local camp_chose_select_terminal = {
            _name = "camp_chose_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = params._datas.index
            	instance:changeSelect(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- playRandoms 随机选择阵营
        local camp_chose_select_randoms_terminal = {
            _name = "camp_chose_select_randoms",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:playRandoms()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- sure 确认
        local camp_chose_select_sure_terminal = {
            _name = "camp_chose_select_sure",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = instance.select_index
        		if index == 0 then
					index = 4
				end 
            	local function responseCallback(response)
	                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                		if index == 4 then
                			state_machine.excute("camp_chose_select_randoms",0,"")
                		else
                			state_machine.excute("camp_chose_window_close",0,"")
                			state_machine.excute("main_window_open",0,"")
							state_machine.excute("join_camp_suceess_window_open",0,"")
	                		state_machine.excute("player_info_update_draw",0,"")
	                		state_machine.excute("user_information_update_vip",0,"")
                		end	
                    end
            	end
            	if __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            		then
            		instance.is_sure = true
            	end
				if instance.is_sure ~= true then	
                    app.load("client.utils.ConfirmTip")
					local tip = ConfirmTip:new()
					tip:init(instance, instance.sureChoose,choose_camp_tip_string[index])
					fwin:open(tip,fwin._notification)                    
                    return
                end 

  				protocol_command.chose_camp.param_list = ""..instance.select_index
                NetworkManager:register(protocol_command.chose_camp.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(camp_chose_select_terminal)
        state_machine.add(camp_chose_select_sure_terminal)
        state_machine.add(camp_chose_select_randoms_terminal)
        state_machine.init()
    end

    -- call func init CampChose machine.
    init_camp_chose_terminal()
end

--确认随机选择阵营
function CampChose:playRandoms()
	local root = self.roots[1]
	for i=1,4 do
		local Panel_camp_light =  ccui.Helper:seekWidgetByName(root,"Panel_camp_light_"..i)
		Panel_camp_light:setVisible(false)
		if __lua_project_id ~= __lua_project_red_alert 
			and __lua_project_id ~= __lua_project_red_alert_time
			then
			local Button_camp =  ccui.Helper:seekWidgetByName(root,"Button_camp_"..i)
			Button_camp:setScale(self.scale)
		end
	end
	local Panel_camp_light =  ccui.Helper:seekWidgetByName(root,"Panel_camp_light_".._ED.user_info.user_force)
	Panel_camp_light:setVisible(true)
	if __lua_project_id ~= __lua_project_red_alert 
		and __lua_project_id ~= __lua_project_red_alert_time
		then
		local Button_camp =  ccui.Helper:seekWidgetByName(root,"Button_camp_".._ED.user_info.user_force)
		Button_camp:setScale(1.1)
	end
	local function doOther()
    	state_machine.excute("camp_chose_window_close",0,"")
		state_machine.excute("main_window_open",0,"")
		state_machine.excute("join_camp_suceess_window_open",0,"")
		state_machine.excute("player_info_update_draw",0,"")
		state_machine.excute("user_information_update_vip",0,"")
	end
	Panel_camp_light:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(doOther)))
end

--确认选择
function CampChose:sureChoose( surenumber )
    if surenumber == 0 then
    	self.is_sure = true
    	state_machine.excute("camp_chose_select_sure",0,"")
    end
end

--第一次打开选中随机阵营
function CampChose:onUpdateDraw()
	state_machine.excute("camp_chose_select",0,
		{
			_datas = 
			{
				terminal_name = "camp_chose_select", 
		        terminal_state = 0, 
		        index = 4,
		        touch_scale = true,
		        touch_scale_xy = 0.95,
			}
		}
		)
end

--选择阵营
function CampChose:changeSelect(index)
	local root = self.roots[1]
	if index == 4 then
		self.select_index = 0
	else
		self.select_index = index
	end
	
	if __lua_project_id ~= __lua_project_red_alert 
		and __lua_project_id ~= __lua_project_red_alert_time
		then
		for i=1,4 do
			local Button_camp =  ccui.Helper:seekWidgetByName(root,"Button_camp_"..i)
			Button_camp:setScale(self.scale)
		end
		local Button_camp =  ccui.Helper:seekWidgetByName(root,"Button_camp_"..index)
		Button_camp:setScale(1.1)
	end
	for i=1,4 do
		local Panel_camp_light =  ccui.Helper:seekWidgetByName(root,"Panel_camp_light_"..i)
		Panel_camp_light:setVisible(false)
	end

	local Panel_camp_light =  ccui.Helper:seekWidgetByName(root,"Panel_camp_light_"..index)
	Panel_camp_light:setVisible(true)
	
	local Text_camp_infor =  ccui.Helper:seekWidgetByName(root,"Text_camp_infor")
	Text_camp_infor:setString(choose_camp_tip_string[index])
end

function CampChose:init()
	self:onInit()
    return self
end

--初始化界面
function CampChose:onInit()
	-- debug.print_r(_ED.user_info)
    local csbItem = csb.createNode(config_csb.login.camp_chose)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self.scale = ccui.Helper:seekWidgetByName(root,"Button_camp_1"):getScale() 
    --确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sure"), nil, 
    {
        terminal_name = "camp_chose_select_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    for i=1,4 do
    	--选择
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_camp_"..i), nil, 
	    {
	        terminal_name = "camp_chose_select", 
	        terminal_state = 0, 
	        index = i,
	    }, nil, 0)
    end
    self:onUpdateDraw()
end

function CampChose:onEnterTransitionFinish()
    
end

--移除状态机
function CampChose:onExit()
    state_machine.remove("camp_chose_select")
    state_machine.remove("camp_chose_select_sure")
    state_machine.remove("camp_chose_select_randoms")
end
function LoginLoading:destroy()
    -- clean frame windows
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
	    fwin:removeAll()
		self:unregisterOnNoteUpdate(self)
		
		state_machine.excute("main_window_open",0,"")
		fwin:__show(fwin._frameview)
	end
end
