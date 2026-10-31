-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂
-- 创建时间	2015.4.27
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHall = class("FameHallClass", Window)
    
function FameHall:ctor()
    self.super:ctor()
    self.roots = {}
	self.times = nil
	self.startTime = nil
    self.messageOne = {}
    self.messageTwo = {}
	self.status = nil
	self.num = 1
	self.panel = nil

	
	app.load("client.home.fame.FameHallHead")
	app.load("client.home.fame.FameHallShowPlayOne")
	app.load("client.home.fame.FameHallShowPlayTwo")
	
    -- Initialize FameHall page state machine.
    local function init_fame_hall_terminal()
	
		local fame_hall_sort_by_fighting_terminal = {
            _name = "fame_hall_sort_by_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_16"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15"):setVisible(false)
				
				local function responseStartCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						if response.node == nil and response.node.roots == nil  then
							return
						end
						
						response.node:onUpdateDrawOne()
						response.node.status = 1
						ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_ming_1"):setHighlighted(true)
						ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_ming_2"):setHighlighted(false)
					end
				end
				
				protocol_command.celebrity_bulletin_init.param_list = "0"
				NetworkManager:register(protocol_command.celebrity_bulletin_init.code, nil, nil, nil, instance, responseStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local fame_hall_sort_by_level_terminal = {
            _name = "fame_hall_sort_by_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_16"):setVisible(false)
				local function responseStartCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:onUpdateDrawTwo()
							response.node.status = 2
							ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_ming_1"):setHighlighted(false)
							ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_ming_2"):setHighlighted(true)
						end
					end
				end
				
				protocol_command.celebrity_bulletin_init.param_list = "1"
				NetworkManager:register(protocol_command.celebrity_bulletin_init.code, nil, nil, nil, instance, responseStartCallback, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local fame_hall_ranking_list_terminal = {
            _name = "fame_hall_ranking_list",
            _init = function (terminal) 
                app.load("client.home.fame.FameHallShow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(FameHallShow:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local fame_hall_update_terminal = {
            _name = "fame_hall_update",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_10_0"):setString(_ED.celebrity_star_add_all_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local fame_hall_research_terminal = {
            _name = "fame_hall_research",
            _init = function (terminal) 
                app.load("client.home.fame.FameHallResearch")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(FameHallResearch:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local fame_hall_update_user_message_terminal = {
            _name = "fame_hall_update_user_message",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				instance:updateCurrentState()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local famous_general_close_terminal = {
			_name = "famous_general_close",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(fwin:find("FameHallClass"))				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(fame_hall_update_user_message_terminal)
		state_machine.add(fame_hall_sort_by_fighting_terminal)
		state_machine.add(fame_hall_sort_by_level_terminal)
		state_machine.add(fame_hall_ranking_list_terminal)
		state_machine.add(fame_hall_research_terminal)
		state_machine.add(fame_hall_update_terminal)
		state_machine.add(famous_general_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_fame_hall_terminal()
end

function FameHall:updateCurrentState()
	
	if self.status == 1 then
		state_machine.excute("fame_hall_sort_by_fighting", 0, "fame_hall_sort_by_fighting.")
	
	elseif  self.status == 2 then
		state_machine.excute("fame_hall_sort_by_level", 0, "fame_hall_sort_by_level.")
	 
	end

end

function FameHall:onUpdate(dt)
	local times = math.ceil(os.time() - self.times)
	if times > 0 and self.startTime == times then
		if self.status == 1 then
			-- self.num = 1
			local passage = self.messageOne[self.num]
			if string.trim(passage) == "" then
				passage = _string_piece_info[319]
			end
			if self.num == 3 or self.num == 6 then	--左边
				local cell = FameHallShowPlayTwo:createCell()
				cell:init(passage)
				self.panel[self.num]:addChild(cell)
			else									--右边
				local cell = FameHallShowPlayOne:createCell()
				cell:init(passage)
				self.panel[self.num]:addChild(cell)
			end
		elseif self.status == 2 then
			-- self.num = 1
			local passage = self.messageTwo[self.num]
			if string.trim(passage) == "" then
				passage = _string_piece_info[319]
			end
			if self.num == 3 or self.num == 6 then	--左边
				local cell = FameHallShowPlayTwo:createCell()
				cell:init(passage)
				self.panel[self.num]:addChild(cell)
			else									--右边
				local cell = FameHallShowPlayOne:createCell()
				cell:init(passage)
				self.panel[self.num]:addChild(cell)
			end
		end
		self.startTime = times + 3
		self.num = self.num + 1
		if self.num == 7 then
			self.num = 1
		end
	end
	if times > self.startTime then
		self.startTime = times + 3
	end
end

function FameHall:onUpdateDrawOne()
	local root = self.roots[1]
	local headPanel = {
		ccui.Helper:seekWidgetByName(root, "Panel_ming_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_6"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_5"),
	}
	local hero_tables = {}
	for i=1, 6 do
		headPanel[i]:removeAllChildren(true)
	end
	local status = false
	for i=1, tonumber(_ED.celebrity_num) do
		local cell = FameHallHead:createCell()
		cell:init(_ED.celebrity_info[i],1,i)
		headPanel[i]:addChild(cell)
		if tonumber(_ED.celebrity_info[i].user_id) == tonumber(_ED.user_info.user_id) then
			status = true
		end
		self.messageOne[i] = _ED.celebrity_info[i].user_message

		table.insert(hero_tables,cell)	
	end
	if status == false then
		ccui.Helper:seekWidgetByName(root, "Button_158"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Button_158"):setVisible(true)
	end
	ccui.Helper:seekWidgetByName(root, "Text_10_0"):setString(_ED.celebrity_star_add_all_num)
	local index = 0
	local function delatEnd( ... )
		local function repetBack( ... )
			index = index + 1
			if index > tonumber(_ED.celebrity_num) then
				self:stopAllActions()
				return
			end

			local v = hero_tables[index]
			if v ~= nil and v.addHeroAnimaton ~= nil and  v.roots ~= nil then
				v:addHeroAnimaton()
				v:setVisible(true)
			end
		end
		self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.001), cc.CallFunc:create(repetBack))))
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(delatEnd)))
	end		
end

function FameHall:onUpdateDrawTwo()
	local root = self.roots[1]
	local headPanel = {
		ccui.Helper:seekWidgetByName(root, "Panel_ming_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_6"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_ming_5"),
	}
	local hero_tables = {}
	for i=1, 6 do
		headPanel[i]:removeAllChildren(true)
	end
	local status = false
	local celebrityNumber = 0
	if tonumber(_ED.celebrity_num) > 6 then
		celebrityNumber = 6
	else
		celebrityNumber = tonumber(_ED.celebrity_num)
	end
	for i=1, celebrityNumber do
		local cell = FameHallHead:createCell()
		cell:init(_ED.celebrity_info[i],2,i)
		headPanel[i]:addChild(cell)
		if tonumber(_ED.celebrity_info[i].user_id) == tonumber(_ED.user_info.user_id) then
			status = true
		end
		self.messageTwo[i] = _ED.celebrity_info[i].user_message
		table.insert(hero_tables,cell)			
	end
	if status == false then
		ccui.Helper:seekWidgetByName(root, "Button_158"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Button_158"):setVisible(true)
	end
	
	if app.configJson.OperatorName == "gamedreamer" or app.configJson.OperatorName == "ggame" then
		ccui.Helper:seekWidgetByName(root, "Button_158"):setVisible(false)
	end
	
	ccui.Helper:seekWidgetByName(root, "Text_10_0"):setString(_ED.celebrity_star_add_all_num)

	local index = 0
	local function delatEnd( ... )
		local function repetBack( ... )
			index = index + 1
			if index > tonumber(_ED.celebrity_num) then
				self:stopAllActions()
				return
			end

			local v = hero_tables[index]
			if v ~= nil and v.addHeroAnimaton ~= nil and  v.roots ~= nil then
				v:addHeroAnimaton()
				v:setVisible(true)
			end
		end
		self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.001), cc.CallFunc:create(repetBack))))
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(delatEnd)))
	end		
end

function FameHall:onEnterTransitionFinish()
	local csbFameHall = csb.createNode("system/famous_general.csb")
	self:addChild(csbFameHall)
	local root = csbFameHall:getChildByName("root")
	table.insert(self.roots, root)
	self.times = os.time()
	self.startTime = math.ceil(os.time() - self.times) + 3
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ming_1"), nil, {terminal_name = "fame_hall_sort_by_fighting", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ming_2"), nil, {terminal_name = "fame_hall_sort_by_level", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ming_3"), nil, {terminal_name = "fame_hall_ranking_list", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_158"), nil, {terminal_name = "fame_hall_research", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
		local Button_close=fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mingrentang_back"), nil, {terminal_name = "famous_general_close", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
		Button_1:setHighlighted(true)
	end
	
	ccui.Helper:seekWidgetByName(root, "Button_158"):setVisible(false)
	state_machine.excute("fame_hall_sort_by_fighting", 0, "fame_hall_sort_by_fighting.")
	self.panel = {
		ccui.Helper:seekWidgetByName(root, "Panel_qipao_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_qipao_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_qipao_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_qipao_6"),
		ccui.Helper:seekWidgetByName(root, "Panel_qipao_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_qipao_5"),
	}
end


function FameHall:onExit()
	state_machine.remove("fame_hall_sort_by_fighting")
	state_machine.remove("fame_hall_sort_by_level")
	state_machine.remove("fame_hall_ranking_list")
	state_machine.remove("fame_hall_research")
	state_machine.remove("fame_hall_update")
	state_machine.remove("famous_general_close")
end