UnionFightingReviewTime = class("UnionFightingReviewTimeClass", Window)

local union_fighting_review_time_open_terminal = {
	_name = "union_fighting_review_time_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("union_fighting_review_time_close", 0, nil)
		if _ED.union_fight_city_user_info ~= nil 
			and _ED.union_fight_city_user_info.is_death == "1" then
			fwin:open(UnionFightingReviewTime:new():init(), fwin._ui)
            state_machine.excute("national_city_open_union_add_role_death_effect", 0, nil)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_review_time_close_terminal = {
	_name = "union_fighting_review_time_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingReviewTimeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_review_time_open_terminal)
state_machine.add(union_fighting_review_time_close_terminal)
state_machine.init()

function UnionFightingReviewTime:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self._review_type = 0

	app.load("client.utils.ConfirmTip")

	local function init_union_fighting_review_time_terminal()
        local union_fighting_review_time_clean_cd_terminal = {
            _name = "union_fighting_review_time_clean_cd",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local ntype = params._datas._ntype
            	instance._review_type = ntype
            	if ntype == 1 then
            		local cost = 0
        		    local normal_costs = zstring.split(dms.string(dms["union_config"], 38, union_config.param), ",")
				    if tonumber(_ED.union_fight_city_user_info.review_times) + 1 >= table.nums(normal_costs) then
				        cost = normal_costs[table.nums(normal_costs)]
				    else
				    	cost = normal_costs[_ED.union_fight_city_user_info.review_times + 1]
				    end
            		local tip = ConfirmTip:new()
                    local info = string.format(tipStringInfo_union_str[91], ""..cost)
                    tip:init(instance, instance.sureReview, info)
                    fwin:open(tip, fwin._windows)
                else
                	instance:sureReview(0)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_review_time_clean_cd_terminal)
    end
    init_union_fighting_review_time_terminal()
end

function UnionFightingReviewTime:sureReview(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        	if _ED.union_fight_city_user_info.is_death == "0" then
        		_ED.union_fight_city_user_info.review_cd_time = 0
            	state_machine.excute("union_fighting_review_time_close", 0, nil)
                state_machine.excute("national_city_open_union_add_role_review_effect", 0, nil)
            else
            	if response.node ~= nil and response.node.roots ~= nil then
            		response.node:registerOnNoteUpdate(response.node)
            	end
            end
        end
    end
    if sure_number == 0 then
	    protocol_command.union_stronghold_resurrect.param_list = _ED.union.union_info.union_id.."\r\n"..self._review_type
	    NetworkManager:register(protocol_command.union_stronghold_resurrect.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function UnionFightingReviewTime:updateDraw( ... )
	local root = self.roots[1]
end

function UnionFightingReviewTime:onUpdate( dt )
	local root = self.roots[1]
	if root == nil then
		return
	end
	_ED.union_fight_city_user_info.review_cd_time = _ED.union_fight_city_user_info.review_cd_time - dt
	if _ED.union_fight_city_user_info.review_cd_time <= 0 then
		self:unregisterOnNoteUpdate(self)
		_ED.union_fight_city_user_info.review_cd_time = 0
		state_machine.excute("union_fighting_review_time_clean_cd", 0, {_datas = {_ntype = 0}})
	end
	local Text_revive_time = ccui.Helper:seekWidgetByName(root, "Text_revive_time")
	Text_revive_time:setString(self:formatTimeString(_ED.union_fight_city_user_info.review_cd_time))
end

function UnionFightingReviewTime:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function UnionFightingReviewTime:onInit(params)
	local csbNode = csb.createNode(config_csb.big_map.map_legion_revive_time)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_revive_go_on"), nil, 
    {
        terminal_name = "union_fighting_review_time_clean_cd", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        _ntype = 1,
    }, 
    nil, 0)
end

function UnionFightingReviewTime:onEnterTransitionFinish()
end

function UnionFightingReviewTime:init()
    self:onInit()
	return self
end

function UnionFightingReviewTime:onExit()
	state_machine.remove("union_fighting_review_time_clean_cd")
end
