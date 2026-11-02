HeroPiecePreviewCell = class("HeroPiecePreviewCellClass", Window)
HeroPiecePreviewCell.__size = nil

local hero_piece_preview_cell_create_terminal = {
    _name = "hero_piece_preview_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HeroPiecePreviewCell:new():init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_piece_preview_cell_create_terminal)
state_machine.init()

function HeroPiecePreviewCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_info = {}
end

function HeroPiecePreviewCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeAllChildren(true)
    for k,v in pairs(self._activity_info) do
        if v ~= nil then
            local reward_tab = zstring.split(v,",")
            local _item_value = tonumber(reward_tab[3])
            local _prop_type = tonumber(reward_tab[2])
            local _prop_item = tonumber(reward_tab[1])
            local data = 
            {
                item_value = _item_value,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }
            local cell = state_machine.excute("hero_piece_preview_icon_cell_create",0,{data})
            cell:setAnchorPoint(cc.p(0,1))
            Panel_icon:addChild(cell)
            cell:setPosition(cc.p((k - 1)*(cell:getContentSize().width), 0))
        end
    end
end

function HeroPiecePreviewCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.recruit.hero_piece_preview_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if HeroPiecePreviewCell.__size == nil then
        HeroPiecePreviewCell.__size = root:getContentSize()
    end

    self:setContentSize(HeroPiecePreviewCell.__size)
    if self._activity_info ~= nil then
        self:onUpdateDraw()
    end
end

function HeroPiecePreviewCell:init(params)
    if params == nil then
        self._activity_info = nil
        self:onInit()
    else
        self._activity_info = params[1]
        if params[2] ~= nil and params[2] < 4 then
           self:onInit()
        end
        self:setContentSize(HeroPiecePreviewCell.__size)
    end
    return self
end

function HeroPiecePreviewCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function HeroPiecePreviewCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.recruit.hero_piece_preview_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function HeroPiecePreviewCell:onExit()
    local Panel_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_icon")
    if Panel_icon ~= nil then
        Panel_icon:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.recruit.hero_piece_preview_cell, self.roots[1])
end