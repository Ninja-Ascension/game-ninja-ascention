----------------------------------------------------------------------------------------------------
-- 说明：点击可以巡逻的领地
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerNoPerson = class("MineManagerNoPersonClass", Window)
    
function MineManagerNoPerson:ctor()
    self.super:ctor()
    self.roots = {}
	self.mouldId = nil
	app.load("client/campaign/mine/MineManagerChooseHero")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.prop.prop_icon_cell")
    -- Initialize MineManager page state machine.
    local function init_mine_manager_no_person_terminal()
	
		--返回
		local mine_manager_manor_no_person_back_terminal = {
            _name = "mine_manager_manor_no_person_back",
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
		
		local mine_manager_manor_no_person_into_terminal = {
            _name = "mine_manager_manor_no_person_into",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--选择伙伴上阵
				local cell = MineManagerChooseHero:new()
				cell:init(params._datas._id)
				fwin:open(cell, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_manor_no_person_back_terminal)
		state_machine.add(mine_manager_manor_no_person_into_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_no_person_terminal()
end

function MineManagerNoPerson:getCityBackGroundImage(index)
	local img = "images/ui/play/minemanager/bg_%d.jpg"
	return string.format(img,index)
end

--道具
function MineManagerNoPerson:getItemCell(mid,mtype,count)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cell:init(cellConfig)
	return cell
end

function MineManagerNoPerson:onUpdateDraw()
	local root = self.roots[1]
	local scrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_xl")
	local textOne = ccui.Helper:seekWidgetByName(root, "Text_xl_13")
	local textTwo = ccui.Helper:seekWidgetByName(root, "Text_xl_14")
	local textThree = ccui.Helper:seekWidgetByName(root, "Text_xl_15")
	local textFour = ccui.Helper:seekWidgetByName(root, "Text_xl_16")
	local textFive = ccui.Helper:seekWidgetByName(root, "Text_xl_17")
	local textSix = ccui.Helper:seekWidgetByName(root, "Text_xl_18")
	
	local bgPanel = ccui.Helper:seekWidgetByName(root, "Panel_80")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_157")
	
	
	-- 设置城池背景-------------------------------------------------------------------------------
	bgPanel:setBackGroundImage(self:getCityBackGroundImage(self.mouldId))

	-- 设置城池名称-------------------------------------------------------------------------------
	local cityName = dms.string(dms["manor_mould"], self.mouldId, manor_mould.manor_name)
	nameText:setString(cityName)
	
	-- 设置城池描述-------------------------------------------------------------------------------
	textOne:setString(string.format(tipStringInfo_mine_info[7],cityName))
	textTwo:setString(tipStringInfo_mine_info[10])
	textThree:setString(string.format(tipStringInfo_mine_info[8],cityName))
	textFour:setString(tipStringInfo_mine_info[10])
	textFive:setString(string.format(tipStringInfo_mine_info[9],cityName))
	textSix:setString(dms.string(dms["manor_mould"], self.mouldId, manor_mould.describe))
	
	-- 设置城池特产-------------------------------------------------------------------------------	
	local listView_hero = ccui.Helper:seekWidgetByName(root, "ListView_103")
	local listView_prop = ccui.Helper:seekWidgetByName(root, "ListView_104")

	local dropShip = zstring.split(dms.string(dms["manor_mould"], self.mouldId, manor_mould.drop_ship), ",")
	for i,v in  ipairs (dropShip) do
		local cell = self:getItemCell(tonumber(v),13)
		listView_hero:addChild(cell)
	end
	
	-- 6,60,1|6,53,1|6,9,1
	local dropProp = zstring.split(dms.string(dms["manor_mould"], self.mouldId, manor_mould.drop_prop), "|")
	for i,v in  ipairs (dropProp) do
		local item = zstring.split(v, ",")
		local mid = tonumber(item[2])
		local mtype = tonumber(item[1])
		local cell = self:getItemCell(mid,mtype)
		listView_prop:addChild(cell)
	end
	-- 设置顶部属性栏-------------------------------------------------------------------------------
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	self.userinfo = userinfo
end

function MineManagerNoPerson:onEnterTransitionFinish()
    local csbMineManager = csb.createNode("campaign/MineManager/attack_territory_add.csb")
    self:addChild(csbMineManager)
	
   	local root = csbMineManager:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_bc"), nil, {func_string = [[state_machine.excute("mine_manager_manor_no_person_back", 0, "mine_manager_manor_no_person_back.'")]],
			isPressedActionEnabled = true,}, nil, 2)
	
	--添加上阵英雄
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_add_5"), nil, 
	{
		terminal_name = "mine_manager_manor_no_person_into", 
		terminal_state = 0, 
		_id = self.mouldId,
		_instance = self,
	}, nil, 0)
	
	self:onUpdateDraw()
	
end

function MineManagerNoPerson:init(_id)
	self.mouldId = _id
end
function MineManagerNoPerson:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:close(self.userinfo)
	end
end
function MineManagerNoPerson:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else	
		fwin:close(self.userinfo)
	end
	state_machine.remove("mine_manager_manor_no_person_back")
	state_machine.remove("mine_manager_manor_no_person_into")
end

function MineManagerNoPerson:createCell()
	local cell = MineManagerNoPerson:new()
	cell:registerOnNodeEvent(cell)
	return cell
end