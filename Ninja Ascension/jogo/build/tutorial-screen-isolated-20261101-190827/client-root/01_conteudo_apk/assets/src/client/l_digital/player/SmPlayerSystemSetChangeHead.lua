-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统修改头像
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetChangeHead = class("SmPlayerSystemSetChangeHeadClass", Window)
local sm_player_system_set_change_head_open_terminal = {
    _name = "sm_player_system_set_change_head_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerSystemSetChangeHeadClass")
        if _window == nil then
            fwin:open(SmPlayerSystemSetChangeHead:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_player_system_set_change_head_close_terminal = {
    _name = "sm_player_system_set_change_head_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("SmPlayerSystemSetChangeHeadClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_set_change_head_open_terminal)
state_machine.add(sm_player_system_set_change_head_close_terminal)
state_machine.init()
    
function SmPlayerSystemSetChangeHead:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}

    self._scroll_view = nil
    self._scroll_view_posy = 0
    self._page_one_offsety = 0
    self._cur_page = 0
    
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then 
        app.load("client.l_digital.player.SmPlayerHeadUnlockInfo")
    else
        app.load("client.l_digital.player.SmPlayerSystemSetChangeHeadPageOne")
        app.load("client.l_digital.player.SmPlayerSystemSetChangeHeadPageTwo")
    end
    local function init_sm_player_system_set_change_head_terminal()

        local sm_player_change_head_page_change_page_terminal = {
            _name = "sm_player_change_head_page_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params and params._datas then 
                    local mType = params._datas.m_type
                    instance:onUpdataDrawNew(mType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_player_change_head_page_select_pic_terminal = {
            _name = "sm_player_change_head_page_select_pic",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currHeadId = params._datas._headId
                if tonumber(_ED.user_info.user_head) == tonumber(currHeadId) then
                    state_machine.excute("sm_player_system_set_change_head_close",0,"sm_player_system_set_change_head_close.")
                    return
                end
                local function responseChangeNameCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.user_info.user_head = tonumber(currHeadId)
                        state_machine.excute("sm_player_infomation_page_updata_head",0,"sm_player_infomation_page_updata_head.")                        
                        state_machine.excute("user_information_update_head",0,"user_information_update_head.")
                        if fwin:find("ArenaClass") ~= nil then
                            state_machine.excute("arena_update_user_pic",0,"arena_update_user_pic.")
                        end
                    end
                    state_machine.excute("sm_player_system_set_change_head_close",0,"sm_player_system_set_change_head_close.")
                end
                protocol_command.user_info_modify.param_list = "1".."\r\n"..currHeadId
                NetworkManager:register(protocol_command.user_info_modify.code, nil, nil, nil, instance, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_player_change_head_page_change_page_terminal)
        state_machine.add(sm_player_change_head_page_select_pic_terminal)
        state_machine.init()
    end
    init_sm_player_system_set_change_head_terminal()
end

function SmPlayerSystemSetChangeHead:drawHead( _pic, _name)
    --头像
    local pic = _pic
    local name = _name
    local layer = ccui.Layout:create()
    layer:setContentSize(cc.size(120,100))
    local layerSize = layer:getContentSize()
    
    local big_icon_path = nil
    if pic < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    end 
    if cc.FileUtils:getInstance():isFileExist(big_icon_path) == false then
        return false
    end

    local ButtonHead = ccui.Button:create(big_icon_path,big_icon_path)
    ButtonHead:setAnchorPoint(cc.p(0.5,0.5))
    ButtonHead:setPosition(cc.p(layerSize.width / 2 , layerSize.height / 2))
    layer:addChild(ButtonHead)

    ButtonHead:setSwallowTouches(false)
    local quality_path = ""
    if tonumber(_ED.vip_grade) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(layerSize.width / 2 , layerSize.height / 2))
    layer:addChild(SpritKuang,-1)
    if self._cur_page == 2 then 
        display:gray(SpritKuang)
        ButtonHead:setBright(false)
    end

    local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then 
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__spoint.y - __epoint.y) <= 3 then
                if self._cur_page == 1 then 
                    state_machine.excute("sm_player_change_head_page_select_pic",0,{ _datas = { _headId = pic }})
                elseif self._cur_page == 2 then 
                    state_machine.excute("sm_player_head_unlock_info_open",0,{pic , name})
                end
            end
        end
    end
    ButtonHead:addTouchEventListener(fourOpenTouchEvent) 
    return layer
end


function SmPlayerSystemSetChangeHead:getHeadCellList(_type)
    local cell_group = {}
    if _type == 1 then
        -- 已解锁
        local cell_size = 0 
        local AllIndexGroup = zstring.split(dms.string(dms["user_config"], 15 ,user_config.param), ",")

        for i, v in pairs(_ED.user_ship) do
            local evo_image = dms.string(dms["ship_mould"], tonumber(v.ship_template_id), ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            local ship_evo = zstring.split(v.evolution_status, "|")
            for j = 1 , tonumber(ship_evo[1]) do
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    local level_groun_iconIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.level_groun_icon)
                    if level_groun_iconIndex == -1 then
                    else    
                        local picIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.form_id)
                        if picIndex ~= nil then
                            table.insert(AllIndexGroup,picIndex)
                        end
                    end
                else
                    local picIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.form_id)
                    if picIndex ~= nil then
                        table.insert(AllIndexGroup,picIndex)
                    end
                end
            end

            --活动皮肤头像
            if v.ship_skin_info and v.ship_skin_info ~= "" then
                local skin_info = zstring.split(v.ship_skin_info, "|")
                for i,v in ipairs(zstring.split(skin_info[2], ",")) do
                    local skin_id = zstring.split(v, ":")[1]
                    local unlock_condition  = dms.int(dms["ship_skin_mould"], skin_id, ship_skin_mould.unlock_condition)
                    local evo_id = dms.int(dms["ship_skin_mould"], skin_id, ship_skin_mould.ship_evo_id)
                    local evo_pic_id = dms.int(dms["ship_evo_mould"], evo_id, ship_evo_mould.level_groun_icon)
                    local activityPicIndex = dms.int(dms["ship_evo_mould"], evo_id, ship_evo_mould.form_id)
                    local limit_time = zstring.split(v, ":")[2]
                    if unlock_condition == -1 and evo_pic_id == 5 and zstring.tonumber(limit_time) == -1 then
                        table.insert(AllIndexGroup, activityPicIndex)
                    end
                end
            end
        end
        local index = 0 

        local tempAllIndexGroup = {}

        for i, v in pairs(AllIndexGroup) do
            if not tempAllIndexGroup[v] then
                local cell = self:drawHead(tonumber(v))
                if cell ~= false then
                    if cell_size == 0 then
                        cell_size = cell:getContentSize()
                    end
                    table.insert(cell_group , cell)
                    index = index + 1

                    tempAllIndexGroup[v] = true
                end
            end
        end
    elseif _type == 2 then
        -- 未解锁
        local cell_size = 0
        local AllIndexGroup = {}
        self.shipName = {}
        local index = 0
        for i = 1, 56 do
            local evo_image = dms.string(dms["ship_mould"], i, ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            local currStage = dms.int(dms["ship_mould"], i, ship_mould.captain_name) - 1
            local ship = fundShipWidthTemplateId(i)
            if ship ~= nil then
                local ship_evo = zstring.split(ship.evolution_status, "|")
                currStage = tonumber(ship_evo[1])
            end

            --活动皮肤头像
            local get_skin = {}
            if ship and ship.ship_skin_info and ship.ship_skin_info ~= "" then
                local skin_info = zstring.split(ship.ship_skin_info, "|")
                for i, v in ipairs(zstring.split(skin_info[2], ",")) do
                    local skin_id = zstring.split(v, ":")[1]
                    local unlock_condition = dms.int(dms["ship_skin_mould"], skin_id, ship_skin_mould.unlock_condition)
                    local evo_id = dms.int(dms["ship_skin_mould"], skin_id, ship_skin_mould.ship_evo_id)
                    local evo_pic_id = dms.int(dms["ship_evo_mould"], evo_id, ship_evo_mould.level_groun_icon)
                    local activityPicIndex = dms.int(dms["ship_evo_mould"], evo_id, ship_evo_mould.form_id)
                    local limit_time = zstring.split(v, ":")[2]
                    if unlock_condition == -1 and evo_pic_id == 5 and zstring.tonumber(limit_time) == -1 then
                        get_skin[evo_id] = true
                    end
                end
            end

            local current_skin_evo_id = -1
            local skin_mould_rows = dms.searchs(dms["ship_skin_mould"], ship_skin_mould.ship_mould_id, i)
            if skin_mould_rows ~= nil then
                for i, v in ipairs(skin_mould_rows) do
                    local unlock_condition = dms.int(dms["ship_skin_mould"], v[1], ship_skin_mould.unlock_condition)
                    if unlock_condition == -1 then
                        local avtivityEvoId = v[3]
                        local picIndex = dms.int(dms["ship_evo_mould"], avtivityEvoId, ship_evo_mould.form_id)
                        local shipNameId = dms.int(dms["ship_evo_mould"], avtivityEvoId, ship_evo_mould.name_index)
                        local evo_pic_id = dms.int(dms["ship_evo_mould"], avtivityEvoId, ship_evo_mould.level_groun_icon)
                        local word_info = dms.element(dms["word_mould"], shipNameId)
                        if not get_skin[tonumber(avtivityEvoId)] and picIndex ~= nil and evo_pic_id == 5 and word_info and current_skin_evo_id ~= tonumber(avtivityEvoId) then
                            table.insert(AllIndexGroup, picIndex)
                            table.insert(self.shipName, word_info[3])
                            local cell = self:drawHead(tonumber(picIndex), word_info[3])
                            if cell ~= false then
                                if cell_size == 0 then
                                    cell_size = cell:getContentSize()
                                end
                                current_skin_evo_id = tonumber(avtivityEvoId)
                                table.insert(cell_group, cell)
                                index = index + 1
                            end
                        end
                    end
                end
            end

            for j = currStage + 1, #evo_info do
                local isShow = true
                if dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.level_groun_icon) == -1 then
                    isShow = false
                end
                if isShow == true then
                    local picIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.form_id)
                    local shipNameId = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.name_index)
                    local word_info = dms.element(dms["word_mould"], shipNameId)
                    if picIndex ~= nil then
                        table.insert(AllIndexGroup, picIndex)
                        table.insert(self.shipName, word_info[3])
                        local cell = self:drawHead(tonumber(picIndex), word_info[3])
                        if cell ~= false then
                            if cell_size == 0 then
                                cell_size = cell:getContentSize()
                            end
                            table.insert(cell_group, cell)
                            index = index + 1
                        end
                    end
                end
            end
        end
    end
    return cell_group
end

-- DSC重塑分开显示基础和解锁头像
function SmPlayerSystemSetChangeHead:onUpdataDrawNew(_page)
    if self._cur_page == _page then 
        return
    end
    local root = self.roots[1]
    local Button_8 = ccui.Helper:seekWidgetByName(root, "Button_8")
    local Text_22 = ccui.Helper:seekWidgetByName(root, "Text_22")
    local Button_8_0 = ccui.Helper:seekWidgetByName(root, "Button_8_0")
    local Text_23 = ccui.Helper:seekWidgetByName(root, "Text_23")
    if _page == 1 then 
        Button_8:setTouchEnabled(false)
        Button_8:setHighlighted(true)
        Button_8_0:setTouchEnabled(true)
        Button_8_0:setHighlighted(false)
        Text_22:setVisible(true)
        Text_23:setVisible(false)
    else
        Button_8:setTouchEnabled(true)
        Button_8:setHighlighted(false)
        Button_8_0:setTouchEnabled(false)
        Button_8_0:setHighlighted(true)
        Text_22:setVisible(false)
        Text_23:setVisible(true)
    end
    self._scroll_view = nil
    self._cur_page = _page
    local root = self.roots[1]
    local ScrollView_head = ccui.Helper:seekWidgetByName(root, "ScrollView_head")
    ScrollView_head:removeAllChildren(true)

    local cellList = self:getHeadCellList(self._cur_page)
    addNodeToScrollView({targetScrollView = ScrollView_head,nodeList = cellList,columns = 6})
end



function SmPlayerSystemSetChangeHead:onUpdataDraw()
	local root = self.roots[1]
    local ScrollView_head = ccui.Helper:seekWidgetByName(root, "ScrollView_head")
    ScrollView_head:removeAllChildren(true)
    local height = 0
    local pageOne = state_machine.excute("sm_player_system_set_change_head_page_one_open",0,"")
    ScrollView_head:addChild(pageOne)
    height = height + pageOne:getContentSize().height
    local pageTwo = state_machine.excute("sm_player_system_set_change_head_page_two_open",0,"")
    ScrollView_head:addChild(pageTwo)
    height = height + pageTwo:getContentSize().height
    height = math.max(height , ScrollView_head:getContentSize().height)
    pageOne:setPositionY(pageTwo:getContentSize().height)
    ScrollView_head:getInnerContainer():setContentSize(cc.size(ScrollView_head:getContentSize().width, height))
    ScrollView_head:getInnerContainer():setPositionY(ScrollView_head:getContentSize().height - height)

    self._scroll_view = ScrollView_head
    self._scroll_view_posy = ScrollView_head:getInnerContainer():getPositionY() + 1
    self._page_one_offsety = pageTwo:getContentSize().height
end

function SmPlayerSystemSetChangeHead:onUpdate(dt)
    if self._scroll_view ~= nil then
        local posY = self._scroll_view:getInnerContainer():getPositionY()
        if posY == self._scroll_view_posy then
            return
        end
        self._scroll_view_posy = posY

        local size = self._scroll_view:getContentSize()
        state_machine.excute("sm_player_change_head_page_one_update_cells", 0, {posY + self._page_one_offsety, size})
        state_machine.excute("sm_player_change_head_page_two_update_cells", 0, {posY, size})
    end
end

function SmPlayerSystemSetChangeHead:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_change_head.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_system_set_change_head_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    -- DSC重塑
    local Button_8 = ccui.Helper:seekWidgetByName(root, "Button_8")
    local Button_8_0 = ccui.Helper:seekWidgetByName(root, "Button_8_0")
    if __lua_project_id == __lua_project_l_digital and Button_8 ~= nil and Button_8_0 ~= nil then 
        fwin:addTouchEventListener(Button_8,nil, 
        {
            terminal_name = "sm_player_change_head_page_change_page",     
            terminal_state = 0, 
            m_type = 1,
            isPressedActionEnabled = false
        }, 
        nil, 0)

        fwin:addTouchEventListener(Button_8_0,nil, 
        {
            terminal_name = "sm_player_change_head_page_change_page",     
            terminal_state = 0, 
            m_type = 2,
            isPressedActionEnabled = false
        }, 
        nil, 0)

        self:onUpdataDrawNew(1)
    else
        self:onUpdataDraw()
    end
end

function SmPlayerSystemSetChangeHead:onExit()
    state_machine.remove("sm_player_change_head_page_change_page")
    state_machine.remove("sm_player_change_head_page_select_pic")
end
