-- ----------------------------------------------------------------------------------------------------
-- 说明：角色点击指引
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PageViewSeatRoleGuide = class("PageViewSeatRoleGuideClass", Window)
    
function PageViewSeatRoleGuide:ctor()
    self.super:ctor()
	app.load("client.battle.fight.FightEnum")
	self.roots = {}
	self.actions = {}
	
	local function init_terminal()
		
		-- 强制关闭
		local page_stage_general_close_terminal = {
            _name = "pageview_seat_role_guide_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				if type(instance.getParent) == "function" then
				
					local p = instance:getParent()
					if nil ~=  p then
						p:removeChild(instance)
					end
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
	
		state_machine.add(page_stage_general_close_terminal)
        state_machine.init()
	end
	init_terminal()
	
end


function PageViewSeatRoleGuide:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("utils/teaching_1.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
end

function PageViewSeatRoleGuide:init()
	
end


function PageViewSeatRoleGuide:onExit()
	state_machine.remove("pageview_seat_role_guide_close")
end


function PageViewSeatRoleGuide:createCell()
	local cell = PageViewSeatRoleGuide:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
