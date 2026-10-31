--------------------------------------------------------------------------------------------------------------
--  说明：加入军团界面列表
--------------------------------------------------------------------------------------------------------------
Unionjoinlistcell = class("UnionjoinlistcellClass", Window)
Unionjoinlistcell.__size = nil

function Unionjoinlistcell:ctor()
	self.super:ctor()
	self.roots = {}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		app.load("client.l_digital.cells.union.union_logo_icon_cell")
	else
		app.load("client.cells.union.union_logo_icon_cell")
	end
	self.example = nil
	self.index = 0
	self.last = false
	self.param = nil
	self.size =nil
	 -- Initialize union join list cell state machine.
    local function init_union_join_list_cell_terminal()
		local union_join_list_cell_to_join_terminal = {
            _name = "union_join_list_cell_to_join",
            _init = function (terminal)
                app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mcell = params._datas.cell
				local btype = params._datas.btype
				if tonumber(btype) == 0 then
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
        local union_join_list_cell_to_more_terminal = {
            _name = "union_join_list_cell_to_more",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		local index = params._datas._index
				state_machine.excute("union_join_to_more", 0, {_datas={_index=index}})
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_join_list_cell_to_join_terminal)
		state_machine.add(union_join_list_cell_to_more_terminal)
        state_machine.init()
    end
    -- call func init union join list cell state machine.
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

			if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
				local params = response.node.param
				local mcell = params._datas.cell
				local btype = params._datas.btype
				local index = params._datas._index				
				params._datas.union_id = mcell.example.union_id
				if tonumber(btype) == 0 then
					mcell.quxbut:setVisible(true)
					mcell.shenqbut:setVisible(false)
					state_machine.excute("union_join_refresh",0,params)

				else	
					mcell.quxbut:setVisible(false)
					mcell.shenqbut:setVisible(true)
					state_machine.excute("union_join_refresh",0,params)
				end
			end
		end
	end
	protocol_command.union_apply.param_list =  mcell.example.union_id.."\r\n"..btype
	NetworkManager:register(protocol_command.union_apply.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
	
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
	local qux = ccui.Helper:seekWidgetByName(root, "Button_12")
	local shenq = ccui.Helper:seekWidgetByName(root, "Button_11")
	local icon = ccui.Helper:seekWidgetByName(root, "Panel_79")

	local quality = tonumber(self.example.union_icon)
	local kuang = tonumber(self.example.union_kuang)
	local cell = CnionLogoIconCell:createCell()
	cell:init(kuang,quality,nil)
	-- icon:removeAllChildren(true)
	icon:addChild(cell)
---	print("self.example.union_appiy====",self.example.union_appiy,self.index,self.example.union_id)
	if tonumber(self.example.union_appiy) == 0 then
		self.quxbut:setVisible(false)
		self.shenqbut:setVisible(true)
	else
		self.quxbut:setVisible(true)
		self.shenqbut:setVisible(false)
	end
end

function Unionjoinlistcell:onInit()
	local path = "legion/legion_list_list.csb"
	if self.last == true then 
		path = "legion/legion_list_more.csb"
	end
	local root = cacher.createUIRef(path, "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	if self.last == true then 



		self.size = root:getChildByName("Panel_list_more"):getContentSize()
		--gengduo
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_list_more"), nil, 
	    {
	        terminal_name = "union_join_list_cell_to_more", 
	        terminal_state = 0,
	        cell = self,
			_index = self.index,
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)

		return
	end
	-- 列表控件动画播放
	local action = csb.createTimeline("legion/legion_list_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
	if Unionjoinlistcell.__size == nil then
		Unionjoinlistcell.__size = root:getChildByName("Panel_12"):getContentSize()
	end	
	self.quxbut = ccui.Helper:seekWidgetByName(root, "Button_12")
	self.shenqbut = ccui.Helper:seekWidgetByName(root, "Button_11")
	self:updateDraw()
	--申请
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
    {
        terminal_name = "union_join_list_cell_to_join", 
        terminal_state = 0,
        cell = self,
		btype = 0,
		_index = self.index,
        isPressedActionEnabled = false
    }, 
    nil, 0)
	--取消申请
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
    {
        terminal_name = "union_join_list_cell_to_join", 
        terminal_state = 0,
        cell = self,
		btype = 1,
		_index = self.index,
        isPressedActionEnabled = false
    }, 
    nil, 0)
end

function Unionjoinlistcell:onEnterTransitionFinish()

end

function Unionjoinlistcell:init(example,index,last)
	self.last = last
	self.example = example
	self.index = index

	if index < 5 then
		self:onInit()
	end

	if self.last == true and self.size ~= nil then
		self:setContentSize(self.size)
	else
		self:setContentSize(Unionjoinlistcell.__size)
	end
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
	cacher.freeRef("legion/legion_list_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function Unionjoinlistcell:onExit()
	cacher.freeRef("legion/legion_list_list.csb", self.roots[1])
end

function Unionjoinlistcell:createCell()
	local cell = Unionjoinlistcell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
