--------------------------------------------------------------------------------------------------------------
--  说明：王者之战战报列表控件
--------------------------------------------------------------------------------------------------------------
SmCrossServerBattleOfWarReportListCell = class("SmCrossServerBattleOfWarReportListCellClass", Window)
SmCrossServerBattleOfWarReportListCell.__size = nil

--创建cell
local sm_cross_server_battle_of_war_report_list_cell_terminal = {
    _name = "sm_cross_server_battle_of_war_report_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCrossServerBattleOfWarReportListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_cross_server_battle_of_war_report_list_cell_terminal)
state_machine.init()

function SmCrossServerBattleOfWarReportListCell:ctor()
	self.super:ctor()
	self.roots = {}

    self.cd_time = 0

    self.isSettlement = false
	 -- Initialize sm_cross_server_battle_of_war_report_list_cell state machine.
    local function init_sm_cross_server_battle_of_war_report_list_cell_terminal()
        --
        -- local sm_cross_server_trial_tower_Addition_select_back_activity_terminal = {
            -- _name = "sm_cross_server_trial_tower_Addition_select_back_activity",
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

        -- state_machine.add(sm_cross_server_trial_tower_Addition_select_back_activity_terminal)
        state_machine.init()
    end 
    -- call func sm_cross_server_battle_of_war_report_list_cell create state machine.
    init_sm_cross_server_battle_of_war_report_list_cell_terminal()

end

function SmCrossServerBattleOfWarReportListCell:updateDraw(isSettlement)
    local root = self.roots[1]
    local Text_zb = ccui.Helper:seekWidgetByName(root, "Text_zb")
    local text_info = battle_of_kings_push_text[tonumber(self.datas.describe)]
    local data_winner = json.decode(self.datas.winner)
    local data_loser = json.decode(self.datas.loser)
    local info = string.gsub(text_info, "!x@", data_loser.nickName)
    info = string.gsub(info, "!y@", data_winner.nickName)
    if tonumber(self.datas.describe) ~= 1 then
        info = string.gsub(info, "!z@", self.datas.score)
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

function SmCrossServerBattleOfWarReportListCell:onUpdate(dt)

end

function SmCrossServerBattleOfWarReportListCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKingsX/battle_of_kings_x_tab_1_2_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmCrossServerBattleOfWarReportListCell.__size == nil then
        SmCrossServerBattleOfWarReportListCell.__size = root:getContentSize()
    end

	self:updateDraw(false)
end

function SmCrossServerBattleOfWarReportListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmCrossServerBattleOfWarReportListCell:clearUIInfo( ... )
    local root = self.roots[1]
    
end

function SmCrossServerBattleOfWarReportListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmCrossServerBattleOfWarReportListCell:unload()
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

function SmCrossServerBattleOfWarReportListCell:init(params)
    self.index = params[1]
    self.datas = params[2]
	self:onInit()

    self:setContentSize(SmCrossServerBattleOfWarReportListCell.__size)
    return self
end

function SmCrossServerBattleOfWarReportListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_1_2_list.csb", self.roots[1])
end