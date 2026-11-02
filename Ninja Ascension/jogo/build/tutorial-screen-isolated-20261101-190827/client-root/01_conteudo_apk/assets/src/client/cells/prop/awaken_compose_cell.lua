----------------------------------------------------------------------------------------------------
-- 说明：合成列表单元格
-------------------------------------------------------------------------------------------------------
AwakenComposeCell = class("AwakenComposeCellClass", Window)

function AwakenComposeCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	
	self.panel_prop = nil
	self.isShowName = nil
	self.types = nil
	self.quality = 0 --品质
	self.isSelect = false -- 选中状态
	self.isNextIcon = false -- 是否显示下一个
	self.drawIndex = 0

	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_awaken_compose_cell_terminal()

		--道具头像按钮的点击
		local awaken_compose_equip_select_terminal = {
            _name = "awaken_compose_equip_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				state_machine.excute("hero_awaken_equip_compose_select_update", 0, cell.drawIndex)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(awaken_compose_equip_select_terminal)

        state_machine.init()
	end
	init_awaken_compose_cell_terminal()
end

function AwakenComposeCell:onUpdateDraw()
	local root = self.roots[1]

	self.size = root:getContentSize()
	
	self:setContentSize(self.size)	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_28_0")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_28")

	local picIndex = 0
	local quality = 0
	local item_index = nil--物品图标索引
	local item_qulityindex = nil--物品品质索引
	local item_nameIndex = nil--物品名称索引
	local item_mouldid = nil--物品模板id
	local item_count = nil --物品数量

	item_index = prop_mould.pic_index
	item_qulityindex = prop_mould.prop_quality
	
	picIndex = dms.int(dms["prop_mould"], self.prop, item_index)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		picIndex = setThePropsIcon(self.prop)[1]
	end
	quality = dms.int(dms["prop_mould"], self.prop, item_qulityindex) + 1
	ccui.Helper:seekWidgetByName(root, "Image_jiantou"):setVisible(self.isNextIcon == true)
	ccui.Helper:seekWidgetByName(root, "Image_select"):setVisible(self.isSelect == true)
	
	Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	fwin:addTouchEventListener(Panel_prop, nil, 
	{
		terminal_name = "awaken_compose_equip_select", 
		terminal_state = 0, 
		cell = self,
	}, 
	nil, 0)
end


function AwakenComposeCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/HeroStorage/generals_juexing_tubiao.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()

end

function AwakenComposeCell:onExit()
end

function AwakenComposeCell:setSelcet(isSelect)
	local root = self.roots[1]
	if root == nil then 
		return 
	end
	self.isSelect = isSelect 
	ccui.Helper:seekWidgetByName(root, "Image_select"):setVisible(isSelect)
end

function AwakenComposeCell:setNextProp(isNext)
	local root = self.roots[1]
	if root == nil then 
		return 
	end
	self.isNextIcon = isNext 
	ccui.Helper:seekWidgetByName(root, "Image_jiantou"):setVisible(isNext)
end

function AwakenComposeCell:init(propId, isSelect, isNext,drawIndex)
	self.prop = propId
	self.isSelect = isSelect
	self.isNextIcon = isNext
	self.drawIndex = drawIndex
end

function AwakenComposeCell:createCell()
	local cell = AwakenComposeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

