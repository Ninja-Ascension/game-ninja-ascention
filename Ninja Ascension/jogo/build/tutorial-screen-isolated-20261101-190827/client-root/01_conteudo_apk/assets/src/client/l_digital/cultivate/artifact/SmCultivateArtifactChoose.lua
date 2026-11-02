-----------------------------

SmCultivateArtifactChoose = class("SmCultivateArtifactChooseClass", Window)

local sm_cultivate_artifact_choose_open_terminal = {
	_name = "sm_cultivate_artifact_choose_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateArtifactChooseClass") == nil then
			fwin:open(SmCultivateArtifactChoose:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_artifact_choose_open_terminal)
state_machine.init()

function SmCultivateArtifactChoose:ctor()
	self.super:ctor()
	self.roots = {}

    self._isAuto = false
    self._aritfact_id = 0

    local function init_sm_cultivate_artifact_choose_terminal()
		local sm_cultivate_artifact_choose_isAuto_terminal = {
            _name = "sm_cultivate_artifact_choose_isAuto",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._isAuto = not instance._isAuto
                    instance:chooseState()
                end
                state_machine.excute("sm_cultivate_artifact_info_update_add_attr_info", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_choose_get_choose_info_terminal = {
            _name = "sm_cultivate_artifact_choose_get_choose_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = ""
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local root = instance.roots[1]
                    local ListView_sxsx = ccui.Helper:seekWidgetByName(root, "ListView_sxsx")
                    for k,v in pairs(ListView_sxsx:getItems()) do
                        if v._isChoose == true then
                            if info == "" then
                                info = info..""..k
                            else
                                info = info..","..k
                            end
                        end
                    end
                end
                return info
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_artifact_choose_isAuto_terminal)
        state_machine.add(sm_cultivate_artifact_choose_get_choose_info_terminal)
        state_machine.init()
    end
    init_sm_cultivate_artifact_choose_terminal()
end

function SmCultivateArtifactChoose:chooseState( ... )
    local root = self.roots[1]
    local ListView_sxsx = ccui.Helper:seekWidgetByName(root, "ListView_sxsx")
    for k,v in pairs(ListView_sxsx:getItems()) do
        v:updateChooseState(self._isAuto)
    end
    -- ccui.Helper:seekWidgetByName(root,"CheckBox_sxtj"):setSelected(not self._isAuto)
end

function SmCultivateArtifactChoose:onUpdateDraw()
    local root = self.roots[1]
    local Text_sh_n_2 = ccui.Helper:seekWidgetByName(root, "Text_sh_n_2")
    local ListView_sxsx = ccui.Helper:seekWidgetByName(root, "ListView_sxsx")
    ListView_sxsx:removeAllItems()
    local count = getPropAllCountByMouldId(242)
    Text_sh_n_2:setString(count)

    for k,v in pairs(_ED.user_artifact_culture_info) do
        local cell = state_machine.excute("sm_cultivate_artifact_choose_cell", 0, {k, v, self._aritfact_id})
        ListView_sxsx:addChild(cell)
    end
    self:chooseState(true)

    self.currentListView = ListView_sxsx
    if self.currentListView then
        self.currentInnerContainer = self.currentListView:getInnerContainer()
        self.currentInnerContainerPosX = self.currentInnerContainer:getPositionX()
        self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    end
end

function SmCultivateArtifactChoose:init(params)
    self._rootWindows = params[1]
    self._aritfact_id = params[2]
	self:onInit()
    return self
end

function SmCultivateArtifactChoose:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_artifact_tab_1.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    local CheckBox_sxtj = ccui.Helper:seekWidgetByName(root,"CheckBox_sxtj")
    -- CheckBox_sxtj:setSelected(false)
    fwin:addTouchEventListener(CheckBox_sxtj, nil, 
    {
        terminal_name = "sm_cultivate_artifact_choose_isAuto", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sh_add_2"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_open_add", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._isAuto = true
	self:onUpdateDraw()
end

function SmCultivateArtifactChoose:onEnterTransitionFinish()
end

function SmCultivateArtifactChoose:onExit()
    state_machine.remove("sm_cultivate_artifact_choose_isAuto")
    state_machine.remove("sm_cultivate_artifact_choose_get_choose_info")
end

function SmCultivateArtifactChoose:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local dir = self.currentListView:getDirection()
        local size = self.currentListView:getContentSize()
        local posX = self.currentInnerContainer:getPositionX()
        local posY = self.currentInnerContainer:getPositionY()

        if dir == 2 and self.currentInnerContainerPosX == posX then
            return
        end

        if dir == 1 and self.currentInnerContainerPosY == posY then
            return
        end
        
        self.currentInnerContainerPosX = posX
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()

        if dir == 2 then
            for i, v in pairs(items) do
                local tempX = v:getPositionX() + posX
                if tempX + itemSize.width < 0 or tempX > size.width + itemSize.width then
                    v:unload()
                else
                    v:reload()
                end
            end
        elseif dir == 1 then
            for i, v in pairs(items) do
                local tempY = v:getPositionY() + posY
                if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                    v:unload()
                else
                    v:reload()
                end
            end
        end
    end    
end
