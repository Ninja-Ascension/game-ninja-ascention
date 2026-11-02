----------------------------------------------------------------------------------------------------
-- 说明：副本界面npc
-------------------------------------------------------------------------------------------------------
LDuplicateNPCCell = class("LDuplicateNPCCellClass", Window)

function LDuplicateNPCCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	
	self.npcID = 0
	self.npcState = 0			--npc攻击状态  0：打过  1：可攻击  2:锁定
	
	self.sceneID = 0			--场景ID
	self.sceneNum = 0			--关卡编号
	self.bossFlag = false
	self.npcType = 0 			--npc类型 0：普通 1：精英 2:BOSS

	self.normal_npc_pad = nil
	self.difficult_npc_pad = nil
	self.boss_npc_pad = nil
	
	self.normal_npc_base = nil
	self.difficult_npc_base = nil
	self.boss_npc_base = nil
	
	self.actionOver = true
	
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_LDuplicateNPCCell_terminal()
		local lduplicate_npc_click_terminal = {
            _name = "lduplicate_npc_click",
            _init = function (terminal) 
				app.load("client.landscape.duplicate.pve.LPVENpc")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _cell = params._datas._cell
				--防止两个图标同事点击
				if not fwin:find("LPVENpcClass") then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local sceneType = dms.int(dms["pve_scene"], _cell.sceneID ,pve_scene.scene_type)
						if _cell.npcState == nil and sceneType ~= 1 and sceneType ~= 15 then
							return false
						end
					else
						if _cell.npcState == nil then
							return false
						end
					end
					state_machine.lock("lduplicate_npc_click")
					local sceneParam = "nc".._ED.npc_state[zstring.tonumber(_cell.npcID)]
					if missionIsOver() == false 
						or tonumber(_ED.user_info.user_food) <= 6 
						or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, "".._cell.npcID, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(_cell.npcID, 
									  _cell.sceneID, 
									  _cell.bossFlag,
									  _cell.npcState,
									  nil,
									  _cell)
						fwin:open(_LPVENpc, fwin._ui)
						state_machine.unlock("lduplicate_npc_click")
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(lduplicate_npc_click_terminal)
        state_machine.init()
	end
	
	init_LDuplicateNPCCell_terminal()
end

function LDuplicateNPCCell:onUpdateDrawEX( ... )
	local root = self.roots[1]
	local root_pad = ccui.Helper:seekWidgetByName(root, "Panel_203")
	local Sprite_npc = root_pad:getChildByName("Sprite_npc")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		local animationQipao = Sprite_npc:getChildByTag(1025)
		if animationQipao ~= nil then 
			Sprite_npc:removeChildByTag(1025)
		end
	end

	local Sprite_enemy = root_pad:getChildByName("Sprite_enemy")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_1034")
	Sprite_npc:setVisible(true)
	Sprite_enemy:setVisible(true)
	

	local mapIndex = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		mapIndex = zstring.split(dms.string(dms["npc"], self.npcID, npc.head_pic),",")[1]
	else
		mapIndex = dms.int(dms["npc"], self.npcID, npc.head_pic)
	end
	local npc_base_index = dms.int(dms["npc"], self.npcID, npc.base_pic) -- 1 杂兵 2 小bos 3 大bos
	if __lua_project_id == __lua_project_l_naruto then
		Sprite_npc:setTexture("images/ui/pve_sn/props_" .. mapIndex .. ".png")
	else
		Sprite_npc:setTexture("images/ui/props/props_" .. mapIndex .. ".png")
		if self.currentSceneType == 15 then
			Sprite_npc:setTexture("images/ui/pve_sn/props_" .. mapIndex .. ".png")
		end
	end

	if self.currentSceneType ~= 15 then
		if npc_base_index == 1 then
			Sprite_enemy:setTexture("images/ui/slots/enemy_3.png")
		elseif npc_base_index == 2 then
			Sprite_enemy:setTexture("images/ui/slots/enemy_2.png")
		else
			Sprite_enemy:setTexture("images/ui/slots/enemy_1.png")
		end
	end

	--绘制星星状态
	local maxStar = tonumber(dms.string(dms["npc"], self.npcID, npc.difficulty_include_count))
	local CurStar = 0
	if zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) ~= 0 then
		CurStar = tonumber(_ED.npc_max_state[tonumber(""..self.npcID)])
	else
		CurStar = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
	end

	if CurStar == 1 then  
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(false)
	elseif CurStar == 2 then 
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(false)
	elseif CurStar == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(false)
	end
	
	--判断NPC宝箱是否显示
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	local checkResult = self:checkNpcTableForNpcID(npcIDTable, self.npcID)
	
	local colorType = 0
	local formation_count = dms.int(dms["npc"], self.npcID, npc.formation_count)
	local environment_formation_data = dms.int(dms["npc"], self.npcID, npc.environment_formation1 + formation_count - 1)
	
	for i = 0, 5 do
		local environment_ship_data = dms.int(dms["environment_formation"], environment_formation_data, environment_formation.seat_one + i)
		if environment_ship_data > 0 then
			local boss_flag = dms.int(dms["environment_ship"], environment_ship_data, environment_ship.sign_pic)
			if boss_flag == 1 then
				colorType = dms.int(dms["environment_ship"], environment_ship_data, environment_ship.ship_type)
				break
			end
		end
	end
    local name_info = ""
    local name_data = zstring.split(dms.string(dms["npc"], self.npcID, npc.npc_name), "|")
    for i, v in pairs(name_data) do
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
        name_info = name_info..word_info[3]
    end
    nameText:setString(name_info)
	nameText:setColor(cc.c3b(color_Type[colorType+1][1],color_Type[colorType+1][2], color_Type[colorType+1][3]))

	if checkResult == true then
		if self.bossFlag == false then
			self.npcType = 1
		end
	end
	if self.bossFlag == true then
		self.npcType = 2
	end

	--噩梦副本场景开启条件
	function checkNpcData( sceneId , currentSceneType)
		if currentSceneType ~= 15 then return true end
		local need_grade = dms.int(dms["pve_scene"], sceneId, pve_scene.open_level)
		if zstring.tonumber(_ED.user_info.user_grade) < need_grade then
			return false
		end
		--获取当前打开的senceID
		local sceneid = 0
		_scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 15)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				sceneid = tempSceneId - 1
				break
			end
		end

		local needOpenScene = zstring.split(dms.string(dms["pve_scene"], sceneid, pve_scene.by_open_scene), ",")
		for k,v in pairs(needOpenScene) do
			local npcCount = #(zstring.split(dms.string(dms["pve_scene"], v, pve_scene.npcs), ","))
			if zstring.tonumber(_ED.scene_current_state[tonumber(v)]) < npcCount then
				-- TipDlg.drawTextDailog(string.format(_new_interface_text[296],dms.string(dms["pve_scene"], tonumber(v), pve_scene.scene_name)))
				return false
			end
		end
		return true
	end
	
	-- 灰色处理
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if self.npcState == nil or (not checkNpcData(self.sceneID, self.currentSceneType)) then
			display:gray(Sprite_npc)
			display:gray(Sprite_enemy)
			nameText:setColor(cc.c3b(255,255,255))
			nameText:setVisible(false)
			if self.currentSceneType == 15 then
				ccui.Helper:seekWidgetByName(root, "Panel_head_box_effect"):setVisible(false)
				local Panel_203 = ccui.Helper:seekWidgetByName(root, "Panel_203")
				local Image_dailingqu = Panel_203:getChildByName("Image_dailingqu")
				local Sprite_npc_box = Panel_203:getChildByName("Sprite_npc_box")
				display:gray(Image_dailingqu)
				display:gray(Sprite_npc_box)
			end
		else
			nameText:setVisible(true)
			if self.currentSceneType == 15 then
				ccui.Helper:seekWidgetByName(root, "Panel_head_box_effect"):setVisible(true)
				local Panel_203 = ccui.Helper:seekWidgetByName(root, "Panel_203")
				local Image_dailingqu = Panel_203:getChildByName("Image_dailingqu")
				local Sprite_npc_box = Panel_203:getChildByName("Sprite_npc_box")
				display:ungray(Image_dailingqu)
				display:ungray(Sprite_npc_box)
			end
		end
	else
		if self.npcState == nil then
			display:gray(Sprite_npc)
			nameText:setColor(cc.c3b(255,255,255))
		end
	end

	--领取显示
	if self.currentSceneType == 15 then
		local Image_kelingqu = ccui.Helper:seekWidgetByName(root, "Image_kelingqu")
		local Image_yilingwan = ccui.Helper:seekWidgetByName(root, "Image_yilingwan")
		local Panel_203 = ccui.Helper:seekWidgetByName(root, "Panel_203")
		local Image_dailingqu = Panel_203:getChildByName("Image_dailingqu")

		local CurStar = 0
		if zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) ~= 0 then
			CurStar = tonumber(_ED.npc_max_state[tonumber(""..self.npcID)])
		else
			CurStar = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
		end

		local pt_lq_state = 0 -- 0 不可领取 1 可领取 2 已领取
		local sx_lq_state = 0
		--判断通关按钮状态
		local drawState = _ED.scene_draw_chest_npcs[tostring(self.npcID)]
		if zstring.tonumber(drawState) == 1 then--已经领取
			pt_lq_state = 2
		else--没有领取
			if self.npcState  ~= nil and tonumber(self.npcState) ~= 1 and tonumber(self.npcState) ~= 2 then
				pt_lq_state = 1
			else
				pt_lq_state = 0
			end
		end

		--判断三星通关按钮状态
		local drawStateEm = _ED.scene_draw_sx_chest_npcs[tostring(self.npcID)]
		if zstring.tonumber(drawStateEm) == 1 then--已经领取
			sx_lq_state = 2
		else--没有领取
			if CurStar  >= 3 then
				sx_lq_state = 1
			else
				sx_lq_state = 0
			end
		end

		local state = -1 -- -1 未通关 0待领取 1 可领取 2 已领取 3 领取了一个 ，另一个不能领取 
		if pt_lq_state == 1 and sx_lq_state == 1 then
			state = 0
		elseif pt_lq_state == 0 and sx_lq_state == 0 then
			state = -1
		elseif pt_lq_state == 2 and sx_lq_state == 2 then
			state = 2
		elseif (pt_lq_state == 2 and sx_lq_state == 0) or (pt_lq_state == 0 and sx_lq_state == 2) then
			state = 3
		else 
			state = 1
		end
		--display:ungray(Image_dailingqu)
		Image_dailingqu:setVisible(state == -1 or state == 3)
		Image_kelingqu:setVisible(state == 1 or state == 0)
		Image_yilingwan:setVisible(state == 2)
	end

	local Panel_jtdh = ccui.Helper:seekWidgetByName(root, "Panel_jtdh")
	Panel_jtdh:removeAllChildren(true)
	Panel_jtdh:setVisible(false)
	if dms.int(dms["npc"], self.npcID, npc.sound_index) > 0 then
		local Panel_203 = ccui.Helper:seekWidgetByName(root, "Panel_203")
		local Sprite_fun_open_tip_bar = Panel_203:getChildByName("Sprite_fun_open_tip_bar")
		local Panel_fun_open_tip = ccui.Helper:seekWidgetByName(root, "Panel_fun_open_tip")
		Panel_fun_open_tip:removeAllChildren(true)
		local open_tip = cc.Sprite:create(string.format("images/ui/pve_sn/fun_open_tip/fun_open_tip_%d.png", dms.int(dms["npc"], self.npcID, npc.sound_index)))
		open_tip:setPosition(cc.p(Panel_fun_open_tip:getContentSize().width/2,Panel_fun_open_tip:getContentSize().height/2))
		Panel_fun_open_tip:addChild(open_tip)
		if self.npcState == nil or not (checkNpcData(self.sceneID, self.currentSceneType))then
			--没打过
			Sprite_fun_open_tip_bar:setVisible(true)
			display:gray(Sprite_fun_open_tip_bar)
			Panel_fun_open_tip:setVisible(true)
			display:gray(open_tip)
		else
			if tonumber(self.npcState) == 0 then
				--打过
				Sprite_fun_open_tip_bar:setVisible(false)
				Panel_fun_open_tip:setVisible(false)
			else
				--
				Sprite_fun_open_tip_bar:setVisible(true)
				display:ungray(Sprite_fun_open_tip_bar)
				Panel_fun_open_tip:setVisible(true)
				display:ungray(open_tip)

				Panel_jtdh:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					--换成气泡
					if dms.int(dms["npc"], self.npcID, npc.npc_type) > 0 then
						local root_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
	            		local Sprite_npc = root_pad:getChildByName("Sprite_npc")
						app.load("client.l_digital.duplicate.sm_pve_duplicate_qibao_cell")
						local qipao = SmPveDuplicateQibaoCell:createCell()
						qipao:init(self.npcID)
						qipao:setTag(1025)
						qipao:setPositionX(Sprite_npc:getPositionX()/4*3)
						qipao:setPositionY(20)
						Sprite_npc:addChild(qipao)
					end
				else
					local jsonFile = "sprite/sprite_pve_arrow.json"
		            local atlasFile = "sprite/sprite_pve_arrow.atlas"
		            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		            Panel_jtdh:addChild(animation)
		        end
			end
		end
	else
		if self.npcState == nil  then
		else
			if tonumber(self.npcState) == 0 then
			else
				Panel_jtdh:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					--换成气泡
					if dms.int(dms["npc"], self.npcID, npc.npc_type) > 0 then
						local root_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
	            		local Sprite_npc = root_pad:getChildByName("Sprite_npc")
						app.load("client.l_digital.duplicate.sm_pve_duplicate_qibao_cell")
						local qipao = SmPveDuplicateQibaoCell:createCell()
						qipao:init(self.npcID)
						qipao:setTag(1025)
						qipao:setPositionX(Sprite_npc:getPositionX()/4*3)
						qipao:setPositionY(20)
						Sprite_npc:addChild(qipao)
					end
				else
					local jsonFile = "sprite/sprite_pve_arrow.json"
		            local atlasFile = "sprite/sprite_pve_arrow.atlas"
		            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		            Panel_jtdh:addChild(animation)
		        end
			end
		end	
	end
	local root_pad = ccui.Helper:seekWidgetByName(root, "Panel_203")
	local Sprite_npc = root_pad:getChildByName("Sprite_npc")
	if npc_base_index == 3 then
		root:setScale(1.2)
		nameText:setScale(0.8)
		local animationQipao = Sprite_npc:getChildByTag(1025)
		if animationQipao ~= nil then 
			animationQipao:setScale(0.8)
		end
	else
		root:setScale(1)
		nameText:setScale(1)
		local animationQipao = Sprite_npc:getChildByTag(1025)
		if animationQipao ~= nil then 
			animationQipao:setScale(1)
		end
	end
end

function LDuplicateNPCCell:onUpdateDraw()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self:onUpdateDrawEX()
		return
	end
	local root = self.roots[1]
	
	
	-- 根据挑战次数 绘制底板颜色 以及背景图 99次为普通怪 10为精英怪 5次为BOSS
	local mapIndex = dms.int(dms["npc"], self.npcID, npc.head_pic)
	self.normal_npc_pad:setTexture("images/ui/props/props_" .. mapIndex .. ".png")
	self.normal_npc_pad:setVisible(true)

	
	--绘制星星状态
	local maxStar = tonumber(dms.string(dms["npc"], self.npcID, npc.difficulty_include_count))
	local CurStar = 0
	if zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) ~= 0 then
		CurStar = tonumber(_ED.npc_max_state[tonumber(""..self.npcID)])
	else
		CurStar = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
	end
	
	
	if CurStar == 1 then  
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(false)
	elseif CurStar == 2 then 
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(false)
	elseif CurStar == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Image_101_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_101_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_101_3"):setVisible(false)
	end
	
	
	--判断NPC宝箱是否显示
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	local checkResult = self:checkNpcTableForNpcID(npcIDTable, self.npcID)
	-- print(checkResult,self.bossFlag)
	
	local colorType = 0
	local formation_count = dms.int(dms["npc"], self.npcID, npc.formation_count)
	local environment_formation_data = dms.int(dms["npc"], self.npcID, npc.environment_formation1 + formation_count - 1)
	
	for i = 0, 5 do
		local environment_ship_data = dms.int(dms["environment_formation"], environment_formation_data, environment_formation.seat_one + i)
		if environment_ship_data > 0 then
			local boss_flag = dms.int(dms["environment_ship"], environment_ship_data, environment_ship.sign_pic)
			if boss_flag == 1 then
				colorType = dms.int(dms["environment_ship"], environment_ship_data, environment_ship.ship_type)
				break
			end
		end
	end
	
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_1034")
	
	if checkResult == true then
		self.normal_npc_pad:setVisible(false)
		
		if self.bossFlag == false then
			self.difficult_npc_pad:setVisible(true)
			self.difficult_npc_pad:setTexture("images/ui/props/props_" .. mapIndex .. ".png")
			self.npcType = 1
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            local name_info = ""
            local name_data = zstring.split(dms.string(dms["npc"], self.npcID, npc.npc_name), "|")
            for i, v in pairs(name_data) do
                local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                name_info = name_info..word_info[3]
            end
            nameText:setString(name_info)
        else
        	nameText:setString(dms.string(dms["npc"], self.npcID, npc.npc_name))
        end 
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			nameText:setColor(cc.c3b(color_Type[colorType+1][1],color_Type[colorType+1][2], color_Type[colorType+1][3]))
		else
			nameText:setColor(cc.c3b(color_Type[colorType][1],color_Type[colorType][2], color_Type[colorType][3]))
		end
	end
	
	if self.bossFlag == true then
		self.normal_npc_pad:setVisible(false)
		
		self.boss_npc_pad:setVisible(true)
		self.boss_npc_pad:setTexture("images/ui/props/props_" .. mapIndex .. ".png")
		
		self.npcType = 2
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            local name_info = ""
            local name_data = zstring.split(dms.string(dms["npc"], self.npcID, npc.npc_name), "|")
            for i, v in pairs(name_data) do
                local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                name_info = name_info..word_info[3]
            end
            nameText:setString(name_info)
        else
			nameText:setString(dms.string(dms["npc"], self.npcID, npc.npc_name))
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			nameText:setColor(cc.c3b(color_Type[colorType+1][1],color_Type[colorType+1][2], color_Type[colorType+1][3]))
		else
			nameText:setColor(cc.c3b(color_Type[colorType][1],color_Type[colorType][2], color_Type[colorType][3]))
		end
	end
	
	-- 底框
	local npc_base_index = dms.int(dms["npc"], self.npcID, npc.base_pic) -- 1 杂兵 2 小bos 3 大bos
	local base_used_pad = nil
	if npc_base_index == 1 then
		base_used_pad = self.normal_npc_base
	elseif npc_base_index == 2 then
		base_used_pad = self.difficult_npc_base
	elseif npc_base_index == 3 then	
		base_used_pad = self.boss_npc_base
	else
		base_used_pad = self.boss_npc_base	
	end
	
	base_used_pad:setVisible(true)
	
	-- 灰色处理
	if self.npcState == nil then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if self.normal_npc_pad ~= nil 
				and self.difficult_npc_pad ~= nil 
				and self.boss_npc_pad ~= nil
				and base_used_pad ~= nil then
			else
				return
			end
		end
		display:gray(self.normal_npc_pad)
		display:gray(self.difficult_npc_pad)
		display:gray(self.boss_npc_pad)
		display:gray(base_used_pad)
		nameText:setColor(cc.c3b(255,255,255))
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local Panel_jtdh = ccui.Helper:seekWidgetByName(root, "Panel_jtdh")
		Panel_jtdh:removeAllChildren(true)
		Panel_jtdh:setVisible(false)
		if dms.int(dms["npc"], self.npcID, npc.sound_index) > 0 then
			local Panel_203 = ccui.Helper:seekWidgetByName(root, "Panel_203")
			local Sprite_fun_open_tip_bar = Panel_203:getChildByName("Sprite_fun_open_tip_bar")
			local Panel_fun_open_tip = ccui.Helper:seekWidgetByName(root, "Panel_fun_open_tip")
			Panel_fun_open_tip:removeAllChildren(true)
			local open_tip = cc.Sprite:create(string.format("images/ui/pve_sn/fun_open_tip/fun_open_tip_%d.png", dms.int(dms["npc"], self.npcID, npc.sound_index)))
			open_tip:setPosition(cc.p(Panel_fun_open_tip:getContentSize().width/2,Panel_fun_open_tip:getContentSize().height/2))
			Panel_fun_open_tip:addChild(open_tip)

			if self.npcState == nil then
				--没打过
				Sprite_fun_open_tip_bar:setVisible(true)
				display:gray(Sprite_fun_open_tip_bar)
				Panel_fun_open_tip:setVisible(true)
				display:gray(open_tip)
			else
				if tonumber(self.npcState) == 0 then
					--打过
					Sprite_fun_open_tip_bar:setVisible(false)
					Panel_fun_open_tip:setVisible(false)
				else
					--
					Sprite_fun_open_tip_bar:setVisible(true)
					display:ungray(Sprite_fun_open_tip_bar)
					Panel_fun_open_tip:setVisible(true)
					display:ungray(open_tip)

					Panel_jtdh:setVisible(true)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					else
						local jsonFile = "sprite/sprite_pve_arrow.json"
			            local atlasFile = "sprite/sprite_pve_arrow.atlas"
			            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			            Panel_jtdh:addChild(animation)
			        end
				end
			end
		else
			if self.npcState == nil then
			else
				if tonumber(self.npcState) == 0 then
				else
					Panel_jtdh:setVisible(true)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					else
						local jsonFile = "sprite/sprite_pve_arrow.json"
			            local atlasFile = "sprite/sprite_pve_arrow.atlas"
			            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			            Panel_jtdh:addChild(animation)
			        end
				end
			end	
		end
	end
end

--检测table中是否包含传入的NPCid
function LDuplicateNPCCell:checkNpcTableForNpcID(npcIDTable, npcID)
	for i, v in pairs(npcIDTable) do
		if v == npcID then
			return true
		end
	end
	return false
end

function LDuplicateNPCCell:onEnterTransitionFinish()

end

function LDuplicateNPCCell:onUpdate(dt)
    if self.npcState ~= nil and tonumber(self.npcState) ~= 0 and self.actionOver == true then
        self.actionOver = false
        local function executeMoveFunc()
            local function executeMoveHeroOverFunc()
                self.actionOver = true
            end
            if self ~= nil and self.roots ~= nil and self.roots[1] ~= nil then
            	local root_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
            	local Sprite_npc = root_pad:getChildByName("Sprite_npc")
				local Sprite_enemy = root_pad:getChildByName("Sprite_enemy")

				if self.currentSceneType == 15 then
		            local Panel_203 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
					local Image_dailingqu = Panel_203:getChildByName("Image_dailingqu")
					local Sprite_npc_box = Panel_203:getChildByName("Sprite_npc_box")
					Image_dailingqu:runAction(cc.Sequence:create(
	                    cc.MoveTo:create(1, cc.p(Image_dailingqu:getPositionX() , Image_dailingqu:getPositionY() - 10))
	                ))
	                Sprite_npc_box:runAction(cc.Sequence:create(
	                    cc.MoveTo:create(1, cc.p(Sprite_npc_box:getPositionX() , Sprite_npc_box:getPositionY() - 10))
	                ))
				end

				Sprite_npc:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(Sprite_npc:getPositionX() , Sprite_npc:getPositionY() - 10))
                ))

                Sprite_enemy:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(Sprite_enemy:getPositionX() , Sprite_enemy:getPositionY() - 10))
                ))

                ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):getPositionX() , ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):getPositionY() - 10)),
                    cc.CallFunc:create(executeMoveHeroOverFunc)
                ))
            end
        end
        if self ~= nil and self.roots ~= nil and self.roots[1] ~= nil then
        	local root_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
        	local Sprite_npc = root_pad:getChildByName("Sprite_npc")
			local Sprite_enemy = root_pad:getChildByName("Sprite_enemy")
			Sprite_npc:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(Sprite_npc:getPositionX() , Sprite_npc:getPositionY() + 10))
                ))
            Sprite_enemy:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(Sprite_enemy:getPositionX() , Sprite_enemy:getPositionY() + 10))
                ))

            if self.currentSceneType == 15 then
	            local Panel_203 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
				local Image_dailingqu = Panel_203:getChildByName("Image_dailingqu")
				local Sprite_npc_box = Panel_203:getChildByName("Sprite_npc_box")
				Image_dailingqu:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(Image_dailingqu:getPositionX() , Image_dailingqu:getPositionY() + 10))
                ))
                Sprite_npc_box:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(Sprite_npc_box:getPositionX() , Sprite_npc_box:getPositionY() + 10))
                ))
			end
            ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):runAction(cc.Sequence:create(
                cc.MoveTo:create(1, cc.p(ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):getPositionX() , ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):getPositionY() + 10)),
                cc.CallFunc:create(executeMoveFunc)
            ))

        end
    end
  --   if self.npcState ~= nil and tonumber(self.npcState) == 0 then
  --   	local root_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
  --   	local Sprite_npc = root_pad:getChildByName("Sprite_npc")
		-- local Sprite_enemy = root_pad:getChildByName("Sprite_enemy")
		-- Sprite_npc:setPositionY(Sprite_npc._y)
		-- Sprite_enemy:setPositionY(Sprite_enemy._y)
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):setPositionY(ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034")._y)
  --   end
end

function LDuplicateNPCCell:runActionByState(_state)
	local root = self.roots[1]
	local action = self.actions[1]

	local ArmatureNode_1 = nil

	if _state == 0 or _state == nil then -- 打过
		-- if ArmatureNode_1 then
		-- 	local animation = ArmatureNode_1:getAnimation()
 	-- 		animation:playWithIndex(0, 0, 0)
		-- end
	elseif _state == 1 then -- 正在攻打
		if action ~= nil then
			action:gotoFrameAndPlay(40, 40, false)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
			-- if ArmatureNode_1 then
			-- 	local animation = ArmatureNode_1:getAnimation()
 		-- 		animation:playWithIndex(1 ,1, -1)
			-- end
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson")
			local Panel_npc_pk_putong = ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong")
			Panel_npc_pk_putong:setVisible(true)
			Panel_npc_pk_putong:removeAllChildren(true)
			local armature = ccs.Armature:create("effice_ui_npc_2")
			armature:getAnimation():playWithIndex(0, 0, -1)
			Panel_npc_pk_putong:addChild(armature)
			armature:setPosition(cc.p(Panel_npc_pk_putong:getContentSize().width/2, Panel_npc_pk_putong:getContentSize().height/2))
			local Panel_npc_putong_0 = ccui.Helper:seekWidgetByName(root, "Panel_npc_putong_0")
			if Panel_npc_putong_0 ~= nil then
				Panel_npc_putong_0:setVisible(true)
				Panel_npc_putong_0:removeAllChildren(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					if missionIsOver() == true then	
						app.load("client.mission.tuition.TuitionController")
						self._tuition = TuitionController:new():init(nil)
						local psize = self:getContentSize()
						self._tuition:setPosition(cc.p(psize.width / 2, psize.height / 2))
						self:addChild(self._tuition, 1000)
						self._tuition:unlockWindow(nil)
					end
				else
					local animation = "animation"
		            local jsonFile = "images/ui/effice/effect_npcopen/effect_npcopen.json"
		            local atlasFile = "images/ui/effice/effect_npcopen/effect_npcopen.atlas"
		            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
		            	local function changeActionCallback( armatureBack )
		            		-- if armatureBack ~= nil and armatureBack.parent ~= nil then
					            armatureBack:removeFromParent(true)
					        -- end
				        end
		                local animate = sp.spine(jsonFile, atlasFile, 1, 0, animation, false, nil)
		                Panel_npc_putong_0:addChild(animate)
		                sp.initArmature(animate)
		                animate._invoke = changeActionCallback
						animate:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		                animate:setPosition(Panel_npc_putong_0:getContentSize().width/2, Panel_npc_putong_0:getContentSize().height/2)
		            end
	            end
	        end
	        if LDuplicateWindow._infoDatas._isLastNpc == true and 
	  			LDuplicateWindow._infoDatas._isBattleWin == true and
  				LDuplicateWindow._infoDatas._isNewNPCAction == false then
  			else
  				if _ED.npc_open_event ~= nil and _ED.npc_open_event == tonumber(self.npcID) then
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson")
					local Panel_npc_pk_putong = ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong")
					Panel_npc_pk_putong:setVisible(true)
					Panel_npc_pk_putong:removeAllChildren(true)
					local armature = ccs.Armature:create("effice_ui_npc_2")
					armature:getAnimation():playWithIndex(0, 0, -1)
					Panel_npc_pk_putong:addChild(armature)
					armature:setPosition(cc.p(Panel_npc_pk_putong:getContentSize().width/2, Panel_npc_pk_putong:getContentSize().height/2))
					local animation_panel = ccui.Helper:seekWidgetByName(root, "Panel_dianliang"):setVisible(true)
					local animation = "animation"
		            local jsonFile = "images/ui/effice/effect_npcopen/effect_npcopen.json"
		            local atlasFile = "images/ui/effice/effect_npcopen/effect_npcopen.atlas"
		            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
		            	local function changeActionCallback( armatureBack )
		            		-- if armatureBack ~= nil and armatureBack.parent ~= nil then
					            armatureBack:removeFromParent(true)
					            _ED.npc_open_event = -1
					        -- end
				        end
		                local animate = sp.spine(jsonFile, atlasFile, 1, 0, animation, false, nil)
		                animation_panel:addChild(animate)
		                sp.initArmature(animate)
		                animate._invoke = changeActionCallback
						animate:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		                animate:setPosition(animation_panel:getContentSize().width/2, animation_panel:getContentSize().height/2)
		            end
	            end
  			end
		else
			if self.npcType == 0 then
				-- self.normal_npc_pad:setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong"):setVisible(true)
				
			elseif self.npcType >= 1 then
				ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_juese"):setVisible(true)
			end	
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
		else
			if self.sceneNum > 1 then
				state_machine.excute("lpve_map_action_play", 0,
				{
					_actionName = string.format("tongguan_%d", self.sceneNum - 1),
					_bRepeated = false,
				})
			end
		end
		
	elseif _state == 2 then -- 开始攻打下一个
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_red_alert 
			then
			local animation_panel=ccui.Helper:seekWidgetByName(root, "Panel_dianliang"):setVisible(true)
			local ArmatureNode_3 = animation_panel:getChildByName("ArmatureNode_3")
			local animation = ArmatureNode_3:getAnimation()
			animation_panel:setVisible(true)
			animation:playWithIndex(0, 0, 0)
		elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
				if _ED.npc_open_event ~= nil and _ED.npc_open_event == tonumber(self.npcID) then
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson")
					local Panel_npc_pk_putong = ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong")
					Panel_npc_pk_putong:setVisible(true)
					Panel_npc_pk_putong:removeAllChildren(true)
					local armature = ccs.Armature:create("effice_ui_npc_2")
					armature:getAnimation():playWithIndex(0, 0, -1)
					Panel_npc_pk_putong:addChild(armature)
					armature:setPosition(cc.p(Panel_npc_pk_putong:getContentSize().width/2, Panel_npc_pk_putong:getContentSize().height/2))
					local animation_panel = ccui.Helper:seekWidgetByName(root, "Panel_dianliang"):setVisible(true)
					local animation = "animation"
		            local jsonFile = "images/ui/effice/effect_npcopen/effect_npcopen.json"
		            local atlasFile = "images/ui/effice/effect_npcopen/effect_npcopen.atlas"
		            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
		            	local function changeActionCallback( armatureBack )
		            		-- if armatureBack ~= nil and armatureBack.parent ~= nil then
					            armatureBack:removeFromParent(true)
					            _ED.npc_open_event = -1
					        -- end
				        end
		                local animate = sp.spine(jsonFile, atlasFile, 1, 0, animation, false, nil)
		                animation_panel:addChild(animate)
		                sp.initArmature(animate)
		                animate._invoke = changeActionCallback
						animate:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		                animate:setPosition(animation_panel:getContentSize().width/2, animation_panel:getContentSize().height/2)
		            end
	            end
			else
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_juesedianliang/effect_juesedianliang.ExportJson")
				local animation_panel = ccui.Helper:seekWidgetByName(root, "Panel_dianliang"):setVisible(true)
				animation_panel:removeAllChildren(true)
				local armature = ccs.Armature:create("effect_juesedianliang")
				armature:getAnimation():playWithIndex(0, 0, -1)
				animation_panel:addChild(armature)
				armature:setPosition(cc.p(animation_panel:getContentSize().width/2, animation_panel:getContentSize().height/2))
			end
		end	
		local function npcNpcAppearActionFunc()
			if action ~= nil then
				action:play("Panel_103_npc", false)
				action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end
					
					local str = frame:getEvent()
					if str == "Panel_103_npc_over" then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
							then
							ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong"):setVisible(true)
						else
							if self.npcType == 0 then
								-- self.normal_npc_pad:setVisible(false)
								ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong"):setVisible(true)
								
							elseif self.npcType >= 1 then
								ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_juese"):setVisible(true)
							end	
						end
					end
				end)
			end
		end	
		
		if self.sceneNum > 1 then
			state_machine.excute("lpve_map_action_play", 0,
			{
				_actionName = string.format("Panel_ko_%d", self.sceneNum - 1),
				_bRepeated = false,
				_eventName = string.format("Panel_ko_over_%d", self.sceneNum - 1),
				_eventFunc = npcNpcAppearActionFunc,
			})
		else
			npcNpcAppearActionFunc()
		end
	end
end

function LDuplicateNPCCell:onInit()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("duplicate/pve_duplicate_k.csb", "root")
		if self.currentSceneType == 15 then
			root = cacher.createUIRef("duplicate/pve_duplicate_em_k.csb", "root")
		end
	else
		local csbItem = csb.createNode("duplicate/pve_duplicate_k.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_203")
    	local Sprite_npc = root_pad:getChildByName("Sprite_npc")
		local Sprite_enemy = root_pad:getChildByName("Sprite_enemy")
		if Sprite_npc._y == nil then
			Sprite_npc._y = Sprite_npc:getPositionY()
		end
		if Sprite_enemy._y == nil then
			Sprite_enemy._y = Sprite_enemy:getPositionY()
		end
		if ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034")._y == nil then
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):getPositionY()
		end
		Sprite_npc:setPositionY(Sprite_npc._y)
		Sprite_enemy:setPositionY(Sprite_enemy._y)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034"):setPositionY(ccui.Helper:seekWidgetByName(self.roots[1], "Text_1034")._y)
	else
		local action = csb.createTimeline("duplicate/pve_duplicate_k.csb")
		root:runAction(action)
		table.insert(self.actions, action)
	end

	local root_pad = ccui.Helper:seekWidgetByName(root, "Panel_203")
	
	self:setContentSize(root_pad:getContentSize())
	
	self.normal_npc_pad = root_pad:getChildByName("Sprite_npc_0")
	self.difficult_npc_pad = root_pad:getChildByName("Sprite_npc_juese")
	self.boss_npc_pad = root_pad:getChildByName("Sprite_npc_boss")
	
	self.normal_npc_base = root_pad:getChildByName("enemy_npc_3")
	self.difficult_npc_base = root_pad:getChildByName("enemy_juese_2")
	self.boss_npc_base = root_pad:getChildByName("enemy_boss_1")
	
	
	self:onUpdateDraw()
	
	local _tempState = self.npcState
	if LDuplicateWindow._infoDatas._isLastNpc == true and 
	  LDuplicateWindow._infoDatas._isBattleWin == true and
	  LDuplicateWindow._infoDatas._isNewNPCAction == false and
	  self.npcState == 1 then
	  
		_tempState = 2
		
	end
	
	self:runActionByState(_tempState)
	
	 -- 设置UI的事件响应
	fwin:addTouchEventListener(root_pad, nil, 
	{
		terminal_name = "lduplicate_npc_click", 	
		terminal_state = 0, 
		_cell = self
	}, 
	nil, 0)
end

function LDuplicateNPCCell:clearUIInfo( ... )
	local root = self.roots[1]
	local root_pad = ccui.Helper:seekWidgetByName(root, "Panel_203")
	if root_pad ~= nil then
		local Sprite_npc = root_pad:getChildByName("Sprite_npc")
		local Sprite_enemy = root_pad:getChildByName("Sprite_enemy")
		local Sprite_fun_open_tip_bar = root_pad:getChildByName("Sprite_fun_open_tip_bar")
		if Sprite_npc._y == nil then
			Sprite_npc:setPositionY(Sprite_npc._y)
		end
		if Sprite_enemy._y == nil then
			Sprite_enemy:setPositionY(Sprite_enemy._y)
		end
		display:ungray(Sprite_npc)
		display:ungray(Sprite_enemy)
		display:ungray(Sprite_fun_open_tip_bar)
		Sprite_fun_open_tip_bar:setVisible(false)
	end
	local Panel_dianliang = ccui.Helper:seekWidgetByName(root, "Panel_dianliang")
	local Panel_npc_pk_putong = ccui.Helper:seekWidgetByName(root, "Panel_npc_pk_putong")
	local Panel_jtdh = ccui.Helper:seekWidgetByName(root, "Panel_jtdh")
	local Panel_fun_open_tip = ccui.Helper:seekWidgetByName(root, "Panel_fun_open_tip")
	local Panel_npc_putong_0 = ccui.Helper:seekWidgetByName(root, "Panel_npc_putong_0")
	if Panel_npc_putong_0 ~= nil then
		Panel_npc_putong_0:removeAllChildren(true)
	end
	if Panel_dianliang ~= nil then
		Panel_dianliang:removeAllChildren(true)
	end
	if Panel_npc_pk_putong ~= nil then
		Panel_npc_pk_putong:removeAllChildren(true)
	end
	if Panel_jtdh ~= nil then
		Panel_jtdh:removeAllChildren(true)
	end
	if Panel_fun_open_tip ~= nil then
		Panel_fun_open_tip:removeAllChildren(true)
	end
end

function LDuplicateNPCCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self:clearUIInfo()
		cacher.freeRef("duplicate/pve_duplicate_k.csb", self.roots[1])
		if self.currentSceneType == 15 then
			cacher.freeRef("duplicate/pve_duplicate_em_k.csb", self.roots[1])
		end
	end
end

function LDuplicateNPCCell:init(value, state, sceneID, sceneNum, bossFlag)
	self.npcID = value
	self.npcState = state
	self.sceneID = sceneID				--场景ID
	self.sceneNum = sceneNum			--关卡编号
	self.bossFlag = bossFlag
	self.currentSceneType = dms.int(dms["pve_scene"], self.sceneID , pve_scene.scene_type) 
	self:onInit()
end

function LDuplicateNPCCell:createCell()
	local cell = LDuplicateNPCCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end

