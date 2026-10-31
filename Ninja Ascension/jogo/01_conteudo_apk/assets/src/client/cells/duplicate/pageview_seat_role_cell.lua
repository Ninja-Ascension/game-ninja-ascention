----------------------------------------------------------------------------------------------------
-- 说明：副本界面npc Q形象
-------------------------------------------------------------------------------------------------------
PageViewSeatRole = class("PageViewSeatRoleClass", Window)

function PageViewSeatRole:ctor()
    self.super:ctor()
	app.load("client.campaign.mine.MineAttackTerritoryRole")
	app.load("client.duplicate.pve.PVEChallengePrincipal") 
	app.load("client.duplicate.pve.PVEChallengeFamous") 
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.cacheSeatBG = nil
	self.cacheNameText = nil		--章节名称
	self.cacheChapterText = nil		--章节编号
	
	self.cacheAction = nil		--缓存动画
	self.cacheBackGround = nil	--缓存背景图层 根据NPC颜色 更换
	self.cacheNpcBox = nil		--隐藏的NPC宝箱
	
	self.npcID = 0
	self.npcState = 0			--npc攻击状态  0：打过  1：可攻击  2:锁定
	
	self.sceneID = 0			--场景ID
	self.sceneNum = 0			--关卡编号
	
	self.sprite_image = nil
	self.sprite_quality = nil
	self.isSoldier = false -- 是否是杂兵 --调用另外一个CSB 游戏王使用
	
	self.isGrayRole = false -- 灰色状态下的角色,提示下一个开启

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_terminal()
		
		-- 点击武将
		local duplicate_pve_secondary_scene_seat_role_open_click_terminal = {
            _name = "duplicate_pve_secondary_scene_seat_role_open_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				local npcID = params._datas.npcID 
				local npcState = params._datas.npcState 
				local sceneID = params._datas.sceneID 
				local sceneNum = params._datas.sceneNum 
				local currentPageType = params._datas.currentPageType 
				local cell = params._datas.cell
				
				if true == cell.isGrayRole  then
					-- 检查开启关卡
					TipDlg.drawTextDailog( cell:getOpenCondition() )
					return
				end
				
				local panel = nil
				if currentPageType == 1 or currentPageType == 2 then
					-- 主线
					panel = PVEChallengePrincipal:new()

				elseif  currentPageType == 3 then
					-- 名将
					panel = PVEChallengeFamous:new()
				end
				
				
				if nil ~= panel then
					panel:init(npcID, sceneID, currentPageType, sceneNum, cell._tuition)
					fwin:open(panel, fwin._window)
					
					state_machine.excute("pageview_seat_role_guide_close", 0, nil)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 武将 泡泡
		local duplicate_pve_secondary_scene_seat_role_open_dialogue_terminal = {
            _name = "duplicate_pve_secondary_scene_seat_role_open_dialogue",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				local npcID = params._datas.npcID 
				local npcState = params._datas.npcState 
				local sceneID = params._datas.sceneID 
				local sceneNum = params._datas.sceneNum 
				local currentPageType = params._datas.currentPageType 
				local cell = params._datas.cell
				
				
				cell:showDialogue()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- npc宝箱
		local duplicate_pve_secondary_scene_npc_box_update_panel_terminal = {
            _name = "duplicate_pve_secondary_scene_npc_box_update_panel",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if nil ~= params.targetCell then
					params.targetCell:changeState(2)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(duplicate_pve_secondary_scene_npc_box_update_panel_terminal)
		state_machine.add(duplicate_pve_secondary_scene_seat_role_open_dialogue_terminal)
		state_machine.add(duplicate_pve_secondary_scene_seat_role_open_click_terminal)
        state_machine.init()
	end
	init_terminal()
end

function PageViewSeatRole:createRole(npcID)
	-- 红警时刻暂时屏蔽
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return false
	end
	local cell = MineAttackTerritoryRole:createCell()
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		 then 
		cell:initNPC(npcID,1)	
	else
		cell:initNPC(npcID)
	end
	return cell
end

function PageViewSeatRole:showDialogue()
	if __lua_project_id == __lua_project_yugioh and self.isSoldier == true --then 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(dms.string(dms["npc"], self.npcID, npc.sign_msg)))
            self.role:showQiPao(word_info[3],self.isLeft)
        else
			self.role:showQiPao(dms.string(dms["npc"], self.npcID, npc.sign_msg),self.isLeft)
		end
	end
end

-- 未开启的npc ,显示宝箱,不显示人
function PageViewSeatRole:setHideRole(isbool)
	if __lua_project_id == __lua_project_yugioh and self.isSoldier == true then 

	else
		self.juese:setVisible(not isbool)
		self.Image_chassis:setVisible(not isbool)	
	end
	self.Panel_role:setVisible(not isbool)
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_312"):setVisible(not isbool)
end


function PageViewSeatRole:setGrayRole()
	self.isGrayRole = true
	if __lua_project_id == __lua_project_yugioh and self.isSoldier == true then 
	else
		self.role:setGrayRole()
	end
end

-- 获取开启条件
function PageViewSeatRole:getOpenCondition()
	--local str = ""
	--local npcs = dms.string(dms["npc"], tonumber(self.npcID), npc.by_open_npc)
	-- npcs = zstring.split(npcs,",")
	-- str = dms.string(dms["npc"], tonumber(npcs[1]), npc.npc_name)
	-- str = string.format(_string_piece_info[360], str)
	return dms.string(dms["npc"], tonumber(self.npcID), npc.by_open_npc) 

end


function PageViewSeatRole:onUpdateDraw()

	local root = self.roots[1]
	if __lua_project_id == __lua_project_yugioh and self.isSoldier == true then 

	elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local head_pic = dms.string(dms["npc"], self.npcID, npc.head_pic)
		head_pic = zstring.split(head_pic, ",")
		self.juese:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic[1]))
	else
		self.role = self:createRole(tonumber(self.npcID))
		self.juese:addChild(self.role)
	end
	
	-- -- 绘制NPC的品质底框
	local qualityImageIndex = dms.int(dms["npc"], self.npcID, npc.base_pic) + 1
	self.cacheNameText:setColor(cc.c3b(color_Type[qualityImageIndex][1],color_Type[qualityImageIndex][2],color_Type[qualityImageIndex][3]))

	--设置关卡名称
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(dms.string(dms["npc"], self.npcID, npc.npc_name), "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        self.cacheNameText:setString(name_info)
    else
		self.cacheNameText:setString(dms.string(dms["npc"], self.npcID, npc.npc_name))
	end

	
	--绘制星星状态
	self:drawNpcStar()

	
	-- --显示章节编号
	-- self.cacheChapterText:setString(self.sceneID .. "-" .. self.sceneNum)
	
	-- 显示宝箱
	self:hasNpcBox()
	
end


function PageViewSeatRole:hasNpcBox(isboolean)
	
	--判断NPC宝箱是否显示
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	local checkResult = self:checkNpcTableForNpcID(npcIDTable, self.npcID)
	local drawState = _ED.scene_draw_chest_npcs[self.npcID]
	if true == checkResult then
		app.load("client.cells.copy.plot_copy_chest")

		local chest = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baoxiang")
		local chest_cell = PlotCopyChest:createCell()
		
		local param = {state = 0, starNum = 0}
	
		if true == self.isNpcOver then
			param.state = 1
		end
			
		if drawState == 1 then 	
			param.state = 2
		end	

		chest_cell:init(5, param, self.sceneID, tonumber(self.npcID), self.npcState)
		
		chest:addChild(chest_cell)
	end
end

function PageViewSeatRole:drawNpcStar()

	local maxStar = 3
	local curStar = 0
	if zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) ~= 0 then
		curStar = tonumber(_ED.npc_max_state[tonumber(""..self.npcID)])
	else
		curStar = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
	end
	
	if curStar > 0 then
		self.isNpcOver = true
	else
		self.isNpcOver = false
	end
	
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		--默认隐藏 放置CSB中设置为显示状态
		for i = 1 , 3 do
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_star_%d",i)):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_star_%d_0",i)):setVisible(false)
		end
	end

	if self.currentPageType == 1 or self.currentPageType == 2 then
		for i = 1 , maxStar do
			if i <= curStar then
				ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_star_%d",i)):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_star_%d_0",i)):setVisible(true)
			end
		end
	end
end

--检测table中是否包含传入的NPCid
function PageViewSeatRole:checkNpcTableForNpcID(npcIDTable, npcID)
	for i, v in pairs(npcIDTable) do
		if v == npcID then
			return true
		end
	end
	return false
end

--动画从头播放到尾
function PageViewSeatRole:playActionToDuration()
	-- if self.cacheAction ~= nil then
		-- self.cacheAction:gotoFrameAndPlay(0, self.cacheAction:getDuration(), false)
	-- end	
	-- self.cacheAction:play(actionName, false)
end

function PageViewSeatRole:resetName(value)
	-- if value == true then
		-- self.cacheNameText:setString("")
	-- else
		-- self.cacheNameText:setString(dms.string(dms["npc"], self.npcID, npc.npc_name))
	-- end
end

function PageViewSeatRole:onEnterTransitionFinish()
end
function PageViewSeatRole:onInit()
	local csbItem = nil
	if __lua_project_id == __lua_project_yugioh and self.isSoldier == true then 
		csbItem = csb.createNode("duplicate/pve_guanka_juese_zabing.csb")
	else
		csbItem = csb.createNode("duplicate/pve_guanka_juese.csb")
	end
	
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	-- local action = csb.createTimeline("duplicate/pve_guangqia.csb")
	-- root:runAction(action)
	-- self.cacheAction = action
	
	--角色
	if __lua_project_id == __lua_project_yugioh and self.isSoldier == true then 
	else
		self.juese = ccui.Helper:seekWidgetByName(root, "Panel_juese")
		self.Image_chassis = ccui.Helper:seekWidgetByName(root, "Image_2")
	end
	
	--章节名称
	self.cacheNameText = ccui.Helper:seekWidgetByName(root, "Text_fuben_name")
	
	-- 攻打动画
	self.attackPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	self.attackPanel:setVisible(false)

	self.attackPanel_0 = ccui.Helper:seekWidgetByName(root, "Panel_3_0")
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self.attackPanel_0:setVisible(false)
	end
	self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_1")
	
	
	
	--开始绘制
	self:onUpdateDraw()
	
	
	fwin:addTouchEventListener(self.Panel_role, nil, 
	{
		terminal_name = "duplicate_pve_secondary_scene_seat_role_open_click", 
		terminal_state = 0, 
		npcID = self.npcID ,
		npcState = self.npcState ,
		sceneID = self.sceneID ,
		sceneNum = self.sceneNum ,
		currentPageType = self.currentPageType ,
		cell = self
	},
	nil, 0)

	-- 红警时刻暂时屏蔽教学
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return false
	end
	if missionIsOver() == true then	
		if zstring.tonumber(_ED.user_info.user_grade) <= 10 and self.npcState == 1 and missionIsOver() == true then	
			self._tuition = TuitionController:new():init(nil)
			local psize = self.Panel_role:getContentSize()
			self._tuition:setPosition(cc.p(psize.width / 2, psize.height / 2))
			self.Panel_role:addChild(self._tuition, 1000)
			self._tuition:unlockWindow(nil)
		end
	end
end


--显示选择框
function PageViewSeatRole:setSelectSign(isboolean)
	self.attackPanel:setVisible(isboolean)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self.attackPanel_0:setVisible(isboolean)
	end
	-- 弹泡泡
	self:showDialogue()
	
end



function PageViewSeatRole:onShow()
	-- ccui.Helper:seekWidgetByName(self.roots[1], "Panel_312"):setVisible(true)
end

function PageViewSeatRole:onHide()
	-- ccui.Helper:seekWidgetByName(self.roots[1], "Panel_312"):setVisible(false)
end

function PageViewSeatRole:resetBgScale()
	-- self.cacheSeatBG:setScale(1)
end


function PageViewSeatRole:onExit()
	-- state_machine.remove("click_page_view_seat")
	-- state_machine.remove("equip_icon_cell_change_equip_storage")
end

--锁定关卡
function PageViewSeatRole:lock()
	-- -- self.npcState == 2
	-- self.cacheChapterText:setString(_string_piece_info[133])
	-- -- self.cacheBackGround:setTouchEnabled(false)
	-- display:gray(self.sprite_image)
	-- display:gray(self.sprite_quality)
	-- display:gray(self.cacheNpcBox:getChildByName("Sprite_1"))
end

--解锁关卡
function PageViewSeatRole:upLock()
	-- self:onUpdateDraw()
end

function PageViewSeatRole:init(value, state, sceneID, sceneNum, currentPageType,isLeft)
	self.npcID = value
	self.npcState = state
	self.sceneID = sceneID				--场景ID
	self.sceneNum = sceneNum			--关卡编号
	self.currentPageType = currentPageType
	self.isLeft = isLeft
	if currentPageType == 1 or currentPageType == 2 then 
		self.isSoldier = dms.int(dms["npc"], self.npcID, npc.base_pic)  == 1
	else
		self.isSoldier = false
	end
	
	self:onInit()
end


function PageViewSeatRole:createCell()
	local cell = PageViewSeatRole:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

