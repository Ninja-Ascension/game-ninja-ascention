--------------------------------------------------------------------------------------------------------------
--  说明：加入军团主界面
--------------------------------------------------------------------------------------------------------------
UnionJoin = class("UnionJoinClass", Window)

local union_join_open_terminal = {
	_name = "union_join_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil then
			fwin:close(fwin:find("UnionJoinClass"))
			fwin:open(UnionJoin:new():init(params),fwin._view)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_join_close_terminal = {
	_name = "union_join_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil then
			fwin:close(fwin:find("UnionJoinClass"))
			fwin:close(fwin:find("UserInformationShopClass"))
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
-- local union_join_to_union_terminal = {
-- 	_name = "union_join_to_union",
-- 	_init = function (terminal)
		
-- 	end,
-- 	_inited = false,
-- 	_instance = self,
-- 	_state = 0,
-- 	_invoke = function(terminal, instance, params)
-- 		if  _ED.union.union_info ~= nil and _ED.union.union_info ~= "" and _ED.union.union_info.union_id ~= nil and zstring.tonumber(_ED.union.union_info.union_id) > 0 then
-- 			if _ED.union.user_union_info ~= nil and _ED.union.user_union_info ~= "" and zstring.tonumber(_ED.union.user_union_info.union_post) > 0 then
-- 				local root = self.roots[1]
-- 				if root == nil then
-- 					return
-- 				end
-- 				if  fwin:find("UnionJoinClass") ~= nil then
-- 					state_machine.excute("Union_open", 0, "")
-- 					TipDlg.drawTextDailog("加入舰队成功")
-- 				end
-- 			end
-- 		end
-- 		return true
-- 	end,
-- 	_terminal = nil,
-- 	_terminals = nil
-- }
state_machine.add(union_join_open_terminal)
state_machine.add(union_join_close_terminal)
-- state_machine.add(union_join_to_union_terminal)
state_machine.init()
function UnionJoin:ctor()
	self.super:ctor()
	app.load("client.l_digital.union.create.UnionCreate")
	app.load("client.l_digital.union.Union")
	app.load("client.l_digital.union.create.SmUnionFindPage")
	app.load("client.l_digital.union.create.SmUnionFormPage")
	app.load("client.l_digital.union.create.SmUnionJoinPage")
	app.load("client.l_digital.cells.union.union_join_list_cell")
	
	self.roots = {}
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	self.pagecount = 0
	self.listcount = 0
	self.ismore = false
	self.cutType = 1
	self.dataTable = nil
	self.firstnumber = 0
	self.enMoreTimes = 0
	self.isEnd = false
	self._empty = nil
	self.tickTime = 0

	self._current_page = 0
    self._to_join = nil 	--加入
    self._create = nil 		--创建
    self._Find = nil 		--查找

    self.page_number = 0	--记录页码

    self.textTable = {}

	 -- Initialize union join state machine.
    local function init_union_join_terminal()
		
		--返回主页
		local union_join_return_home_terminal = {
            _name = "union_join_return_home",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:cleanView(fwin._view) 
				fwin:close(self)
				if fwin:find("HomeClass") == nil then
					state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_home_page", 
								current_button_name = "Button_home",
								but_image = "Image_home", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
				end
				state_machine.excute("menu_back_home_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_join_to_create_change_page_terminal = {
            _name = "sm_union_join_to_create_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳转创建军团
		local union_join_to_create_terminal = {
            _name = "union_join_to_create",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mcell = params._datas.cell
                state_machine.excute("union_create_open", 0, mcell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--搜索军团
		local union_join_to_look_terminal = {
            _name = "union_join_to_look",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:lookUnion()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--更多
		local union_join_more_terminal = {
            _name = "union_join_more",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local length = #_ED.union.union_list_info
				
				instance:more()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新列表
		local union_join_refresh_terminal = {
            _name = "union_join_refresh",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = params._datas._index
            	if instance.cutType == 2 then
            		if params._datas.btype == 0 then
	            		_ED.union.union_list_info[index].union_appiy = 1
	            		if instance.dataTable ~= nil and instance.dataTable[index] ~= nil then
	            			local isOut = true
	            			for i, v in pairs(instance.dataTable) do
	            				if tonumber(v.union_id) == tonumber(_ED.union.union_list_info[index].union_id) then
	            					v.union_appiy = 1
	            					isOut =false
	            				end
	            			end
		            		--	instance.dataTable[index].union_appiy = 1
		            		if isOut == true then
		            			local long = #instance.dataTable
		            			instance.dataTable[long+1] = _ED.union.union_list_info[index]
		            		end
	            		end
	            		instance:updateDraw()
	            	else
						_ED.union.union_list_info[index].union_appiy = 0
						if instance.dataTable ~= nil and instance.dataTable[index] ~= nil then
	            			--instance.dataTable[index].union_appiy = 0
	            			local isOut = true
	            			for i, v in pairs(instance.dataTable) do
	            				if tonumber(v.union_id) == tonumber(_ED.union.union_list_info[index].union_id) then
	            					v.union_appiy = 0
	            					isOut =false
	            				end
	            			end
		            		--	instance.dataTable[index].union_appiy = 1
		            		if isOut == true then
		            			local long = #instance.dataTable
		            			instance.dataTable[long+1] = _ED.union.union_list_info[index]
		            		end
	            		end
	            	end
            		
            	else
	            	if params._datas.btype == 0 then
	            		if instance.dataTable ~= nil and instance.dataTable[index] ~= nil then
	            			instance.dataTable[index].union_appiy = 1
	            		end
	            		if _ED.union.union_list_info[index] ~= nil then
	            			_ED.union.union_list_info[index].union_appiy = 1
	            		end	
	            		instance:updateDraw()
	            	else
						if instance.dataTable ~= nil and instance.dataTable[index] ~= nil then
	            			instance.dataTable[index].union_appiy = 0
	            		end
	            		if _ED.union.union_list_info[index] ~= nil then
							_ED.union.union_list_info[index].union_appiy = 0
						end	
						instance:updateDraw()
	            	end
	            end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --舰队列表
		local union_join_list_terminal = {
            _name = "union_join_list",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.cutType == 2 then
	            	instance.cutType = 3
	            	instance:updateDraw()
	            end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --gengduo
		local union_join_to_more_terminal = {
            _name = "union_join_to_more",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = params._datas._index
            	instance:more(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

		state_machine.add(union_join_return_home_terminal)
		state_machine.add(union_join_to_create_terminal)
		state_machine.add(union_join_to_look_terminal)
		state_machine.add(union_join_more_terminal)
		state_machine.add(union_join_refresh_terminal)
		state_machine.add(union_join_list_terminal)
		state_machine.add(union_join_to_more_terminal)
		state_machine.add(sm_union_join_to_create_change_page_terminal)

        state_machine.init()
    end
    
    -- call func init union join state machine.
    init_union_join_terminal()

end

function UnionJoin:updataIndex( index,mcell )
	local root = self.roots[1]
	if root == nil then
		return
	end
	UnionJoin.cacheListView:addChild(mcell)
	UnionJoin.cacheListView:removeItem(index-1)
	UnionJoin.cacheListView:requestRefreshView()

end
function UnionJoin:more(index)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.ismore = false
	if self.isEnd == true then
		TipDlg.drawTextDailog(tipStringInfo_union_str[57])
		return
	end
	if  (self.enMoreTimes*5) < tonumber(UnionJoin.asyncIndex) and (self.enMoreTimes*5) < self.firstnumber then

		self.cutType = 3
		self.enMoreTimes = self.enMoreTimes +1
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_01")
		rewardListView:removeItem(index-1)
		self:loading2()
	else
		if self.firstnumber == (self.pagecount + 1)*20 then
			local function responseUnionSearchCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if response.node ~= nil and response.node.roots~=nil  and response.node.roots[1] ~= nil then
						if zstring.tonumber(_ED.union.union_list_sum) == 0 then
							TipDlg.drawTextDailog(tipStringInfo_union_str[57])
							self.isEnd = true
							return
						end
						if _ED.union.union_list_info == nil or _ED.union.union_list_info =="" or self.dataTable == nil then
							return
						end
						local length = #self.dataTable
						for i,v in ipairs(_ED.union.union_list_info) do
							self.dataTable[length+i] = v
						end

						self.pagecount = self.pagecount + 1
						self.cutType = 3
						self.enMoreTimes = self.enMoreTimes+1
						local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_01")
						rewardListView:removeItem(index-1)
						self:loading2()
					end
				end
			end
			local pagecount = self.pagecount + 1
			_ED.union.union_list_info = nil
			protocol_command.union_list.param_list = pagecount
			NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)

		else
			TipDlg.drawTextDailog(tipStringInfo_union_str[57])
		end
	end
end
function UnionJoin:lookUnion()
	self.ismore = false
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
	local str = zstring.exchangeTo(text:getString())

	if text:getString() ~= "" then
		local function responseUnionSearchCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots[1] ~= nil then
					if self._empty ~= nil then
						self._empty:removeFromParent(true)
						self._empty = nil	
					end	
					self.cutType = 2
					response.node:updateDraw()
				end
			end
		end
		-- text:setString("")
		_ED.union.union_list_info = nil
		protocol_command.union_search.param_list = str
		NetworkManager:register(protocol_command.union_search.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
	end
end

function UnionJoin:loading2()
	-- local arry = _ED.union.union_list_info
	-- if self.dataTable ~= nil then
	local arry = self.dataTable
	-- end
	
	for i=UnionJoin.asyncIndex, #arry do
		local cell = Unionjoinlistcell:createCell()
		cell:init(arry[UnionJoin.asyncIndex],UnionJoin.asyncIndex,false)
		UnionJoin.cacheListView:addChild(cell)
		UnionJoin.cacheListView:requestRefreshView()
		UnionJoin.asyncIndex = UnionJoin.asyncIndex + 1
		if  i == (self.enMoreTimes*5) and self.cutType ~= 2 then
			local cell = Unionjoinlistcell:createCell()
			cell:init("",UnionJoin.asyncIndex,true)
			UnionJoin.cacheListView:addChild(cell)
			UnionJoin.cacheListView:requestRefreshView()
			self.ismore = true
			break
		end
	end
	UnionJoin.cacheListView:jumpToBottom()
end
function UnionJoin:loading()
	local function sortfunction( a,b )
		local result = false
		if tonumber(a.union_appiy)  == 1 and tonumber(b.union_appiy) == 0 then
			return true
		end 
		return result
	end
	
	local arry = {}
	local notApplyList = {}
	for k,v in pairs(_ED.union.union_list_info) do
		if tonumber(v.union_appiy) == 1 then
			table.insert(arry, v)
		else
			table.insert(notApplyList, v)
		end
	end
	for k,v in pairs(notApplyList) do
		table.insert(arry, v)
	end
	if self.cutType == 1 then
		
		-- table.sort( arry, sortfunction )
		self.dataTable = arry
		self.firstnumber = #arry
		self.enMoreTimes = 1
	elseif self.cutType == 2 then
	elseif self.cutType == 3 then
		if self.dataTable ~= nil then
			arry = self.dataTable
		end
	end
	self.listcount = #arry
	if self.cutType ~= 1 then
		-- table.sort( arry, sortfunction )
	end
	for i, v in pairs(arry) do
		local cell = Unionjoinlistcell:createCell()
		cell:init(arry[UnionJoin.asyncIndex],UnionJoin.asyncIndex,false)
		UnionJoin.cacheListView:addChild(cell)
		UnionJoin.cacheListView:requestRefreshView()
		UnionJoin.asyncIndex = UnionJoin.asyncIndex + 1
		if  i == (self.enMoreTimes*5) and self.cutType ~= 2 then
			local cell = Unionjoinlistcell:createCell()
			cell:init("",UnionJoin.asyncIndex,true)
			UnionJoin.cacheListView:addChild(cell)
			UnionJoin.cacheListView:requestRefreshView()
			self.ismore = true
			break
		end
	end
	UnionJoin.cacheListView:jumpToTop()
	
end

function UnionJoin:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	-- ListView_01_su0 TextField_1
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_01")	
	-- local morebutton = ccui.Helper:seekWidgetByName(root, "Panel_list_more")	
	-- morebutton:setVisible(true)
	rewardListView:setVisible(true)
	
	UnionJoin.asyncIndex = 1
	self.pagecount = 0
	self.ismore = false
	UnionJoin.cacheListView = rewardListView
	self.currentListView = UnionJoin.cacheListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	if #rewardListView:getItems() > 0 then
		rewardListView:removeAllItems()
	end
	self:loading()


end
function UnionJoin:updateDraw1()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	local function listViewEventCallBack(sender, evenType)
		if evenType == ccui.ScrollviewEventType.scrollToBottom then
			if self.ismore ==true then
				self.ismore= false
				local index = UnionJoin.asyncIndex
				state_machine.excute("union_join_to_more", 0, {_datas={_index=index}})
			end
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
           
        end
	end
	
	listView:addScrollViewEventListener(listViewEventCallBack)
end
function UnionJoin:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:updateDraw()
end

function UnionJoin:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	UnionJoin.asyncIndex = 1
	UnionJoin.cacheListView = nil

	self.currentListView = nil
	self.currentInnerContainer = nil
end
function UnionJoin:onUpdate(dt)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		if self.roots == nil or self.tickTime == nil then 
	        return
	    end
	    self.tickTime = self.tickTime - dt
	    if self.tickTime <= 0 then
	        self.tickTime = 2
	        local function responseCallback( response )
	        end
	        -- NetworkManager:register(protocol_command.refush_cache_message.code, nil, nil, nil, nil, responseCallback, false, nil)
	    end
	end

	if self.cutType ~= nil and self.cutType == 2 then
		local root = self.roots[1]
		if root == nil then
			return
		end
		local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
		if text ~= nil then
			local str = zstring.exchangeTo(text:getString())
			if text:getString() == "" then
				state_machine.excute("union_join_list",0,"")
			end	
		end		
	end

	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
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

function UnionJoin:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_list_tab = ccui.Helper:seekWidgetByName(root, "Panel_list_tab")
    local Button_join = ccui.Helper:seekWidgetByName(root, "Button_join")
    local Button_form = ccui.Helper:seekWidgetByName(root, "Button_form")
    local Button_find = ccui.Helper:seekWidgetByName(root, "Button_find")
    if page == self._current_page then
        if page == 1 then
            Button_join:setHighlighted(true)
        elseif page == 2 then
            Button_form:setHighlighted(true)
        elseif page == 3 then
            Button_find:setHighlighted(true)
        end
        return
    end

    -- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		for i, v in ipairs(self.textTable) do
		    if v ~= nil then
		        v:setVisible(page == i)
		    end
		end
	end

    self._current_page = page
    Button_join:setHighlighted(false)
    Button_form:setHighlighted(false)
    Button_find:setHighlighted(false)
    state_machine.excute("sm_union_join_page_hide", 0, nil)
    state_machine.excute("sm_union_form_page_hide", 0, nil)
    state_machine.excute("sm_union_find_page_hide", 0, nil)
    	
    if page == 1 then
        Button_join:setHighlighted(true)
        if self._to_join == nil then
            self._to_join = state_machine.excute("sm_union_join_page_open", 0, {Panel_list_tab,self.page_number})
        else
            state_machine.excute("sm_union_join_page_show", 0, nil)
        end
	elseif page == 2 then
		Button_form:setHighlighted(true)
		if self._create == nil then
            self._create = state_machine.excute("sm_union_form_page_open", 0, {Panel_list_tab})
        else
            state_machine.excute("sm_union_form_page_show", 0, nil)
        end
	elseif page == 3 then
		Button_find:setHighlighted(true)
		if self._Find == nil then
            self._Find = state_machine.excute("sm_union_find_page_open", 0, {Panel_list_tab})
        else
            state_machine.excute("sm_union_find_page_show", 0, nil)
        end
    end
end


function UnionJoin:onInit()
	local csbUnionJoin = csb.createNode("legion/legion_list.csb")
    local root = csbUnionJoin:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionJoin)
	
	-- local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
	-- draw:addEditBox(text, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_19"), 6, cc.KEYBOARD_RETURNTYPE_DONE)
	
	-- if _ED.union.union_list_sum == nil or zstring.tonumber(_ED.union.union_list_sum) == 0 then
	-- else
	-- 	self:updateDraw()
	-- 	self:updateDraw1()
	-- end
	
	
	
	local createbutton = ccui.Helper:seekWidgetByName(root, "Button_02")
	-- 创建军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_02"), nil, 
    {
        terminal_name = "union_join_to_create", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 搜索军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_19"), nil, 
    {
        terminal_name = "union_join_to_look", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	-- 更多
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_list_more"), nil, 
    -- {
        -- terminal_name = "union_join_to_look", 
        -- terminal_state = 0,
        -- cell = self,
        -- isPressedActionEnabled = false
    -- }, 
    -- nil, 0)
	 -- 返回主页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"), nil, 
    {
        terminal_name = "union_join_return_home", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
     -- 舰队列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, 
    {
        terminal_name = "union_join_list", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_join"), nil, 
    {
        terminal_name = "sm_union_join_to_create_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_form"), nil, 
    {
        terminal_name = "sm_union_join_to_create_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_find"), nil, 
    {
        terminal_name = "sm_union_join_to_create_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 0)
		

	-- DSC重塑
    self.textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_join_1 = ccui.Helper:seekWidgetByName(root, "Text_join_1")
        local Text_form_1 = ccui.Helper:seekWidgetByName(root, "Text_form_1")
        local Text_find_1 = ccui.Helper:seekWidgetByName(root, "Text_find_1")

        table.insert(self.textTable, Text_join_1)
        table.insert(self.textTable, Text_form_1)
        table.insert(self.textTable, Text_find_1)
        
        for _, v in ipairs(self.textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end
    end

    self.page_number = 0
	self:changeSelectPage(1)

    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
        local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
        Panel_effec:addChild(animation2)
    end
end

function UnionJoin:onEnterTransitionFinish()
	app.load("client.player.UserInformationShop")
	local userinfo = fwin:find("UserInformationShopClass")
	if userinfo == nil then
		local UserInformationShop = UserInformationShop:new()
		UserInformationShop._rootWindows = self
		fwin:open(UserInformationShop,fwin._view)
	end
end

function UnionJoin:init()
	self.cutType = 1
	self.pagecount = 0
	self:onInit()
	return self
end

function UnionJoin:close( ... )
    local Panel_effec = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function UnionJoin:onExit()
	state_machine.remove("union_join_return_home")
	state_machine.remove("union_join_to_create")
	state_machine.remove("union_join_to_look")
	state_machine.remove("union_join_more")
	state_machine.remove("union_join_refresh")
	state_machine.remove("union_join_list")
	state_machine.remove("union_join_to_more")
end