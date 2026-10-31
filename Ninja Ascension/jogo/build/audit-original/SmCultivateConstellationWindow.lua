-----------------------------
-- 诸神赐福主界面
-----------------------------
SmCultivateConstellationWindow = class("SmCultivateConstellationWindowClass", Window)

local sm_cultivate_constellation_window_open_terminal = {
	_name = "sm_cultivate_constellation_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if true == funOpenDrawTip(125) then
            return
        end
        if fwin:find("SmCultivateConstellationWindowClass") == nil then
            fwin:open(SmCultivateConstellationWindow:new():init(), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_cultivate_constellation_window_close_terminal = {
	_name = "sm_cultivate_constellation_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCultivateConstellationWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_constellation_window_open_terminal)
state_machine.add(sm_cultivate_constellation_window_close_terminal)
state_machine.init()

function SmCultivateConstellationWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentIndex = 0

    self.currentScrollView = nil
    self.leftButton = nil
    self.rightButton = nil

    self.lastIndex = -1

    self.all_pages = 0

    app.load("client.l_digital.cultivate.constellation.ConstellationPageCell")
    app.load("client.l_digital.cultivate.achieve.SmCultivateAchieveHelp")
    app.load("client.l_digital.cultivate.constellation.SmCultivateConstellationRank")
    app.load("client.l_digital.cultivate.constellation.SmCultivateConstellationRule")
    
    local function init_sm_cultivate_constellat_terminal()
        local sm_cultivate_constellat_update_choose_state_terminal = {
            _name = "sm_cultivate_constellat_update_choose_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = tonumber(params)
                instance:changeAttributeNum(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local tab_btn_change_terminal = {
            _name = "tab_btn_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local chooseIndex = params._datas._index
                instance:changePageViewShow(chooseIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arrow_button_scroll_terminal = {
            _name = "arrow_button_scroll",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local click_type = params._datas._type
                local current_page = instance._pageViews:getCurPageIndex()
                if click_type == 1 then
                    current_page = current_page - 1
                else
                    current_page = current_page + 1
                end
                instance:changePageViewShow(current_page + 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local open_constellation_rank_terminal = {
            _name = "open_constellation_rank",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = 9
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_cultivate_constellation_rank_open", 0, "")
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

        local constellation_rule_open_terminal = {
            _name = "constellation_rule_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_cultivate_constellation_rule_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        

        state_machine.add(sm_cultivate_constellat_update_choose_state_terminal)
        state_machine.add(tab_btn_change_terminal)
        state_machine.add(arrow_button_scroll_terminal)
        state_machine.add(open_constellation_rank_terminal)
        state_machine.add(constellation_rule_open_terminal)
        state_machine.init()
    end
    init_sm_cultivate_constellat_terminal()
end

function SmCultivateConstellationWindow:updatePageView( chooseIndex )
    
end

function SmCultivateConstellationWindow:onUpdateDraw(pageIndex)
	if ocultosSistemas ~= nil then ocultosSistemas() end -- OCULTOS-SISTEMAS
    local root = self.roots[1]
    self:tabBtnShow()
    self._pageViews = ccui.Helper:seekWidgetByName(root,"PageView_xz_shux")
    self._pageViews:removeAllPages()
    self._pageViews:setCustomScrollThreshold(20)

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local currentPageIndex = self._pageViews:getCurPageIndex()
            if self.lastIndex == currentPageIndex then
                return
            end
            currentPageIndex = tonumber(self._pageViews:getCurPageIndex() + 1)
            self:changePageViewShow(currentPageIndex)
            self.lastIndex = currentPageIndex - 1
        end
    end

    self._pageViews:addEventListener(pageViewEvent)
    self._pageViews.callback = pageViewEvent

    local all_stars = #dms["constellation_mould"]
    for i=1,all_stars do
        local open_level = dms.int(dms["constellation_mould"], i, constellation_mould.constellation_open_level)
        local max_level = dms.int(dms["user_config"], 5, user_config.param)
        if open_level <=  max_level then
            local ConstellationPageCell = ConstellationPageCell:createCell()
            ConstellationPageCell:init(i)
            self._pageViews:addPage(ConstellationPageCell)
            self.all_pages = self.all_pages + 1
        end
    end
    self:changePageViewShow(pageIndex or 1)
end

function SmCultivateConstellationWindow:changeAttributeNum( index )
    local root = self.roots[1]
    local Panel_star_infor_lock = ccui.Helper:seekWidgetByName(root,"Panel_star_infor_lock")
    local Text_xz_gj_n = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n")
    local Text_xz_fy_n = ccui.Helper:seekWidgetByName(root,"Text_xz_fy_n")
    local Text_xz_sm_n = ccui.Helper:seekWidgetByName(root,"Text_xz_sm_n")
    local Text_xz_jz_n = ccui.Helper:seekWidgetByName(root,"Text_xz_jz_n")

    local Text_xz_jz = ccui.Helper:seekWidgetByName(root,"Text_xz_jz")

    Text_xz_fy_n:setString("")
    Text_xz_gj_n:setString("")
    Text_xz_sm_n:setString("")
    Text_xz_jz:setString("")

    Text_xz_jz:setString(_ED.constellation_info.ctv)

    local use_ships = _ED.constellation_info.hba
    local all_gj = 0
    local all_fy = 0
    local all_sm = 0
    local protect_nums = 0
    local need_level = dms.int(dms["constellation_mould"], index, constellation_mould.constellation_open_level)
    if need_level > tonumber(_ED.user_info.user_grade) or not use_ships or not use_ships[index .. ""] or self:getTableNum(use_ships[index .. ""]) == 0 then
        Panel_star_infor_lock:setVisible(false)
    else
        Panel_star_infor_lock:setVisible(true)
        -- for i,v in pairs(use_ships[index .. ""]) do
        --     local group_id = v
        --     local add_attribute = dms.string(dms["constellation_group"], group_id, constellation_group.add_additional)
        --     local cost = dms.int(dms["constellation_group"], group_id, constellation_group.protect_num)
        --     -- local Text_shuxing_2:setString(skill_attributes_text_tips[zstring.tonumber(additionals[2][1]) + 1] .. ":" .. additionals[2][2])
        --     local additionals = zstring.splits(add_attribute, "|", ",")
        --     all_gj = all_gj + zstring.tonumber(additionals[1][2])
        --     all_fy = all_fy + zstring.tonumber(additionals[2][2])
        --     all_sm = all_sm + zstring.tonumber(additionals[3][2])
        --     protect_nums = protect_nums + cost
        -- end
        protect_nums, all_gj, all_fy, all_sm = self:attributeNumClt(index)

        Text_xz_gj_n:setString( math.floor(all_gj))
        Text_xz_fy_n:setString( math.floor(all_fy))
        Text_xz_sm_n:setString( math.floor(all_sm))
        Text_xz_jz_n:setString( protect_nums)
    end
end

function SmCultivateConstellationWindow:getTableNum(table)
    local index = 0
    for k,v in pairs(table) do
        if v then
            index = index + 1
        end
    end
    return index
end

function SmCultivateConstellationWindow:attributeNumClt(index)
    local all_cost = 0
    local all_gj = 0
    local all_fy = 0
    local all_sm = 0
    local ship_group_id = dms.string(dms["constellation_mould"], index, constellation_mould.constellation_ship_id)
    local ship_ids = zstring.split(ship_group_id, ",")
    local constellation_add_config = zstring.splits(dms.string(dms["play_config"], 83, pirates_config.param), "|", ",")
    local percent_add_constellation = 0
    for i,v in pairs(_ED.constellation_info.hba[index .. ""]) do
        if v then
            for k,z in pairs(v) do
                if z then
                    local cost = dms.int(dms["constellation_group"], z, constellation_group.protect_num)
                    all_cost = all_cost + cost
                end
            end
        end
    end
    for i,v in pairs(_ED.constellation_info.uc[index.. ""]) do
        if v then
            local ship_template_id = ship_ids[tonumber(i)+1]
            local current_ship = nil
            for i,ship in pairs(_ED.user_ship) do
                if tonumber(ship.ship_template_id) == tonumber(ship_template_id) then
                    current_ship = ship
                end
            end

            percent_add_constellation = tonumber(constellation_add_config[tonumber(self:getTableNum(_ED.constellation_info.hba[index .. ""][i .. ""]))][2])

            local add_percent_star = 0
            local add_percent_quality = 0
            local add_percent_all = 0

            if current_ship then
                local star_add_config = zstring.splits(dms.string(dms["play_config"], 81, pirates_config.param), "|", ",")
                local star_num = tonumber(current_ship.StarRating)
                add_percent_star = tonumber(star_add_config[star_num][2])
                
                local quality_add_config = zstring.splits(dms.string(dms["play_config"], 82, pirates_config.param), "|", ",")
                local quality = tonumber(current_ship.Order)
                add_percent_quality = tonumber(quality_add_config[quality+1][2])
            end
            add_percent_all = (add_percent_star + add_percent_quality + percent_add_constellation)/100
            local add_attribute = dms.string(dms["constellation_group"], v, constellation_group.add_additional)
            local additionals = zstring.splits(add_attribute, "|", ",")
            all_gj = all_gj + zstring.tonumber(additionals[1][2])*(add_percent_all + 1)
            all_fy = all_fy + zstring.tonumber(additionals[2][2])*(add_percent_all + 1)
            all_sm = all_sm + zstring.tonumber(additionals[3][2])*(add_percent_all + 1)
        end
    end

    return all_cost, all_gj, all_fy, all_sm
end

function SmCultivateConstellationWindow:changePageViewShow( index )
    local root = self.roots[1]
    local Button_xz_shux_left = ccui.Helper:seekWidgetByName(root,"Button_xz_shux_left")
    local Button_xz_shux_right = ccui.Helper:seekWidgetByName(root,"Button_xz_shux_right")
    local Text_xz_num = ccui.Helper:seekWidgetByName(root,"Text_xz_num")
    local Text_xz_num_name = ccui.Helper:seekWidgetByName(root,"Text_xz_num_name")
    local Panel_xz_attribute = ccui.Helper:seekWidgetByName(root,"Panel_xz_attribute")
    local Panel_xz_att_icon = ccui.Helper:seekWidgetByName(root,"Panel_xz_att_icon")
    local Panel_xz_att_text = ccui.Helper:seekWidgetByName(root,"Panel_xz_att_text")

    

    Text_xz_num:setString("")
    Text_xz_num_name:setString("")
    

    Panel_xz_attribute:removeBackGroundImage()
    Panel_xz_att_icon:removeBackGroundImage()
    Panel_xz_att_text:removeBackGroundImage()

    

    local stars_list = ccui.Helper:seekWidgetByName(root,"ListView_xz_star_btn")
    local page_index = index - 1
    if self._pageViews and page_index <= #self._pageViews:getPages() then
        self._pageViews:scrollToPage(page_index)
        if index > 1 then
            Button_xz_shux_left:setVisible(true)
        else
            Button_xz_shux_left:setVisible(false)
        end

        if index < self.all_pages then
            Button_xz_shux_right:setVisible(true)
        else
            Button_xz_shux_right:setVisible(false)
        end

        for i,item in pairs(stars_list:getItems()) do
            local btn = ccui.Helper:seekWidgetByName(item,"Button_xz_star")
            if item.page == index then
                btn:setHighlighted(true)
                btn:setTouchEnabled(false)
            else
                btn:setHighlighted(false)
                btn:setTouchEnabled(true)
            end
        end

        local name_mould_id = dms.int(dms["constellation_mould"], index, constellation_mould.constellation_name_id)
        local type_id = dms.int(dms["constellation_mould"], index, constellation_mould.constellation_ship_type)
        local name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)

        local ship_template_ids = dms.string(dms["constellation_mould"], index, constellation_mould.constellation_ship_id)
        local ship_group_ids = dms.string(dms["constellation_mould"], index, constellation_mould.constellation_group_id)
       
        Panel_xz_attribute:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_icon_%d.png", type_id))
        Panel_xz_att_icon:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_icon_%d.png", type_id))
        Panel_xz_att_text:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_t_%d.png", type_id))
        Text_xz_num:setString(string.format(tipStringInfo_constellation_tips[1], index))
        Text_xz_num_name:setString(name)

        self:changeAttributeNum(index)
    end
end


function SmCultivateConstellationWindow:tabBtnShow()
	if ocultosSistemas ~= nil then ocultosSistemas() end -- OCULTOS-SISTEMAS
    local all_stars = #dms["constellation_mould"]
    local root = self.roots[1]
    local tab_list = ccui.Helper:seekWidgetByName(root,"ListView_xz_star_btn")
    tab_list:removeAllItems()
    local temp_btn_root = csb.createNode("cultivate/constellation_star_cell.csb")
    local temp_btn = temp_btn_root:getChildByName("root")
    for i=1,all_stars do
        local open_level = dms.int(dms["constellation_mould"], i, constellation_mould.constellation_open_level)
        local max_level = dms.int(dms["user_config"], 5, user_config.param)
        if open_level <=  max_level then
            local cell = temp_btn:clone()
            local btn = ccui.Helper:seekWidgetByName(cell,"Button_xz_star")
            cell.page = i
            fwin:addTouchEventListener(btn, nil, 
                {
                    terminal_name = "tab_btn_change", 
                    terminal_state = 0, 
                    _index = i,
                    touch_black = true,
                }, nil, 3)
            tab_list:addChild(cell)
        end
    end
end


function SmCultivateConstellationWindow:onUpdate( dt )
    
end

function SmCultivateConstellationWindow:init()
	if ocultosSistemas ~= nil then ocultosSistemas() end -- OCULTOS-SISTEMAS
	self:onInit()
    return self
end

function SmCultivateConstellationWindow:onInit()
	if ocultosSistemas ~= nil then ocultosSistemas() end -- OCULTOS-SISTEMAS
    local csbItem = csb.createNode("cultivate/constellation.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:onUpdateDraw()
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_constellation_close"), nil, 
    {
        terminal_name = "sm_cultivate_constellation_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    local Button_xz_shux_left = ccui.Helper:seekWidgetByName(root,"Button_xz_shux_left")
    local Button_xz_shux_right = ccui.Helper:seekWidgetByName(root,"Button_xz_shux_right")
    fwin:addTouchEventListener(Button_xz_shux_left, nil, 
    {
        terminal_name = "arrow_button_scroll", 
        terminal_state = 0, 
        _type = 1,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(Button_xz_shux_right, nil, 
    {
        terminal_name = "arrow_button_scroll", 
        terminal_state = 0,
        _type = 2,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xz_ranking"), nil, 
    {
        terminal_name = "open_constellation_rank", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xz_guize"), nil, 
    {
        terminal_name = "constellation_rule_open", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

function SmCultivateConstellationWindow:onEnterTransitionFinish()
end

function SmCultivateConstellationWindow:onExit()
    state_machine.remove("sm_cultivate_constellat_update_choose_state")
    state_machine.remove("tab_btn_change")
    state_machine.remove("arrow_button_scroll")
    state_machine.remove("open_constellation_rank")
end
