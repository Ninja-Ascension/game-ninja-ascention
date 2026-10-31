-------------------------------------------------------------------------------------------------------
-- 说明：三国志主界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

DestinySystem = class("DestinySystemClass", Window)
    
function DestinySystem:ctor()
    self.super:ctor()
	app.load("client.utils.objectMessage.ObjectMessage")
	
	self.roots = {}
	self.table_pageData = nil
	self.number_currentOpenedPageIndex = 0 --当前已经开启的位置页数
	self.number_currentShowPageIndex = 0 --当前滑动到显示的位置页数
	
	self.clickLock = false
	self.clickLockIndex = 0
	self.timerQueue = {}
	self.destiny_mould_data = dms["destiny_mould"]

	self.cell = nil
    -- Initialize DestinySystem page state machine.
    local function init_DestinySystem_terminal()
		--返回home界面
		local destiny_system_return_home_page_terminal = {
            _name = "destiny_system_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
					or __lua_project_id == __lua_project_yugioh
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_warship_girl_b 
					then
					cacher.destoryRefPools()
					cacher.removeAllTextures()
					cacher.cleanSystemCacher()
					if fwin:find("PropPageClass") ~= nil and instance.cell ~=nil then
						state_machine.excute("prop_list_cell_request_prop_update_count",0,instance.cell)
					end
				end
				fwin:cleanView(fwin._view) 
				fwin:close(instance)
				fwin:close(fwin:find("DestinyAddPropertyInfoCellClass"))
				app.load("client.home.Home")

				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("HomeClass") == nil then
						cacher.cleanActionTimeline()
						checkTipBeLeave()						
						fwin:removeAll()
						fwin:open(Home:new(), fwin._view)
					end
					state_machine.excute("menu_back_home_page", 0, "")
				else
					fwin:open(Home:new(), fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--点亮星星,飘完属性了
		local destiny_system_lighten_star_terminal = {
            _name = "destiny_system_lighten_star",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if nil ~= fwin:find("DestinySystemClass") and nil ~= instance.shakeProperty then
					instance:shakeProperty()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		
		--打开属性界面
		local destiny_system_open_property_page_terminal = {
            _name = "destiny_system_open_property_page",
            _init = function (terminal) 
                app.load("client.cells.destiny.destiny_add_property_info_cell") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print("打开 window---------------------------------- ")
				local destinyAddPropertyInfoCell = DestinyAddPropertyInfoCell:new()
				fwin:open(destinyAddPropertyInfoCell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--请求点亮星星界面
		local destiny_system_light_on_button_terminal = {
            _name = "destiny_system_light_on_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:checkupAscendingOrder()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--按下星云图的界面左侧按钮
		local destiny_system_star_left_button_terminal = {
            _name = "destiny_system_star_left_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 回退
				instance:pageviewToright()
					
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--按下星云图的界面右侧按钮
		local destiny_system_star_right_button_terminal = {
            _name = "destiny_system_star_right_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:pageviewToleft()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--按下菜单栏icon的界面跳转
		local destiny_system_update_page_index_terminal = {
            _name = "destiny_system_update_page_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _index = params._datas._data._index

				instance.number_currentShowPageIndex = _index
			
				instance:updatePageView()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--按下菜单栏icon的界面跳转
		local destiny_system_update_icon_show_tip_terminal = {
            _name = "destiny_system_update_icon_show_tip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _target = params.target
				instance:startTimer(_target)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --来自于包裹界面的cell
        local destiny_system_set_prop_cell_terminal = {
            _name = "destiny_system_set_prop_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params
				instance:setFromCell(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(destiny_system_return_home_page_terminal)
		state_machine.add(destiny_system_open_property_page_terminal)
		state_machine.add(destiny_system_light_on_button_terminal)
		state_machine.add(destiny_system_star_left_button_terminal)
		state_machine.add(destiny_system_star_right_button_terminal)
		state_machine.add(destiny_system_update_page_index_terminal)
		state_machine.add(destiny_system_update_icon_show_tip_terminal)
		state_machine.add(destiny_system_lighten_star_terminal)
		state_machine.add(destiny_system_set_prop_cell_terminal)
		
        state_machine.init()
    end
    -- call func init hom state machine.
    init_DestinySystem_terminal()
end

function DestinySystem:setFromCell(cell)
	self.cell = cell
end
function DestinySystem:startTimer(target)
	table.insert(self.timerQueue, {target = target, timer = 2*60})
end


function DestinySystem:view_ship_grow_up_additional()
	
	local ship = self:getPlayerShip()
	local function responseAdvenceHeroMathCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.roots == nil then
				return
			end
			local _advancedBack = {}
			_advancedBack[1] = 0  		--nil
			_advancedBack[2] = _ED.add_ship_courage     	--战船攻击加成
			_advancedBack[3] = _ED.add_ship_intellect 		--战船物防加成
			_advancedBack[4] = _ED.add_ship_power  			--战船生命加成
			_advancedBack[5] = _ED.add_ship_nimable     	--战船法防加成	
			response.node.oldShipData = _advancedBack

			--> print("属性回来了------------------------------",_ED.add_ship_power ,self.oldShipData[2])
			response.node:destiny_start()
		else
			response.node.buttonLock = false
		end
	end
	protocol_command.view_ship_grow_up_additional.param_list = ""..ship.ship_id
	NetworkManager:register(protocol_command.view_ship_grow_up_additional.code, nil, nil, nil, self, responseAdvenceHeroMathCallback, false, nil)
end


function DestinySystem:destiny_start()
	
	local function destiny_init_recruitCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--print("点星星了---------2222222--------------------------------")
			if response.node.updateData ~= nil then
				response.node:updateData()
				response.node:drawProperty()
				--发送通知,交由各个子控件自行更新数据显示
				ObjectMessage.fireMessage(ObjectMessageNameEnum.destiny_icon_cell_update_all_state)
				
				-- 调用showData 提示获得
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					fwin:close(fwin:find("DestinyAddPropertyInfoCellClass"))
					local destinyAddPropertyInfoCell = DestinyAddPropertyInfoCell:new()
					fwin:open(destinyAddPropertyInfoCell, fwin._windows)
				end
				response.node:alertRewadInfo()
			end
		end
		
		self.buttonLock = false
	end

	local function destiny_start_recruitCallBack(response)
		_ED.baseFightingCount = calcTotalFormationFight()
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			NetworkManager:register(protocol_command.destiny_init.code, nil, nil, nil, self, destiny_init_recruitCallBack, false, nil)
		end
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if response.node ~= nil and response.node.roots ~= nil then
				response.node.buttonLock = false
			end
		end
	end
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		NetworkManager:register(protocol_command.destiny_start.code, nil, nil, nil, self, destiny_start_recruitCallBack, false, nil)
	else
		NetworkManager:register(protocol_command.destiny_start.code, nil, nil, nil, nil, destiny_start_recruitCallBack, false, nil)
	end
	
end


function DestinySystem:checkupAscendingOrder()

	-- 如果当前下一级 id == -1,则到头了
	local index = self:checkupMaxNumIndex() - 1
	index = math.max(index, 1)
	local last_next_id = dms.int(dms["destiny_mould"], index, destiny_mould.next_id)
	
	if last_next_id == -1 then
		return
	end

	-- 已经在发请求了 ,操作未完成
	if true == self.buttonLock then
		return
	end
	
	
	self.buttonLock = true
	-- self.button_sgz_3:setBright(false)
	-- self.button_sgz_3:setTouchEnabled(false)
	
	--> print("self.ship.ship_template_id-------------------",self:getPlayerShip().ship_template_id)
	
	--> print("checkupAscendingOrder--------------------",self.isLevel )

	if self.isLevel == true then
		--> print("----------发 属性请求-------------------------------------",self.isLevel)
		self:view_ship_grow_up_additional()
	else
		--> print("----------点星星的-------------------------------------",self.isLevel)
		self:destiny_start()
	end
end


function DestinySystem:onUpdate(dt)
	
	for i=1, table.getn(self.timerQueue) do
		local item = self.timerQueue[i]
		
		if item.timer == 0 then
			-- 发消息
			local target = item.target
			self.timerQueue[i] = nil
			table.remove(self.timerQueue, i)
			local data = {
					target = target,
					}
			state_machine.excute("destiny_icon_cell_update_icon_show_tip_timer_end", 0, data)
			break
		else
			item.timer = item.timer -1
		end
	end
	
	
	-- if self.clickLock then
		-- if self.clickLockIndex == 30 then
			-- self.clickLockIndex = 0
			-- self.clickLock = false
		-- end
		
		-- self.clickLockIndex = self.clickLockIndex +1
	-- end
end

---------------------------------------------------------------------------------------------------
-- 做数据更新
-- self.table_pageData 存储所有的数据
-- self.number_propNum 当前点亮星星要消耗的物品数量
-- self.string_property 当前下一个未开启的星星所带的功能说明
-- self.number_currentShowPageIndex 当前显示的页面索引


-- 检查越界
function DestinySystem:checkupMaxNumIndex(addNum)
	addNum = addNum or 0
	local data = self.destiny_mould_data
	local index =  _ED.cur_destiny_id + addNum
	if index >= #data then
		-- 越界处理
		index = #data
	end
	return index
end	
	
-- 获取当前模板数据更新
function DestinySystem:updateMouldData()

	self.table_pageData = {}
	local data = self.destiny_mould_data
	
	local zindex = 1
	local nindex = 1
	
	function separate(n, value)
		local queue = nil
		for i = n, #data do
			local page_index = dms.int(data, i, destiny_mould.page_index)
			if tonumber(page_index) == value then
				if nil == queue then
					queue = {}
				end
				table.insert(queue, data[i])
				nindex = nindex +1
				if i == #data then
					return queue
				end
			else
				return queue
			end
		end
		return nil
	end
	
	while true do
		local sdata = separate(nindex, zindex)
		
		if type(sdata) == "table" then
			table.insert(self.table_pageData, sdata)
			zindex = zindex +1
		else
			return
		end
	end
end


--获取更新当前显示星所需要的消耗物品数量以及背包中持有的数量
function DestinySystem:updateNeedPropData()
	local data = self.destiny_mould_data
	-- 获取数量
	local index = self:checkupMaxNumIndex(1)
	
	local need_of_prop = dms.int(data, index, destiny_mould.need_of_prop)
	local need_of_prop_count = dms.int(data, index, destiny_mould.need_of_prop_count)

	local length = _ED.user_prop_number
	local user_prop = _ED.user_prop
	local currentPropNum = 0
		
	for i, v in pairs(user_prop) do
		if tonumber(v.user_prop_template) == need_of_prop then
			currentPropNum = v.prop_number
			break
		end
	end
	self.number_propNum = currentPropNum.."/"..need_of_prop_count
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		local ButtonJH = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sgz_3")
		local ImageJH = ccui.Helper:seekWidgetByName(self.roots[1], "Image_9")
		if zstring.tonumber(currentPropNum) >= zstring.tonumber(need_of_prop_count) then 
			ButtonJH:setTouchEnabled(true)
			ButtonJH:setColor(cc.c3b(255, 255, 255))
			ImageJH:setColor(cc.c3b(255, 255, 255))
		else
			ButtonJH:setTouchEnabled(false)
			ButtonJH:setColor(cc.c3b(130, 130, 130))
			ImageJH:setColor(cc.c3b(130, 130, 130))
		end
	end
end


-- 算出当前cell的显示属性
function DestinySystem:updatePropertyAdditionalData()
	local index = self:checkupMaxNumIndex(1)
	local data = self.destiny_mould_data
	-- 显示属性加成
	local property_additional = dms.string(data, index, destiny_mould.property_additional)
	
	-- if tonumber(property_additional) == -1 then
		-- -- 已经取到末尾不处理的数据
		-- return
	-- end
	
	-- local propertyList = zstring.zsplit(property_additional, "|")
	
	-- for i=1 ,#propertyList do
		-- propertyList[i] = zstring.zsplit(propertyList[i], ",")
	-- end

	-- local propertyName = string_equiprety_name[tonumber(propertyList[#propertyList][1])+1]
	-- local propertyValue = tostring(propertyList[#propertyList][2])..string_equiprety_name_vlua_type[tonumber(propertyList[#propertyList][1])+1]
	
	
	local mouldIndex = tonumber(index)
	--> print("id-------------------",mouldIndex)
	local reward = self:calculatePropertyAdditional(mouldIndex)
	
	--> print("id-------------------",mouldIndex, reward.name..reward.value)
	
	self.string_property = reward.descript--reward.name..reward.value
end


--获取当前已经开启的页面索引
function DestinySystem:updateCurrentOpenedPageIndex()
	local data = self.destiny_mould_data
	local index = self:checkupMaxNumIndex(1)
	
	local currentOpenedPageIndex = dms.int(data, index, destiny_mould.page_index) 
	-- if currentOpenedPageIndex == nil or currentOpenedPageIndex == #self.table_pageData then
		
		-- --currentOpenedPageIndex = dms.int(data, self:checkupMaxNumIndex(), destiny_mould.page_index) 
	-- end

	if __lua_project_id == __lua_project_red_alert then
		--未开启页面不自动滑过去，滑动到上一页
		local last_next_id = dms.int(dms["destiny_mould"], index, destiny_mould.next_id)
		if last_next_id == -1 then
			currentOpenedPageIndex = currentOpenedPageIndex -1
		end
	end
	if self.number_currentShowPageIndex > 0 and self.number_currentShowPageIndex ~= currentOpenedPageIndex then
		-- 更新进来的,且页面变化了
		self.number_currentShowPageIndex = currentOpenedPageIndex
		--self.number_currentOpenedPageIndex = self.number_currentShowPageIndex
		self:updatePageView()
	end
	-- 初始化的
	--self.number_currentOpenedPageIndex = currentOpenedPageIndex
	self.number_currentShowPageIndex = currentOpenedPageIndex
end

-- 更新所有当前的需要数据
function DestinySystem:updateData()
	self:updateMouldData()
	self:updateNeedPropData()
	self:updatePropertyAdditionalData()
	self:updateCurrentOpenedPageIndex()
end
--------------------------------------------------------------------
-- 界面绘制
-- self.iconListView 界面上菜单栏的listview
-- self.bodyPageView 界面上星云图pageview
-- self.bodyPageView:getCurPageIndex() 获取当前滑动到的页面索引
-- self.iconListView._csize 单个cell的矩形大小
-- self.iconListView.containerWidth listview的实际显示内容宽度
-- self.iconListView.viewWidth listview的自身容器宽度

-- 绘制listview
function DestinySystem:drawIconListView()
	local root = self.roots[1]
	self.iconListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.iconListView:removeAllItems()
	local csize = nil
	local listViewCells = {}
	for i = 1 , #self.table_pageData do
		local mouldIndex = tonumber(dms.int(self.table_pageData[i], 1, destiny_mould.id)) -- 模板id
		local cell = self:createIconCell()
		cell:init(1, mouldIndex)
		cell:setPageIndex(i)
		self.iconListView:pushBackCustomItem(cell)
			
		cell:removeChosen()
		cell:setGray()
		
		--> print("当前页----",self.number_currentShowPageIndex , i)
		
		if self.number_currentShowPageIndex == i then
			cell:setChosen()
		end
		if self.number_currentShowPageIndex > i then
			cell:removeGray()
		end
		if self.number_currentShowPageIndex == i and self:checkupMaxNumIndex() == #self.destiny_mould_data then
			cell:removeGray()
		end
		
		if csize == nil then
			csize = cell:getContentSize()
		end
		cell.updateAllState(cell)
		table.insert(listViewCells, cell)
	end
	
	local containerWidth = csize.width*#self.table_pageData
	local listviewSize = self.iconListView:getInnerContainer():getContentSize()
	self.iconListView:getInnerContainer():setContentSize(cc.size(containerWidth, listviewSize.height))
	self.iconListView:jumpToLeft()
	self.iconListView.containerWidth = containerWidth
	self.iconListView.viewWidth = self.iconListView:getContentSize().width

	local function scrollViewEvent(sender, evenType)
		if evenType == ccui.ScrollviewEventType.scrolling then--4
			--sender._firstIndex = sender:getCurSelectedIndex() +1
		end
	end
	self.iconListView:addScrollViewEventListener(scrollViewEvent)
	self.iconListView._csize = csize

end

function DestinySystem:drawIconListViewEX( ... )
	local root = self.roots[1]
	self.iconListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.iconListView:removeAllItems()

	local csize = nil
	local index = 1
	local function delatEnd( sender )
		if index > #self.table_pageData then
			self:stopAllActionsByTag(100)
			return
		end
		local mouldIndex = tonumber(dms.int(self.table_pageData[index], 1, destiny_mould.id))
		local cell = self:createIconCell()
		cell:init(1, mouldIndex)
		cell:setPageIndex(index)
		self.iconListView:pushBackCustomItem(cell)
			
		cell:removeChosen()
		cell:setGray()
		
		if self.number_currentShowPageIndex > index then
			cell:removeGray()
		elseif self.number_currentShowPageIndex == index then
			if self:checkupMaxNumIndex() == #self.destiny_mould_data then
				cell:removeGray()
			else
				cell:setChosen()
			end
		end
		
		if csize == nil then
			csize = cell:getContentSize()
		end
		index = index + 1
		if index > #self.table_pageData then
			self:stopAllActionsByTag(100)
		end
	end
	delatEnd()
	local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(delatEnd)))
	self:runAction(action)
	action:setTag(100)
	
	local containerWidth = csize.width*#self.table_pageData
	local listviewSize = self.iconListView:getInnerContainer():getContentSize()
	self.iconListView:getInnerContainer():setContentSize(cc.size(containerWidth, listviewSize.height))
	self.iconListView:jumpToLeft()
	self.iconListView.containerWidth = containerWidth
	self.iconListView.viewWidth = self.iconListView:getContentSize().width

	self.iconListView._csize = csize
end

-- 绘制pageview
function DestinySystem:drawBodyPageView()
	local root = self.roots[1]
	if nil == self.bodyPageView then
		self.bodyPageView = ccui.Helper:seekWidgetByName(root, "PageView_sgz")
	end
	self.bodyPageView:removeAllPages()
	for i = 1 , #self.table_pageData  do
		local cell = self:createTotemBody()
		self.bodyPageView:insertPage(cell, i-1)
		cell._isOver = false
		-- cell:updateCreateNode(self.table_pageData[i])
	end
	
	local function pageViewEvent(sender, eventType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		
        if eventType == ccui.PageViewEventType.turning then
			if self.boolean_issrolllock == true then
				self.boolean_issrolllock = false
				return
			end
			self.number_currentShowPageIndex =  sender:getCurPageIndex() + 1
			self:changedPageviewIndex()
			self:drawProperty()
			if sender:getCurPageIndex() < #self.table_pageData-1 then
				if self.bodyPageView:getPage(sender:getCurPageIndex()+1)._isOver == false  then
					self.bodyPageView:getPage(sender:getCurPageIndex()+1):updateCreateNode(self.table_pageData[tonumber(sender:getCurPageIndex()+2)])
					self.bodyPageView:getPage(sender:getCurPageIndex()+1)._isOver = true
				end
			end
			if sender:getCurPageIndex() > 1 then
				if self.bodyPageView:getPage(sender:getCurPageIndex()-1)._isOver == false then
					self.bodyPageView:getPage(sender:getCurPageIndex()-1):updateCreateNode(self.table_pageData[tonumber(sender:getCurPageIndex()-1)])
					self.bodyPageView:getPage(sender:getCurPageIndex()-1)._isOver = true
				end
			end
        end
    end 
    self.bodyPageView:addEventListener(pageViewEvent)
end


-- 绘制界面属性面板中文本的值
function DestinySystem:drawPropertyText()
	if nil == self.ui_text_property then
		self.ui_text_property = ccui.Helper:seekWidgetByName(self.roots[1], "Text_sgz_2")
	end
	self.ui_text_property:setString(tostring(self.string_property))
	
	if nil == self.ui_text_num then
		self.ui_text_num = ccui.Helper:seekWidgetByName(self.roots[1], "Text_4")
	end
	self.ui_text_num:setString(tostring(self.number_propNum))
end

-- 绘制界面属性面板
function  DestinySystem:drawProperty()
	self:drawPropertyText()
	local root = self.roots[1]
	-- 升
	local panel_property = ccui.Helper:seekWidgetByName(root, "Panel_sgz_2_d")
	local data = self.destiny_mould_data
	local page_index = dms.string(data, self:checkupMaxNumIndex(), destiny_mould.page_index)
	local newIndex = self:checkupMaxNumIndex(1)
	local next_page_index = dms.string(data,newIndex , destiny_mould.page_index)
	-- 已点亮
	local image_sgz_2_d = ccui.Helper:seekWidgetByName(root, "Image_sgz_2_d")
	-- 未点亮
	local image_sgz_1_d = ccui.Helper:seekWidgetByName(root, "Image_sgz_1_d")
	
	image_sgz_1_d:setVisible(false)
	image_sgz_2_d:setVisible(false)
	panel_property:setVisible(false)
	
	--> print("检查边界-------------------------------------------")
	--> print(next_page_index, self.number_currentShowPageIndex,  _ED.cur_destiny_id, #data ,self:checkupMaxNumIndex())
	
	if tonumber(next_page_index) == tonumber(self.number_currentShowPageIndex) and self:checkupMaxNumIndex() < #data then
		panel_property:setVisible(true)
	elseif tonumber(next_page_index) > tonumber(self.number_currentShowPageIndex) or self:checkupMaxNumIndex() == #data then
		image_sgz_2_d:setVisible(true)
	elseif tonumber(next_page_index) < tonumber(self.number_currentShowPageIndex) then
		image_sgz_1_d:setVisible(true)
	end
end
------------------------------------------------------------------------
-- 绘制基础元件

-- 绘制用于pageview的元件
function DestinySystem:createTotemBody()
	app.load("client.cells.destiny.destiny_body_cell")
	local cell = DestinyBodyCell:createCell()
	return cell
end


-- 绘制用于listview的元件
function DestinySystem:createIconCell()
	app.load("client.cells.destiny.destiny_icon_cell")
	local cell = DestinyIconCell:createCell()
	return cell
end

----------------------------------------------------------------------
-- 处理逻辑

function DestinySystem:runningView()
	--1. 定位到当前页面- pageview
	self:setPageViewIndex(self.number_currentShowPageIndex - 1)
	--2. 定位到当前页面- listview
	self:setListViewIndex()  
end

function DestinySystem:setPageViewIndex(index)
	-- pageview的index是0开始所以-1
	self.bodyPageView:scrollToPage(index)    
	-- 变更显示属性
	self:drawProperty()
	for i=self.bodyPageView:getCurPageIndex()-1, self.bodyPageView:getCurPageIndex() do
		if i ~= -1 and i~=#self.table_pageData then
			if self.bodyPageView:getPage(i)._isOver == false then
				self.bodyPageView:getPage(i):updateCreateNode(self.table_pageData[tonumber(i+1)])
				self.bodyPageView:getPage(i)._isOver = true
			end
		end
	end
end

function DestinySystem:setListViewIndex()
	-- 没有直接的设置方法,需要计算
	local showIndex = self.number_currentShowPageIndex
	--local showIndex = 8
	-- 显示位于最左边
	local showX = showIndex * self.iconListView._csize.width * -1 + self.iconListView._csize.width
	
	if showX == 0 or showIndex ==1 or showIndex ==6 then
		-- 当前显示的是第一项,不继续了
	else
		showX = showX + self.iconListView.viewWidth
	end
	self.iconListView:getInnerContainer():setPositionX(showX)
end


-- 向左滑动,增加页数
function DestinySystem:pageviewToleft()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--如果下一个是未开启的，点击右侧翻页到下一页按钮失效，提示未开放,前id和后id都为-1 则为开启，获取两个条件同时满足的第一条数据，取page_index
		local table1 = dms.searchs(dms["destiny_mould"], destiny_mould.previous_id, -1)
		local table2 = dms.searchs(table1, destiny_mould.next_id, -1)
		local page_open_max_index = 1
		for i,v in pairs(table2) do
			page_open_max_index = dms.int(table2, i,destiny_mould.page_index)
			--print(dms.int(table2, i,destiny_mould.page_index))
			break
		end
		--print("-------",page_open_max_index,self.number_currentShowPageIndex)
		if page_open_max_index -1 == self.number_currentShowPageIndex then
			TipDlg.drawTextDailog(_string_piece_info[199])
			return
		end
	end
	local index =  self.bodyPageView:getCurPageIndex()
	self:setPageViewIndex(index + 1)
end

-- 向右滑动,减少页数
function DestinySystem:pageviewToright()
	local index =  self.bodyPageView:getCurPageIndex()
	self:setPageViewIndex(index - 1)
end

function DestinySystem:changedPageviewIndex()
	
	local cell = self.iconListView:getItem(self.number_currentShowPageIndex-1)
	if cell ~= nil then
		local _messageName = ObjectMessageNameEnum.destiny_icon_cell_set_chosen_state
		local _messageData = ObjectMessageData.getInitExample(_messageName)
		_messageData.source = cell
		_messageData.target = cell
		ObjectMessage.fireMessage(_messageName, _messageData)
	end
	
	local newX = 0
	
	local showIndex = self.number_currentShowPageIndex
	-- 取出我当前的位置值
	local posX = showIndex * self.iconListView._csize.width
	
	-- 取出当前层容器的位置
	local containerX = self.iconListView:getInnerContainer():getPositionX()
	
	-- 计算两者之差
	local xxValue = posX + containerX
	if xxValue < 0 then
		-- 位于左侧 屏幕外 直接移到左边
		newX = posX * -1 + self.iconListView._csize.width
		self.iconListView:getInnerContainer():setPositionX(newX)
		
	elseif xxValue > self.iconListView.viewWidth then
		-- 位于右侧 屏幕外 直接移到右边
		newX = (posX - self.iconListView.viewWidth) * -1
		self.iconListView:getInnerContainer():setPositionX(newX)
	
	elseif xxValue == 0 then
		newX = posX * -1 + self.iconListView._csize.width
		self.iconListView:getInnerContainer():setPositionX(newX)
	end
end


function DestinySystem:updatePageView()
	self:setPageViewIndex(self.number_currentShowPageIndex - 1)
end

function DestinySystem:updateListViewOpen()
	-- 设置listview
	
	local data = self.destiny_mould_data
	local num = dms.int(data,self:checkupMaxNumIndex(), destiny_mould.page_index) 
	for i = 1, num do
		self.iconListView:getItem(i-1):removeGray()
	end

end


------------------------------------------------------------------------
-- 计算 可显示的奖励

-- 算出当前cell的显示属性
function DestinySystem:calculatePropertyAdditional(mouldIndex)
	local reward = {}

	-- 显示属性加成
	local property_additional = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.property_additional)
	local descript = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.descript)
	descript = zstring.zsplit(descript, ",")
	local descriptStr = ""
	for i,v in pairs(descript) do
		descriptStr = descriptStr..v
	end
	
	if tonumber(property_additional) == -1 then
		-- 已经取到属性变更信息
		-- 进入pirates_config - 176行索引
		return self:calculateSpecialPropertyAdditional(mouldIndex)
	else
		local propertyList = zstring.zsplit(property_additional, "|")
		self.propertyList = propertyList	
		for i=1 ,#propertyList do
			propertyList[i] = zstring.zsplit(propertyList[i], ",")
		end

		reward.name = descript[1]--string_equiprety_name[tonumber(propertyList[#propertyList][1])+1]
		reward.value = tostring(propertyList[#propertyList][2])..string_equiprety_name_vlua_type[tonumber(propertyList[#propertyList][1])+1]
		reward.type = "property"
		reward.descript = descriptStr
		
		--> print("道具的额-----------------------------------------------",self.isLevel)
	end
	
	return reward
end

-- 算出当前为-1时的获取
function DestinySystem:calculateSpecialPropertyAdditional(mouldIndex)
	local reward = {}
	-- 优先算是否改运
	local is_change_destiny = dms.int(dms["destiny_mould"], mouldIndex, destiny_mould.is_change_destiny)
	if tonumber(is_change_destiny) == 1 then
		-- 1就是改
		local descript = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.descript)
		reward.name = tostring(descript)
		reward.value = tostring("")
		reward.type = "level"
		reward.descript = descript
		self.isLevel = true
		
		--> print("改运的额-----------------------------------------------",self.isLevel)
	else
		-- 0就是不改
		-- 不是改运,则取当前字段中获得道具
		local get_of_prop = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.get_of_prop)
		local get_of_prop_count = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.get_of_prop_count)
		local descript = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.descript)
		-- 道具模板 
		local prop_name = dms.string(dms["prop_mould"], get_of_prop, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        prop_name = setThePropsIcon(get_of_prop)[2]
	    end
		reward.name = prop_name
		reward.value = tostring(get_of_prop_count)
		reward.type = "goods"
		reward.descript = descript
		--> print("物品的额-----------------------------------------------",self.isLevel)
	end
	
	return reward
end


-------------------------------------------------------------------------
-- 提醒获得奖励信息
function DestinySystem:alertRewadInfo()
	local mouldIndex = tonumber(_ED.cur_destiny_id)
	local reward = self:calculatePropertyAdditional(mouldIndex)
	-- 属性变更
	-- 物品获得
	-- 宝箱获得
	-- 主角品质提升
	
	--> print("leixing-------------------------------", reward.type)
	
	if reward.type == "property" then
		self:showPropertyChangeTipInfo(reward.name,reward.value)
	elseif reward.type == "level" then
		-- 去突破
		self:showAdvanced()
	elseif reward.type == "goods" then
		--46号奖励
		self:showGoods()
	end
end

function DestinySystem:showBigBox(rewardMouldId)
	app.load("client.reward.BigBoxRewad")
	local win = BigBoxRewad:new()
	win:init(rewardMouldId)
	fwin:open(win, fwin._windows)
end

function DestinySystem:showPropReward(rewardMouldId, count)
	app.load("client.reward.AcquireRewad")
	local win = AcquireRewad:new()
	win:initProp(rewardMouldId, count)
	fwin:open(win, fwin._windows)
end

-- 显示 获得物品提示
function DestinySystem:showGoods()
	-- 检查是不是 
	
	-- 171
	-- 46
	-- 1
	-- 77 6 1
	
	local rewardList = getSceneReward(46)
	-- -- 空的关掉
	if nil == rewardList then
		return
	end
	
	local reward = getRewardItemWithType(rewardList, 6)
	local mid = reward.prop_item
	--local mid = 77
	local props_type = dms.int(dms["prop_mould"], mid, prop_mould.props_type)
	--> print("props_type----------------------------------",props_type)
	-- if tonumber(props_type) == 7 then
		-- --7 选择型包裹（爆竹库）
		
		-- self:showBigBox(mid)
	-- else
		-- 否,普通道具
		self:showPropReward(mid, reward.item_value)
	-- end
	
end


-- 显示属性变更的提示信息
function DestinySystem:showPropertyChangeTipInfo(property,value)
	-- 外面星星点亮时,通知传进来的 
	-- 有属性增加时.提示这个
	app.load("client.cells.utils.property_change_tip_info_cell") 
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()

	local str = tipStringInfo_destiny[1]
	
	local textData = {}
	table.insert(textData, {property = property, value = value})
	
	tipInfo:init(7,str, textData)	
	fwin:open(tipInfo, fwin._ui)
end


-- function DestinySystem:getPlayerShipId()
	-- for i, ship in pairs(_ED.user_ship) do
		-- if tonumber(ship.captain_type) == 0 then 
			-- return ship.ship_id
		-- end
	-- end
	-- return nil
-- end

function DestinySystem:getPlayerShipId()
	local ship = self:getPlayerShip()
	local shipMID = nil
	if ship then
		shipMID = ship.ship_template_id
	end
	return shipMID
end

function DestinySystem:getPlayerShip()
	local ship = nil
	for i = 1 , table.getn(_ED.user_formetion_status) do
		local shipItem = fundShipWidthId(_ED.user_formetion_status[i])
		local mid = shipItem.ship_template_id
		if dms.int(dms["ship_mould"], mid, ship_mould.captain_type) == 0 then
			--shipId = mid
			ship = shipItem
			break 
		end
	end
	return ship
end




-- 跳去突破
function DestinySystem:showAdvanced()
	self:drawPlayer()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:close(fwin:find("DestinyAddPropertyInfoCellClass"))
	end
	app.load("client.destiny.AscendingOrder")
	local win = AscendingOrder:new()
	win:init(self:getPlayerShip(), self.oldShipData)
	fwin:open(win, fwin._ui)	
end

function DestinySystem:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self:stopAllActionsByTag(100)
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
		if fwin:find("HomeClass") == nil then
			cacher.cleanActionTimeline()
			checkTipBeLeave()
				
			-- fwin:removeAll()
		end
	end
end

-- 显示属性按钮抖动
function DestinySystem:shakeProperty()
	local action = csb.createTimeline("destiny/destiny.csb")
	action:play("Button_sgz_1_big", false)
	self.roots[1]:runAction(action)
end



-- 变更显示 猪脚动画   
function DestinySystem:drawPlayer()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		return
	end
	local shipId = self:getPlayerShipId()
	-- for i = 1 , table.getn(_ED.user_formetion_status) do
		-- local mid = fundShipWidthId(_ED.user_formetion_status[i]).ship_template_id
		-- if dms.int(dms["ship_mould"], mid, ship_mould.captain_type) == 0 then
			-- shipId = mid
			-- break 
		-- end
	-- end
	if nil ~= shipId then
		app.load("client.cells.ship.ship_body_cell")
		local playerPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_202")
		
		playerPanel:removeAllChildren(true)
		
		local shipMID = tonumber(shipId)
		local cell = ShipBodyCell:createCell()
		cell:initShipMID(shipMID)
		playerPanel:addChild(cell)
	end
end

------------------------------------------------------------------------

function DestinySystem:drawAll()
	local root = self.roots[1]
	-- 测试数据 ----------------------------------------------------
	--_ED.cur_destiny_id = 4 --用来测试点亮星数和位置
	
	-- 基本数据处理 ---------------------------------------------
	self:updateData()
	
	-- 基本视图处理 ---------------------------------------------
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:drawIconListViewEX()
	else
		self:drawIconListView()
	end
	self:drawBodyPageView()
	self:drawProperty()
	self:drawPlayer()
	-- 逻辑启动处理 ---------------------------------------------
	self:runningView()
	
	-- 界面按钮 -----------------------------------------------------
	-- 返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sgz_2"),         
							nil,
							{terminal_name = "destiny_system_return_home_page", 
							next_terminal_name = "destiny_system_return_home_page",           
							terminal_state = 0, 
							isPressedActionEnabled = true}, nil, 0)

	-- 属性面板
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sgz_1"),         
							nil,
							{terminal_name = "destiny_system_open_property_page", 
							next_terminal_name = "destiny_system_open_property_page",           
							terminal_state = 0, 
							isPressedActionEnabled = true}, nil, 0)	
	-- 点亮星星
	self.button_sgz_3 = ccui.Helper:seekWidgetByName(root, "Button_sgz_3")
	fwin:addTouchEventListener(self.button_sgz_3,         
							nil,
							{terminal_name = "destiny_system_light_on_button", 
							next_terminal_name = "destiny_system_light_on_button",           
							terminal_state = 0, 
							isPressedActionEnabled = true}, nil, 0)
	-- 点星云图的左侧按钮
	local star_left = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sgz_r"), nil,
		{func_string = [[state_machine.excute("destiny_system_star_left_button", 0, "click destiny_system_star_left_button.'")]], 
							isPressedActionEnabled = true}, nil, 0)
	-- 点星云图的右侧按钮
	local star_right = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sgz_l"), nil,
		{func_string = [[state_machine.excute("destiny_system_star_right_button", 0, "click destiny_system_star_right_button.'")]], 
							isPressedActionEnabled = true}, nil, 0)
end


function DestinySystem:onEnterTransitionFinish()
    local csbDestinySystem = csb.createNode("destiny/destiny.csb")
    self:addChild(csbDestinySystem)
	local root = csbDestinySystem:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:onLoad()
	else
		local action = csb.createTimeline("destiny/destiny.csb")
		csbDestinySystem:runAction(action)
		action:gotoFrameAndPlay(0, action:getDuration(), false)
	end
	-- if true == self.isRegistered then
	self:drawAll()
	-- else
		-- local function recruitCallBack(response)
			-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
				-- local win = fwin:find("DestinySystemClass")
				-- if nil ~= win then
					-- win:drawAll()
				-- end
			-- end
		-- end
		-- local request = NetworkManager:register(protocol_command.destiny_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
		-- request.handler = recruitCallBack
	-- end
	
	-- app.load("client.player.EquipPlayerInfomation")
	-- self.EquipPlayerInfomation = EquipPlayerInfomation:new()
	-- fwin:open(self.EquipPlayerInfomation, fwin._windows)
	app.load("client.player.EquipPlayerInfomation")
	fwin:open(EquipPlayerInfomation:new(), fwin._view)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local destinyAddPropertyInfoCell = DestinyAddPropertyInfoCell:new()
		fwin:open(destinyAddPropertyInfoCell, fwin._windows)
	end
	
	
	
	--self:showAdvanced()
	-------------------------------测试
	-- app.load("client.reward.AcquireRewad")
	-- local win = AcquireRewad:new()
	-- win:initHero(518, 1)
	-- fwin:open(win, fwin._dialog)
	
end

function DestinySystem:init(isRegistered)

	--self.isRegistered = isRegistered
	
end

function DestinySystem:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local effect_paths = "images/ui/effice/effect_47/effect_47.ExportJson"
	    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	    effect_paths = "images/ui/effice/effect_ui_destiny_icon/effect_ui_destiny_icon.ExportJson"
	    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	end
	state_machine.remove("destiny_system_return_home_page")
	state_machine.remove("destiny_system_open_property_page")
	state_machine.remove("destiny_system_light_on_button")
	state_machine.remove("destiny_system_star_left_button")
	state_machine.remove("destiny_system_star_right_button")
	state_machine.remove("destiny_system_update_page_index")
	state_machine.remove("destiny_system_update_icon_show_tip")
	state_machine.remove("destiny_system_lighten_star")
	state_machine.remove("destiny_system_set_prop_cell")
end

function DestinySystem:onLoad()
    local effect_paths = "images/ui/effice/effect_47/effect_47.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_ui_destiny_icon/effect_ui_destiny_icon.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end
