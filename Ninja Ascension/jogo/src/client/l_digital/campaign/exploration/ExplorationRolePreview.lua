-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
ExplorationPokemonPreview = class("ExplorationPokemonPreviewClass", Window)

local exploration_pokemon_preview_window_open_terminal = {
    _name = "exploration_pokemon_preview_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationPokemonPreviewClass") == nil then
            fwin:open(ExplorationPokemonPreview:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_pokemon_preview_window_close_terminal = {
    _name = "exploration_pokemon_preview_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationPokemonPreviewClass") then
            fwin:close(fwin:find("ExplorationPokemonPreviewClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_pokemon_preview_window_open_terminal)
state_machine.add(exploration_pokemon_preview_window_close_terminal)
state_machine.init()

function ExplorationPokemonPreview:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.campaign.exploration.ExplorationRolePreviewCell")

    local function init_exploration_pokemon_preview_terminal()
        local exploration_pokemon_preview_update_terminal = {
            _name = "exploration_pokemon_preview_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params
                instance:onUpdateDraw(_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_pokemon_preview_type_terminal)
        state_machine.add(exploration_pokemon_preview_update_terminal)
        state_machine.init()
    end
    
    init_exploration_pokemon_preview_terminal()
end

function ExplorationPokemonPreview:init(params)
    return self
end

function ExplorationPokemonPreview:onUpdate(dt)

end

function ExplorationPokemonPreview:onUpdateDraw()
    local root = self.roots[1]
    local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
    local params = dms.searchs(dms["role_explore_catch"], 2, mapId)
    local max_num = table.nums(params)
    
    local ScrollView_41 = ccui.Helper:seekWidgetByName(root, "ScrollView_role_head")
    local panel = ScrollView_41:getInnerContainer()
    panel:setContentSize(ScrollView_41:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/4
    local Hlindex = 0
    local m_number = max_num
    local cellHeight = 0
    local cellWidth = 0
    local oneCellHeight = 247
    index = 0
    cellHeight = math.ceil(m_number/4) *oneCellHeight
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_41:getContentSize().width, sHeight)
    ScrollView_41:jumpToTop()
    for i, info in ipairs(params) do
        index = index + 1
        local data = {}
        data.mould_id = info[3]
        data.tag = tonumber(info[7]) == 1 and 1 or -1
        data.order = tonumber(info[8])
        local cell = state_machine.excute("exploration_pokemon_preview_cell_create",0,{index, data, 13})
        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index - 1)%4 == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - oneCellHeight * Hlindex
        end
        if index <= 4 then
            tHeight = sHeight - oneCellHeight
        end

        cell:setPosition(cc.p(tWidth, tHeight + 10))
    end
end

function ExplorationPokemonPreview:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_pokemon_preview.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "exploration_pokemon_preview_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function ExplorationPokemonPreview:onExit()

end
