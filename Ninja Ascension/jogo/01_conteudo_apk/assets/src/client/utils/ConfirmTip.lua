-- ----------------------------------------------------------------------------------------------------
-- 说明：二级确认界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：李彪
-- 时间 : 04.19
-------------------------------------------------------------------------------------------------------
ConfirmTip = class("ConfirmTipClass", Window)
    
function ConfirmTip:ctor()
    self.super:ctor()
    self.roots = {}
    self._instance = nil
    self._callback = nil
    self._txt = ""
    self.params = nil -- {terminal_name = "", terminal_state = 0, _msg = "", _datas= {}}

    -- Initialize ConfirmTip state machine.
    local function init_ConfirmTip_terminal()
		-- 界面确定按钮
        local confirm_tip_ok_terminal = {
            _name = "confirm_tip_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_adventure then
                    app.load("client.adventure.shop.AdventureRecharge")
                    -- 跳转到商店充值界面 排位赛层级比较高
                    local Window1 = fwin:find("AdventureArenaWarcraftClass")
                    local Window2 = fwin:find("AdventureArenaWarcraftListClass")
                    local Window3 = fwin:find("AdventureBattleFormationClass")
                    if Window1~= nil or Window2 ~= nil or Window3 ~= nil then 
                        fwin:close(fwin:find("AdventureArenaWarcraftShopClass"))
                        fwin:open(AdventureRecharge:new():init(), fwin._windows)
                    else
                        fwin:open(AdventureRecharge:new():init(), fwin._view)
                    end
                    fwin:close(fwin:find("AdventureRecruitWithGoldClass"))
                else
                    if instance.params ~= nil then
                        state_machine.excute(instance.params.terminal_name, instance.params.terminal_state, {status = 1, _datas = instance.params._datas})
                    else
                        instance._callback(instance._instance, 0,self._self)
                    end
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面取消按钮
        local confirm_tip_cancel_terminal = {
            _name = "confirm_tip_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                if instance._isExecuteCloseCallback == true then
                    if instance.params ~= nil then
                        state_machine.excute(instance.params.terminal_name, instance.params.terminal_state, {status = 2, _datas = instance.params._datas})
                    else
                        instance._callback(instance._instance, 1)
                    end
                end
			
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面关闭
        local confirm_tip_close_terminal = {
            _name = "confirm_tip_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if instance._isExecuteCloseCallback == true then
                    if instance.params ~= nil then
                        state_machine.excute(instance.params.terminal_name, instance.params.terminal_state, {status = 3, _datas = instance.params._datas})
                    else
                        instance._callback(instance._instance, 1)
                    end
                end
                
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(confirm_tip_close_terminal)
        state_machine.add(confirm_tip_ok_terminal)
        state_machine.add(confirm_tip_cancel_terminal)
        state_machine.init()
    end
    
    -- call func init ConfirmTip state machine.
    init_ConfirmTip_terminal()
end

function ConfirmTip:onEnterTransitionFinish()
    local csbConfirmTip = csb.createNode("utils/prompt_1.csb")
    self:addChild(csbConfirmTip)
	
	local root = csbConfirmTip:getChildByName("root")
    table.insert(self.roots, root)
	
	--提示文本
    local drawText = ""
    if self.params ~= nil then
        drawText = self.params._msg
    elseif self._txt ~= nil and self._txt ~= "" then
	   drawText = self._txt   
    end
    local titleName = ccui.Helper:seekWidgetByName(root, "Text_141")
    if titleName ~= nil then
        titleName:setString(drawText or " ")
    end

	local ok_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, {
		terminal_name = "confirm_tip_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
	local cancel_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, {
		terminal_name = "confirm_tip_cancel", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
	local cancel_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {
		terminal_name = "confirm_tip_close", 
		terminal_state = 1,
		taget = self
		}, nil, 0)
    local cancel_button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prompt_close"), nil, {
        terminal_name = "confirm_tip_close", 
        terminal_state = 1,
        touch_black = true,
        taget = self
        }, nil, 3)
    local cancel_button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, {
        terminal_name = "confirm_tip_close", 
        terminal_state = 1,
        taget = self
        }, nil, 3)
    local Panel_6_13 = ccui.Helper:seekWidgetByName(root, "Panel_6_13")
    if self.isShowAni ~= nil and self.isShowAni == false then
        Panel_6_13:setVisible(false)
    end
end

function ConfirmTip:init(instance, callback, txt, params,cell , isShowAni, isExecuteCloseCallback)
	self._instance = instance
	self._callback = callback
	self._txt = txt
    self.params = params
    self._self = cell
    if isShowAni ~= nil then
        self.isShowAni = isShowAni
    end

    self._isExecuteCloseCallback = (isExecuteCloseCallback == nil) and true or isExecuteCloseCallback

    return self
end

function ConfirmTip:onExit()
	state_machine.remove("confirm_tip_ok")
	state_machine.remove("confirm_tip_cancel")
	state_machine.remove("confirm_tip_close")
	
end