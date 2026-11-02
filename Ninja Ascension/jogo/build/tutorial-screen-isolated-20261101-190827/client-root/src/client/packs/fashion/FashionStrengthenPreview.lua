--------------------------------------------------------------------------------------------------------------
--  说明：时装强化预览界面
--------------------------------------------------------------------------------------------------------------

FashionStrengthenPreview = class("FashionStrengthenPreviewClass", Window)


--打开界面
local fashion_strengthen_Preview_open_terminal = {
    _name = "fashion_strengthen_Preview_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionStrengthenPreviewWindow = fwin:find("FashionStrengthenPreviewClass")
        if FashionStrengthenPreviewWindow ~= nil and FashionStrengthenPreviewWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_strengthen_Preview_open", 0, "")
        local cell = FashionStrengthenPreview:createCell()
        fwin:open(cell:init(params), fwin._ui)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_strengthen_Preview_close_terminal = {
    _name = "fashion_strengthen_Preview_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionStrengthenPreview:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fashion_strengthen_Preview_open_terminal)
state_machine.add(fashion_strengthen_Preview_close_terminal)
state_machine.init()


function FashionStrengthenPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	app.load("client.cells.fashion.fashion_strengthen_preview_list_cell")
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	 -- Initialize fashion information Preview machine.
    local function init_fashion_strengthen_Preview_terminal()
    	-- 隐藏界面
        local fashion_strengthen_Preview_hide_event_terminal = {
            _name = "fashion_strengthen_Preview_hide_event",
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
        local fashion_strengthen_Preview_show_event_terminal = {
            _name = "fashion_strengthen_Preview_show_event",
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
		local fashion_strengthen_Preview_refresh_terminal = {
            _name = "fashion_strengthen_Preview_refresh",
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
        state_machine.add(fashion_strengthen_Preview_hide_event_terminal)
        state_machine.add(fashion_strengthen_Preview_show_event_terminal)
        state_machine.add(fashion_strengthen_Preview_refresh_terminal)
        state_machine.init()
    end
    init_fashion_strengthen_Preview_terminal()
end

function FashionStrengthenPreview:onHide()
	self:setVisible(false)
end

function FashionStrengthenPreview:onShow()
	self:setVisible(true)
end


function FashionStrengthenPreview:loading()


	if FashionStrengthenPreview.cacheListView == nil then
		return 
	end
	-- self.example
	local equipGrade = tonumber(self.example.equip.user_equiment_grade)
	local skills = dms.int(dms["equipment_mould"], self.example.mould_id, equipment_mould.skill_equipment_adron_mould)
    local talentDatas = dms.searchs(dms["equipment_fashion_talent"], equipment_fashion_talent.group_id, skills)
    local open  = nil 
    local willopen = nil
    if table.getn(talentDatas) ~= 0 then
        for i,v in ipairs(talentDatas) do
        	if dms.atoi(v,equipment_fashion_talent.talent_id) > 0 then
        		local cell = FashionStrengthenPreviewListCell:createCell()
        		cell:init(v,equipGrade,FashionStrengthenPreview.asyncIndex)
        		FashionStrengthenPreview.cacheListView:addChild(cell)
				FashionStrengthenPreview.cacheListView:requestRefreshView()
				FashionStrengthenPreview.asyncIndex = FashionStrengthenPreview.asyncIndex + 1
        	end
        end
    end

end

function FashionStrengthenPreview:onUpdate(dt)

	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function FashionStrengthenPreview:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local equipGrade = tonumber(self.example.equip.user_equiment_grade)
	ccui.Helper:seekWidgetByName(root, "Text_11_0"):setString(equipGrade)
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1264")	
	FashionStrengthenPreview.asyncIndex = 1
	FashionStrengthenPreview.cacheListView = rewardListView
	self.currentListView = FashionStrengthenPreview.cacheListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	if #rewardListView:getItems() > 0 then
		rewardListView:removeAllItems()
	end
	self:loading()

end

function FashionStrengthenPreview:onInit()
	self:updateDraw()
end

function FashionStrengthenPreview:onEnterTransitionFinish()
    local csbFashionStrengthenPreviewCell = csb.createNode("fashionable_dress/fashionable_qianghua_yulan.csb")
    local root = csbFashionStrengthenPreviewCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionStrengthenPreviewCell)



   
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2564"), nil, 
    {
        terminal_name = "fashion_strengthen_Preview_close", 
        terminal_state = 0,
        _self = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    self:onInit()
    -- self:init()
    state_machine.unlock("fashion_strengthen_Preview_open", 0, "")
end

function FashionStrengthenPreview:init(params)
	self.example = params._datas._cell
	-- self:onInit()
	return self
end

function FashionStrengthenPreview:onExit()
	state_machine.remove("fashion_strengthen_Preview_hide_event")
	state_machine.remove("fashion_strengthen_Preview_show_event")
    state_machine.remove("fashion_strengthen_Preview_refresh")
end

function FashionStrengthenPreview:createCell( ... )
    local cell = FashionStrengthenPreview:new()
     -- cell:registerOnNodeEvent(cell)
    return cell
end

function FashionStrengthenPreview:closeCell( ... )
    local FashionStrengthenPreviewWindow = fwin:find("FashionStrengthenPreviewClass")
    if FashionStrengthenPreviewWindow == nil then
        return
    end
    fwin:close(FashionStrengthenPreviewWindow)
end