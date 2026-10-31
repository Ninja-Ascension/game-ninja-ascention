-- ------------------------------------------------------------------------------------------------------------
--  守卫战增益cell
-- ------------------------------------------------------------------------------------------------------------
GuardBattleGainCell = class("GuardBattleGainCellClass", Window)
GuardBattleGainCell.__size = nil

--创建cell
local guard_battle_gain_cell_create_terminal = {
    _name = "guard_battle_gain_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = GuardBattleGainCell:new()
        local index = params[1]
        cell:init(index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(guard_battle_gain_cell_create_terminal)
state_machine.init()

function GuardBattleGainCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    local function init_guard_battle_gain_cell_terminal()

        local guard_battle_gain_cell_gain_up_terminal = {
            _name = "guard_battle_gain_cell_gain_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                cell = params._datas.cell
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        TipDlg.drawTextDailog(red_alert_time_str[288])
                    end
                end
                protocol_command.guard_buff_buy.param_list = ""..cell._index
                NetworkManager:register(protocol_command.guard_buff_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_gain_cell_gain_up_terminal)
        state_machine.init()
    end
    
    init_guard_battle_gain_cell_terminal()
end


function GuardBattleGainCell:updateDraw()
    local root = self.roots[1]
    local Panel_guard_battle_gain_icon = ccui.Helper:seekWidgetByName(root, "Panel_guard_battle_gain_icon")
    local Text_gain_props_name = ccui.Helper:seekWidgetByName(root, "Text_gain_props_name")
    local Text_guard_battle_gain_infor = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_gain_infor")
    local Text_guard_battle_gain_gold_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_gain_gold_n")
    local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
    local Button_guard_battle_gain_up = ccui.Helper:seekWidgetByName(root, "Button_guard_battle_gain_up")
    Text_gain_props_name:removeAllChildren(true)
    Image_4:setVisible(true)

    local talent_name = dms.string(dms["guard_buff"], self._index, guard_buff.talent_name)
    local max_count = dms.int(dms["guard_buff"], self._index, guard_buff.max_count)
    local cost_gold = zstring.split(dms.string(dms["guard_buff"], self._index, guard_buff.cost_gold), ",")
    local talent_describe = dms.string(dms["guard_buff"], self._index, guard_buff.talent_describe)
    local pic_index = zstring.split(dms.string(dms["guard_buff"], self._index, guard_buff.pic_index), ",")
    Panel_guard_battle_gain_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._index,17})
    Panel_guard_battle_gain_icon:addChild(cell) 

    local level = 0
    if _ED.guard_battle_user_info ~= nil 
        and _ED.guard_battle_user_info.factor_list ~= nil 
        and _ED.guard_battle_user_info.factor_list[self._index] ~= nil 
        then
        level = tonumber(_ED.guard_battle_user_info.factor_list[self._index])
    end
    Text_guard_battle_gain_infor:setString(talent_describe)
    if level < max_count then
        Button_guard_battle_gain_up:setTouchEnabled(true)
        Button_guard_battle_gain_up:setBright(true)
        Text_guard_battle_gain_gold_n:setString(cost_gold[level + 1])
    else
        Image_4:setVisible(false)
        Button_guard_battle_gain_up:setTouchEnabled(false)
        Button_guard_battle_gain_up:setBright(false)
        Text_guard_battle_gain_gold_n:setString("")
    end

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, telent_name, "fonts/simhei.ttf",19)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..level.."/"..max_count, "fonts/simhei.ttf",19)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_gain_props_name:getContentSize().width/2,Text_gain_props_name:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_gain_props_name:getContentSize().width,19))
    Text_gain_props_name:addChild(_richText)
end

function GuardBattleGainCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.guard_battle_gain_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if GuardBattleGainCell.__size == nil then
        GuardBattleGainCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_gain_up"), nil, 
    {
        terminal_name = "guard_battle_gain_cell_gain_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function GuardBattleGainCell:onEnterTransitionFinish()

end

function GuardBattleGainCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function GuardBattleGainCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.guard_battle_gain_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function GuardBattleGainCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_guard_battle_gain_icon = ccui.Helper:seekWidgetByName(root, "Panel_guard_battle_gain_icon")
    local Text_gain_props_name = ccui.Helper:seekWidgetByName(root, "Text_gain_props_name")
    local Text_guard_battle_gain_infor = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_gain_infor")
    local Text_guard_battle_gain_gold_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_gain_gold_n")

    if Panel_guard_battle_gain_icon ~= nil then
        Panel_guard_battle_gain_icon:removeAllChildren(true)
        Text_gain_props_name:removeAllChildren(true)
        Text_guard_battle_gain_infor:setString("")
        Text_guard_battle_gain_gold_n:setString("")
    end
end

function GuardBattleGainCell:init(index)
    self._index = index 
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(GuardBattleGainCell.__size)
    return self
end

function GuardBattleGainCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.guard_battle_gain_cell, self.roots[1])
end

