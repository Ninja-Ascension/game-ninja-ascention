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
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                app.load("client.l_digital.union.meeting.UnionTheMeetingChangeSign")
            else
				app.load("client.union.meeting.UnionTheMeetingChangeSign")
			end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if self.gard == nil then
            		return
            	end
				if tonumber(_ED.union.user_union_info.union_post) == 1 or  tonumber(_ED.union.user_union_info.union_post) == 2 then
					state_machine.excute("union_the_meeting_change_sign_open", 0, params)
				else
					TipDlg.drawTextDailog(tipStringInfo_union_str[33])
					return
				end	
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_logo_icon_cell_look_info_terminal)
        state_machine.init()
    end
    -- call func init union logo icon cell state machine.
    init_union_logo_icon_cell_terminal()

end

function CnionLogoIconCell:updateDraw()
	local root = self.roots[1]
	local legion_tub = ccui.Helper:seekWidgetByName(root, "Panel_legion_tub")
	local legion_kuang = ccui.Helper:seekWidgetByName(root, "Panel_legion_kuang")
	if self.kuang == 1 then
		legion_kuang:setBackGroundImage("images/ui/play/legion/legion_icon_box.png")
	else
		legion_kuang:setBackGroundImage(string.format("images/ui/play/legion/legion_icon_box_%d.png", tonumber(self.kuang)))
	end
	legion_tub:setBackGroundImage(string.format("images/ui/play/legion/juntuan_biaozhi_%d.png", self.tub))
	

	
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
	if self.gard ~= nil then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_legion_kuang"), nil, 
		{
			terminal_name = "union_logo_icon_cell_look_info", 
			terminal_state = 0,
			cell = self,
			gard = self.gard,
			isPressedActionEnabled = false
		}, 
		nil, 0)
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
