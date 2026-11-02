----------------------------------------------------------------------------------------------------
-- 说明：天命的显示属性增强弹出界面
-------------------------------------------------------------------------------------------------------
DestinyAddPropertyInfoCell = class("DestinyAddPropertyInfoCellClass", Window)

function DestinyAddPropertyInfoCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		
	
	local function init_DestinySystem_terminal()
		--关闭界面
		local destiny_property_close_page_terminal = {
			_name = "destiny_property_close_page",
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
		state_machine.add(destiny_property_close_page_terminal)
		state_machine.init()
	end
    -- call func init hom state machine.
    init_DestinySystem_terminal()
end

function DestinyAddPropertyInfoCell:onUpdateDraw()
	-- 属性界面用211 协议
	-- _ED.cur_star_count = npos(list)--当前副本星数
	-- _ED.cur_destiny_id = npos(list)--当前天命id(最新点亮的,没有为0)
	-- _ED.commander_add = npos(list)--统帅加成
	-- _ED.force_add = npos(list)--武力加成
	-- _ED.wit_add = npos(list)--智力加成
	-- _ED.atk_add = npos(list)--攻击加成
	-- _ED.hp_add = npos(list)--生命加成
	-- _ED.def_add = npos(list)--物防加成
	-- _ED.res_add = npos(list)--法防加成
	local root = self.roots[1]
	
	local text_physics = ccui.Helper:seekWidgetByName(root, "Text_6")--物理防御
	local text_magic = ccui.Helper:seekWidgetByName(root, "Text_7")--法术防御
	local text_life = ccui.Helper:seekWidgetByName(root, "Text_8")--生命防御
	local text_attack = ccui.Helper:seekWidgetByName(root, "Text_9")--攻击防御
	
	text_physics:setString(_ED.def_add)
	text_magic:setString(_ED.res_add)
	text_life:setString(_ED.hp_add)
	text_attack:setString(_ED.atk_add)
end

function DestinyAddPropertyInfoCell:onEnterTransitionFinish()	
    local csbDestinySystem = csb.createNode("destiny/destiny_property.csb")
    self:addChild(csbDestinySystem)
	local root = csbDestinySystem:getChildByName("root")
	self.size = root:getContentSize()
	self:setContentSize(self.size)
	table.insert(self.roots, root)

	self:onUpdateDraw()
	
	local action = csb.createTimeline("destiny/destiny_property.csb")
	csbDestinySystem:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sgz_proper"), nil, 
		{func_string = [[state_machine.excute("destiny_property_close_page", 0, "click destiny_property_close_page.'")]]}, nil, 0)
end

function DestinyAddPropertyInfoCell:onExit()
	state_machine.remove("destiny_property_close_page")
	
end

function DestinyAddPropertyInfoCell:init()
	
end


function DestinyAddPropertyInfoCell:createCell()
	local cell = DestinyAddPropertyInfoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

