--------------------------------------------------------------------------------------------------------------
--  说明：城池解锁小icon
--------------------------------------------------------------------------------------------------------------
HomeBuildUnlockCell = class("HomeBuildUnlockCellClass", Window)
HomeBuildUnlockCell.__size = nil

--创建cell
local home_build_unlock_create_cell_terminal = {
    _name = "home_build_unlock_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local build_data = params[1]
        local cell = HomeBuildUnlockCell:new()
        cell:init(build_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_build_unlock_create_cell_terminal)
state_machine.init()

function HomeBuildUnlockCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.build_data = nil

end

function HomeBuildUnlockCell:updateDraw()
    local root = self.roots[1]
    local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv")
    if self.build_data.update_id == 17 then 
        Text_skill_lv:setString(string.format(red_alert_all_str[13],self.build_data.level))
    else
        Text_skill_lv:setString(string.format(red_alert_all_str[13],self.build_data.level + 1))
    end
    local Panel_skill = ccui.Helper:seekWidgetByName(root,"Panel_skill")
    local pic = dms.string(dms["build_mould"],self.build_data.update_id,build_mould.pic)
    -- Panel_skill:setBackGroundImage("images/ui/role_skills/build_icon/build_icon_".._ED.user_info.user_force.."_".. pic ..".png")
    Panel_skill:setBackGroundImage(string.format(config_res.images.ui.role_skills.build_icon.build_icon_png,_ED.user_info.user_force) .."_"..pic..".png")


    local build_id = self.build_data.update_id
    local function buttonTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        if ccui.TouchEventType.began == evenType then
            local function openOtherWindow()
                if self.open_window == false then
                    state_machine.excute("build_level_up_mine_cell_window_open",0,{build_id,cc.p(__spoint.x,__spoint.y)})
                    self.open_window = true
                else
                    state_machine.excute("build_level_up_mine_cell_window_close", 0, 0)
                end
            end 
            self.open_window = false        
            local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
            self:stopAllActions()
            self:runAction(action)
        elseif ccui.TouchEventType.moved == evenType then

        elseif ccui.TouchEventType.canceled == evenType then
            self:stopAllActions()
            state_machine.excute("build_level_up_mine_cell_window_close", 0, 0)
        elseif ccui.TouchEventType.ended == evenType then
            self:stopAllActions()
            state_machine.excute("build_level_up_mine_cell_window_close", 0, 0)
        end
    end
    Panel_skill:setTouchEnabled(true)
    fwin:addTouchEventListener(Panel_skill, buttonTouchEvent, 
    {
        terminal_state = 0, 
        add_index = i,
    }, nil, 0)
end


function HomeBuildUnlockCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.barrack.barrack_science_icon_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    if HomeBuildUnlockCell.__size == nil then
        HomeBuildUnlockCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function HomeBuildUnlockCell:onEnterTransitionFinish()

end

function HomeBuildUnlockCell:init( build_data)
    self.build_data = build_data
    self:onInit()
    self:setContentSize(HomeBuildUnlockCell.__size)
    return self
end

function HomeBuildUnlockCell:onExit()
    
end