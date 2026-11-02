-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂人物封装
-- 创建时间	2015.4.27
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHallHead = class("FameHallHeadClass", Window)
    
function FameHallHead:ctor()
    self.super:ctor()
    self.roots = {}
    self.person = nil
	self.types = nil
	self.num = nil
	self.action = nil
	self.cacheFightArmature = nil
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize FameHall page state machine.
    local function init_fame_hall_head_terminal()
		
		local fame_hall_ranking_add_star_terminal = {
            _name = "fame_hall_ranking_add_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local id = params._datas._id
				local cell = params._datas._cell
				local function responseStartCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						TipDlg.drawTextDailog(string.format(_string_piece_info[364], zstring.tonumber(_ED.add_user_silver)))
						
						response.node:onUpdateDraw2()
						state_machine.excute("fame_hall_update", 0, "click fame_hall_update.'")
					end
				end
				if _ED.celebrity_star_add_all_num ~= nil and _ED.celebrity_star_add_all_num ~= "" and tonumber(_ED.celebrity_star_add_all_num) > 0 then
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_djdh"):setVisible(true)
					local function changeActionCallback(armatureBack)
					end
					self.cacheFightArmature = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_djdh"):getChildByName("ArmatureNode_1")
					-- self.cacheFightArmature._needLoad = true
					-- self.cacheFightArmature._invoke = changeActionCallback
					-- self.cacheFightArmature._actionIndex = 0
					-- self.cacheFightArmature._nextAction = 1
					self.cacheFightArmature:getAnimation():playWithIndex(0)
					protocol_command.celebrity_bulletin_support.param_list = id
					NetworkManager:register(protocol_command.celebrity_bulletin_support.code, nil, nil, nil, cell, responseStartCallback, false, nil)
					
				else
					TipDlg.drawTextDailog(_string_piece_info[318])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fame_hall_ranking_add_star_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_fame_hall_head_terminal()
end

function FameHallHead:onUpdateDraw2()
	local root = self.roots[1]
	local starNumLabel = ccui.Helper:seekWidgetByName(root, "Text_402")
	starNumLabel:setString(_ED.celebrity_star_lessen_all_num)
end

function FameHallHead:onUpdateDraw()
	local root = self.roots[1]
	local nameLabel = ccui.Helper:seekWidgetByName(root, "Text_103")
	local typeLabel = ccui.Helper:seekWidgetByName(root, "Text_204")
	local typeNumLabel = ccui.Helper:seekWidgetByName(root, "Text_3")
	local starNumLabel = ccui.Helper:seekWidgetByName(root, "Text_402")
	local shipPanel = ccui.Helper:seekWidgetByName(root, "Panel_3_role")
	if tonumber(self.types) == 1 then
		local userId = self.person.user_id
		nameLabel:setString(self.person.user_name)
		typeLabel:setString(_string_piece_info[303])
		local recommendFight = tonumber(self.person.user_fighting)
		if recommendFight >= 10000 then
			recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
		end
		typeNumLabel:setString(recommendFight)
		starNumLabel:setString(self.person.user_star_num)
		if self.num == 1 then
			ccui.Helper:seekWidgetByName(root, "Image_11_1"):setVisible(true)
		elseif self.num == 2 then
			ccui.Helper:seekWidgetByName(root, "Image_11_2"):setVisible(true)
		elseif self.num == 3 then
			ccui.Helper:seekWidgetByName(root, "Image_11_3"):setVisible(true)
		elseif self.num >= 4 then
			ccui.Helper:seekWidgetByName(root, "Image_530"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_578"):setString(self.num)
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. self.person.pic_index .. ".ExportJson")
			-- local cell = ccs.Armature:create("spirte_" .. self.person.pic_index)
			-- cell:getAnimation():playWithIndex(0)
			-- shipPanel:removeAllChildren(true)
			-- shipPanel:addChild(cell)
			-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
			-- -- cell:setPosition(cc.p(shipPanel:getContentSize().width/2, shipPanel:getContentSize().height/2))
			-- cell:setPosition(cc.p(shipPanel:getContentSize().width/2, 0))
						
			-- local temp_bust_index = self.person.pic_index
			-- shipPanel:removeAllChildren(true)
			-- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			-- if animationMode == 1 then
			-- 	app.load("client.battle.fight.FightEnum")
			-- 	sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			-- else
			-- 	draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
			-- end
		else
			local isHaveSpineAni = false
			if __lua_project_id == __lua_project_yugioh then
				local jsonFile = string.format("sprite/spirte_battle_card_%s.json", self.person.pic_index)
				if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
					isHaveSpineAni = true
					shipPanel:removeAllChildren(true)
			        local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", self.person.pic_index)
			        app.load("client.battle.fight.FightEnum")
			        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
			            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

			        spArmature:setPosition(cc.p(shipPanel:getContentSize().width/2, 0))
			        spArmature.animationNameList = spineAnimations
			        sp.initArmature(spArmature, true)
			        shipPanel:addChild(spArmature)
			    end
		    end
		    if isHaveSpineAni == false then
				shipPanel:setBackGroundImage(string.format(("images/face/big_head/big_head_%d.png"), tonumber(self.person.pic_index)))
			end
		end
		
		
	elseif tonumber(self.types) == 2 then
		local userId = self.person.user_id
		nameLabel:setString(self.person.user_name)
		-- typeLabel:setString(_string_piece_info[303])
		typeNumLabel:setString(self.person.user_level)
		starNumLabel:setString(self.person.user_star_num)
		if self.num == 1 then
			ccui.Helper:seekWidgetByName(root, "Image_11_1"):setVisible(true)
		elseif self.num == 2 then
			ccui.Helper:seekWidgetByName(root, "Image_11_2"):setVisible(true)
		elseif self.num == 3 then
			ccui.Helper:seekWidgetByName(root, "Image_11_3"):setVisible(true)
		elseif self.num >= 4 then
			ccui.Helper:seekWidgetByName(root, "Image_530"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_578"):setString(self.num)
		end
		
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. self.person.pic_index .. ".ExportJson")
			-- local cell = ccs.Armature:create("spirte_" .. self.person.pic_index)
			-- cell:getAnimation():playWithIndex(0)
			-- shipPanel:removeAllChildren(true)
			-- shipPanel:addChild(cell)
			-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
			-- -- cell:setPosition(cc.p(shipPanel:getContentSize().width/2, shipPanel:getContentSize().height/2))
			-- cell:setPosition(cc.p(shipPanel:getContentSize().width/2, 0))
			
			-- local temp_bust_index = self.person.pic_index
			-- shipPanel:removeAllChildren(true)
			-- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			-- if animationMode == 1 then
			-- 	app.load("client.battle.fight.FightEnum")
			-- 	sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			-- else
			-- 	draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))		
			-- end
		else
			local isHaveSpineAni = false
			if __lua_project_id == __lua_project_yugioh then
				local jsonFile = string.format("sprite/spirte_battle_card_%s.json", self.person.pic_index)
				if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
					isHaveSpineAni = true
					shipPanel:removeAllChildren(true)
			        local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", self.person.pic_index)
			        app.load("client.battle.fight.FightEnum")
			        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
			            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

			        spArmature:setPosition(cc.p(shipPanel:getContentSize().width/2, 0))
			        spArmature.animationNameList = spineAnimations
			        sp.initArmature(spArmature, true)
			        shipPanel:addChild(spArmature)
			    end
		    end
		    if isHaveSpineAni == false then
				shipPanel:setBackGroundImage(string.format(("images/face/big_head/big_head_%d.png"), tonumber(self.person.pic_index)))
			end
		end
	end
	
	
end
function FameHallHead:addHeroAnimaton( ... )

	local root = self.roots[1]
	local shipPanel = ccui.Helper:seekWidgetByName(root, "Panel_3_role")
	shipPanel:removeAllChildren(true)
	local temp_bust_index = _user_pic_index[self.person.pic_index]
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	Image_2:setVisible(true)
	app.load("client.battle.fight.FightEnum")
	sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	
end

function FameHallHead:onEnterTransitionFinish()
	local csbFameHallHead = csb.createNode("system/famous_general_role.csb")
	self:addChild(csbFameHallHead)
	local root = csbFameHallHead:getChildByName("root")
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
	else
		local action = csb.createTimeline("system/famous_general_role.csb")
	    csbFameHallHead:runAction(action)
		self.action = action
		action:play("Panel_3_role_dh", true)
	end
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:setVisible(false)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xin"), nil, 
	{
		terminal_name = "fame_hall_ranking_add_star", 
		terminal_state = 0,
		_id = self.person.user_id,
		_cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end


function FameHallHead:onExit()
	-- state_machine.remove("fame_hall_ranking_list")
end

function FameHallHead:init(person,types,num)
	self.person = person
	self.types = types
	self.num = num
end

function FameHallHead:createCell()
	local cell = FameHallHead:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
