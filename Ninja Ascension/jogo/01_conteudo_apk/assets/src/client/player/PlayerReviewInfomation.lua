-- ----------------------------------------------------------------------------------------------------
-- 说明：查看玩家阵容数据 
-- 创建时间：2015-04-02
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：李彪
-------------------------------------------------------------------------------------------------------

PlayerReviewInfomation = class("PlayerReviewInfomationClass", Window, true)
    
function PlayerReviewInfomation:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.cells.campaign.arena_head_icon_cell")
	app.load("client.cells.campaign.icon.arena_role_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.common.review_opponent_info_seat_cell")
	
	self.currentPlayerID = -1		--当前查看玩家的ID
	self.currentSeatIndex = 1		--当前查看阵容的索引
	
	self.equipIconPanelArr = {}
	
	self.myIconCell = nil
	
	self.currentPageIndex = 0
	
	self.number_currentShowPageIndex = 1 --当前页索引
	self.leadHero = nil --当前主角
	
    -- Initialize PlayerReviewInfomation page state machine.
    local function init_player_review_infomation_terminal()
	
		local init_player_review_close_terminal = {
            _name = "init_player_review_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local init_player_review_click_seat_terminal = {
            _name = "init_player_review_click_seat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- self:resetAllSelectedStatus()
				-- local tmpSeat = params._datas.seat
				-- tmpSeat:setSelected(true)
				
				-- if tmpSeat == self.myIconCell then
					-- self.cachePageView:scrollToPage(0)
				-- else
					-- for i, v in pairs(self.cacheListView:getItems()) do
						-- if v == tmpSeat then
							-- self.cachePageView:scrollToPage(i)
							-- break
						-- end
					-- end
				-- end
				
				-- self.currentPageIndex = self.cachePageView:getCurPageIndex()
		
				-- if self.currentPageIndex + 1 ~= self.currentSeatIndex then
					-- self.currentSeatIndex = self.currentPageIndex + 1
				-- end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--小icon被点击,更换界面
		local player_review_infomation_update_page_terminal = {
            _name = "player_review_infomation_update_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _index = instance:getIconIndex(params.source)
				instance.number_currentShowPageIndex = _index
				instance:updatePageView()
				--instance:updateListViewX()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(player_review_infomation_update_page_terminal)
		state_machine.add(init_player_review_close_terminal)
		state_machine.add(init_player_review_click_seat_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_player_review_infomation_terminal()
end

-- +1
function PlayerReviewInfomation:getIconIndex(source)
	if self.leadHero == source then
		return 1
	else
		local items = self.cacheListView:getItems()
		for i,v in ipairs(items) do
			if v == source then
				return i +1
			end
		end
	end
	return nil
end

function PlayerReviewInfomation:updatePageView()
	local items = self.cacheListView:getItems()				
	self.number_currentShowPageIndex = math.min(self.number_currentShowPageIndex, #items+1)
	self:setPageViewIndex(self.number_currentShowPageIndex - 1)
end

function PlayerReviewInfomation:setPageViewIndex(index)
	self.cachePageView:scrollToPage(index)    
end


-- 页面位置改变了,要去改顶部小图标的索引了
function PlayerReviewInfomation:changedPageviewIndex()
	
	--> print("-----------------------------------", self.number_currentShowPageIndex)
	
	--更新装备
	self:updataEquipment()
	
	local listView = self.cacheListView
	if self.number_currentShowPageIndex == 1 then
		local cell = self.leadHero
		if cell ~= nil then
			local _messageName = ObjectMessageNameEnum.player_review_infomation_icon_cell_set_chosen_state
			local _messageData = ObjectMessageData.getInitExample(_messageName)
			_messageData.source = cell
			_messageData.target = cell
			ObjectMessage.fireMessage(_messageName, _messageData)
		end
	elseif self.number_currentShowPageIndex > 1 then
	
		local cell = listView:getItem(self.number_currentShowPageIndex-2)
		if cell ~= nil then
			local _messageName = ObjectMessageNameEnum.player_review_infomation_icon_cell_set_chosen_state
			local _messageData = ObjectMessageData.getInitExample(_messageName)
			_messageData.source = cell
			_messageData.target = cell
			ObjectMessage.fireMessage(_messageName, _messageData)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
			self:updateListViewY()
		else
			self:updateListViewX()
		end
	end
end


function PlayerReviewInfomation:updateListViewY()
	local listView = self.cacheListView
	
	local newY = 0
	
	local showIndex = self.number_currentShowPageIndex -1
	-- 取出我当前的位置值
	local posY = showIndex * listView._csize.height
	
	-- 取出当前层容器的位置
	local containerY = listView:getInnerContainer():getPositionY()
	
	-- 计算两者之差
	local xxValue = posY + containerY

	local items = listView:getItems()

	-- 如果当前数末尾且大于4 则定位在最下
	if self.number_currentShowPageIndex ==  #_ED.player_ship and self.number_currentShowPageIndex > 4 then
		listView:jumpToBottom()
	elseif self.number_currentShowPageIndex == 2 then
		listView:jumpToTop()
	else
	
		--> print("xxValue- listView.viewWidth----------",xxValue , listView.viewWidth)
		if xxValue < 0 then
			-- 位于 屏幕外 直接移到左边
			newY = posY * -1 + listView._csize.height
			listView:getInnerContainer():setPositionY(newY)
			
		elseif xxValue > listView.viewHeight then
			-- 位于右侧 屏幕外 直接移到右边
			newY = (posY - listView.viewHeight) * -1
			listView:getInnerContainer():setPositionY(newY)
		
		elseif xxValue == 0 then
			newY = posY * -1 + listView._csize.height
			listView:getInnerContainer():setPositionY(newY)
		end
	end
end

function PlayerReviewInfomation:updateListViewX()
	local listView = self.cacheListView
	
	local newX = 0
	
	local showIndex = self.number_currentShowPageIndex -1
	-- 取出我当前的位置值
	local posX = showIndex * listView._csize.width
	
	-- 取出当前层容器的位置
	local containerX = listView:getInnerContainer():getPositionX()
	
	-- 计算两者之差
	local xxValue = posX + containerX

	local items = listView:getItems()

	-- 如果当前数末尾且大于4 则定位在最右
	if self.number_currentShowPageIndex ==  #_ED.player_ship and self.number_currentShowPageIndex > 4 then
		listView:jumpToRight()
	else
	
		--> print("xxValue- listView.viewWidth----------",xxValue , listView.viewWidth)
		if xxValue < 0 then
			-- 位于左侧 屏幕外 直接移到左边
			newX = posX * -1 + listView._csize.width
			listView:getInnerContainer():setPositionX(newX)
			
		elseif xxValue > listView.viewWidth then
			-- 位于右侧 屏幕外 直接移到右边
			newX = (posX - listView.viewWidth) * -1
			listView:getInnerContainer():setPositionX(newX)
		
		elseif xxValue == 0 then
			newX = posX * -1 + listView._csize.width
			listView:getInnerContainer():setPositionX(newX)
		end
	end
end

-------------------------------------------------------------------------------------------------
-- 旧有代码

function PlayerReviewInfomation:initDraw()

	local root = self.roots[1]
	local playerID = tonumber(self.currentPlayerID)
	
	ccui.Helper:seekWidgetByName(root, "Text_ckzr_name"):setString(_ED.player_name)--写用户名
	
	--显示猪脚头像
	local masterIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_zjtx")
	local shc = ArenaHeadIconCell:createCell()
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b then --or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		shc:init(_ED.player_ship[1].ship_template_id,_ED.player_ship[1].ship_picture)
	else
		shc:init(_ED.player_ship[1].ship_template_id)
	end
	masterIcon:addChild(shc)
	self.myIconCell = shc
	self.myIconCell:setChosen()
	self.leadHero = shc
	
	--显示队员Icon
	for i, v in pairs(_ED.player_ship) do
		if i ~= 1 then
			local tmpSHC = ArenaHeadIconCell:createCell()
			tmpSHC:init(v.ship_template_id)
			self.cacheListView:addChild(tmpSHC)
		end
	end
	--self:reviseListviewSize(self.cacheListView)
	
	-- 判定下 当前的间隔 
	local itemsMargin = self.cacheListView:getItemsMargin()
	--> print("itemsMargin------------------",itemsMargin)
	
	local csize = self.leadHero:getContentSize()
	self.cacheListView._csize = csize
	-- 计算基本数值
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.cacheListView.viewHeight = self.cacheListView:getContentSize().height
		local n = #_ED.player_ship - 1
		local containerHeight =  math.max(csize.height * n, self.cacheListView.viewHeight)

		local listviewSize = self.cacheListView:getInnerContainer():getContentSize()
		self.cacheListView:getInnerContainer():setContentSize(cc.size(listviewSize.width, containerHeight))
		self.cacheListView:jumpToTop()
		self.cacheListView.containerHeight = containerHeight

	else
		self.cacheListView.viewWidth = self.cacheListView:getContentSize().width
		local n = #_ED.player_ship - 1
		local containerWidth =  math.max(csize.width * n, self.cacheListView.viewWidth)

		local listviewSize = self.cacheListView:getInnerContainer():getContentSize()
		self.cacheListView:getInnerContainer():setContentSize(cc.size(containerWidth, listviewSize.height))
		self.cacheListView:jumpToLeft()
		self.cacheListView.containerWidth = containerWidth
	end

	--显示队员身体
	for i, v in pairs(_ED.player_ship) do
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			local function createHero( ... )
				local tmpROISC = ReviewOpponentInfoSeatCell:createCell()
				tmpROISC:init(v)
				self.cachePageView:addPage(tmpROISC)
			end
			cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,createHero,self)		
		else
			local tmpROISC = ReviewOpponentInfoSeatCell:createCell()
			tmpROISC:init(v)
			self.cachePageView:addPage(tmpROISC)			
		end
	end
	
	
		-- 定义滑动触发事件
	local function pageViewEvent(sender, eventType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.PageViewEventType.turning then

			self.number_currentShowPageIndex =  sender:getCurPageIndex() + 1
			self:changedPageviewIndex()
			-- self:updataEquipment()
        end
    end 
    self.cachePageView:addEventListener(pageViewEvent)

	--更新装备
	self:updataEquipment()
end

function PlayerReviewInfomation:addhero( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		for i, v in pairs(_ED.player_ship) do
			-- if i == 1 then
			-- else
				local tmpROISC = ReviewOpponentInfoSeatCell:createCell()
				tmpROISC:init(v)
				self.cachePageView:addPage(tmpROISC)
			-- end
		end
	end
end
function PlayerReviewInfomation:updataEquipment()
	local root = self.roots[1]
	
	if #self.equipIconPanelArr > 0 then
		--清空icon panel原有的元素
		for i, v in pairs(self.equipIconPanelArr) do
			for c, t in pairs(v:getChildren()) do
				v:removeChild(t)
			end
		end
	end
	
	if #self.equipIconPanelArr <= 0 then
		--武器icon 左上
		local equipIcon
		equipIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_17_1")
		table.insert(self.equipIconPanelArr, equipIcon)
		
		--腰带icon 左下
		equipIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_17_2")
		table.insert(self.equipIconPanelArr, equipIcon)
		
		--头盔icon 右上
		equipIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_17_4")
		table.insert(self.equipIconPanelArr, equipIcon)
		
		--盔甲icon 右下
		equipIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_17_5")
		table.insert(self.equipIconPanelArr, equipIcon)
		
		--宝物1 icon 左边
		equipIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_17_3")
		table.insert(self.equipIconPanelArr, equipIcon)
		
		--宝物2 icon 右边
		equipIcon = ccui.Helper:seekWidgetByName(root, "Panel_ckzr_17_6")
		table.insert(self.equipIconPanelArr, equipIcon)
	end
	
	--显示当前查看武将的数据
	local seatIndex = self.number_currentShowPageIndex
	local tmpShipData = _ED.player_ship[seatIndex]
	local captain_type = dms.int(dms["ship_mould"],tmpShipData.ship_template_id,ship_mould.captain_type)
	if captain_type == 3 then 
		--宠物
		local petPanel = ccui.Helper:seekWidgetByName(root, "Panel_zhanchong")
		if petPanel ~= nil then 
			petPanel:setVisible(true)
			self:onUpdateDrawPetInfo(tmpShipData)
		end
		local equipmentPanel = ccui.Helper:seekWidgetByName(root, "Panel_99")
		equipmentPanel:setVisible(false)

	else
		local petPanel = ccui.Helper:seekWidgetByName(root, "Panel_zhanchong")
		if petPanel ~= nil then 
			petPanel:setVisible(false)
		end
		local equipmentPanel = ccui.Helper:seekWidgetByName(root, "Panel_99")
		if equipmentPanel ~= nil then 
			equipmentPanel:setVisible(true)
		end
		local petIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_zc")
		if tmpShipData.pet_template_id ~= nil and tmpShipData.pet_template_id > 0 then 
			--有宠物
			if petIconPanel ~= nil then 
				petIconPanel:removeAllChildren(true)
				petIconPanel:setVisible(true)
				app.load("client.cells.ship.ship_head_cell")
				local cell = ShipHeadCell:createCell()
		        cell:init(nil,5,tmpShipData.pet_template_id)
		        petIconPanel:addChild(cell)
			end
		else
			if petIconPanel ~= nil then 
				petIconPanel:removeAllChildren(true)

			end
		end 
	end
	for i, v in pairs(tmpShipData.equipment) do
		if v ~= nil and v.user_equiment_template ~= nil then
			local eic = EquipIconCell:createCell()
			eic:init(9, v, v.user_equiment_template)
			self.equipIconPanelArr[i]:addChild(eic)
		end
	end
end

function PlayerReviewInfomation:onUpdateDrawPetInfo( ship)
	local root = self.roots[1]
	local pet_id = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
    local pet_formations = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
    for i=1,6 do
    	local image = ccui.Helper:seekWidgetByName(root, "Image_zw_"..i .. "_0")
    	image:setVisible(false)	
    	local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..i)
    	formationText:setString("")
    end
  	ccui.Helper:seekWidgetByName(root, "Text_zl"):setString("".. ship.hero_fight)
    local level = zstring.tonumber(ship.train_level)
    if pet_formations ~= nil then 
        --有阵型加成
        local addFormation = nil
        for k,v in pairs(pet_formations) do
            if level == zstring.tonumber(v[3]) then 
                addFormation = v
                break
            end
        end
        if addFormation == nil then 
            return
        end
        local formations = {}
        local counts = 0
        for i=1,6 do
        	local image = ccui.Helper:seekWidgetByName(root, "Image_zw_"..i .. "_0")
    		local attribute = addFormation[5+i]
            local lenghtAdd = string.len(attribute)
            local value = 1
            local index = 1
            if lenghtAdd > 2 then 
            -- 有加层
            	image:setVisible(true)
        		local info = zstring.split("".. attribute,"|")
	        	if info ~= nil and #info == 2 then
	        		--两种属性 必然是防御 物理防御，法术防御
	        		index = 40
	        		value = zstring.tonumber(zstring.split(""..info[1],",")[2])
              	end
	         	if info ~= nil and #info == 1 then 
                    --一种属性
                    local addAttribute = zstring.split("".. info[1],",")
                    index = zstring.tonumber(addAttribute[1]) + 1
                    value = zstring.tonumber(addAttribute[2])
               	end
                counts = counts + 1
	            local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..counts)
	            formationText:setString("" .._pet_tipString_info[13] .. i .. " " .. string_equiprety_name[index] .. value ..string_equiprety_name_vlua_type[index])
	        end
	    end
    end
end
function PlayerReviewInfomation:onEnterTransitionFinish()
	
    local tmpCsb = csb.createNode("campaign/ArenaStorage/ArenaStorage_view_line.csb")
	local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_view_line.csb")
	local root = tmpCsb:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(tmpCsb)
	
	tmpCsb:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	 	-- action:setFrameEventCallFunc(function (frame)
	  --       if nil == frame then
	  --           return
	  --       end

	  --       local str = frame:getEvent()
	  --       if str == "window_open_over" then	
	  --       	self:addhero()
	  --       end
	        
	  --   end)
	end
	--todo
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
		self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_ckzr_tx_0")
	else
		self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_ckzr_tx")
	end
	self.cachePageView = ccui.Helper:seekWidgetByName(root, "PageView_ckzr_2")
	-- -- touch事件监听
	-- local function cacheListViewTouchCallback(sender, eventType)
		-- self.currentPageIndex = self.cachePageView:getCurPageIndex()
		-- if self.currentPageIndex + 1 ~= self.currentSeatIndex then
			-- self.currentSeatIndex = self.currentPageIndex + 1
			
			-- --更新listview	self.currentPageIndex
			-- self:resetAllSelectedStatus()
			
			-- --如果是自己
			-- if self.currentPageIndex == 0 then
				-- --self.myIconCell:setSelected(true)
			-- else
				-- --self.cacheListView:getItem(self.currentPageIndex - 1):setSelected(true)
			-- end
			
			-- --更新装备
			-- self:updataEquipment()
		-- end
	-- end

	-- self.cachePageView:addEventListener(cacheListViewTouchCallback)	--addTouchEventListener
	
	--添加关闭按钮的事件
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zkzr_gb"), 	nil, 
	{
		terminal_name = "init_player_review_close", 	
		next_terminal_name = "init_player_review_close", 	
		current_button_name = "Button_zkzr_gb",		
		but_image = "player_review_close",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self:requestInitDatas(self.currentPlayerID)
end

--重置所有选择状态
function PlayerReviewInfomation:resetAllSelectedStatus()
	--self.myIconCell:setSelected(false)
	if #self.cacheListView:getItems() > 0 then
		for i, v in pairs(self.cacheListView:getItems()) do
			--v:setSelected(false)
		end
	end
end


--请求初始化数据
function PlayerReviewInfomation:requestInitDatas(palyerID)

	local function responseInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--> print("数据来了啦啦啦啦", self.currentPlayerID)
			if response.node ~= nil and response.node.roots ~= nil then
				response.node:initDraw()
			end
		end
	end
	
	protocol_command.look_at_user_fleet.param_list = palyerID 
	NetworkManager:register(protocol_command.look_at_user_fleet.code, nil, nil, nil, self, responseInitCallback, false, nil)
end


function PlayerReviewInfomation:init(playerID)-- 排名 战力值
	if playerID == -1 then self:setVisible(false) end
	self.currentPlayerID = playerID
end


function PlayerReviewInfomation:onExit()
	state_machine.remove("init_player_review_close")
	state_machine.remove("init_player_review_click_seat")
	state_machine.remove("player_review_infomation_update_page")
	
end
