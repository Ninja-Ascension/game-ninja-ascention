 -- ----------------------------------------------------------------------------------------------------
-- 说明：游戏设置
-------------------------------------------------------------------------------------------------------
AdventureSet = class("AdventureSetClass", Window)
    
function AdventureSet:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure set state machine.
    local function init_adventure_set_terminal()
        -- 设置音乐
        local adventure_set_music_terminal = {
            _name = "adventure_set_music",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if isBgmOpen() then
                    muteBgm()
                else
                    openBgm()
                end
                instance:onUpdateDraw()

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 设置音效
        local adventure_set_sound_terminal = {
            _name = "adventure_set_sound",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if iscurrentBgm() then
                    muteSoundEffect()
                else
                    openSoundEffect()
                end
                instance:onUpdateDraw()

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 登出
        local adventure_set_logout_terminal = {
            _name = "adventure_set_logout",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					handlePlatformRequest(0, LOGOUT, "")
				else
					local platformloginInfo = {
						platform_id="",
						register_type="",
						platform_account="",
						nickname="",		
						password="",
						is_registered = false
					}
					_ED.user_platform = {}
					_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
					_ED.default_user = platformloginInfo.platform_account
					fwin:removeAll()
					fwin:reset(nil)
					fwin:open(Login:new(), fwin._view)
					fwin:close(fwin:find("ConnectingViewClass"))
					_ED.m_is_games = false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 开发者名单
        local adventure_set_show_developers_terminal = {
            _name = "adventure_set_show_developers",
            _init = function (terminal)
                app.load("client.adventure.system.set.AdventureDeveloperInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureDeveloperInfo:new(), fwin._view)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        state_machine.add(adventure_set_music_terminal)
        state_machine.add(adventure_set_sound_terminal)
        state_machine.add(adventure_set_logout_terminal)
        state_machine.add(adventure_set_show_developers_terminal)

        state_machine.init()
    end
    
    -- call func init adventure set state machine.
    init_adventure_set_terminal()
end

function AdventureSet:init()
	return self
end

function AdventureSet:onUpdateDraw()
    local root = self.roots[1]

    local musicButton = ccui.Helper:seekWidgetByName(root, "Button_music")
    local musicopenText = musicButton:getChildByName("Text_open")
    local musiccloseText = musicButton:getChildByName("Text_close")
    local musiccloseImage = musicButton:getChildByName("Image_5")
    if isBgmOpen() then
        musicopenText:setVisible(true)
        musiccloseText:setVisible(false)
        musiccloseImage:setVisible(false)
    else
        musicopenText:setVisible(false)
        musiccloseText:setVisible(true)
        musiccloseImage:setVisible(true)
    end

    local soundButton = ccui.Helper:seekWidgetByName(root, "Button_sound")
    local soundopenText = soundButton:getChildByName("Text_open")
    local soundcloseText = soundButton:getChildByName("Text_close")
    local soundcloseImage = soundButton:getChildByName("Image_5")
    if iscurrentBgm() then
        soundopenText:setVisible(true)
        soundcloseText:setVisible(false)
        soundcloseImage:setVisible(false)
    else
        soundopenText:setVisible(false)
        soundcloseText:setVisible(true)
        soundcloseImage:setVisible(true)
    end
end

function AdventureSet:onEnterTransitionFinish()
    local csbAdventureSet = csb.createNode("system/game_setting.csb")
    local root = csbAdventureSet:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureSet)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
		func_string = [[fwin:close(fwin:find("AdventureSetClass"))]],       
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 音乐开关
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_music"),       nil, 
    {
        terminal_name = "adventure_set_music",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 音效开关
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sound"),       nil, 
    {
        terminal_name = "adventure_set_sound",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    -- local exitButton = ccui.Helper:seekWidgetByName(root, "Button_exit")
    -- if zstring.tonumber(_game_platform_version_type)  == 4 then 
    --     exitButton:setVisible(false)
    -- else
    --     exitButton:setVisible(true)
    -- end
    -- 登出系统
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exit"),       nil, 
    {
        terminal_name = "adventure_set_logout",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 开发者
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_develop"),       nil, 
    {
        terminal_name = "adventure_set_show_developers",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function AdventureSet:onExit()
    state_machine.remove("adventure_set_music")
    state_machine.remove("adventure_set_sound")
    state_machine.remove("adventure_set_logout")
    state_machine.remove("adventure_set_show_developers")
end