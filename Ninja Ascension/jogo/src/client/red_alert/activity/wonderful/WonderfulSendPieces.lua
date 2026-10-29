-----------------------------
-- 十连抽送碎片活动(活动类型38)
-----------------------------
WonderfulSendPieces = class("WonderfulSendPiecesClass", Window)

local wonderful_send_pieces_window_open_terminal = {
    _name = "wonderful_send_pieces_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if nil == fwin:find("WonderfulSendPiecesClass") then
            local panel = WonderfulSendPieces:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_send_pieces_window_open_terminal)
state_machine.init()

function WonderfulSendPieces:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_posY = 0
    --load lua file
    app.load("client.red_alert.cells.recruit.hero_piece_preview_cell")
    app.load("client.red_alert.cells.recruit.hero_piece_preview_icon_cell")
    -- Initialize wonderful_send_pieces state machine.
    local function init_wonderful_send_pieces_terminal()

            -- 刷新
            local wonderful_send_pieces_goto_hero_recruit_terminal = {
                _name = "wonderful_send_pieces_goto_hero_recruit",
                _init = function (terminal) 
                    
                end,
                _inited = false,
                _instance = self,
                _state = 0,
                _invoke = function(terminal, instance, params) 
                    state_machine.excute("wonderful_window_close",0,"")
                    state_machine.excute("hero_recruit_window_open",0,"")
                    return true
                end,
                _terminal = nil,
                _terminals = nil
            }

            state_machine.add(wonderful_send_pieces_goto_hero_recruit_terminal)    
        state_machine.init()
    end
    
    -- call func init sign_in state machine.
    init_wonderful_send_pieces_terminal()
end

function WonderfulSendPieces:onUpdateDrawListview()
    local root = self.roots[1]
    -- 活动时间
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    Text_time:setString(_ED.activity_info["38"].activity_dec)

    self._list_view = ccui.Helper:seekWidgetByName(root,"ScrollView_confirm")
    self._list_view:removeAllChildren(true)
    -- 奖励绘制
    local line_max_count = 5
    local max_line = 0
    local reward_id = _ED.activity_info["38"].activity_data[1][1].achieve_reward
    local reward_items = dms.string(dms["scene_reward"],reward_id,scene_reward.reward_items)
    reward_items = zstring.split(reward_items,"|")
    if #reward_items % line_max_count == 0 then
        max_line = #reward_items / line_max_count
    else
        max_line = math.floor(#reward_items / line_max_count) + 1
    end
    local panel_cell = state_machine.excute("hero_piece_preview_cell_create", 0, nil)
    local total_height = panel_cell:getContentSize().height * max_line
    local current_height = total_height

    local cacher_index = 0
    local index = 0
    for i,list in pairs(reward_items) do
        if index == 5 then
            index = 0
        end
        if index == 0 then
            local result = {reward_items[i], reward_items[i+1], reward_items[i+2], reward_items[i+3], reward_items[i+4]}
            local panel = state_machine.excute("hero_piece_preview_cell_create", 0, {result, cacher_index})
            self._list_view:addChild(panel)
            panel:setPosition(cc.p(0, current_height))
            current_height = current_height - panel:getContentSize().height - 5
            cacher_index = cacher_index + 1
        end
        index = index + 1
    end

    self._list_view:getInnerContainer():setContentSize(cc.size(
        self._list_view:getContentSize().width, total_height))
    self._list_view:jumpToTop()

    self._list_view_posY = self._list_view:getInnerContainer():getPositionY()
end

function WonderfulSendPieces:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self._list_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + 150 * 2 < 0 or tempY > 150 + 150 * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function WonderfulSendPieces:onEnterTransitionFinish()

end

function WonderfulSendPieces:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_send_pieces)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 前往招募界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "wonderful_send_pieces_goto_hero_recruit",        
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDrawListview()
end

function WonderfulSendPieces:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    _ED.send_pieces_activity_tip = 0
    return self
end

function WonderfulSendPieces:onExit()
    state_machine.remove("wonderful_send_pieces_goto_hero_recruit")
end
