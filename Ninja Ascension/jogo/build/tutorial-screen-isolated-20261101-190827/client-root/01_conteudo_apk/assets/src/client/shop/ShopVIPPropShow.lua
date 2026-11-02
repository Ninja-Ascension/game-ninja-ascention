-- ----------------------------------------------------------------------------------------------------
-- 说明：商城Vip礼包预览
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopVIPPropShow = class("ShopVIPPropShowClass", Window)

function ShopVIPPropShow:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.cell = {}
	self.prop = nil
	self.shop_type = nil
	self.enum_type = {
		_SHOW_RES_INFORMATION = 2, 			-- 查看物品信息
	}
	app.load("client.shop.ShopVIPPropShowCell")
	local function init_Shop_vip_prop_terminal()
		local init_Shop_vip_prop_show_back_terminal = {
			_name = "init_Shop_vip_prop_show_back",
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
		state_machine.add(init_Shop_vip_prop_show_back_terminal)

        state_machine.init()
	end
	init_Shop_vip_prop_terminal()
end

function ShopVIPPropShow:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
	local num = 1
	local equipId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_equipment)
	local equipName = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        equipName = setThePropsIcon(self.prop.mould_id)[2]
    end
	local changeNum = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_equipment_count)
	if equipId ~= nil and equipId ~= 0 then 
		self.cell[num] = {equipId,"equip",changeNum}
		num = num + 1
	end
	
	equipId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_equipment2)
	changeNum = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_equipment2_count)
	if  equipId ~= nil and equipId ~= 0 then 
		self.cell[num] = {equipId,"equip",changeNum}
		num = num + 1
	end
	
	equipId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_equipment3)
	changeNum = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_equipment3_count)
	if  equipId ~= nil and equipId ~= 0 then 
		self.cell[num] = {equipId,"equip",changeNum}
		num = num + 1
	end
	
	local shipId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_ship)
	if shipId ~= nil and shipId ~= 0 then 
		self.cell[num] = {shipId,"ship",1}
		num = num + 1
	end
	local propId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.change_of_prop)
	local number_one = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.split_or_merge_count)
	
	if propId ~= nil and propId ~= 0 then 
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			self.cell[num] = {propId,"prop",number_one}
		else
			self.cell[num] = {propId,"prop",1}
		end
		
		num = num + 1
	end
	
	propId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_prop)
	changeNum = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_prop_count)
	if propId ~= nil and propId ~= 0 then 
		self.cell[num] = {propId,"prop",changeNum}
		num = num + 1
	end
	
	propId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_prop2)
	changeNum = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_prop2_count)
	if propId ~= nil and propId ~= 0 then 
		self.cell[num] = {propId,"prop",changeNum}
		num = num + 1
	end
	
	propId = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_prop3)
	changeNum = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_prop3_count)
	if  propId ~= nil and propId ~= 0 then 
		self.cell[num] = {propId,"prop",changeNum}
		num = num + 1
	end
	
	local goldCount = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_gold)
	
	if goldCount > 0 then--可领取宝石数量
		self.cell[num] = {goldCount,"goldCount"}
		num = num + 1
	end
	--可为战士们提供强化经验。--将魂说明
	local reputeCount = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_repute)
	if reputeCount > 0 then--可领取声望数量
		self.cell[num] = {reputeCount,"reputeCount"}
		num = num + 1
	end
	
	local sliverCount = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.use_of_silver)
	if sliverCount > 0 then--可领取银币数量
		self.cell[num] = {sliverCount,"sliverCount"}
		num = num + 1
	end
	
	for i=1 ,table.getn(self.cell) do
		local cell = ShopVIPPropShowCell:createCell()
		cell:init(self.cell[i])
		listView:addChild(cell)
	end
	
end

function ShopVIPPropShow:onEnterTransitionFinish()
	local csbShopVIPPropShow = csb.createNode("shop/package_preview.csb")
	local root = csbShopVIPPropShow:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShopVIPPropShow)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"), nil, 
	{
		terminal_name = "init_Shop_vip_prop_show_back",
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self:onUpdateDraw()
end

function ShopVIPPropShow:onExit()
	state_machine.remove("init_Shop_vip_prop_show_back")
end

function ShopVIPPropShow:init(prop,_type)
	self.prop = prop
	if _type~= nil then
		if _type == self.enum_type._SHOW_RES_INFORMATION then
			self.prop.mould_id = self.prop.user_prop_template
		end
	end
end

