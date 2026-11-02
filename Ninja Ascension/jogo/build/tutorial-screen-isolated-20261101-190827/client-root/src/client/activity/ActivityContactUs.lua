-- ----------------------------------------------------------------------------------------------------
-- 说明：联系我们
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityContactUs = class("ActivityContactUsClass", Window)
    
function ActivityContactUs:ctor()
    self.super:ctor()
	self.roots = {}

	local function init_activity_contact_us_window_terminal()
		-- FB跳转
		local activity_contact_us_jump_to_facebook_terminal = {
			_name = "activity_contact_us_jump_to_facebook",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if tipStringInfo_customer_service_tips[1] ~= nil then
					handlePlatformRequest(0, CC_OPEN_URL, tipStringInfo_customer_service_tips[1])
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

        state_machine.add(activity_contact_us_jump_to_facebook_terminal)
        state_machine.init()
    end

    init_activity_contact_us_window_terminal()
end

function ActivityContactUs:onUpdateDraw()
	local root = self.roots[1]
	local Text_linkto = ccui.Helper:seekWidgetByName(root, "Text_linkto")
	-- La maqueta ko de contact_us.csb no trae Text_linkto: sin esta guarda
	-- la ventana daba error de Lua en coreano.
	if Text_linkto ~= nil then
		Text_linkto:setString(tipStringInfo_customer_service_tips[1])
	end


 	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "activity_contact_us_jump_to_facebook",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function ActivityContactUs:initDraw()
	
end


function ActivityContactUs:onEnterTransitionFinish()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/contact_us.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	self:onUpdateDraw()
end

function ActivityContactUs:onExit()
   state_machine.remove("activity_contact_us_jump_to_facebook")
end

function ActivityContactUs:init()

end


function ActivityContactUs:createCell()
	local cell = ActivityContactUs:new()
	cell:registerOnNodeEvent(cell)
	return cell
end