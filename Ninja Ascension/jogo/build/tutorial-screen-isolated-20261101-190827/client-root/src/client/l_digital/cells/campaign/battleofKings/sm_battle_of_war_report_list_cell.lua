--------------------------------------------------------------------------------------------------------------
--  说明：王者之战战报列表控件
--------------------------------------------------------------------------------------------------------------
SmBattleOfWarReportListCell = class("SmBattleOfWarReportListCellClass", Window)
SmBattleOfWarReportListCell.__size = nil

--创建cell
local sm_battle_of_war_report_list_cell_terminal = {
    _name = "sm_battle_of_war_report_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmBattleOfWarReportListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_battle_of_war_report_list_cell_terminal)
state_machine.init()

function SmBattleOfWarReportListCell:ctor()
	self.super:ctor()
	self.roots = {}

    self.cd_time = 0

    self.isSettlement = false
	 -- Initialize sm_battle_of_war_report_list_cell state machine.
    local function init_sm_battle_of_war_report_list_cell_terminal()
        --
        -- local sm_trial_tower_Addition_select_back_activity_terminal = {
            -- _name = "sm_trial_tower_Addition_select_back_activity",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)          
                -- local cell = params._datas.cells
                -- if tonumber(_ED.three_kingdoms_view.current_max_stars) >= tonumber(cell.need) then
                    -- local Image_ygm = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_ygm")
                    -- Image_ygm:setVisible(true)
                    -- Image_ygm:setScale(5)
                    -- local function playOver()
                        -- state_machine.excute("addition_select_back_activity", 0, {cell.need,cell.info})
                    -- end
                    -- Image_ygm:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 1),cc.CallFunc:create(playOver)))
                    
                -- else
                    -- return
                -- end
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(sm_trial_tower_Addition_select_back_activity_terminal)
        state_machine.init()
    end 
    -- call func sm_battle_of_war_report_list_cell create state machine.
    init_sm_battle_of_war_report_list_cell_terminal()

end

function SmBattleOfWarReportListCell:updateDraw(isSettlement)
    local root = self.roots[1]
    local Text_zb = ccui.Helper:seekWidgetByName(root, "Text_zb")
    local text_data = zstring.split(self.datas, ",")
    local text_info = battle_of_kings_push_text[tonumber(text_data[2])]
    local info = string.gsub(text_info, "!x@", text_data[3])
    info = string.gsub(info, "!y@", text_data[4])
    if tonumber(text_data[1]) ~= 1 then
        info = string.gsub(info, "!z@", text_data[5])
    end
    text_info = info
    Text_zb:setString(text_info)

    Text_zb:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_zb:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_zb:getFontSize() * 6
    end
                
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))

    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    text_info, 
    cc.c3b(255, 255, 255),
    cc.c3b(255, 255, 255),
    0, 
    0, 
    Text_zb:getFontName(), 
    Text_zb:getFontSize(),
    chat_rich_text_color)

    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_zb:getContentSize().height)
    _richText2:setPositionX(0)
    Text_zb:addChild(_richText2)
    Text_zb:setString("")
end

function SmBattleOfWarReportListCell:onUpdate(dt)

end

function SmBattleOfWarReportListCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKings/battle_of_kings_tab_1_2_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmBattleOfWarReportListCell.__size == nil then
        SmBattleOfWarReportListCell.__size = root:getContentSize()
    end

	self:updateDraw(false)
end

function SmBattleOfWarReportListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmBattleOfWarReportListCell:clearUIInfo( ... )
    local root = self.roots[1]
    
end

function SmBattleOfWarReportListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmBattleOfWarReportListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_1_2_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmBattleOfWarReportListCell:init(params)
    self.index = params[1]
    self.datas = params[2]
	self:onInit()

    self:setContentSize(SmBattleOfWarReportListCell.__size)
    return self
end

function SmBattleOfWarReportListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_1_2_list.csb", self.roots[1])
end