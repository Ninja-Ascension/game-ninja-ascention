-----------------------------
--战地争霸的积分奖励的cell
-----------------------------
ArenaIntegralCell = class("ArenaIntegralCellClass", Window)
ArenaIntegralCell.__size = nil

local arena_integral_cell_terminal = {
    _name = "arena_integral_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaIntegralCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_integral_cell_terminal)
state_machine.init()

function ArenaIntegralCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
	
	-- app.load("client.red_alert_time.mail.MailPresentationInfo")
	
 	local function init_arena_integral_cell_terminal()
	
		local arena_integral_cell_response_terminal = {
            _name = "arena_integral_cell_response",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells

				local function responseCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:onUpdateDraw()
						end	
						checkRewardObtainDraw()
                        state_machine.excute("arena_shop_tab_update_honour", 0, "")
                        state_machine.excute("arena_reward_integral_tab_update_draw", 0, "")
					end
				end
				protocol_command.draw_arena_score_reward.param_list = cell._index-1
				NetworkManager:register(protocol_command.draw_arena_score_reward.code, nil, nil, nil, cell, responseCallBack, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(arena_integral_cell_response_terminal)
        state_machine.init()
    end
	init_arena_integral_cell_terminal()        	
end

function ArenaIntegralCell:onUpdateDraw()
	local root = self.roots[1]
	--不可领取和已领取
	local Text_integral_not = ccui.Helper:seekWidgetByName(root, "Text_integral_not")
	--进度条
	local LoadingBar_integral_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_integral_bar")
	local state_group = zstring.split(_ED.arena_info.state_group, ",")
	if tonumber(_ED.arena_info.integral) >= self._index*2 then
		LoadingBar_integral_bar:setPercent(100)
		if tonumber(state_group[self._index]) == 0 then--可以领取
			Text_integral_not:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_integral_receive"):setVisible(true)
		else--已经领取
			Text_integral_not:setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_integral_receive"):setVisible(false)
			Text_integral_not:setString(arena_tip_text[22])
		end
	else
		if self._index*2 - tonumber(_ED.arena_info.integral) >= 2 then
			LoadingBar_integral_bar:setPercent(0)
		elseif  self._index*2 - tonumber(_ED.arena_info.integral) == 1 then
			LoadingBar_integral_bar:setPercent(50)
		end
		Text_integral_not:setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_integral_receive"):setVisible(false)
		Text_integral_not:setString(arena_tip_text[21])
	end
	--列表
	local ListView_integral_reward = ccui.Helper:seekWidgetByName(root, "ListView_integral_reward")
	ListView_integral_reward:removeAllItems()
	local reward_data = zstring.split(dms.string(dms["arena_score"], self._index, arena_score.content), "|")
	for i=1, #reward_data do
		local info = zstring.split(reward_data[i], ",")
		if tonumber(info[1]) == -1 then
			info[1] = resource_prop_id[tonumber(info[2])]
			info[2] = 1
		end
		local prop_type = tonumber(info[2])
		local show_type = 6
		if tonumber(info[2]) == 13 then --坦克
			prop_type = 3
		elseif tonumber(info[2]) == 6 then --道具	
			prop_type = 1
		elseif tonumber(info[2]) == 7 then --配件	
			prop_type = 7
		else
			prop_type = 1
		end
		local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 1, tonumber(info[1]), prop_type, tonumber(info[3])})
		ListView_integral_reward:addChild(cell)
	end
	
	ListView_integral_reward:requestRefreshView()
	ListView_integral_reward:setTouchEnabled(false)
	--进度数
	local Text_integral_ing_n = ccui.Helper:seekWidgetByName(root, "Text_integral_ing_n")
	Text_integral_ing_n:setString(dms.string(dms["arena_score"], self._index, arena_score.score))
end


function ArenaIntegralCell:onEnterTransitionFinish()

end

function ArenaIntegralCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_reward_cell_1, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if ArenaIntegralCell.__size == nil then
		ArenaIntegralCell.__size = root:getContentSize()
	end
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_integral_receive"), nil, 
    {
        terminal_name = "arena_integral_cell_response", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function ArenaIntegralCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_reward_cell_1, root)
end

function ArenaIntegralCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaIntegralCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_reward_cell_1, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaIntegralCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_integral_reward = ccui.Helper:seekWidgetByName(root, "ListView_integral_reward")
    local Text_integral_not = ccui.Helper:seekWidgetByName(root, "Text_integral_not")
    local Text_integral_ing_n = ccui.Helper:seekWidgetByName(root, "Text_integral_ing_n")
    local LoadingBar_integral_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_integral_bar")
    local Button_integral_receiveccui = ccui.Helper:seekWidgetByName(root, "Button_integral_receive")

    if ListView_integral_reward ~= nil then
        ListView_integral_reward:removeAllItems()
        Text_integral_not:setString("")
        Text_integral_ing_n:setString("")
        LoadingBar_integral_bar:setPercent(0)
        Button_integral_receiveccui:setVisible(true)
    end
end

function ArenaIntegralCell:init(params)
	self._index = tonumber(params)
	-- if self._index ~= nil and self._index <= 7 then
        self:onInit()
    -- end
	self:setContentSize(ArenaIntegralCell.__size)
    return self
end

