-----------------------------------------------------------------------------------------------
-- 说明：世界聊天表情
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatBiaoQing = class("ChatBiaoQingClass", Window)
    
function ChatBiaoQing:ctor()
    self.super:ctor()
	self.roots = {}
	self.id = nil
	self.types = nil
    -- Initialize ChatWorldPage page state machine.
    local function init_chat_biaoqing_terminal()
	
		local chat_biaoqing_terminal = {
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
					state_machine.excute("chat_world_page_add_image", 0, id)
				elseif types == 2 then
					state_machine.excute("union_world_page_add_image", 0, id)
				elseif types == 3 then
					state_machine.excute("chat_whisper_page_add_image", 0, id)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		state_machine.add(chat_biaoqing_terminal)

        state_machine.init()
    end
    -- call func init hom state machine.
    init_chat_biaoqing_terminal()
end


function ChatBiaoQing:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		return
	end
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


function ChatBiaoQing:onExit()

end

function ChatBiaoQing:init(id,types)
	self.id = id
	self.types = types			--1为世界聊天
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		local csbItem = csb.createNode("Chat/chat_biaoqing.csb")
		local root = csbItem:getChildByName("root")
		root:removeFromParent(true)
	    self:addChild(root)
		table.insert(self.roots, root)
		local panel_bq = ccui.Helper:seekWidgetByName(root, "Panel_chat_biaoqing")	
		
		local image = ccui.Helper:seekWidgetByName(root, "Image_1")	
		local MySize = image:getContentSize()
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
end

function ChatBiaoQing:createCell()
	local cell = ChatBiaoQing:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
