-----------------------------
--首次充值（类型92）
-----------------------------
RedAlertTimeActivityFirstRecharge = class("RedAlertTimeActivityFirstRechargeClass", Window)

local red_alert_time_first_recharge_window_open_terminal = {
    _name = "red_alert_time_first_recharge_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeActivityFirstRechargeClass") then
            local panel = RedAlertTimeActivityFirstRecharge:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_first_recharge_window_open_terminal)
state_machine.init()

function RedAlertTimeActivityFirstRecharge:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
    self.m_times = 0

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil
    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
    local function init_red_alert_time_first_recharge_terminal()
	
        --刷新
        local red_alert_time_first_recharge_updata_terminal = {
            _name = "red_alert_time_first_recharge_updata",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_first_recharge_updata_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_troops_assembled state machine.
    init_red_alert_time_first_recharge_terminal()
end

function RedAlertTimeActivityFirstRecharge:onUpdateDraw()
    local root = self.roots[1]
    local Text_act_share_infor = ccui.Helper:seekWidgetByName(root, "Text_act_share_infor") -- 描述
	local Text_act_share_time_n = ccui.Helper:seekWidgetByName(root, "Text_act_share_time_n") -- 时间
    local Text_act_share_time_t = ccui.Helper:seekWidgetByName(root, "Text_act_share_time_t")
    local Text_act_share_name = ccui.Helper:seekWidgetByName(root, "Text_act_share_name") --名称
    local ListView_act_share = ccui.Helper:seekWidgetByName(root, "ListView_act_share") 
    ListView_act_share:removeAllItems()
    local index = 1
    for i=1, #_ED.activity_info[""..self.activity_type].activity_data[1] do
        local cell = state_machine.excute("red_alert_time_act_share_create_cell",0,{_ED.activity_info[""..self.activity_type].activity_data[1][i],index,self.activity_type,1})
        ListView_act_share:addChild(cell)
        index = index + 1 
    end
    self._list_view = ListView_act_share
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    Text_act_share_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
    Text_act_share_infor:setString(_ED.activity_info[""..self.activity_type].activity_dec)
    Text_act_share_time_n:setVisible(false)
    Text_act_share_time_t:removeAllChildren(true)
    Text_act_share_time_t:setString("")
    Text_act_share_time_t:setVisible(true)
    local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    local font_size = Text_act_share_time_t:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_act_share_time_t:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_act_share_time_t:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_act_share_time_t:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_act_share_time_t:addChild(time_int_1)
end

function RedAlertTimeActivityFirstRecharge:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_time_t"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_time_t"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_act_share_arrow_down:setVisible(true)
        else
            self._Image_act_share_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_act_share_arrow_up:setVisible(true)
        else
            self._Image_act_share_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RedAlertTimeActivityFirstRecharge:onEnterTransitionFinish()

end


function RedAlertTimeActivityFirstRecharge:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_5)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_look_rank"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 3)

    self._Image_act_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_down")
    self._Image_act_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_share_arrow_down:stopAllActions()
    self._Image_act_share_arrow_up:stopAllActions()
    playActions(self._Image_act_share_arrow_down)
    playActions(self._Image_act_share_arrow_up)
    self._Image_act_share_arrow_down:setVisible(false)
    self._Image_act_share_arrow_up:setVisible(false)

	self:onUpdateDraw()
end

function RedAlertTimeActivityFirstRecharge:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeActivityFirstRecharge:onExit()
    state_machine.remove("red_alert_time_first_recharge_updata")
end
