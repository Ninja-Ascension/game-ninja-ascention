-- ------------------------------------------------------------------------------------------------------------
--  阵营对决奖励cell
-- ------------------------------------------------------------------------------------------------------------
CampPkEventTextCell = class("CampPkEventTextCellClass", Window)
CampPkEventTextCell.__size = nil

--创建cell
local camp_pk_event_text_cell_create_terminal = {
    _name = "camp_pk_event_text_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CampPkEventTextCell:new()
        local index = params[1]
        local info = params[2]
        local params_str = params[3]
        local event_id = params[4]
        cell:init(index, info, params_str, event_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(camp_pk_event_text_cell_create_terminal)
state_machine.init()

function CampPkEventTextCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = ""
    self._params_str = ""
    self._event_id = 0

    local function init_camp_pk_event_text_cell_terminal()
        local camp_pk_event_text_cell_update_info_terminal = {
            _name = "camp_pk_event_text_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index 
                cell._info = params.info
                cell._params_str = params.params_str
                cell._event_id = params.event_id
                if cell._info ~= "" and tonumber(cell._event_id) > 0 then
                    cell:reload()
                    cell:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_event_text_cell_update_info_terminal)
        state_machine.init()
    end
    init_camp_pk_event_text_cell_terminal()
end

function CampPkEventTextCell:updateDraw()
    local root = self.roots[1]
    local Text_camp_pk_battle_p = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_p")
    Text_camp_pk_battle_p:removeAllChildren(true)

    local parmas = zstring.split(self._params_str, ",")
    local info_str = self._info
    local replace_str = {"!x@", "!y@", "!z@"}
    for k, v in pairs(parmas) do
        local temp_str = v
        if (k == 2 and tonumber(self._event_id) == 12)
            or (k == 1 and tonumber(self._event_id) == 14)
            then
            local mould_id = tonumber(temp_str)
            temp_str = dms.string(dms["camp_duel_mould"], mould_id, camp_duel_mould.name)
        end
        info_str = string.gsub(info_str, replace_str[k], temp_str)
    end

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setAnchorPoint(cc.p(0.5, 0.5))
    _richText:setContentSize(cc.size(Text_camp_pk_battle_p:getContentSize().width,20))
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        info_str, 
        cc.c3b(189, 206, 224),
        cc.c3b(189, 206, 224),
        0, 
        0, 
        config_res.font.font_name, 
        18,
        chat_rich_text_color)
    _richText:setPosition(cc.p(Text_camp_pk_battle_p:getContentSize().width/2,Text_camp_pk_battle_p:getContentSize().height/2))
    self:addChild(_richText)
end

function CampPkEventTextCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.camp_pk_battle_cell_1_text, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CampPkEventTextCell.__size == nil then
        CampPkEventTextCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function CampPkEventTextCell:onEnterTransitionFinish()

end

function CampPkEventTextCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CampPkEventTextCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.camp_pk_battle_cell_1_text, root)
    root:removeFromParent(true)
    self.roots = {}
end

function CampPkEventTextCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_camp_pk_battle_p = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_p")
    if Text_camp_pk_battle_p ~= nil then
        Text_camp_pk_battle_p:removeAllChildren(true)
    end
end

function CampPkEventTextCell:init(index, info, params_str, event_id)
    self._index = index 
    self._info = info
    self._params_str = params_str
    self._event_id = event_id
    -- if index ~= nil and index <= 5 then
        self:onInit()
    -- end
    self:setContentSize(CampPkEventTextCell.__size)
    return self
end

function CampPkEventTextCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.camp_pk_battle_cell_1_text, self.roots[1])
    local root = self.roots[1]
    root:removeFromParent(true)
end

