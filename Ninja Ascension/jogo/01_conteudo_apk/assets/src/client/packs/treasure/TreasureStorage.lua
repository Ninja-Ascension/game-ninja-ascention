-- ----------------------------------------------------------------------------------------------------
-- 说明：宝物界面
-------------------------------------------------------------------------------------------------------

TreasureStorage = class("TreasureStorageClass", Window)
    
function TreasureStorage:ctor()
    self.super:ctor()
	self.group = {self}
	self.roots = {}
	
	app.load("client.home.Home")
	app.load("client.player.UserInformation")
	app.load("client.player.UserInformationHeroStorage")
	app.load("client.packs.treasure.TreasuresListView")

    -- Initialize treasure_storage page state machine.
    local function init_treasure_storage_terminal()
		--返回主界面
		local treasure_storage_return_home_page_terminal = {
            _name = "treasure_storage_return_home_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
            		self:playCloseAction()
            		if fwin:find("TreasuresListViewClass") then
            			fwin:find("TreasuresListViewClass"):playCloseAction()
            		end
	            else
					-- fwin:close(instance)
					-- state_machine.excute("menu_manager", 0, 
					-- {
					-- 	_datas = 
					-- 	{
					-- 		terminal_name = "menu_manager", 
					-- 		next_terminal_name = "menu_back_home_page", 
					-- 		but_image = "Image_home", 
					-- 		terminal_state = 0, 
					-- 		isPressedActionEnabled = true
					-- 	}
					-- })
					fwin:cleanView(fwin._view) 
					fwin:close(instance)
					state_machine.excute("menu_back_home_page", 0, "") 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --返回宝物仓库页面
		local treasure_storage_back_treasure_storages_terminal = {
            _name = "treasure_storage_back_treasure_storages",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--显示自己
				instance:onShow()
				--更新宝物数量
				instance.group[2]:onUpdateTreasureCount()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --隐藏宝物仓库页面
		local treasure_storage_hide_treasure_storages_terminal = {
            _name = "treasure_storage_hide_treasure_storages",
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
	
		state_machine.add(treasure_storage_return_home_page_terminal)
		state_machine.add(treasure_storage_treasure_storages_sell_terminal)
		state_machine.add(treasure_storage_back_treasure_storages_terminal)
		state_machine.add(treasure_storage_hide_treasure_storages_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_storage_terminal()
end

function TreasureStorage:onEnterTransitionFinish()
	local userinfo = UserInformationHeroStorage:new()
	local info = fwin:open(userinfo,fwin._view)
	-- table.insert(self.group, info)
	
    local csbtreasure_storage = csb.createNode("packs/TreasureStorage/treasure.csb")
	local root = csbtreasure_storage:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbtreasure_storage)

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local action = csb.createTimeline("packs/TreasureStorage/treasure.csb")
	    csbtreasure_storage:runAction(action)
	    self.m_action = action
	    self:playIntoAction()
	end
	
	--返回主界面按钮事件添加
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		func_string = [[state_machine.excute("treasure_storage_return_home_page", 0, "click treasure_storage_return_home_page.")]],
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--创建宝物的ListView界面
	local treasuresListView = fwin:open(TreasuresListView:new(), fwin._background)
	table.insert(self.group, treasuresListView)
end

function TreasureStorage:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_close", false)
	end
end

function TreasureStorage:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_open", false)
		self.m_action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	
	        elseif str == "window_close_over" then
	            self:actionEndClose()
	        end
	    end)
	end
end

function TreasureStorage:actionEndClose( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		fwin:close(fwin:find("UserInformationHeroStorageClass"))
		fwin:close(fwin:find("TreasuresListViewClass"))
		fwin:close(self)
	end
end

function TreasureStorage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
end

function TreasureStorage:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
end

function TreasureStorage:onExit()
	state_machine.remove("treasure_storage_return_home_page")
	state_machine.remove("treasure_storage_back_treasure_storages")
	state_machine.remove("treasure_storage_hide_treasure_storages")
end
