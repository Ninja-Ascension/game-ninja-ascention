LimSummonCellMainJump = class("LimSummonCellMainJumpClass", Window)
LimSummonCellMainJump.__size = nil
LimSummonCellMainJump.__num_show = 10

function LimSummonCellMainJump:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.index = 0
    self.params = nil

    local function init_lim_summon_cell_main_jump_terminal()
        local lim_summon_cell_main_jump_terminal = {
            _name = "lim_summon_cell_main_jump",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local idActivity = params._datas.idActivity
                if idActivity > 0 then
                    if LimSummonMgr:GetInstance():isValidActivity(idActivity) then
                        local function requestCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("new_recruit_main_window_close", 0, nil)

                                if nil == fwin:find("LimSummonViewMainClass") then
                                    state_machine.excute("lim_summon_view_main_window_open", 0, idActivity)
                                else
                                    state_machine.excute("lim_summon_view_main_jump_activity", 0, idActivity)
                                end
                            end
                        end
                        protocol_command.time_limit_lottery_init.param_list = idActivity
                        NetworkManager:register(protocol_command.time_limit_lottery_init.code, nil, nil, nil, nil, requestCallBack, false, nil)
                    else
                        TipDlg.drawTextDailog(tipStringInfo_lim_summon_up[9])
                        LimSummonMgr:GetInstance():removeActivity(idActivity)
                    end
                else
                    state_machine.excute("lim_summon_view_main_window_close", 0, nil)
                    state_machine.excute("new_recruit_main_window_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_cell_main_jump_terminal)
        state_machine.init()
    end

    init_lim_summon_cell_main_jump_terminal()
end

function LimSummonCellMainJump:init(params, index)
    self.path_csb = "activity/lim_summon/lim_summon_main_cell.csb"
    self.index = index
    if self.index == nil then
        self.index = 0
    end
    self.params = params

    self:initData()

    if nil ~= self.onInit then
        if self.index < LimSummonCellMainJump.__num_show then
            self:onInit(params)
        end
        self:setContentSize(LimSummonCellMainJump.__size)
    end

    self:registerOnNodeEvent(self)
    return self
end

function LimSummonCellMainJump:onInit(params)
    local root = cacher.createUIRef(self.path_csb, "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if LimSummonCellMainJump.__size == nil then
        LimSummonCellMainJump.__size = root:getContentSize()
    end

    -- ==========此处定义界面中的按钮点击事件==========

    -- 定义按钮控件
    self.Button_jump = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jump"), nil,
    {
        terminal_name = "lim_summon_cell_main_jump",
        terminal_state = 0,
        isPressedActionEnabled = true,
        idActivity = self.idActivity
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function LimSummonCellMainJump:onEnterTransitionFinish()

end

function LimSummonCellMainJump:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    local Image_jump = ccui.Helper:seekWidgetByName(root, "Image_jump")
    if Image_jump then
        Image_jump:setVisible(false)
    end

    self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
end

function LimSummonCellMainJump:initData()
    self.idActivity = self.params
    self.idIcon = LimSummonMgr:GetInstance():getIcon(self.idActivity)
end

function LimSummonCellMainJump:showData()
    -- 设置按钮的皮肤
    local pathNormal = string.format("image/cut/summoning_pagging/cut_summoning_pagging_dark_%d.png", self.idIcon)
    local pathPressed = string.format("image/cut/summoning_pagging/cut_summoning_pagging_light_%d.png", self.idIcon)

    if cc.FileUtils:getInstance():isFileExist(pathNormal) then
        self.Button_jump:loadTextureNormal(pathNormal)
    end

    if cc.FileUtils:getInstance():isFileExist(pathPressed) then
        self.Button_jump:loadTexturePressed(pathPressed)
        self.Button_jump:loadTextureDisabled(pathPressed)
    end
end

function LimSummonCellMainJump:setFocus(bFocus)
    if bFocus then
        self.Button_jump:setHighlighted(true)
        self.Button_jump:setTouchEnabled(false)
    else
        self.Button_jump:setHighlighted(false)
        self.Button_jump:setTouchEnabled(true)
    end
end

-- 红点设置
function LimSummonCellMainJump:setRedTip(isShow)
    self.Image_red:setVisible(isShow)
end

function LimSummonCellMainJump:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(self.path_csb, root)
end

function LimSummonCellMainJump:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimSummonCellMainJump:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef(self.path_csb, root)
    
    self.roots = {}
end

function LimSummonCellMainJump:clearUIInfo()

end