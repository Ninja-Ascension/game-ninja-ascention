-----------------------------
-- 神器主界面
-----------------------------
SmCultivateArtifactWindow = class("SmCultivateArtifactWindowClass", Window)

local sm_cultivate_artifact_window_open_terminal = {
	_name = "sm_cultivate_artifact_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if true == funOpenDrawTip(123) then
            return
        end
        local function responseCallBack( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        		if fwin:find("SmCultivateArtifactWindowClass") == nil then
        			fwin:open(SmCultivateArtifactWindow:new():init(), fwin._ui)		
        		end
            end
        end
        NetworkManager:register(protocol_command.artifact_init.code, nil, nil, nil, nil, responseCallBack, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_cultivate_artifact_window_close_terminal = {
	_name = "sm_cultivate_artifact_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        --fwin:close(fwin:find("UserTopInfoAClass"))
		fwin:close(fwin:find("SmCultivateArtifactWindowClass"))
        fwin:close(fwin:find("UserTopInfoAClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_artifact_window_open_terminal)
state_machine.add(sm_cultivate_artifact_window_close_terminal)
state_machine.init()

function SmCultivateArtifactWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self._chooseIndex = 0

    self.currentScrollView = nil
    self.leftButton = nil
    self.rightButton = nil

    app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactInfo")
    app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactHelp")
    app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactChoose")
    app.load("client.l_digital.cells.cultivate.artifact.sm_cultivate_artifact_choose_cell")
    app.load("client.l_digital.cells.cultivate.artifact.sm_cultivate_artifact_cell")
    app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactConfirmTrain")
    
    local function init_sm_cultivate_artifact_terminal()
		local sm_cultivate_artifact_open_result_terminal = {
            _name = "sm_cultivate_artifact_open_result",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:openResult(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_update_choose_state_terminal = {
            _name = "sm_cultivate_artifact_update_choose_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._chooseIndex == params then
                    return
                end
                instance:updateListChooseState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_open_add_terminal = {
            _name = "sm_cultivate_artifact_open_add",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                local cell = HeroPatchInformationPageGetWay:createCell()
                cell:init(242, 2)
                fwin:open(cell, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_scroll_terminal = {
            _name = "sm_cultivate_artifact_scroll",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.currentScrollView:jumpToPercentHorizontal(params._datas.index * 100)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_update_info_terminal = {
            _name = "sm_cultivate_artifact_update_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateListView()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_artifact_open_result_terminal)
        state_machine.add(sm_cultivate_artifact_update_choose_state_terminal)
        state_machine.add(sm_cultivate_artifact_open_add_terminal)
        state_machine.add(sm_cultivate_artifact_scroll_terminal)
        state_machine.add(sm_cultivate_artifact_update_info_terminal)
        state_machine.init()
    end
    init_sm_cultivate_artifact_terminal()
end

function SmCultivateArtifactWindow:openResult( isOpen )
    local root = self.roots[1]
    local Panel_tab_1 = ccui.Helper:seekWidgetByName(root, "Panel_tab_1")
    Panel_tab_1:removeAllChildren(true)
    if isOpen == true and table.nums(_ED.user_artifact_culture_info) > 1 then
        local id = dms.string(dms["artifact_mould"], self._chooseIndex, artifact_mould.id)
        state_machine.excute("sm_cultivate_artifact_choose_open", 0, {Panel_tab_1, id})
    end

    local Text_sh_n = ccui.Helper:seekWidgetByName(root, "Text_sh_n")
    local count = getPropAllCountByMouldId(242)
    Text_sh_n:setString(count)
end

function SmCultivateArtifactWindow:updateListChooseState( chooseIndex )
    for k,v in pairs(self.currentScrollView:getItems()) do
        if chooseIndex == k then
            v:updateChooseState(true)
        else
            v:updateChooseState(false)
        end
    end
    local lastId = 0
    local lastInfo = nil
    if self._chooseIndex > 0 then
        lastId = dms.string(dms["artifact_mould"], self._chooseIndex, artifact_mould.id)
        lastInfo = _ED.user_artifact_info[""..lastId]
    end
    local id = dms.string(dms["artifact_mould"], chooseIndex, artifact_mould.id)
    local info = _ED.user_artifact_info[""..id]
    self._chooseIndex = chooseIndex

    self:onUpdateDraw()
end

function SmCultivateArtifactWindow:onUpdateDraw()
    fwin:close(fwin:find("SmCultivateArtifactInfoClass"))
    local root = self.roots[1]
    local Panel_tab_2 = ccui.Helper:seekWidgetByName(root, "Panel_tab_2")
    local Panel_di = ccui.Helper:seekWidgetByName(root, "Panel_di")
    local Panel_sq_name = ccui.Helper:seekWidgetByName(root, "Panel_sq_name")
    local Panel_sq_big_icon = ccui.Helper:seekWidgetByName(root, "Panel_sq_big_icon")
    local Image_sq_lock = ccui.Helper:seekWidgetByName(root, "Image_sq_lock")
    local Text_sh_n = ccui.Helper:seekWidgetByName(root, "Text_sh_n")
    Panel_tab_2:removeAllChildren(true)
    Panel_di:removeAllChildren(true)
    Panel_sq_name:removeBackGroundImage()
    if Panel_sq_big_icon._x == nil then
        Panel_sq_big_icon._x = Panel_sq_big_icon:getPositionX()
        Panel_sq_big_icon._y = Panel_sq_big_icon:getPositionY()
    else
        Panel_sq_big_icon:setPosition(cc.p(Panel_sq_big_icon._x, Panel_sq_big_icon._y))
    end
    Panel_sq_big_icon:removeBackGroundImage()
    Panel_sq_big_icon:removeAllChildren(true)
    Panel_sq_big_icon:stopAllActions()
    Image_sq_lock:setVisible(false)

    local count = getPropAllCountByMouldId(242)
    Text_sh_n:setString(count)

    local pic = dms.int(dms["artifact_mould"], self._chooseIndex, artifact_mould.pic)
    Panel_sq_name:setBackGroundImage(string.format("images/ui/text/SQ_res/sq_img/sq_name_%d.png", pic))
    local icon = cc.Sprite:create(string.format("images/ui/text/SQ_res/sq_img/sq_big_icon_%d.png", pic))
    Panel_sq_big_icon:addChild(icon)
    icon:setPosition(cc.p(Panel_sq_big_icon:getContentSize().width/2, Panel_sq_big_icon:getContentSize().height/2))
    local id = dms.string(dms["artifact_mould"], self._chooseIndex, artifact_mould.id)
    local info = _ED.user_artifact_info[""..id]
    if tonumber(info.state) == 1 then
        local jsonFile = "images/ui/effice/effect_artifact_bg/effect_artifact_bg.json"
        local atlasFile = "images/ui/effice/effect_artifact_bg/effect_artifact_bg.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_di:addChild(animation)
        animation:setPosition(cc.p(Panel_di:getContentSize().width/2, Panel_di:getContentSize().height/2))
        display:ungray(icon)
        Panel_sq_big_icon:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, -10)), cc.MoveBy:create(1, cc.p(0, 10)))))
    else
        display:gray(icon)
        Image_sq_lock:setVisible(true)
    end
    state_machine.excute("sm_cultivate_artifact_info_open", 0, {Panel_tab_2, self._chooseIndex})
end

function SmCultivateArtifactWindow:onUpdateListView( ... )
    local root = self.roots[1]
    local ListView_sq_icon = ccui.Helper:seekWidgetByName(root, "ListView_sq_icon")
    ListView_sq_icon:removeAllItems()
    local isShow = nil
    for i=1,dms.count(dms["artifact_mould"]) do
        local id = dms.string(dms["artifact_mould"], i, artifact_mould.id)
        local info = _ED.user_artifact_info[""..id]
        if tonumber(info.state) == 0 then
            if isShow == nil then
                isShow = true
            else
                isShow = false
            end
        end
        local cell = state_machine.excute("sm_cultivate_artifact_cell", 0, {i, info, isShow})
        ListView_sq_icon:addChild(cell)
    end
    self.currentScrollView = ListView_sq_icon
end

function SmCultivateArtifactWindow:onUpdate( dt )
    local posX = self.currentScrollView:getInnerContainer():getPositionX()
    if posX <= -20 then
        self.leftButton:setVisible(true)
    else
        self.leftButton:setVisible(false)
    end
    if posX >= self.currentScrollView:getContentSize().width - self.currentScrollView:getInnerContainer():getContentSize().width + 20 then
        self.rightButton:setVisible(true)
    else
        self.rightButton:setVisible(false)
    end
end

function SmCultivateArtifactWindow:init()
	self:onInit()
    return self
end

function SmCultivateArtifactWindow:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_artifact.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self.leftButton = ccui.Helper:seekWidgetByName(root,"Button_arrow_left")
    self.rightButton = ccui.Helper:seekWidgetByName(root,"Button_arrow_right")
    fwin:addTouchEventListener(self.leftButton, nil, 
    {
        terminal_name = "sm_cultivate_artifact_scroll", 
        terminal_state = 0, 
        touch_black = true,
        index = 0,
    }, nil, 3)

    fwin:addTouchEventListener(self.rightButton, nil, 
    {
        terminal_name = "sm_cultivate_artifact_scroll", 
        terminal_state = 0, 
        touch_black = true,
        index = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sh_add"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_open_add", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_help_open", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
    
    self:onUpdateListView()
    -- self:onUpdateDraw()
    self:updateListChooseState(1)
end

function SmCultivateArtifactWindow:onEnterTransitionFinish()
    fwin:open(UserTopInfoA:new(), fwin._ui)
end

function SmCultivateArtifactWindow:onExit()
    state_machine.remove("sm_cultivate_artifact_update")
    state_machine.remove("sm_cultivate_artifact_update_choose_state")
    state_machine.remove("sm_cultivate_artifact_open_add")
    state_machine.remove("sm_cultivate_artifact_open_result")
    state_machine.remove("sm_cultivate_artifact_update_info")
end
