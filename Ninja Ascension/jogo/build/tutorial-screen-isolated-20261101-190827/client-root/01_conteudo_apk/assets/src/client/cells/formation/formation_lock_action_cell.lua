----------------------------------------------------------------------------------------------------
-- 说明：阵容界面中，武将上阵位未开启的绘制
-------------------------------------------------------------------------------------------------------
FormationLockActionCell = class("FormationLockActionCellClass", Window)

function FormationLockActionCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.data = {}		-- 根据阵型位开启的条件
	self.current_type = 0
	self.enum_type = {
		_FORMATION_EQUIPMENT = 1,	-- 阵容界面缘分添加的锁
		_FORMATION_SHIP = 2,		-- 阵容界面武将上阵的锁
	}
end

function FormationLockActionCell:onUpdateDraw()
	local root = self.roots[1]
	self.size = root:getContentSize()
	self:setContentSize(self.size)
	if self.current_type == self.enum_type._FORMATION_SHIP then
		ccui.Helper:seekWidgetByName(root, "Panel_yuanfen_suo"):setVisible(false)
		local openinfo = dms.searchs(dms["user_experience_param"], user_experience_param.battle_unit, tonumber(_ED.user_info.user_fight)+1)
		ccui.Helper:seekWidgetByName(root, "Text_4"):setString(dms.atos(openinfo[1], user_experience_param.level))
	elseif self.current_type == self.enum_type._FORMATION_EQUIPMENT then 
		local configParam =dms.string(dms["pirates_config"], 142, pirates_config.param)
		local paramInfo = zstring.split(configParam,",")
		ccui.Helper:seekWidgetByName(root, "Text_5"):setString(paramInfo[self.data])
		ccui.Helper:seekWidgetByName(root, "Panel_zrlb_suo_icon"):setVisible(false)
	end
	root:setSwallowTouches(false)
end

function FormationLockActionCell:onEnterTransitionFinish()

end

function FormationLockActionCell:onInit()
	local filePath = "icon/role_box_close.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function FormationLockActionCell:onExit()
end

function FormationLockActionCell:init(_type,data)
	self.current_type = _type
	self.data = data

	self:onInit()
end

function FormationLockActionCell:createCell()
	local cell = FormationLockActionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

