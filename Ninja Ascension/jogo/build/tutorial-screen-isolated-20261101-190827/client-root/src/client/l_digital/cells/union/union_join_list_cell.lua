--------------------------------------------------------------------------------------------------------------
--  说明：加入军团界面列表
--------------------------------------------------------------------------------------------------------------
Unionjoinlistcell = class("UnionjoinlistcellClass", Window)
Unionjoinlistcell.__size = nil

function Unionjoinlistcell:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	app.load("client.l_digital.union.create.SmUnionInfoWindow")

	self.example = nil
	self.index = 0
	self.page_number = 0
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
					local approval_status = zstring.split(mcell.example.approval_status ,",")
				    if tonumber(approval_status[1]) == 2 then
				    	--无法加入的提示
				    	TipDlg.drawTextDailog(_new_interface_text[58])
				    	return
				    end
				    if zstring.tonumber(approval_status[2]) > 0 then
				    	if zstring.tonumber(approval_status[2]) > tonumber(_ED.user_info.user_grade) then
				    		--等级不足的提示
				    		TipDlg.drawTextDailog(_new_interface_text[59])
				    		return
				    	end
				    end
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

        --查看
        local union_join_list_cell_to_view_terminal = {
            _name = "union_join_list_cell_to_view",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		local cell = params._datas.cell
				state_machine.excute("sm_union_info_window_window_open", 0, cell.example)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_join_list_cell_to_join_terminal)
		state_machine.add(union_join_list_cell_to_more_terminal)
		state_machine.add(union_join_list_cell_to_view_terminal)
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
					local approval_status = zstring.split(mcell.example.approval_status ,",")
					if tonumber(approval_status[1]) == 0 then
						local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                    app.load("client.l_digital.union.UnionTigerGate")
                                else
                                    app.load("client.union.UnionTigerGate")
                                end 
                                state_machine.excute("Union_open", 0, response.node)
                            end
                        end
                        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, mcell, responseCallback, false, nil)    
                        local function responseUnionFightCallback( response )
                        end
                        if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                            protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
                            NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, nil, responseUnionFightCallback, false, nil)
                        end
                        TipDlg.drawTextDailog(_new_interface_text[60])
					else
						mcell.quxbut:setVisible(true)
						mcell.shenqbut:setVisible(false)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						else
							state_machine.excute("union_join_refresh",0,params)
						end
					end

				else	
					mcell.quxbut:setVisible(false)
					mcell.shenqbut:setVisible(true)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					else
						state_machine.excute("union_join_refresh",0,params)
					end
				end
			end
		end
	end
	protocol_command.union_apply.param_list =  mcell.example.union_id.."\r\n"..btype
	NetworkManager:register(protocol_command.union_apply.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
end
function Unionjoinlistcell:quxSureTip( param )
	self.param = param
	self:quxSureTipCallBack(0)
end

function Unionjoinlistcell:updateDraw()
	local root =self.roots[1]
	if root == nil then
		return
	end
	local Text_p_number = ccui.Helper:seekWidgetByName(root, "Text_p_number")
	-- ccui.Helper:seekWidgetByName(root, "Text_14"):setString(self.example.union_president_name)
	local maxMember = dms.string(dms["union_lobby_param"], self.example.union_level, union_lobby_param.maxMember)
	if Text_p_number and self.example and self.example ~= nil and self.example.union_member and self.example.union_member ~= nil and maxMember and maxMember ~= nil and self.example.union_science_num and self.example.union_science_num ~= nil then
		Text_p_number:setString(self.example.union_member.."/"..(zstring.tonumber(maxMember)+zstring.tonumber(self.example.union_science_num)))
	end
	ccui.Helper:seekWidgetByName(root, "Text_legion_name"):setString(self.example.union_name)
	ccui.Helper:seekWidgetByName(root, "Text_legion_lv"):setString("Lv"..self.example.union_level)

	local Text_condition_lv = ccui.Helper:seekWidgetByName(root, "Text_condition_lv")	--限制的等级
	local Text_condition_examine = ccui.Helper:seekWidgetByName(root, "Text_condition_examine")	--限制的内容
	local approval_status = zstring.split(self.example.approval_status ,",")
    local strs = ""
    if tonumber(approval_status[2]) == 0 then
        strs = union_limit_title[4]
    else
        strs = string.format(_new_interface_text[5],zstring.tonumber(approval_status[2]))
    end
    Text_condition_lv:setString(strs)
    Text_condition_examine:setString(union_limit_title[tonumber(approval_status[1])+1])

	local qux = ccui.Helper:seekWidgetByName(root, "Button_12")
	local shenq = ccui.Helper:seekWidgetByName(root, "Button_11")
	local icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_logo")
	icon:removeAllChildren(true)

	local quality = tonumber(self.example.union_icon)
	local kuang = tonumber(self.example.union_kuang)
	local cell = CnionLogoIconCell:createCell()
	cell:init(kuang,quality,1)
	-- icon:removeAllChildren(true)
	icon:addChild(cell)

	for i=1,3 do
		ccui.Helper:seekWidgetByName(root, "Image_pm_"..i):setVisible(false)
	end
	ccui.Helper:seekWidgetByName(root, "Text_pm"):setString("")

	local rank = tonumber(self.index) + self.page_number * 10
	if self.page_number == -1 then
		rank = zstring.tonumber(self.example.union_rank) 
	end

	if rank <= 3 then
		ccui.Helper:seekWidgetByName(root, "Image_pm_"..rank):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Text_pm"):setString(rank)
	end
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
	local root = cacher.createUIRef(path, "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	-- 列表控件动画播放
	-- local action = csb.createTimeline("legion/legion_list_list.csb")
 --    root:runAction(action)
    -- action:play("list_view_cell_open", false)
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

	--查看工会信息
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_12"), nil, 
    {
        terminal_name = "union_join_list_cell_to_view", 
        terminal_state = 0,
        cell = self
    }, 
    nil, 0)
    
end

function Unionjoinlistcell:onEnterTransitionFinish()

end

--page_number -1：公会搜索
function Unionjoinlistcell:init(example,index,page_number)
	self.page_number = page_number
	self.example = example
	self.index = index

	-- if index < 5 then
		self:onInit()
	-- end

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
