CrossServerBattelShowBestFormation = class("CrossServerBattelShowBestFormationClass", Window)

local cross_server_battel_show_best_show_best_formation_open_terminal = {
	_name = "cross_server_battel_show_best_formation_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local userId = params.userId
		local serverId = params.serverId
		if not userId or not serverId then
			return
		end
		local function responseCrossServerBattelInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
               	local window = fwin:find("CrossServerBattelShowBestFormationClass")
				if window ~= nil and window:isVisible() == true then
					return true
				end
				fwin:open(CrossServerBattelShowBestFormation:new():init(params), fwin._ui)
            end
        end
        protocol_command.cross_mine_get_rank_formation.param_list = userId .. "\r\n" .. serverId
        NetworkManager:register(protocol_command.cross_mine_get_rank_formation.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local cross_server_battel_show_best_formation_close_terminal = {
	_name = "cross_server_battel_show_best_formation_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossServerBattelShowBestFormationClass"))
		fwin:close(fwin:find("CrossServerBattelShopTopClass"))
		state_machine.unlock("cross_server_battel_show_best_formation_open")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_server_battel_show_best_show_best_formation_open_terminal)
state_machine.add(cross_server_battel_show_best_formation_close_terminal)
state_machine.init()

function CrossServerBattelShowBestFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.page = 0

	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_formation_icon")

    local function init_cross_server_battel_show_best_formation_terminal()
    	local cross_server_battel_show_best_formation_return_terminal = {
            _name = "cross_server_battel_show_best_formation_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("cross_server_battel_show_best_formation_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_show_best_formation_choose_page_terminal = {
            _name = "cross_server_battel_show_best_formation_choose_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local page = params._datas.page
				instance:updateDraw(page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(cross_server_battel_show_best_formation_return_terminal)
		state_machine.add(cross_server_battel_show_best_formation_choose_page_terminal)
        state_machine.init()
    end
	
    init_cross_server_battel_show_best_formation_terminal()
end


function CrossServerBattelShowBestFormation:changeButtonState( ... )
	local root = self.roots[1]
	for i=1,2 do
		local Image_yss_0 = ccui.Helper:seekWidgetByName(root, "Image_yss_"..i.."_1")
		local Image_yss_1 = ccui.Helper:seekWidgetByName(root, "Image_yss_"..i.."_2")
		local Button_ghz_yss = ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_"..i)
		if self.page == i then
			Image_yss_0:setVisible(false)
			Image_yss_1:setVisible(true)
			Button_ghz_yss:setTouchEnabled(false)
			Button_ghz_yss:setHighlighted(true)
		else
			Image_yss_0:setVisible(true)
			Image_yss_1:setVisible(false)
			Button_ghz_yss:setTouchEnabled(true)
			Button_ghz_yss:setHighlighted(false)
		end
	end
end

function CrossServerBattelShowBestFormation:updateDraw(page)
	local root = self.roots[1]
	if root == nil then
		return
	end
	if self.page == page then
		return
	end
	self.page = page
	self:changeButtonState()
	for i = 1, 18 do
		local panel = ccui.Helper:seekWidgetByName(root,"Panel_ghz_yss_icon_d_" .. i)
		panel:removeAllChildren(true)
	end

    local enemy_info = page == 1 and _ED.cross_server_battel_over_formation_info.attack or _ED.cross_server_battel_over_formation_info.guard
	for i = 1 ,table.nums(enemy_info) do
		local all_fight = 0
		local all_speed= 0
		for k = 1,table.nums(enemy_info[i]) do
			local panel = ccui.Helper:seekWidgetByName(root,"Panel_ghz_yss_icon_d_" .. k + (i-1)*6)
			if panel then
				local datas = nil
				if zstring.tonumber(enemy_info[i][k]) == -1 then
				else
					datas = self:initEnemyData(enemy_info[i][k])
					all_fight = all_fight + tonumber(datas.hero_fight)
					all_speed = all_speed + tonumber(datas.speed)
				end
		        local cell = state_machine.excute("cross_server_battel_formation_icon_create", 0, {datas, true, i})
		        panel:addChild(cell)
		        cell._scale = panel:getScale()
			end
		end
		local Text_cross_pk_fight_em_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_yss_dw_f_" .. i)
		local Text_cross_pk_speed_em_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_yss_dw_s_" .. i)
		Text_cross_pk_fight_em_n:setString(all_fight)
		Text_cross_pk_speed_em_n:setString(all_speed)
	end
end

function CrossServerBattelShowBestFormation:initEnemyData(info)
	if zstring.tonumber(info) == -1 then
		return
	end
	local ship_info = {}
	local infos = zstring.split(info, ":")
	ship_info.ship_template_id = infos[1]
	ship_info.ship_grade = infos[2]
	ship_info.evolution_status = infos[3]
	ship_info.StarRating = infos[4]
	ship_info.Order = infos[5]
	ship_info.hero_fight = infos[6]
	ship_info.speed = infos[8]
	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		ship_info.speed = infos[7]
	end
	ship_info.skin_id = infos[11]
	return ship_info
end

function CrossServerBattelShowBestFormation:getUserShips( ... )
	local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
	local function sortFunction(a, b)
		return tonumber(a.hero_fight) > tonumber(b.hero_fight)
	end
	table.sort(result, sortFunction)
	return result
end

function CrossServerBattelShowBestFormation:onInit()
	local csbUnion = csb.createNode("campaign/cross_service/cross_service_formation_infor.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wzzz_back"), nil, 
    {
        terminal_name = "cross_server_battel_show_best_formation_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	for i=1,2 do
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_"..i), nil, 
	    {
	        terminal_name = "cross_server_battel_show_best_formation_choose_page", 
	        terminal_state = 0,
	        page = i,
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)
	end

	-- app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop") 					--顶部用户信息
	-- local userinfo = CrossServerBattelShopTop:new()
 --    userinfo._rootWindows = self
 --    local info = fwin:open(userinfo,fwin._windows)

	self:updateDraw(1)
	
    state_machine.unlock("union_fight_formation_open")
end

function CrossServerBattelShowBestFormation:onEnterTransitionFinish()
end

function CrossServerBattelShowBestFormation:init(params)
	self.user_formation = params
	self:onInit()
	return self
end

function CrossServerBattelShowBestFormation:onExit()
	self.roots[1]:stopAllActions()
	state_machine.remove("cross_server_battel_show_best_formation_return")
	state_machine.remove("cross_server_battel_show_best_formation_choose_page")
end
