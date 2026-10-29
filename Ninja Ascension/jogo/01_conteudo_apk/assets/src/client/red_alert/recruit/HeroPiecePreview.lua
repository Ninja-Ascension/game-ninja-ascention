-- ----------------------------------------------------------------------------------------------------
-- 十连抽送碎片
-------------------------------------------------------------------------------------------------------
HeroPiecePreview = class("HeroPiecePreviewClass", Window)

--打开碎片预览
local hero_piece_preview_window_open_terminal = {
    _name = "hero_piece_preview_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("HeroPiecePreviewClass") then
            fwin:open(HeroPiecePreview:new():init(), fwin._view)
        else
            state_machine.excute("hero_piece_preview_window_show", 0, "")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_piece_preview_window_close_terminal = {
    _name = "hero_piece_preview_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroPiecePreviewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(hero_piece_preview_window_open_terminal)
state_machine.add(hero_piece_preview_window_close_terminal)
state_machine.init()
function HeroPiecePreview:ctor()
    self.super:ctor()
    self.roots = {}
    self.action = nil
    
    self._list_view = nil
    self._list_view_posY = 0

    app.load("client.red_alert.cells.recruit.hero_piece_preview_cell")
    app.load("client.red_alert.cells.recruit.hero_piece_preview_icon_cell")

    local function init_hero_piece_preview_terminal()

        --显示所有
        local hero_piece_preview_window_show_terminal = {
            _name = "hero_piece_preview_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local hero_piece_preview_window_hide_terminal = {
            _name = "hero_piece_preview_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_piece_preview_window_show_terminal)
        state_machine.add(hero_piece_preview_window_hide_terminal)
        state_machine.init()
    end
    
    init_hero_piece_preview_terminal()
end

function HeroPiecePreview:onShow()
   self:setVisible(true)
end

function HeroPiecePreview:onHide()
   self:setVisible(false)
end

function HeroPiecePreview:onEnterTransitionFinish()

end

function HeroPiecePreview:onUpdateDraw()
    local root = self.roots[1]
    self._list_view = ccui.Helper:seekWidgetByName(root,"ScrollView_hero_piece_preview")
    self._list_view:removeAllChildren(true)

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

function HeroPiecePreview:onUpdate(dt)
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

function HeroPiecePreview:onInit()
    local csbItem = csb.createNode(config_csb.recruit.hero_piece_preview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "hero_piece_preview_window_close",        
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function HeroPiecePreview:init()
    self:onInit()
    return self
end

function HeroPiecePreview:onExit()
    state_machine.remove("hero_piece_preview_window_show")
    state_machine.remove("hero_piece_preview_window_hide")
end