-----------------------------
--兵营科技
-----------------------------
BarrackScience = class("BarrackScienceClass", Window)

--打开兵营科技
local barrack_science_window_open_terminal = {
    _name = "barrack_science_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(106) == true then
            return
        end       
        state_machine.excute("home_select_action_window_close",0,"")
        if nil == fwin:find("BarrackScienceClass") then
            fwin:open(BarrackScience:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭兵营科技
local barrack_science_window_close_terminal = {
    _name = "barrack_science_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BarrackScienceClass"))
      
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(barrack_science_window_open_terminal)
state_machine.add(barrack_science_window_close_terminal)
state_machine.init()

function BarrackScience:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("client.red_alert.cells.barrack.barrack_science_cell")
    app.load("client.red_alert.cells.barrack.barrack_science_icon_cell")
    app.load("client.red_alert.barrack.BarrackScienceLvUp")
    app.load("client.utils.ConfirmTip")

    --var
    --兵营等级列表
    self.cells = {}
    --页面索引
    self.pageIndex = 0
    --最大页面索引
    self.maxPageIndex = 3 
    --科技升级冷却最大时间
    self.max_time = nil
    --加速所需钻石text
    self.speed_need_gem_text = nil
    --科技升级冷却所需时间text
    self.leava_time_text = nil
    --加速面板
    self.panel_quick = nil
    self.last_time = nil
    --绿色进度条
    self.loading_bar = nil
    --加速所需钻石
    self.need_gem = nil
    --红色进度条
    self._loadingBar_red = nil

    
    -- Initialize barrack_science state machine.
    local function init_barrack_science_terminal()
	   --翻页
        local barrack_science_scoll_pageindex_terminal = {
            _name = "barrack_science_scoll_pageindex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local to_turn_page = params._datas.to_turn_page + instance.pageIndex - 1
                instance:scrollToPageIndex(to_turn_page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新cell等级
       local barrack_science_update_cell_terminal = {
            _name = "barrack_science_update_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateCell(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --加速
        local barrack_science_clear_cd_terminal = {
            _name = "barrack_science_clear_cd",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.need_gem > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end

                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[254],instance.need_gem)
                tip:init(instance, instance.sureSpeedUp, info)
                fwin:open(tip,fwin._windows) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --关闭界面
        local barrack_science_close_terminal = {
            _name = "barrack_science_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(barrack_science_scoll_pageindex_terminal)
        state_machine.add(barrack_science_update_cell_terminal)
        state_machine.add(barrack_science_clear_cd_terminal)
        state_machine.add(barrack_science_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_barrack_science_terminal()
end

--加速
function BarrackScience:sureSpeedUp(sure_number)

    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                response.node:onUpdateDrawOther()
                playEffect(formatMusicFile("effect", 10015))
            end
        end
    end

    if sure_number == 0 then
       NetworkManager:register(protocol_command.barracks_teach_clear_cd.code, nil, nil, nil, self, responseCallback, false, nil)  
    end
end

--刷新兵营科技界面
function BarrackScience:onUpdateDraw()
    local root = self.roots[1]
    local PageView_choose = ccui.Helper:seekWidgetByName(root,"PageView_choose")    --页面选择
    local Panel_choose_1 = PageView_choose:getChildByName("Panel_choose_1")         --当前页
    local Panel_choose_2 = PageView_choose:getChildByName("Panel_choose_2")         --下一页
    local Panel_choose_3 = PageView_choose:getChildByName("Panel_choose_3")
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_1")          --绿色进度条
    local LoadingBar_red = ccui.Helper:seekWidgetByName(root,"LoadingBar_red")      --红色进度条
    local all_numbers = 0

    for i = 1, dms.count( dms["teach_escalate_param"] ) do
        if _ED.barracks_info["" .. i] == nil then
            -- break
        else
            all_numbers = all_numbers + 1 
        end
    end
    if all_numbers <= 8 then
        PageView_choose:removePageAtIndex(2)  --移除第三页
        PageView_choose:removePageAtIndex(1)  --移除第二页
        self.maxPageIndex = 1
    elseif all_numbers <= 16 then
        PageView_choose:removePageAtIndex(2)  --移除第三页
        self.maxPageIndex = 2
    else
        self.maxPageIndex = 3
    end
    LoadingBar_1:setPercent(0)
    LoadingBar_red:setPercent(100)
    self.loading_bar = LoadingBar_1
    self._loadingBar_red = LoadingBar_red
    self:turnButtonCheckShow()
end

--刷新cell等级
function BarrackScience:onUpdateCell(barrack_id)
    for i,cell in pairs(self.cells) do
        if tonumber(cell.barrack_id) == tonumber(barrack_id) then
            if cell.updateDraw ~= nil then
                cell:updateDraw()
            end
        end
    end
end

--刷新页面列表
function BarrackScience:onUpdateDrawPageCell()
    local root = self.roots[1]
    local PageView_choose = ccui.Helper:seekWidgetByName(root,"PageView_choose")
    local Panel_choose_1 = PageView_choose:getChildByName("Panel_choose_1")
    local Panel_choose_2 = PageView_choose:getChildByName("Panel_choose_2")
    local Panel_choose_3 = PageView_choose:getChildByName("Panel_choose_3")
    local height = Panel_choose_1:getContentSize().height
    local width = Panel_choose_1:getContentSize().width
    local index = 0
    for i = 1, dms.count( dms["teach_escalate_param"] ) do
        if _ED.barracks_info["" .. i] == nil then
            -- break
        else
            index = index + 1
            local cell = state_machine.excute("barrack_science_create_cell",0,{_ED.barracks_info["" .. i].barrack_id,self.max_time,index})
            table.insert(self.cells,cell)

            local pos_index = index
            if pos_index > 8 then
                if pos_index > 16 then
                    pos_index = pos_index - 16
                else
                    pos_index = pos_index - 8
                end
            end
            local poy = 0
            local pox = 0

            if pos_index <= 4 then
                poy = height / 2
                pox = width / 4 * (pos_index - 1)
            else
                poy = 0
                pox = width / 4 * (pos_index - 5)
            end  
            cell:setPosition(cc.p(pox,poy))
            if index <= 8 then
                Panel_choose_1:addChild(cell)
            elseif index <= 16 then
                Panel_choose_2:addChild(cell)
            else
                Panel_choose_3:addChild(cell)
            end
        end
    end

    PageView_choose.getItems = function(pageView)
        return self.cells
    end
    
end

--翻页按钮检查显示
function BarrackScience:turnButtonCheckShow()
    local root = self.roots[1]
    local Button_turn_left = ccui.Helper:seekWidgetByName(root,"Button_turn_left")      --左翻页
    local Button_turn_right = ccui.Helper:seekWidgetByName(root,"Button_turn_right")    --右翻页
    if self.maxPageIndex == 1 then
        Button_turn_left:setVisible(false)
        Button_turn_right:setVisible(false)
        return
    end

    if self.maxPageIndex == 2 then
        if self.pageIndex == 1 then
            Button_turn_left:setVisible(false)
            Button_turn_right:setVisible(true)            
        elseif self.pageIndex == 2 then
            Button_turn_left:setVisible(true)
            Button_turn_right:setVisible(false)
        end
        return
    end

    if self.maxPageIndex == 3 then
        if self.pageIndex == 1 then
            Button_turn_left:setVisible(false)
            Button_turn_right:setVisible(true)            
        elseif self.pageIndex == 2 then
            Button_turn_left:setVisible(true)
            Button_turn_right:setVisible(true)
        elseif self.pageIndex == 3 then
            Button_turn_left:setVisible(true)
            Button_turn_right:setVisible(false)
        end
    end
end

--刷新页面
function BarrackScience:onUpdateDrawOther()
    local root = self.roots[1]
    local Panel_quick = ccui.Helper:seekWidgetByName(root,"Panel_quick")        --加速面板
    self.panel_quick = Panel_quick
    local leava_time = math.max(_ED.barracks_leave_time - (os.time() - _ED.barracks_start_time),0)
    local Text_spend_v = ccui.Helper:seekWidgetByName(root,"Text_spend_v")      --加速所需钻石
    self.speed_need_gem_text = Text_spend_v

    Text_spend_v:setString(math.abs(math.ceil(math.ceil(leava_time/60.0)/2/10)*10))
    self.need_gem = math.abs(math.ceil(math.ceil(leava_time/60.0)/2/10)*10)

    local Text_science_cd_time_1 = ccui.Helper:seekWidgetByName(root,"Text_science_cd_time_1")  --科技升级冷却所需时间
    self.leava_time_text = Text_science_cd_time_1
    Text_science_cd_time_1:setString(self:formatTimeString(leava_time))

    local Text_science_cd_time_2 = ccui.Helper:seekWidgetByName(root,"Text_science_cd_time_2")  --科技升级冷却最大时间
    Text_science_cd_time_2:setString(self:formatTimeString(self.max_time))
    if leava_time > 0 then
        Panel_quick:setVisible(true)
    else
        Panel_quick:setVisible(false)    
    end
end

--刷新科技升级冷却时间
function BarrackScience:onUpdate(dt)
    if self.speed_need_gem_text == nil or self.leava_time_text == nil or self.panel_quick == nil then
        return
    end

    local leava_time = math.max(_ED.barracks_leave_time - (os.time() - _ED.barracks_start_time),0)
    if leava_time > 0 then
        self.panel_quick:setVisible(true)
    else
        self.loading_bar:setPercent(0)
        self.panel_quick:setVisible(false)    
    end
    if os.time() - zstring.tonumber(self.last_time) >= 1 and leava_time >= 0 then
        self.leava_time_text:setString(self:formatTimeString(leava_time))
        local persent = leava_time / self.max_time * 100
        self.loading_bar:setPercent(persent)
        self.speed_need_gem_text:setString(math.abs(math.ceil(math.ceil(leava_time/60.0)/2/10)*10))
        self.need_gem = math.abs(math.ceil(math.ceil(leava_time/60.0)/2/10)*10)
    end
    if tonumber(leava_time) < tonumber(self.max_time) then
        self.leava_time_text:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
        self.loading_bar:setVisible(true)
        self._loadingBar_red:setVisible(false)
    elseif tonumber(leava_time) >= tonumber(self.max_time) then
        self.leava_time_text:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        self.loading_bar:setVisible(false)
        self._loadingBar_red:setVisible(true)
    end
end

function BarrackScience:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))

    return timeString
end

function BarrackScience:formatTimeStringChinese(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = string.format(red_alert_all_str[86], math.floor(now_time/3600))
    timeString = string.format(red_alert_all_str[87], math.floor((now_time%3600)/60))
    timeString = string.format(red_alert_all_str[88], math.floor(now_time%60))
    return timeString
end

--初始化页面选择按钮
function BarrackScience:initPageViewScrollTouchListen()
    local root = self.roots[1]
    local PageView_choose = ccui.Helper:seekWidgetByName(root, "PageView_choose")
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local nowPageIndex = sender:getCurPageIndex()
            if nowPageIndex == 0 then
                self.pageIndex = 1 
            elseif nowPageIndex == 1 then
                self.pageIndex = 2 
            elseif nowPageIndex == 2 then
                self.pageIndex = 3 
            end
            self:turnButtonCheckShow()
        end
    end 
    PageView_choose:addEventListener(pageViewEvent)
end

--翻页
function BarrackScience:scrollToPageIndex(pageIndex)
    local root = self.roots[1]
    local PageView_choose = ccui.Helper:seekWidgetByName(root,"PageView_choose")
    PageView_choose:scrollToPage(pageIndex)
end

function BarrackScience:onEnterTransitionFinish()

end

-- 关闭界面动画
function BarrackScience:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("barrack_science_window_close", 0, "")
        end
    end)
end

--初始化界面
function BarrackScience:onInit( )
    local csbItem = csb.createNode(config_csb.barrack.barrack_science)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.barrack.barrack_science)
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbItem:runAction(action)


    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "barrack_science_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quick"), nil, 
    {
        terminal_name = "barrack_science_clear_cd", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    -- 左翻页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_turn_left"), nil, 
    {
        terminal_name = "barrack_science_scoll_pageindex", 
        terminal_state = 0, 
        touch_scale = true,
        to_turn_page = -1,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 右翻页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_turn_right"), nil, 
    {
        terminal_name = "barrack_science_scoll_pageindex", 
        terminal_state = 0, 
        touch_scale = true,
        to_turn_page = 1,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    self.pageIndex = 1
	self:onUpdateDraw()
    self:onUpdateDrawOther()
    self:onUpdateDrawPageCell()
    self:initPageViewScrollTouchListen()
end

--初始化科技升级冷却最大时间
function BarrackScience:initData()
    local function sortType( a, b )
        return tonumber(a.barrack_id) < tonumber(b.barrack_id)
    end
    table.sort(_ED.barracks_info, sortType)

    local level = _ED.home_build["2"].level
    local update_group_id = dms.int(dms["build_mould"],2,build_mould.update_id)             --升级库组id
    local barrack_build_info = _ED.build_escalate_info[""..update_group_id][""..level]
    self.max_time = tonumber(barrack_build_info.max_volumn)
end

function BarrackScience:init()
    self:initData()
	self:onInit()
    return self
end

--移除状态机
function BarrackScience:onExit()
    state_machine.remove("barrack_science_scoll_pageindex")
    state_machine.remove("barrack_science_update_cell")
    state_machine.remove("barrack_science_clear_cd")
    state_machine.remove("barrack_science_close")
    
end
