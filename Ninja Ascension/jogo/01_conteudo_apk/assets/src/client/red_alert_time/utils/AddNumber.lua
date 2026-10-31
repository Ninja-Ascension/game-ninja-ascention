-----------------------------
--属性增加
-----------------------------
AddNumber = class("AddNumberClass", Window)

local add_number_window_open_terminal = {
    _name = "add_number_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("add_number_window_close",0,"")
        if nil == fwin:find("AddNumberClass") then
            local show_type = params[1]
            local text_table = params[2]
            fwin:open(AddNumber:new():init(show_type,text_table), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local add_number_window_close_terminal = {
    _name = "add_number_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("AddNumberClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(add_number_window_open_terminal)
state_machine.add(add_number_window_close_terminal)
state_machine.init()

function AddNumber:ctor()
    self.super:ctor()
    self.roots = {}
    self.show_type = nil
    self.text_table = nil
    -- 1、2、3、4、5、6升星界面星格图标
    --7升星界面动画角色位置
    --8装备界面动画角色位置
    --9、10、11、12、13、14装备界面宝石图标
    --15装备大图标位置
    --16 17 18 19 20 21 22 23 24 兵营科技升级
    -- 28 羁绊
end

function AddNumber:onEnterTransitionFinish()
    local root = self.roots[1]
    local Panel_add = ccui.Helper:seekWidgetByName(root, "Panel_add_"..self.show_type)
    for i,text in pairs(self.text_table) do
        local textfont = nil
        if self.show_type == 28 then
            textfont = ccui.RichText:create()
            textfont:ignoreContentAdaptWithSize(false)  
            local re1 = nil
            re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, text , "fonts/simhei.ttf",22)
            textfont:pushBackElement(re1)
            textfont:setContentSize(cc.size(260,24))
        else
            textfont = cc.LabelBMFont:create(text,"fonts/add_up.fnt")
            textfont:setScale(0.9)
        end
            textfont:setVisible(false)
            Panel_add:addChild(textfont)
        

        local pos = cc.p(textfont:getPositionX(),textfont:getPositionY()+30)  
        local pos2 = cc.p(textfont:getPositionX(),textfont:getPositionY()+110)  
        local function playOver()
            if i == #self.text_table then
                state_machine.excute("add_number_window_close",0,"")
            end
        end
        local function showText()
            textfont:setVisible(true)
        end
        local action = cc.Sequence:create(cc.DelayTime:create(0.2*(i-1)),cc.CallFunc:create(showText),cc.Spawn:create(cc.FadeIn:create(0.2),cc.ScaleTo:create(0.2,1.05),cc.MoveTo:create(0.2,pos)),
            cc.ScaleTo:create(0.1,1),
            cc.DelayTime:create(0.8),
            cc.Spawn:create(cc.ScaleTo:create(0.5,0.9),cc.MoveTo:create(0.5,pos2))
            ,cc.CallFunc:create(playOver))
        textfont:runAction(action)
    end
    if ( self.show_type >= 16 and self.show_type <= 24 ) or  self.show_type == 8 then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_barrack_up/effice_barrack_up.ExportJson")
        local armature = ccs.Armature:create("effice_barrack_up")
        -- armature:setPosition(cc.p(Panel_add:getContentSize().width/2, Panel_add:getContentSize().height/2))
        armature:setPosition(cc.p(0,Panel_add:getContentSize().height - 50))
        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
        Panel_add:addChild(armature)
        armature:getAnimation():playWithIndex(0,0,0)
        armature._invoke = function(armatureBack)
            armature:removeFromParent(true)
        end
    end
end

function AddNumber:onUpdateDraw()
    local root = self.roots[1]
end

function AddNumber:init(show_type,text_table)
    self.show_type = show_type
    self.text_table = text_table
	self:onInit()
    return self
end

function AddNumber:onInit( )
    local csbItem = csb.createNode(config_csb.utils.add_number)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:onUpdateDraw() 
end


function AddNumber:onExit()

end
