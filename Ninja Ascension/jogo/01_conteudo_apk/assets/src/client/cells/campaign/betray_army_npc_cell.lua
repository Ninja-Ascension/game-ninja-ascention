-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军围剿的npc形象绘制
-- 创建时间：2015-03-30
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyNpcCell = class("BetrayArmyNpcCellClass", Window)
    
function BetrayArmyNpcCell:ctor()
    self.super:ctor()
	app.load("client.campaign.worldboss.BetrayArmyBattleScene")
    self.roots = {}
	self.actions = {}
	self.npcExample = nil 
	self.activityType = nil
	self.actionT = nil
	self.Index = 0
	self.isDie = false
	self.world_boss_hero = nil --用做变灰的

    -- Initialize BetrayArmyNpcCell page state machine.
    local function init_arena_ladder_panel_terminal()
		--	打开npc二级信息界面
		local betray_army_npc_cell_into_battle_info_terminal = {
            _name = "betray_army_npc_cell_into_battle_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local NpcExample = params._datas._npcExample
				local _cell = params._datas.cell
				local BetrayArmyPve = BetrayArmyBattleScene:new()
				BetrayArmyPve:init(NpcExample,_cell)
				fwin:open(BetrayArmyPve, fwin._ui)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新状态
		-- local betray_army_npc_cell_refresh_terminal = {
            -- _name = "betray_army_npc_cell_refresh",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
				-- params.npcCell:oudataDraw(params.betrayArmyId)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- 刷新状态及血量
		local world_boss_update_role_npc_info_terminal = {
            _name = "world_boss_update_role_npc_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				params.cell:updateState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(world_boss_update_role_npc_info_terminal)
		state_machine.add(betray_army_npc_cell_into_battle_info_terminal)
		state_machine.add(betray_army_npc_cell_refresh_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_panel_terminal()
end


-- 更新
function BetrayArmyNpcCell:updateState()
	if true ~= self.isDie then
		for i = 1 , _ED.worldboss_refush_rebel_army.count do
			local data = _ED.worldboss_refush_rebel_army.list[i]
			
			if data[1] == tonumber(self.npcExample.betray_army_example) then
				
				local root = self.roots[1]
				local HpLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")	--npc血条
				HpLoadingBar:setPercent(tonumber(self.npcExample.surplus_hp) / tonumber(self.npcExample.all_hp) * 100)
				
				if tonumber(self.npcExample.surplus_hp) <= 0 then
					self:oudataDraw(zstring.tonumber(self.npcExample.betray_army_id),self.npcExample.surplus_hp)
				end
			
				break
			end
		end
	end
end



function BetrayArmyNpcCell:oudataDraw(betrayArmyId,npcHp)
	self.isDie = true
	local root = self.roots[1]
	local TextDoom = ccui.Helper:seekWidgetByName(root, "Text_40")	--npc己击沉
	local TextFlee = ccui.Helper:seekWidgetByName(root, "Text_41")	--npc己逃跑
	if zstring.tonumber(npcHp) <= 0 then
		TextDoom:setVisible(true)
		TextFlee:setVisible(false)
	else
		TextDoom:setVisible(false)
		TextFlee:setVisible(true)
	end
	local PanelNpc = ccui.Helper:seekWidgetByName(root, "Panel_3")	--npc形象
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_yugioh then
		if npcHp == nil then
			TextDoom:setVisible(false)
			TextFlee:setVisible(true)
		end
	else
		local npcHeadPic = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.aram_pic)  -1000
		local npcIcon = string.format("images/face/big_head/big_head_%d.png", npcHeadPic)

		local isHaveSpineAni = false
		if __lua_project_id == __lua_project_yugioh then
			local jsonFile = string.format("sprite/spirte_battle_card_%s.json", npcHeadPic)
			if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
				isHaveSpineAni = true
				PanelNpc:removeAllChildren(true)
		        local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", npcHeadPic)
		        app.load("client.battle.fight.FightEnum")
		        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
		            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

		        spArmature:setPosition(cc.p(PanelNpc:getContentSize().width/2, 0))
		        spArmature.animationNameList = spineAnimations
		        sp.initArmature(spArmature, true)
		        PanelNpc:addChild(spArmature)
		    end
	    end
		if isHaveSpineAni == false then
			local background = cc.Sprite:create(npcIcon)
			background:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
			background:setAnchorPoint(cc.p(0.5, 0.5))
			background:setPosition(cc.p(PanelNpc:getContentSize().width/2,PanelNpc:getContentSize().height/2))
			PanelNpc:addChild(background)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.world_boss_hero:setColor(cc.c3b(50, 50, 50))--灰色处理
	else
		display:gray(PanelNpc)
	end

	self.actionT:stopAllActions()	--	停止动画
	ccui.Helper:seekWidgetByName(root, "Panel_2"):setTouchEnabled(false)
	-- self.Index = 0
end
function BetrayArmyNpcCell:initDraw()

	local root = self.roots[1]
	
	
	local TextName = ccui.Helper:seekWidgetByName(root, "Text_37")	--npc名字
	local PanelNpc = ccui.Helper:seekWidgetByName(root, "Panel_3")	--npc形象
	local FindName = ccui.Helper:seekWidgetByName(root, "Text_1_0")	--发现者名字
	local HpLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")	--npc血条
	local PanelInfo = ccui.Helper:seekWidgetByName(root, "Panel_22")	
	
	local betrayArmyId = zstring.tonumber(self.npcExample.betray_army_id)	--叛军模板

	--npc名字
	local npcName = dms.string(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.army_name)
	local quality = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.army_quality)
	local color = tipStringInfo_quality_color_Type[quality]
	local npcNameColor = cc.c4b(color[1],color[2],color[3],255) -- cc.c4b(255,0,0,255)	
	--npc形象
	local npcHeadPic = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		npcHeadPic = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.aram_pic)
	else
		npcHeadPic = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.aram_pic) - 1000
	end
	--发现者名字
	--print("---",npcHeadPic)
	--if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--q版动画一样高
		-- if npcHeadPic == 229 then--巨罗汉异于常人，所以他头上的名字和进度条程序控制加高
		-- 	local panelneedup = ccui.Helper:seekWidgetByName(root, "Image_8")
		-- 	panelneedup:setPositionY(panelneedup:getPositionY()+55)
		-- end
	--end
	FindName:setString(self.npcExample.friend_name)
	
	TextName:setString(npcName)
	TextName:setColor(npcNameColor)
	PanelInfo:setVisible(true)
	HpLoadingBar:setPercent(tonumber(self.npcExample.surplus_hp) / tonumber(self.npcExample.all_hp) * 100)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		local index=_ED.betray_army_information.army_count
		-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. npcHeadPic .. ".ExportJson")
		-- local cell = ccs.Armature:create("spirte_" .. npcHeadPic)
		-- cell:getAnimation():playWithIndex(0)
		-- PanelNpc:removeAllChildren(true)
		-- PanelNpc:addChild(cell)
		-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
		-- -- cell:setPosition(cc.p(PanelNpc:getContentSize().width/2, PanelNpc:getContentSize().height/2))
		-- cell:setPosition(cc.p(PanelNpc:getContentSize().width/2, 0))

		local temp_bust_index = npcHeadPic
		local shipPanel = PanelNpc
		shipPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local hero = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			self.world_boss_hero = hero
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        self.world_boss_hero:setScaleX(-1)
		    end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end
	else
	
		local npcIcon = string.format("images/face/big_head/big_head_%d.png", npcHeadPic)
		PanelNpc:setBackGroundImage(npcIcon)
	end
	
	

	-- local background = cc.Sprite:create(npcIcon)
	-- -- background:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
	-- background:setAnchorPoint(cc.p(0.5, 0.5))
	-- background:setPosition(cc.p(PanelNpc:getContentSize().width/2,PanelNpc:getContentSize().height/2))
	-- PanelNpc:addChild(background)	
	
	-- 当血值为0,及表示已击杀,切换显示状态
	if tonumber(self.npcExample.surplus_hp) <= 0 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_yugioh then
			self:oudataDraw(self.npcExample.betray_army_id,0)
		else
			self:oudataDraw(self.npcExample.betray_army_id)
		end
	end
end


function BetrayArmyNpcCell:DarwFleeTime()
	local root = self.roots[1]
	if _ED.betray_army_information.army_time ~= nil then
		local times = os.time()- tonumber(_ED.betray_army_information.army_time)
		
		local FleeTime = 0
		if times < self.npcExample.stop_time/1000 then 
			FleeTime =self.npcExample.stop_time/1000-times	--剩余刷新的时间
			if math.floor(tonumber(FleeTime)) == 0 then
				self.Index = self.Index + 1
				if tonumber(self.Index) == 1 then
					self:oudataDraw(self.npcExample.betray_army_id)
					self:onUpdate(nil)
				end
			end
		end
	end
end
function BetrayArmyNpcCell:onUpdate(dt)
	if true ~= self.isDie then
		self:DarwFleeTime()
	end
end
function BetrayArmyNpcCell:onEnterTransitionFinish()
	
    local csbBetrayArmyNpcCell = csb.createNode("campaign/WorldBoss/worldBoss_role.csb")
	local root = csbBetrayArmyNpcCell:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbBetrayArmyNpcCell)
	
	self.actionT = csbBetrayArmyNpcCell
	-- 叛军NPC呼吸动画
	local action = csb.createTimeline("campaign/WorldBoss/worldBoss_role.csb")
	table.insert(self.actions, action)
	self.actionT:runAction(action)
	action:play("Panel_3_dh", true)

	local function trigger_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				state_machine.excute("betray_army_npc_cell_into_battle_info", 0, {_datas={  _npcExample = self.npcExample, cell = self}})
			end
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(trigger_onTouchEvent)
	
	
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
		-- {
			-- terminal_name = "betray_army_npc_cell_into_battle_info",
			-- terminal_state = 0,
			-- _npcExample = self.npcExample,
			-- cell = self,
			-- -- isPressedActionEnabled = true
		-- }, nil, 0)
	ccui.Helper:seekWidgetByName(root, "Panel_2"):setSwallowTouches(false)
	self:initDraw()
end

function BetrayArmyNpcCell:createCell()
	local cell = BetrayArmyNpcCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end

function BetrayArmyNpcCell:init(npcExample)
	self.npcExample = npcExample
end


function BetrayArmyNpcCell:onExit()
	state_machine.remove("world_boss_update_role_npc_info")
end
