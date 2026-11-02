-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
DuplicateMap = class("DuplicateMapClass", Window)
DuplicateMap.__cache_spines = {}
DuplicateMap.__last_scene_id = -1
DuplicateMap.__position = cc.p(0, 0)

--打开
DuplicateMap.__npc_index = -1

local duplicate_map_window_open_terminal = {
    _name = "duplicate_map_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		cacher.removeAllTextures()
        fwin:freeAllMemeryPool()
    	fwin:close(fwin:find("DuplicateMapClass"))
    	local _duplicateMapWindow = fwin:find("DuplicateMapClass")
        if nil == _duplicateMapWindow then
	    	if type(params) == "table" then
	            terminal._datas = params._datas -- 记录数据
	        end

	    	local scenceID = terminal._datas._scenceID
	    	local from_type = terminal._datas._from_type

	    	local npc_id = nil 
	    	if params ~= nil and params._datas ~= nil and params._datas._npc_id ~= nil then
	    		npc_id = params._datas._npc_id
	    	end
	    	local index = 0
	    	if params ~= nil and params._datas ~= nil and params._datas.index ~= nil then
	    		index = params._datas.index
	    	end
			fwin:open(DuplicateMap:new():init(scenceID,from_type,npc_id,index), fwin._view)
		end

		state_machine.excute("duplicate_manager_window_hide", 0, "")
		state_machine.excute("home_button_for_action_window_open", 0, "")
		state_machine.excute("chat_view_window_open", 0, "")
		state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("star_box_duplicate_window_open", 0, nil)
        if fwin:find("SevenStarMapUiClass")  ~= nil then
        	state_machine.excute("chat_view_window_hide", 0, "")  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭
local duplicate_map_window_close_terminal = {
    _name = "duplicate_map_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("DuplicateMapClass")
        local copytype = 1
        if win ~= nil then
        	copytype = win.copytype
            fwin:close(win)
        end 
        if fwin:find("HeroStarActivationClass")  ~= nil then
        	state_machine.excute("duplicate_manager_window_close",0,"")
        	state_machine.excute("hero_star_activation_window_show",0,"")
        elseif fwin:find("PacksClass")  ~= nil then
        	state_machine.excute("duplicate_manager_window_close",0,"")
        	state_machine.excute("packs_window_show",0,"")
        elseif fwin:find("TaskClass")  ~= nil then
        	state_machine.excute("duplicate_manager_window_close",0,"")
        	state_machine.excute("task_window_show",0,"")
        elseif fwin:find("SevenStarClass")  ~= nil then
        	state_machine.excute("duplicate_manager_window_close",0,"")
        	state_machine.excute("seven_star_window_show",0,"")
        else
        	if fwin:find("DuplicateManagerClass") == nil then
        		state_machine.excute("duplicate_manager_window_open",0,{copytype})
        	else
        		state_machine.excute("duplicate_manager_window_show",0,"")
        	end
        end

     --    cacher.removeAllTextures()
    	-- fwin:freeAllMemeryPool()
    	
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_map_window_open_terminal)
state_machine.add(duplicate_map_window_close_terminal)
state_machine.init()

function DuplicateMap:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.sceneID = nil
	self.copytype = nil -- 1 简单 2 普通 3 困难 --可能没用到，留着或许以后会用
	self.short_cut_npc_id = nil
	self.index = nil

	self.hasImmaturity = false

	self.npc_cells = {}

	self.npcIds = {}
	self.npcStates = {}

	self._npc_ids = {}
	
	self.UpLArmature = nil

	app.load("client.red_alert.cells.duplicate.duplicate_npc_cell")
	app.load("client.red_alert.duplicate.ClearanceSuccess")
	app.load("client.mission.missionex.PrologueScreenInfo")
	app.load("client.red_alert.battle.battle_enum")
	
    local function init_duplicate_map_window_terminal()
   		-- 外部跳转定位
        local duplicate_map_short_cut_npc_terminal = {
            _name = "duplicate_map_short_cut_npc",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               	instance:npcAddShowCut(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示界面
		local duplicate_map_window_show_terminal = {
            _name = "duplicate_map_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                instance:showCurrentLevelSign()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--隐藏界面
		local duplicate_map_window_hide_terminal = {
            _name = "duplicate_map_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --升级
		local duplicate_map_check_level_up_terminal = {
            _name = "duplicate_map_check_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:checkLevelUp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --升级
		local duplicate_map_move_to_choose_npc_terminal = {
            _name = "duplicate_map_move_to_choose_npc",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:moveToChoosePos(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(duplicate_map_short_cut_npc_terminal)
        state_machine.add(duplicate_map_window_show_terminal)
        state_machine.add(duplicate_map_window_hide_terminal)
        state_machine.add(duplicate_map_check_level_up_terminal)
        state_machine.add(duplicate_map_move_to_choose_npc_terminal)
        state_machine.init()
    end
    
    init_duplicate_map_window_terminal()
end

--npc绘制
function DuplicateMap:onUpdateDraw()
	local root = self.roots[1]
	local action = self.actions[1]
	local ScrollView_duplicate_map = ccui.Helper:seekWidgetByName(root,"ScrollView_duplicate_map")
	ScrollView_duplicate_map:jumpToBottom()

	local sceneID = tonumber(self.sceneID)
	if sceneID ~= DuplicateMap.__last_scene_id then
		DuplicateMap.__last_scene_id = sceneID
		for i, v in pairs(DuplicateMap.__cache_spines) do
			v:release()
		end
		DuplicateMap.__cache_spines = {nil}
	end

	self.npcIds = {}
	self.npcStates = {}

	local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.npcs), ",")
	local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
	local tIndex = 1
	for i = 1, table.getn(tempNpcIds) do
		local npcState = 0
		if sceneState + 1 == i then
			npcState = 1
			self.npcIds[tIndex] = tempNpcIds[i]
			self.npcStates[tIndex] = npcState
			break
		end
		self.npcIds[tIndex] = tempNpcIds[i]
		self.npcStates[tIndex] = npcState
		tIndex = tIndex + 1
	end
	-- npc
	local npcIdTableText = nil
	local npcIdTable = nil



	local isPassAll = true
	local index = 1
	for i = 1, #tempNpcIds do
		local NpcPad = nil 
		if self.copytype == 1 and tonumber(self.sceneID) ~= 1 then 
			NpcPad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_npc_"..i)
		else
			NpcPad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_npc_"..index)
		end
		NpcPad:removeAllChildren(true)
		index = index + 2
		local boss_flag = false
		local boss_index = dms.int(dms["npc"],tempNpcIds[i],npc.npc_type)

		if boss_index == 1 then
			boss_flag = true
		end		
		local npc_cell = state_machine.excute("duplicate_npc_create_cell",0,{tempNpcIds[i],self.sceneID,boss_flag,self.npcStates[i],i})
		NpcPad:addChild(npc_cell)
		table.insert(self.npc_cells,npc_cell)
		if tonumber(self.short_cut_npc_id) == tonumber(tempNpcIds[i]) then -- 跳转进来的
			local x = NpcPad:getPositionX()-- - NpcPad:getContentSize().width*2
			local y = NpcPad:getPositionY()-- + NpcPad:getContentSize().height*2
			local size = ScrollView_duplicate_map:getInnerContainer():getContentSize()
			-- debug.print_r(size)
			isPassAll = false
			local move_x = x/size.width*100
			local move_y = 100 - y/size.height*100
			-- print("====0=====",move_x,move_y)
			if move_x > 70 then
				move_x = 100 
			elseif move_x < 30 then
				move_x = 0
			end
			if move_y > 70 then
				move_y = 100 
			elseif move_y < 30 then
				move_y = 0
			end
			-- print("=====1====",move_x,move_y)
			ScrollView_duplicate_map:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
		else
			--定位到最新npc
			if self.npcStates[i] == 1 and self.short_cut_npc_id == nil then
				local x = NpcPad:getPositionX()-- - NpcPad:getContentSize().width*2
				local y = NpcPad:getPositionY()-- + NpcPad:getContentSize().height*2
				local size = ScrollView_duplicate_map:getInnerContainer():getContentSize()
				-- debug.print_r(size)
				isPassAll = false
				local move_x = x/size.width*100
				local move_y = 100 - y/size.height*100
				-- print("====0=====",move_x,move_y)
				if move_x > 70 then
					move_x = 100 
				elseif move_x < 30 then
					move_x = 0
				end
				if move_y > 70 then
					move_y = 100 
				elseif move_y < 30 then
					move_y = 0
				end
				-- print("=====1====",move_x,move_y)
				ScrollView_duplicate_map:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
				-- ScrollView_duplicate_map:scrollToPercentBothDirection(cc.p(100,0),0.5,true)
			end
		end
	end
	if isPassAll == true then
		ScrollView_duplicate_map:jumpToTopRight()
	end
	self.hasImmaturity = isPassAll
	for i, v in pairs(tempNpcIds) do
		table.insert(self._npc_ids, v)
	end
	--滑动完之后再添加人
	local function createNpc()
		-- self:createAllNpcAnimation(tempNpcIds)
		if DuplicateMap.__npc_index <= #self.npc_cells then
			local index = DuplicateMap.__npc_index
			if DuplicateMap.__npc_index < 0 then
				index = #self.npcStates
				DuplicateMap.__npc_index = 0
			end
			self.npc_cells[index]:createNpcAnimation(self.npcIds[index], self.short_cut_npc_id, DuplicateMap.__cache_spines)
			DuplicateMap.__npc_index = DuplicateMap.__npc_index + 1
			self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(createNpc)))

			if  DuplicateMap.__npc_index == 2 then
				self:checkPassLevel()
			end
		end
	end
	DuplicateMap.__npc_index = -1
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(createNpc)))
end

function DuplicateMap:npcAddShowCut(npc_id)
	for i,npc_cell in pairs(self.npc_cells) do
		npc_cell:removeShortCutNpc()
		-- print("=============",npc_id,npc_cell.npc_id)
		if tonumber(npc_id) == tonumber(npc_cell.npc_id) then
			npc_cell:showShortCutNpc()
		end
	end
end

function DuplicateMap:showCurrentLevelSign()
	
	for i,npc_cell in pairs(self.npc_cells) do
		
		-- print("=============",npc_id,npc_cell.npc_id)
		npc_cell:showCurrentLevelSign()
		
	end
end

function DuplicateMap:createAllNpcAnimation( tempNpcIds )
	-- local index = 1
	-- local function createCell()
	-- 	if index > #tempNpcIds then
	-- 		self:stopAllActions()
	-- 		return
	-- 	end
	-- 	self.npc_cells[index]:createNpcAnimation(tempNpcIds[index])
	-- 	index = index + 1
	-- end
 --    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(createCell)))
 --    self:runAction(action)
 	local index = 1
 	local create_index = false
 	for i,v in pairs(self.npcStates) do
 		if self.npcStates[i] == 1 then
 			index = i
 			create_index = true
 		end
 	end
 	if create_index == false then
 		self.npc_cells[#self.npcStates]:createNpcAnimation(self.npcIds[#self.npcStates],self.short_cut_npc_id)
 	else
 		self.npc_cells[index]:createNpcAnimation(self.npcIds[index],self.short_cut_npc_id)
 	end
 	
 	DuplicateMap.__npc_index = 1
	local temp_bust_index = dms.int(dms["npc"], self._npc_ids[DuplicateMap.__npc_index], npc.head_pic)
	temp_bust_index = 10000 + temp_bust_index
	local sprite_png_path = "sprite/spirte_"..temp_bust_index ..".png"
	cc.Director:getInstance():getTextureCache():addImageAsync(sprite_png_path, self.loading_npc_cell, self, true, true)

end

function DuplicateMap:loading_npc_cell()
	-- print("========0000000",os.clock())
	self.npc_cells[DuplicateMap.__npc_index]:createNpcAnimation(self.npcIds[DuplicateMap.__npc_index],self.short_cut_npc_id)
	-- print("========1111111",os.clock())
	DuplicateMap.__npc_index = DuplicateMap.__npc_index + 1
	if DuplicateMap.__npc_index <= #self.npc_cells then
	 	local temp_bust_index = dms.int(dms["npc"], self._npc_ids[DuplicateMap.__npc_index], npc.head_pic)
	 	temp_bust_index = 10000 + temp_bust_index
		local sprite_png_path = "sprite/spirte_"..temp_bust_index ..".png"
		cc.Director:getInstance():getTextureCache():addImageAsync(sprite_png_path, self.loading_npc_cell, self, true, true)
		-- print("========22222222222",os.clock())
	end
end

function DuplicateMap:onHide()
    self:setVisible(false)
end

function DuplicateMap:onShow()
    self:setVisible(true)
end

function DuplicateMap:checkLevelUp()
	-- print("=======_ED.last_level===",_ED.last_level)
	if _ED.last_level ~= 0 then
		if _ED.last_level ~= _ED.user_info.user_grade then
			if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
				if zstring.tonumber(_ED.last_level) >= 6 then
					state_machine.excute("player_upgrade_window_open",0,{_ED.last_level,_ED.last_user_food})
				end
			else
				state_machine.excute("player_upgrade_window_open",0,{_ED.last_level,_ED.last_user_food})
			end
		end
	end
end

function DuplicateMap:checkPassLevel()
    if self.copytype == battle_enum._fight_type._fight_type_104 then
    else
		local len = #self._npc_ids 
		local last_npc = self._npc_ids[len]
		if tonumber(_ED.npc_last_state[tonumber(last_npc)]) <= 0 then
			if tonumber(_ED.npc_state[tonumber(last_npc)]) > 0 then 
				state_machine.excute("clearance_success_window_open",0,"")
			end
		end
		self:checkLevelUp()
	end
end

function DuplicateMap:checkMission()
    if _ED._scene_npc_id ~= "" and _ED._scene_npc_id ~= nil then
        if tonumber(_ED.npc_last_state[tonumber(_ED._scene_npc_id)])  <= 0 and 
            tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)]) > 0 then
            -- print("============尝试去触发npc")
            if executeMissionExt(mission_mould_battle,touch_off_mission_ls_scene,"".._ED._scene_npc_id.."v1",nil,nil,true,true) == true then
                -- print("============npc触发成功")
            else
                local sceneParam = "sc".._ED.scene_current_state[zstring.tonumber("".._ED.easy_now_scene_id)] .. "m".._ED.scene_max_state[zstring.tonumber("".._ED.easy_now_scene_id)]
                if executeMissionExt(mission_mould_tuition, touch_off_mission_battle_over, "".._ED.easy_now_scene_id, nil, true, sceneParam, false) == false then
                	
                end
            end
        end  

        _ED.npc_last_state[tonumber(_ED._scene_npc_id)] = tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)])
    end
end

function DuplicateMap:moveToChoosePos( index )
    if index <= 0 or index > #self.npc_cells then
        return
    end

	local ScrollView_duplicate_map = ccui.Helper:seekWidgetByName(self.roots[1],"ScrollView_duplicate_map")
	local NpcPad = self.npc_cells[index]
	-- if tonumber(self.short_cut_npc_id) == tonumber(choose_npc) then -- 跳转进来的
		local x = NpcPad:getPositionX()-- - NpcPad:getContentSize().width*2
		local y = NpcPad:getPositionY()-- + NpcPad:getContentSize().height*2
		local size = ScrollView_duplicate_map:getInnerContainer():getContentSize()
		isPassAll = false
		local move_x = x/size.width*100
		local move_y = 100 - y/size.height*100
		-- print("====0=====",move_x,move_y)
		if move_x > 70 then
			move_x = 100 
		elseif move_x < 30 then
			move_x = 0
		end
		if move_y > 70 then
			move_y = 100 
		elseif move_y < 30 then
			move_y = 0
		end
		-- print("=====1====",move_x,move_y)
		ScrollView_duplicate_map:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
	-- else
		--定位到最新npc
		-- if self.npcStates[i] == 1 and self.short_cut_npc_id == nil then
		-- 	local x = NpcPad:getPositionX()-- - NpcPad:getContentSize().width*2
		-- 	local y = NpcPad:getPositionY()-- + NpcPad:getContentSize().height*2
		-- 	local size = ScrollView_duplicate_map:getInnerContainer():getContentSize()
		-- 	-- debug.print_r(size)
		-- 	isPassAll = false
		-- 	local move_x = x/size.width*100
		-- 	local move_y = 100 - y/size.height*100
		-- 	-- print("====0=====",move_x,move_y)
		-- 	if move_x > 70 then
		-- 		move_x = 100 
		-- 	elseif move_x < 30 then
		-- 		move_x = 0
		-- 	end
		-- 	if move_y > 70 then
		-- 		move_y = 100 
		-- 	elseif move_y < 30 then
		-- 		move_y = 0
		-- 	end
		-- 	-- print("=====1====",move_x,move_y)
		-- 	ScrollView_duplicate_map:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
		-- 	-- ScrollView_duplicate_map:scrollToPercentBothDirection(cc.p(100,0),0.5,true)
		-- end
	-- end
end

function DuplicateMap:onEnterTransitionFinish()
	local map_id = dms.int(dms["pve_scene"],self.sceneID,pve_scene.scene_map_id)
	local filePath = string.format(config_csb.duplicate.map.duplicate_map,map_id) 
    local csbMap = csb.createNode(filePath)
    local root = csbMap:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbMap)
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local Panel_pve_splice = ccui.Helper:seekWidgetByName(root,"Panel_pve_splice")
		local m_mapid = 1
		if map_id == 1 then
			m_mapid = 2
		else
			m_mapid = map_id
		end
		Panel_pve_splice:removeAllChildren(true)
		local Panel_map_image1 = ccui.Layout:create()
		Panel_map_image1:setContentSize(cc.size(1024, 512))
		Panel_pve_splice:addChild(Panel_map_image1)
		Panel_map_image1:setPosition(cc.p(Panel_pve_splice:getPositionX(),Panel_pve_splice:getPositionY()+128))
		Panel_map_image1:setBackGroundImage(string.format("images/ui/pve_sn/pve_map/pve_map_%s_01.png", m_mapid))
	
		local Panel_map_image2 = ccui.Layout:create()
		Panel_map_image2:setContentSize(cc.size(256, 512))
		Panel_pve_splice:addChild(Panel_map_image2)
		Panel_map_image2:setPosition(cc.p(Panel_map_image1:getPositionX()+Panel_map_image1:getContentSize().width,Panel_map_image1:getPositionY()))
		Panel_map_image2:setBackGroundImage(string.format("images/ui/pve_sn/pve_map/pve_map_%s_02.png", m_mapid))
	
		local Panel_map_image3 = ccui.Layout:create()
		Panel_map_image3:setContentSize(cc.size(256, 512))
		Panel_pve_splice:addChild(Panel_map_image3)
		Panel_map_image3:setPosition(cc.p(Panel_map_image2:getPositionX()+Panel_map_image2:getContentSize().width,Panel_map_image2:getPositionY()))
		Panel_map_image3:setBackGroundImage(string.format("images/ui/pve_sn/pve_map/pve_map_%s_03.png", m_mapid))
	
		local Panel_map_image4 = ccui.Layout:create()
		Panel_map_image4:setContentSize(cc.size(1024, 128))
		Panel_pve_splice:addChild(Panel_map_image4)
		Panel_map_image4:setPosition(cc.p(0,0))
		Panel_map_image4:setBackGroundImage(string.format("images/ui/pve_sn/pve_map/pve_map_%s_04.png", m_mapid))
	
		local Panel_map_image5 = ccui.Layout:create()
		Panel_map_image5:setContentSize(cc.size(256, 128))
		Panel_pve_splice:addChild(Panel_map_image5)
		Panel_map_image5:setPosition(cc.p(Panel_map_image4:getPositionX()+Panel_map_image4:getContentSize().width,0))
		Panel_map_image5:setBackGroundImage(string.format("images/ui/pve_sn/pve_map/pve_map_%s_05.png", m_mapid))
	
		local Panel_map_image6 = ccui.Layout:create()
		Panel_map_image6:setContentSize(cc.size(256, 262))
		Panel_pve_splice:addChild(Panel_map_image6)
		Panel_map_image6:setPosition(cc.p(Panel_map_image5:getPositionX()+Panel_map_image5:getContentSize().width,0))
		Panel_map_image6:setBackGroundImage(string.format("images/ui/pve_sn/pve_map/pve_map_%s_06.png", m_mapid))
	end
	self:onUpdateDraw()
	-- self:checkPassLevel()--延迟出升级，和通关动画
	self:checkMission()
	local len = #self._npc_ids 
	local last_npc = self._npc_ids[len]
	_ED.npc_last_state[tonumber(last_npc)] = _ED.npc_state[tonumber(last_npc)]

	local check_scene = self:firstOpenScene(self.sceneID)
	if missionIsOver() == true then
		if self.copytype == 1 then
			if check_scene == true then
				self:chenkupFinishedAllNPC()
				self:chenkupFirstInto()
			end
		else
			local npcInfo = fwin:find("PrologueScreenInfoClass")
			if npcInfo ~= nil then
				fwin:close(npcInfo)
			end
		end
	end
end

function DuplicateMap:firstOpenScene(sceneId)
	if _ED.scene_last_state[sceneId] ~= _ED.scene_current_state[sceneId] then
		_ED.scene_last_state[sceneId] = _ED.scene_current_state[sceneId]
		return true
	end
	return false
end

function DuplicateMap:chenkupFinishedAllNPC()
	if self.hasImmaturity == true then
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			if zstring.tonumber(self.sceneID) >= 6 then
				local infoGUI = PrologueScreenInfo:new()
				infoGUI:init(self.sceneID, self.index, 1)
				fwin:open(infoGUI, fwin._screen)
			end
		else
			local infoGUI = PrologueScreenInfo:new()
			infoGUI:init(self.sceneID, self.index, 1)
			fwin:open(infoGUI, fwin._screen)
		end
	end
end

function DuplicateMap:chenkupFirstInto()
	local currentStar = tonumber(_ED.get_star_count[self.sceneID])
	if currentStar == 0 then 
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			if zstring.tonumber(self.sceneID) >= 6 then
				local infoGUI = PrologueScreenInfo:new()
				infoGUI:init(self.sceneID, self.index, 0)
				fwin:open(infoGUI, fwin._screen)
			end
		else
			local infoGUI = PrologueScreenInfo:new()
			infoGUI:init(self.sceneID, self.index, 0)
			fwin:open(infoGUI, fwin._screen)
		end
	end
end

function DuplicateMap:init(_sceneID,_type,_npc_id,index)
	self.sceneID = _sceneID
	self.copytype = _type
	self.short_cut_npc_id = _npc_id
	self.index = index
	return self
end

function DuplicateMap:close( ... )
	for i=1,9 do
		local NpcPad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_npc_"..i)
		if NpcPad ~= nil then
			NpcPad:removeAllChildren(true)
		end
	end
end

function DuplicateMap:onExit()
	state_machine.remove("duplicate_map_short_cut_npc")
	state_machine.remove("duplicate_map_window_show")
	state_machine.remove("duplicate_map_window_hide")
	state_machine.remove("duplicate_map_check_level_up")
	state_machine.remove("duplicate_map_move_to_choose_npc")
end
