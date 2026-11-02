--------------------------------------------------------------------------------------------------------------
--  说明：军团头像标示框
--------------------------------------------------------------------------------------------------------------
CnionLogoIconCell = class("CnionLogoIconCellClass", Window)

function CnionLogoIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	self.kuang = 1
	self.tub = 1
	self.gard = nil
	 -- Initialize union logo icon cell state machine.
    local function init_union_logo_icon_cell_terminal()
		-- 点击响应查看军团信息
		local union_logo_icon_cell_look_info_terminal = {
            _name = "union_logo_icon_cell_look_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	if cell.gard == nil then
            		return
            	end
				state_machine.excute("sm_union_form_page_update_draw", 0, cell.tub)
				state_machine.excute("union_the_meeting_change_sign_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更换现有工会的图标
		local union_logo_icon_cell_set_union_icon_terminal = {
            _name = "union_logo_icon_cell_set_union_icon",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.union.union_info.union_icon = cell.tub
						-- DSC重塑
						if __lua_project_id == __lua_project_l_digital then
							state_machine.excute("union_the_meeting_place_information_new_update_icon", 0, "")
						else
							state_machine.excute("union_the_meeting_place_information_update_icon", 0, "")
						end
						state_machine.excute("union_the_meeting_change_sign_close", 0, "")
					end
				end
            	protocol_command.unino_pic_frame_exchange.param_list = cell.tub.."\r\n"..cell.kuang
				NetworkManager:register(protocol_command.unino_pic_frame_exchange.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_logo_icon_cell_look_info_terminal)
		state_machine.add(union_logo_icon_cell_set_union_icon_terminal)
        state_machine.init()
    end
    -- call func init union logo icon cell state machine.
    init_union_logo_icon_cell_terminal()

end

function CnionLogoIconCell:updateDraw()
	local root = self.roots[1]
	local legion_tub = ccui.Helper:seekWidgetByName(root, "Panel_legion_tub")
	legion_tub:removeBackGroundImage()
	local legion_kuang = ccui.Helper:seekWidgetByName(root, "Panel_legion_kuang")
	if self.tub and self.tub ~= nil then
		legion_kuang:setBackGroundImage(string.format("images/ui/union_logo/union_logo_%d.png", self.tub))
	end

	-- setBackGroundImage

end

function CnionLogoIconCell:onInit()
	-- local root = cacher.createUIRef("legion/legion_icon.csb", "root")
	local csbLegionIcon = csb.createNode("legion/legion_icon.csb")
	local root = csbLegionIcon:getChildByName("root")
	root:removeFromParent(false)
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	self:updateDraw()
	if self.gard == 1 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_legion_kuang"), nil, 
		{
			terminal_name = "union_logo_icon_cell_look_info", 
			terminal_state = 0,
			cell = self,
			gard = self.gard,
			isPressedActionEnabled = false
		}, 
		nil, 0)
	elseif self.gard == nil then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_legion_kuang"), nil, 
		{
			terminal_name = "union_logo_icon_cell_set_union_icon", 
			terminal_state = 0,
			cell = self,
			gard = self.gard,
			isPressedActionEnabled = false
		}, 
		nil, 0)	
	else
		ccui.Helper:seekWidgetByName(root, "Panel_legion_kuang"):setSwallowTouches(false)	
	end	
	
	
end

function CnionLogoIconCell:onEnterTransitionFinish()

end

function CnionLogoIconCell:init(kuang,tub,gard)
	self.kuang = tonumber(kuang)
	self.tub = tonumber(tub)
	if gard ~= nil then
		self.gard = tonumber(gard)
	end	
	self:onInit()
	return self
end

function CnionLogoIconCell:onExit()
	-- cacher.freeRef("legion/legion_icon.csb", self.roots[1])
end

function CnionLogoIconCell:createCell()
	local cell = CnionLogoIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
