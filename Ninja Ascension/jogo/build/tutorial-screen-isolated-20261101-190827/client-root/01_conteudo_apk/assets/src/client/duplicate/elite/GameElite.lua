-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE主线副本
-- 创建时间
-- 作者：胡文轩
-- 修改记录：GameElite
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

GameElite = class("GameEliteClass", Window)
GameElite.botton_index = 0
GameElite._name = nil
GameElite._index = 0

function GameElite:initData(data1, data2)
	GameElite._name = data1
	GameElite._index = data2
end


function GameElite:ctor()
    self.super:ctor()
	self.roots = {}

	
    local function init_game_elite_terminal()
	
	
		-- 退出当前副本集
		local game_elite_exit_terminal = {
            _name = "game_elite_exit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)
				fwin:open(Duplicate:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local duplicate_pve_list_2_terminal = {
            _name = "duplicate_pve_list_2",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
					app.load("client.duplicate.elite.PveScene")
					fwin:open(PveScene:new(), fwin._background)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		state_machine.add(game_elite_exit_terminal)
		state_machine.add(duplicate_pve_list_2_terminal)
        state_machine.init()
    end
    
    init_game_elite_terminal()
end




function GameElite:onEnterTransitionFinish()
	table.insert(self.roots, root)
    local csbPveBox= csb.createNode("duplicate/pve_duplicate_1.csb")
	self:addChild(csbPveBox)
	local PveBoxRoot 	= csbPveBox:getChildByName("root")
	--DOTO
	

    local csbPveDuplicate = csb.createNode("duplicate/pve_duplicate.csb")
	self:addChild(csbPveDuplicate)
	
	local PveDuplicateRoot 	= csbPveDuplicate:getChildByName("root")
	local Panel_2 		= ccui.Helper:seekWidgetByName(PveDuplicateRoot, "Panel_2")
	local Text1 		= ccui.Helper:seekWidgetByName(PveDuplicateRoot, "Text_1")
    Text1:setString(_string_piece_info[2]..GameElite._index.._string_piece_info[3]..GameElite._name)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(Panel_2, "Button_1"), nil, {func_string = [[state_machine.excute("game_elite_exit", 0, "click game_elite_exit.'")]], 
									isPressedActionEnabled = true}, nil, 2)
	
	state_machine.excute("duplicate_pve_list_2", 0, "click duplicate_pve_list_2.'")
end

function GameElite:onExit()
	state_machine.remove("game_elite_exit")
	state_machine.remove("duplicate_pve_list_2")
end
