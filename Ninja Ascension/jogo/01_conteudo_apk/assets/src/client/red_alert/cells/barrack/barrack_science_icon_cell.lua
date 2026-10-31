--------------------------------------------------------------------------------------------------------------
--  说明：兵营科技图片cell
--------------------------------------------------------------------------------------------------------------
BarrackScienceIconCell = class("BarrackScienceIconCellClass", Window)
BarrackScienceIconCell.__size = nil

--创建cell
local barrack_science_icon_create_cell_terminal = {
    _name = "barrack_science_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local barrack_id = params[1]
        local from_type = params[2]
        local cell = BarrackScienceIconCell:new()
        cell:init(barrack_id,from_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(barrack_science_icon_create_cell_terminal)
state_machine.init()

function BarrackScienceIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.barrack_id = nil
    self.from_type = nil -- 1 兵营科技   2  兵营科技升级 --3兵营解锁

end

function BarrackScienceIconCell:updateDraw()
    local root = self.roots[1]

    if self.from_type == 3 then
        local level = dms.int(dms["teach_upgrade_param"],self.barrack_id,teach_upgrade_param.level)
        local group_id = dms.int(dms["teach_upgrade_param"],self.barrack_id,teach_upgrade_param.group_id)
        local pic_index = dms.int(dms["teach_escalate_param"],group_id,teach_escalate_param.pic_index)
        local Panel_skill = ccui.Helper:seekWidgetByName(root,"Panel_skill")
        Panel_skill:setBackGroundImage("images/ui/role_skills/barrack_science/barrack_science_skills_" .. pic_index .. ".png")
        local Text_skill_lv = ccui.Helper:seekWidgetByName(root,"Text_skill_lv")
        Text_skill_lv:setString(string.format(red_alert_all_str[13],level + 1))
        Panel_skill:setTouchEnabled(true)

        local function buttonTouchEvent(sender, evenType)
            local __spoint = sender:getTouchBeganPosition()
            if ccui.TouchEventType.began == evenType then
                local function openOtherWindow( ... )
                    if self.open_window == false then
                        state_machine.excute("build_level_up_skill_introduce_cell_window_open",0,{
                            self.barrack_id,cc.p(__spoint.x,__spoint.y)
                            })
                        self.open_window = true
                    else
                        state_machine.excute("build_level_up_skill_introduce_cell_window_close", 0, 0)
                    end
                end 
                self.open_window = false        
                local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                self:stopAllActions()
                self:runAction(action)
            elseif ccui.TouchEventType.moved == evenType then

            elseif ccui.TouchEventType.canceled == evenType then
                self:stopAllActions()
                state_machine.excute("build_level_up_skill_introduce_cell_window_close", 0, 0)
            
            elseif ccui.TouchEventType.ended == evenType then
                self:stopAllActions()
                state_machine.excute("build_level_up_skill_introduce_cell_window_close", 0, 0)
            end
        end

        --移除技能        
        fwin:addTouchEventListener(Panel_skill, buttonTouchEvent, nil, nil, 0)

        
    else
        local level = _ED.barracks_info[""..self.barrack_id].barrack_level
        local pic_index = _ED.barracks_info[""..self.barrack_id].pic_index
        local Panel_skill = ccui.Helper:seekWidgetByName(root,"Panel_skill")
        Panel_skill:setBackGroundImage("images/ui/role_skills/barrack_science/barrack_science_skills_" .. pic_index .. ".png")

        local Text_skill_lv = ccui.Helper:seekWidgetByName(root,"Text_skill_lv")
        Text_skill_lv:setString(string.format(red_alert_all_str[13],level))

        if self.from_type == 2 then
            Text_skill_lv:setVisible(false)
        end
    end
end


function BarrackScienceIconCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.barrack.barrack_science_icon_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    if BarrackScienceIconCell.__size == nil then
        BarrackScienceIconCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function BarrackScienceIconCell:onEnterTransitionFinish()

end

function BarrackScienceIconCell:init( barrack_id , from_type)
    self.barrack_id = barrack_id
    self.from_type = from_type
    self:onInit()
    self:setContentSize(BarrackScienceIconCell.__size)
    return self
end

function BarrackScienceIconCell:onExit()
    
end