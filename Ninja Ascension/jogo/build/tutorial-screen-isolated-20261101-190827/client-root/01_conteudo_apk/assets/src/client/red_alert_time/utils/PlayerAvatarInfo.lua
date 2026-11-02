--------------------------------------------------------------------------------------------------------------
--  说明：称号详情
--------------------------------------------------------------------------------------------------------------
PlayerAvatarInfo = class("PlayerAvatarInfoClass", Window)

--打开界面
local player_avatar_info_open_terminal = {
    _name = "player_avatar_info_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("PlayerAvatarInfoClass") == nil then
            fwin:open(PlayerAvatarInfo:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local player_avatar_info_close_terminal = {
    _name = "player_avatar_info_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerAvatarInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_avatar_info_open_terminal)
state_machine.add(player_avatar_info_close_terminal)
state_machine.init()

function PlayerAvatarInfo:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_player_avatar_info_terminal()
        
    end
    init_player_avatar_info_terminal()
end

--初始化
function PlayerAvatarInfo:onInit(params)
    local csbItem = csb.createNode(config_csb.utils.player_legion_title)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_title_close"), nil, 
    {
        terminal_name = "player_avatar_info_close",
        terminal_state = 0, 
        touch_black = true,
        close_state = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_legion_title_sure"), nil, 
    {
        terminal_name = "player_avatar_info_close",
        terminal_state = 0, 
        touch_black = true,
        close_state = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "player_avatar_info_close",
        terminal_state = 0, 
    }, nil, 3)

    local title_data = dms.element(dms["avatar_head"], params)
    local quality = dms.atoi(title_data, avatar_head.quality)

    local achievement_id = dms.atoi(title_data, avatar_head.condition)
    local title_name = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_name)
    local infor = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_dec)

    ccui.Helper:seekWidgetByName(root,"Text_player_legion_title_name"):setString(title_name)
    ccui.Helper:seekWidgetByName(root,"Text_player_legion_title_name"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    ccui.Helper:seekWidgetByName(root,"Text_player_legion_title_infor"):setString(infor)
end

function PlayerAvatarInfo:onEnterTransitionFinish()

end

function PlayerAvatarInfo:init(params)
    self:onInit(params)
    return self
end

function PlayerAvatarInfo:onExit()
end