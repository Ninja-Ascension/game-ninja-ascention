-- ----------------------------------------------------------------------------------------------------
-- 说明：魔陷卡说明
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MagicCardInfo = class("MagicCardInfoClass", Window)

function MagicCardInfo:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.treasure_instance = nil
	self.types = nil -- 1 分解 2 重生
	app.load("client.refinery.TreasureInfoList")
    -- Initialize TreasureRebornPage page state machine.
    local function init_magic_card_info_init_terminal()
		-- 重生界面初始化，包含清除当前武将处理
        local magic_card_resolve_info_back_terminal = {
            _name = "magic_card_resolve_info_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(magic_card_resolve_info_back_terminal)
        state_machine.init()
    end
    
    init_magic_card_info_init_terminal()
end

function MagicCardInfo:onUpdateDraw1()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _magic_card_info[2]
	local info = {}
	info[1] = _magic_card_info[6]
	info[2] = _magic_card_info[7]
	info[3] = _magic_card_info[8]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
end

function MagicCardInfo:onUpdateDraw2()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _magic_card_info[1]
	local info = {}
	info[1] = _magic_card_info[3]
	info[2] = _magic_card_info[4]
	info[3] = _magic_card_info[5]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
end

function MagicCardInfo:onEnterTransitionFinish()
	local refinery_help = csb.createNode("refinery/refinery_help.csb")
	self:addChild(refinery_help)
	local root = refinery_help:getChildByName("root")
	table.insert(self.roots, root)
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_help"), nil, 
	{
		terminal_name = "magic_card_resolve_info_back",
	},
	nil, 0)
	if self.types == 1 then 
		self:onUpdateDraw1()
	else
		self:onUpdateDraw2()
	end
	
end

function MagicCardInfo:init(types)
	self.types = types
end

function MagicCardInfo:onExit()
	state_machine.remove("magic_card_resolve_info_back")
end
