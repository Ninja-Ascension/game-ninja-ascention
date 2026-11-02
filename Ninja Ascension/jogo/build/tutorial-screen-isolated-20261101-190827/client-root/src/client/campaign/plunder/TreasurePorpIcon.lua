----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
TreasurePorpIcon = class("TreasurePorpIconClass", Window)

function TreasurePorpIcon:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.propMould = nil		-- 当前要绘制的道具mould
	self.isPlunder = 0			-- 点击是否进入抢夺  0就进入
	self.prop = nil
	app.load("client.cells.prop.model_prop_icon_cell")
	app.load("client.campaign.plunder.PlunderList")
	app.load("client.packs.equipment.EquipFragmentInfomation")
	local function init_treasure_porp_icon_terminal()
	-- 夺宝信息初始化
		local treasure_porp_icon_show_terminal = {
            _name = "treasure_porp_icon_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				if terminal._state == 0 then
					
					--> print("来了吗??treasure_porp_icon_show------------------------------")
					
					-----------记录当前场景缓存数据
					app.load("client.utils.scene.SceneCacheData")
					local cacheName = SceneCacheNameEnum.PLUNDER
					local cacheData = SceneCacheData.read(cacheName)
					if nil == cacheData then
						cacheData = SceneCacheData.getInitExample(cacheName)
					end
			
					cacheData.propMouldId = cell.propMould
					SceneCacheData.write(cacheName, cacheData, "treasure_porp_icon_show")

					local page = PlunderList:new()
					page:init(cell.propMould)
					fwin:open(page, fwin._view)
				else
					local equipId = dms.int(dms["prop_mould"],params._datas._id,prop_mould.change_of_equipment)
					local page = EquipFragmentInfomation:createCell()
					page:init(equipId,nil,3,params._datas._id)
					fwin:open(page, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(treasure_porp_icon_show_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_porp_icon_terminal()
end

function TreasurePorpIcon:onUpdateDraw()
	local Panel_3 	= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")			-- 底图

	local Text_1 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_1")				-- 数量
	
	local Sprite_1 =  Panel_3:getChildByName("Sprite_1")
	Sprite_1:removeAllChildren(true)
	picIndex = tonumber(dms.string(dms["prop_mould"], self.propMould, prop_mould.pic_index))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		picIndex = setThePropsIcon(self.propMould)[1]
	end

	local iconCell = ModelPropIconCell:createCell()
	local config = iconCell:createConfig(tonumber(self.propMould), nil, false)
	iconCell:init(config)
	
	Sprite_1:addChild(iconCell)

	local num = 0
	self.isPlunder = 0
	for i,prop in pairs(_ED.user_prop) do
		if tonumber(prop.user_prop_template) == tonumber(self.propMould) then
			num = tonumber(prop.prop_number)
			self.isPlunder = num
			self.prop = prop
		end
	end
	Text_1:setString(num)
	
	if num == 0 then
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
			__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then

		else
			--这行好像有内存泄露,加了这个会涨内存
			app.load("frameworks.support.filters.gray")
			gray.setGray(Sprite_1)
		end
		Sprite_1:setColor(cc.c3b(50, 50, 50))
		iconCell.roots[1]:setColor(cc.c3b(50, 50, 50))
	else
		iconCell.roots[1]:setColor(cc.c3b(255, 255, 255))
	end
end

function TreasurePorpIcon:onEnterTransitionFinish()
	self.roots = {}
	local csbItem = csb.createNode("campaign/Snatch/snatch_bwsp.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	local Panel_1 = nil
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
		--防止报错
		if Panel_1 == nil then 
			Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_suipian_1")
			if Panel_1 == nil then 
				return
			else
				Panel_1:setTouchEnabled(true)
			end
		else
			Panel_1:setTouchEnabled(true)	
		end
	else	
		Panel_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_1")
	end
	
	Panel_1:setSwallowTouches(true)
	
	fwin:addTouchEventListener(Panel_1, nil, 
	{
		terminal_name = "treasure_porp_icon_show", 
		terminal_state = self.isPlunder,
		_id = self.propMould,
		cell = self,
	},
	nil, 0)	
	
	
	if missionIsOver() == false then
		if tonumber(self.propMould) == tonumber(_plunder_patch_mould) then
			Panel_1:setName("Panel_1_mx")
		end
	end	
	
end

function TreasurePorpIcon:onExit()
	--state_machine.remove("treasure_porp_icon_show")
end

function TreasurePorpIcon:init(propMould)
	--> print("碎片道具id-init--------------------",propMould)
	self.propMould = propMould
end

function TreasurePorpIcon:createCell()
	local cell = TreasurePorpIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

