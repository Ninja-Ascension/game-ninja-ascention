--------------------------------------------------------------------------------------------------------------
--  说明：时装主界面
--------------------------------------------------------------------------------------------------------------
FashionDevelop = class("FashionDevelopClass", Window)

--打开界面
local fashion_develop_open_terminal = {
    _name = "fashion_develop_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionDevelopWindow = fwin:find("FashionDevelopClass")
        if FashionDevelopWindow ~= nil and FashionDevelopWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_develop_open", 0, "")
        fwin:open(FashionDevelop:createCell():init(params), fwin._viewdialog)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_develop_close_terminal = {
    _name = "fashion_develop_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UserInformationShopClass"))
        FashionDevelop:closeCell()
        state_machine.excute("fashion_information_page_close", 0, nil)
        state_machine.excute("fashion_strengthen_page_close", 0, nil)
        state_machine.excute("fashion_recast_page_close", 0, nil)
        state_machine.excute("fashion_handbook_page_close", 0, nil)
        state_machine.excute("hero_storage_show_window", 0, "")
        if fwin:find("MenuClass") ~= nil then
            state_machine.excute("formation_updata_fashion", 0, "")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fashion_develop_open_terminal)
state_machine.add(fashion_develop_close_terminal)
state_machine.init()

local Choose_Type = {
    type_info = 1,           -- 时装信息
    type_strengthen = 2,        -- 时装强化
    type_recast = 3,            -- 时装重铸
    type_handbook = 4,          -- 时装图鉴
}

function FashionDevelop:ctor()
	self.super:ctor()
	self.roots = {}
    self.group ={}
    -- self.chooseType = Choose_Type.type_info
    self.infoCell = nil
    self.strengthenCell = nil
    self.recastCell = nil
    self.handbookCell = nil

    self.shipIcon = nil 
    self.selectIndex = nil 
    self.selectIcon = nil 
    self.openGotoIndex = nil   -- 打开界面时穿模板ID定位
    -- self.strengthenGotoIndex = nil
    -- 引入消息对象的定义事件名,以及数据格式
    app.load("client.utils.objectMessage.ObjectMessage")
    -- app.load("client.utils.objectMessage.ObjectMessageNameEnum")

    app.load("client.packs.fashion.FashionInformationPage")
    app.load("client.packs.fashion.FashionStrengthenPage")
    app.load("client.packs.fashion.FashionRecastPage")
    app.load("client.packs.fashion.FashionHandbookPage")
    
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.fashion.fashion_icon_cell")
    app.load("client.cells.fashion.fashion_listview_icon_cell")
    
	 -- Initialize fashion develop machine.
    local function init_fashion_develop_terminal()
		-- 隐藏界面
        local fashion_develop_hide_event_terminal = {
            _name = "fashion_develop_hide_event",
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
        local fashion_develop_event_terminal = {
            _name = "fashion_develop_show_event",
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
		local fashion_develop_refresh_terminal = {
            _name = "fashion_develop_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _index = instance:getIconIndex(params._source)
                instance.selectIndex = _index
                instance.selectIcon = params._source
                instance:updateDraw()
                instance:updateShipCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 打开时装信息界面
		local fashion_develop_open_information_page_terminal = {
            _name = "fashion_develop_open_information_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi"):setHighlighted(true)
                if instance.chooseType == Choose_Type.type_info then
                    return
                end

                instance.chooseType = Choose_Type.type_info
                instance:updateButton()
                instance:updateShipCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--打开时装强化界面
		local fashion_develop_open_strengthen_page_terminal = {
            _name = "fashion_develop_open_strengthen_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chengyuan"):setHighlighted(true)
                if instance.chooseType ~= Choose_Type.type_strengthen then
                    instance.chooseType = Choose_Type.type_strengthen
                    instance:updateButton()
                    instance:updateShipCell()
                end
                if params ~= nil and params ~= "" then
                    if params._datas._mouldeID ~= nil then
                        instance:strGotoIndex(zstring.tonumber(params._datas._mouldeID))
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 打开时装重铸界面
		local fashion_develop_open_recast_page_terminal = {
            _name = "fashion_develop_open_recast_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_dongtai"):setHighlighted(true)
                if instance.chooseType == Choose_Type.type_recast then
                    return
                end
                instance.chooseType = Choose_Type.type_recast
                instance:updateButton()
                instance:updateShipCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 打开时装图鉴界面
		local fashion_develop_open_handbook_page_terminal = {
            _name = "fashion_develop_open_handbook_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.chooseType == Choose_Type.type_handbook then
                    return
                end
                instance.chooseType = Choose_Type.type_handbook
                instance:updateButton()
                instance:updateShipCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 更新选择INDEX
        local fashion_develop_open_updata_index_terminal = {
            _name = "fashion_develop_open_updata_index",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _index = instance:getIconIndex(params.source)
                instance.selectIndex = _index
                instance.selectIcon = params.source
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(fashion_develop_hide_event_terminal)
		state_machine.add(fashion_develop_show_event_terminal)
		state_machine.add(fashion_develop_refresh_terminal)
		state_machine.add(fashion_develop_open_information_page_terminal)
		state_machine.add(fashion_develop_open_strengthen_page_terminal)
		state_machine.add(fashion_develop_open_recast_page_terminal)
        state_machine.add(fashion_develop_open_handbook_page_terminal)
		state_machine.add(fashion_develop_open_updata_index_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place machine.
    init_fashion_develop_terminal()

end

function FashionDevelop:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function FashionDevelop:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function FashionDevelop:strGotoIndex(mouldid)
    local root = self.roots[1]
    if root == nil then
        return
    end
    if mouldid > 0 then
        local items = self.litterListView:getItems()
        for i,v in ipairs(items) do
            if v.mould_id ~= nil and zstring.tonumber(v.mould_id) == mouldid then
                local data = {
                    source = v,
                    _isrefresh = true
                }
                state_machine.excute("fashion_strengthen_page_refresh", 0, data)
                self:setListViewIndex(i-1)
            end
        end
    end
end

function FashionDevelop:drawShipIcon()
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- 绘制头像
    local user_info = nil
    local color = nil
    for i = 2, 7 do
        local shipId = _ED.formetion[i]
        if tonumber(shipId) > 0 then
            local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
            if tonumber(isleadtype) == 0 then
                user_info = _ED.user_ship[_ED.formetion[i]]
                color = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.ship_type)
                break
            end
        end
    end

    local cell = FashionListviewIconCell:createCell()
    cell:init(2, nil, nil, nil, nil, nil, nil ,user_info)
    self.shipIcon = cell
    return cell 
    -- ListView_3:addChild(cell)
end

-- 主角
function FashionDevelop:updateShipCell()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3")
    if self.chooseType == Choose_Type.type_info then
        if self.shipIcon ~= nil then
            local index = self:getIconIndex(self.shipIcon)
            if index == nil then
                local shipcell = self:drawShipIcon()
                ListView_3:insertCustomItem(shipcell,0)
                self.selectIndex = self.selectIndex +1
                -- if self.selectIndex <= 2 then
                    -- print("type_infoself.selectIcon ===",self.selectIcon )
                    if self.selectIcon ~= nil then
                        local _index = self:getIconIndex(self.selectIcon)
                        if _index~= nil then
                            self:setListViewIndex(_index-1)
                            local cell = ListView_3:getItem(_index-1)
                            local data = {
                                source = cell
                            }
                            state_machine.excute("fashion_information_page_refresh", 0, data)
                        else
                            self:setListViewIndex(0)
                        end
                    else
                        self:setListViewIndex(0)
                    end
                -- end
            end
            
        end
    elseif self.chooseType == Choose_Type.type_strengthen then
        if self.shipIcon ~= nil then
            local index = self:getIconIndex(self.shipIcon)
            if index ~= nil then
                ListView_3:removeItem(index-1)
                if self.selectIndex == 1 then
                    self:setListViewIndex(0)
                    local cell = ListView_3:getItem(0)
                    local data = {
                        source = cell
                    }
                    state_machine.excute("fashion_strengthen_page_refresh", 0, data)
                else
                    self.selectIndex = self.selectIndex - 1
                end 
            else
                if ListView_3:getCurSelectedIndex() == 0 then
                    local cell = ListView_3:getItem(0)
                    local data = {
                        source = cell
                    }
                    state_machine.excute("fashion_strengthen_page_refresh", 0, data)
                end
            end
        end
        if ListView_3:getCurSelectedIndex() == 0 then
            self:setListViewIndex(0)
        end
     elseif self.chooseType == Choose_Type.type_recast then

        if self.shipIcon ~= nil then
           local index = self:getIconIndex(self.shipIcon)

            if index ~= nil then
                ListView_3:removeItem(index-1)

                if self.selectIndex == 1 then
                    self:setListViewIndex(0)
                    local cell = ListView_3:getItem(0)
                    local data = {
                        source = cell
                    }
                    state_machine.excute("fashion_recast_page_refresh", 0, data)
                else
                    self.selectIndex = self.selectIndex - 1
                end 
            else
                if ListView_3:getCurSelectedIndex() == 0 then
                    local cell = ListView_3:getItem(0)
                    local data = {
                        source = cell
                    }
                    state_machine.excute("fashion_recast_page_refresh", 0, data)
                end
            end
        end
        if ListView_3:getCurSelectedIndex() == 0 then
            self:setListViewIndex(0)
        end
    elseif self.chooseType == Choose_Type.type_handbook then
    end
end

function FashionDevelop:updateListview()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3")
    ListView_3:removeAllItems()
    self.litterListView = ListView_3
    
    local shipcell = self:drawShipIcon()
    ListView_3:addChild(shipcell)

    local fashionEquip = dms.searchs(dms["equipment_mould"], equipment_mould.equipment_type, 6)
    local fashionEquipCount = table.getn(fashionEquip)
    local listTable = {}
    local selectid = nil
    local openGotoIndex  = nil
    if self.openGotoIndex ~= nil then
        openGotoIndex = zstring.tonumber(self.openGotoIndex)
    end
    if fashionEquip ~= nil and fashionEquipCount ~= nil and fashionEquipCount > 0 then
        for i,v in ipairs(fashionEquip) do
            if v ~= nil then 
                local _name = dms.atos(v,equipment_mould.equipment_name) 
                -- if _name ~= "备用" then
                    local _mould = dms.atoi(v,equipment_mould.id)
                    local Equip = fundEquipWidthId(_mould)
                    if Equip ~= nil then
                        if tonumber(Equip.ship_id) > 0 then
                            v._grade = 10000
                            -- selectid = i
                        else
                            v._grade = tonumber(Equip.user_equiment_grade)
                        end
                        
                    else
                        v._grade = -1
                    end

                    table.insert(listTable,v) 
                -- end
            end
        end
    end
    if table.getn(listTable) > 0 then
        local sortFunc = function( a, b )
            return a._grade > b._grade
        end
        table.sort(listTable, sortFunc)
        for i,v in ipairs(listTable) do
            -- print("")
            local _mould = dms.atoi(v,equipment_mould.id)
            local Equip = fundEquipWidthId(_mould)
            if Equip ~= nil then
                local cell = FashionListviewIconCell:createCell()
                cell:init(1, Equip, _mould, nil, nil, nil,v._grade)
                ListView_3:addChild(cell)
            else
                local cell = FashionListviewIconCell:createCell()
                cell:init(1, nil, _mould, nil, nil, nil, v._grade)
                ListView_3:addChild(cell)
            end
            if v._grade == 10000 then
                selectid = i
            end
            if openGotoIndex ~= nil then
                if openGotoIndex == _mould then
                    selectid = i
                end
            end
        end
    end
    ListView_3:jumpToLeft()
    if selectid == nil then
        self:setListViewIndex(0)
        selectid = 0
    else
        self:setListViewIndex(selectid)
    end
    local cell = ListView_3:getItem(selectid)
    local data = {
        source = cell
    }
    self.selectIndex = selectid + 1
    -- state_machine.excute("fashion_information_page_refresh", 0, data)

end
function FashionDevelop:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local items = self.litterListView:getItems()
    for i,v in ipairs(items) do
        if i == self.selectIndex then
            self.selectIcon = v
            ccui.Helper:seekWidgetByName(v, "Image_bidiao"):setVisible(true)
            v.isWear = true
            local data = {
                source = v,
                _isrefresh = true
            }
            state_machine.excute("fashion_recast_page_refresh", 0, data)
            -- state_machine.excute("fashion_strengthen_page_refresh", 0, data)
        else
            ccui.Helper:seekWidgetByName(v, "Image_bidiao"):setVisible(false)
            v.isWear = false
        end
    end
   

end
-- 根据顶部icon查找当前选择索引
function FashionDevelop:getIconIndex(source)  
    local items = self.litterListView:getItems()
    for i,v in ipairs(items) do
        if v == source then
            return i
        end
    end
    return nil
end

function FashionDevelop:updateButton()
    state_machine.excute("fashion_information_page_hide_event", 0, nil)
    state_machine.excute("fashion_strengthen_page_hide_event", 0, nil)
    state_machine.excute("fashion_recast_page_hide_event", 0, nil)
    state_machine.excute("fashion_handbook_page_hide_event", 0, nil)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Button_shizhuang"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_tujian"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Image_shizhuang"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_qianghua"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_chongzhu"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_tujian"):setVisible(false)

    local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3")
   -- print( "===",ListView_3:getCurSelectedIndex())
    ccui.Helper:seekWidgetByName(root, "Panel_7"):setVisible(true)
    if self.chooseType == Choose_Type.type_info then
       
        ccui.Helper:seekWidgetByName(root, "Button_shizhuang"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_shizhuang"):setVisible(true)
        if self.infoCell == nil then
            local cell = ListView_3:getItem(self.selectIndex-1)
            local data = {
                source = cell
            }
            self.infoCell = state_machine.excute("fashion_information_page_open", 0, nil)
            state_machine.excute("fashion_information_page_refresh", 0, data)

        else

            state_machine.excute("fashion_information_page_show_event", 0, nil)
            state_machine.excute("fashion_information_page_play_action", 0, nil)

        end
    elseif self.chooseType == Choose_Type.type_strengthen then
        ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_qianghua"):setVisible(true)
        if self.strengthenCell == nil then
            local cell = ListView_3:getItem(self.selectIndex-1)
            local data = {
                source = cell
            }
            self.strengthenCell = state_machine.excute("fashion_strengthen_page_open", 0, nil)
            state_machine.excute("fashion_strengthen_page_refresh", 0, data)
        else
            state_machine.excute("fashion_strengthen_page_show_event", 0, nil)    
            state_machine.excute("fashion_strengthen_page_play_action", 0, nil)    
        end
    elseif self.chooseType == Choose_Type.type_recast then
        ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_chongzhu"):setVisible(true)
        if self.recastCell == nil then
            local cell = ListView_3:getItem(self.selectIndex-1)
            local data = {
                source = cell
            }
            self.recastCell = state_machine.excute("fashion_recast_page_open", 0, nil)
            state_machine.excute("fashion_recast_page_refresh", 0, data)
            -- self:addChild(self.recastCell) 
        else
            state_machine.excute("fashion_recast_page_show_event", 0, nil)
            state_machine.excute("fashion_recast_page_play_action", 0, nil)
        end
        
    elseif self.chooseType == Choose_Type.type_handbook then
        ccui.Helper:seekWidgetByName(root, "Panel_7"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_tujian"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_tujian"):setVisible(true)
        if self.handbookCell == nil then
            self.handbookCell = state_machine.excute("fashion_handbook_page_open", 0, nil)
            -- self:addChild(self.handbookCell)
        else
            state_machine.excute("fashion_handbook_page_show_event", 0, nil)
        end
    end
end
function FashionDevelop:setListViewIndex(index)
    
    -- if nil == index then
    --     index = self.number_currentShowPageIndex - 1
    -- end
    
    index = math.max(index,0)
    
    local _messageName = ObjectMessageNameEnum.fashion_listview_icon_cell_set_chosen_state
    local _messageData = ObjectMessageData.getInitExample(_messageName)
    _messageData.source = self.litterListView:getItem(index)
    _messageData.target = _messageData.source
    ObjectMessage.fireMessage(_messageName,_messageData)
end

function FashionDevelop:onInit()
    self:updateListview()
    self:updateButton()
    self:updateShipCell()
end

function FashionDevelop:onEnterTransitionFinish()
    app.load("client.player.UserInformationShop")                   --顶部用户信息
    local userinfo = fwin:find("UserInformationShopClass")
    if userinfo == nil then
        fwin:open(UserInformationShop:new(),fwin._ui)
    end
    local csbFashionDevelopCell = csb.createNode("fashionable_dress/fashionable.csb")
    local root = csbFashionDevelopCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionDevelopCell)
    ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setTouchEnabled(false)
    ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setTouchEnabled(false)
    ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setBright(false)
    ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setBright(false)
    for i, v in pairs(_ED.user_equiment) do
        if v.equipment_type == "6" then 
            ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setBright(true)
            ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setBright(true)
            break
        end
    end



    -- local fashionEquip, pic = getUserFashion()
    -- if fashionEquip ~= nil and pic ~= nil then
    --     ccui.Helper:seekWidgetByName(root, "Button_qianghua"):setTouchEnabled(true)
    --     ccui.Helper:seekWidgetByName(root, "Button_chongzhu"):setTouchEnabled(true)
    -- end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shizhuang"),  nil, 
    {
        terminal_name = "fashion_develop_open_information_page",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianghua"),  nil, 
    {
        terminal_name = "fashion_develop_open_strengthen_page",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chongzhu"),  nil, 
    {
        terminal_name = "fashion_develop_open_recast_page",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian"),  nil, 
    {
        terminal_name = "fashion_develop_open_handbook_page",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fanhui"),  nil, 
    {
        terminal_name = "fashion_develop_close",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)

    self:onInit()
    state_machine.unlock("fashion_develop_open", 0, "")
end

function FashionDevelop:init(params)
	self.chooseType = params._datas._pageType
    self.openGotoIndex = params._datas._mouldeID
	return self
end

function FashionDevelop:onExit()
    self.infoCell = nil
    self.strengthenCell = nil
    self.recastCell = nil
    self.handbookCell = nil
	state_machine.remove("fashion_develop_hide_event")
	state_machine.remove("fashion_develop_show_event")
	state_machine.remove("fashion_develop_refresh")
	state_machine.remove("fashion_develop_open_information_page")
	state_machine.remove("fashion_develop_open_strengthen_page")
	state_machine.remove("fashion_develop_open_recast_page")
    state_machine.remove("fashion_develop_open_handbook_page")
	state_machine.remove("fashion_develop_open_updata_index")

end

function FashionDevelop:createCell()
    local cell = FashionDevelop:new()

    return cell
end

function FashionDevelop:closeCell( ... )
    local FashionDevelopWindow = fwin:find("FashionDevelopClass")
    if FashionDevelopWindow == nil then
        return
    end
    fwin:close(FashionDevelopWindow)
end