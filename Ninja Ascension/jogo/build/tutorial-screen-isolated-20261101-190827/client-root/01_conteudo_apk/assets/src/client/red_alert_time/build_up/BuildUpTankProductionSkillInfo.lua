-- ------------------------------------------------------------------------------------------------------------
--  说明：红色坦克技能说明信息
-- ------------------------------------------------------------------------------------------------------------
BuildUpTankProductionSkillInfo = class("BuildUpTankProductionSkillInfoClass", Window)

--打开界面
local build_up_tank_production_skill_info_window_open_terminal = {
    _name = "build_up_tank_production_skill_info_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpTankProductionSkillInfoClass") == nil then
            local _win = BuildUpTankProductionSkillInfo:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_tank_production_skill_info_window_close_terminal = {
    _name = "build_up_tank_production_skill_info_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpTankProductionSkillInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_tank_production_skill_info_window_open_terminal)
state_machine.add(build_up_tank_production_skill_info_window_close_terminal)
state_machine.init()

function BuildUpTankProductionSkillInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._telent_id = 0
     -- Initialize alert_home state machine.
    local function init_build_up_tank_production_skill_info_terminal()

    end
    -- call func alert_home create state machine.
    init_build_up_tank_production_skill_info_terminal()
end

--显示
function BuildUpTankProductionSkillInfo:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpTankProductionSkillInfo:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpTankProductionSkillInfo:onInit()
    local csbItem = csb.createNode(config_csb.props.base_res_yield_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_tank_production_skill_info_window_close", 
        terminal_state = 0, 
    }, nil, 1)

    self:onUpdateDraw()
end

-- 显示信息
function BuildUpTankProductionSkillInfo:onUpdateDraw()
    local root = self.roots[1]
    local Text_res_yield_infor = ccui.Helper:seekWidgetByName(root, "Text_res_yield_infor")
    local Text_res_yield_infor_prompt = ccui.Helper:seekWidgetByName(root, "Text_res_yield_infor_prompt")

    local telent_name = dms.string(dms["talent_mould"], self._telent_id, talent_mould.talent_name)
    local telent_des = dms.string(dms["talent_mould"], self._telent_id, talent_mould.talent_describe)
    Text_res_yield_infor:setString(telent_name)
    Text_res_yield_infor_prompt:setString(telent_des)
end

--初始化
function BuildUpTankProductionSkillInfo:init(params)
    self._telent_id = params[1]
    self:onInit()
end

--移除状态机
function BuildUpTankProductionSkillInfo:onExit()

end