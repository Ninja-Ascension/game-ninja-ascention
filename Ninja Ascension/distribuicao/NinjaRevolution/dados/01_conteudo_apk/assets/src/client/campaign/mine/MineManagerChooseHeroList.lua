----------------------------------------------------------------------------------------------------
-- 说明：选择武将巡逻
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerChooseHeroList = class("MineManagerChooseHeroListClass", Window)
    
function MineManagerChooseHeroList:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.heroInstance = nil
	self._id = nil
	app.load("client.cells.prop.model_prop_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
    -- Initialize MineManager page state machine.
    local function init_mine_manager_choose_hero_list_patrol_terminal()
	
		--选择
		local mine_manager_manor_choose_hero_choose_terminal = {
            _name = "mine_manager_manor_choose_hero_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- state_machine.excute("hero_reborn_show_hero_info", 0, {_datas = {cell = params._datas.cell}})
				
				-- 关闭 选择武将列表
				state_machine.excute("mine_manager_manor_choose_hero_back", 0, "mine_manager_manor_choose_hero_back.")
				-- 关闭 当前空置状态的城池
				state_machine.excute("mine_manager_manor_no_person_back", 0, "mine_manager_manor_no_person_back.")
				
				-- 打开 巡逻城池,将选择武将入场
				local cell = MineManagerAddPerson:createCell()
				cell:init(params._datas._hero,params._datas._id)
				fwin:open(cell,fwin._view)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_manor_choose_hero_choose_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_choose_hero_list_patrol_terminal()
end

function MineManagerChooseHeroList:getShipHeadCell(mouldId)
	local cell = ModelPropIconCell:createCell()
	local data = cell:createConfig()
	data.touchShowType = 1
	data.mouldId = mouldId
	data.mouldType = 13
	cell:init(data)
	return cell
end


function MineManagerChooseHeroList:onUpdateDraw()
	local root = self.roots[1]

	local hero_mould = self.heroInstance.ship_template_id
	local hero_data = dms.element(dms["ship_mould"], hero_mould)
	
	local hero_color = dms.atoi(hero_data, ship_mould.ship_type)
	local hero_type = dms.atoi(hero_data, ship_mould.capacity)
	
	local hero_level = self.heroInstance.ship_grade
	local hero_rank_level = dms.atoi(hero_data, ship_mould.initial_rank_level)
	local hero_skill_level = self.heroInstance.ship_skillstren.skill_level
	
	-- 图标
	ccui.Helper:seekWidgetByName(root, "Panel_288"):addChild(self:getShipHeadCell(hero_mould))
	
	-- 类型
	local type_name = ""
	if hero_type == 1 then
		type_name = _string_piece_info[58]
	elseif hero_type == 2 then
		type_name = _string_piece_info[59]
	elseif hero_type == 3 then
		type_name = _string_piece_info[60]
	elseif hero_type == 4 then
		type_name = _string_piece_info[61]
	else
		type_name = " "
	end

	local nameLevel = self.heroInstance.captain_name
	if hero_rank_level > 0 then
		nameLevel = nameLevel.."+"..hero_rank_level
	end
	
	-- 名称
	local name_text = ccui.Helper:seekWidgetByName(root, "Text_181")
	name_text:setString(nameLevel)
	name_text:setColor(cc.c3b(color_Type[hero_color+1][1],color_Type[hero_color+1][2],color_Type[hero_color+1][3]))
	ccui.Helper:seekWidgetByName(root, "Text_4"):setString(type_name)
	
	-- 碎片数
	ccui.Helper:seekWidgetByName(root, "Text_183"):setString("0")
	for k,v in pairs (_ED.user_prop) do
		local prop_mould_id = tonumber(v.user_prop_template)
		local storage_page_index = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.storage_page_index) 
		if storage_page_index == 5 then
			local use_of_ship = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.use_of_ship) 
			if tonumber(self.heroInstance.ship_base_template_id) == use_of_ship then
				ccui.Helper:seekWidgetByName(root, "Text_183"):setString(getPropAllCountByMouldId(prop_mould_id))
				break 
			end
		end
	end
end

function MineManagerChooseHeroList:onEnterTransitionFinish()
	local csbHeroChooseForRebornCell = csb.createNode("campaign/MineManager/attack_territory_choose_list.csb")
	local root = csbHeroChooseForRebornCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_287")
	local size = panel:getContentSize()
	self:setContentSize(size)
	
	-- 巡逻中
	local image114 = ccui.Helper:seekWidgetByName(root, "Image_114")
	
	-- 选择
	local button181 = ccui.Helper:seekWidgetByName(root, "Button_181")
	
	if true == self.isPatrol then
		-- 显示 巡逻中,  灰色按钮
		button181:setBright(false)
		button181:setTouchEnabled(false)
		
		image114:setVisible(true)
		
	else
		
		image114:setVisible(false)
		
		fwin:addTouchEventListener(button181, nil, 
		{
			terminal_name = "mine_manager_manor_choose_hero_choose", 
			_cell = self,
			_hero = self.heroInstance,
			_id = self._cityID,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	
	end
	
	self:onUpdateDraw()
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory_choose_list.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        -- local str = frame:getEvent()
        -- if str == "" then
		
        -- end
    end)
	action:play("list_view_cell_open", false)

end

function MineManagerChooseHeroList:onExit()
	state_machine.remove("mine_manager_manor_choose_hero_choose")
end


function MineManagerChooseHeroList:init(ship, id,isPatrol)
	self.heroInstance = ship
	self._cityID = id
	self.isPatrol = isPatrol
	
end

function MineManagerChooseHeroList:createCell()
	local cell = MineManagerChooseHeroList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end