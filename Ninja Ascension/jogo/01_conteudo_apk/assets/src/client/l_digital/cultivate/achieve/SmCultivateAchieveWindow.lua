-----------------------------
-- 神器主界面
-----------------------------
SmCultivateAchieveWindow = class("SmCultivateAchieveWindowClass", Window)

local sm_cultivate_achieve_window_open_terminal = {
	_name = "sm_cultivate_achieve_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if true == funOpenDrawTip(124) then
            return
        end
        if fwin:find("SmCultivateAchieveWindowClass") == nil then
            fwin:open(SmCultivateAchieveWindow:new():init(), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_cultivate_achieve_window_close_terminal = {
	_name = "sm_cultivate_achieve_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCultivateAchieveWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_achieve_window_open_terminal)
state_machine.add(sm_cultivate_achieve_window_close_terminal)
state_machine.init()

function SmCultivateAchieveWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentIndex = 0

    self.currentScrollView = nil
    self.leftButton = nil
    self.rightButton = nil

    app.load("client.l_digital.cells.cultivate.achieve.sm_cultivate_achieve_cell")
    app.load("client.l_digital.cultivate.achieve.SmCultivateAchieveHelp")
    app.load("client.l_digital.cultivate.achieve.SmCultivateAchieveRank")
    
    local function init_sm_cultivate_achieve_terminal()
        local sm_cultivate_achieve_update_choose_state_terminal = {
            _name = "sm_cultivate_achieve_update_choose_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_achieve_page_change_terminal = {
            _name = "sm_cultivate_achieve_page_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local chooseIndex = params._datas._index
                instance:updateListChooseState(chooseIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_achieve_help_terminal = {
            _name = "sm_cultivate_achieve_help",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local title = instance.title_id
                state_machine.excute("sm_cultivate_achieve_help_open",0,title)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_avhieve_ranking_terminal = {
            _name = "sm_cultivate_avhieve_ranking",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = 8
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_cultivate_achieve_rank_open", 0, "")
                        end
                    end
                end
                protocol_command.order_get_info.param_list = m_type.."\r\n".."1".."\r\n".."10"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        

        state_machine.add(sm_cultivate_achieve_update_choose_state_terminal)
        state_machine.add(sm_cultivate_achieve_page_change_terminal)
        state_machine.add(sm_cultivate_achieve_help_terminal)
        state_machine.add(sm_cultivate_avhieve_ranking_terminal)
        state_machine.init()
    end
    init_sm_cultivate_achieve_terminal()
end

function SmCultivateAchieveWindow:updateListChooseState( chooseIndex )
    local root = self.roots[1]
    for i, v in ipairs(self.tab_btns) do
        local btn = ccui.Helper:seekWidgetByName(root,v)
        if i == chooseIndex then
            btn:setTouchEnabled(false)
            btn:setHighlighted(true)
        else
            btn:setTouchEnabled(true)
            btn:setHighlighted(false)
        end
    end
    if self.currentIndex == chooseIndex then
        return
    end
    self.currentIndex = chooseIndex
    self:onUpdateDraw(chooseIndex)
end

function SmCultivateAchieveWindow:onUpdateDraw(index)
    local root = self.roots[1]
    local name = ccui.Helper:seekWidgetByName(root,"Text_cj_n") --称号
    local sorce = ccui.Helper:seekWidgetByName(root,"Text_jf_n") --积分
    local speed = ccui.Helper:seekWidgetByName(root,"Text_speed_n") --速度

    local list = ccui.Helper:seekWidgetByName(root,"ListView_sq_icon")
    list:removeAllItems()
    list:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

    --称号
    local my_sorce = zstring.tonumber(_ED.user_artifact_achieve_all_sorce)
    local my_id = 1
    local max_sorce = dms.int(dms["achievement_title"], #dms["achievement_title"], 3)
    
    for i, v in ipairs(dms["achievement_title"]) do
        local id = tonumber(dms.int(dms["achievement_title"], i, 1))
        if my_sorce <= 0 then
            my_id = 1
        elseif my_sorce >= tonumber(max_sorce) then
            my_id = dms.int(dms["achievement_title"], #dms["achievement_title"], 1)
        elseif i < #dms["achievement_title"] and tonumber(dms.int(dms["achievement_title"], i, 3)) <= my_sorce and my_sorce < tonumber(dms.int(dms["achievement_title"], i + 1, 3))  then
            my_id = id
        end
    end
    self.title_id = my_id
    local name_index = tonumber(dms.int(dms["achievement_title"], my_id, 2))
    local my_name = dms.element(dms["word_mould"], name_index)[3]

    -- 积分
    local all_speed = 0
    for i, v in ipairs(_ED.user_artifact_achieve_info) do
        local speeds = dms.int(dms["achievement"], v.id, achievement.achievement_speed)
        local max_level = dms.int(dms["achievement"], v.id, achievement.achievement_need_level)
        if tonumber(_ED.user_info.user_grade) >= max_level then
            all_speed = all_speed + speeds
        end
        if dms.int(dms["achievement"], v.id, achievement.achievement_type) == 1 then
        end
    end

    name:setString(my_name)
    sorce:setString(zstring.tonumber(_ED.user_artifact_achieve_all_sorce) .. "/" .. all_speed)
    speed:setString(_ED.user_info.speed_sum)


    local achieve_ones = {}
    local achieve_tows = {}
    local achieve_thrs = {}
    for i, v in ipairs(_ED.user_artifact_achieve_info) do
        local achievement_type = dms.int(dms["achievement"], v.id, achievement.achievement_type)
        if achievement_type and achievement_type == 1 then
            table.insert(achieve_ones, v)
        elseif achievement_type and achievement_type == 2 then
            table.insert(achieve_tows, v)
        elseif achievement_type and achievement_type == 3 then
            table.insert(achieve_thrs, v)
        end
    end

    local achieve_params = index == 1 and achieve_ones or (index == 2 and achieve_tows or achieve_thrs)
    local new_achieves = self:sortTask(achieve_params)
    for i, v in ipairs(new_achieves) do
        local item = dms.element(dms["achievement"], tonumber(v.id))
        local params = {}
        params.id = v.id
        params.name = dms.element(dms["word_mould"], zstring.tonumber(item[2]))[3]
        params.des = dms.element(dms["word_mould"], zstring.tonumber(item[3]))[3]
        params.reward = item[9]
        params.condition = (zstring.tonumber(item[6]) == 27 and zstring.tonumber(item[4]) == 2) and tonumber(item[8]) or tonumber(item[7])
        params.is_display = item[11]
        params.stars = item[12]
        params.speed = tonumber(v.speed) -- -1已领取
        params.have_stars = tonumber(v.have_stars)
        local cell = state_machine.excute("sm_cultivate_achieve_cell",0,{params, index})
        list:addChild(cell)
    end

    list:requestRefreshView()
end


function SmCultivateAchieveWindow:sortTask( tasks )
    local task = {}
    local new_tasks = {}
    local temp_tasks = {}
    local now_type = -1

    for i,v in ipairs(tasks) do
        if v and v.id then
            table.insert(task, v)
        end
    end
    
    table.sort(task, function( a, b )
        local result = false
        if tonumber(a.id) < tonumber(b.id) then
            result = true
        end
        return result
    end)

    local new_items = {}
    for i, v in ipairs(task) do
        local mType = dms.int(dms["achievement"], v.id, 6)
        if tonumber(now_type) ~= tonumber(mType) then
            if #new_items > 0 then
                table.insert(temp_tasks,new_items)
            end
            new_items = {}
            now_type = mType
            table.insert(new_items, v)
        else
            table.insert(new_items, v)
        end
    end

    function filterTables( items )
        local new_item = nil
        local index = 0
        local have_stars = dms.int(dms["achievement"], items[#items].id, 12)
        if tonumber(items[#items].speed) == -1 then
            new_item = items[#items]
        else
            for i, v in ipairs(items) do
                if tonumber(v.speed) ~= -1 then
                    new_item = v
                    break
                end
            end
        end
        new_item.have_stars = have_stars
        return new_item
    end

    for k, v in ipairs(temp_tasks) do
        local item = filterTables(v)
        if item then
            table.insert(new_tasks ,item)
        end
    end
    local not_achieve = {}
    local is_achieve = {}
    local achieved = {}
    for k, p in ipairs(new_tasks) do
        local condition_type = dms.int(dms["achievement"], p.id, 6)
        local achieve_type = dms.int(dms["achievement"], p.id, 4)
        local condition = (condition_type == 27 and achieve_type == 2) and dms.int(dms["achievement"], p.id, 8) or dms.int(dms["achievement"], p.id, 7)
        local max_level = dms.int(dms["achievement"], p.id, achievement.achievement_need_level)
        if tonumber(p.speed) == -1 then
            table.insert(achieved, p)
        elseif tonumber(p.speed) < condition and tonumber(p.speed) ~= -1 and tonumber(_ED.user_info.user_grade) >= max_level then
            table.insert(not_achieve, p)
        elseif tonumber(p.speed) >= condition and tonumber(p.speed) ~= -1 and tonumber(_ED.user_info.user_grade) >= max_level then
            table.insert(is_achieve, p)
        end
    end
    
    local new_achieves = {}
    function insertToNew( list )
        table.sort(list, function( a, b )
            if tonumber(a.id) <= tonumber(b.id) then
                return true
            else
                return false
            end
        end)
        for k, v in ipairs(list) do
            table.insert(new_achieves, v)
        end
    end

    insertToNew(is_achieve)
    insertToNew(achieved)
    insertToNew(not_achieve)
    return new_achieves
end


function SmCultivateAchieveWindow:onUpdate( dt )
    
end

function SmCultivateAchieveWindow:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "user_information")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    if tonumber(_ED.vip_grade) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    local pic = tonumber(_ED.user_info.user_head)
    if pic >= 9 then
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(sprit,0)

    -- fwin:addTouchEventListener(Panel_player_icon, nil, 
    -- {
    --     terminal_name = "sm_cultivate_achieve_to_user_information", 
    --     terminal_state = 0, 
    --     touch_black = true,
    -- }, nil, 3)
end

function SmCultivateAchieveWindow:init()
	self:onInit()
    return self
end

function SmCultivateAchieveWindow:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_achievement.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self:drawHead()
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_cultivate_achieve_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ranking"), nil, 
    {
        terminal_name = "sm_cultivate_avhieve_ranking", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_guize"), nil, 
    {
        terminal_name = "sm_cultivate_achieve_help", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    self.tab_btns = {"Button_maoxian", "Button_yangcheng", "Button_huodong"}
    for i, v in ipairs(self.tab_btns) do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,v), nil,
            {
                terminal_name = "sm_cultivate_achieve_page_change", 
                terminal_state = 0,
                _index = i,
                touch_black = true,
            }, nil, 3)

        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_cultivate_achieve_" .. v,
        _widget = ccui.Helper:seekWidgetByName(root,v),
        _invoke = nil,
        _interval = 0.5,})
    end
    self:updateListChooseState(1)
end

function SmCultivateAchieveWindow:onEnterTransitionFinish()
end

function SmCultivateAchieveWindow:onExit()
    state_machine.remove("sm_cultivate_achieve_update_choose_state")
    state_machine.remove("sm_cultivate_achieve_page_change")
    state_machine.remove("sm_cultivate_avhieve_ranking")
    state_machine.remove("sm_cultivate_achieve_help")
end
