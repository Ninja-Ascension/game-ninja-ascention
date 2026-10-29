-- 组合卡道具ICON

CombinePropCell = class("CombinePropCellClass", Window)

function CombinePropCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.combine_prop.CombinePropWindow")

    local function init_CombinePropCell_terminal()

    end
    init_CombinePropCell_terminal()
end

function CombinePropCell:init()
    self:onInit()
end

function CombinePropCell:onInit()
    local csbCombinePropCell = csb.createNode("activity/icon/activity_zhk_tuisong.csb")	
    local root = csbCombinePropCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    local Button_act_but = ccui.Helper:seekWidgetByName(root,"Button_act_but")
    fwin:addTouchEventListener(Button_act_but, nil, 
        {
            terminal_name = "combine_prop_window_open", 
            terminal_state = 0, 
            isPressedActionEnabled = false
        },
        nil,0)

    local ball = cc.Sprite:create("images/ui/bar/tips.png")
    ball:setAnchorPoint(cc.p(0.5, 0.5))
    ball:setPosition(cc.p(Button_act_but:getContentSize().width-ball:getContentSize().width*0.5, Button_act_but:getContentSize().height-ball:getContentSize().height*0.5))
    Button_act_but:addChild(ball)

end

function CombinePropCell:createCell()
	local cell = CombinePropCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function CombinePropCell:onExit()

end