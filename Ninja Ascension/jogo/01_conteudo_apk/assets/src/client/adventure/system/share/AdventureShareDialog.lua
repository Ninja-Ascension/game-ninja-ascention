-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏分享
-------------------------------------------------------------------------------------------------------

--打开分享界面
local adventure_open_share_dialog_terminal = {
    _name = "adventure_open_share_dialog",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then 
            if zstring.tonumber("".._ED.server_review) == 0 then 
                fwin:open(AdventureShareDialog:new():init(params), fwin._ui)      
            end 
        end
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_open_share_dialog_terminal)
state_machine.init()

AdventureShareDialog = class("AdventureShareDialogClass", Window)
    
function AdventureShareDialog:ctor()
    self.super:ctor()
    self.roots = {}
    self.shareText = nil

    -- Initialize adventure mercenary equipment fate state machine.
    local function init_adventure_share_terminal()
        --点击去分享
        local adventure_share_to_center_terminal = {
            _name = "adventure_share_to_center",
            _init = function (terminal)
                app.load("client.adventure.system.share.AdventureShareCenter")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                state_machine.excute("adventure_sharecenter_to_share",0,instance.shareText)
                fwin:close(fwin:find("AdventureShareDialogClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_share_to_center_terminal) 
        state_machine.init()
    end
    
    -- call func init adventure mercenary equipment fate state machine.
    init_adventure_share_terminal()
end

function AdventureShareDialog:init(shareText)
    self.shareText = shareText
    return self
end

function AdventureShareDialog:onEnterTransitionFinish()
    local csbAdventureprompt = csb.createNode("utils/prompt_share.csb")
    local root = csbAdventureprompt:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureprompt)
    ccui.Helper:seekWidgetByName(root, "Text_word_s"):setString(self.shareText)

    --添加评论
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"),       nil, 
    {
        terminal_name = "adventure_share_to_center",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureShareDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureShareDialog:onExit()
    state_machine.remove("adventure_share_to_center")
end


