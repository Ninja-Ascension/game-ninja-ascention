-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场天梯区域及对手显示区
-- 创建时间：2015-03-30
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaLadderSeatCell = class("ArenaLadderSeatCellClass", Window)
ArenaLadderSeatCell.__size = nil
ArenaLadderSeatCell.__userHeroFontName = nil
ArenaLadderSeatCell.__selfIndex = 0
function ArenaLadderSeatCell:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.roleInstance = nil
	
	--rank text
	self.cacheRankText = nil
	
	--force text
	self.cacheForceText = nil
	
	--name text
	self.cacheNameText = nil
	self._armature = nil
	self.roleShipId = 0
	self.isAddRole = false
    -- Initialize ArenaLadderSeatCell page state machine.
    local function init_arena_ladder_seat_terminal()
	
		local arena_role_icon_click_terminal = {
            _name = "arena_role_icon_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				local cell = params._datas.cell
				state_machine.excute("arena_oppoent_fight", 0, {
					_datas = {
						but_image = "fight", 		
						terminal_state = 0, 
						isPressedActionEnabled = true,
						opponentInstance = cell
					}
				})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --扫荡5次
		local arena_ladder_seat_cell_fight_five_counts_terminal = {
            _name = "arena_ladder_seat_cell_fight_five_counts",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if zstring.tonumber(_ED.user_info.endurance) < 2 then
					app.load("client.cells.prop.prop_buy_prompt")
					local win = PropBuyPrompt:new()
					win:init(getPiratesConfigPropMID(16), 2)
					fwin:open(win, fwin._ui)
					return
				end
            	local target = params._datas.cell
				local function responseOneKeyArenaCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if _ED._areana_one_key_reward ~= nil and _ED._areana_one_key_reward ~= "" then 
							app.load("client.campaign.arena.ArenaMopReward")
							state_machine.excute("arena_mop_reward_window_close", 0, 0)
							state_machine.excute("arena_mop_reward_window_open", 0, 0)
						end
					end
				end
            	protocol_command.one_key_sweep_arena.param_list = target.roleInstance.rank .. "\r\n0"
				NetworkManager:register(protocol_command.one_key_sweep_arena.code, nil, nil, nil, parent, responseOneKeyArenaCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_role_icon_click_terminal)
		state_machine.add(arena_ladder_seat_cell_fight_five_counts_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_seat_terminal()
end

-- 落水
function ArenaLadderSeatCell:playDropoutAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		return
	end
	local root = self.roots[1]
	if root == nil then
        return
    end

	self.action:play("Panel_dh_1", false)
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end

		local str = frame:getEvent()
		if str == "over1" then
			state_machine.excute("arena_ladder_seat_cell_play_dropout_action_complete", 0, 0)
		end
	end)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_light") 
		panel:setVisible(true)
		self._armature = panel:getChildByName("ArmatureNode_5")
		self._armature:getAnimation():playWithIndex(0)
	end
end

-- 进入
function ArenaLadderSeatCell:playTurnintoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		return
	end	
	local root = self.roots[1]
	if root == nil then
        return
    end

	self.action:play("Panel_dh_2", false)
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end

		local str = frame:getEvent()
		if str == "over2" then
			state_machine.excute("arena_ladder_seat_cell_play_turninto_action_complete", 0, 0)
		end
	end)

end

function ArenaLadderSeatCell:addHeroAnimaton()
	local root = self.roots[1]
	local role = self.roleInstance
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		self.roleIconPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.roleIconPanel, nil, nil, cc.p(0.5, 0))
		
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local ship_mould_pic_id = _user_pic_index[self.roleShipId]
			self._armature = sp.spine_sprite(self.roleIconPanel, ship_mould_pic_id, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        self._armature:setScaleX(-1)
		    end
		else
			self._armature = draw.createEffect("spirte_" .. self.roleShipId, "sprite/spirte_" .. self.roleShipId .. ".ExportJson", self.roleIconPanel, -1, nil, nil, cc.p(0.5, 0))
		end
		self.isAddRole = true
	elseif __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon
		then
		self.roleIconPanel:removeAllChildren(true)
		local movementIndex = dms.string(dms["ship_mould"], self.roleInstance.template[1], ship_mould.movement)
		if tonumber(movementIndex) > 0 then
            for k,v in pairs(__fashion_animation_info) do
                local animations = zstring.split(v[2], ",")
                for i,id in ipairs(animations) do
                    if tonumber(id) == tonumber(self.roleInstance.icon) then
                        movementIndex = v[1]
                        break
                    end
                end
            end
        end
		local jsonFile = ""
        local atlasFile = ""
        if __lua_project_id == __lua_project_yugioh then
            atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", movementIndex)
			jsonFile = string.format("sprite/spirte_battle_card_%s.json", movementIndex)
		else
			atlasFile = string.format("sprite/big_head_%s.atlas", movementIndex)
			jsonFile = string.format("sprite/big_head_%s.json", movementIndex)
		end
        app.load("client.battle.fight.FightEnum")
        self._armature = sp.spine(jsonFile, atlasFile, 1, 0, 
            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

        self._armature:setPosition(cc.p(self.roleIconPanel:getContentSize().width/2, 0))
        self._armature.animationNameList = spineAnimations
        sp.initArmature(self._armature, true)
        self.roleIconPanel:addChild(self._armature)
        self.isAddRole = true
	elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_rouge
		then
		self.roleIconPanel:removeBackGroundImage()
		self.roleIconPanel:setBackGroundImage("images/face/big_head/big_head_" .. self.roleShipId .. ".png")
	elseif __lua_project_id == __lua_project_warship_girl_b then
		self.roleIconPanel:removeBackGroundImage()
		self.roleIconPanel:setBackGroundImage("images/face/card_head/card_head_" .. self.roleShipId .. ".png")
	end
end

function ArenaLadderSeatCell:initDraw()

	local root = self.roots[1]
	local role = self.roleInstance
	
	self.roleIconPanel:removeBackGroundImage()
	
	--> print("asdasdasdasdasdasdasdsdasdasd", role.icon)
	local icon = dms.string(dms["ship_mould"], role.template[1], ship_mould.bust_index)
	if ___is_open_leadname == true then
		if ArenaLadderSeatCell.__userHeroFontName == nil then
			ArenaLadderSeatCell.__userHeroFontName = self.cacheNameText:getFontName()
		end
		if dms.int(dms["ship_mould"], tonumber(role.template[1]), ship_mould.captain_type) == 0 then
			self.cacheNameText:setFontName("")
			self.cacheNameText:setFontSize(self.cacheNameText:getFontSize())-->设置字体大小
		else
			self.cacheNameText:setFontName(ArenaLadderSeatCell.__userHeroFontName)
		end
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b then
		if role.icon ~= nil and zstring.tonumber(role.icon) > 0 then
			icon = role.icon
		end
	end
	self.cacheRankText:setString(role.rank)
	self.cacheNameText:setString(role.name)
	
	
	local petPanel = ccui.Helper:seekWidgetByName(root, "Panel_pet")
	if petPanel ~= nil then 
		--宠物头像
		petPanel:removeAllChildren(true)
		petPanel:removeBackGroundImage()
		if zstring.tonumber(role.pet_template_id) ~= 0 then 
			local picIndex = dms.int(dms["ship_mould"],role.pet_template_id,ship_mould.All_icon)
			petPanel:setBackGroundImage("images/face/big_head/big_head_"..picIndex..".png")	
		end
	end
	if __lua_project_id == __lua_project_pokemon then
	else
		self.roleIconPanel:setBackGroundImage("images/face/card_head/card_head_" .. icon .. ".png")
	end
	local Button5Counts = ccui.Helper:seekWidgetByName(root, "Button_z5c")
	if Button5Counts ~= nil then 
		Button5Counts:setVisible(false)
		
		local is_open =  tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 76, fun_open_condition.level)
		local offValue = zstring.tonumber(self.posIndex) - ArenaLadderSeatCell.__selfIndex
		if offValue <= 2 and offValue > 0 and is_open then 
			Button5Counts:setVisible(true)
		end
	end

	local finalForce = tonumber(role.force)
	if finalForce > 100000 then
		finalForce = math.floor(finalForce / 10000)
		self.cacheForceText:setString(finalForce .. _string_piece_info[150])
	else
		self.cacheForceText:setString(role.force)
	end

	--显示颜色排名------------------------
	local rank = tonumber(role.rank)
	local colorIndex = 0
	if rank <= 3 then
		
		if tonumber(_ED.user_info.user_id) == tonumber(role.id) then
			colorIndex = 4
		else
			colorIndex = 3
		end
	else
		
		if tonumber(_ED.user_info.user_id) == tonumber(role.id) then
			colorIndex = 2
		else
			colorIndex = 1
		end
	end
	self:setShipColor(colorIndex)
end

---------------
--1 默认
--2 主角
--3 前3名
--4 主角在前3名
function ArenaLadderSeatCell:setShipColor(index)

	local valueBool = false
	local root = self.roots[1]

	for i = 1, 4 do
		valueBool = false
		if i == index then
			valueBool = true
		end
	
		ccui.Helper:seekWidgetByName(root, "Image_" .. i):setVisible(valueBool)
	end

end

function ArenaLadderSeatCell:onEnterTransitionFinish()
	
end

function ArenaLadderSeatCell:onInitDraw( isInit )
	if self.roleInstance == -1 then 
		return
	end
	
	local csbPath = ""
	if self.isleft then
		csbPath = "campaign/ArenaStorage/ArenaStorage_list_role.csb"
	else
		csbPath = "campaign/ArenaStorage/ArenaStorage_list_role_1.csb"
	end
	
    local root = cacher.createUIRef(csbPath, "root")
	table.insert(self.roots, root)
    self:addChild(root)
	
	local action = csb.createTimeline(csbPath)
    root:runAction(action)
    self.action = action
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	-- panel:setPosition(cc.p(0, -100))
	panel:setTouchEnabled(false)
	panel:setSwallowTouches(false)
	self:setContentSize(panel:getContentSize())
	--icon
	self.roleIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_role")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self.roleIconPanel == nil then
			self.roleIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_role_top")
		end
	end
	self.roleIconPanel:setSwallowTouches(false)
	
	--rank text
	self.cacheRankText = ccui.Helper:seekWidgetByName(root, "Text_2")
	
	--force text
	self.cacheForceText = ccui.Helper:seekWidgetByName(root, "Text_5")
	
	--name text
	self.cacheNameText = ccui.Helper:seekWidgetByName(root, "Text_role_name")
	self.roleIconPanel.__originScale = self.roleIconPanel:getScale()
	
	if missionIsOver() == true then
		--处理滑动时触发点击
		local function roleIconPanel_onTouchEvent(sender, evenType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if evenType == ccui.TouchEventType.began then
				if sender.playButtonTouchAction ~= true then
					sender.playButtonTouchAction = true
					sender:stopAllActions()
					
					sender.__scale = sender.__originScale
					sender:runAction(cc.ScaleTo:create(0.05, sender.__scale * 1.08))
				end
			elseif evenType == ccui.TouchEventType.moved then
			elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
				if sender.playButtonTouchAction == true then
					sender:stopAllActions()
					sender:runAction(cc.ScaleTo:create(0.05, sender.__scale))
					sender.playButtonTouchAction = false
				end
			
				if math.abs(__epoint.x - __spoint.x) < 10 then
					state_machine.excute("arena_oppoent_fight", 0, {
							_datas = {
								but_image = "fight", 		
								terminal_state = 0, 
								isPressedActionEnabled = true,
								opponentInstance = self
							}
						})
				end
			end
		end
		
		self.roleIconPanel:addTouchEventListener(roleIconPanel_onTouchEvent)
	else
		fwin:addTouchEventListener(self.roleIconPanel, 	nil, {
			terminal_name = "arena_role_icon_click", 	
			terminal_state = 0, 
			cell = self
		}, 
		nil, 0)
	end

	--扫荡5次
	local Button5Counts = ccui.Helper:seekWidgetByName(root, "Button_z5c")
	if Button5Counts ~= nil then 
		fwin:addTouchEventListener(Button5Counts, 	nil, {
			terminal_name = "arena_ladder_seat_cell_fight_five_counts", 	
			terminal_state = 0, 
			cell = self
		}, 
		nil, 0)
	end

	self:initDraw()

	if isInit == true then
		self:addHeroAnimaton()
	end
end

function ArenaLadderSeatCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInitDraw()
end

function ArenaLadderSeatCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	if self.isleft then
		csbPath = "campaign/ArenaStorage/ArenaStorage_list_role.csb"
	else
		csbPath = "campaign/ArenaStorage/ArenaStorage_list_role_1.csb"
	end
    cacher.freeRef(csbPath, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ArenaLadderSeatCell:addRoleArmature( armature )
	local root = self.roots[1]
    if self.isAddRole == true then
        return
    end
	self.roleIconPanel:removeAllChildren(true)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.roleIconPanel, nil, nil, cc.p(0.5, 0))
		self.roleIconPanel:addChild(armature)
		armature:release()
		self._armature = armature
		self.isAddRole = true
	elseif __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon
		then
		self.roleIconPanel:addChild(armature)
		armature:release()
		self._armature = armature
		self.isAddRole = true
	elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_rouge
		then
		self.roleIconPanel:removeBackGroundImage()
		self.roleIconPanel:setBackGroundImage("images/face/big_head/big_head_" .. self.roleShipId .. ".png")
	elseif __lua_project_id == __lua_project_warship_girl_b then
		self.roleIconPanel:removeBackGroundImage()
		self.roleIconPanel:setBackGroundImage("images/face/card_head/card_head_" .. self.roleShipId .. ".png")
	end
end

function ArenaLadderSeatCell:getRoleArmature( ... )
	if self.isAddRole == true then
		self.isAddRole = false
		self._armature:retain()
		self._armature:removeFromParent(true)
		return {self.roleShipId, self._armature}
	end
	return nil
end

function ArenaLadderSeatCell:changeTopName()
	local root = self.roots[1]
	if nil ~= root and nil ~= self.roleIconPanel then
		self.roleIconPanel:setName("Panel_role_top")
	end
end

function ArenaLadderSeatCell:init(role, isleft,i, isLoad)-- 排名 战力值
	if role == -1 then self:setVisible(false) end
	self.roleInstance = role
	self.isleft = isleft
	self.posIndex = i
	self.roleShipId = dms.string(dms["ship_mould"], role.template[1], ship_mould.bust_index)
	if isLoad == true then
		self:onInitDraw(true)
	end
end

function ArenaLadderSeatCell:createCell()
	local cell = ArenaLadderSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ArenaLadderSeatCell:close( ... )
	self.roleIconPanel:removeAllChildren(true)
	local csbPath = ""
	if self.isleft then
		csbPath = "campaign/ArenaStorage/ArenaStorage_list_role.csb"
	else
		csbPath = "campaign/ArenaStorage/ArenaStorage_list_role_1.csb"
	end
    cacher.freeRef(csbPath, self.roots[1])
end

function ArenaLadderSeatCell:onExit()

end
