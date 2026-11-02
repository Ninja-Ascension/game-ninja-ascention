-- ----------------------------------------------------------------------------------------------------
-- 说明：推荐阵容
-------------------------------------------------------------------------------------------------------

RecommendFormation = class("RecommendFormationClass", Window)
   
local recommend_formation_window_open_terminal = {
    _name = "recommend_formation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RecommendFormationClass") then
        	local formationWindow = RecommendFormation:new()
			formationWindow:init(params)
			fwin:open(formationWindow, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(recommend_formation_window_open_terminal)
state_machine.init()

function RecommendFormation:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.formation.RecommendFormationList")

	self.group = {
        _onePage = nil,
        _twoPage = nil,
        _therePage =nil,
        _fourPage =nil,
    }
    -- Initialize Home page state machine.
    local function init_recommend_formation_terminal()
		local recommend_formation_manager_terminal = {
            _name = "recommend_formation_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
					terminal.select_button:setTouchEnabled(true)
				end
				if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				end
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(true)
					terminal.select_button:setTouchEnabled(false)
				end
				if params._datas.next_terminal_name  ~= nil then
					for i, v in pairs(instance.group) do
						if v ~= nil then
							v:setVisible(false)
						end
					end
					state_machine.excute(params._datas.next_terminal_name, 0, params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新推荐列表
		local recommend_formation_select_update_terminal = {
            _name = "recommend_formation_select_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawPage(params._datas.select_index)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(recommend_formation_manager_terminal)
		state_machine.add(recommend_formation_select_update_terminal)
        state_machine.init()
		
    end
    
    init_recommend_formation_terminal()
end

function RecommendFormation:onUpdateDraw()
	
end

--设置page的视图
function RecommendFormation:setPageWindow(index,cell)
	if index == 1 then 
		self.group._onePage = cell
	elseif index == 2 then 
		self.group._twoPage = cell
	elseif index == 3 then 
		self.group._therePage = cell
	elseif  index == 4 then 
		self.group._fourPage = cell
	end
end

--返回page的视图
function RecommendFormation:getPageWindow(index)
	if index == 1 then 
		return self.group._onePage
	elseif index == 2 then 
		return self.group._twoPage
	elseif index == 3 then 
		return self.group._therePage
	elseif  index == 4 then 
		return self.group._fourPage
	end
	return nil
end

function RecommendFormation:onUpdateDrawPage(index)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local Panel_15 = ccui.Helper:seekWidgetByName(root, "Panel_15")
	for i=1,4 do
		local cell = self:getPageWindow(i)
		if index == i then
			if cell == nil then 
				local window = RecommendFormationList:new()
				window:init(index)
				Panel_15:addChild(window)
				self:setPageWindow(i,window)
				window:setVisible(true)
			else
				cell:setVisible(true)
			end
		else
			if cell ~= nil then 
				cell:setVisible(false)
			end
		end
	end
end

function RecommendFormation:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("formation/Formation_tuijian_0.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("RecommendFormationClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)

	for i=1,4 do
		local button_name = "Button_" .. i
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], button_name), nil, 
		{
			terminal_name = "recommend_formation_manager", 	
			next_terminal_name = "recommend_formation_select_update", 			
			current_button_name = button_name, 	
			but_image = "", 	
			select_index = i,
			terminal_state = 0, 
			isPressedActionEnabled = tempIsPressedActionEnabled
		}, 
		nil, 0)	
	end
	state_machine.excute("recommend_formation_manager", 0, 
	{
		_datas = {
			terminal_name = "recommend_formation_manager", 	
			next_terminal_name = "recommend_formation_select_update", 
			current_button_name = "Button_1",
			but_image = "", 		
			terminal_state = 0,
			select_index = 1,
			isPressedActionEnabled = false
		}
	})
end


function RecommendFormation:onExit()
end

function RecommendFormation:init()
end
