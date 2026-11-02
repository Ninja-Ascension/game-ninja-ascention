-----------------------------
-- 养成数码精神主界面
-----------------------------
SmCultivateSpiritWindow = class("SmCultivateSpiritWindowClass", Window)

--打开界面
local sm_cultivate_spirit_window_open_terminal = {
	_name = "sm_cultivate_spirit_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if true == funOpenDrawTip(122) then
            return
        end
		if fwin:find("SmCultivateSpiritWindowClass") == nil then
			fwin:open(SmCultivateSpiritWindow:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cultivate_spirit_window_close_terminal = {
	_name = "sm_cultivate_spirit_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("notification_center_update", 0, "push_notification_cultivate_spirit")
        fwin:close(fwin:find("UserTopInfoAClass"))
		fwin:close(fwin:find("SmCultivateSpiritWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_spirit_window_open_terminal)
state_machine.add(sm_cultivate_spirit_window_close_terminal)
state_machine.init()

function SmCultivateSpiritWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

	app.load("client.l_digital.cells.cultivate.sm_cultivate_spirit_cell")

    local function init_sm_cultivate_spirit_terminal()
		
		local sm_cultivate_spirit_update_terminal = {
            _name = "sm_cultivate_spirit_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_spirit_update_terminal)
        state_machine.init()
    end
    init_sm_cultivate_spirit_terminal()
end

function SmCultivateSpiritWindow:onUpdateDraw()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_spirit")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local rows = 2
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/rows
    local cellHeight2 = 0--state_machine.excute("sm_cultivate_spirit_cell",0,{0}):getContentSize().height
    local Hlindex = 0
    local number = #dms["ship_spirit_group"]
    local m_number = math.ceil(number/rows)
    cellHeight = m_number*(cellHeight2)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    for i=1, number do
    	local cell = state_machine.excute("sm_cultivate_spirit_cell",0,{index})
    	panel:addChild(cell)
    	if cellHeight2 == 0 then
    		cellHeight2 = cell:getContentSize().height
            cellHeight = m_number*(cellHeight2)
            sHeight = math.max(sHeight, cellHeight)
            panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    	end
        if index == 1 then
            first = cell
        end
        tWidth = tWidth + wPosition
        if (index-1)%rows ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - cellHeight2*Hlindex  
        end
        if index <= rows then
            tHeight = sHeight - cellHeight2
        end
        index = index + 1
        cell:setPosition(cc.p(tWidth,tHeight))
    end
    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    --总速度
    local Text_speed_n = ccui.Helper:seekWidgetByName(root, "Text_speed_n")
    Text_speed_n:setString(_ED.user_info.speed_sum)
end

function SmCultivateSpiritWindow:onUpdate( dt )
    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height/2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmCultivateSpiritWindow:init()
	self:onInit()
    return self
end

function SmCultivateSpiritWindow:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_spirit.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_cultivate_spirit_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
	
	self:onUpdateDraw()

    local userinfo = UserTopInfoA:new()
    local info = fwin:open(userinfo,fwin._view)
end

function SmCultivateSpiritWindow:onEnterTransitionFinish()
    
end


function SmCultivateSpiritWindow:onExit()
end

function SmCultivateSpiritWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end

