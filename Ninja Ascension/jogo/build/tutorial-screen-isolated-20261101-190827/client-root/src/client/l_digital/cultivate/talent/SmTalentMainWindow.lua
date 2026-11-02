-----------------------------
-- 天赋主界面
-----------------------------
SmTalentMainWindow = class("SmTalentMainWindowClass", Window)

--打开界面
local sm_talent_main_window_open_terminal = {
	_name = "sm_talent_main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local function requestCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        		if fwin:find("SmTalentMainWindowClass") == nil then
        			fwin:open(SmTalentMainWindow:new():init(), fwin._ui)		
        		end
            end
        end
        --if _ED.digital_talent_state_info == nil then 
        --protocol_command.ship_talent_init.param_list = 
            NetworkManager:register(protocol_command.ship_talent_init.code, nil, nil, nil, nil, requestCallBack, false, nil) 
        -- else
        --     if fwin:find("SmTalentMainWindowClass") == nil then
        --         fwin:open(SmTalentMainWindow:new():init(), fwin._ui)        
        --     end 
        -- end 
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_talent_main_window_close_terminal = {
	_name = "sm_talent_main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("notification_center_update", 0, "push_notification_cultivate_talent")
        fwin:close(fwin:find("UserTopInfoAClass"))
		fwin:close(fwin:find("SmTalentMainWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_main_window_open_terminal)
state_machine.add(sm_talent_main_window_close_terminal)
state_machine.init()

function SmTalentMainWindow:ctor()
	self.super:ctor()
	self.roots = {}
    self.page_index = 1
    self.page_group = {}
    self.page_creat_machine = {}
    self.page_image = {}
    self.page_image_other = {} 
    app.load("client.l_digital.cultivate.talent.SmTalentPageOne")
    app.load("client.l_digital.cultivate.talent.SmTalentPageTwo")
    app.load("client.l_digital.cultivate.talent.SmTalentPageThree")
    app.load("client.l_digital.cultivate.talent.SmTalentPageFour")
    app.load("client.l_digital.cultivate.talent.SmTalentDetailInfo")
    app.load("client.l_digital.cultivate.talent.SmTalentOneKeyUp")
    app.load("client.l_digital.cultivate.talent.SmTalentRuler")
    app.load("client.l_digital.cultivate.talent.SmTalentResetPoint")
    app.load("client.l_digital.cultivate.talent.sm_talent_cell")
    app.load("client.l_digital.cultivate.talent.sm_talent_four_cell")


    local function init_sm_talent_main_window_terminal()
        local sm_talent_main_window_change_page_terminal = {
            _name = "sm_talent_main_window_change_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.page_index = tonumber(params._datas._page)
                instance:changePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_talent_main_window_updata_terminal = {
            _name = "sm_talent_main_window_updata",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_talent_main_up_updata_terminal = {
            _name = "sm_talent_main_up_updata",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local Text_tip = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_tip")
                    local number = 0
                    for i,v in pairs(_ED.digital_talent_page_use_point_array) do
                        number = number + tonumber(v)
                    end
                    local strs = string.format(_new_interface_text[214], number)
                    Text_tip:setString(strs)
                    instance:onUpdateDrawTalentPoint()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_talent_main_window_reset_point_terminal = {
            _name = "sm_talent_main_window_reset_point",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local allTalentPoint = 0
                for i ,v in pairs(_ED.digital_talent_page_use_point_array) do
                    allTalentPoint = allTalentPoint + tonumber(v)
                end
                if allTalentPoint == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[174])
                    return
                end
                state_machine.excute("sm_talent_reset_point_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_talent_main_window_change_page_terminal)
        state_machine.add(sm_talent_main_window_updata_terminal)
        state_machine.add(sm_talent_main_window_reset_point_terminal)
        state_machine.add(sm_talent_main_up_updata_terminal)

        state_machine.init()
    end
    init_sm_talent_main_window_terminal()
end

function SmTalentMainWindow:changePage()
    local root = self.roots[1]
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    -- else
        local Panel_tab = ccui.Helper:seekWidgetByName(root,"Panel_tab")
        for i = 1 , 4 do
            if i == self.page_index then
                if self.page_group[i] ~= nil then
                    self.page_group[i]:setVisible(true)
                else
                    self.page_group[i] = state_machine.excute(self.page_creat_machine[i],0,"")
                    Panel_tab:addChild(self.page_group[i])
                end
                self.page_image[i]:setVisible(true)
                if self.page_image_other[i] ~= nil then
                    self.page_image_other[i]:setVisible(true)
                end
            else
                if self.page_group[i] ~= nil then
                    self.page_group[i]:setVisible(false)
                end
                self.page_image[i]:setVisible(false)
                if self.page_image_other[i] ~= nil then
                    self.page_image_other[i]:setVisible(false)
                end
            end
        end
    -- end
end

function SmTalentMainWindow:onUpdateDrawTalentPoint()
    local root = self.roots[1]
    --天赋点
    local Text_tfd_n = ccui.Helper:seekWidgetByName(root,"Text_tfd_n")
    Text_tfd_n:setString(zstring.tonumber(_ED.user_info.talent_point))
end

function SmTalentMainWindow:onUpdateDraw()
    local root = self.roots[1]
    --天赋点
    local Text_tfd_n = ccui.Helper:seekWidgetByName(root,"Text_tfd_n")
    Text_tfd_n:setString(zstring.tonumber(_ED.user_info.talent_point))
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    --     local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_tf")
    --     m_ScrollView:removeAllChildren(true)
    --     local panel = m_ScrollView:getInnerContainer()
    --     panel:setContentSize(m_ScrollView:getContentSize())
    --     panel:setPosition(cc.p(0,0))
    --     panel:removeAllChildren(true)
    --     local sSize = panel:getContentSize()
    --     local sHeight = sSize.height
    --     local sWidth = sSize.width
    --     local controlSize = m_ScrollView:getInnerContainerSize()
    --     local nextY = sSize.height
    --     local nextX = sSize.width
    --     local tHeight = 0
    --     local cellHeight = 0
    --     local tWidth = 0
    --     local wPosition = 0
    --     local Hlindex = 0
    --     local number = 3
    --     local m_number = math.ceil(number/3)
    --     cellHeight = m_ScrollView:getContentSize().height
    --     sHeight = math.max(sHeight, cellHeight)
    --     local first = nil
    --     local index = 1
    --     local maxWidth = 0
    --     for i=1, 3 do
    --         local cell = state_machine.excute(self.page_creat_machine[i],0,"")
    --         panel:addChild(cell)
    --         index = index + 1
    --         cell:setPosition(cc.p(tWidth,tHeight))
    --         tWidth = tWidth + ccui.Helper:seekWidgetByName(cell.roots[1],"root"):getContentSize().width
    --         maxWidth = maxWidth + ccui.Helper:seekWidgetByName(cell.roots[1],"root"):getContentSize().width
    --     end
    --     -- panel:setContentSize(maxWidth, sHeight)
    --     m_ScrollView:setInnerContainerSize(cc.size(maxWidth, sHeight))
    --     m_ScrollView:jumpToTop()
    -- else
        -- local data = _ED.digital_talent_state_info
        --datas里的内容是“数码天赋Id:等级,附加参数|....”
        --图标
        for i = 1 , 4 do
            local Panel_tf_icon_tab = ccui.Helper:seekWidgetByName(root,"Panel_tf_icon_tab_"..i)
            Panel_tf_icon_tab:removeAllChildren(true)
            local Panel_tf_icon_tab1 = ccui.Helper:seekWidgetByName(root,"Panel_tf_icon_tab_"..(i + 4))
            if _ED.digital_talent_page_is_lock[i] == true then
                display:gray(self.page_image[i])
                if self.page_image_other[i] ~= nil then
                    display:gray(self.page_image_other[i])
                end
            else
                display:ungray(self.page_image[i])
                if self.page_image_other[i] ~= nil then
                    display:ungray(self.page_image_other[i])
                end
            end
            local cell = state_machine.excute("sm_talent_cell_creat",0,{0, i})
            Panel_tf_icon_tab:addChild(cell)
            if Panel_tf_icon_tab1 ~= nil then
                Panel_tf_icon_tab1:removeAllChildren(true)
                local cell1 = state_machine.excute("sm_talent_cell_creat",0,{0, i})
                Panel_tf_icon_tab1:addChild(cell1)
            end
        end
    -- end

    local Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")
    local number = 0
    for i,v in pairs(_ED.digital_talent_page_use_point_array) do
        number = number + tonumber(v)
    end
    local strs = string.format(_new_interface_text[214], number)
    Text_tip:setString(strs)
end

function SmTalentMainWindow:init()
	self:onInit()
    return self
end

function SmTalentMainWindow:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_talent_main_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --重置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chongzhi"), nil, 
    {
        terminal_name = "sm_talent_main_window_reset_point", 
        terminal_state = 0
    }, nil, 0)

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help"), nil, 
    {
        terminal_name = "sm_talent_ruler_open", 
        terminal_state = 0
    }, nil, 0)
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    -- else
        for i = 1 , 4 do
            local Image_tab_bg = ccui.Helper:seekWidgetByName(root,"Image_tab_bg_"..i)
            fwin:addTouchEventListener(Image_tab_bg, nil, 
            {
                terminal_name = "sm_talent_main_window_change_page", 
                terminal_state = 0,
                _page = i,
            }, nil, 0)
            -- Panel_tf_icon_tab:setTouchEnabled(true)
        end
        for i = 5 , 7 do
            local Image_tab_bg = ccui.Helper:seekWidgetByName(root,"Image_tab_bg_"..i)
            fwin:addTouchEventListener(Image_tab_bg, nil, 
            {
                terminal_name = "sm_talent_main_window_change_page", 
                terminal_state = 0,
                _page = i - 4,
            }, nil, 0)
            -- Panel_tf_icon_tab:setTouchEnabled(true)
        end
    -- end

    ccui.Helper:seekWidgetByName(root,"Image_bg"):setTouchEnabled(true)
    self.page_creat_machine = {
        "sm_talent_page_one_open",
        "sm_talent_page_two_open",
        "sm_talent_page_three_open",
        "sm_talent_page_four_open",
    }
    local Panel_gj = ccui.Helper:seekWidgetByName(root,"Panel_gj")
    local Panel_dj = ccui.Helper:seekWidgetByName(root,"Panel_dj")
    self.page_image = {
        Panel_gj:getChildByName("Sprite_tab_1"),
        Panel_gj:getChildByName("Sprite_tab_2"),
        Panel_gj:getChildByName("Sprite_tab_3"),
        Panel_gj:getChildByName("Sprite_tab_4"),
    }
    self.page_image_other = {
        Panel_dj:getChildByName("Sprite_tab_5"),
        Panel_dj:getChildByName("Sprite_tab_6"),
        Panel_dj:getChildByName("Sprite_tab_7"),
    }
    self:onUpdateDraw()
	self:changePage()

    Panel_gj:setVisible(false)
    Panel_dj:setVisible(false)
    local needlevel = 0
    for i=1, table.getn(dms["ship_talent_group"]) do
        needlevel = dms.int(dms["ship_talent_group"], i, ship_talent_group.show_level)
    end
    if zstring.tonumber(_ED.user_info.user_grade) >= needlevel then
        Panel_gj:setVisible(true)
    else
        Panel_dj:setVisible(true)
    end
	
    local userinfo = UserTopInfoA:new()
    local info = fwin:open(userinfo,fwin._view)
end

function SmTalentMainWindow:onEnterTransitionFinish()
    
end

function SmTalentMainWindow:onExit()
	state_machine.remove("sm_talent_main_window_change_page")
    state_machine.remove("sm_talent_main_window_updata")
    state_machine.remove("sm_talent_main_window_reset_point")
end

