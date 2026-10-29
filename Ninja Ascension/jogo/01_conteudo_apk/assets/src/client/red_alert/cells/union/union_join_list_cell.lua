--------------------------------------------------------------------------------------------------------------
--  说明：加入军团界面列表
--------------------------------------------------------------------------------------------------------------
Unionjoinlistcell = class("UnionjoinlistcellClass", Window)
Unionjoinlistcell.__size = nil
--创建cell
local union_join_list_create_cell_terminal = {
    _name = "union_join_list_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local example = params[1]
        local index = params[2]
        local cell = Unionjoinlistcell:new()
        cell:init(example, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_join_list_create_cell_terminal)
state_machine.init()
function Unionjoinlistcell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.example = nil
	self.index = 0
	self.param = nil
	self.size = nil

	app.load("client.utils.ConfirmTip")

    local function init_union_join_list_cell_terminal()
		local union_join_list_cell_to_join_terminal = {
            _name = "union_join_list_cell_to_join",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mcell = params._datas.cell
				local btype = params._datas.btype
				if tonumber(btype) == 1 then
					mcell.param = params
					mcell:quxSureTipCallBack(0)
				else
					mcell:quxSureTip(params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_join_list_cell_to_join_terminal)
        state_machine.init()
    end
    init_union_join_list_cell_terminal()
end

function Unionjoinlistcell:quxSureTipCallBack(n)
	if n ~= 0 then
		return
	end
	local params = self.param
	local mcell = params._datas.cell
	local btype = params._datas.btype
	local index = params._datas._index
	local function responseUnionSearchCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				local params = response.node.param
				local mcell = params._datas.cell
				local btype = params._datas.btype
				local index = params._datas._index				
				params._datas.union_id = mcell.example.union_id
				if tonumber(btype) == 1 then
					mcell.quxbut:setVisible(true)
					mcell.shenqbut:setVisible(false)
				else	
					mcell.quxbut:setVisible(false)
					mcell.shenqbut:setVisible(true)
				end
			end
		end
	end
	protocol_command.union_apply.param_list = mcell.example.union_id.."\r\n"..btype
	NetworkManager:register(protocol_command.union_apply.code, nil, nil, nil, mcell, responseUnionSearchCallback, false, nil)
end

function Unionjoinlistcell:quxSureTip( param )
	self.param = param
	local tip = ConfirmTip:new()
	tip:init(self, self.quxSureTipCallBack, tipStringInfo_union_str[38])
	fwin:open(tip,fwin._ui)
end

function Unionjoinlistcell:updateDraw()
	local root =self.roots[1]
	if root == nil then
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_14"):setString(self.example.union_president_name)
	ccui.Helper:seekWidgetByName(root, "Text_15"):setString(self.example.union_member)
	ccui.Helper:seekWidgetByName(root, "Text_16"):setString(self.example.union_watchword)
	ccui.Helper:seekWidgetByName(root, "Text_11"):setString(self.example.union_name)
	ccui.Helper:seekWidgetByName(root, "Text_17"):setString(self.example.union_level)
	local icon = ccui.Helper:seekWidgetByName(root, "Panel_79")
	icon:setBackGroundImage("images/ui/quality/camp_"..self.example.union_camp..".png")
	if tonumber(self.example.union_appiy) == 0 then
		self.quxbut:setVisible(false)
		self.shenqbut:setVisible(true)
	else
		self.quxbut:setVisible(true)
		self.shenqbut:setVisible(false)
	end
end

function Unionjoinlistcell:onInit()
	local root = cacher.createUIRef(config_csb.cells.legion.legion_list_list, "root")
    self:addChild(root)
	table.insert(self.roots, root)

	if Unionjoinlistcell.__size == nil then
		Unionjoinlistcell.__size = root:getChildByName("Panel_12"):getContentSize()
	end

	self.quxbut = ccui.Helper:seekWidgetByName(root, "Button_12")
	self.shenqbut = ccui.Helper:seekWidgetByName(root, "Button_11")

	fwin:addTouchEventListener(self.shenqbut, nil, 
    {
        terminal_name = "union_join_list_cell_to_join", 
        terminal_state = 0,
        cell = self,
		btype = 1,
		_index = self.index,
        isPressedActionEnabled = false
    }, 
    nil, 0)

	fwin:addTouchEventListener(self.quxbut, nil, 
    {
        terminal_name = "union_join_list_cell_to_join", 
        terminal_state = 0,
        cell = self,
		btype = 0,
		_index = self.index,
        isPressedActionEnabled = false
    }, 
    nil, 0)
	self:updateDraw()
end

function Unionjoinlistcell:onEnterTransitionFinish()

end

function Unionjoinlistcell:init(example, index)
	self.example = example
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(Unionjoinlistcell.__size)
	return self
end

function Unionjoinlistcell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function Unionjoinlistcell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(config_csb.cells.legion.legion_list_list, root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function Unionjoinlistcell:onExit()
	if self.roots[1] ~= nil then
		cacher.freeRef(config_csb.cells.legion.legion_list_list, self.roots[1])
	end
end

function Unionjoinlistcell:createCell()
	local cell = Unionjoinlistcell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
