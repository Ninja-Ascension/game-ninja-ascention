-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗胜利
-------------------------------------------------------------------------------------------------------
AdventureBattleVictory = class("AdventureBattleVictoryClass", Window)
    
function AdventureBattleVictory:ctor()
    self.super:ctor()
    self.roots = {}
    self.startAnimation = nil -- 战斗开始动画
    self.continueAnimation = nil -- 持续动画

    -- Initialize adventure battle victory state machine.
    local function init_adventure_battle_victory_terminal()
        state_machine.init()
    end
    
    -- call func init adventure battle victory state machine.
    init_adventure_battle_victory_terminal()
end

function AdventureBattleVictory:init()
	return self
end

function AdventureBattleVictory:gotoOriginScene()
    fwin:close(self)
    fwin:close(fwin:find("AdventureBattleClass"))

    cacher.removeAllTextures()
    fwin:reset(nil)
    if _ED.adventure_create_character == true then 
    	_ED.adventure_create_character = false
    	fwin:open(Menu:new():init(true), fwin._taskbar)
	else
    	fwin:open(Menu:new(), fwin._taskbar)	
    end
    
	if zstring.tonumber(_ED.battleData.battle_init_type) == 12 then --排位赛
		state_machine.excute("menu_manager", 0, 
			{
				_datas = {
					terminal_name = "menu_manager",     
	           		next_terminal_name = "menu_adventure_arena", 
	            	current_button_name = "Button_jingjichang",
	            	but_image = "Image_beijing_1",
	            	animation_name = "Panel_jingjichang",         
	            	terminal_state = 0, 
					openId = 52,
	            	isPressedActionEnabled = false
				}
			}
		)
		app.load("client.adventure.campaign.arena.AdventureArenaRankedGame")
		fwin:open(AdventureArenaRankedGame:new():init(true), fwin._view)
	elseif 	zstring.tonumber(_ED.battleData.battle_init_type) == 11 then --竞技场
		state_machine.excute("menu_manager", 0, 
			{
				_datas = {
					terminal_name = "menu_manager",     
	           		next_terminal_name = "menu_adventure_arena", 
	            	current_button_name = "Button_jingjichang",
	            	but_image = "Image_beijing_1",
	            	animation_name = "Panel_jingjichang",         
	            	terminal_state = 0, 
					openId = 52,
	            	isPressedActionEnabled = false
				}
			}
		)
		app.load("client.adventure.campaign.arena.AdventureArena")
		fwin:open(AdventureArena:new():init(true), fwin._view)

	elseif zstring.tonumber(_ED.battleData.battle_init_type) == 1 or zstring.tonumber(_ED.battleData.battle_init_type) == 16 then --矿山	
		state_machine.excute("menu_manager", 0, 
			{
				_datas = {
					terminal_name = "menu_manager",     
		            next_terminal_name = "menu_adventure_mining", 
		            -- terminal_name = "menu_adventure_mining",   
		            current_button_name = "Button_wakuang",
		            but_image = "Image_beijing_3",
		            animation_name = "Panel_wakuang",         
		            terminal_state = 0, 
					openId = 51,
		            isPressedActionEnabled = false
				}
			}
		)
		-- app.load("client.adventure.campaign.mine.AdventureMineManager")
		-- fwin:open(AdventureMineManager:new():init(), fwin._view)	
		state_machine.excute("adventure_mine_manager_open",0,false)
	elseif zstring.tonumber(_ED.battleData.battle_init_type) == 13 then --好友
			state_machine.excute("menu_manager", 0, 
			{
				_datas = {
					terminal_name = "menu_manager",     
		            next_terminal_name = "menu_adventure_avg", 
		            -- terminal_name = "menu_adventure_avg",  
		            current_button_name = "Button_maoxian",
		            but_image = "Image_beijing_4",
		            animation_name = "Panel_maoxian",         
		            terminal_state = 0, 
		            isPressedActionEnabled = false
				}
			}
		)

			  -- 跳转到好友界面
			state_machine.excute("home_adventure_friends", 0, 0)
	elseif zstring.tonumber(_ED.battleData.battle_init_type) == 15 then --排位赛
		state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager",     
		           		next_terminal_name = "menu_adventure_arena", 
		            	current_button_name = "Button_jingjichang",
		            	but_image = "Image_beijing_1",
		            	animation_name = "Panel_jingjichang",         
		            	terminal_state = 0, 
						openId = 52,
		            	isPressedActionEnabled = false
					}
				}
			)
		app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftList")
		fwin:open(AdventureArenaWarcraftList:new():init(), fwin._windows)
	else
		state_machine.excute("menu_manager", 0, 
			{
				_datas = {
					terminal_name = "menu_manager",     
		            next_terminal_name = "menu_adventure_avg", 
		            -- terminal_name = "menu_adventure_avg",  
		            current_button_name = "Button_maoxian",
		            but_image = "Image_beijing_4",
		            animation_name = "Panel_maoxian",         
		            terminal_state = 0, 
		            isPressedActionEnabled = false
					-- terminal_name = "menu_manager", 	
					-- next_terminal_name = "menu_show_home_page", 
					-- current_button_name = "Button_daditu",
					-- but_image = "Image_daditu", 		
					-- terminal_state = 0, 
					-- isPressedActionEnabled = true
				}
			}
		)
	end
end

function AdventureBattleVictory:onEnterTransitionFinish()
	local csbAdventureBattleVictory = csb.createNode("battle/battle_victory.csb")
    local root = csbAdventureBattleVictory:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleVictory)
    cc.SimpleAudioEngine:getInstance():stopMusic()
    local function backPlotScene(sender, eventType)             --点击确定
        if eventType == ccui.TouchEventType.ended then
            self:gotoOriginScene()
        elseif eventType == ccui.TouchEventType.began then
            playEffect(formatMusicFile("button", 1))        --加入按钮音效
        end
    end
    pushEffect(formatMusicFile("background", 11))
    local panel2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	panel2:addTouchEventListener(backPlotScene)
    self.startAnimation = panel2:getChildByName("ArmatureNode_2")
    self.continueAnimation = panel2:getChildByName("ArmatureNode_3")
    self.continueAnimation:setVisible(false)
    draw.initArmature(self.startAnimation, nil, -1, 0, 1)
    csb.animationChangeToAction(self.startAnimation, 0, 0, false)

    draw.initArmature(self.continueAnimation, nil, -1, 0, 1)
    csb.animationChangeToAction(self.continueAnimation, 0, 0, false)
    self.startAnimation._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            armatureBack:setVisible(false)
            self.continueAnimation:setVisible(true)
        end
    end   
end

function AdventureBattleVictory:onExit()

end