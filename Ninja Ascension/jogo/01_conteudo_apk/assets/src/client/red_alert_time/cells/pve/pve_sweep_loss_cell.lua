----------------------------------------------------------------------------------------------------
-- 说明：扫荡损失cell
-------------------------------------------------------------------------------------------------------
PveSweepLossCell = class("PveSweepLossCellClass", Window)
PveSweepLossCell.__size = nil
PveSweepLossCell.__scroll_size = nil

local pve_sweep_loss_create_cell_terminal = {
    _name = "pve_sweep_loss_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveSweepLossCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_sweep_loss_create_cell_terminal)
state_machine.init()

function PveSweepLossCell:ctor()
    self.super:ctor()
	self.roots = {}		
	self.old_formation = nil
	
 	local function init_pve_sweep_loss_cell_terminal()
        local pve_sweep_loss_cell_choose_terminal = {
            _name = "pve_sweep_loss_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_sweep_loss_cell_choose_terminal)
        state_machine.init()
    end
	init_pve_sweep_loss_cell_terminal()        	
end

function PveSweepLossCell:onUpdateDraw()
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")
	local Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")
	m_ScrollView:removeAllChildren(true)
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setName("cellPanel")
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)

    local loss_formation = {}
    for k, v in pairs(self.old_formation) do
        if zstring.tonumber(v.loss_count) > 0 then
            table.insert(loss_formation, v)
        end
    end

	local height = m_ScrollView:getContentSize().height
	local number = #loss_formation
	if number/3 > 0 then
		height = math.ceil(number/3)*height
	else
		height = height
	end
	local upHeight = 0 
	panel:setContentSize(cc.size(m_ScrollView:getContentSize().width, height))
	if height > m_ScrollView:getContentSize().height then
		upHeight = height - m_ScrollView:getContentSize().height
		root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height+upHeight))
		PveSweepLossCell.__size = root:getContentSize()
		Text_tip:setPositionY(Text_tip:getPositionY()+upHeight)
		m_ScrollView:setContentSize(panel:getContentSize())
		m_ScrollView:setPositionY(m_ScrollView:getPositionY()+upHeight)
	else
		root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height))
		PveSweepLossCell.__size = root:getContentSize()
		Text_tip:setPositionY(Text_tip:getPositionY())
		m_ScrollView:setContentSize(panel:getContentSize())
		m_ScrollView:setPositionY(m_ScrollView:getPositionY())
	end
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getContentSize()
	local cellWidth = sSize.width / 3
	
	for i = 1, #loss_formation do
        local cell = state_machine.excute("pve_sweep_loss_icon_create_cell",0,loss_formation[i])

		local cellHeight = cell:getContentSize().height-5
		local row = math.floor((i - 1) / 3 + 1)
		local col = math.floor((i - 1) % 3)
		local controlHeight = row * cellHeight
		if controlHeight < sSize.height then
			controlSize.height = sSize.height
		else
			controlSize.height = controlHeight
		end
		m_ScrollView:setContentSize(cc.size(controlSize.width, controlSize.height))
		local pos = cc.p(cellWidth * col + (cellWidth - cell:getContentSize().width)/2,sSize.height - cellHeight * row)
		cell:setPosition(pos)
		cell.panel = panel
		panel:addChild(cell)
	end
	
end

function PveSweepLossCell:onEnterTransitionFinish()
	
end

function PveSweepLossCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.pve.pve_sweep_cell_loss, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PveSweepLossCell.__size == nil then
		PveSweepLossCell.__size = root:getContentSize()
	end
	local Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")
	local m_ScrollView = ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")

    if PveSweepLossCell.__scroll_size == nil then
        PveSweepLossCell.__scroll_size = m_ScrollView:getContentSize()
    end

	if root._size == nil then
		root._size = root:getContentSize()
	end
	if root._y == nil then
		root._y = root:getPositionY()
	end
	if ccui.Helper:seekWidgetByName(root,"Text_tip")._y == nil then
		ccui.Helper:seekWidgetByName(root,"Text_tip")._y = ccui.Helper:seekWidgetByName(root,"Text_tip"):getPositionY()
	end
	if ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")._size == nil then
		ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")._size = ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon"):getContentSize()
	end
	if ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")._y == nil then
		ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")._y = ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon"):getPositionY()
	end
	
	root:setContentSize(root._size)
    m_ScrollView:setContentSize(PveSweepLossCell.__scroll_size)
	PveSweepLossCell.__size = root:getContentSize()
	ccui.Helper:seekWidgetByName(root,"Text_tip"):setPositionY(ccui.Helper:seekWidgetByName(root,"Text_tip")._y)
	ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon"):setContentSize(ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")._size)
	ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon"):setPositionY(ccui.Helper:seekWidgetByName(root,"ScrollView_loss_icon")._y)

	self:onUpdateDraw()
end

function PveSweepLossCell:onExit()
	cacher.freeRef(config_csb.cells.pve.pve_sweep_cell_loss, self.roots[1])
end

function PveSweepLossCell:reload()
	-- local root = self.roots[1]
	-- if root ~= nil then
	-- 	return
	-- end
	-- self:onInit()
end

function PveSweepLossCell:unload()
	-- local root = self.roots[1]
	-- if root == nil then
	-- 	return
	-- end
	-- cacher.freeRef(config_csb.cells.pve.pve_sweep_cell_loss, root)
	-- root:removeFromParent(false)
	-- self.roots = {}
end

function PveSweepLossCell:init(params)
	self.old_formation = params
    self:onInit()
	self:setContentSize(PveSweepLossCell.__size)
end

