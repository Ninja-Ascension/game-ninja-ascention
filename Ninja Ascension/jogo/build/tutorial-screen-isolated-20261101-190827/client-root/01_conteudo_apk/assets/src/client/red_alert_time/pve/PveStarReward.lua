--------------------------------------------------------------------------------------------------------------
--  说明：宝箱界面
--------------------------------------------------------------------------------------------------------------
PveStarReward = class("PveStarRewardClass", Window)

--打开界面
local pve_star_reward_open_terminal = {
	_name = "pve_star_reward_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PveStarRewardClass") == nil then
    		fwin:open(PveStarReward:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_star_reward_close_terminal = {
	_name = "pve_star_reward_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveStarRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_star_reward_open_terminal)
state_machine.add(pve_star_reward_close_terminal)
state_machine.init()

function PveStarReward:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self._index = 0
    -- 场景id
    self._scene_id = 0

    app.load("client.red_alert_time.cells.props.props_use_cell")
    local function init_pve_star_reward_terminal()
        local pve_star_reward_show_terminal = {
            _name = "pve_star_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_star_reward_hide_terminal = {
            _name = "pve_star_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_star_reward_receive_terminal = {
            _name = "pve_star_reward_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseRewardCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
						state_machine.excute("pve_chapter_update_draw",0,"")
						state_machine.excute("pve_map_update_draw",0,"")
                        state_machine.excute("pve_star_reward_close",0,"")
                        checkRewardObtainDraw()
                    end
                end
                protocol_command.draw_scene_rewad.param_list = ""..instance._scene_id .."\r\n" .. instance._index-1
                NetworkManager:register(protocol_command.draw_scene_rewad.code, nil, nil, nil, instance, responseRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local pve_star_reward_update_draw_terminal = {
            _name = "pve_star_reward_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_star_reward_show_terminal)
        state_machine.add(pve_star_reward_hide_terminal)
        state_machine.add(pve_star_reward_receive_terminal)
        state_machine.add(pve_star_reward_update_draw_terminal)
        state_machine.init()
    end
    
    init_pve_star_reward_terminal()
end

function PveStarReward:updateDraw()
    local root = self.roots[1]
    
    local Panel_reaward_icon = ccui.Helper:seekWidgetByName(root, "Panel_reaward_icon") -- icon
    local Text_reward_name = ccui.Helper:seekWidgetByName(root, "Text_reward_name")     -- 道具名
    Panel_reaward_icon:removeAllChildren(true)
    Text_reward_name:setString("")
    local star_reward_id = dms.string(dms["pve_scene"], self._scene_id, pve_scene.star_reward_id)
    local star_reward_id = zstring.split(star_reward_id, ",")
    local reward_items = dms.string(dms["scene_reward"], star_reward_id[self._index], scene_reward.reward_items)
    local reward_items = zstring.split(reward_items, ",")

    local prop_name = dms.string(dms["prop_mould"], reward_items[1], prop_mould.prop_name)
    Text_reward_name:setString(prop_name)
    local cell = state_machine.excute("props_icon_create_cell",0,{5,1,reward_items[1],1,reward_items[3]})
    Panel_reaward_icon:addChild(cell) 
    if self._index == 3 then
        ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
    end
    -- 需求
    local Text_reward_star_prompt = ccui.Helper:seekWidgetByName(root, "Text_reward_star_prompt")
    local reward_need_star = dms.string(dms["pve_scene"], self._scene_id, pve_scene.reward_need_star)
    local reward_need_star = zstring.split(reward_need_star, ",")
    Text_reward_star_prompt:setString(string.format(red_alert_time_str[20], reward_need_star[self._index]))

    -- 领取按钮
    local Button_reaward_receive = ccui.Helper:seekWidgetByName(root, "Button_reaward_receive")
    Button_reaward_receive:setVisible(false)
    local current_star = tonumber(_ED.get_star_count[self._scene_id])
    local need_star = tonumber(reward_need_star[self._index])
    local reward_state = tonumber(_ED.star_reward_state[self._scene_id])
	local openBox = {
		{1,3,5,7},
		{2,3,6,7},
		{4,5,6,7},
	}
    if current_star >= need_star then
        Button_reaward_receive:setVisible(true)
		for j=1, 4 do
			if openBox[self._index][j] == tonumber(reward_state) then
				Button_reaward_receive:setVisible(false)
			end
		end	
    end
end

--初始化
function PveStarReward:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_star_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_star_reward_close"), nil, 
    {
        terminal_name = "pve_star_reward_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "pve_star_reward_close", 
        terminal_state = 0, 
    }, nil, 3)
    
    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reaward_receive"), nil, 
    {
        terminal_name = "pve_star_reward_receive",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:updateDraw()
end

function PveStarReward:onEnterTransitionFinish()

end

function PveStarReward:init(params)
    self._index = params[1]
    self._scene_id = params[2]
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function PveStarReward:onExit()
    state_machine.remove("pve_star_reward_show")
    state_machine.remove("pve_star_reward_hide")
    state_machine.remove("pve_star_reward_receive")
    state_machine.remove("pve_star_reward_update_draw")
end