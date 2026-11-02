-----------------------------
--神秘商店
-----------------------------
MysteryShop = class("MysteryShopClass", Window)

local mystery_shop_window_open_terminal = {
    _name = "mystery_shop_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("MysteryShopClass")
        if nil == _window then
            fwin:open(MysteryShop:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local mystery_shop_window_close_terminal = {
    _name = "mystery_shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MysteryShopClass"))
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("task_window_show",0,"")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mystery_shop_window_open_terminal)
state_machine.add(mystery_shop_window_close_terminal)
state_machine.init()

function MysteryShop:ctor()
    self.super:ctor()
    --var
    self.roots = {}
    
    --宝石text
    self.gem_text = nil

    --
    self.jade_text = nil

    --老板娘文字窗口
    self._panel_chat = nil

    -- 老板娘文字
    self._text_chat = nil

    -- load lua file
    app.load("client.red_alert_time.cells.shop.mystery_shop_cell")
    app.load("client.red_alert_time.shop.MysteryShopBuy")
    
    -- Initialize mystery_shop state machine.
    local function init_mystery_shop_terminal()

        --刷新
        local mystery_shop_refresh_button_terminal = {
            _name = "mystery_shop_refresh_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function refreshCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                            response.node:onUpdateDraw()
                            response.node:onUpdateDrawList()
                        end
                    end
                end
                local VipLv = tonumber(_ED.vip_grade) -- vip 等级 
                local free_times = instance:getFreeRefreshTimes()
                -- local token_times = tonumber(getPropAllCountByMouldId(3))
                local token_times = 0
                if fundPropWidthId(216) ~= nil then 
                    local token = fundPropWidthId(216)
                    token_times = token.prop_number
                end
                -- local gem_times_max = dms.int(dms["base_consume"],30,tonumber(base_consume.vip_0_value)+VipLv)--神秘商店刷新次数。VIP越高次数越多
                -- local gem_times_use_times = tonumber(_ED.secret_shop_init_info.refresh_count)
                -- local count = getPropAllCountByMouldId(3)

                if tonumber(params._datas.ntype) == 0 then
                    -- if tonumber(gem_times_max + instance:getMonthCardRefreshTime() - gem_times_use_times) > 0  or zstring.tonumber(token_times) > 0  or free_times > 0 then
                        if free_times == 0 and zstring.tonumber(token_times) == 0 then
                            local need_gold = dms.int(dms["shop_config"],2,shop_config.param)
                            -- if tonumber(_ED.user_info.user_gold) < need_gold then
                            --     TipDlg.drawTextDailog(red_alert_all_str[79])
                            --     return
                            -- end
                            if tonumber(_ED.user_info.jade) < 100 then
                                TipDlg.drawTextDailog(red_alert_all_str[38])
                                return
                            end
                        end
                        protocol_command.secret_shop_refresh.param_list = params._datas.ntype
                        NetworkManager:register(protocol_command.secret_shop_refresh.code, nil, nil, nil, instance, refreshCallBack, false, nil)
                    -- else
                    --     TipDlg.drawTextDailog(red_alert_all_str[190])
                    -- end
                else
                    local high_token_times = 0
                    local prop = fundPropWidthId(dms.int(dms["shop_config"], 15, shop_config.param))
                    if prop ~= nil then 
                        high_token_times = prop.prop_number
                    end
                    if tonumber(high_token_times) > 0 then
                        protocol_command.secret_shop_refresh.param_list = params._datas.ntype
                        NetworkManager:register(protocol_command.secret_shop_refresh.code, nil, nil, nil, instance, refreshCallBack, false, nil)
                    else
                        TipDlg.drawTextDailog(red_alert_all_str[224])
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --老板娘对话
        local image_mystery_shop_talk_terminal = {
            _name = "image_mystery_shop_talk",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:wifeOfShopTalk()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(mystery_shop_refresh_button_terminal)
        state_machine.add(image_mystery_shop_talk_terminal)
        state_machine.init()
    end
    
    -- call func init mystery_shop state machine.
    init_mystery_shop_terminal()
end

function MysteryShop:onHide( ... )
    self:setVisible(false)
end

function MysteryShop:onShow( ... )
    self:setVisible(true)
end

function MysteryShop:onUpdateDrawList( ... )
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_mystery_shop_7")
    local ListView_2 = ccui.Helper:seekWidgetByName(root,"ListView_mystery_shop_6")
    ListView_1:removeAllItems()
    ListView_2:removeAllItems()
    for i ,v in pairs(_ED.secret_shop_init_info.goods_info) do 
	local function showCell()
        local cell = state_machine.excute("mystery_shop_create_cell",0,{v, i-1, 1})
        if math.floor(i % 2) ~= 0 then
            ListView_1:addChild(cell)
        else
            ListView_2:addChild(cell)
        end
		end
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local run_action2  = cc.Sequence:create(cc.DelayTime:create(0.1*i),cc.CallFunc:create(showCell))
		self:runAction(run_action2)
	else
		showCell()
	end
    end
end

function MysteryShop:onUpdateDraw()
    local root = self.roots[1]
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    -- 钻石
    local Text_mystery_shop_13 = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_13") 
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000) 
        Text_mystery_shop_13:setString(string.format(red_alert_all_str[122],info))
    else
        Text_mystery_shop_13:setString(_ED.user_info.user_gold)
    end
    -- 英魂
    local Text_mystery_shop_14 = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_14") 
    if tonumber(_ED.user_info.jade) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.jade)/10000)
        Text_mystery_shop_14:setString(string.format(red_alert_all_str[122],info))
    else
        Text_mystery_shop_14:setString(_ED.user_info.jade)
    end
    self.gem_text = Text_mystery_shop_13
    self.jade_text = Text_mystery_shop_14
    local Panel_mystery_shop_time = ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_time") -- 显示时间
    local Text_mystery_shop_token_number = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_token_number") --刷新令数量
    local Text_mystery_shop_gem_frequency = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_gem_frequency") -- 元宝刷新次数
    local Panel_mystery_shop_token_refresh = ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_token_refresh") -- 令牌刷新层
    local Panel_mystery_shop_gem_refresh = ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_gem_refresh") -- 元宝刷新层
    local Button_mystery_shop_free = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_free") -- 免费刷新按钮
    local Button_mystery_shop_token = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_token") -- 令牌刷新按钮
    local Button_mystery_shop_gem = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_gem") -- 元宝刷新按钮
    local Image_mystery_shop_free_time = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_free_time")
    local Text_mystery_shop_free_time_num = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_free_time_num")
    local Text_mystery_book_free_time_num = ccui.Helper:seekWidgetByName(root,"Text_mystery_book_free_time_num")

    local Text_hg_refresh_time = ccui.Helper:seekWidgetByName(root,"Text_hg_refresh_time")
    local Image_hg_refresh_time = ccui.Helper:seekWidgetByName(root,"Image_hg_refresh_time")

    local VipLv = tonumber(_ED.vip_grade) -- vip 等级 
    local free_times = self:getFreeRefreshTimes()
    -- local token_times = zstring.tonumber(getPropAllCountByMouldId(3))
    local token_times = 0 
    if fundPropWidthId(216) ~= nil then 
        local token = fundPropWidthId(216)
        if token ~= nil then
            token_times = token.prop_number
        end
    end
    -- local gem_times_max = dms.int(dms["base_consume"],30,tonumber(base_consume.vip_0_value)+VipLv)--神秘商店刷新次数。VIP越高次数越多
    -- local gem_times_use_times = _ED.secret_shop_init_info.refresh_count
    Text_mystery_shop_token_number:setString(token_times)
    Text_mystery_shop_gem_frequency:setString("")
    local Text_mystery_shop_16 = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_16")
    Text_mystery_shop_16:setString("")
    -- Text_mystery_shop_gem_frequency:setString(gem_times_use_times .. "/" .. (gem_times_max + self:getMonthCardRefreshTime()))

    Panel_mystery_shop_token_refresh:setVisible(false)
    Panel_mystery_shop_gem_refresh:setVisible(false)
    Panel_mystery_shop_time:setVisible(false)
    Image_mystery_shop_free_time:setVisible(false)
    Text_mystery_shop_free_time_num:setString("")
    Text_hg_refresh_time:setString("")
    Image_hg_refresh_time:setVisible(false)
    Button_mystery_shop_token:setVisible(false)
    Button_mystery_shop_free:setVisible(true)
    local high_token_times = 0
    local prop = fundPropWidthId(dms.int(dms["shop_config"], 15, shop_config.param))
    if prop ~= nil then 
        high_token_times = prop.prop_number
    end
    if tonumber(high_token_times) > 0 then
        Text_hg_refresh_time:setString(""..high_token_times)
        Image_hg_refresh_time:setVisible(true)
    end
    -- print("==========",free_times,token_times)
    if free_times >= 6 then -- 如果免费次数已满 不显示刷新时间
        Image_mystery_shop_free_time:setVisible(true)
        Text_mystery_shop_free_time_num:setString(free_times)
    else
        Panel_mystery_shop_time:setVisible(true)
        if free_times > 0 then -- 如果免费次数没满，有免费次数 显示免费刷新按钮 其余隐藏  
            Image_mystery_shop_free_time:setVisible(true)
            Text_mystery_shop_free_time_num:setString(free_times)
        else
            if tonumber(token_times) > 0 then -- 如果有令牌  显示令牌
                Panel_mystery_shop_token_refresh:setVisible(true) 
                Image_mystery_shop_free_time:setVisible(true)
                Button_mystery_shop_token:setVisible(true)
                Button_mystery_shop_free:setVisible(false)
                Text_mystery_shop_free_time_num:setString(token_times)             
            else
                Panel_mystery_shop_gem_refresh:setVisible(true)   
                Button_mystery_shop_free:setVisible(false)                
            end
        end
    end
end

function MysteryShop:getMonthCardRefreshTime( ... )
    local add_times = 0
    local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
    if _ED.month_card ~= nil and _ED.month_card ~= "" 
        and _ED.month_card[_drawMonth[1][1]] ~= nil 
        and _ED.month_card[_drawMonth[1][1]] ~= "" 
        then
        local monthCardDayOne = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time
        if tonumber(monthCardDayOne) > 0 then
            add_times = 10
        end
    end
    return add_times
end

function MysteryShop:getFreeRefreshTimes()
    return tonumber(_ED.secret_shop_init_info.free_times)
end

function MysteryShop:onUpdate(dt)
    if self.gem_text == nil or self.jade_text == nil then
        return
    end
    self:onUpdateDrawResouceNumber()
    self:onUpdateDrawTime()

end

function MysteryShop:formatTimeString(_time)   --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function MysteryShop:onUpdateDrawTime( ... )
    if _ED.secret_shop_init_info.os_time ~= nil then
        local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
        local remainTime = 0
        local root = self.roots[1]
        local _refreshTime = ccui.Helper:seekWidgetByName(root, "Text_mystery_shop_time")
        if times > _ED.secret_shop_init_info.refresh_time/1000 then 
            _refreshTime:setString(self:formatTimeString(remainTime))
        else 
            remainTime =_ED.secret_shop_init_info.refresh_time/1000-times
            _refreshTime:setString(self:formatTimeString(remainTime))
        end
    end
end

function MysteryShop:onUpdateDrawResouceNumber()
    -- 钻石
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000) 
        self.gem_text:setString(string.format(red_alert_all_str[122],info))
    else
        self.gem_text:setString(_ED.user_info.user_gold)
    end
    -- 英魂
    if tonumber(_ED.user_info.jade) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.jade)/10000)
        self.jade_text:setString(string.format(red_alert_all_str[122],info))
    else
        self.jade_text:setString(_ED.user_info.jade)
    end

end

function MysteryShop:onEnterTransitionFinish()

end

--老板娘对话
function MysteryShop:wifeOfShopTalk()
    self._panel_chat:setOpacity(255)
    local numbers = #wife_of_shop_talk
    local random_value = math.random(1,numbers)
    self._text_chat:setString(wife_of_shop_talk[random_value])
    self._panel_chat:stopAllActions()
    self._panel_chat:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.FadeOut:create(1)))
end

function MysteryShop:onInit( )
    local csbItem = csb.createNode(config_csb.shop.mystery_shop)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_close"), nil, 
    {
        terminal_name = "mystery_shop_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local Button_mystery_shop_free = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_free") -- 免费刷新按钮
    local Button_mystery_shop_token = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_token") -- 令牌刷新按钮
    local Button_mystery_shop_gem = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_gem") -- 元宝刷新按钮
    local Button_mystery_shop_get = ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_get") -- 获取将魂按钮
    local Image_mystery_shop_9 = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_9") -- 老板娘文字按钮
    local Text_chat = ccui.Helper:seekWidgetByName(root,"Text_chat") -- 老板娘文字  
    local Panel_chat = ccui.Helper:seekWidgetByName(root,"Panel_chat") -- 老板娘文字面板
    self._text_chat = Text_chat
    self._panel_chat = Panel_chat
    Panel_chat:setVisible(true)
    local numbers = #wife_of_shop_talk
    local random_value = math.random(1,numbers)
    Text_chat:setString(wife_of_shop_talk[random_value])

    -- 免费刷新
    fwin:addTouchEventListener(Button_mystery_shop_free, nil, 
    {
        terminal_name = "mystery_shop_refresh_button", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 0,
    }, nil, 0)

    -- 令牌刷新
    fwin:addTouchEventListener(Button_mystery_shop_token, nil, 
    {
        terminal_name = "mystery_shop_refresh_button", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 0,
    }, nil, 0)

    -- 高级招募令
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hg_refresh"), nil, 
    {
        terminal_name = "mystery_shop_refresh_button", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 1,
    }, nil, 0)

    -- 元宝刷新
    fwin:addTouchEventListener(Button_mystery_shop_gem, nil, 
    {
        terminal_name = "mystery_shop_refresh_button", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 0,
    }, nil, 0)   

    -- 获取将魂
    fwin:addTouchEventListener(Button_mystery_shop_get, nil, 
    {
        terminal_name = "get_the_way_window_open", 
        -- func_string = [[funOpenDrawTip(100)]],       
        terminal_state = 0, 
        prop_type = 5,
        prop_item = -1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 老板娘文字
    fwin:addTouchEventListener(Image_mystery_shop_9, nil, 
    {
        terminal_name = "image_mystery_shop_talk",     

    }, nil, 0)    
	self:onUpdateDraw()	
    self:onUpdateDrawList()
end

function MysteryShop:init()
	self:onInit()
    return self
end

function MysteryShop:onExit()
    state_machine.remove("mystery_shop_refresh_button")
    state_machine.remove("image_mystery_shop_talk")
end
