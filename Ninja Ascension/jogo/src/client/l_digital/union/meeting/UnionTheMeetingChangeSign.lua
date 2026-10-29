--------------------------------------------------------------------------------------------------------------
--  说明：
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingChangeSign = class("UnionTheMeetingChangeSignClass", Window)
UnionTheMeetingChangeSign.isUnion = false
--打开界面
local union_the_meeting_change_sign_open_terminal = {
    _name = "union_the_meeting_change_sign_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local UnionTheMeetingChangeSignWindow = fwin:find("UnionTheMeetingChangeSignClass")
        if UnionTheMeetingChangeSignWindow ~= nil and UnionTheMeetingChangeSignWindow:isVisible() == true then
            return true
        end
        if params ~= nil and params ~= "" then
            UnionTheMeetingChangeSign.isUnion = true
        else
            UnionTheMeetingChangeSign.isUnion = false
        end
		fwin:open(UnionTheMeetingChangeSign:createCell(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_change_sign_close_terminal = {
    _name = "union_the_meeting_change_sign_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingChangeSign:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_change_sign_open_terminal)
state_machine.add(union_the_meeting_change_sign_close_terminal)
state_machine.init()

function UnionTheMeetingChangeSign:ctor()
	self.super:ctor()
	self.roots = {}

	self.selectkuangIndex = -1
	self.selecttuIndex = -1
	self.suo2Image = false
    self.suo3Image = false
    self.isUnion = false

    app.load("client.l_digital.cells.union.union_logo_icon_cell")
	 -- Initialize union the meeting place trends machine.
    local function init_union_the_meeting_change_sign_terminal()
		
		-- 隐藏界面
        local union_the_meeting_change_sign_hide_event_terminal = {
            _name = "union_the_meeting_change_sign_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_the_meeting_change_sign_show_event_terminal = {
            _name = "union_the_meeting_change_sign_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(union_the_meeting_change_sign_hide_event_terminal)
        state_machine.add(union_the_meeting_change_sign_show_event_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place trends  machine.
    init_union_the_meeting_change_sign_terminal()

end

function UnionTheMeetingChangeSign:onHide()
	self:setVisible(false)
end

function UnionTheMeetingChangeSign:onShow()
	self:setVisible(true)
end

function UnionTheMeetingChangeSign:updateDraw()
    local root = self.roots[1]
    local cell_list = {}
    local param = dms.string(dms["union_config"], 2, union_config.param)
    local tSortedHeroes = zstring.split(param ,",")
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_legion_icon")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/5
    local Hlindex = 0
    local number = #tSortedHeroes
    local m_number = math.ceil(number/5)
    cellHeight = m_number*(m_ScrollView:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    for j, v in pairs(tSortedHeroes) do
        local cell = CnionLogoIconCell:createCell()
        if  UnionTheMeetingChangeSign.isUnion == true then
            cell:init(1,tonumber(v))
        else
            cell:init(1,tonumber(v),1)
        end
        
        
        panel:addChild(cell)
        table.insert(cell_list, cell)
        if j == 1 then
            first = cell
        end
        tWidth = tWidth + wPosition
        if (j-1)%5 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - wPosition*Hlindex  
        end
        if j <= 5 then
            tHeight = sHeight - wPosition
        end
        cell:setPosition(cc.p(tWidth,tHeight))
        cell:setVisible(false)
    end
    m_ScrollView:jumpToTop()

    for i, v in pairs(cell_list) do
        if #cell_list >= 1 then
            local t = 0.1 + 0.1 * (i - 1)
            v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
                sender:setVisible(true)
            end), cc.ScaleTo:create(0.1, 1)}))
        end
    end
end

function UnionTheMeetingChangeSign:onInit()
	self:updateDraw()
end

function UnionTheMeetingChangeSign:onEnterTransitionFinish()
    local csbUnionTheMeetingChangeSignCell = csb.createNode("legion/legion_biaozhi.csb")
    local root = csbUnionTheMeetingChangeSignCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingChangeSignCell)
	 local action = csb.createTimeline("legion/legion_biaozhi.csb")

    csbUnionTheMeetingChangeSignCell:runAction(action)
 
    action:play("window_open", false)
	
	
    self:init()

     -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123"), nil, 
    {
        terminal_name = "union_the_meeting_change_sign_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function UnionTheMeetingChangeSign:init()
	self:onInit()
	return self
end

function UnionTheMeetingChangeSign:onExit()

end

function UnionTheMeetingChangeSign:createCell( ... )
    local cell = UnionTheMeetingChangeSign:new()
	
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingChangeSign:closeCell( ... )
    local UnionTheMeetingChangeSignWindow = fwin:find("UnionTheMeetingChangeSignClass")
    if UnionTheMeetingChangeSignWindow == nil then
        return
    end
    fwin:close(UnionTheMeetingChangeSignWindow)
end