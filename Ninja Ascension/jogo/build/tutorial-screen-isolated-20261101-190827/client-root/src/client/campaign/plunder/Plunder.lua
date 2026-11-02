-- ----------------------------------------------------------------------------------------------------
-- 说明：夺宝
-- 创建时间	2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
Plunder = class("PlunderClass", Window)
    
function Plunder:ctor()
    self.super:ctor()
	app.load("client.utils.objectMessage.ObjectMessage")
	app.load("client.cells.plunder.plunder_icon_cell")
	app.load("client.utils.ConfirmTip")
	app.load("client.campaign.plunder.PlunderCombiningPage")
	app.load("client.campaign.plunder.PlunderUseProp")
	
	
	
	self.roots = {}
	self.treasurePorp = {}		-- 存放所有宝物碎片
	self.residentShowQueue = {}		-- 存放所有常驻宝物模板ID
	self.treasureQueue = {}		-- 存放除了常驻宝物以外的模板ID
	
	self.allTreasureQueue = {} --所有(排过序)

	self.maxTreasureIndex = 0	-- 最大宝物量
	self.curentIndex = 0		-- 当前宝物索引
	
	self.lastComId = 0 -- 合成id
	self.lastId = 0
	self.isChange = nil
	self.changeTime = -1
	
	self.isFirstInto = true
	
	------04.11新修改内容
	self.number_currentShowPageIndex = 0 -- 当前显示的第几页 
	
	self.isRunningTimer = false --是否在跑计时器
	self.avoidFightTime = 0 --当前免战CD时间(ms)
	
	self.run_state = 0
	self.enter_type = -1
	
	self.missionEMID = -1 -- 教学时的指定宝物id
	self.missionSMID = -1 -- 教学时的指定宝物的碎片id
	self.missionIndex = -1 -- 教学时的指定宝物索引
	
	---------------------------
	
    -- Initialize Plunder page state machine.
    local function init_plunder_terminal()
		
		--显示隐藏本界面
		local plunder_show_and_hide_terminal = {
            _name = "plunder_show_and_hide",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 直接删除不在隐藏显示
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回
		local plunder_back_activity_terminal = {
            _name = "plunder_back_activity",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("CampaignClass") == nil then
						state_machine.excute("menu_show_campaign",0,2)
					else
						state_machine.excute("campaign_window_show",0,"")
					end
				else
					fwin:open(Campaign:new(), fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--打开免战牌
		local plunder_not_battle_terminal = {
            _name = "plunder_not_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:open(PlunderUseProp:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--有东西用了,检查下是不是要刷新倒计时了
		local prop_buy_prompt_use_info_to_plunder_terminal = {
            _name = "prop_buy_prompt_use_info_to_plunder",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _self = fwin:find("PlunderClass")
				if nil ~= _self then
					_self:usePropChangeData(params) 	
					-- instance:usePropChangeData(params) 	
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--合成
		local plunder_combining_conect_terminal = {
            _name = "plunder_combining_conect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				if nil == fwin:find("PlunderClass") then
				
					return 
				end
				
				instance.curentIndex = instance:getCurentIndex()
				if missionIsOver() == false then
					instance.curentIndex = self.missionIndex+1
				end
				
				local function responseCurentIndexCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 记录下当前id
						if response.node ~= nil and response.node.roots ~= nil then
							response.node.lastComId = response.node.allTreasureQueue[response.node.curentIndex].id
							local items = response.node.litterPageView:getPage(response.node.litterPageView:getCurPageIndex())
							state_machine.excute("plunder_combining_page_action", 0, items)
						end
					else
						if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
							instance:setComposeStates(true)
						end
					end
					
				end
				
				
				if instance:checkIsOver(instance.allTreasureQueue[instance.curentIndex]) == true then
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						state_machine.lock("plunder_icon_cell_set_chosen_state_change")					
					end
					local datas = dms.searchs(dms["grab_rank_link"], grab_rank_link.equipment_mould, instance.allTreasureQueue[instance.curentIndex].id)
					local grabRankLink = datas[1][grab_rank_link.id]
					if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
						instance:setComposeStates(false)
					end
					protocol_command.prop_compound.param_list = ""..grabRankLink.."\r\n".."2".."\r\n".."1"
					NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, instance, responseCurentIndexCallback, false, nil)
				else
					TipDlg.drawTextDailog(tipStringInfo_plunder[2])
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--小icon被点击,更换界面
		-- 抢夺战斗结束定位（由于优化，定时器加载，所以等到定时器结束在定位）by-tongwensen
		local plunder_update_page_terminal = {
            _name = "plunder_update_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if instance == nil or instance.roots == nil or instance.getIconIndex == nil then
					return
					
				end
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or 
					__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_yugioh then
					if _ED.last_plunders_litter_page.open == 0 then
						local _index = instance:getIconIndex(params.source)
						_ED.last_plunders_litter_page.page = _index
						instance.number_currentShowPageIndex = _index
					elseif _ED.last_plunders_litter_page.open == 1 then
						if _ED.last_plunders_litter_page.page == nil then
							_ED.last_plunders_litter_page.page = 1
						end
						instance.number_currentShowPageIndex = _ED.last_plunders_litter_page.page
						if instance.number_currentShowPageIndex == 0 then
							instance.number_currentShowPageIndex = 1
						end
						local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_3068") -- 上面小列表
	    				listView:getItem(0):removeChosen()
	    				local item = listView:getItem(instance.number_currentShowPageIndex - 1)
	    				if item ~= nil then
	    					item:setChosen()
	    				else
	    					listView:getItem(0):setChosen()
	    				end
						
						_ED.last_plunders_litter_page.open = 0
					end
				else
					local _index = instance:getIconIndex(params.source)
					instance.number_currentShowPageIndex = _index
				end
				instance:updatePageView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--调用动画结束,刷新界面
		local plunder_combining_page_ready_over_terminal = {
            _name = "plunder_combining_page_ready_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:composeWin()
				instance:onUpdataProcessing()

				local function getIsChange()
				
					for i,v in ipairs(instance.allTreasureQueue) do
						if tonumber(instance.lastComId) == tonumber(v.id) then
							return false
						end
					end
					return true 
				end
				
				if getIsChange() == true then
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						fwin:close(instance)
						fwin:open(Plunder:new(), fwin._view)
					else
						instance.isChange = true
						instance.changeTime = 5
					end
				else
				
					instance:onUpdataDrawCopy()
				end
				
				
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local plunder_update_pageview_reloadDraw_terminal = {
            _name = "plunder_update_pageview_reloadDraw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local index = instance.litterPageView:getCurPageIndex()
				instance.litterPageView:getPage(index):reloadDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--检查是否有奖励
		local plunder_update_pageview_check_reward_terminal = {
            _name = "plunder_update_pageview_check_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:checkForRewardAndMission()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
				--重刷
		local plunder_update_pageview_update_all_terminal = {
            _name = "plunder_update_pageview_update_all",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	--重刷整个界面
            	instance:updateListviewAndPageView(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(prop_buy_prompt_use_info_to_plunder_terminal)
		state_machine.add(plunder_show_and_hide_terminal)
		state_machine.add(plunder_back_activity_terminal)
		state_machine.add(plunder_not_battle_terminal)
		state_machine.add(plunder_combining_conect_terminal)
		state_machine.add(plunder_update_page_terminal)
		state_machine.add(prop_buy_prompt_use_info_terminal)
		state_machine.add(plunder_combining_page_ready_over_terminal)
		state_machine.add(plunder_update_pageview_reloadDraw_terminal)
		state_machine.add(plunder_update_pageview_check_reward_terminal)
		state_machine.add(plunder_update_pageview_update_all_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_plunder_terminal()
end


----------------04.11

-- 根据顶部icon查找当前选择索引
function Plunder:getIconIndex(source)  
	local items = self.litterListView:getItems()
	for i,v in ipairs(items) do
		if v == source then
			return i
		end
	end
	return nil
end

-- 根据顶部icon的id查找当前选择索引
function Plunder:getIdIndex(source)  
	local index = 0
	
	local items = self.litterListView:getItems()
	for i,v in ipairs(items) do
		if v:getId() == source then
			index = i-1
			break
		end
	end

	return index
end

-- 根据顶部icon的id查找当前选择索引
function Plunder:getIdIndexID(index)  
	if self.litterListView then
	
		local items = self.litterListView:getItems()
		for i,v in ipairs(items) do
			if i == index then
				return v:getId()
			end
		end
	end
	return nil
end
-- 更新页面内容
function Plunder:updateListviewAndPageView(update_type)
	local currentIndex = self:getCurentIndex()
	local currentId = self:getIdIndexID(currentIndex)
	local lastnumber = #self.allTreasureQueue
	self:onUpdataProcessing()
	local nownumber = #self.allTreasureQueue
	if lastnumber == nownumber then
		--心法没有变多刷新当前
		state_machine.excute("plunder_update_pageview_reloadDraw",0,update_type)
		return   
	end

	--刷新所有
	self:onUpdataDraw()

	local findIndex = 0
	for k,v in pairs(self.allTreasureQueue) do
		if v.id == currentId then
			findIndex = k
		end
	end
	self.number_currentShowPageIndex = findIndex
	self:updatePageView()
	self:setListViewIndex()
end
-- 更新页面内容
function Plunder:updatePageView()
	-- pageview的index是0开始所以-1
	
	local items = self.litterListView:getItems()				
	self.number_currentShowPageIndex = math.min(self.number_currentShowPageIndex, #items)
	self:setPageViewIndex(self.number_currentShowPageIndex - 1)
end

-- 跳转到指定页面
function Plunder:setPageViewIndex(index)
	-- local nowIndex = self.litterPageView:getCurPageIndex()
	index = math.max(index,0)
	-- local x = index - nowIndex
	-- self.litterPageView:getInnerContainer():setPositionX(0)
	
	
	------------------------------
	-- local index = self.litterPageView:getCurPageIndex()
	local page = self.litterPageView:getPage(index)
	local leng = #self.litterPageView:getPages()
	
	-- 出于进入时更快显示的考虑,只加载当前显示的这一个.
	if self.isFirstInto == true then
		self.isFirstInto = false
		page:loadDraw()
	else
		-- 非首次进入时,加载三个
		for i = 0, leng-1 do
			-- 3个 -------------------------------------------
			if i < index - 1 or i > index +1 then
				self.litterPageView:getPage(i):removeDraw()
			else
				self.litterPageView:getPage(i):loadDraw()
			end
		end
	
	end
	-- ----------------------------------	
	
	self.litterPageView:scrollToPage(index)    
end

		
function Plunder:setListViewIndex(index)
	
	if nil == index then
		index = self.number_currentShowPageIndex - 1
	end
	
	index = math.max(index,0)
	
	local _messageName = ObjectMessageNameEnum.plunder_icon_cell_set_chosen_state
	local _messageData = ObjectMessageData.getInitExample(_messageName)
	_messageData.source = self.litterListView:getItem(index)
	_messageData.target = _messageData.source
	--> print("ffffffffffffffffff---------------", index,_messageData.source)
	ObjectMessage.fireMessage(_messageName,_messageData)
end

-- 页面位置改变了,要去改顶部小图标的索引了
function Plunder:changedPageviewIndex()

	local listView = self.litterListView
	local cell = listView:getItem(self.number_currentShowPageIndex-1)
	if cell ~= nil then
		local _messageName = ObjectMessageNameEnum.plunder_icon_cell_set_chosen_state
		local _messageData = ObjectMessageData.getInitExample(_messageName)
		_messageData.source = cell
		_messageData.target = cell
		ObjectMessage.fireMessage(_messageName, _messageData)
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	
	else
	
		local newX = 0
		
		local showIndex = self.number_currentShowPageIndex
		-- 取出我当前的位置值
		local posX = showIndex * listView._csize.width
		
		-- 取出当前层容器的位置
		local containerX = listView:getInnerContainer():getPositionX()
		
		-- 计算两者之差
		local xxValue = posX + containerX

		
		local items = self.litterListView:getItems()
		--> print("items------------------------", #items)
		-- if #items <= 4 then
			-- listView:getInnerContainer():setPositionX(0)
		-- else
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
		-- end
	end
end

--倒计时更新
function Plunder:onUpdateTime(dt)
	if true == self.isRunningTimer then
		local clockTime = os.time() --os.clock()
		local Dvalue = clockTime - self.timestamp
		--> print("clockTime-----------------",clockTime ,Dvalue )

		if Dvalue >= 1 then
			self.timestamp = clockTime
			self.avoidFightTime = self.avoidFightTime - Dvalue
			
			if self.avoidFightTime <= 0 then
				self.isRunningTimer = false
				
				self.avoidButton:setVisible(true)
				self.runningTitle:setVisible(false)
				self.runningText:setVisible(false)
			else
				--> print("倒计时开始了-----------------", math.ceil(self.avoidFightTime)/60/60)
				local timer =  math.ceil(self.avoidFightTime)
				local str = self:formatTime(timer)
				self.runningText:setString(str)
			end
		end
	end
	
	
	
			
	
	
end

-- 返回格式化时间,参数是秒
function Plunder:formatTime (second)
	-- local timeTabel = {}
	-- local day = 0
	-- local hour = math.floor(tonumber(second)/3600)
	-- local minute = math.floor((tonumber(second)%3600)/60)
	-- local second = math.ceil(tonumber(second)%60)
	-- if second == 60 then
		-- second = 0
		-- minute = minute + 1
	-- end
	-- if minute == 60 then
		-- minute = 0
		-- hour = hour + 1
	-- end
	
	-- if hour < 10 then
		-- hour = "0"..hour
	-- end
	
	-- if minute < 10 then
		-- minute = "0"..minute
	-- end
	
	-- if second < 10 then
		-- second = "0"..second
	-- end
	-- local str = hour..":"..minute..":"..second
	-- return str
	
	local timeString = ""
	timeString = timeString .. string.format("%02d",math.floor(tonumber(second)/3600)) .. ":"
	timeString = timeString .. string.format("%02d",math.floor((tonumber(second)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d",math.floor(tonumber(second)%60))
	
	return timeString
end

-- 检查免战cd
function Plunder:checkupAvoidFightCD()
	local now = getAvoidFightTime()
	self.avoidFightTime = zstring.tonumber(now)/1000
	if self.avoidFightTime > 0 then
		-- 显示 倒计时
		self.avoidButton:setVisible(false)
		self.runningTitle:setVisible(true)
		self.runningText:setVisible(true)
		self.timestamp = os.time()-1
		self.isRunningTimer = true
	else
		self.isRunningTimer = false
		
	end
end


--合成成功了
function Plunder:composeWin()
	--从返回的奖励里取值
	local reward = getSceneReward(5)
	
	if reward == nil then
		return
	end
	local reward_list = reward.show_reward_list
	local mould_id = tonumber(reward_list[1].prop_item)
	local page = EquipFragmentInfomation:createCell()
	page:init(mould_id, 2 ,3)
	fwin:open(page, fwin._ui)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		state_machine.unlock("plunder_icon_cell_set_chosen_state_change")					
	end

	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		self:setComposeStates(true)
	end
end 

function Plunder:getCurentIndex()
	return self.litterPageView:getCurPageIndex() + 1
end

---------------end

function Plunder:getInstance(mould)
	local propInstace = nil
	for i,prop in pairs(_ED.user_prop) do
		if tonumber(prop.user_prop_template) == tonumber(mould) then
			propInstace = prop
			break
		end
	end
	return propInstace
end

-- 检查碎片是否凑齐
function Plunder:checkIsOver(mould)
	if mould == nil then
		return false
	end
	local result = true
	local datas = dms.searchs(dms["grab_rank_link"], grab_rank_link.equipment_mould, mould.id)
	local grabRankLink = datas[1][grab_rank_link.id]
	
	local need_prop = 
	{
		tonumber(dms.int(dms["grab_rank_link"], grabRankLink, grab_rank_link.need_prop1)),
		tonumber(dms.int(dms["grab_rank_link"], grabRankLink, grab_rank_link.need_prop2)),
		tonumber(dms.int(dms["grab_rank_link"], grabRankLink, grab_rank_link.need_prop3)),
		tonumber(dms.int(dms["grab_rank_link"], grabRankLink, grab_rank_link.need_prop4)),
		tonumber(dms.int(dms["grab_rank_link"], grabRankLink, grab_rank_link.need_prop5)),
		tonumber(dms.int(dms["grab_rank_link"], grabRankLink, grab_rank_link.need_prop6))
	}
	
	for i = 1,6 do
		if	need_prop[i] ~= -1 then
			local prop = self:getInstance(need_prop[i])
			if prop == nil then
				result = false
				break
			elseif prop.prop_number == 0 then
				result = false
				break
			end
		end
	end
	return result
end

-- 数据处理
function Plunder:onUpdataProcessing()
	
	self.allTreasureQueue = {}
	self.treasurePorp = {}
	self.maxTreasureIndex = 0
	local propIndex = 1 
	for i, prop in pairs(_ED.user_prop) do
		if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.storage_page_index) == 6 then
			self.treasurePorp[propIndex] = prop
			propIndex = propIndex + 1
		end
	end
	
	
	-- 常驻宝物
	local residentQueue = dms.searchs(dms["grab_rank_link"], grab_rank_link.is_resident, 1)
	
	for i = 1,#residentQueue do
		local id = tonumber(residentQueue[i][grab_rank_link.equipment_mould])
		local quality = dms.int(dms["equipment_mould"], id, equipment_mould.rank_level)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level)
		end
		self.residentShowQueue[i] = {
			id = id,
			quality = quality,
		}
	end
	-- 获取背包中宝物
	local treasureQueue ={}
	propIndex = 1
	for i,prop in pairs(self.treasurePorp) do
		local isSame = false
		local changeOfEquipmentMould = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.change_of_equipment)

		for l,tem in pairs(treasureQueue) do
			if changeOfEquipmentMould == tem.id then
				isSame = true
				break
			end
		end
		if isSame == false then
			local id = changeOfEquipmentMould
			local quality = dms.int(dms["equipment_mould"], id, equipment_mould.rank_level)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level)
			end
			treasureQueue[propIndex] = {
				id = id,
				quality = quality,
			}
			propIndex = propIndex + 1
		end

	end
	
	-- 去除重复的宝物id
	function checkupRepeat(v)
		for i=1, #self.residentShowQueue do
			if tonumber(self.residentShowQueue[i].id) == tonumber(v.id) then
				return true
			end
		end
		return false
	end
	
	local tempQueue = {}
	for i=1, #treasureQueue do
		if false == checkupRepeat(treasureQueue[i]) then
			table.insert(tempQueue, treasureQueue[i])
		end
	end
	
	for i,v in ipairs(self.residentShowQueue) do
		table.insert(tempQueue, v)
	end
	
	-- id排序
	function _idSort(a, b)
		if a.id > b.id then
			return true
		end
		return false
	end
	table.sort(tempQueue, _idSort)
	
	-- -- 品质排序
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		function _qualitySort(a, b)
			if a.quality > b.quality then
				return true
			end
			return false
		end
		table.sort(tempQueue, _qualitySort)
	end
	-- 回灌新值
	self.allTreasureQueue = tempQueue
end

-- 刷新界面
function Plunder:onUpdataDrawCopy()
	local index = self.litterPageView:getCurPageIndex()
	local id = self.litterListView:getItem(index).data
	local pageCell = self.litterPageView:getPage(index)
	
	local csize = nil

	for i,v in ipairs(self.allTreasureQueue) do
		self.maxTreasureIndex = self.maxTreasureIndex + 1
		if tonumber(id) == tonumber(v.id) then
	
			state_machine.excute("plunder_combining_page_update_treasure", 0, pageCell)
			
			return
		end
	end
	

	
	-- if status == false then
		-- local cell = nil 
		-- self.litterListView:removeItem(index)
		-- self.litterPageView:removePageAtIndex(index)
		-- if index - 1 >= 0 then
			-- cell = self.litterListView:getItem(index)
		-- else
			-- cell = self.litterListView:getItem(index)
		-- end
		-- cell = self.litterListView:getItem(0)
		-- if cell ~= nil then
			-- local _messageName = ObjectMessageNameEnum.plunder_icon_cell_set_chosen_state
			-- local _messageData = ObjectMessageData.getInitExample(_messageName)
			-- _messageData.source = cell
			-- _messageData.target = cell
			-- ObjectMessage.fireMessage(_messageName, _messageData)
		-- end
		
		-- if index - 1 >= 0 then
			-- self.litterPageView:scrollToPage(index-1)
		-- else
			-- self.litterPageView:scrollToPage(index+1)
		-- end
		-- self.litterPageView:scrollToPage(0)
	-- end
	
end

function Plunder:onUpdataDraw()
	self.litterListView:removeAllItems()
	self.litterPageView:removeAllPages()
	
	--> print("self.allTreasureQueue------", #self.allTreasureQueue)
	
	local csize = nil

	local function calcListViewSize( ... )
		-- 计算基本数值
		self.litterListView.viewWidth = self.litterListView:getContentSize().width
		local n = #self.allTreasureQueue
		local containerWidth =  math.max(csize.width * n, self.litterListView.viewWidth)

		local listviewSize = self.litterListView:getInnerContainer():getContentSize()
		self.litterListView:getInnerContainer():setContentSize(cc.size(containerWidth, listviewSize.height))
		self.litterListView:jumpToLeft()
		self.litterListView.containerWidth = containerWidth
		self.litterListView:requestRefreshView()
	end

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local index = 0
		local function repetBack( ... )
			index = index + 1
			if index > #self.allTreasureQueue then
				calcListViewSize()
				self:stopAllActions()
				if self.enter_type == 1 then
					state_machine.excute("plunder_update_page",0,"")
				end
				return
			end

			local v = self.allTreasureQueue[index]
			if v ~= nil then
				local cell = PlunderIconCell:createCell()
				cell:init(v.id)
				self.litterListView:addChild(cell)
				
				local page = PlunderCombiningPage:createCell()
				page:init(v.id)

				self.litterPageView:insertPage(page,self.maxTreasureIndex)
				self.maxTreasureIndex = self.maxTreasureIndex + 1

				if csize == nil then
					csize = cell:getContentSize()
				end
				self.litterListView._csize = csize
			end
		end
		repetBack()
		self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(repetBack))))
	else
		for i,v in ipairs(self.allTreasureQueue) do
			local cell = PlunderIconCell:createCell()
			cell:init(v.id)
			self.litterListView:addChild(cell)
			
			local page = PlunderCombiningPage:createCell()
			page:init(v.id)

			self.litterPageView:insertPage(page,self.maxTreasureIndex)
			self.maxTreasureIndex = self.maxTreasureIndex + 1

			if csize == nil then
				csize = cell:getContentSize()
			end
		end
		self.litterListView._csize = csize
		calcListViewSize()
	end
end

function Plunder:usePropChangeData(params)
	--检查道具模板id
	local params_id = params.mould_id
	if zstring.tonumber(self.smallAvoidTemplateId) == params_id or 
		zstring.tonumber(self.bigAvoidTemplateId) == params_id then
		self:checkupAvoidFightCD()
	end
end

-- function Plunder:readCacheUpdatePageView()
	--> print("谁要更新了---------11-------------------------------")
	-- app.load("client.utils.scene.SceneCacheData")
	-- local cacheName = SceneCacheNameEnum.PLUNDER
	-- local cacheData = SceneCacheData.read(cacheName)

	-- if nil ~= cacheData then
		--> print("谁要更新了-----------22222-----------------------------")
		-- self.number_currentShowPageIndex = cacheData.lastIndex
		-- self:updatePageView()
	-- end
-- end

function Plunder:setComposeStates(isTouch)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local hechengButton = ccui.Helper:seekWidgetByName(root, "Button_synthesis_2")
	if isTouch == true then 
		hechengButton:setColor(cc.c3b(255, 255, 255))
		hechengButton:setTouchEnabled(true)
	else
		hechengButton:setColor(cc.c3b(150, 150, 150))
		hechengButton:setTouchEnabled(false)
	end
end

function Plunder:showReward(rewardMouldId)
	app.load("client.reward.AcquireRewad")
	local win = AcquireRewad:new()
	win:initProp(rewardMouldId)
	fwin:open(win, fwin._view)
end

function Plunder:showWinReward(rewardMouldId)
	--显示获得吧
	self:showReward(rewardMouldId)
	-- 定位到之前
	
	--self:updatePageView()
end

function Plunder:getRewardMouldId()
	app.load("client.utils.scene.SceneCacheData")
	local cacheName = SceneCacheNameEnum.PLUNDER
	local cacheData = SceneCacheData.read(cacheName)

			
	
	
	if nil ~= cacheData then
		
		if cacheData.isWin == nil then
			-- 没有发生过战斗的情况
			if nil ~= cacheData.lastIndex then
				
				self.lastId = cacheData.lastIndex
			end
			
			SceneCacheData.delete(cacheName)
			return -1
		
		else
			-- 检查奖励id
			local rewardMouldId = cacheData.rewardMouldId
			if nil ~= cacheData.rewardMouldId and nil ~= cacheData.propMouldId  and  cacheData.rewardMouldId == cacheData.propMouldId then
				self.lastId = cacheData.lastIndex
				SceneCacheData.delete(cacheName)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or
					__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					_ED.user_snatch_info.snatch_is_get = true
				end
				return cacheData.rewardMouldId
			else
				--cacheData.propMouldId = cacheData.propMouldId or cacheData.rewardMouldId
				self.lastId = cacheData.lastIndex
				cacheData.rewardMouldId = nil
				cacheData.isWin = nil
				SceneCacheData.write(cacheName, cacheData,"getRewardMouldId")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					_ED.user_snatch_info.snatch_is_get = false
				end
				--开路吧
				--> print("开路吧-------------")
				--state_machine.excute("plunder_show_and_hide", 0)
				local page = PlunderList:new()
				page:init(cacheData.propMouldId)
				fwin:open(page, fwin._view)
				return nil
			end
		
		end
	end
	return -1
end
		
function Plunder:createLayout()

	self.missionEMID = -1 -- 教学时的指定宝物id
	self.missionSMID = -1 -- 教学时的指定宝物的碎片id
	self.missionIndex = -1 -- 教学时的指定宝物的位置索引
	
	-- 如果在教学中,自动跳转到指定碎片页
	-- 电探21号
	if missionIsOver() == false then
		local eid = dms.int(dms["prop_mould"], _plunder_patch_mould, prop_mould.change_of_equipment)
		self.missionSMID = pid
		self.missionEMID = eid
	end	

	local root = self.roots[1] 
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
	else
		local action = csb.createTimeline("campaign/Snatch/snatch_0.csb")
		action:gotoFrameAndPlay(0, action:getDuration(), false)
		root:runAction(action)
	end
	
	self.litterListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_3068") -- 上面小列表
	self.litterPageView = ccui.Helper:seekWidgetByName(self.roots[1], "PageView_56636") -- 下面对应列表
	
	-- 定义滑动触发事件
	local function pageViewEvent(sender, eventType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if eventType == ccui.PageViewEventType.turning then
			-- if self.boolean_issrolllock == true then
				-- self.boolean_issrolllock = false
				-- return
			-- end
			self.number_currentShowPageIndex =  sender:getCurPageIndex() + 1
			self:changedPageviewIndex()
			--self:drawProperty()

			-- ------------------------------
			local index = self.litterPageView:getCurPageIndex()
			local page = self.litterPageView:getPage(index)
			local leng = #self.litterPageView:getPages()
			
			-- 不是直接指定的	
			for i = 0, leng-1 do
				-- 3个 -------------------------------------------
				if i < index - 1 or i > index +1 then
					self.litterPageView:getPage(i):removeDraw()
				else
					self.litterPageView:getPage(i):loadDraw()
				end
			end
			-- ----------------------------------	
		end
	end 
	self.litterPageView:addTouchEventListener(pageViewEvent)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_return"), nil,     		--返回
	{
		terminal_name = "plunder_back_activity", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 2)	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_free_war"), nil,     	--免战
	{
		terminal_name = "plunder_not_battle", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_synthesis_2"), nil, 		--合成
	{
		terminal_name = "plunder_combining_conect", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	--免战牌
	self.avoidButton = ccui.Helper:seekWidgetByName(self.roots[1], "Button_free_war")
	--计时标题
	self.runningTitle = ccui.Helper:seekWidgetByName(self.roots[1], "Label_time_0")
	--计时文本
	self.runningText = ccui.Helper:seekWidgetByName(self.roots[1], "Label_time")
	
	-- 夺宝初始化
	self:onUpdataProcessing()
	self:onUpdataDraw()

	-- 记录免战卡id
	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	-- 11 小免
	self.smallAvoidTemplateId = tonumber(config[11])
	-- 12 大免
	self.bigAvoidTemplateId = tonumber(config[12])

	self:checkupAvoidFightCD()
	
	self.number_currentShowPageIndex = self:getIdIndex(self.lastId)
	
	local index = self.number_currentShowPageIndex
	-- 如果在教学中,自动跳转到指定碎片页
	-- 电探21号
	if missionIsOver() == false then
		self.missionIndex = self:getIdIndex(self.missionEMID)
		index = self.missionIndex
	end	
	
	self:setListViewIndex(index)
	self:setPageViewIndex(index)

	---------------------------------------------------
	--顶部属性栏
	-- app.load("client.player.UserInformationHeroStorage")
	-- self.userInformationHeroStorage = UserInformationHeroStorage:new()
	-- fwin:open(self.userInformationHeroStorage, fwin._view)
	
	app.load("client.player.EquipPlayerInfomation") --顶部用户信息
	self.userinfoBar = EquipPlayerInfomation:new()
	fwin:open(self.userinfoBar,fwin._view)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		if self.enter_type == 1 then
			state_machine.excute("plunder_update_page",0,"")
		end
	end
end

function Plunder:saveLastPageIndex()
	
	local id = self:getIdIndexID(tonumber(self.number_currentShowPageIndex))
	
	if nil ~= id then

	-----------记录当前场景缓存数据
	app.load("client.utils.scene.SceneCacheData")
	local cacheName = SceneCacheNameEnum.PLUNDER
	local cacheData = SceneCacheData.read(cacheName)
	if nil == cacheData then
		cacheData = SceneCacheData.getInitExample(cacheName)
	end
	cacheData.lastIndex = id
	SceneCacheData.write(cacheName, cacheData, "saveLastPageIndex")
	end
end

function Plunder:onUpdate(dt)
	self:onUpdateTime(dt)
	
	if zstring.tonumber(self.changeTime) > 0 then
		self.changeTime = self.changeTime - 1
	end
	
	if true == self.isChange and self.changeTime == 0  then
		self.isChange = nil
		self.changeTime = -1
		self.number_currentShowPageIndex = 1
		self:onUpdataDraw()
		self:setListViewIndex(0)
		self:setPageViewIndex(0)
	end
	
	
	if self.enter_type == -1 then
		return
	end

	if self.run_state == 2 then
		self.run_state = 3
		
		if missionIsOver() == false then
			executeResetCurrentEvent()
		end	
	end
	self.run_state = self.run_state + 1
	
	
end

function Plunder:init(_enter_type)
	self.enter_type = _enter_type
end
function Plunder:checkForRewardAndMission()
	local rewardMouldId = self:getRewardMouldId()
	if nil ~= rewardMouldId then
		if rewardMouldId ~=  -1 then
			self:showWinReward(rewardMouldId)
		end
	end
end
function Plunder:onEnterTransitionFinish()


	local csbPlunder = csb.createNode("campaign/Snatch/snatch_0.csb")
	local root = csbPlunder:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		self:createLayout()
		self:checkForRewardAndMission()
	else
		local rewardMouldId = self:getRewardMouldId()
		-- 检查是否打开页面内容
		-- 进入会检查数据再做跳转
		if nil ~= rewardMouldId then
			self:createLayout()
			if rewardMouldId ~=  -1 then
				self:showWinReward(rewardMouldId)
			end
		end
	end

	-- self.name = "Plunder"
	-- local function callback(_self)
		-- local this = _self
		-- return function(instance,params)
			-- print("------------------------------------>")
			-- print(self)
			-- print(_self)
			-- print(this)
			-- print(instance)
			
			-- print(self.plunderPropChangeHandler)
			-- print(_self.plunderPropChangeHandler)
			-- print(this.plunderPropChangeHandler)
			-- print(instance.plunderPropChangeHandler)
			
			-- print(instance)
			-- print(params)
			-- this:plunderPropChangeHandler(instance,params)
		-- end
	-- end

	--添加消息监听
	--ObjectMessage.addMessageListener(ObjectMessageNameEnum.prop_use_change, self, callback(self))
	self.run_state = 1
	
	state_machine.excute("menu_button_hide_highlighted_all", 0, nil)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:onLoad()
	end
end

function Plunder:plunderPropChangeHandler(instance,params) 	
	self:usePropChangeData(params)
end
function Plunder:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		self.litterListView:removeAllItems()
		self.litterPageView:removeAllPages()
		fwin:close(self.userinfoBar)
	end
end
function Plunder:onExit()
	self:saveLastPageIndex()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local effect_paths = "images/ui/effice/effect_ui_85/effect_ui_85.ExportJson"
	    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	else
		fwin:close(self.userinfoBar)
	end
	state_machine.remove("plunder_show_and_hide")
	state_machine.remove("plunder_back_activity")
	state_machine.remove("plunder_not_battle")
	--state_machine.remove("plunder_combining_conect")
	state_machine.remove("prop_buy_prompt_use_info")
	state_machine.remove("plunder_update_pageview_reloadDraw")
	state_machine.remove("plunder_update_pageview_check_reward")
	state_machine.remove("plunder_update_pageview_update_all")
end

function Plunder:onLoad( ... )
	local effect_paths = "images/ui/effice/effect_ui_85/effect_ui_85.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end