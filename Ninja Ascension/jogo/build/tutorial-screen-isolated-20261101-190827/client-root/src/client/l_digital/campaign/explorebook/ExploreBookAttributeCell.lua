-- ----------------------------------------------------------------------------------------------------
-- 说明：图鉴属性
-------------------------------------------------------------------------------------------------------

ExploreBookAttributeCell = class("ExploreBookAttributeCellClass", Window)

--打开界面
local explore_book_attribute_cell_open_terminal = {
	_name = "explore_book_attribute_cell_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if nil == fwin:find("ExploreBookAttributeCellClass") then
            fwin:open(ExploreBookAttributeCell:new():init(params), fwin._view)
        end 
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(explore_book_attribute_cell_open_terminal)
state_machine.init()

function ExploreBookAttributeCell:ctor()
    self.super:ctor()
	self.roots = {}
    _ED.allIcons = {}

    app.load("client.l_digital.campaign.explorebook.ExploreBookListCell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookListDataCell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPage")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPageTwo")
    app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPageThree")
    app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPageInfo")

	local function init_fileIsland_friends_terminal()
		--关闭界面
		local Button_closed_terminal = {
			_name = "Button_closed",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(fwin:find("ExploreBookAttributeCellClass"))
                state_machine.excute("explore_book_updata_icon", 0, "")   --by zy
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

        -- 刷新信息
		local explore_book_refreshListView_terminal = {
            _name = "explore_book_refreshListView",
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

        -- 刷新按钮状态
        local explore_book_button_status_refresh_terminal = {
            _name = "explore_book_button_status_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateButtonStatus()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--激活界面
		local Button_boss_activation_name_terminal = {
		    _name = "Button_boss_activation_name",
		    _init = function (terminal)
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
                --local cells = params._datas.cells
                local idx = params._datas.idx
                local ids = params._datas.ids
                local exploration_book_item = dms.string(dms["explore_achievement_tree_mould"],ids,3)
                local item_data_n = zstring.split(exploration_book_item,"|")
                local universalId = dms.int(dms["shop_config"], 5 , shop_config.param)
                local _max_select_num = zstring.tonumber(getPropAllCountByMouldId(universalId))
                for k, v in pairs(item_data_n) do
                    local item_data = zstring.split(v,",")
                    -- if tonumber(item_data[1]) == 6 then             
                    --     if tonumber(_max_select_num) < tonumber(item_data[3])  then
                    --         TipDlg.drawTextDailog(_new_interface_text[27])
                    --         return
                    --     end
                    -- end

                    if tonumber(item_data[1]) == 1 then
                        if tonumber(_ED.user_info.user_silver) < tonumber(item_data[3]) then
                            TipDlg.drawTextDailog(_string_piece_info[128])  
                            return 
                        end
                    end
                end		        
		        local function responseGrowPlanPurchaseCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                if response.node ~= nil and response.node.roots[1] ~= nil then
                            instance:onUpdateDrawData()
                            instance:onUpdateDraw()
		                end 
		            end
		        end
		        protocol_command.exlore_achievement_unlock.param_list = ""..ids
		        NetworkManager:register(protocol_command.exlore_achievement_unlock.code, nil, nil, nil, instance, responseGrowPlanPurchaseCallback, false, nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		-- 升级界面
		local Button_book_lv_up_name_terminal = {
		    _name = "Button_book_lv_up_name",
		    _init = function (terminal)
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
                --local cells = params._datas.cells
                local idx = params._datas.idx
                local ids = params._datas.ids
                local row = params._datas.row
                --state_machine.excute("explore_book_attribute_cell_page_icon_uplvani", 0,{ids,idx})

                local exploration_book_item = dms.string(dms["explore_achievement_talent_mould"],ids,5)
                local item_data_n = zstring.split(exploration_book_item,"|")
                local universalId = dms.int(dms["shop_config"], 5 , shop_config.param)
                local _max_select_num = zstring.tonumber(getPropAllCountByMouldId(universalId))
                for k, v in pairs(item_data_n) do
                    local item_data = zstring.split(v,",")
                    -- if tonumber(item_data[1]) == 6 then            
                    --     if tonumber(_max_select_num) < tonumber(item_data[3]) then
                    --         TipDlg.drawTextDailog(_new_interface_text[27])
                    --         return
                    --     end
                    -- end

                    if tonumber(item_data[1]) == 1 then
                        if tonumber(_ED.user_info.user_silver) < tonumber(item_data[3]) then
                            TipDlg.drawTextDailog(_string_piece_info[128])  
                            return 
                        end
                    end
                end

		        local function responseGrowPlanPurchaseCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                if response.node ~= nil and response.node.roots[1] ~= nil then
                            instance:onUpdateDraw()
                            --instance:onUpdateDrawData()
                            state_machine.excute("explore_book_main_up_updata", 0, "")
                            state_machine.excute("explore_book_attribute_cell_page_icon_uplvani", 0,{ids, idx, row})
                            state_machine.excute("explore_book_attribute_cell_page_icon_lock_anim", 0, nil)
		                end
		            end
		        end
		        protocol_command.explore_achievement_level_up_talent.param_list = ""..ids.."\r\n"..idx
		        NetworkManager:register(protocol_command.explore_achievement_level_up_talent.code, nil, nil, nil, instance, responseGrowPlanPurchaseCallback, false, nil)
                   
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		state_machine.add(Button_closed_terminal)
        state_machine.add(explore_book_refreshListView_terminal)
        state_machine.add(Button_boss_activation_name_terminal)
        state_machine.add(Button_book_lv_up_name_terminal)
        state_machine.add(explore_book_button_status_refresh_terminal)

		state_machine.init()
	end

	init_fileIsland_friends_terminal()
end

function ExploreBookAttributeCell:onUpdateDraw()
	local root = self.roots[1]
    local btn_show = 1
    local book_talent_level = nil
    local curr_max_id = 0
    local curr_max_level = 1
    local row = 1

    local book_data_id = zstring.split(dms.string(dms["explore_achievement_tree_mould"],self.dataID,4),",")

    local book_data_max_id = nil
    for i, v in pairs(book_data_id) do
        book_data_max_id = tonumber(v)
    end

    for i, v in pairs(_ED.explore_book_data.telent.information) do
        curr_max_id = v.id
        curr_max_level = v.level
        if i == 1 then
            curr_min_id = v.id
        end
    end

    if tonumber(book_data_id[1]) > curr_max_id then
        curr_max_id = tonumber(book_data_id[1])
        curr_max_level = nil
    elseif book_data_max_id < curr_min_id then
        curr_max_id = tonumber(book_data_id[1])
        curr_max_level = nil
        book_talent_level = nil
    else
        for i, v in pairs(_ED.explore_book_data.telent.information) do
            if v.id <= book_data_max_id then
                if tonumber(book_data_id[1]) <= v.id then
                    if v.id then
                        curr_max_id = v.id
                        curr_max_level = v.level
                        book_talent_level = v.level
                    end
                else
                    curr_max_id = tonumber(book_data_id[1])
                    curr_max_level = nil
                    book_talent_level = nil
                end
            end
        end
    end

    if curr_max_level == nil then
        curr_max_id = curr_max_id
        for i= 1,#(_ED.explore_book_data.tree)do
            if tonumber(_ED.explore_book_data.tree[i] )== tonumber(self.dataID) then
               book_talent_level = 1
            end
        end
    elseif curr_max_level == 1 then
        curr_max_id = curr_max_id
        book_talent_level = 2
    elseif curr_max_level == 2 then
        curr_max_id = curr_max_id + 1
        book_talent_level = 1
    end


    local book_idx_id = zstring.split(dms.string(dms["explore_achievement_tree_mould"],self.dataID,4),",")
    local data = {}    
    for k, v in pairs(book_idx_id) do
        local talent_info_data = dms.searchs(dms["explore_achievement_talent_mould"], 1, tonumber(v))
        if talent_info_data ~= nil then
            for j , w in pairs(talent_info_data) do
                local info = {}
                info.idx = tonumber(w[1])
                if curr_max_id >= tonumber(w[1]) then
                    table.insert(data,info)
                end
            end
        end
    end
    row = math.ceil(#data / 4)

    local book_talent_id_info = dms.searchs(dms["explore_achievement_talent_mould"], 2, curr_max_id)
    local book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],self.page,5),",")
    local book_name = dms.string(dms["explore_achievement_tree_mould"],book_id_n[self.index],2)
    local book_tree_id_info = dms.searchs(dms["explore_achievement_tree_mould"], 1, book_id_n[self.index])

    local talent_info = {}
    if book_talent_level == nil then
        talent_info = book_tree_id_info
    else
        if book_talent_id_info then
            for j, k in pairs(book_talent_id_info) do
                if tonumber(k[3]) == book_talent_level then
                    table.insert(talent_info,k)
                end
            end
        end
    end
    local word_info_name = nil
    local word_info_intro = nil
    local word_info = dms.element(dms["word_mould"], book_name)
    if book_talent_level == nil then
        word_info_name = word_info
    else
        if talent_info[1] then
            word_info_name = dms.element(dms["word_mould"], tonumber(talent_info[1][4]))
            word_info_intro = dms.element(dms["word_mould"], tonumber(talent_info[1][11]))
        end
    end
	local Text_open_day_0 = ccui.Helper:seekWidgetByName(root, "Text_open_day_0")

    if word_info ~= nil then
        Text_open_day_0:setString(word_info[3])
    end

    local Text_open_day_0_0 = ccui.Helper:seekWidgetByName(root, "Text_open_day_0_0")
    if book_talent_level == nil then
        Text_open_day_0_0:setString(word_info_name[3])
    else
        Text_open_day_0_0:setString(word_info_name[3]..":"..word_info_intro[3])
    end

    local Panel_talent_icon = ccui.Helper:seekWidgetByName(root,"Panel_talent_icon")
    Panel_talent_icon:removeAllChildren(true)
    if book_talent_level ~= nil and talent_info ~= nil then
        local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..tonumber(talent_info[1][9]))
        local currSprite = cc.Sprite:create(spriteImage)
        currSprite:setAnchorPoint(0,0)
        Panel_talent_icon:addChild(currSprite)
    end

    local ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    ListView_2:removeAllChildren(true)
    local item_info = talent_info[1][5]
    if book_talent_level == nil then
        item_info = talent_info[1][3]
    end

    local item_data_n = zstring.split(item_info,"|")
    for k, v in pairs(item_data_n) do
        local item_data = zstring.split(v,",")
        local needPropIcon = ResourcesIconCell:createCell()
        needPropIcon:init(tonumber(item_data[1]), tonumber(item_data[3]), tonumber(item_data[2]), nil,nil,true,true,1)
        ListView_2:addChild(needPropIcon)
    end

    local Button_boss_up = ccui.Helper:seekWidgetByName(root, "Button_boss_up")
    local Button_boss_activation = ccui.Helper:seekWidgetByName(root, "Button_boss_activation")

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_boss_activation"), nil, 
    {
        terminal_name = "Button_boss_activation_name", 
        terminal_state = 0, 
        touch_black = true,
        idx = curr_max_id,
        ids = self.dataID
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_boss_up"), nil, 
    {
        terminal_name = "Button_book_lv_up_name", 
        terminal_state = 0, 
        touch_black = true,
        idx = curr_max_id,
        row = row,
        ids = self.dataID
    }, nil, 3)


    local Button_exploration_book_activation = ccui.Helper:seekWidgetByName(root, "Button_boss_activation")
    local Button_exploration_book_up = ccui.Helper:seekWidgetByName(root, "Button_boss_up")

    self:onUpdateButtonStatus()
    self:onUpdateBottomShow(book_data_max_id)
end

function ExploreBookAttributeCell:onUpdateButtonStatus()
    local root = self.roots[1]
    local Button_exploration_book_activation = ccui.Helper:seekWidgetByName(root, "Button_boss_activation")
    local Button_exploration_book_up = ccui.Helper:seekWidgetByName(root, "Button_boss_up")

    -- 主界面修改进属性界面激活和升级
    if _ED.explore_book_data.tree ==  nil then
        Button_exploration_book_up:setVisible(false)
        Button_exploration_book_activation:setVisible(true)
    else
        local function sortFunction(a, b)
            return a > b
        end
        Button_exploration_book_up:setVisible(false)
        Button_exploration_book_activation:setVisible(true)
        for i= 1,#(_ED.explore_book_data.tree)do
            if tonumber(_ED.explore_book_data.tree[i] )== tonumber(self.dataID) then
                Button_exploration_book_up:setVisible(true)
                Button_exploration_book_activation:setVisible(false)
            end
        end
    end
end

function ExploreBookAttributeCell:onUpdateBottomShow(max_id)
    local root = self.roots[1]
    local Text_open_day_0_0 = ccui.Helper:seekWidgetByName(root, "Text_open_day_0_0")
    local ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    local Button_boss_up = ccui.Helper:seekWidgetByName(root, "Button_boss_up")
    local Button_boss_activation = ccui.Helper:seekWidgetByName(root, "Button_boss_activation")
    local Button_boss_battle = ccui.Helper:seekWidgetByName(root, "Button_boss_battle")
    local Panel_talent_icon = ccui.Helper:seekWidgetByName(root, "Panel_talent_icon")
    local Image_holy_right_icon_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_bg_1")
    for i, v in pairs(_ED.explore_book_data.telent.information) do
        if v.id == max_id then
            if v.level == 2 then
                Text_open_day_0_0:setVisible(false)
                ListView_2:setVisible(false)
                Button_boss_up:setVisible(false)
                Button_boss_activation:setVisible(false)
                Panel_talent_icon:setVisible(false)
                Button_boss_battle:setVisible(false)
                Image_holy_right_icon_bg_1:setVisible(false)
            end
        end
    end
end

function ExploreBookAttributeCell:onUpdateDrawData()
    local book_idx_id = zstring.split(dms.string(dms["explore_achievement_tree_mould"],self.dataID,4),",")
    local data = {}  
    local book_id_max = 1   
    for k, v in pairs(book_idx_id) do
        book_id_max = v
        local talent_info = dms.searchs(dms["explore_achievement_talent_mould"], 1, tonumber(v))
        if talent_info ~= nil then
            for j , w in pairs(talent_info) do
                local info = {}
                info.idx = tonumber(w[1])
                table.insert(data,info)
            end
        end
    end

    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
    m_ScrollView:removeAllChildren(true)
    local cellCount = math.ceil(#data / 4)
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
    local wPosition = sWidth/1
    local Hlindex = 0
    local number = math.ceil((#book_idx_id)/4)
    local m_number = math.ceil(number/1)
    cellHeight = m_number*172
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    for i= 1, cellCount do
        local cell = ExploreBookAttributeCellPageTwo:createCell()
        local cellData = {}
        for j = 1, 4 do
            local single = data[j + 4 * (i - 1)]
            if single then
                single.maxNum = book_id_max 
                table.insert(cellData, single)
            end
        end
        cell:init(cellData, i, self.dataID,data)
        panel:addChild(cell)

        if cell_size == nil then
            cell_size = cell:getContentSize()
        end

        cell_height = cell:getContentSize().height
        tWidth = tWidth + wPosition
        if (index-1)%1 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - cell_height*Hlindex  
        end
        if index <= 1 then
            tHeight = sHeight - cell_height
        end
        cell:setPosition(cc.p(tWidth,tHeight))
        index = index + 1
    end

    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()

    self.listView2 = m_ScrollView
    self.list_view_2_posY = m_ScrollView:getInnerContainer():getPositionY()

    --self._cell_group = cell_group
    self._cell_size = cell_size
end


-- mei帧刷新
function ExploreBookAttributeCell:onUpdateLeftListView()
	if self.listView ~= nil then
	    local size = self.listView:getContentSize()
	    local posY = self.listView:getInnerContainer():getPositionY()
	    if self.list_view_posY == posY then
	        return
	    end

	    self.list_view_posY = posY
	    local items = self.listView:getItems()

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

-- 每帧刷新
function ExploreBookAttributeCell:onUpdateRightListView()
	if self.listView2 ~= nil then
	    local size = self.listView2:getContentSize()
	    local posY = self.listView2:getInnerContainer():getPositionY()
	    if self.list_view_2_posY == posY then
	        return
	    end

	    self.list_view_2_posY = posY

        local items = self._cell_group
        local itemSize = self._cell_size
        for i, v in pairs(items) do
            if v ~= nil and tolua.isnull(v) == false then
                if v ~= nil then
                    local tempY = v:getPositionY() + posY
                    if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                        v:unload()
                    else
                        v:reload()
                    end
                end
            end
        end
    else
        if self._scroll_view ~= nil then
            local posY = self._scroll_view:getInnerContainer():getPositionY()
            if posY == self._scroll_view_posy then
                return
            end
            self._scroll_view_posy = posY

            local size = self._scroll_view:getContentSize()
            local items = self._cell_group
            local itemSize = self._cell_size
            for i, v in pairs(items) do
                if v ~= nil and tolua.isnull(v) == false then
                    if v ~= nil then
                        local tempY = v:getPositionY() + posY
                        if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                            v:unload()
                        else
                            v:reload()
                        end
                    end
                end
            end
        end
    end
end

function ExploreBookAttributeCell:onUpdate(dt)
	--self:onUpdateLeftListView()
	--self:onUpdateRightListView()
end

function ExploreBookAttributeCell:onInit()
	local csb_explore_friend_task = csb.createNode("campaign/exploration/exploration_book_add.csb")
	local root = csb_explore_friend_task:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_friend_task)

    local Image_holy_right_icon_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_bg_1")
    Image_holy_right_icon_bg_1:setVisible(false)
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "Button_closed", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDrawData()
	self:onUpdateDraw()
   
    -- 顶部用户信息
	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop") 					
	local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	-- self:registerOnNodeEvent(self)
	-- self:registerOnNoteUpdate(self, 1)
end

function ExploreBookAttributeCell:init(params)
    self.page = params[1]   -- 第一层信息
    self.dataID = params[2] or 1    -- 第一层第几个按钮
    self.index = params[3]
	self:onInit()
	return self
end

function ExploreBookAttributeCell:onExit()
	--state_machine.remove("fileIsland_holy_thing_close")
end

