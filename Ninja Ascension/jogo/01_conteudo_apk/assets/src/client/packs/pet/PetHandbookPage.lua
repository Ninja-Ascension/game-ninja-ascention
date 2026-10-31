--------------------------------------------------------------------------------------------------------------
--  说明：宠物图鉴
--------------------------------------------------------------------------------------------------------------
PetHandbookPage = class("PetHandbookPageClass", Window)

--打开界面
local pet_handbook_page_open_terminal = {
    _name = "pet_handbook_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local PetHandbookPageWindow = fwin:find("PetHandbookPageClass")
        if PetHandbookPageWindow ~= nil and PetHandbookPageWindow:isVisible() == true then
            return true
        end
        state_machine.lock("pet_handbook_page_open", 0, "")
        local cell = PetHandbookPage:createCell(params)
        fwin:open(cell, fwin._view)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local pet_handbook_page_close_terminal = {
    _name = "pet_handbook_page_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        PetHandbookPage:closeCell()
        -- state_machine.excute("union_refresh_info", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(pet_handbook_page_open_terminal)
state_machine.add(pet_handbook_page_close_terminal)
state_machine.init()

function PetHandbookPage:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.isOpen = false
    app.load("client.cells.pet.pet_handbook_page_list_cell")
   
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
	
	 -- Initialize fashion information page machine.
    local function init_pet_handbook_page_terminal()
		-- 隐藏界面
        local pet_handbook_page_hide_event_terminal = {
            _name = "pet_handbook_page_hide_event",
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
        local pet_handbook_page_show_event_terminal = {
            _name = "pet_handbook_page_show_event",
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
		--刷新信息
		local pet_handbook_page_refresh_terminal = {
            _name = "pet_handbook_page_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		  --点击
        local pet_handbook_page_open_action_terminal = {
            _name = "pet_handbook_page_open_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local skillindex = params._datas._skillIndex

                instance:playAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_handbook_page_hide_event_terminal)
		state_machine.add(pet_handbook_page_show_event_terminal)
        state_machine.add(pet_handbook_page_refresh_terminal)
		state_machine.add(pet_handbook_page_open_action_terminal)
        state_machine.init()
    end
    
    -- call func init fashion information page   machine.
    init_pet_handbook_page_terminal()

end

function PetHandbookPage:onHide()
	self:setVisible(false)
end

function PetHandbookPage:onShow()
	self:setVisible(true)
end

function PetHandbookPage:playAction()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local action = self.actions[1]
    if  self.isOpen == false then
        self.isOpen = true
        action:play("tanchuang_1", false)
    else
        self.isOpen = false
        action:play("tanchuang_2", false)
    end
end

function PetHandbookPage:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllChildren(true)

    PetHandbookPage.asyncIndex = 1
    PetHandbookPage.cacheListView = ListView_1
    self.currentListView = PetHandbookPage.cacheListView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

    local datas = dms["pet_pokedex"]
    if (type(datas) == 'string') then
        datas = datas.split("\r\n")
    end

    local activateIds = {}
    local addTable = {}
    local tableNum = 0
    for i,v in ipairs (datas) do
        if v ~= nil then
            local suitId = dms.atoi(v,pet_pokedex.suit_id)
            local cell = PetHandbookPageListCell:createCell()
            if zstring.tonumber(suitId) > 0 then
                cell:init(v,PetHandbookPage.asyncIndex,suitId)
                PetHandbookPage.cacheListView:addChild(cell)
                PetHandbookPage.cacheListView:requestRefreshView()
                PetHandbookPage.asyncIndex = PetHandbookPage.asyncIndex + 1
            elseif zstring.tonumber(suitId) == -1 then
                --未开放
                cell:init(v,PetHandbookPage.asyncIndex,suitId)
                PetHandbookPage.cacheListView:addChild(cell)
                PetHandbookPage.cacheListView:requestRefreshView()
                PetHandbookPage.asyncIndex = PetHandbookPage.asyncIndex + 1
            end
            if cell._isActivate == true then 
                --激活后添加到数组中
                table.insert(activateIds,suitId)
            end
        end 
    end
    local t_types = {}
    local t_values = {}
    for k,v in pairs(activateIds) do
        local suitDate = dms.element(dms["suit_param"], v)
        local activate_property1 = dms.atos(suitDate,suit_param.activate_property1)
        local activate_property2 = dms.atos(suitDate,suit_param.activate_property2)
        local activate_property3 = dms.atos(suitDate,suit_param.activate_property3)
        local infoDate = nil
        if activate_property1 ~= "-1" then 
            infoDate = activate_property1
        end
        if activate_property2 ~= "-1" then 
            infoDate = activate_property2
        end
        if activate_property3 ~= "-1" then 
            infoDate = activate_property3
        end
        if infoDate ~= nil then 
            local seq1 = zstring.split("" ..infoDate,"|")
            for i,v in pairs(seq1) do
                local influenceType = zstring.split(v,",")      --每一种属性
                local _pType = tonumber(influenceType[1])
                local _pValue = zstring.tonumber(influenceType[2])
                t_types[_pType] = true
                if t_values[_pType] ~= nil then 
                    t_values[_pType] = t_values[_pType] + _pValue
                else
                    t_values[_pType] = _pValue
                end
            end
        end
    end
    --遍历所有属性
    local index = 1
    for i=0,36 do
        local infoText = ccui.Helper:seekWidgetByName(root, "Text_shuxin_sz_"..i+1)
        local valueText = ccui.Helper:seekWidgetByName(root, "Text_shuxin_sz_1_"..i+1)
        if infoText ~= nil or valueText ~= nil then 
            infoText:setString("")
            valueText:setString("")
        end
        if t_values[i] ~= nil and t_types[i] == true then
            local infoText = ccui.Helper:seekWidgetByName(root, "Text_shuxin_sz_"..index)
            local valueText = ccui.Helper:seekWidgetByName(root, "Text_shuxin_sz_1_"..index)
            infoText:setString(_influence_type[i+1].."+")
            valueText:setString(t_values[i]..string_equiprety_name_vlua_type[i+1])
            index = index + 1
        end
    end
end

function PetHandbookPage:onEnterTransitionFinish()
    local csbPetHandbookPageCell = csb.createNode("packs/PetStorage/PetStorage_tujian.csb")
    local root = csbPetHandbookPageCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbPetHandbookPageCell)


    local action = csb.createTimeline("packs/PetStorage/PetStorage_tujian.csb") 
    table.insert(self.actions, action )
    csbPetHandbookPageCell:runAction(action)
    -- action:play("tanchuang_1", false)
   
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_5"), nil, 
    {
        terminal_name = "pet_handbook_page_open_action", 
        terminal_state = 0,
        isPressedActionEnabled = false
    }, 
    nil, 0)

    self:updateDraw()
    state_machine.unlock("pet_handbook_page_open", 0, "")
end

function PetHandbookPage:init()
	return self
end

function PetHandbookPage:onExit()
	state_machine.remove("pet_handbook_page_hide_event")
	state_machine.remove("pet_handbook_page_show_event")
    state_machine.remove("pet_handbook_page_refresh")
	state_machine.remove("pet_handbook_page_open_action")

end

function PetHandbookPage:createCell( ... )
    local cell = PetHandbookPage:new()
     cell:registerOnNodeEvent(cell)
    return cell
end

function PetHandbookPage:closeCell( ... )
    local PetHandbookPageWindow = fwin:find("PetHandbookPageClass")
    if PetHandbookPageWindow == nil then
        return
    end
    fwin:close(PetHandbookPageWindow)
end