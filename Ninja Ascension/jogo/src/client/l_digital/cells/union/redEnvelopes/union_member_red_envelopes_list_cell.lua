--------------------------------------------------------------------------------------------------------------
--  说明：公会成员发的红包信息
--------------------------------------------------------------------------------------------------------------
unionMemberRedEnvelopesListCell = class("unionMemberRedEnvelopesListCellClass", Window)
unionMemberRedEnvelopesListCell.__size = nil
function unionMemberRedEnvelopesListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_member_red_envelopes_list_cell_terminal()
    	local union_member_red_envelopes_list_cell_update_draw_terminal = {
            _name = "union_member_red_envelopes_list_cell_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:updateDraw()
            	state_machine.excute("sm_union_grab_red_envelopes_update_draw", 0, "")
            	state_machine.excute("sm_union_red_envelopes_send_type_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    	-- 抢红包
        local union_member_red_envelopes_list_cell_hair_terminal = {
            _name = "union_member_red_envelopes_list_cell_hair",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        	
                        	local m_type = dms.int(dms["union_red_reward"], cell.example.mould_id, union_red_reward.m_type)
                        	state_machine.excute("sm_union_red_envelopes_draw_animation", 0, {m_type,"union_member_red_envelopes_list_cell_update_draw"})
                        end
                    end
                end
                state_machine.lock("union_member_red_envelopes_list_cell_hair", 0, "")
                protocol_command.union_red_packet_rap_manager.param_list = cell.example.id.."|"..cell.example.times
                NetworkManager:register(protocol_command.union_red_packet_rap_manager.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抢红包
        local union_member_red_envelopes_list_cell_open_rank_terminal = {
            _name = "union_member_red_envelopes_list_cell_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        	state_machine.excute("sm_union_red_envelopes_rank_open", 0, {-1,cell.example.name})
                        end
                    end
                end
                protocol_command.union_red_packet_rap_rank.param_list = "-1".."\r\n"..(cell.example.id.."-"..cell.example.times)
                NetworkManager:register(protocol_command.union_red_packet_rap_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_member_red_envelopes_list_cell_hair_terminal)
        state_machine.add(union_member_red_envelopes_list_cell_update_draw_terminal)
        state_machine.add(union_member_red_envelopes_list_cell_open_rank_terminal)


        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_member_red_envelopes_list_cell_terminal()

end

function unionMemberRedEnvelopesListCell:updateDraw()
	local root = self.roots[1]
	
	local propId = dms.int(dms["union_red_reward"], self.example.mould_id, union_red_reward.correspond_id)
	--道具
	local Panel_hb_icon = ccui.Helper:seekWidgetByName(root, "Panel_hb_icon")
	Panel_hb_icon:removeBackGroundImage()
	local prop_pic = dms.int(dms["prop_mould"], propId, prop_mould.pic_index)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        prop_pic = setThePropsIcon(propId)[1]
    end
    Panel_hb_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", prop_pic))

	--名称
	local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name") 
	Text_player_name:setString(self.example.name)
	--红包次数
	local Text_hbs = ccui.Helper:seekWidgetByName(root, "Text_hbs") 
	Text_hbs:setString(self.example.remain_number.."/"..dms.int(dms["union_red_reward"], self.example.mould_id, union_red_reward.number))
	--抢完了
	local Image_yqw = ccui.Helper:seekWidgetByName(root, "Image_yqw") 
	--抢的按钮
	local Button_qiang = ccui.Helper:seekWidgetByName(root, "Button_qiang") 
	self.to_view = false
	if tonumber(self.example.remain_number) == 0 then
		Image_yqw:setVisible(true)
		Button_qiang:setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Panel_247"):setTouchEnabled(true)
		self.to_view = true
	else
		Image_yqw:setVisible(false)
		Button_qiang:setVisible(true)
		Button_qiang:setBright(true)
		Button_qiang:setTouchEnabled(true)
		for i, v in pairs(_ED.union_red_envelopes_my_info) do
			local datas = zstring.split(v ,",")
			if tonumber(datas[4]) == tonumber(self.example.times) then
				Button_qiang:setBright(false)
				Button_qiang:setTouchEnabled(false)
				ccui.Helper:seekWidgetByName(root,"Panel_247"):setTouchEnabled(true)
				self.to_view = true
				break
			end
		end
	end


end

function unionMemberRedEnvelopesListCell:onInit()

	local csbunionMemberRedEnvelopesListCell= csb.createNode("legion/sm_legion_red_packet_tab_3_list.csb")
    local root = csbunionMemberRedEnvelopesListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionMemberRedEnvelopesListCell)
	if unionMemberRedEnvelopesListCell.__size == nil then
		unionMemberRedEnvelopesListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

	ccui.Helper:seekWidgetByName(root,"Panel_247"):setSwallowTouches(false)

	-- ccui.Helper:seekWidgetByName(root,"Panel_247"):setTouchEnabled(false)

	self:updateDraw()

	--抢红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_qiang"), nil, 
    {
        terminal_name = "union_member_red_envelopes_list_cell_hair",
        terminal_state = 0,
        cell = self,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

     local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
            -- sender.isMoving = false
        elseif eventType == ccui.TouchEventType.moved then 
            -- sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__epoint.y - __spoint.y) <= 8 then
                if self.to_view == true then
                    state_machine.excute("union_member_red_envelopes_list_cell_open_rank",0,{ _datas = { cell = self }})
                end
            end
        end
    end
    ccui.Helper:seekWidgetByName(root,"Panel_247"):addTouchEventListener(fourOpenTouchEvent)

    --看排行
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_247"), nil, 
 --    {
 --        terminal_name = "union_member_red_envelopes_list_cell_open_rank",
 --        terminal_state = 0,
 --        cell = self,
 --        touch_black = true,
 --        isPressedActionEnabled = true
 --    },
 --    nil,0)
end

function unionMemberRedEnvelopesListCell:onEnterTransitionFinish()

end

function unionMemberRedEnvelopesListCell:init(example,index)
	self.example = example
	self.index = index
	-- if index < 5 then
		self:onInit()
	-- end
	self:setContentSize(unionMemberRedEnvelopesListCell.__size)
	-- self:onInit()
	return self
end

function unionMemberRedEnvelopesListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionMemberRedEnvelopesListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_red_packet_tab_3_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionMemberRedEnvelopesListCell:onExit()
	cacher.freeRef("legion/sm_legion_red_packet_tab_3_list.csb", self.roots[1])
end

function unionMemberRedEnvelopesListCell:createCell()
	local cell = unionMemberRedEnvelopesListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
