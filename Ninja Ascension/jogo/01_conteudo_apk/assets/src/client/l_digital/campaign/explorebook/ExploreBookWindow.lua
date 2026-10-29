-----------------------------
-- 图鉴主界面
-----------------------------
ExploreBookWindow = class("ExploreBookWindowClass", Window)

--打开界面
local explore_book_window_open_terminal = {
	_name = "explore_book_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if nil == fwin:find("ExploreBookWindowClass") then
            fwin:open(ExploreBookWindow:new():init(params), fwin._view)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local explore_book_window_close_terminal = {
	_name = "explore_book_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ExploreBookWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(explore_book_window_open_terminal)
state_machine.add(explore_book_window_close_terminal)
state_machine.init()

function ExploreBookWindow:ctor()
	self.super:ctor()
	self.roots = {}
    self.page = 1
    self.page_group = {}
    self.page_creat_machine = {}
    self.page_image = {}
    self.page_image_other = {} 
    self.listView = nil
    app.load("client.l_digital.campaign.explorebook.ExploreBookListCell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookListDataCell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookRuleWindow")

    local function init_explore_book_main_window_terminal()
        local explore_book_main_window_change_page_terminal = {
            _name = "explore_book_main_window_change_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance.page_index = tonumber(params._datas._page)
                -- instance:changePage()
                self.page = tonumber(params)
                instance:onUpdateDrawData()
                instance:updateButtonStatus()
                return true
                --local page = SmShopTab:new():init(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local explore_book_main_window_updata_terminal = {
            _name = "explore_book_main_window_updata",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --instance:onUpdateDraw()
                state_machine.excute("explore_book_list_cell_refush", 0, "")
                instance:onUpdateDrawData()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local explore_book_main_up_updata_terminal = {
            _name = "explore_book_main_up_updata",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
              -- instance:onUpdateDraw()   --by zy
               instance:onUpdateDrawTalentInfo()

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
                -- local allTalentPoint = 0
                -- for i ,v in pairs(_ED.digital_talent_page_use_point_array) do
                --     allTalentPoint = allTalentPoint + tonumber(v)
                -- end
                -- if allTalentPoint == 0 then
                --     TipDlg.drawTextDailog(_new_interface_text[174])
                --     return
                -- end
                -- state_machine.excute("sm_talent_reset_point_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local button_explore_book_attribute_info_terminal = {
            _name = "button_explore_book_attribute_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    -- local Image_buff_view = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_buff_view")
                    -- local Text_buff = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_buff")
                    -- Image_buff_view:setVisible(true)
                    -- Text_buff:setString("属性信息")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --by zy
        local explore_book_updata_icon_terminal = {
            _name = "explore_book_updata_icon",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
              instance:updateIion()
              instance:updateDrawBuffInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --by zy 刷新激活按钮
        local explore_book_updata_bt_terminal = {
            _name = "explore_book_updata_bt",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
              instance:updateBt()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- local explore_book_window_rule_terminal = {
        --     _name = "explore_book_window_rule",
        --     _init = function (terminal)
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)

        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }

        state_machine.add(explore_book_main_window_change_page_terminal)
        state_machine.add(explore_book_main_window_updata_terminal)
        state_machine.add(sm_talent_main_window_reset_point_terminal)
        state_machine.add(explore_book_main_up_updata_terminal)
        state_machine.add(button_explore_book_attribute_info_terminal)
        state_machine.add(explore_book_updata_icon_terminal)
        state_machine.add(explore_book_updata_bt_terminal)
        --state_machine.add(explore_book_window_rule_terminal)
        
        state_machine.init()
    end
    init_explore_book_main_window_terminal()
end

function ExploreBookWindow:changePage()
    local root = self.roots[1]
    local Panel_tab = ccui.Helper:seekWidgetByName(root,"Panel_tab")
    for i = 1 , 4 do
        -- if i == self.page_index then
        -- else
        -- end
    end
end

function ExploreBookWindow:onUpdateDrawTalentInfo()
    local root = self.roots[1]                                             
    local Text_exploration_book_lv_n = ccui.Helper:seekWidgetByName(root,"Text_exploration_book_lv_all_n")
    -- if _ED.explore_book_data.countLevel then
    --    Text_exploration_book_lv_n:setString("Lv".._ED.explore_book_data.countLevel)
    -- end    by zy 没有及时刷新   
    if _ED.explore_book_data ~= nil then
        if _ED.explore_book_data.countLevel == nil then
            Text_exploration_book_lv_n:setString("Lv".."0")
        else
            Text_exploration_book_lv_n:setString("Lv".._ED.explore_book_data.countLevel)
        end
    end

    local Text_exploration_book_title = ccui.Helper:seekWidgetByName(root,"Text_exploration_book_title")
    if _ED.explore_book_data ~= nil then
        local title_mould_id = nil
        if tonumber(_ED.explore_book_data.title) == nil then
            title_mould_id = 1
        else
            title_mould_id = tonumber(_ED.explore_book_data.title)
        end
        local title_mould_info = dms.searchs(dms["explore_achievement_title_mould"], 1, title_mould_id)
        local word_info = dms.element(dms["word_mould"], tonumber(title_mould_info[1][2])) 
        Text_exploration_book_title:setString(word_info[3])
    end
end

function ExploreBookWindow:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_commodity = ccui.Helper:seekWidgetByName(root, "ListView_btn")
    ScrollView_commodity:removeAllChildren(true)
    local show_group = {}
    local show_group2 = {}
    local cell_size = nil
    local width_n = math.ceil(#show_group/ 2)
    local index = 1

    local cell_number_mx = dms.float(dms["play_config"], 126, pirates_config.param)
    self.cells= {}
    for i = 1 , (cell_number_mx) do
        local cell = ExploreBookListCell:createCell()
        table.insert(self.cells,cell)

        local show_group = dms.string(dms["explore_achievement_world_mould"],i,2)
        
        local isopen = false --by zy
        local lv = zstring.split(dms.string(dms["explore_achievement_world_mould"],i,4),",")
        if tonumber(_ED.user_info.user_grade) >= tonumber(lv[1]) and _ED.explore_book_data.countLevel >= tonumber(lv[2]) then
          isopen = true
        end
        cell:init(i,isopen,self.page)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
        ScrollView_commodity:addChild(cell)
        cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
        index = index + 1
    end

    if nil ~= cell_size then
        self.roll_width = cell_size.width * 3
        local InnerWidth = math.max(cell_size.width * width_n , ScrollView_commodity:getContentSize().width)
        ScrollView_commodity:getInnerContainer():setContentSize(cc.size(InnerWidth , cell_size.height * 2))
    end
    self._scroll_view = ScrollView_commodity
    self._scroll_view_pox = 99999--ScrollView_commodity:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_commodity:getInnerContainer():getPositionX()

    self:updateButtonStatus()
end

function ExploreBookWindow:updateIion()
    for i,v in pairs(self.cells) do
        local isopen = false --by zy
        local lv = zstring.split(dms.string(dms["explore_achievement_world_mould"],i,4),",")
        if tonumber(_ED.user_info.user_grade) >= tonumber(lv[1]) and _ED.explore_book_data.countLevel >= tonumber(lv[2]) then
          isopen = true
        end
        v:initIcion(isopen)      
    end
end

function ExploreBookWindow:updateButtonStatus()
    for i,v in pairs(self.cells) do
        local Button_exploration_book = ccui.Helper:seekWidgetByName(v.roots[1], "Button_exploration_book")
        if i == self.page then
            Button_exploration_book:setHighlighted(true)
        else
            Button_exploration_book:setHighlighted(false)
        end     
    end
end

function ExploreBookWindow:updateBt()
    if not  _ED.explore_book_data.tree then
        return
    end
end

function ExploreBookWindow:onUpdateDrawData()
    --self.page = page
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_book_box")
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
    local wPosition = sWidth/3
    local Hlindex = 0
    local number = 5
    local m_number = math.ceil(number/3)
    cellHeight = m_number*230 + 40
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    local explore_book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],self.page,5),",")
    for i= 1, (#(explore_book_id_n)) do

        local cell = ExploreBookListDataCell:createCell()
        cell:init(self.page,i,explore_book_id_n[i])
        panel:addChild(cell)
        cell_height = cell:getContentSize().height
        tWidth = tWidth + wPosition
        if (index-1)%3 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - cell_height*Hlindex  
        end
        if index <= 3 then
            tHeight = sHeight - cell_height
        end
        cell:setPosition(cc.p(tWidth,tHeight))
        index = index + 1
    end

    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()
   
end

function ExploreBookWindow:updateDrawBuffInfo()
    --by zy 
    local root = self.roots[1]
    local Text_buff = ccui.Helper:seekWidgetByName(root, "Text_buff")
    local chars = {}
    local char = ""
    local char1 = ""
    local function judgeNums(chars)
        local str3 = ""
        if tonumber(chars) == 0 then
          str3 = skill_attributes_text_tips[1]
        elseif tonumber(chars) == 1 then
          str3 = skill_attributes_text_tips[2]
        elseif tonumber(chars) == 2 then
          str3 = skill_attributes_text_tips[3]  
        end
      return str3
    end
   
    if _ED.explore_book_data.countLevel>= 10 and _ED.explore_book_data.countLevel < 20 then
       chars = zstring.splits(dms.string(dms["explore_achievement_title_mould"], 1, 5),"|",",")
    elseif _ED.explore_book_data.countLevel>= 20 and _ED.explore_book_data.countLevel < 30 then   
       chars = zstring.splits(dms.string(dms["explore_achievement_title_mould"], 2, 5),"|",",")
    elseif  _ED.explore_book_data.countLevel >= 30 then 
       chars = zstring.splits(dms.string(dms["explore_achievement_title_mould"], 3, 5),"|",",")
    end
    for i=1,#chars do
          char = (judgeNums(chars[i][1])).."+  "..chars[i][2].."\n"
          char1 = char1..char
    end
    Text_buff:setString(skill_attributes_text_tips[85].."\n"..char1) 

    if _ED.explore_book_data.countLevel< 10 then
      Text_buff:setString(_new_interface_text[231])
    end  
end

function ExploreBookWindow:init()
	self:onInit()
    return self
end

function ExploreBookWindow:onInit()
    local csbItem = csb.createNode("campaign/exploration/exploration_book.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    app.load("client.player.UserInformationHeroStorage")
    -- 绘制顶部用户信息栏
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_phb_back"), nil, 
    {
        terminal_name = "explore_book_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrt_add_0"), nil, 
    {
        terminal_name = "explore_book_rule_window_open",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:updateDrawBuffInfo()

    local Button_arrt_add = ccui.Helper:seekWidgetByName(root,"Button_arrt_add")
    local Text_buff = ccui.Helper:seekWidgetByName(root,"Text_buff")
    local function buffOnTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == evenType then
            ccui.Helper:seekWidgetByName(root, "Image_buff_view"):setVisible(true)
        elseif ccui.TouchEventType.moved == evenType then
            if __lua_project_id == __lua_project_gragon_tiger_gate
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_digimon_adventure 
                or __lua_project_id == __lua_project_yugioh
                or __lua_project_id == __lua_project_warship_girl_b 
                then
                if __mpoint.x - __spoint.x > 80 
                    or __mpoint.x - __spoint.x < -80 
                    or __mpoint.y - __spoint.y > 50 
                    or __mpoint.y - __spoint.y < -50 
                    then
                    ccui.Helper:seekWidgetByName(root, "Image_buff_view"):setVisible(false)
                end
            end
        elseif ccui.TouchEventType.ended == evenType then
            ccui.Helper:seekWidgetByName(root, "Image_buff_view"):setVisible(false)
        end
    end
    Button_arrt_add:addTouchEventListener(buffOnTouchEvent)


    local book_idx_id = zstring.split(dms.string(dms["explore_achievement_tree_mould"],1,4),",")
    local data = {}     
    for k, v in pairs(book_idx_id) do
        local talent_info = dms.searchs(dms["explore_achievement_talent_mould"], 1, tonumber(v))
        for j , w in pairs(talent_info) do
            local info = {}
            info.index = tonumber(w[1])
            table.insert(data,info)
        end
    end

    local Text_exploration_book_lv_n = ccui.Helper:seekWidgetByName(root,"Text_exploration_book_lv_all_n")
    if _ED.explore_book_data ~= nil then
        if _ED.explore_book_data.countLevel == nil then
            Text_exploration_book_lv_n:setString("Lv".."0")
        else
            Text_exploration_book_lv_n:setString("Lv".._ED.explore_book_data.countLevel)
        end
    end

    local Text_exploration_book_title = ccui.Helper:seekWidgetByName(root,"Text_exploration_book_title")

    local title_mould_id = 1
    if _ED.explore_book_data.countLevel < 20 then
      title_mould_id = 1
    elseif _ED.explore_book_data.countLevel>=20 and _ED.explore_book_data.countLevel <30 then
      title_mould_id = 2
    else
      title_mould_id = 3
    end
 
    local title_mould_info = dms.searchs(dms["explore_achievement_title_mould"], 1, title_mould_id)
    local word_info = dms.element(dms["word_mould"], tonumber(title_mould_info[1][2])) 
    Text_exploration_book_title:setString(word_info[3])

    self:onUpdateDraw()
    self:onUpdateDrawData()
end

function ExploreBookWindow:onEnterTransitionFinish()
    
end

function ExploreBookWindow:onExit()
	state_machine.remove("sm_talent_main_window_change_page")
    state_machine.remove("sm_talent_main_window_updata")
    state_machine.remove("sm_talent_main_window_reset_point")
end

