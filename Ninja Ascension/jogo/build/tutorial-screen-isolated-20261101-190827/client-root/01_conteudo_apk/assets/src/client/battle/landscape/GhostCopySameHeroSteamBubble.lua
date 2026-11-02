GhostCopySameHeroSteamBubble = class("GhostCopySameHeroSteamBubbleClass", Window)
 
function GhostCopySameHeroSteamBubble:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

    local function init_ghost_copy_same_hero_steam_bubble_terminal()
        local ghost_copy_same_hero_steam_bubble_close_terminal = {
            _name = "ghost_copy_same_hero_steam_bubble_close", 
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(ghost_copy_same_hero_steam_bubble_close_terminal)
        state_machine.init()
    end

    init_ghost_copy_same_hero_steam_bubble_terminal()
end

function GhostCopySameHeroSteamBubble:init(params)
    self:onInit()
    return self
end

function GhostCopySameHeroSteamBubble:onInit( ... )
    local csbAction = csb.createNode("campaign/maoxian_batle_duihua_t.csb")
    self:addChild(csbAction)
    local Text_battle_duihua = ccui.Helper:seekWidgetByName(csbAction:getChildByName("root"), "Text_battle_duihua")
    local test_list = zstring.split(dms.string(dms["play_config"], 74, play_config.param), ",")
    local index = math.random(1, #test_list)--随机开始
    local word_info = dms.element(dms["word_mould"], tonumber(test_list[index]))
    -- Text_battle_duihua:setString("哈哈哈，你真笨！")
    Text_battle_duihua:setString(word_info[3])
end

function GhostCopySameHeroSteamBubble:onEnterTransitionFinish()

end

function GhostCopySameHeroSteamBubble:onExit()

end
