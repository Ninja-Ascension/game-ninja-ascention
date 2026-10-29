--------------------------------------------------------------------------------------------------------------
--  说明：主公技icon
--------------------------------------------------------------------------------------------------------------
MajestyIconCell = class("MajestyIconCellClass", Window)
MajestyIconCell.__size = nil

--创建cell
local majesty_icon_create_cell_terminal = {
    _name = "majesty_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local majesty_id = params[1]
        local cell = MajestyIconCell:new()
        cell:init(majesty_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(majesty_icon_create_cell_terminal)
state_machine.init()

function MajestyIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.majesty_id = nil

end

function MajestyIconCell:updateDraw()
    local root = self.roots[1]
    local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv")
    Text_skill_lv:setString("")
    local Image_add = ccui.Helper:seekWidgetByName(root,"Image_add")
    if self.majesty_id == nil then
        Image_add:setVisible(true)
        return
    end
    local Panel_skill = ccui.Helper:seekWidgetByName(root,"Panel_skill")
    local skill_pic = dms.int(dms["majesty_skill"],self.majesty_id,majesty_skill.skill_pic)
    Panel_skill:setBackGroundImage("images/ui/role_skills/protagonist_skills/protagonist_skills_".. skill_pic .. ".png")


    local function buttonTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        if ccui.TouchEventType.began == evenType then
            local function openOtherWindow( ... )
                if self.open_window == false then
                    state_machine.excute("protagonist_skills_infor_window_open",0,{self.majesty_id,cc.p(__spoint.x,__spoint.y)})
                    self.open_window = true
                else
                    state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
                end
            end 
            self.open_window = false        
            local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
            self:stopAllActions()
            self:runAction(action)
        elseif ccui.TouchEventType.moved == evenType then

        elseif ccui.TouchEventType.canceled == evenType then
            self:stopAllActions()
            state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
        
        elseif ccui.TouchEventType.ended == evenType then
            self:stopAllActions()
            state_machine.excute("protagonist_skills_infor_window_close", 0, 0)
        end
    end
    Panel_skill:setTouchEnabled(true)
    fwin:addTouchEventListener(Panel_skill, buttonTouchEvent, 
    {
        terminal_state = 0, 
        add_index = i,
    }, nil, 0)
end


function MajestyIconCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.barrack.barrack_science_icon_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    if MajestyIconCell.__size == nil then
        MajestyIconCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function MajestyIconCell:onEnterTransitionFinish()

end

function MajestyIconCell:init( majesty_id)
    self.majesty_id = majesty_id
    self:onInit()
    self:setContentSize(MajestyIconCell.__size)
    return self
end

function MajestyIconCell:onExit()
    
end