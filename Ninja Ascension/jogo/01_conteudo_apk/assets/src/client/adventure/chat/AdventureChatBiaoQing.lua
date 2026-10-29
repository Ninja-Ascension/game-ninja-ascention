-----------------------------------------------------------------------------------------------
-- 说明：聊天表情
-------------------------------------------------------------------------------------------------------

AdventureChatBiaoQing = class("AdventureChatBiaoQingClass", Window)
    
function AdventureChatBiaoQing:ctor()
    self.super:ctor()
	self.roots = {}
	self.id = nil
	self.types = nil
    -- Initialize ChatWorldPage page state machine.
    local function init_adventure_chat_biaoqing_terminal()
	
		local adventure_chat_biaoqing_terminal = {
            _name = "chat_biaoqing",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local types = params._datas._type
				local id = params._datas._id
				if types == 1 then
					state_machine.excute("adventure_chat_world_page_add_image", 0, id)
				elseif types == 2 then
					state_machine.excute("adventure_union_world_page_add_image", 0, id)
				elseif types == 3 then
					state_machine.excute("adventure_chat_whisper_page_add_image", 0, id)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		state_machine.add(adventure_chat_biaoqing_terminal)

        state_machine.init()
    end
    -- call func init hom state machine.
    init_adventure_chat_biaoqing_terminal()
end


function AdventureChatBiaoQing:onEnterTransitionFinish()
    local csbItem = csb.createNode("Chat/chat_biaoqing.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)
	
	
	local panel_bq = ccui.Helper:seekWidgetByName(root, "Panel_chat_biaoqing")
	local MySize = panel_bq:getContentSize()
	self:setContentSize(MySize)
	
	panel_bq:setBackGroundImage(string.format("images/ui/biaoqing/%d.png", tonumber(self.id)))
	fwin:addTouchEventListener(panel_bq, nil, 
	{
		terminal_name = "chat_biaoqing", 	
		_id = self.id,
		_type = self.types,
		terminal_state = 0,
	}, 
	nil, 0)

end


function AdventureChatBiaoQing:onExit()

end

function AdventureChatBiaoQing:init(id,types)
	self.id = id
	self.types = types			--1为世界聊天
end

function AdventureChatBiaoQing:createCell()
	local cell = AdventureChatBiaoQing:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
