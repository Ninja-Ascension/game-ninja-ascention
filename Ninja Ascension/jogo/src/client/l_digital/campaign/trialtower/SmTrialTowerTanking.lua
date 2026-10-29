-----------------------------
-- 试炼排行榜界面
-----------------------------
SmTrialTowerTanking = class("SmTrialTowerTankingClass", Window)

--打开界面
local sm_trial_tower_tanking_open_terminal = {
	_name = "sm_trial_tower_tanking_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerTankingClass") == nil then
			-- fwin:open(SmTrialTowerTanking:new():init(params), fwin._ui)
			local function responseCallback(response)
				state_machine.unlock("sm_trial_tower_tanking_open")
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(SmTrialTowerTanking:new():init(params), fwin._ui)
                end
            end
			state_machine.lock("sm_trial_tower_tanking_open")
            protocol_command.order_get_info.param_list = "5".."\r\n"..(1).."\r\n"..(50)
            NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, nil, responseCallback, false, nil)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_tanking_close_terminal = {
	_name = "sm_trial_tower_tanking_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerTankingClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_tanking_open_terminal)
state_machine.add(sm_trial_tower_tanking_close_terminal)
state_machine.init()

function SmTrialTowerTanking:ctor()
	self.super:ctor()
	self.roots = {}

    self.list_view = nil
    self.list_view_posY = 0

	-- load lua file
	app.load("client.l_digital.cells.campaign.sm_trial_tower_ranking_list_cell")

    local function init_sm_trial_tower_tanking_terminal()
        --
        local sm_ranking_union_view_the_first_place_terminal = {
            _name = "sm_ranking_union_view_the_first_place",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_tanking_terminal()
end

function SmTrialTowerTanking:updateDraw()
	local root = self.roots[1]

	local Text_sl_ph_2 = ccui.Helper:seekWidgetByName(root,"Text_sl_ph_2")
	if _ED.three_kingdoms_score_rank.my_info.user_rank > 0 then
		Text_sl_ph_2:setString("" .. _ED.three_kingdoms_score_rank.my_info.user_rank)
	else
		Text_sl_ph_2:setString(_string_piece_info[34])
	end

	local ListView_sl_ph = ccui.Helper:seekWidgetByName(root,"ListView_sl_ph")
	for i, v in pairs(_ED.three_kingdoms_score_rank.other_user) do
		local cell = state_machine.excute("sm_trial_tower_ranking_list_cell", 0, {i, v})
		ListView_sl_ph:addChild(cell)
	end
    ListView_sl_ph:requestRefreshView()
    self.list_view = ListView_sl_ph
    self.list_view_posY = ListView_sl_ph:getInnerContainer():getPositionY()
end

function SmTrialTowerTanking:init(params)
	self:onInit()
    return self
end

function SmTrialTowerTanking:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_ranking.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_trial_tower_tanking_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function SmTrialTowerTanking:onUpdate( dt )
	if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmTrialTowerTanking:onEnterTransitionFinish()
    
end


function SmTrialTowerTanking:onExit()
    state_machine.remove("sm_trial_tower_tanking_change_page")
	state_machine.remove("sm_trial_tower_tanking_open_rank")
end

