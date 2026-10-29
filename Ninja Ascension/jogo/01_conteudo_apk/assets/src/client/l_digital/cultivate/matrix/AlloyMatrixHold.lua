----------------------------------------------------------------------------------------------------
-- 特殊道具类的封装(金钱,砖石,荣誉等等..)
----------------------------------------------------------------------------------------------------
AlloyMatrixHold = class("AlloyMatrixHoldClass", Window)

function AlloyMatrixHold:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.types = nil		-- 当前要绘制的道具实例数据对对象
	
	-- 初始化道具小图标事件响应需要使用的状态机
	-- local function init_prop_money_info_cell_terminal()
	-- 	local prop_money_info_cell_terminal = {
 --            _name = "prop_money_info_cell",
 --            _init = function (terminal) 
            
 --            end,
 --            _inited = false,
 --            _instance = self,
 --            _state = 0,
 --            _invoke = function(terminal, instance, params) 
	-- 			fwin:close(instance)
 --                return true
 --            end,
 --            _terminal = nil,
 --            _terminals = nil
 --        }

	-- 	state_machine.add(prop_money_info_cell_terminal)
		
 --        state_machine.init()
	-- end
	-- init_prop_money_info_cell_terminal()
end

function AlloyMatrixHold:onUpdateDraw()
	local root = self.roots[1]
	local di_kuang = ccui.Helper:seekWidgetByName(root, "Panel_alloy_infor_hold_formation")
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_infor_hold_icon")
	local name = ccui.Helper:seekWidgetByName(root, "Text_alloy_infor_hold_name")
	local Text_infor_hold_lv_n = ccui.Helper:seekWidgetByName(root, "Text_infor_hold_lv_n")
	local Text_alloy_hold_atk_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_atk_t_0")
	local Text_alloy_hold_atk_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_atk_n_0")
	local Text_alloy_hold_hp_t_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_hp_t_0")
	local Text_alloy_hold_hp_n_0 = ccui.Helper:seekWidgetByName(root, "Text_alloy_hold_hp_n_0")

	local cell = ResourcesIconCell:createCell()
    cell:init(66, 0, self.info.metalMould,nil,nil,true,true,1)
    di_kuang:addChild(cell)

    --获取装备名称索引
	local nameindex = dms.int(dms["ship_metal_mould"], self.info.metalMould, ship_metal_mould.name)
	--通过索引找到word_mould
	local word_info = dms.element(dms["word_mould"], nameindex)
	local prop_name = word_info[3]
	name:setString(prop_name)
	quality = dms.int(dms["ship_metal_mould"], self.info.metalMould, ship_metal_mould.quality)
	quality = quality + 1
	name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))

	Text_infor_hold_lv_n:setString(self.info.metalLevel)

	local mould_type = dms.int(dms["ship_metal_mould"], self.info.metalMould, ship_metal_mould.add_type)
	local big_type = dms.int(dms["ship_metal_mould"], self.info.metalMould, ship_metal_mould.head)
	local quality = dms.int(dms["ship_metal_mould"], self.info.metalMould, ship_metal_mould.quality)

    local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
    local add_percent = tonumber(quality_add[quality +1][2])
	local add_attribute = ""
	for i = 1, #dms["ship_metal_param"] do
		local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
		local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
		local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)
		local add = dms.string(dms["ship_metal_param"], i, ship_metal_param.metal_add)
		if mould_type == group_id and tonumber(self.info.metalLevel) == grade and tonumber(self.info.metalRankLevel) == level then
			add_attribute = add
			break
		end
	end

	if big_type == 1 then
		if add_attribute then
			local add_infos = zstring.splits(add_attribute, "|", ",")
			Text_alloy_hold_atk_t_0:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[1][1]) + 1][1])
			Text_alloy_hold_atk_n_0:setString(tonumber(add_infos[1][2])*add_percent)

			Text_alloy_hold_hp_t_0:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[2][1]) + 1][1])
			Text_alloy_hold_hp_n_0:setString(tonumber(add_infos[2][2])*add_percent)
		end
	elseif big_type == 2 then
		if add_attribute then
			local add_infos = zstring.split(add_attribute, ",")
			if tonumber(add_infos[1]) == 33 then
                Text_alloy_hold_atk_t_0:setString(tipStringInfo_alloy_matrix_tips[5])
                Text_alloy_hold_atk_n_0:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
            elseif tonumber(add_infos[1]) == 34 then
                Text_alloy_hold_atk_t_0:setString(tipStringInfo_alloy_matrix_tips[6])
                Text_alloy_hold_atk_n_0:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
            end
            Text_alloy_hold_hp_t_0:setString("")
            Text_alloy_hold_hp_n_0:setString("")
		end
	end
	
	local Image_djxx = ccui.Helper:seekWidgetByName(root, "Image_matrix_infor_hold_attr_hp_bg")
    local Image_djxx_bg = ccui.Helper:seekWidgetByName(root, "Image_matrix_infor_hold_bg")

	local screenSize = cc.Director:getInstance():getWinSize() 
	local rootPos = fwin:convertToWorldSpace(root, cc.p(0, 0))
	if rootPos.y + Image_djxx_bg:getContentSize().height * app.scaleFactor > screenSize.height then
		root:setPositionY(root:getPositionY() - rootPos.y / app.scaleFactor - Image_djxx_bg:getContentSize().height + screenSize.height / app.scaleFactor - 10)
	end
	if rootPos.x + Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 > screenSize.width then
		root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor - Image_djxx_bg:getContentSize().width / 2 + screenSize.width / app.scaleFactor - 10 )
	end
	if rootPos.x - Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 < 0 then
		root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor + Image_djxx_bg:getContentSize().width / 2)
	end
	if nil == self.widget then
		root:setPosition(cc.p(screenSize.width / app.scaleFactor / 2, screenSize.height / app.scaleFactor / 2 - Image_djxx_bg:getContentSize().height / 2))
	end
end

function AlloyMatrixHold:onEnterTransitionFinish()
	local csbItem = csb.createNode("cultivate/alloy_matrix_infor_hold_cell.csb")
	local root = csbItem:getChildByName("root")

	self:addChild(csbItem)
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
end

function AlloyMatrixHold:onExit()

end

function AlloyMatrixHold:init(types, info, widget)
	self.types = types
	self.info = info
	self.widget = widget
	if nil ~= self.widget then
		local pos = fwin:convertToWorldSpace(widget, cc.p(0, 0))
		local anchor = widget:getAnchorPoint()
		local size = widget:getContentSize()
		pos.x = pos.x / app.scaleFactor + size.width / 2 -- (size.width * anchor.x)
		-- pos.y = pos.y + (size.height * anchor.y) + 50
		pos.y = pos.y / app.scaleFactor + size.height - 25 * app.scaleFactor
		self:setPosition(pos)
	else
		--self:setPosition(cc.p(fwin._width / 2, fwin._height / 2))
	end
end

function AlloyMatrixHold:createCell()
	local cell = AlloyMatrixHold:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

