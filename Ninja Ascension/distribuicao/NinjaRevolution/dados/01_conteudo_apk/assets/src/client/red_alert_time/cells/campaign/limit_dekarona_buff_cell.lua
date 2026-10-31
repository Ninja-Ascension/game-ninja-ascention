-- ---------------------------
-- 极限挑战购买buffcell
-- ---------------------------
LimitDekaronaBuffCell = class("LimitDekaronaBuffCellClass", Window)
LimitDekaronaBuffCell.__size = nil

local limit_dekarona_buff_create_cell_terminal = {
    _name = "limit_dekarona_buff_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LimitDekaronaBuffCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekarona_buff_create_cell_terminal)
state_machine.init()

function LimitDekaronaBuffCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._buff = nil

    local function init_limit_dekarona_buff_cell_terminal()
        local limit_dekarona_buff_cell_choose_terminal = {
            _name = "limit_dekarona_buff_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("limit_dekaron_challenge_update_draw", 0, nil)
                            TipDlg.drawTextDailog(red_alert_time_str[255])
                        end
                    end
                end
                protocol_command.extreme_buff_buy.param_list = ""..index - 1
                NetworkManager:register(protocol_command.extreme_buff_buy.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekarona_buff_cell_choose_terminal)
        state_machine.init()
    end
    
    init_limit_dekarona_buff_cell_terminal()
end

--刷新列表数据
function LimitDekaronaBuffCell:onUpdateDraw()
    local root = self.roots[1]
    for i=1,3 do
        local Panel_limit_buff_icon = ccui.Helper:seekWidgetByName(root,"Panel_limit_buff_icon_"..i)
        local Text_limit_buff_add = ccui.Helper:seekWidgetByName(root,"Text_limit_buff_add_"..i)
        local Text_limit_buff_star = ccui.Helper:seekWidgetByName(root,"Text_limit_buff_star_"..i)
        local Button_limit_buff_choose = ccui.Helper:seekWidgetByName(root,"Button_limit_buff_choose_"..i)
        local Panel_limit_buff_in = ccui.Helper:seekWidgetByName(root,"Panel_limit_buff_in_"..i)
        Panel_limit_buff_icon:removeAllChildren(true)
        Text_limit_buff_add:removeAllChildren(true)
        Text_limit_buff_star:removeAllChildren(true)
        Button_limit_buff_choose:setBright(true)
        Button_limit_buff_choose:setTouchEnabled(true)
        local cell = state_machine.excute("props_icon_create_cell",0,{1,3,self._buff[i],14})
        Panel_limit_buff_icon:addChild(cell) 
        local buff_data = dms.element(dms["limit_challenge_buff"], self._buff[i])
        local buff_info = zstring.split(dms.atos(buff_data, limit_challenge_buff.buff_info), ",")
        local need_star = dms.atoi(buff_data, limit_challenge_buff.need_star)
        local is_handred = false
        local dec = ""
        for i,v in pairs(attribute_hundred) do
            if tonumber(buff_info[1]) == v then
                is_handred = true
            end
        end
        if is_handred == true then
            dec = "+"..buff_info[2] .. "%"
        else
            dec = "+"..buff_info[2]
        end
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_attribute[tonumber(buff_info[1]) + 1], "fonts/simhei.ttf",20)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, dec, "fonts/simhei.ttf",20)
        _richText_1:pushBackElement(re2)
        _richText_1:setPosition(cc.p(Text_limit_buff_add:getContentSize().width/2,Text_limit_buff_add:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_limit_buff_add:getContentSize().width,20))
        Text_limit_buff_add:addChild(_richText_1)
        
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[141], "fonts/simhei.ttf",20)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, need_star, "fonts/simhei.ttf",20)
        _richText_2:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[139], "fonts/simhei.ttf",20)
        _richText_2:pushBackElement(re3)
        _richText_2:setPosition(cc.p(Text_limit_buff_star:getContentSize().width/2,Text_limit_buff_star:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_limit_buff_star:getContentSize().width,20))
        Text_limit_buff_star:addChild(_richText_2)

        if need_star > _ED.user_extreme_info.surplus_star_count then
            Button_limit_buff_choose:setBright(false)
            Button_limit_buff_choose:setTouchEnabled(false)
        end
        Panel_limit_buff_in:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.1),
                cc.MoveTo:create(0.3, cc.p(0, 0))
            ))
    end
end

function LimitDekaronaBuffCell:onUpdate( dt )
    
end

function LimitDekaronaBuffCell:onEnterTransitionFinish()

end

--初始化列表
function LimitDekaronaBuffCell:onInit( )
    local root = cacher.createUIRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 3), "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if LimitDekaronaBuffCell.__size == nil then
        LimitDekaronaBuffCell.__size = root:getContentSize()
    end

    for i=1,3 do
        local Panel_limit_buff_in = ccui.Helper:seekWidgetByName(root,"Panel_limit_buff_in_"..i)
        Panel_limit_buff_in:setPositionX(-600)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_limit_buff_choose_"..i), nil, 
        {
            terminal_name = "limit_dekarona_buff_cell_choose", 
            terminal_state = 0, 
            cell = self,
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 1)
    end

	self:onUpdateDraw()	
end

function LimitDekaronaBuffCell:init(params)
    self._buff = params[1]
    self:onInit()
    self:setContentSize(LimitDekaronaBuffCell.__size)
    return self
end

function LimitDekaronaBuffCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimitDekaronaBuffCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 3))
    root:removeFromParent(false)
    self.roots = {}
end

function LimitDekaronaBuffCell:clearUIInfo( ... )
    local root = self.roots[1]
    for i=1,3 do
        local Panel_limit_buff_icon = ccui.Helper:seekWidgetByName(root,"Panel_limit_buff_icon_"..i)
        local Text_limit_buff_add = ccui.Helper:seekWidgetByName(root,"Text_limit_buff_add_"..i)
        local Text_limit_buff_star = ccui.Helper:seekWidgetByName(root,"Text_limit_buff_star_"..i)
        if Panel_limit_buff_icon ~= nil then
            Panel_limit_buff_icon:removeAllChildren(true)
            Text_limit_buff_add:removeAllChildren(true)
            Text_limit_buff_star:removeAllChildren(true)
        end
    end
end

function LimitDekaronaBuffCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 3), self.roots[1])
end
