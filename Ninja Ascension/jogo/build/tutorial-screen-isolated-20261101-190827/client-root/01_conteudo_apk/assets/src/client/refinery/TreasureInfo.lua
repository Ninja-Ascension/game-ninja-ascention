-- ----------------------------------------------------------------------------------------------------
-- 说明：回收说明界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TreasureInfo = class("TreasureInfoClass", Window)

function TreasureInfo:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.treasure_instance = nil
	self.types = nil
	app.load("client.refinery.TreasureInfoList")
    -- Initialize TreasureRebornPage page state machine.
    local function init_treasure_info_init_terminal()
		-- 重生界面初始化，包含清除当前武将处理
        local treasure_reborn_info_back_terminal = {
            _name = "treasure_reborn_info_back",
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

        state_machine.add(treasure_reborn_info_back_terminal)
        state_machine.init()
    end
    
    init_treasure_info_init_terminal()
end

function TreasureInfo:onUpdateDraw1()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _treasure_info[1]
	local info = {}
	info[1] = _treasure_info[17]
	info[2] = _treasure_info[18]
	info[3] = _treasure_info[19]
	info[4] = _treasure_info[20]
	info[5] = _treasure_info[21]
	info[6] = _treasure_info[22]
	info[7] = _treasure_info[23]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
	
end

function TreasureInfo:onUpdateDraw2()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _treasure_info[2]
	local info = {}
	info[1] = _treasure_info[14]
	info[2] = _treasure_info[15]
	info[3] = _treasure_info[16]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
	
end

function TreasureInfo:onUpdateDraw3()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _treasure_info[3]
	local info = {}
	info[1] = _treasure_info[8]
	info[2] = _treasure_info[9]
	info[3] = _treasure_info[10]
	info[4] = _treasure_info[11]
	info[5] = _treasure_info[12]
	info[6] = _treasure_info[13]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
	
	
end

function TreasureInfo:onUpdateDraw4()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _treasure_info[4]
	local info = {}
	info[1] = _treasure_info[5]
	info[2] = _treasure_info[6]
	info[3] = _treasure_info[7]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
	
end
function TreasureInfo:onUpdateDraw5()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local name = _union_info[1]
	local info = {}
	info[1] = _union_info[2]
	info[2] = _union_info[3]
	info[3] = _union_info[4]
	info[4] = _union_info[5]
	info[5] = _union_info[6]
	info[6] = _union_info[7]
	info[7] = _union_info[8]
	info[8] = _union_info[9]
	
	local cell = TreasureInfoList:createCell()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		cell:init(name, info,5)
	else
		cell:init(name, info)
	end
	listView:addChild(cell)
	
end
function TreasureInfo:onUpdateDraw6()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root,"ListView_1")
	local name = _union_info[10]
	local info = {}
	info[1] = _union_info[11]
	info[2] = _union_info[12]
	info[3] = _union_info[13]
	info[4] = _union_info[14]
	info[5] = _union_info[15]
	info[6] = _union_info[16]
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
end
function TreasureInfo:onUpdateDraw7()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root,"ListView_1")
	local name = ""
	local info = {}
	info[1] = _capture_resource_tip_info
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local cell = cc.Label:createWithTTF(_capture_resource_tip_info, "fonts/FZYiHei-M20S.ttf", 
				19 / CC_CONTENT_SCALE_FACTOR(), cc.size(listView:getContentSize().width - 10, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		cell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		cell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		listView:setContentSize(cell:getContentSize())
		listView:getInnerContainer():setContentSize(cell:getContentSize())
		listView:addChild(cell)
		listView:requestRefreshView()
	else
		local cell = TreasureInfoList:createCell()
		cell:init(name, info)
		listView:addChild(cell)
	end
end

function TreasureInfo:onUpdateDraw8()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root,"ListView_1")
	local name = ""
	local info = {}
	info[1] = _union_fight_tip_info
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
end

--装备重生
function TreasureInfo:onUpdateDraw9()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root,"ListView_1")
	local name = _equip_ment_info[1]
	local info = {}
	info[1] = _equip_ment_info[2]
	info[2] = _equip_ment_info[3]
	info[3] = _equip_ment_info[4]
	info[4] = _equip_ment_info[5]
	
	local cell = TreasureInfoList:createCell()
	cell:init(name, info)
	listView:addChild(cell)
end

function TreasureInfo:onEnterTransitionFinish()
	local refinery_help = csb.createNode("refinery/refinery_help.csb")
	self:addChild(refinery_help)
	local root = refinery_help:getChildByName("root")
	table.insert(self.roots, root)
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_help"), nil, 
	{
		terminal_name = "treasure_reborn_info_back",
	},
	nil, 0)
	
	if self.types == 1 then
		self:onUpdateDraw1()
	elseif self.types == 2 then
		self:onUpdateDraw2()
	elseif self.types == 3 then
		self:onUpdateDraw3()
	elseif self.types == 4 then
		self:onUpdateDraw4()
	elseif self.types == 5 then
		self:onUpdateDraw5()
	elseif self.types == 6 then
		self:onUpdateDraw6()
	elseif self.types == 7 then
		self:onUpdateDraw7()
	elseif self.types == 8 then
		self:onUpdateDraw8()
	elseif self.types == 9 then 
		self:onUpdateDraw9()
	end
	
end

function TreasureInfo:init(types)
	self.types = types
end

function TreasureInfo:onExit()
	state_machine.remove("treasure_reborn_info_back")
end
