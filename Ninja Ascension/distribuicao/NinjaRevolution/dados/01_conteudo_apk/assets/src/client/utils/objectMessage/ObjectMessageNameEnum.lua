--------------------------------------------------------------------------------------------------------------
-- 消息名称的枚举定义
-- 调用ObjectMessage时,所使用的消息名,必须是在这里注册定义的.
-- 不允许在外部使用字符串私自定义消息名
-- 定义新的消息名时,需要考虑已有的是否合适可用
-- -------------------------------------------
-- 因为消息名较长,为了便于识别就暂时不做大写处理,用小写的
-- -------------------------------------------
-- to: 李彪
----------------------------------------------

-- 消息枚举
ObjectMessageNameEnum = {
	-- 天命 设置 顶部 icon展示栏,指定目标选中状态
	destiny_icon_cell_set_chosen_state = "destiny_icon_cell_set_chosen_state",
	-- 天命 设置 顶部 icon展示栏,更新所有icon状态
	destiny_icon_cell_update_all_state = "destiny_icon_cell_update_all_state",
	-- 天命 设置 星云图 icon展栏,指定目标选中状态
	destiny_body_icon_cell_set_chosen_state = "destiny_body_icon_cell_set_chosen_state",
	
	-- 抢夺 设置 顶部 icon展示栏,指定目标选中状态
	plunder_icon_cell_set_chosen_state = "plunder_icon_cell_set_chosen_state",
	
	-- 道具被购买
	prop_buy_change = "prop_buy_change",
	
	-- 道具被使用
	prop_use_change = "prop_use_change",
	
	-- 查看别人阵容的界面中 顶部 icon展示栏,指定目标选中状态
	player_review_infomation_icon_cell_set_chosen_state = "player_review_infomation_icon_cell_set_chosen_state",
	-- 用于时装列表的小图标,指定目标选中状态
	fashion_listview_icon_cell_set_chosen_state = "fashion_listview_icon_cell_set_chosen_state",
}

------------------------------------------------
-- 数据格式定义
-- -------------------------------------------
-- 目前定义为每个消息各自独立的数据结构.
-- 待需求稳定,可再另做单独的数据格式类复用.
------------------------------------------------

--初始化实例的管理对象(私有)
local ObjectMessageDataInit = {}

ObjectMessageData = {}

-- 发送该消息时,可用携带的数据格式
ObjectMessageData.getInitExample = function(key)
	return ObjectMessageDataInit[key]()
end 

-- 天命 设置 顶部 icon展示栏,指定目标选中状态
ObjectMessageDataInit[ObjectMessageNameEnum.destiny_icon_cell_set_chosen_state] = function()
	return{
		source = nil,  --userdata 触发源对象icon cell
		target = nil,  --userdata 目标对象icon cell
	}
end

-- 天命 设置 星云图 icon展栏,指定目标选中状态
ObjectMessageDataInit[ObjectMessageNameEnum.destiny_body_icon_cell_set_chosen_state] = function()
	return{
		source = nil,  --userdata 触发源对象icon cell
		target = nil,  --userdata 目标对象icon cell
	}
end

-- 抢夺 设置 顶部 icon展示栏,指定目标选中状态
ObjectMessageDataInit[ObjectMessageNameEnum.plunder_icon_cell_set_chosen_state] = function()
	return{
		source = nil,  --userdata 触发源对象icon cell
		target = nil,  --userdata 目标对象icon cell
	}
end

-- 道具被购买
ObjectMessageDataInit[ObjectMessageNameEnum.prop_buy_change] = function()
	return{
		mould_id = nil, --int 模板id
		count = nil,	--int 数量
	}
end

-- 道具被使用
ObjectMessageDataInit[ObjectMessageNameEnum.prop_use_change] = function()
	return{
		mould_id = nil, --int 模板id
		count = nil,	--int 数量
	}
end

-- 查看别人阵容的界面中 顶部 icon展示栏,指定目标选中状态
ObjectMessageDataInit[ObjectMessageNameEnum.player_review_infomation_icon_cell_set_chosen_state] = function()
	return{
		source = nil,  --userdata 触发源对象icon cell
		target = nil,  --userdata 目标对象icon cell
	}
end

ObjectMessageDataInit[ObjectMessageNameEnum.fashion_listview_icon_cell_set_chosen_state] = function()
	return{
		source = nil,  --userdata 触发源对象icon cell
		target = nil,  --userdata 目标对象icon cell
	}
end
