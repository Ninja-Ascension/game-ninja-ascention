----------------------------------------------------------------------------------------------------
-- 说明：抢夺列表
-------------------------------------------------------------------------------------------------------
PlunderList = class("PlunderListClass", Window)

function PlunderList:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.propMould = nil		-- 当前要绘制的道具mould
	self.equipmentMould = nil	-- 抢夺对应的宝物id
	self.grabTankLink = nil		-- 抢夺对应的宝物id对应的抢夺表
	
	self.isSendNet = false 		-- 锁定当前是否在发请求
	self.isRunningTimer = false
	
	self.timestamp = 0
	self.changeTime = 5
	
	self.isRunningAvoidFightCD = false
	self.avoidFightTime = 0
	self.avoidFightCD = 0
	
	self.isChallenge = false --检查离开本页面的状态
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:close(fwin:find("PlunderListClass"))
	end
	
	app.load("client.campaign.plunder.PlunderListCell")
	local function init_plunder_list_terminal()
		local plunder_list_close_terminal = {
            _name = "plunder_list_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.isChallenge = false
				--> print("没进战斗的了-------------调关闭-----------------")
				fwin:close(instance)
				
				fwin:close("PlunderClass")
				if fwin:find("PlunderClass") == nil then
					fwin:open(Plunder:new(), fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local plunder_list_close_from_challenge_terminal = {
            _name = "plunder_list_close_from_challenge",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("进战斗的了-------------调关闭-----------------")
				instance.isChallenge = true
			
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(plunder_list_close_from_challenge_terminal)
		state_machine.add(plunder_list_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_plunder_list_terminal()
end

-- 更新数据
function PlunderList:onUpdateDatas()
	
	if true == self.isSendNet then
		return
	end
	
	self.isSendNet = true
	
	local function responsePlunderCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.onUpdateDraw == nil then
				return
			end
			response.node:onUpdateDraw()
			
			response.node.isSendNet = false
		end
	end

	protocol_command.refresh_grab_list.param_list = ""..self.propMould.."\r\n"..self.grabTankLink
	NetworkManager:register(protocol_command.refresh_grab_list.code, nil, nil, nil, self, responsePlunderCallback, false, nil)
end

function PlunderList:loading_cell()
	if PlunderList.cacheListView == nil then
		return
	end	

	local cell = PlunderListCell:createCell()
	cell:init(_ED._snatch_listing[PlunderList.asyncIndex], self.propMould, self.equipmentMould, self.grabTankLink)
	PlunderList.cacheListView:addChild(cell)
	PlunderList.cacheListView:requestRefreshView()
	PlunderList.asyncIndex = PlunderList.asyncIndex + 1
end

-- 更新画面
function PlunderList:onUpdateDraw()
	local ListView_3168 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_3168")	-- 要添加的地方
	ListView_3168:removeAllItems()

	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	PlunderList.asyncIndex = 1
	PlunderList.cacheListView = ListView_3168
	for i = 1,tonumber(_ED._snatch_listing_count) do
		--> print("****"..i.."****", _ED._snatch_listing[i].snatch_object_type)
		--> print("****"..i.."****", _ED._snatch_listing[i].snatch_object_id)
		--> print("****"..i.."****", _ED._snatch_listing[i].snatch_object_hero_id)
		--> print("****"..i.."****", _ED._snatch_listing[i].object_level)
		--> print("****"..i.."****", _ED._snatch_listing[i].object_name)
		--> print("****"..i.."****", _ED._snatch_listing[i].object_probability)
		--> print("****"..i.."****", _ED._snatch_listing[i].object_icon1)
		--> print("****"..i.."****", _ED._snatch_listing[i].object_icon2)
		--> print("****"..i.."****", _ED._snatch_listing[i].object_icon3)
		--> print("*************************************************************")
		-- local cell = PlunderListCell:createCell()
		-- cell:init(_ED._snatch_listing[i], self.propMould, self.equipmentMould, self.grabTankLink)
		-- ListView_3168:addChild(cell)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local cell = PlunderListCell:createCell()
			cell:init(_ED._snatch_listing[i], self.propMould, self.equipmentMould, self.grabTankLink)
			PlunderList.cacheListView:addChild(cell)
		else
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	ListView_3168:requestRefreshView()

end

--倒计时更新
function PlunderList:onUpdate(dt)
	-- 计算换一批
	if true == self.isRunningTimer then
		local clockTime = os.time()
		local Dvalue = clockTime - self.timestamp
		--> print("clockTime-----------------",clockTime ,Dvalue )
		if Dvalue >= 1 then
			self.timestamp = clockTime
			
			self.changeTime = self.changeTime - Dvalue
			
			if self.changeTime <= 0 then
			
				self.isRunningTimer = false
				self.changeTime = 5

				self.Label_57976:setVisible(true)
				self.Text_203:setVisible(false)
			else
			local timer =  math.ceil(self.changeTime)
				--> print("倒计时开始了-----------------", math.ceil(self.avoidFightTime)/60/60)
			
				local str = self:formatTime(timer)
				self.Text_203:setString(str)
			end
		end
	end
	
	-- 计算免战倒计时
	if true == self.isRunningAvoidFightCD then
		local clockTime = os.time()

		local Dvalue = clockTime - self.avoidFightCD
		if Dvalue >= 1 then
			self.avoidFightCD = clockTime
			self.avoidFightTime = self.avoidFightTime - Dvalue
			
			if self.avoidFightTime <= 0 then
			
				self.isRunningAvoidFightCD = false

				self.Panel_198:setVisible(false)
			else
				local timer2 =  math.ceil(self.avoidFightTime)
				local str2 = self:formatTime(timer2)
				self.Text_98:setString(str2)
			end
		end
	end
	
	if self.endurance ~= _ED.user_info.endurance then
		self.endurance = _ED.user_info.endurance
		local nowRecover = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3174_1")
		nowRecover:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
	end
end

-- 返回格式化时间,参数是秒
function PlunderList:formatTime (second)
	-- local timeTabel = {}
	-- local day = 0
	-- local hour = math.floor(tonumber(second)/3600)
	-- local minute = math.floor((tonumber(second)%3600)/60)
	-- local second = math.ceil(tonumber(second)%60)
	-- if second == 60 then
	-- 	second = 0
	-- 	minute = minute + 1
	-- end
	-- if minute == 60 then
	-- 	minute = 0
	-- 	hour = hour + 1
	-- end
	
	-- if hour < 10 then
	-- 	hour = "0"..hour
	-- end
	
	-- if minute < 10 then
	-- 	minute = "0"..minute
	-- end
	
	-- if second < 10 then
	-- 	second = "0"..second
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
function PlunderList:checkupAvoidFightCD()
	local now = getAvoidFightTime()
	self.avoidFightTime = zstring.tonumber(now)/1000
	if self.avoidFightTime > 0 then
		-- 显示 倒计时
		self.Panel_198:setVisible(true)
		self.avoidFightCD = os.time()-1
		self.isRunningAvoidFightCD = true
	else
		self.isRunningAvoidFightCD = false
		
	end
end


function PlunderList:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/indiana.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	-- 当前燃料
	local nowRecover = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3174_1")
	nowRecover:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
	
	--消耗燃料 
	local consumeRecover = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3177_1")
	consumeRecover:setString(2)
	-- 倒计时文本
	self.Text_203 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_203")
	-- 换一批文本
	self.Label_57976 = ccui.Helper:seekWidgetByName(self.roots[1], "Label_57976")
	
	-- 显示免战倒计时
	self.Panel_198 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_198")
	
	-- 免战计数文本
	self.Text_98 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_98")
	
	-- 换一批
	local exchangeButton =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_3179")

	local function exchangeButton_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				
				if false == self.isRunningTimer then
				
					TipDlg.drawTextDailog(tipStringInfo_plunder[5])
					self.timestamp =  os.time() -1
					self.Label_57976:setVisible(false)
					self.Text_203:setVisible(true)
					self.Text_203:setString("00:00:05")
					self.changeTime = 5
					self.isRunningTimer = true
					self:onUpdateDatas()
				end
			end
		end
	end
	exchangeButton:addTouchEventListener(exchangeButton_onTouchEvent)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if _ED.user_snatch_info.snatch_is_get == true or _ED._snatch_listing_count == 0 then
			self:onUpdateDatas()		
		else
			self:onUpdateDraw()
		end
		_ED.user_snatch_info.snatch_is_get = false
	else
		self:onUpdateDatas()
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_return"), nil, 
	{
		terminal_name = "plunder_list_close", 
		terminal_state = self.isPlunder,
		cell = self
	},
	nil, 2)	
	
	
	app.load("client.player.EquipPlayerInfomation") --顶部用户信息
	self.userinfoBar = EquipPlayerInfomation:new()
	fwin:open(self.userinfoBar,fwin._view)
	
	 self:checkupAvoidFightCD()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
	
	else
		-- 关闭 抢夺主界面
		fwin:close(fwin:find("PlunderClass"))
	end
end
function PlunderList:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		PlunderList.asyncIndex = 1
		if PlunderList.cacheListView ~= nil then
			PlunderList.cacheListView:removeAllItems()
			PlunderList.cacheListView = nil
		end
		fwin:close(self.userinfoBar)
		-- fwin:close(self.userinfoBar)
		-- 如果不是从挑战的方式离开的,则清空缓存
		if true ~= self.isChallenge then
			--> print("要关闭了---不是经战斗的--------------")
			app.load("client.utils.scene.SceneCacheData")
			local cacheName = SceneCacheNameEnum.PLUNDER
			local cacheData = SceneCacheData.read(cacheName)
			local lastIndex = cacheData.lastIndex
			SceneCacheData.delete(cacheName)
			
			if nil == cacheData then
				cacheData = SceneCacheData.getInitExample(cacheName)
			end
			cacheData.lastIndex = lastIndex
			SceneCacheData.write(cacheName, cacheData, "saveLastPageIndexForOnExitPlunderList")
		end
	end
end
function PlunderList:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
	else
		PlunderList.asyncIndex = 1
		PlunderList.cacheListView = nil
		fwin:close(self.userinfoBar)
		-- fwin:close(self.userinfoBar)
		-- 如果不是从挑战的方式离开的,则清空缓存
		if true ~= self.isChallenge then
			--> print("要关闭了---不是经战斗的--------------")
			app.load("client.utils.scene.SceneCacheData")
			local cacheName = SceneCacheNameEnum.PLUNDER
			local cacheData = SceneCacheData.read(cacheName)
			local lastIndex = cacheData.lastIndex
			SceneCacheData.delete(cacheName)
			
			if nil == cacheData then
				cacheData = SceneCacheData.getInitExample(cacheName)
			end
			cacheData.lastIndex = lastIndex
			SceneCacheData.write(cacheName, cacheData, "saveLastPageIndexForOnExitPlunderList")
		end
	end
	state_machine.remove("plunder_list_close_from_challenge")
	state_machine.remove("plunder_list_close")
	
end


function PlunderList:getGrabRankLink(equipmentMould)
	-- 宝物碎片关系->装备id
	local data = dms["grab_rank_link"]
	
	for i = 1 ,#data do
		
		local item = data[i]
		
		if zstring.tonumber(item[grab_rank_link.equipment_mould]) == zstring.tonumber(equipmentMould) then
		
			return i
		end
		
	end
	
	return nil
end

function PlunderList:init(propMould)
	self.propMould = propMould
	self.equipmentMould = dms.int(dms["prop_mould"], self.propMould, prop_mould.change_of_equipment)
	self.grabTankLink = dms.int(dms["equipment_mould"], self.equipmentMould, equipment_mould.grab_rank_link)
	if nil == self.grabTankLink or self.grabTankLink < 0 then
		self.grabTankLink = self:getGrabRankLink()
	end
end