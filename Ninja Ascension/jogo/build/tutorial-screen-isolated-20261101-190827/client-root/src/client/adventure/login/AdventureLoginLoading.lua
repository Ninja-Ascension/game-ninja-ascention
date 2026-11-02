 AdventureLoginLoading= class("AdventureLoginLoadingClass", Window)
 
function AdventureLoginLoading:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.currentType = 0
	self.totalNum = 10
	self.isBeginLoad = false
	self.isLoadBookFunction = false
	self.isLoadBookScene = false
	self.isLoadMineScene = false
	self.loadingBar = nil

	local function init_fight_loading_terminal()
	-- 	local fight_loading_update_draw_terminal = {
	-- 		_name = "fight_loading_update_draw", 
	-- 		_init = function (terminal)
	-- 		end,
	-- 		_inited = false,
	-- 		_instance = self,
	-- 		_state = 0,
	-- 		_invoke = function(terminal, instance, params)
	-- 			return true
	-- 		end,
	-- 		_terminal = nil,
	-- 		_terminals = nil
	-- 	}

		
        state_machine.init()
    end

	init_fight_loading_terminal()
end

function AdventureLoginLoading:init( nType )
	self.currentType = nType
	self:onInit()
	return self
end

function AdventureLoginLoading:onInit()
    local csbBattleLoadingCell = csb.createNode("login/login_denglu.csb")
	local root = csbBattleLoadingCell:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBattleLoadingCell)
	self.loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	self.Text_loading_02 = ccui.Helper:seekWidgetByName(root, "Text_10")
	self.Text_loading_02:setString("10/100")
	local action = csb.createTimeline("login/login_denglu.csb")
	
    table.insert(self.actions, action)
	csbBattleLoadingCell:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "windows_close_over" then
        	fwin:close(self)
        	app.load("client.home.Menu")
        	fwin:open(Menu:new():init(true), fwin._taskbar)
			state_machine.excute("menu_manager", 0, 
			{
				_datas = {
				terminal_name = "menu_manager", 	
				next_terminal_name = "menu_show_home_page", 
				current_button_name = "Button_daditu",
				but_image = "Image_daditu", 		
				terminal_state = 0, 
				isPressedActionEnabled = true
			}
		})
   	    end
    end)
end

function AdventureLoginLoading:onUpdate( dt )
	if self.isBeginLoad == false then
		return
	end
	
	if self.totalNum >= 100 then
		self.isBeginLoad = false
		self:loadingSuccess()
		return
	elseif self.totalNum >= 20 and self.totalNum <= 30 and self.isLoadBookFunction == false then
		self.isLoadBookFunction = true
		app.load("client.loader.formula")
    	local typed_ship_mould_array = get_typed_base_ship_moulds()
	elseif self.totalNum >= 30 and self.totalNum <= 40 and self.isLoadMineScene == false then
		self.isLoadMineScene = true
		app.load("client.adventure.campaign.mine.AdventureMineManager")
		state_machine.excute("adventure_mine_manager_open", 0, true)
		 
	elseif self.totalNum >= 45 and self.totalNum <= 55 and self.isLoadBookScene == false then
		self.isLoadBookScene = true
		app.load("client.adventure.mercenary.handbook.AdventureMercenaryHeroHandbook")
		state_machine.excute("adventure_mercenary_hero_handbook_open", 0, false)

	end
	self.totalNum = self.totalNum + 3
	self.loadingBar:setPercent(self.totalNum)
	self.Text_loading_02:setString(self.totalNum.."/100")
end

function AdventureLoginLoading:loadingSuccess( ... )
	
	self:unregisterOnNoteUpdate(self)

	local action = self.actions[1]
	action:play("windows", false)

end

function AdventureLoginLoading:onEnterTransitionFinish()
	self:registerOnNoteUpdate(self)
	self.isBeginLoad = true
end

function AdventureLoginLoading:onExit()
end