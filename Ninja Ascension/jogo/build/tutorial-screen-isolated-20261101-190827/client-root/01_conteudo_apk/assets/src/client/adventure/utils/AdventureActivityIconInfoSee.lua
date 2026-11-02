-- ----------------------------------------------------------------------------------------------------
-- 说明：活动图标信息查看
-------------------------------------------------------------------------------------------------------
AdventureActivityIconInfoSee = class("AdventureActivityIconInfoSeeClass", Window)
AdventureActivityIconInfoSee.__size = nil    
function AdventureActivityIconInfoSee:ctor()
    self.super:ctor()
    self.roots = {}
	self.current_type = 0  -- 普通情况  0  装备技能4
	self.mould_data = nil
	self.position = nil
	self.isAdd2Parent = false
	self.prop = nil
	self.parentNode = nil
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()

        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureActivityIconInfoSee:init(prop,cell,type,is2Parent)
	self.current_type = type
	self.prop = prop
	self.isAdd2Parent = is2Parent
	--self._rootWindows = cell
	--有父节点不需要计算坐标
	if self.isAdd2Parent == true then 
		self._rootWindows = cell
	else 
		--无父节点,相对应屏幕计算坐标
		self.parentNode = cell
		self._rootWindows = nil
	end
	
	return self
end

function AdventureActivityIconInfoSee:onUpdateDraw()

	-- local skillMouldData = dms.element(dms["skill_mould"], skillMouldId)
 --    local skill_describe = dms.atos(skillMouldData, skill_mould.skill_describe)
 --    Text_suming_info:setString(skill_describe)
 --    -- 显示宿命技名称
 --    local Text_sumingji = ccui.Helper:seekWidgetByName(root, "Text_sumingji")
 --    Text_sumingji:setString(dms.atos(skillMouldData, skill_mould.skill_name))
	local root = self.roots[1]

	if self.current_type == 0 then 
		-- 普通道具按照正常流程
		local mould_data = self.prop.mould_data or dms.element(dms["prop_mould"], self.prop.mould_id)
		if  mould_data == nil then 
			local  name  =  nil
			local remarks = nil
			--print(self.prop.resource_type)
			if tonumber(self.prop.resource_type) == 2 then  -- 血钻
				name = _All_tip_string_info._crystalName
				remarks = _All_tip_string_info_description._crystalNameDescription
			elseif tonumber(self.prop.resource_type) == 4  then -- 将魂
				name = _All_tip_string_info._soulName
				remarks = _All_tip_string_info_description._soulJadeNameDescription 
			elseif tonumber(self.prop.resource_type) == 1 then  --金币,
				name = _All_tip_string_info._fundName
				remarks = _All_tip_string_info_description._fundNameDescription 
			elseif tonumber(self.prop.resource_type) == 3 then  --王者之章
				name = _All_tip_string_info._glories
				remarks = _All_tip_string_info_description._gloriesDescription 
			elseif tonumber(self.prop.resource_type) == 8 then  --经验
				name = _All_tip_string_info._expName
				remarks = _All_tip_string_info_description._expNameDescription 
			elseif tonumber(self.prop.resource_type) == 25 then  --排位赛胜点
				name = _All_tip_string_info._winName
				remarks = _All_tip_string_info_description._winNameDescription 
			elseif tonumber(self.prop.resource_type) == 26 then  --排位赛积分
				name = _All_tip_string_info._integralName
				remarks = _All_tip_string_info_description._integralNameDescription 
			elseif tonumber(self.prop.resource_type) == 27 then  --排位赛奖励中心
				name = _All_tip_string_info._arena
				remarks = _All_tip_string_info_description._arenaDescription 
			end
		
			ccui.Helper:seekWidgetByName(root, "Text_props_name"):setString(name)
			ccui.Helper:seekWidgetByName(root, "Text_props_word"):setString(remarks)
		else 
			ccui.Helper:seekWidgetByName(root, "Text_props_name"):setString(dms.atos(mould_data, prop_mould.prop_name))
			ccui.Helper:seekWidgetByName(root, "Text_props_word"):setString(dms.atos(mould_data, prop_mould.remarks))
		end
	elseif self.current_type == 4 then
		-- 技能道具,特殊情况
		local mould_data = dms.element(dms["equipment_mould"], self.prop.id)
		ccui.Helper:seekWidgetByName(root, "Text_props_name"):setString(dms.atos(mould_data, equipment_mould.equipment_name))
		ccui.Helper:seekWidgetByName(root, "Text_props_word"):setString(dms.atos(mould_data, equipment_mould.trace_remarks))
	end
end

function AdventureActivityIconInfoSee:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/prop_tips.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    if AdventureActivityIconInfoSee.__size == nil then
		AdventureActivityIconInfoSee.__size = root:getContentSize()
	end
    self:addChild(csbAdventureBattleReward)
    self:setContentSize(root:getContentSize())
	self:onUpdateDraw()
	if self.isAdd2Parent == true then 
		local ps = fwin:convertToWorldSpace(self,cc.p(0,0))
		-- print(ps.x,ps.y)
		-- print(ps.x + root:getContentSize().width)
		local position = cc.p(self._rootWindows:getPositionX(),self._rootWindows:getPositionY() + self._rootWindows:getContentSize().height)
		if (ps.x + self._rootWindows:getContentSize().width + root:getContentSize().width) > fwin._width  then 
			 -- 超出屏幕后,按照改容器的宽度计算
			position.x = fwin._width - self:getContentSize().width - 15
		end
		root:setPosition(position)
		
	else
		-- 转换世界坐标系 安卓是有自适应的,所以需要计算缩放因子,游戏是按照 960*640的分辨率来做的,所以IOS 端的缩放因子是1 
		local scaleFactor = app.scaleFactor	
		local beforePos = cc.p(0,0)
		local lastPos = cc.p(0,0)
		self.position = cc.p(0,0)
		beforePos = fwin:convertToWorldSpace(self.parentNode,cc.p(0 , self.parentNode:getContentSize().height))
		
		lastPos.x = beforePos.x / scaleFactor  - fwin._x * scaleFactor
		lastPos.y = beforePos.y / scaleFactor - fwin._y * scaleFactor
		local isbigWidth = false
		self.position.x = lastPos.x
		self.position.y = lastPos.y
		if (lastPos.x + self:getContentSize().width) > fwin._width then 
			--提示超过屏幕
			self.position.x = fwin._width - self:getContentSize().width - 15 
			isbigWidth = true	
		end
		if beforePos.y + self:getContentSize().height > fwin._height - 10 then 
			-- 到顶了
			if isbigWidth == true then 
				-- 右上角,特殊处理
				self.position.x = lastPos.x - self:getContentSize().width --- self.parentNode:getContentSize().width
				self.position.y = fwin._height - 60 - self.parentNode:getContentSize().height
			end
		end
		root:setPosition(self.position)
	end
end

function AdventureActivityIconInfoSee:onExit()

end