-- ----------------------------------------------------------------------------------------------------
-- 说明：公会工会副本
-------------------------------------------------------------------------------------------------------
SmUnionDuplicate = class("SmUnionDuplicateClass", Window)

local sm_union_duplicate_open_terminal = {
    _name = "sm_union_duplicate_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionDuplicateClass")
        if nil == _homeWindow then
            local panel = SmUnionDuplicate:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_duplicate_close_terminal = {
    _name = "sm_union_duplicate_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
        if nil ~= _ED.user_formetion_status_copy then
            _ED.user_formetion_status = _ED.user_formetion_status_copy
            _ED.user_formetion_status_copy = nil
        end
        if nil ~= _ED.formetion_copy then
            _ED.formetion = _ED.formetion_copy
            _ED.formetion_copy = nil
        end
		local _homeWindow = fwin:find("SmUnionDuplicateClass")
        if nil ~= _homeWindow then
            if fwin:find("UnionTigerGateClass") == nil then
                state_machine.excute("Union_open", 0, "")
            end
    		fwin:close(fwin:find("SmUnionDuplicateClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_duplicate_open_terminal)
state_machine.add(sm_union_duplicate_close_terminal)
state_machine.init()
    
function SmUnionDuplicate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ScrollView_pve_map = nil
    self.Button_pve_map_arrow_1 = nil
    self.Button_pve_map_arrow_2 = nil

    app.load("client.l_digital.union.duplicate.SmUnionPveMap")
    app.load("client.l_digital.union.duplicate.SmUnionDuplicateRule")
    app.load("client.l_digital.union.duplicate.SmUnionMembershipProgress")
    app.load("client.l_digital.union.duplicate.SmUnionRewardDistribution")
    app.load("client.cells.ship.hero_icon_list_cell")
    local function init_sm_union_duplicate_terminal()
        -- 显示界面
        local sm_union_duplicate_display_terminal = {
            _name = "sm_union_duplicate_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionDuplicateWindow = fwin:find("SmUnionDuplicateClass")
                if SmUnionDuplicateWindow ~= nil then
                    SmUnionDuplicateWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_duplicate_hide_terminal = {
            _name = "sm_union_duplicate_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionDuplicateWindow = fwin:find("SmUnionDuplicateClass")
                if SmUnionDuplicateWindow ~= nil then
                    SmUnionDuplicateWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一键布阵
        local sm_union_duplicate_oen_key_formation_window_terminal = {
            _name = "sm_union_duplicate_oen_key_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:oneKeyFormationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_duplicate_open_join_formation_window_terminal = {
            _name = "sm_union_duplicate_open_join_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("hero_formation_choice_wear_window_open", 0, {params._datas.cell_index, 1, -1, nil, "sm_union_duplicate_join_formation", params._datas.cell_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_duplicate_join_formation_terminal = {
            _name = "sm_union_duplicate_join_formation",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:joinFormtion(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 阵型变更
        local sm_union_duplicate_join_formation_change_terminal = {
            _name = "sm_union_duplicate_join_formation_change",
            _init = function (terminal)
                app.load("client.formation.FormationChange") 
                app.load("client.home.HomeHero") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local formationChangeWindow = FormationChange:new()
                -- fwin:open(formationChangeWindow, fwin._windows)
                state_machine.excute("formation_change_window_open", 0, {nil, "sm_union_duplicate_join_formation_change_request", nil})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_duplicate_join_formation_change_request_terminal = {
            _name = "sm_union_duplicate_join_formation_change_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_duplicate_join_update_formation_terminal = {
            _name = "sm_union_duplicate_join_update_formation",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(_new_interface_text[72])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_duplicate_join_open_distribution_terminal = {
            _name = "sm_union_duplicate_join_open_distribution",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_union_reward_distribution_open", 0, "")
                    end
                end
                NetworkManager:register(protocol_command.union_copy_get_lucky_reward_info.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_duplicate_move_list_terminal = {
            _name = "sm_union_duplicate_move_list",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_ScrollView = ccui.Helper:seekWidgetByName(instance.roots[1],"ScrollView_pve_map")
                local toward = -1
                if params._datas.ntype == 2 then
                    toward = 1
                end
                local baseWidth = m_ScrollView:getContentSize().width
                local movePos = m_ScrollView:getInnerContainer():getPositionX() + baseWidth/2 * toward
                local maxWidth = m_ScrollView:getInnerContainer():getContentSize().width
                movePos = math.min(0, movePos)
                movePos = math.max(-maxWidth + baseWidth, movePos)
                m_ScrollView:getInnerContainer():setPositionX(movePos)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 控制一键领取按钮的显隐
        local sm_union_duplicate_show_one_click_btn_terminal = {
            _name = "sm_union_duplicate_show_one_click_btn",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:showOneClickBtn()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 一键领取奖励
        local sm_union_duplicate_get_one_click_reward_terminal = {
            _name = "sm_union_duplicate_get_one_click_reward",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(25)
                                getRewardWnd:updateSortState(false)
								fwin:open(getRewardWnd,fwin._ui)

                                state_machine.excute("sm_union_duplicate_show_one_click_btn", 0, nil)
								
	                        end
	                    end
                    end
                    protocol_command.one_key_draw_union_copy_draw_reward.param_list = ""
                	NetworkManager:register(protocol_command.one_key_draw_union_copy_draw_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_duplicate_display_terminal)
        state_machine.add(sm_union_duplicate_hide_terminal)
        state_machine.add(sm_union_duplicate_oen_key_formation_window_terminal)
        state_machine.add(sm_union_duplicate_open_join_formation_window_terminal)
        state_machine.add(sm_union_duplicate_join_formation_terminal)
        state_machine.add(sm_union_duplicate_join_formation_change_terminal)
        state_machine.add(sm_union_duplicate_join_update_formation_terminal)
        state_machine.add(sm_union_duplicate_join_open_distribution_terminal)
        state_machine.add(sm_union_duplicate_join_formation_change_request_terminal)
        state_machine.add(sm_union_duplicate_move_list_terminal)
        state_machine.add(sm_union_duplicate_show_one_click_btn_terminal)
        state_machine.add(sm_union_duplicate_get_one_click_reward_terminal)
        state_machine.init()
    end
    init_sm_union_duplicate_terminal()
end

-- 一键领取奖励按钮
function SmUnionDuplicate:showOneClickBtn()
    if self.Button_oneclick == nil then
        return
    end
    local isShow = false
    local stateInfo = zstring.split(_ED.union.user_union_info.npc_frist_reward_state, "|")
    local npcInfo = _ED.union_pve_info

    for k,v in pairs(stateInfo) do
        local stateInfo = zstring.split(v, ":", tonumber)
        local curState = stateInfo[2]
        local curID =  stateInfo[1]

        for m, npcInfo in pairs(npcInfo) do
            local npcID = tonumber(npcInfo.id)
            if curID == npcID then
                local npcState = tonumber(npcInfo.status)
                -- 0未领取 (首胜) 2未领取（非首胜）
                if (curState == 0 or curState == 2) and npcState ~= 0 then
                    isShow = true
                end
                break
            end
        end
        if isShow == true then
            break
        end
    end

    self.Button_oneclick:setVisible(isShow)
end

function SmUnionDuplicate:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_pve_map")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth
    local Hlindex = 0
    local current_grade = dms.int(dms["copy_config"],3,copy_config.param)
    local current_index = (#_ED.union_pve_info) >= current_grade and current_grade or (#_ED.union_pve_info)

    sWidth = math.max(sWidth, sWidth*math.ceil((current_index+2)/4))
    panel:setContentSize(sWidth, m_ScrollView:getContentSize().width)

    local posX = m_ScrollView:getPositionX() - root:getContentSize().width/2
    local index = 0
    local m_width = 0
    for i=1, math.ceil((current_index+2)/4) do
        local cellmap = SmUnionPveMap:createCell()
        cellmap:init(i)
        panel:addChild(cellmap)
        index = index + 1
        if cellmap ~= nil and cellmap.roots[1] ~= nil then
            m_width = cellmap:getContentSize().width
            cellmap:setPosition(cc.p(m_width*(index-1),tHeight))
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                for i = 1, 4 do
                    ccui.Helper:seekWidgetByName(cellmap.roots[1], "Panel_gh_pve_npc_"..i):setPositionX(ccui.Helper:seekWidgetByName(cellmap.roots[1], "Panel_gh_pve_npc_"..i)._x - posX)
                end

                if i > 1 then
                    for i = 1, 4 do
                        ccui.Helper:seekWidgetByName(cellmap.roots[1], "Panel_gh_pve_npc_"..i):setPositionX(ccui.Helper:seekWidgetByName(cellmap.roots[1], "Panel_gh_pve_npc_"..i)._x - posX - 498)
                    end
                end
            end
        end
    end
    -- local maxNpc = self.number*4
    -- local npc_op = maxNpc-4+i
    -- if tonumber(_ED.union_pve_info[tonumber(self.data_id)].status) == 0 then
    -- if tonumber(self.data_id) == #_ED.union_pve_info then
    local maxIndex = current_index
    -- for k,v in pairs(_ED.union_pve_info) do
    --     if tonumber(v.status) == 0 then
    --         maxIndex = k
    --         break
    --     end
    -- end
    if maxIndex > 4 then
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            local moverInfo = posX
            if index > 1 then
                moverInfo = moverInfo - 498 - posX
                --moverInfo = moverInfo + 498
            end
            if math.floor(maxIndex % 4) == 0 then
                m_ScrollView:getInnerContainer():setPositionX(-m_width * (math.floor(maxIndex / 4)-1)-moverInfo)
            else
                m_ScrollView:getInnerContainer():setPositionX(-m_width * (math.floor(maxIndex / 4))-moverInfo)
            end
        else
            if math.floor(maxIndex % 4) == 0 then
                m_ScrollView:getInnerContainer():setPositionX(-m_width * (math.floor(maxIndex / 4)-1))
            else
                m_ScrollView:getInnerContainer():setPositionX(-m_width * (math.floor(maxIndex / 4)))
            end
        end
    end

    -- local maxWidth = m_width*index
    -- if m_ScrollView:getContentSize().width < maxWidth then
    --     m_ScrollView:setInnerContainerSize(cc.size(maxWidth,m_ScrollView:getContentSize().height))
    -- end
    _ED.user_formetion_status_copy = {}
    _ED.formetion_copy = {}
    table.merge(_ED.user_formetion_status_copy, _ED.user_formetion_status)
    table.merge(_ED.formetion_copy, _ED.formetion)

    local union_copy_formation_status_info = cc.UserDefault:getInstance():getStringForKey(getKey("union_copy_formation_status_info"), "")
    local union_copy_formation_info = cc.UserDefault:getInstance():getStringForKey(getKey("union_copy_formation_info"), "")
    
    local  temp_ship = true
    if nil ~= union_copy_formation_status_info or "" ~= union_copy_formation_status_info or nil ~= union_copy_formation_info or "" ~= union_copy_formation_info then
        local temp_formation_status =  zstring.split(union_copy_formation_status_info, ",")
        local temp_formation_info = zstring.split(union_copy_formation_info, ",")
        
        for k,v in pairs(temp_formation_status) do
            if not _ED.user_ship[v] and tonumber(v) ~= 0  then
                temp_ship = false
            end
        end
    end

    if nil == union_copy_formation_status_info or "" == union_copy_formation_status_info or nil == union_copy_formation_info or "" == union_copy_formation_info or (not temp_ship)  then
        cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
        cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_info"), zstring.concat(_ED.formetion, ","))
    else
        _ED.user_formetion_status = zstring.split(union_copy_formation_status_info, ",")
        _ED.formetion = zstring.split(union_copy_formation_info, ",")
    end
    --
end

function SmUnionDuplicate:oneKeyFormationChange()
    -- state_machine.unlock("battle_ready_window_oen_key_formation_window")

    local nMaxCount = self:getFormationCount()

    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local fightShipList = {}

    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            table.insert(fightShipList, ship) 
        end
    end
    table.sort(fightShipList, fightingCapacity)

    local str = ""
    for i = 1, 6 do
        _ED.formetion[i + 1] = 0
        _ED.user_formetion_status[i] = 0
        if i <= nMaxCount then
            local ship = fightShipList[i]
            local shipId = zstring.tonumber(_ED.formetion[i + 1])
            if nil ~= ship then
                _ED.formetion[i + 1] = ship.ship_id
                _ED.user_formetion_status[i] = ship.ship_id
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_info"), zstring.concat(_ED.formetion, ","))

    self:onUpdateDrawFormation()
end

function SmUnionDuplicate:formationChange(params)
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_info"), zstring.concat(_ED.formetion, ","))
end

function SmUnionDuplicate:joinFormtion(params)
    state_machine.excute("hero_formation_choice_wear_window_close", 0, 0)

    local nMaxCount = self:getFormationCount()

    local cell_index = params[1]
    local ship_id = params[2]

    for i, v in pairs(_ED.user_formetion_status) do
        if zstring.tonumber(v) <= 0 and i <= nMaxCount then
            cell_index = i
            break
        end
    end

    local old_ship_id = zstring.tonumber(_ED.user_formetion_status[cell_index])
    _ED.user_formetion_status[cell_index] = ship_id
    for i = 1, 6 do
        local shipId = zstring.tonumber(_ED.formetion[i + 1])
        if i <= nMaxCount then
            if shipId > 0 then
                if old_ship_id == shipId then
                    _ED.formetion[i + 1] = ship_id
                    break
                end
            else
                _ED.formetion[i + 1] = ship_id
                break
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_info"), zstring.concat(_ED.formetion, ","))

    self:onUpdateDrawFormation()
end

function SmUnionDuplicate:getFormationCount()
    local nMaxCount = 6
    return nMaxCount
end

function SmUnionDuplicate:onUpdateDrawFormation( ... )
    local root = self.roots[1]

    local nMaxCount = self:getFormationCount()
        --画武将列表
    local ListView_gh_pve_line = ccui.Helper:seekWidgetByName(root, "ListView_gh_pve_line")
    ListView_gh_pve_line:removeAllItems()
    for i= 1, 6 do
        local cell = HeroIconListCell:createCell()
        local ship = _ED.user_ship["".._ED.user_formetion_status[6-i+1]]
        if nil ~= ship then
            cell:init(ship, 6-i+1, true)
            local Image_line_role = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_line_role")
            if nil ~= Image_line_role then
                Image_line_role:setVisible(false)
            end
        -- else
        --     cell:init(nil,6-i+1, true)
        end

        if 6-i+1 <= nMaxCount then
            -- 上阵
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "sm_union_duplicate_open_join_formation_window",
                cell_index = 6-i+1,
                isPressedActionEnabled = true
            },
            nil,0)
        end
        if nil ~= ship then
            ListView_gh_pve_line:addChild(cell) 
        end
    end
    ListView_gh_pve_line:requestRefreshView()
end

function SmUnionDuplicate:onUpdate( dt )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local posX = self.ScrollView_pve_map:getInnerContainer():getPositionX()
    if posX >= -40 then
        self.Button_pve_map_arrow_1:setVisible(false)
    else
        self.Button_pve_map_arrow_1:setVisible(true)
    end
    if posX <= -self.ScrollView_pve_map:getInnerContainer():getContentSize().width + self.ScrollView_pve_map:getContentSize().width then
        self.Button_pve_map_arrow_2:setVisible(false)
    else
        self.Button_pve_map_arrow_2:setVisible(true)
    end
end

function SmUnionDuplicate:init()
    self:onInit()
    return self
end

function SmUnionDuplicate:onInit()
    local csbSmUnionDuplicate = csb.createNode("legion/sm_legion_pve_main.csb")
    local root = csbSmUnionDuplicate:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionDuplicate)
    self:onUpdateDraw()
    self:onUpdateDrawFormation()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_union_duplicate_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    --一键上阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gh_pve_line"), nil, 
    {
        terminal_name = "sm_union_duplicate_oen_key_formation_window",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

    --调整阵型
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gh_pve_bz"), nil, 
    {
        terminal_name = "sm_union_duplicate_join_formation_change",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

    --会员进度
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hyjd"), nil, 
    {
        terminal_name = "sm_union_membership_progress_open",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

     --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gz"), nil, 
    {
        terminal_name = "sm_union_duplicate_rule_open",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

     --分配
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fpjl"), nil, 
    {
        terminal_name = "sm_union_duplicate_join_open_distribution",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

    self.ScrollView_pve_map = ccui.Helper:seekWidgetByName(root,"ScrollView_pve_map")
    self.Button_pve_map_arrow_1 = ccui.Helper:seekWidgetByName(root,"Button_pve_map_arrow_1")
    self.Button_pve_map_arrow_2 = ccui.Helper:seekWidgetByName(root,"Button_pve_map_arrow_2")
    --左翻
    fwin:addTouchEventListener(self.Button_pve_map_arrow_1, nil, 
    {
        terminal_name = "sm_union_duplicate_move_list",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true,
        ntype = 2,
    },
    nil,0)
    --右翻
    fwin:addTouchEventListener(self.Button_pve_map_arrow_2, nil, 
    {
        terminal_name = "sm_union_duplicate_move_list",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true,
        ntype = 1,
    },
    nil,0)
    
    --一键领取副本奖励
    self.Button_oneclick = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_oneclick"), nil, 
    {
        terminal_name = "sm_union_duplicate_get_one_click_reward",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true,
    },
    nil,0)

    state_machine.excute("sm_union_user_topinfo_open",0,self)
    state_machine.excute("sm_union_duplicate_show_one_click_btn", 0, nil)
end

function SmUnionDuplicate:onExit()
    state_machine.remove("sm_union_duplicate_display")
    state_machine.remove("sm_union_duplicate_hide")
    state_machine.remove("sm_union_duplicate_oen_key_formation_window")
    state_machine.remove("sm_union_duplicate_open_join_formation_window")
    state_machine.remove("sm_union_duplicate_join_formation")
    state_machine.remove("sm_union_duplicate_join_formation_change")
    state_machine.remove("sm_union_duplicate_join_update_formation")
    state_machine.remove("sm_union_duplicate_join_open_distribution")
    state_machine.remove("sm_union_duplicate_join_formation_change_request")
    state_machine.remove("sm_union_duplicate_move_list")
    state_machine.remove("sm_union_duplicate_show_one_click_btn")
    state_machine.remove("sm_union_duplicate_get_one_click_reward")
end