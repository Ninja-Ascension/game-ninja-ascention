-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军来袭
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyNpcArrival = class("BetrayArmyNpcArrivalClass", Window)
    
function BetrayArmyNpcArrival:ctor()
    self.super:ctor()
    self.roots = {}
	self.rebelArmyMouldId = nil
    -- Initialize BetrayArmyNpcArrival page state machine.
    local function init_world_boss_terminal()
		
		local betray_army_npc_arrival_button_close_terminal = {
            _name = "betray_army_npc_arrival_button_close",
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
		local betray_army_npc_arrival_button_go_to_attack_terminal = {
            _name = "betray_army_npc_arrival_button_go_to_attack",
            _init = function (terminal) 
				app.load("client.campaign.worldboss.WorldBoss")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function recruitCallBack(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:removeAll()
						fwin:open(WorldBoss:new(), fwin._view)	
						app.load("client.home.Menu")
						fwin:open(Menu:new(), fwin._taskbar)
					end
				end
				NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(betray_army_npc_arrival_button_close_terminal)
		state_machine.add(betray_army_npc_arrival_button_go_to_attack_terminal)
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end
function BetrayArmyNpcArrival:onUpdateDraw()
	local root = self.roots[1]
	local TextName = ccui.Helper:seekWidgetByName(root, "Text_2")
	local PanelNpc = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local PanelText = ccui.Helper:seekWidgetByName(root, "Panel_1145")

	--npc名字和品质
	local betrayArmyId = zstring.tonumber(self.rebelArmyMouldId)	--叛军模板
	
	local npcName = dms.string(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.army_name)
	local quality = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.army_quality)
	local color = tipStringInfo_quality_color_Type[quality]
	local npcNameColor = cc.c4b(color[1],color[2],color[3],255) -- cc.c4b(255,0,0,255)	
	local npcLv = self.npcLevel 
		
	--npc头像索引
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		npcHeadPic = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.aram_pic)
	else
		npcHeadPic = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.aram_pic) - 1000
	end
	
	local strOne = _string_piece_info[337]
	local strName = npcName
	local strTwo = ""
	if verifySupportLanguage(_lua_release_language_en) == true then
		strTwo = "(".._string_piece_info[6]..npcLv..")".._string_piece_info[338]
	else
		strTwo = "("..npcLv.._string_piece_info[6]..")".._string_piece_info[338]
	end
	
	local strColor = cc.c3b(tipStringInfo_quality_color_Type[1][1], tipStringInfo_quality_color_Type[1][2], tipStringInfo_quality_color_Type[1][3])
	local strColorNpc = npcNameColor
	
	
	local mRoot = ccui.RichText:create()
	local fontSize = 20
	mRoot:ignoreContentAdaptWithSize(false)
	
	
	local reOne = ccui.RichElementText:create(1, strColor, 255, strOne, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(reOne)
	
	
	local reTwo = ccui.RichElementText:create(1, strColorNpc, 255, strName, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(reTwo)
	
	local reThree = ccui.RichElementText:create(1, strColor, 255, strTwo, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(reThree)
	
	-- width,tonumber(cell:getContentSize().height
	mRoot:setContentSize(cc.size(PanelText:getContentSize().width, PanelText:getContentSize().height))
	mRoot:setPosition(cc.p(PanelText:getContentSize().width *0.5, PanelText:getContentSize().height *0.5))
	PanelText:addChild(mRoot)
	

	
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
			local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                shipSpine:setScaleX(-1)
            end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end
	else
	
		local npcIcon = string.format("images/face/big_head/big_head_%d.png", npcHeadPic)
		PanelNpc:setBackGroundImage(npcIcon)
	end
	
end


function BetrayArmyNpcArrival:onEnterTransitionFinish()
	
	local csbBetrayArmyNpcArrival = csb.createNode("campaign/WorldBoss/worldBoss_encounter.csb")
	self:addChild(csbBetrayArmyNpcArrival)
	local root = csbBetrayArmyNpcArrival:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
	--稍后攻打
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_1"), nil, 
	{
		terminal_name = "betray_army_npc_arrival_button_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	--立即前往
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_2"), nil, 
	{
		terminal_name = "betray_army_npc_arrival_button_go_to_attack", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
end


function BetrayArmyNpcArrival:init()
	self.rebelArmyMouldId 		=  _ED.rebel_army_mould_id 
	self.npcLevel	=  _ED.rebel_aram_level
	
	_ED.rebel_army_mould_id = nil 
	_ED.rebel_aram_level  	= nil 
end
function BetrayArmyNpcArrival:createCell()
	local cell = BetrayArmyNpcArrival:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function BetrayArmyNpcArrival:onExit()

end
