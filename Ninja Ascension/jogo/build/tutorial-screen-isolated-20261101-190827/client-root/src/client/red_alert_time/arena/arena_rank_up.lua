-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸排名升级
-------------------------------------------------------------------------------------------------------
ArenaRankUp = class("ArenaRankUpClass", Window)

local arena_rank_up_open_terminal = {
    _name = "arena_rank_up_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRankUpClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRankUp:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_rank_up_close_terminal = {
    _name = "arena_rank_up_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRankUpClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRankUpClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_rank_up_open_terminal)
state_machine.add(arena_rank_up_close_terminal)
state_machine.init()
    
function ArenaRankUp:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self._params = nil
	self.isover = false

    self._number = 1
    self._now_show_numbers = {}
	
	local function init_arena_rank_up_terminal()
		local arena_rank_up_over_close_terminal = {
			_name = "arena_rank_up_over_close",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance.isover ~= false then
					fwin:close(fwin:find("ArenaRankUpClass"))
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(arena_rank_up_over_close_terminal)
		state_machine.init()
	end
	
	init_arena_rank_up_terminal()
	
end

function ArenaRankUp:init(params)
	self._params = params
    self:onInit()
    return self
end

function ArenaRankUp:onInit()
    local csbArenaRankUp = csb.createNode(config_csb.arena.arena_rank_change_settlement)
    local root = csbArenaRankUp:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRankUp)
	local action = csb.createTimeline(config_csb.arena.arena_rank_change_settlement)
    table.insert(self.actions, action)
    csbArenaRankUp:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "window_open_over" then
            -- fwin:close(self)
			self.isover = true 
            state_machine.excute("arena_rank_up_over_close", 0, "")
        end
        
    end)
	
	-- Animations_PlayOpenMainUI({self}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    local function playAction()
        if self._number <= 10 then
            self._BitmapFontLabel_rank_up:setString(self._now_show_numbers[11 - self._number])
            self._BitmapFontLabel_rank_down:setString(self._now_show_numbers[self._number])
            self._number = self._number + 1
            root:runAction(cc.Sequence:create(
                    cc.DelayTime:create(0.05),
                    cc.CallFunc:create(playAction))
                    )
        end
    end

    local now_rank = tonumber(_ED.arena_info.rank)
    local addNumbers = tonumber(_ED.arena_info.rank) - tonumber(_ED.arena_last_rank)
    self._number = 1
    self._now_show_numbers = {}
    for i = 1 , 9 do
        local one_add_number = math.floor(addNumbers / 4 *(i-1))
        table.insert(self._now_show_numbers,now_rank - one_add_number)
    end
    table.insert(self._now_show_numbers, tonumber(_ED.arena_last_rank))
	
	-- 对方
	local BitmapFontLabel_rank_down = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_rank_down")
	BitmapFontLabel_rank_down:setString(_ED.arena_last_rank)
    self._BitmapFontLabel_rank_down = BitmapFontLabel_rank_down

	-- local actions = CCLabelChange:create(BitmapFontLabel_rank_down, 20, 1, 1000000)
	-- actions:playAction()
	
	local Panel_player_head_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_head_2")
	Panel_player_head_2:removeBackGroundImage()
	if self._params.user_head_id ~= nil or self._params.user_head_id ~= "" then
        local head_data = zstring.split(self._params.user_head_id, ",")
        local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
        Panel_player_head_2:setBackGroundImage(string.format(config_res.images.ui.props.props, head_info[1]))

	end
	local Text_player_name_2 = ccui.Helper:seekWidgetByName(root, "Text_player_name_2")
	Text_player_name_2:setString(self._params.user_name)
	
	--我
	local BitmapFontLabel_rank_up = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_rank_up")
	BitmapFontLabel_rank_up:setString(_ED.arena_info.rank)
    self._BitmapFontLabel_rank_up = BitmapFontLabel_rank_up

	local Panel_player_head_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_head_1")
	Panel_player_head_1:removeBackGroundImage()
    local head_data = zstring.split(_ED.user_info.user_head_id, ",")
    local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
    Panel_player_head_1:setBackGroundImage(string.format(config_res.images.ui.props.props, head_info[1]))
        
	local Text_player_name_1 = ccui.Helper:seekWidgetByName(root, "Text_player_name_1") 
	Text_player_name_1:setString(_ED.user_info.user_name)
	
    playAction()
	
	--挑战
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "arena_rank_up_over_close", 
        terminal_state = 0, 
    }, nil, 1)
end

function ArenaRankUp:onExit()
	state_machine.remove("arena_rank_up_over_close")
end