-----------------------------
--消费返利
-----------------------------
RedAlertTimeActivityConsumeBackGoods = class("RedAlertTimeActivityConsumeBackGoodsClass", Window)

local red_alert_time_consume_back_goods_window_open_terminal = {
    _name = "red_alert_time_consume_back_goods_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeActivityConsumeBackGoodsClass") then
            local panel = RedAlertTimeActivityConsumeBackGoods:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_consume_back_goods_window_open_terminal)
state_machine.init()

function RedAlertTimeActivityConsumeBackGoods:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
    self.m_times = 0

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil

    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
    local function init_red_alert_time_consume_back_goods_terminal()
	
        --刷新
        local red_alert_time_consume_back_goods_updata_terminal = {
            _name = "red_alert_time_consume_back_goods_updata",
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
		
        state_machine.add(red_alert_time_consume_back_goods_updata_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_troops_assembled state machine.
    init_red_alert_time_consume_back_goods_terminal()
end

function RedAlertTimeActivityConsumeBackGoods:onUpdateDraw()
    local root = self.roots[1]
    local Text_act_share_infor = ccui.Helper:seekWidgetByName(root, "Text_act_share_infor") -- 描述
	local Text_act_share_time_n = ccui.Helper:seekWidgetByName(root, "Text_act_share_time_n") -- 时间
    local Text_act_share_time_t = ccui.Helper:seekWidgetByName(root, "Text_act_share_time_t")
    local Text_act_share_name = ccui.Helper:seekWidgetByName(root, "Text_act_share_name") --名称
    local ListView_act_share = ccui.Helper:seekWidgetByName(root, "ListView_act_share") 
    ListView_act_share:removeAllItems()
    local index = 1
    local reward_list_number = #_ED.activity_info[""..self.activity_type].activity_data[1]
    for i=1, reward_list_number do
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
    Text_act_share_time_t:setVisible(false)

    local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
    Text_act_share_act_time_1:removeAllChildren(true)
    Text_act_share_act_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_act_share_act_time_1, 0, activity_str_tip[93], getRedAlertTimeActivityFormat(self.m_times))
    Text_act_share_act_time_1:addChild(time_info)
    Text_act_share_act_time_1:addChild(time_int)
    self._label_close_text = time_int

    -- 重置倒计时
    if tonumber(self.activity_type) == 95 then
        local server_time = getCurrentGTM8Time()
        self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
        local Text_act_share_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_2")
        Text_act_share_act_time_2:removeAllChildren(true)
        Text_act_share_act_time_2:setString("")
        local reset_time_info, reset_time_int = createActivityTimeLable(Text_act_share_act_time_2, 1, activity_str_tip[94], getRedAlertTimeActivityFormat(self.m_reset_times))
        Text_act_share_act_time_2:addChild(reset_time_info)
        Text_act_share_act_time_2:addChild(reset_time_int)
        self._label_reset_text = reset_time_int
    end

    local achieve_complete_count = _ED.activity_info[""..self.activity_type].activity_data[1][reward_list_number].achieve_complete_count
    local cost_goods = zstring.split(achieve_complete_count,"/")
    local Text_promp_n = ccui.Helper:seekWidgetByName(root, "Text_promp_n")
    Text_promp_n:removeAllChildren(true)
    Text_promp_n:setString("")
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    _richText2:setContentSize(cc.size(root:getContentSize().width,40))
    _richText2:setAnchorPoint(cc.p(0.5, 0.5))
    local numbers = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state,",")
    local dataset= nil
    dataset = string.format(activity_str_tip[109],""..cost_goods[1])   
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    dataset, 
    cc.c3b(255, 255, 255),
    cc.c3b(255, 255, 255),
    0, 
    0, 
    config_res.font.font_name, 
    20,
    chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionX(Text_promp_n:getPositionX()*3/2)
    _richText2:setPositionY(-Text_promp_n:getContentSize().height/2)
    Text_promp_n:addChild(_richText2)
end

function RedAlertTimeActivityConsumeBackGoods:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
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

function RedAlertTimeActivityConsumeBackGoods:onEnterTransitionFinish()

end


function RedAlertTimeActivityConsumeBackGoods:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_6)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

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

function RedAlertTimeActivityConsumeBackGoods:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeActivityConsumeBackGoods:onExit()
    state_machine.remove("red_alert_time_consume_back_goods_updata")
end
