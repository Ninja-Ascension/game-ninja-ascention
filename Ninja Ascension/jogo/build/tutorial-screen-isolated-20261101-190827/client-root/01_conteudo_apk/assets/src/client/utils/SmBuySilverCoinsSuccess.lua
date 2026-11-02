-----------------------------
-- 购买银币成功
-----------------------------
SmBuySilverCoinsSuccess = class("SmBuySilverCoinsSuccessClass", Window)

--打开界面
local sm_buy_silver_coins_success_open_terminal = {
	_name = "sm_buy_silver_coins_successopen",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmBuySilverCoinsSuccessClass") == nil then
			fwin:open(SmBuySilverCoinsSuccess:new():init(params), fwin._windows)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_buy_silver_coins_success_open_terminal)
state_machine.init()

function SmBuySilverCoinsSuccess:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.isDouble = false
    local function init_sm_buy_silver_coins_successterminal()

        --刷新界面
        local sm_buy_silver_coins_successupdate_draw_page_terminal = {
            _name = "sm_buy_silver_coins_successupdate_draw_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭界面
        local sm_buy_silver_coins_success_close_terminal = {
            _name = "sm_buy_silver_coins_success_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("window_close", false)
                -- fwin:close(fwin:find("SmBuySilverCoinsSuccessClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_buy_silver_coins_success_close_terminal)
        state_machine.add(sm_buy_silver_coins_successupdate_draw_page_terminal)
        state_machine.init()
    end
    init_sm_buy_silver_coins_successterminal()
end


function SmBuySilverCoinsSuccess:init(params)
    self.m_type = params[1]
    self.number = params[2]
	self:onInit()
    return self
end

function SmBuySilverCoinsSuccess:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local function changeActionCallback( armatureBack ) 
        armatureBack:removeFromParent(true)
    end

    local Panel_dh = ccui.Helper:seekWidgetByName(root,"Panel_dh")
    Panel_dh:removeAllChildren(true)
    local jsonFile = "sprite/sprite_dianjin_jb.json"
    local atlasFile = "sprite/sprite_dianjin_jb.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)

    local resetCountElement = dms.element(dms["base_consume"], 62)
    local maxCount = dms.atoi(resetCountElement, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    local activity = _ED.active_activity[84]
    --今天定金次数|是否暴击了|双倍结束时间
    local datas = zstring.split(activity.activity_params, ",")

    local reworld = getSceneReward(7)

    local Image_chenggong = ccui.Helper:seekWidgetByName(root,"Image_chenggong")
    local Image_baoji = ccui.Helper:seekWidgetByName(root,"Image_baoji")
    if tonumber(datas[2]) > 0 then
        Image_chenggong:setVisible(false)
        Image_baoji:setVisible(true)
    else
        Image_chenggong:setVisible(true)
        Image_baoji:setVisible(false)
    end
    if tonumber(self.m_type) > 1 then
        --10
        ccui.Helper:seekWidgetByName(root,"Panel_danci"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Panel_shici"):setVisible(true)
        --点金次数
        local Text_dianjin_n = ccui.Helper:seekWidgetByName(root,"Text_dianjin_n")
        Text_dianjin_n:setString(self.number)
        --暴击次数
        local Text_baoji_n = ccui.Helper:seekWidgetByName(root,"Text_baoji_n")
        Text_baoji_n:setString(datas[2])

        local Text_money_n_2 = ccui.Helper:seekWidgetByName(root,"Text_money_n_2")
        Text_money_n_2:setString("+"..reworld.show_reward_list[1].item_value)
        local Image_double_0 = ccui.Helper:seekWidgetByName(root,"Image_double_0")
        if _ED.active_activity[90] ~= nil and zstring.tonumber(datas[1]) <= dms.int(dms["activity_config"], 15, pirates_config.param) then
            --双倍
            Image_double_0:setVisible(true)
        else
            --普通
            Image_double_0:setVisible(false)
        end
    else
        --1
        ccui.Helper:seekWidgetByName(root,"Panel_danci"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Panel_shici"):setVisible(false)
        local Text_money_n = ccui.Helper:seekWidgetByName(root,"Text_money_n")
        Text_money_n:setString("+"..reworld.show_reward_list[1].item_value)
        local Image_double = ccui.Helper:seekWidgetByName(root,"Image_double")
        if _ED.active_activity[90] ~= nil and zstring.tonumber(datas[1]) <= maxCount then
            --双倍
            Image_double:setVisible(true)
        else
            --普通
            Image_double:setVisible(false)
        end
    end

end

function SmBuySilverCoinsSuccess:onInit()
    local csbItem = csb.createNode("utils/sm_dianjinshou_success.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    local action = csb.createTimeline("utils/sm_dianjinshou_success.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    playEffect(formatMusicFile("effect", 9980))
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            fwin:close(self)
        end
        
    end)

    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_xzjl"), nil, 
    {
        terminal_name = "sm_buy_silver_coins_success_close",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

end

function SmBuySilverCoinsSuccess:onEnterTransitionFinish()
    
end


function SmBuySilverCoinsSuccess:onExit()
end

