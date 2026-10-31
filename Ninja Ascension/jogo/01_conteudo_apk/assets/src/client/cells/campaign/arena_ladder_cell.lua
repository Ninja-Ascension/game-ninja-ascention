-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场天梯区域及对手显示区 每六个角色为一个区域
-- 创建时间：2015-03-30
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaLadderCell = class("ArenaLadderCellClass", Window)
    
function ArenaLadderCell:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.width = 0
	self.height = 0
	self.roleList = nil
	
	self.cacheSeatList = {}		--缓存seat数组
	
	app.load("client.cells.campaign.arena_ladder_seat_cell")
	
    -- Initialize ArenaLadderCell page state machine.
    local function init_arena_ladder_panel_terminal()
	
		-- local arena_back_activity_terminal = {
            -- _name = "arena_back_activity",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
                
				-- fwin:open(Campaign:new(), fwin._view)
				-- fwin:close(instance)

                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(arena_back_activity_terminal)
        -- state_machine.add(arena_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_panel_terminal()
end

function ArenaLadderCell:initDraw()

	local root = self.roots[1]
	
	local panelName = {
		"Panel_3",
		"Panel_4",
		"Panel_5",
		"Panel_6",
		"Panel_7",
		"Panel_8"
	}
	
	-- local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	--> print("sssssssssssssssssssssssssssssssssssssss", root)

	for i, v in pairs(self.roleList) do
		local ALSC = ArenaLadderSeatCell:createCell()
		local isleft = true
		if i %2 == 0 then
			isleft = false
		end
		ALSC:init(v,isleft)
		local tmpPanel = ccui.Helper:seekWidgetByName(root, panelName[i])
		tmpPanel:addChild(ALSC)
		table.insert(self.cacheSeatList, ALSC)
	end
	
end


function ArenaLadderCell:onEnterTransitionFinish()
	
    local csbArenaLadder = csb.createNode("campaign/ArenaStorage/ArenaStorage_list.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	
	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	tmpPanel:setSwallowTouches(false)
	-- self:setContentSize(tmpPanel:getContentSize())
	--> print("sssssssssssssssssssssssssssssssssssssss", tmpPanel)
	
	-- self:setContentSize(csbArenaLadder:getContentSize())
	self.width = tmpPanel:getContentSize().width
	self.height = tmpPanel:getContentSize().height
	--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", self.height)
	
	-- local back_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), 	nil, 
	-- {
		-- terminal_name = "arena_back_activity", 	
		-- next_terminal_name = "arena_back_activity", 	
		-- current_button_name = "Button_2",		
		-- but_image = "ArenaLadderCell",	
		-- terminal_state = 0, 
		-- isPressedActionEnabled = true
	-- }, 
	-- nil, 0)
	
	self:initDraw()
end

function ArenaLadderCell:createCell()
	local cell = ArenaLadderCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ArenaLadderCell:init(aRoleList)
	self.roleList = aRoleList
end


function ArenaLadderCell:onExit()
	-- state_machine.remove("arena_back_activity")
end
