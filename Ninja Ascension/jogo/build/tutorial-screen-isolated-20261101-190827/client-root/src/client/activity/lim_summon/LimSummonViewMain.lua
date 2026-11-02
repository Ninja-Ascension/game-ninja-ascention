LimSummonViewMain = class("LimSummonViewMainClass", Window)

-- 打开窗口
local lim_summon_view_main_window_open_terminal = {
    _name = "lim_summon_view_main_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("LimSummonViewMainClass") then
            fwin:open(LimSummonViewMain:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local lim_summon_view_main_window_close_terminal = {
    _name = "lim_summon_view_main_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimSummonViewMainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lim_summon_view_main_window_open_terminal)
state_machine.add(lim_summon_view_main_window_close_terminal)
state_machine.init()

function LimSummonViewMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._cell_list = {}    -- 切换cell列表

    app.load("client.shop.recharge.RechargeDialog")
	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")
    app.load("client.utils.CurrencyIcon")
    app.load("client.activity.lim_summon.LimSummonMgr")
    app.load("client.activity.lim_summon.LimSummonCellMainJump")
	app.load("client.activity.lim_summon.LimSummonCellPreview")
    app.load("client.activity.lim_summon.LimSummonCellRecord")
    app.load("client.activity.lim_summon.LimSummonCellShop")
    app.load("client.activity.lim_summon.LimSummonViewPreview")
    app.load("client.activity.lim_summon.LimSummonViewRecord")
    app.load("client.activity.lim_summon.LimSummonViewRule")
    app.load("client.activity.lim_summon.LimSummonViewShop")
    app.load("client.activity.lim_summon.LimSummonViewTips")

    local function init_lim_summon_view_main_terminal()
        
        local lim_summon_view_main_close_terminal =
        {
            _name = "lim_summon_view_main_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("LimSummonViewMainClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local lim_summon_view_main_recruit_terminal =
        {
            _name = "lim_summon_view_main_recruit",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local data = params._datas.info

                if instance then
                    instance:doSummon(data)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_record_terminal =
        {
            _name = "lim_summon_view_main_record",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 历史记录
                if instance then
                    state_machine.excute("lim_summon_view_record_window_open", 0, instance.idActivity)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_preview_terminal =
        {
            _name = "lim_summon_view_main_preview",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 奖励预览
                if instance then
                    state_machine.excute("lim_summon_view_preview_window_open", 0, instance.idActivity)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_shop_terminal =
        {
            _name = "lim_summon_view_main_shop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 商店
                if instance then
                    if LimSummonMgr:GetInstance():isTipCanBuyShopItem(instance.idActivity) then
                        LimSummonMgr:GetInstance():writeTipCanBuyShopItem(instance.idActivity)
                        instance:refreshReddot()
                    end
                    state_machine.excute("lim_summon_view_shop_window_open", 0, instance.idActivity)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_rule_terminal =
        {
            _name = "lim_summon_view_main_rule",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 规则界面
                state_machine.excute("lim_summon_view_rule_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_view_role_info_terminal =
        {
            _name = "lim_summon_view_main_view_role_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 查看详情
                if instance then
                    instance:viewRoleInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_refresh_summon_terminal =
        {
            _name = "lim_summon_view_main_refresh_summon",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 刷新界面
                if instance then
                    instance:refreshSummon()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_jump_activity_terminal =
        {
            _name = "lim_summon_view_main_jump_activity",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local idActivity = params
                if instance then
                    if LimSummonMgr:GetInstance():isValidActivity(idActivity) then
                        instance:changeActivity(idActivity)
                    else
                        -- 该活动已经结束
                        TipDlg.drawTextDailog(tipStringInfo_lim_summon_up[9])
                        LimSummonMgr:GetInstance():removeActivity(idActivity)
                        instance:showJumpLst()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_main_refresh_reddot_terminal =
        {
            _name = "lim_summon_view_main_refresh_reddot",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 刷新红点
                if instance then
                    instance:refreshReddot()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_view_main_close_terminal)
		state_machine.add(lim_summon_view_main_recruit_terminal)
        state_machine.add(lim_summon_view_main_record_terminal)
		state_machine.add(lim_summon_view_main_preview_terminal)
        state_machine.add(lim_summon_view_main_shop_terminal)
		state_machine.add(lim_summon_view_main_rule_terminal)
        state_machine.add(lim_summon_view_main_view_role_info_terminal)
		state_machine.add(lim_summon_view_main_refresh_summon_terminal)
        state_machine.add(lim_summon_view_main_jump_activity_terminal)
		state_machine.add(lim_summon_view_main_refresh_reddot_terminal)
        
        state_machine.init()
    end

    init_lim_summon_view_main_terminal()
end

function LimSummonViewMain:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function LimSummonViewMain:onUpdate(dt)
    if self.countTimer == nil then
        self.countTimer = 0
    end
    self.countTimer = self.countTimer + dt
    if self.countTimer >= 1 then
        -- processFrame
        self.countTimer = 0
    end

    -- 倒计时
    self:showTime()
end

function LimSummonViewMain:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/lim_summon/lim_summon_main.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.btnClose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
    {
        terminal_name = "lim_summon_view_main_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    -- 抽取1次
    self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
    {
        terminal_name = "lim_summon_view_main_recruit",
        terminal_state = 0,
        isPressedActionEnabled = true,
        info = 1
    }, nil, 0)

    -- 抽取10次
    self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
    {
        terminal_name = "lim_summon_view_main_recruit",
        terminal_state = 0,
        isPressedActionEnabled = true,
        info = 10
    }, nil, 0)

    -- 查看记录
    self.Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
    {
        terminal_name = "lim_summon_view_main_record",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    -- 奖励预览
    self.Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil,
    {
        terminal_name = "lim_summon_view_main_preview",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    -- 积分商店
    self.Button_5 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil,
    {
        terminal_name = "lim_summon_view_main_shop",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    -- 规则界面
    self.Button_6 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil,
    {
        terminal_name = "lim_summon_view_main_rule",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    -- 查看数码信息
    self.Button_view_role_info = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_view_role_info"), nil,
    {
        terminal_name = "lim_summon_view_main_view_role_info",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    

    self:onUpdateDraw()
    self:showData()
end

function LimSummonViewMain:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    -- 活动倒计时
    self.Text_activity_time = ccui.Helper:seekWidgetByName(root, "Text_activity_time")
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

    -- 抽取消耗
    self.Text_cost_1 = ccui.Helper:seekWidgetByName(root, "Text_cost_1")
    self.Panel_cost_1 = ccui.Helper:seekWidgetByName(root, "Panel_cost_1")
    self.Text_white_1 = ccui.Helper:seekWidgetByName(root, "Text_white_1")
    self.Text_red_1 = ccui.Helper:seekWidgetByName(root, "Text_red_1")
    self.Text_red_1:setVisible(false)

    self.Text_cost_2 = ccui.Helper:seekWidgetByName(root, "Text_cost_2")
    self.Panel_cost_2 = ccui.Helper:seekWidgetByName(root, "Panel_cost_2")
    self.Text_white_2 = ccui.Helper:seekWidgetByName(root, "Text_white_2")
    self.Text_red_2 = ccui.Helper:seekWidgetByName(root, "Text_red_2")
    self.Text_red_2:setVisible(false)
    -- 抽1次小红点
    self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
    self.Image_red:setVisible(false)
    -- 抽取10次小红点
    self.Image_red_2 = ccui.Helper:seekWidgetByName(root, "Image_red_2")
    -- 积分商店小红点
    self.Image_red_5 = ccui.Helper:seekWidgetByName(root, "Image_red_5")
    -- 抽取进度条和文本
    self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    self.Text_progress = ccui.Helper:seekWidgetByName(root, "Text_progress")
    -- 限定卡立绘
    self.Panel_chouka = ccui.Helper:seekWidgetByName(root, "Panel_chouka")
    self.Image_role = ccui.Helper:seekWidgetByName(root, "Image_role")
    -- 3种货币
    self.Panel_currency_1 = ccui.Helper:seekWidgetByName(root, "Panel_currency_1")
    self.Panel_currency_2 = ccui.Helper:seekWidgetByName(root, "Panel_currency_2")
    self.Panel_currency_3 = ccui.Helper:seekWidgetByName(root, "Panel_currency_3")
    -- up池跳转框
    self.ListView_jump_to_up = ccui.Helper:seekWidgetByName(root, "ListView_jump_to_up")
end

function LimSummonViewMain:initData()
    -- 更新数据

    -- 当前的活动ID
    self.idActivity = self.params
end

function LimSummonViewMain:showData()
    -- 更新显示
    self:changeActivity(self.idActivity)
end

function LimSummonViewMain:refreshReddot()
    -- 刷新红点
    if LimSummonMgr:GetInstance():isTipCanBuyShopItem(self.idActivity) then
        self.Image_red_5:setVisible(true)
    else
        self.Image_red_5:setVisible(false)
    end

    if LimSummonMgr:GetInstance():isTipCanSummonTen(self.idActivity) then
        self.Image_red_2:setVisible(true)
    else
        self.Image_red_2:setVisible(false)
    end

    LimSummonMgr:GetInstance():writeTipNewActivity(self.idActivity)

    -- 通知刷新主页
    LimSummonMgr:GetInstance():noticeRefreshMainReddot()

    self:refreshChangeReddot()
end

-- 切換按鈕红点
function LimSummonViewMain:refreshChangeReddot()
    for k,v in pairs(self._cell_list) do
        local isShow = false
        if k == "0" then 
            if  getNewShopRecruitmentFreeTime() == true or (getNewShopRecruitmentFirstLogin("ten") == true and getNewRecruitTenDiamondEnough()) or (getNewRecruitTenPropEnough() == true) then
                isShow = true
            end
        else
            if LimSummonMgr:GetInstance():isTipCanSummonTen(tonumber(k)) then
                isShow = true
            end
        end 
        v:setRedTip(isShow)
    end
end

function LimSummonViewMain:changeActivity(idActivity)
    -- 当前的活动ID
    self.idActivity = idActivity

    self:showTime()
    self:showPic()
    self:showProgress()
    self:showJumpLst()
    self:showSummonBtn()
    self:showCurrency()

    self:refreshReddot()
end

-- 显示活动时间
function LimSummonViewMain:showTime()
    local status,surplus_time = LimSummonMgr:GetInstance():getActivityTime(self.idActivity)
    
    if status == LimSummonMgr:GetInstance().enumActivityStatus.Summon then
        -- 招募时间
        self.Text_time:setString(tipStringInfo_lim_summon_up[1])
    elseif status == LimSummonMgr:GetInstance().enumActivityStatus.View then
        -- 展示时间
        self.Text_time:setString(tipStringInfo_lim_summon_up[2])
    end

    self.Text_activity_time:setString(getRedAlertTimeActivityFormat(surplus_time))
end

-- 显示活动立绘
function LimSummonViewMain:showPic()
    local idPic = LimSummonMgr:GetInstance():getMainPic(self.idActivity)

    -- 立绘
    local pathPic = string.format("image/cut/limited_time_summoning/cut_limited_time_summoning_role_%d.png", idPic)
    if cc.FileUtils:getInstance():isFileExist(pathPic) then
        self.Image_role:loadTexture(pathPic)
    end
end

-- 显示抽取进度
function LimSummonViewMain:showProgress()
    local count = LimSummonMgr:GetInstance():getSummonProgress(self.idActivity)
    local maxCount = LimSummonMgr:GetInstance().MaxCountKeepRecruit
    local percent = count/maxCount * 100

    self.LoadingBar_1:setPercent(percent)
    self.Text_progress:setString(count.."/"..maxCount)
end

-- 招募跳转普通池和up池
function LimSummonViewMain:showJumpLst()
    self._cell_list = {}
    self.ListView_jump_to_up:removeAllItems()

    -- 原招募界面
    local cell = LimSummonCellMainJump:new()
    cell:init(0)
    cell:setFocus(false)
    self.ListView_jump_to_up:addChild(cell)
    self._cell_list["0"] = cell
    -- up池活动
    local lstActivity = LimSummonMgr:GetInstance():getActivityLst()
    for i,v in pairs(lstActivity) do
        local idActivity = v   
        local cell = LimSummonCellMainJump:new()
        cell:init(idActivity)
        self.ListView_jump_to_up:addChild(cell)
        self._cell_list[""..idActivity] = cell
        if self.idActivity == idActivity then
            cell:setFocus(true)
        else
            cell:setFocus(false)
        end
    end

    self.ListView_jump_to_up:jumpToLeft()
    self.ListView_jump_to_up:requestRefreshView()
end

-- 设置1抽或10抽的btn
function LimSummonViewMain:showSummonBtn()
    -- 抽奖券ID
    local propID = LimSummonMgr:GetInstance():getIdPropSummon()
    local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)
    local pathIcon = string.format("image/common/currency/common_currency_%d.png", picIndex)

    -- 当前抽奖券数量
    local countCur = LimSummonMgr:GetInstance():getCountPropSummon()

    -- 十连抽消耗的券数
    local countCost = LimSummonMgr:GetInstance().nCostSummonTen

    self.Text_cost_1:setString("X1")
    self.Panel_cost_1:removeBackGroundImage()
    self.Panel_cost_1:setBackGroundImage(pathIcon)

    if countCur >= 1 then
        self.Text_white_1:setVisible(true)
        self.Text_red_1:setVisible(false)
    else
        self.Text_white_1:setVisible(false)
        self.Text_red_1:setVisible(true)
    end

    self.Text_cost_2:setString("X"..countCost)
    self.Panel_cost_2:removeBackGroundImage()
    self.Panel_cost_2:setBackGroundImage(pathIcon)

    if countCur >= countCost then
        self.Text_white_2:setVisible(true)
        self.Text_red_2:setVisible(false)
    else
        self.Text_white_2:setVisible(false)
        self.Text_red_2:setVisible(true)
    end
end

function LimSummonViewMain:showCurrency()
    -- 钻石
	local cell = state_machine.excute("currency_icon_create", 0, {propType = 2, propID = nil})
	self.Panel_currency_1:removeAllChildren(true)
	self.Panel_currency_1:addChild(cell)

    -- 召唤券
    local sProp = LimSummonMgr:GetInstance().sPropDataRecruit
    local lstData = zstring.split(sProp, ",", zstring.tonumber)
    local propType = lstData[1]
    local propID = lstData[2]
	cell = state_machine.excute("currency_icon_create", 0, {propType = propType, propID = propID})
	self.Panel_currency_2:removeAllChildren(true)
	self.Panel_currency_2:addChild(cell)

    -- 积分
    sProp = LimSummonMgr:GetInstance().sPropDataJifen
    lstData = zstring.split(sProp, ",", zstring.tonumber)
    propType = lstData[1]
    propID = lstData[2]
	cell = state_machine.excute("currency_icon_create", 0, {propType = propType, propID = propID})
	self.Panel_currency_3:removeAllChildren(true)
	self.Panel_currency_3:addChild(cell)
end

function LimSummonViewMain:refreshSummon()
    self:showProgress()
    self:showSummonBtn()
end

function LimSummonViewMain:doSummon(data)
    -- 展示期间无法抽取奖励
    local status,surplus_time = LimSummonMgr:GetInstance():getActivityTime(self.idActivity)
    if status == LimSummonMgr:GetInstance().enumActivityStatus.View then
        TipDlg.drawTextDailog(tipStringInfo_lim_summon_up[10])
        return
    end

    local countCost = 1
    if data == 1 then
        countCost = 1
    elseif data == 10 then
        countCost = LimSummonMgr:GetInstance().nCostSummonTen
    end

    -- 当前抽奖券数量
    local countCur = LimSummonMgr:GetInstance():getCountPropSummon()

    local function callbackSummon()
        -- 播放抽奖动画
        if fwin:find("HeroRecruitSuccessClass") ~= nil then
            fwin:close(fwin:find("HeroRecruitSuccessClass"))
        end

        if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
            fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
        end

        getSceneReward(64)
        _ED.show_reward_list_group_ex = {}
        if data == 1 then
            local obj = HeroRecruitSuccess:new()
            obj:setRanking(nil, 16, true)
            fwin:open(obj, fwin._ui)
        elseif data == 10 then
            local obj = HeroRecruitSuccessTen:new()
            obj:setRanking(nil, 16, true)
            fwin:open(obj, fwin._ui)
        end

        _ED.prop_chest_store_recruiting = false

        -- 刷新进度条和抽取按钮
        state_machine.excute("lim_summon_view_main_refresh_summon", 0, nil)

        -- 刷新界面内红点
        state_machine.excute("lim_summon_view_main_refresh_reddot", 0, nil)
        
        -- 通知红点
        LimSummonMgr:GetInstance():noticeRefreshMainReddot()
    end

    local function sendMsgDoSummon(data)
        _ED.new_prop_object = {}
        _ED.recruit_success_ship_id = nil
        _ED.new_reward_object = {}
        _ED.prop_chest_store_recruiting = true

        LimSummonMgr:GetInstance():RequestDraw(self.idActivity, data, callbackSummon, "lim_summon_view_main_recruit")
    end

    if countCur < countCost then
        -- 弹出提示框
        local params = {}
        params.type = data
        params.countNeed = countCost - countCur
        params.callback = sendMsgDoSummon
        state_machine.excute("lim_summon_view_tips_window_open", 0, params)
    else
        sendMsgDoSummon(data)
    end
end

function LimSummonViewMain:viewRoleInfo()
    -- 查看详情
    local infoItem = LimSummonMgr:GetInstance():getUpRewardItem(self.idActivity)
    if infoItem == "" then
        return
    end

    local lstData = zstring.split(infoItem, ",", zstring.tonumber)
    local type = lstData[1]
    local idProp = lstData[2]
    if type == 13 then
        local ship_mould_id = idProp
        state_machine.excute("sm_role_information_open", 0, {ship_mould_id})
    end
end

function LimSummonViewMain:onExit()
    state_machine.remove("lim_summon_view_main_close")
    state_machine.remove("lim_summon_view_main_recruit")
    state_machine.remove("lim_summon_view_main_record")
    state_machine.remove("lim_summon_view_main_preview")
    state_machine.remove("lim_summon_view_main_shop")
    state_machine.remove("lim_summon_view_main_rule")
    state_machine.remove("lim_summon_view_main_view_role_info")
    state_machine.remove("lim_summon_view_main_refresh_summon")
    state_machine.remove("lim_summon_view_main_jump_activity")
    state_machine.remove("lim_summon_view_main_refresh_reddot")
end

function LimSummonViewMain:close()
    LimSummonMgr:GetInstance():Clear()
end

function LimSummonViewMain:destroy(window)
 
end