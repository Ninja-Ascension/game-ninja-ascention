-- YouTube推广Icon
FansExtensionCell = class("FansExtensionCellClass", Window)

function FansExtensionCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.fans_extension.FansExtensionWindow")

    local function init_fans_extension_cell_terminal()
        local fans_extension_cell_open_terminal = {
            _name = "fans_extension_cell_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:refushRedDot(true)
                    state_machine.excute("fans_extension_window_open",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fans_extension_cell_open_terminal)
        state_machine.init()
    end
    init_fans_extension_cell_terminal()
end

function FansExtensionCell:init()
    self:onInit()
end

function FansExtensionCell:onInit()
    local csbFansExtensionCell = csb.createNode("activity/icon/acyivity_youtubu.csb")
    local root = csbFansExtensionCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    self:onUpdateDraw()
    self:refushRedDot()
    self:drawEffect()
end

function FansExtensionCell:onUpdateDraw()
    local root = self.roots[1]

    local Button_act_but = ccui.Helper:seekWidgetByName(root, "Button_act_but")
    fwin:addTouchEventListener(
        Button_act_but,
        nil,
        {
            terminal_name = "fans_extension_cell_open",
            terminal_state = 0,
            isPressedActionEnabled = false
        },
        nil,
        0
    )

    self.redBall = cc.Sprite:create("images/ui/bar/tips.png")
    self.redBall:setAnchorPoint(cc.p(0.5, 0.5))
    self.redBall:setPosition(
        cc.p(root:getContentSize().width - self.redBall:getContentSize().width * 0.5, root:getContentSize().height - self.redBall:getContentSize().height * 0.5)
    )
    root:addChild(self.redBall)
end

function FansExtensionCell:refushRedDot(clkState)
    local showRedDot = true
    local nowSeverTime = os.time() + _ED.time_add_or_sub
    local day = math.floor(nowSeverTime / 86400)
    local openState = cc.UserDefault:getInstance():getStringForKey("fans_extension_is_open_state", "")
    if clkState then
        cc.UserDefault:getInstance():setStringForKey("fans_extension_is_open_state", day)
        cc.UserDefault:getInstance():flush()
        showRedDot = false
    end

    if day == tonumber(openState) then
        showRedDot = false
    end

    if showRedDot then
        self.redBall:setVisible(true)
    else
        self.redBall:setVisible(false)
    end
end

-- 添加图标icon动画
function FansExtensionCell:drawEffect()
    local root = self.roots[1]
    local Button_act_but = ccui.Helper:seekWidgetByName(root, "Button_act_but")
    local Panel_172_4 = ccui.Helper:seekWidgetByName(root, "Panel_172_4")

	local jsonFile = "images/ui/effice/effect_community/effect_community.json"
	local atlasFile = "images/ui/effice/effect_community/effect_community.atlas"
    
    if true == cc.FileUtils:getInstance():isFileExist(jsonFile) and Panel_172_4 then
        Panel_172_4:removeAllChildren(true)
        
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_172_4:getContentSize().width / 2, Panel_172_4:getContentSize().height / 2))
        Panel_172_4:addChild(animation)
    end
end

function FansExtensionCell:createCell()
    local cell = FansExtensionCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function FansExtensionCell:onExit()
    state_machine.remove("fans_extension_cell_open")
end
