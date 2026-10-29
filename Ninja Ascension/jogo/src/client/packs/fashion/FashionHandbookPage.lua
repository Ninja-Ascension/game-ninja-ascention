--------------------------------------------------------------------------------------------------------------
--  说明：时装图鉴
--------------------------------------------------------------------------------------------------------------
FashionHandbookPage = class("FashionHandbookPageClass", Window)

--打开界面
local fashion_handbook_page_open_terminal = {
    _name = "fashion_handbook_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionHandbookPageWindow = fwin:find("FashionHandbookPageClass")
        if FashionHandbookPageWindow ~= nil and FashionHandbookPageWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_handbook_page_open", 0, "")
        local cell = FashionHandbookPage:createCell(params)
        fwin:open(cell, fwin._view)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_handbook_page_close_terminal = {
    _name = "fashion_handbook_page_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionHandbookPage:closeCell()
        -- state_machine.excute("union_refresh_info", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fashion_handbook_page_open_terminal)
state_machine.add(fashion_handbook_page_close_terminal)
state_machine.init()

function FashionHandbookPage:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.isOpen = false
    app.load("client.cells.fashion.fashion_handbook_page_list_cell")
   
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
	
	 -- Initialize fashion information page machine.
    local function init_fashion_handbook_page_terminal()
		-- 隐藏界面
        local fashion_handbook_page_hide_event_terminal = {
            _name = "fashion_handbook_page_hide_event",
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
        local fashion_handbook_page_show_event_terminal = {
            _name = "fashion_handbook_page_show_event",
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
		local fashion_handbook_page_refresh_terminal = {
            _name = "fashion_handbook_page_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                state_machine.excute("union_refresh_info", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		  --点击
        local fashion_handbook_page_open_action_terminal = {
            _name = "fashion_handbook_page_open_action",
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
		
		state_machine.add(fashion_handbook_page_hide_event_terminal)
		state_machine.add(fashion_handbook_page_show_event_terminal)
        state_machine.add(fashion_handbook_page_refresh_terminal)
		state_machine.add(fashion_handbook_page_open_action_terminal)
        state_machine.init()
    end
    
    -- call func init fashion information page   machine.
    init_fashion_handbook_page_terminal()

end

function FashionHandbookPage:onHide()
	self:setVisible(false)
end

function FashionHandbookPage:onShow()
	self:setVisible(true)
end

function FashionHandbookPage:playAction()
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

function FashionHandbookPage:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllChildren(true)

    FashionHandbookPage.asyncIndex = 1
    FashionHandbookPage.cacheListView = ListView_1
    self.currentListView = FashionHandbookPage.cacheListView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

    -- local fashionEquip = dms.searchs(dms["equipment_mould"], equipment_mould.equipment_type, 6)
    -- local fashionEquipCount = table.getn(fashionEquip) FashionHandbookPage
    local datas = dms["equipment_fashion_pokedex"]
    if (type(datas) == 'string') then
        datas = datas.split("\r\n")
    end
    local addTable = {}
    local tableNum = 0
    for i,v in ipairs (datas) do
        if v ~= nil then
            local suitId = dms.atoi(v,equipment_fashion_pokedex.suit_id)
            if zstring.tonumber(suitId) > 0 then
                local cell = FashionHandbookPageListCell:createCell()
                cell:init(v,FashionHandbookPage.asyncIndex,suitId)
                FashionHandbookPage.cacheListView:addChild(cell)
                FashionHandbookPage.cacheListView:requestRefreshView()
                FashionHandbookPage.asyncIndex = FashionHandbookPage.asyncIndex + 1

                local equipMouldIdOne = dms.atoi(v ,equipment_fashion_pokedex.suit_fashion_id_1)
                local equipMouldIdTwo = dms.atoi(v ,equipment_fashion_pokedex.suit_fashion_id_2)
                local equipOne = fundEquipWidthId(equipMouldIdOne) 
                local equipTwo = fundEquipWidthId(equipMouldIdTwo)
                if equipOne ~= nil and equipTwo ~= nil then
                    local activate_property1 = dms.string(dms["suit_param"],suitId,suit_param.activate_property1)
                    local seq1 = zstring.split(activate_property1,"|")
                    for i,v in pairs(seq1) do
                        local influenceType = zstring.split(v,",")      --每一种属性
                        if #influenceType >= 2 then
                            local _pType = tonumber(influenceType[1])
                            local _pValue = tonumber(influenceType[2])
                            tableNum = tableNum+1
                            if addTable[_pType+1] == nil then
                                addTable[_pType+1] = _pValue
                            else
                                addTable[_pType+1] =addTable[_pType+1] + _pValue
                            end
                        end
                    end 
                end
            elseif zstring.tonumber(suitId) == -1 then
                local cell = FashionHandbookPageListCell:createCell()
                cell:init(v,FashionHandbookPage.asyncIndex,suitId)
                FashionHandbookPage.cacheListView:addChild(cell)
                FashionHandbookPage.cacheListView:requestRefreshView()
                FashionHandbookPage.asyncIndex = FashionHandbookPage.asyncIndex + 1
            end
        end 
    end
    local index = 1
    for i,v in pairs(addTable) do
        if v ~= nil then
            local str1 = ""
            local str2 = ""
            if i > 4 then 
                str1 = _influence_type[i].."+"
                str2 = v.."%"
                -- Text_shuxing_01:setString(string_equiprety_name[_pType+1])
                -- Text_shuxing_02:setString(_pValue.."%")
            else
                str1 = string_equiprety_name[i]
                str2 = v
                -- Text_shuxing_01:setString(string_equiprety_name[_pType+1])
                -- Text_shuxing_02:setString(_pValue)
            end
            local Text_shuxing_01 = ccui.Helper:seekWidgetByName(root, string.format("Text_shuxin_sz_%d", index))
            local Text_shuxing_02 = ccui.Helper:seekWidgetByName(root, string.format("Text_shuxin_sz_%d", index+1))
            if Text_shuxing_01 ~= nil and  Text_shuxing_02 ~= nil then
                Text_shuxing_01:setString(str1)
                Text_shuxing_02:setString(str2)
                index = index + 2
            end
        end
    end
    if index == 1 then
        ccui.Helper:seekWidgetByName(root, "Panel_5"):setTouchEnabled(false)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_5"):setTouchEnabled(true)
    end

end

function FashionHandbookPage:onInit()
	self:updateDraw()
end

function FashionHandbookPage:onEnterTransitionFinish()
    local csbFashionHandbookPageCell = csb.createNode("fashionable_dress/fashionable_tujian.csb")
    local root = csbFashionHandbookPageCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionHandbookPageCell)


    local action = csb.createTimeline("fashionable_dress/fashionable_tujian.csb") 
    table.insert(self.actions, action )
    csbFashionHandbookPageCell:runAction(action)
    -- action:play("tanchuang_1", false)
   
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_5"), nil, 
    {
        terminal_name = "fashion_handbook_page_open_action", 
        terminal_state = 0,
        isPressedActionEnabled = false
    }, 
    nil, 0)

    self:init()
    state_machine.unlock("fashion_handbook_page_open", 0, "")
end

function FashionHandbookPage:init()
	self:onInit()
	return self
end

function FashionHandbookPage:onExit()
	state_machine.remove("fashion_handbook_page_hide_event")
	state_machine.remove("fashion_handbook_page_show_event")
    state_machine.remove("fashion_handbook_page_refresh")
	state_machine.remove("fashion_handbook_page_open_action")

end

function FashionHandbookPage:createCell( ... )
    local cell = FashionHandbookPage:new()
     cell:registerOnNodeEvent(cell)
    return cell
end

function FashionHandbookPage:closeCell( ... )
    local FashionHandbookPageWindow = fwin:find("FashionHandbookPageClass")
    if FashionHandbookPageWindow == nil then
        return
    end
    fwin:close(FashionHandbookPageWindow)
end