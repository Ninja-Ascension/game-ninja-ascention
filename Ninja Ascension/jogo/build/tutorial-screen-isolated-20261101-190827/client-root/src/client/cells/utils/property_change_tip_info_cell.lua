----------------------------------------------------------------------------------------------------
-- 说明：属性变更提示信息的绘制
-------------------------------------------------------------------------------------------------------
PropertyChangeTipInfoAnimationCell = class("PropertyChangeTipInfoAnimationCellClass", Window)

function PropertyChangeTipInfoAnimationCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}			-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.action = nil		-- 动画缓存
	self.text = {}			-- 文本集
	self.textData = {}		-- 传入文本信息

	self.endPosition = nil	-- 文字消失位子(绝对位子)
	self.endTime = 1		-- 文字消失时间
	self.types = nil
	self.colorQueue = {}
	self.panel = nil
	
	self.changeState = 0
	self.enum_type = {
		_FORMATION_CHANGE_HERO = 1,	-- 在阵容界面更换武将改变属性
		_CHANGE_HERO_STRENGTHEN_GRADE = 2,	-- 在武将等级变更成功 -- 同觉醒一样
		_CHANGE_HERO_STRENGTHEN_EXPERIENCE = 3,	-- 在武将经验增加,但没升级
		_CHANGE_TREASYRE_REFINE = 4,	-- 宝物精炼界面
		_EQUIP_STRENGHT_THEN = 5,		-- 装备强化界面
		_HERO_TIANMING = 6,				-- 武将天命界面
		_DESTINY_STAR = 7,				-- 三国志的点亮星星界面
		_CHANGE_TREASYRE_STRENGHT = 8,	-- 宝物强化界面
		_HERO_RECRUIT_OF_CAMP = 9 ,  ---阵容招募界面
		_LEARING_SKILL = 10 , -- 技能好感度提升
		_FORMATION_CHANGE_HOME_HERO = 11 ,--主页面的上阵提示
		_EQUIP_STAR_MULTIPLE = 12 ,-- 升星暴击
		_EQUIP_STAR_RESULT = 13 ,-- 升星结果
		_LIMIT_RECHARGE_SUCCEED = 14 , --限时优惠购买陈工
	}
	
	self.end_type = {
		_UP_AND_DOWN = 1,	-- 1.向上下分离隐藏 
		_DOWN_ALL = 2,	-- 2.向下隐藏
		_UP_ALL = 3,	-- 3.向上隐藏
		_UP_TO_TOP = 4, -- 4.向上到顶
		
	}
end

function PropertyChangeTipInfoAnimationCell:onUpdateDraw()
	-- 按顺序获取控件
	if self.types == self.enum_type._FORMATION_CHANGE_HERO then 
		local findex = 1
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local add = self.textData[i].add
				local nameOne = self.textData[i].nameOne
				local nameTwo = self.textData[i].nameTwo
				if nameOne ~= nil and nameTwo ~= nil then
					-- self.text[findex]:setColor(self.colorQueue[5])
					-- self.text[findex]:setString("["..nameOne.."]")
					-- findex = findex +1
					-- self.text[findex]:setColor(self.colorQueue[2])
					-- self.text[findex]:setString("的缘分")
					-- findex = findex +1
					-- self.text[findex]:setColor(self.colorQueue[5])
					-- self.text[findex]:setString("["..nameTwo.."]")
					-- findex = findex +1
					-- self.text[findex]:setColor(self.colorQueue[5])
					-- self.text[findex]:setString("激活")
					-- findex = findex +1
					
					local _richText = ccui.RichText:create()
					_richText:ignoreContentAdaptWithSize(true)
					-- _richText:setContentSize(cc.size(500, 10))
					local re1 = ccui.RichElementText:create(1, self.colorQueue[5], 255, "["..nameOne.."]", self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re1)
					local re2 = ccui.RichElementText:create(1, self.colorQueue[2], 255, _string_piece_info[333], self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re2)
					local re3 = ccui.RichElementText:create(1, self.colorQueue[5], 255, "["..nameTwo.."]", self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re3)
					local re4 = ccui.RichElementText:create(1, self.colorQueue[2], 255, _string_piece_info[334], self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re4)
					self.text[findex]:addChild(_richText)
					
					_richText:setAnchorPoint(CCPoint(0.5, 0.5))
					_richText:setPosition(cc.p(0, 0))
					findex = findex +1
				else
					local txt = property..value
					local prefix = ""
					if tonumber(value) > 0  then
						-- prefix = _string_piece_info[153]
						if add ~= nil then
							self.text[findex]:setColor(self.colorQueue[5])
							self.text[findex]:setString(property .. value .. add)
						else
							self.text[findex]:setColor(self.colorQueue[4])
							self.text[findex]:setString(property .. "+" .. value)
						end
						
						findex = findex +1
					elseif tonumber(value) < 0  then
						self.text[findex]:setColor(self.colorQueue[3])
						self.text[findex]:setString(txt)
						
						findex = findex +1
					elseif  tonumber(value) == 0  then
						-- 值为0时不显示
						--self.text[findex]:setColor(self.colorQueue[2])
					end
				end
				
			else
				self.text[i]:setString("")
			end
		end
		
		self.titleText:setColor(self.colorQueue[1])
		self.titleText:setString(self.titleString)
	
	elseif self.types == self.enum_type._CHANGE_HERO_STRENGTHEN_GRADE then
		local findex = 2
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local txt = property..value
				local prefix = ""
				if tonumber(value) > 0  then
					prefix = _string_piece_info[153]
					self.text[findex]:setColor(self.colorQueue[4])
					self.text[findex]:setString(prefix..txt)
					
					findex = findex +1
				elseif tonumber(value) < 0  then
					self.text[findex]:setColor(self.colorQueue[3])
					self.text[findex]:setString(prefix..txt)
					
					findex = findex +1
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
		
		-- 提升Panel_up_22坐标,textData里的第一个必须是标题
		self.text[1]:setString(self.titleString)
		self.text[1]:setColor(self.colorQueue[1])
		
		local panel_up_22 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_22")
		local _x,_y = panel_up_22:getPosition()
		panel_up_22:setPositionY(_y+28)
		
	elseif self.types == self.enum_type._CHANGE_HERO_STRENGTHEN_EXPERIENCE then
	
		local expValue = self.textData[1].value
		
		self.text[1]:setString(self.titleString)
		self.text[1]:setColor(self.colorQueue[1])
		
		self.text[2]:setString(expValue)
		self.text[2]:setColor(self.colorQueue[2])
		
		local titleTextX,titleTextY = self.text[1]:getPosition()
		local titleTextSize = self.text[1]:getContentSize()
		local valueTextSize = self.text[2]:getContentSize()
		
		self.text[1]:setPositionX(titleTextX - valueTextSize.width*0.5)
		titleTextX = self.text[1]:getPositionX()
		self.text[2]:setPosition(cc.p(titleTextX + titleTextSize.width*0.5 + valueTextSize.width*0.5,titleTextY))
	elseif self.types == self.enum_type._CHANGE_TREASYRE_REFINE then
		local findex = 1
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local add = self.textData[i].add
				local txt = property..value
				local prefix = ""
				if tonumber(value) > 0  then
					if add ~= nil then
						self.text[findex]:setColor(self.colorQueue[5])
						self.text[findex]:setString(property .. value .. add)
					else
					
						self.text[findex]:setColor(self.colorQueue[4])
						self.text[findex]:setString(txt .. "%")
					end
					
					findex = findex +1
				elseif tonumber(value) < 0  then
					self.text[findex]:setColor(self.colorQueue[3])
					self.text[findex]:setString(txt .. "%")
					
					findex = findex +1
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
		
		self.titleText:setColor(self.colorQueue[1])
		self.titleText:setString(self.titleString)
	elseif self.types == self.enum_type._EQUIP_STRENGHT_THEN then
		local findex = 2
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local add = self.textData[i].add
				local txt = ""
				if i == 1 then
					txt = property
				else
					txt = property..value
				end
				local prefix = ""
				if tonumber(value) > 0  then
					if add ~= nil then
						self.text[findex]:setColor(self.colorQueue[5])
						self.text[findex]:setString(property .. value .. add)
					else
						self.text[findex]:setColor(self.colorQueue[4])
						self.text[findex]:setString(txt)
					end
					
					findex = findex +1
				elseif tonumber(value) < 0  then
					self.text[findex]:setColor(self.colorQueue[3])
					self.text[findex]:setString(txt)
					
					findex = findex +1
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
		
		self.titleText:setColor(self.colorQueue[1])
		self.titleText:setString(self.titleString)
		local panel_up_22 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_22")
		local _x,_y = panel_up_22:getPosition()
		panel_up_22:setPositionY(_y+28)
	elseif self.types == self.enum_type._HERO_TIANMING then
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local add = self.textData[i].add
				local txt = property.."+"..value
				if tonumber(value) > 0  then
					if add ~= nil then
						self.text[1]:setColor(self.colorQueue[3])
						self.text[1]:setString(property .. value .. add)
					else
						self.text[1]:setColor(self.colorQueue[2])
						self.text[1]:setString(txt)
					end
				elseif tonumber(value) < 0  then
					self.text[1]:setColor(self.colorQueue[2])
					self.text[1]:setString(txt)
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
	elseif self.types == self.enum_type._DESTINY_STAR then
		local findex = 2
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local txt = property.."+"..value
				local prefix = ""
				if tonumber(value) > 0  then
					prefix = ""
					self.text[findex]:setColor(self.colorQueue[4])
					self.text[findex]:setString(prefix..txt)
					
					findex = findex +1
				elseif tonumber(value) < 0  then
					self.text[findex]:setColor(self.colorQueue[3])
					self.text[findex]:setString(prefix..txt)
					
					findex = findex +1
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
		
		-- 提升Panel_up_22坐标,textData里的第一个必须是标题
		self.text[1]:setString(self.titleString)
		self.text[1]:setColor(self.colorQueue[1])
		
		local panel_up_22 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_22")
		local _x,_y = panel_up_22:getPosition()
		panel_up_22:setPositionY(_y+28)
	elseif self.types == self.enum_type._CHANGE_TREASYRE_STRENGHT then
		local findex = 1
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				-- local txt = property..value
				-- local prefix = ""
				-- if tonumber(value) > 0  then
					-- prefix = ""
					-- self.text[findex]:setColor(self.colorQueue[4])
					-- self.text[findex]:setString(prefix..txt)
					
					-- findex = findex +1
				-- elseif tonumber(value) < 0  then
					-- self.text[findex]:setColor(self.colorQueue[3])
					-- self.text[findex]:setString(prefix..txt)
					
					-- findex = findex +1
				-- elseif  tonumber(value) == 0  then
				-- end
				local _richText = ccui.RichText:create()
				_richText:ignoreContentAdaptWithSize(true)
				-- _richText:setContentSize(cc.size(500, 10))
				local re1 = ccui.RichElementText:create(1, self.colorQueue[2], 255, property, self.text[findex]:getFontName(), self.text[findex]:getFontSize())
				_richText:pushBackElement(re1)
				local re2 = ccui.RichElementText:create(2, self.colorQueue[4], 255, ""..value, self.text[findex]:getFontName(), self.text[findex]:getFontSize())
				_richText:pushBackElement(re2)
			
				self.text[findex]:addChild(_richText)
				
				_richText:setAnchorPoint(CCPoint(0.5, 0.5))
				_richText:setPosition(cc.p(0, 0))
				findex = findex +1
			else
				self.text[i]:setString("")
			end
		end
	elseif self.types == self.enum_type._HERO_RECRUIT_OF_CAMP then	
		local findex = 1
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local add = self.textData[i].add
				local nameOne = self.textData[i].nameOne
				local nameTwo = self.textData[i].nameTwo
				local colortype = self.textData[i].colortype
				if nameOne ~= nil and nameTwo ~= nil then
					
					
					local _richText = ccui.RichText:create()
					_richText:ignoreContentAdaptWithSize(true)
					-- _richText:setContentSize(cc.size(500, 10))

					local color = cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3])
					local re1 = ccui.RichElementText:create(1, self.colorQueue[2], 255, nameOne, self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re1)
					
					local re2 = ccui.RichElementText:create(1, color, 255, nameTwo, self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re2)
					
					self.text[findex]:addChild(_richText)
					
					_richText:setAnchorPoint(CCPoint(0.5, 0.5))
					_richText:setPosition(cc.p(0, 0))
					findex = findex +1
				else
					local txt = property..value
					local prefix = ""
					if tonumber(value) > 0  then
						-- prefix = _string_piece_info[153]
						if add ~= nil then
							self.text[findex]:setColor(self.colorQueue[5])
							self.text[findex]:setString(property .. value .. add)
						else
							self.text[findex]:setColor(self.colorQueue[4])
							self.text[findex]:setString(property .. "+" .. value)
						end
						
						findex = findex +1
					elseif tonumber(value) < 0  then
						self.text[findex]:setColor(self.colorQueue[3])
						self.text[findex]:setString(txt)
						
						findex = findex +1
					elseif  tonumber(value) == 0  then
						-- 值为0时不显示
						--self.text[findex]:setColor(self.colorQueue[2])
					end
				end
				
			else
				self.text[i]:setString("")
			end
		end
		
		self.titleText:setColor(self.colorQueue[1])
		self.titleText:setString(self.titleString)
	elseif self.types == self.enum_type._LEARING_SKILL then	
		local findex = 1
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local nameOne = self.textData[i].nameOne
				local nameTwo = self.textData[i].nameTwo
				if nameOne ~= nil and nameTwo ~= nil then
					
					
					local _richText = ccui.RichText:create()
					_richText:ignoreContentAdaptWithSize(true)
					-- _richText:setContentSize(cc.size(500, 10))

					local color = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
					local re1 = ccui.RichElementText:create(1, self.colorQueue[2], 255, nameOne, self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re1)
					
					local re2 = ccui.RichElementText:create(1, color, 255, nameTwo, self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re2)
					
					self.text[findex]:addChild(_richText)
					
					_richText:setAnchorPoint(CCPoint(0.5, 0.5))
					_richText:setPosition(cc.p(0, 0))
					findex = findex +1
				end
				
			else
				self.text[i]:setString("")
			end
		end
		
		self.titleText:setColor(self.colorQueue[1])
		self.titleText:setString(self.titleString)
	elseif self.types == self.enum_type._FORMATION_CHANGE_HOME_HERO then 
		local findex = 1
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local add = self.textData[i].add
				local nameOne = self.textData[i].nameOne
				local nameTwo = self.textData[i].nameTwo
				if nameOne ~= nil and nameTwo ~= nil then
				
					local _richText = ccui.RichText:create()
					_richText:ignoreContentAdaptWithSize(true)
					-- _richText:setContentSize(cc.size(500, 10))
					local re1 = ccui.RichElementText:create(1, self.colorQueue[5], 255, "["..nameOne.."]", self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re1)
					local re2 = ccui.RichElementText:create(1, self.colorQueue[2], 255, _string_piece_info[333], self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re2)
					local re3 = ccui.RichElementText:create(1, self.colorQueue[5], 255, "["..nameTwo.."]", self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re3)
					local re4 = ccui.RichElementText:create(1, self.colorQueue[2], 255, _string_piece_info[334], self.text[findex]:getFontName(), self.text[findex]:getFontSize())
					_richText:pushBackElement(re4)
					self.text[findex]:addChild(_richText)
					
					_richText:setAnchorPoint(CCPoint(0.5, 0.5))
					_richText:setPosition(cc.p(0, 0))
					findex = findex +1
				else
					local txt = property..value
					local prefix = ""
					if tonumber(value) > 0  then
						-- prefix = _string_piece_info[153]
						if add ~= nil then
							self.text[findex]:setColor(self.colorQueue[5])
							self.text[findex]:setString(property .. value .. add)
						else
							self.text[findex]:setColor(self.colorQueue[4])
							self.text[findex]:setString(property .. "+" .. value)
						end
						
						findex = findex +1
					elseif tonumber(value) < 0  then
						self.text[findex]:setColor(self.colorQueue[3])
						self.text[findex]:setString(txt)
						
						findex = findex +1
					elseif  tonumber(value) == 0  then
						-- 值为0时不显示
						--self.text[findex]:setColor(self.colorQueue[2])
					end
				end
				
			else
				self.text[i]:setString("")
			end
		end
		
		self.titleText:setColor(self.colorQueue[1])
		self.titleText:setString(self.titleString)
	elseif self.types == self.enum_type._EQUIP_STAR_MULTIPLE then
		local findex = 2
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local txt = property..value
				local prefix = ""
				if tonumber(value) > 0  then
					prefix = _string_piece_info[153]
					self.text[findex]:setColor(self.colorQueue[4])
					self.text[findex]:setString(property.. prefix ..value)
					
					findex = findex +1
				elseif tonumber(value) < 0  then
					self.text[findex]:setColor(self.colorQueue[3])
					self.text[findex]:setString(property.. prefix ..value)
					
					findex = findex +1
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
		
		-- 提升Panel_up_22坐标,textData里的第一个必须是标题
		self.text[1]:setString(self.titleString)
		self.text[1]:setColor(self.colorQueue[1])
		
		local panel_up_22 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_22")
		local _x,_y = panel_up_22:getPosition()
		panel_up_22:setPositionY(_y+28)
	elseif self.types == self.enum_type._EQUIP_STAR_RESULT then
		local findex = 2
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local txt = property..value
				local prefix = ""
				if tonumber(value) > 0  then
					prefix = _string_piece_info[153]
					self.text[findex]:setColor(self.colorQueue[4])
					self.text[findex]:setString(property.. prefix ..value)
					
					findex = findex +1
				elseif tonumber(value) < 0  then
					self.text[findex]:setColor(self.colorQueue[3])
					self.text[findex]:setString(property.. prefix ..value)
					
					findex = findex +1
				elseif  tonumber(value) == 0  then
					-- 值为0时不显示
					--self.text[findex]:setColor(self.colorQueue[2])
				end
			else
				self.text[i]:setString("")
			end
		end
		
		-- 提升Panel_up_22坐标,textData里的第一个必须是标题
		self.text[1]:setString(self.titleString)
		self.text[1]:setColor(self.colorQueue[1])
		
		local panel_up_22 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_22")
		local _x,_y = panel_up_22:getPosition()
		panel_up_22:setPositionY(_y+28)
	elseif self.types == self.enum_type._LIMIT_RECHARGE_SUCCEED then 
		local findex = 2
		for i = 1,#self.textData do
			if self.textData[i] ~= nil then
				local property = self.textData[i].property
				local value = self.textData[i].value
				local txt = property..value
				local prefix = ""
				if value ~= "" and tonumber(value) > 0  then
					prefix = _string_piece_info[153]
					self.text[findex]:setColor(self.colorQueue[1])
					self.text[findex]:setString(property.. prefix ..value)
					findex = findex +1
				elseif value == "" then 
					self.text[findex]:setColor(self.colorQueue[2])
					self.text[findex]:setString(property)
					findex = findex + 1
				end
			else
				self.text[i]:setString("")
			end
		end
		-- 提升Panel_up_22坐标,textData里的第一个必须是标题
		local panel_up_22 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_22")
		local _x,_y = panel_up_22:getPosition()
		panel_up_22:setPositionY(_y+28)
	end
end


function PropertyChangeTipInfoAnimationCell:getTextColor(i)
	return cc.c3b(
					tipStringInfo_property_change_color_Type[i][1], 
					tipStringInfo_property_change_color_Type[i][2], 
					tipStringInfo_property_change_color_Type[i][3]
				)
end
 
function PropertyChangeTipInfoAnimationCell:onUpdateConfig()
	
	local endPanelName = nil
	local endType = nil

	if self.types == self.enum_type._FORMATION_CHANGE_HERO then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
			self:getTextColor(7),--金色
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._UP_AND_DOWN
		
	elseif self.types == self.enum_type._CHANGE_HERO_STRENGTHEN_GRADE then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._DOWN_ALL
		
	elseif self.types == self.enum_type._CHANGE_HERO_STRENGTHEN_EXPERIENCE then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(5),--文本颜色
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._UP_ALL
		
	elseif self.types == self.enum_type._CHANGE_TREASYRE_REFINE then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
			self:getTextColor(7),--金色
		}
		endPanelName = "Panel_bwjl_7"
		endType = self.end_type._UP_AND_DOWN
	elseif self.types == self.enum_type._EQUIP_STRENGHT_THEN then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
			self:getTextColor(7),--金色
		}
		endPanelName = "Panel_bwjl_7"
		endType = self.end_type._DOWN_ALL
		
	elseif self.types == self.enum_type._HERO_TIANMING then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(2),--文本颜色
			self:getTextColor(7),--金色
		}
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._UP_ALL
	elseif self.types == self.enum_type._DESTINY_STAR then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
		}	
		
		endPanelName = "Panel_destiny_7788"
		endType = self.end_type._UP_TO_TOP
	elseif self.types == self.enum_type._CHANGE_TREASYRE_STRENGHT then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
		}	
		
		endPanelName = "Panel_destiny_7788"
		endType = self.end_type._UP_TO_TOP
	elseif self.types == self.enum_type._HERO_RECRUIT_OF_CAMP then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
			self:getTextColor(7),--金色
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._UP_ALL
	elseif self.types == self.enum_type._LEARING_SKILL then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
			self:getTextColor(7),--金色
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._UP_ALL
	elseif self.types == self.enum_type._FORMATION_CHANGE_HOME_HERO then
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
			self:getTextColor(7),--金色
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._UP_ALL
	elseif self.types == self.enum_type._EQUIP_STAR_MULTIPLE then
		self.colorQueue = {
			self:getTextColor(6),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._DOWN_ALL
	elseif self.types == self.enum_type._EQUIP_STAR_RESULT then 
		self.colorQueue = {
			self:getTextColor(1),--title颜色
			self:getTextColor(1),--0值颜色 ==0
			self:getTextColor(5),--负值颜色 <0
			self:getTextColor(2),--正值颜色 >0
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._DOWN_ALL
	elseif self.types == self.enum_type._LIMIT_RECHARGE_SUCCEED then 
		self.colorQueue = {
			self:getTextColor(2),
			self:getTextColor(1),
		}
		
		endPanelName = "Panel_line_8"
		
		endType = self.end_type._DOWN_ALL
	end
	
	local endposX = 0
	local endposY = 0
	
	if nil ~= endPanelName then
		endposX,endposY = ccui.Helper:seekWidgetByName(self.roots[1], endPanelName):getPosition()
	end
	self.endPosition = cc.p(endposX,endposY)
	
	if nil ~= endType then
		self.endType = endType
	end
end

function PropertyChangeTipInfoAnimationCell:onFrameEventEnd()
	
	local isPlayEffect = true
	
	if self.types == self.enum_type._FORMATION_CHANGE_HERO then
		if self.notShow == false then
		else
			state_machine.excute("formation_property_change_tip_info",0,self.textData)
		end
		
	elseif self.types == self.enum_type._CHANGE_HERO_STRENGTHEN_GRADE then
		state_machine.excute("hero_strengthen_grade_change_animation",0,self.textData)
	
	elseif self.types == self.enum_type._CHANGE_HERO_STRENGTHEN_EXPERIENCE then
		-- 没有后续处理
	elseif self.types == self.enum_type._CHANGE_TREASYRE_REFINE then
		state_machine.excute("treasure_refine_update",0,"")
		
		isPlayEffect = false
		pushEffect(formatMusicFile("effect", 9992))
	elseif self.types == self.enum_type._EQUIP_STRENGHT_THEN then
		state_machine.excute("equip_strengthen_update", 0, self.textData)
		state_machine.excute("equip_strengthen_btn_restore", 0, "")
	elseif self.types == self.enum_type._DESTINY_STAR then
		state_machine.excute("destiny_system_lighten_star", 0, "destiny_system_lighten_star.")
	elseif self.types == self.enum_type._CHANGE_TREASYRE_STRENGHT then
	
	elseif self.types == self.enum_type._HERO_TIANMING then
	
		isPlayEffect = false
	elseif self.types == self.enum_type._HERO_RECRUIT_OF_CAMP then
		
	elseif self.types == self.enum_type._FORMATION_CHANGE_HOME_HERO then
		state_machine.excute("formation_property_change_tip_info",0,self.textData)
	end
	
	
	-- 根据当前值的 + - 播放不同音效
	if true == isPlayEffect then
		if self.changeState == -1 then -- 存在红色项 --
			playEffectForAbilityDown()
		elseif self.changeState == 1 then -- 全是绿色项 ++
			playEffectForAbilityUp()
		end
	end
	
	fwin:close(self)
end

function PropertyChangeTipInfoAnimationCell:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		return
	end
	local csbItem = csb.createNode("utils/text_up_ing.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	self.action = csb.createTimeline("utils/text_up_ing.csb")
	self.action:setTimeSpeed(app.getTimeSpeed())
	self.action:play("Panel_up_22_in", false)
	self.roots[1]:runAction(self.action)

	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		self.text = {
			ccui.Helper:seekWidgetByName(root, "Text_ing_15"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_16"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_17"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_18"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_19"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_20"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_21"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_22"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_23"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_24"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_25"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_26"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_27"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_28"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_29"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_30"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_31"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_32"),
		}
	else
		self.text = {
			ccui.Helper:seekWidgetByName(root, "Text_ing_15"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_16"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_17"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_18"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_19"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_20"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_21"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_22"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_23"),
			ccui.Helper:seekWidgetByName(root, "Text_ing_24"),
		}
	end
	
	self:onUpdateConfig()
	
	self.titleText = ccui.Helper:seekWidgetByName(root, "Text_ing_25")
	
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		local str = frame:getEvent()
		if str == "over6" then
			if self.end_type._UP_AND_DOWN == self.endType then
				self.action:play("Panel_up_22_out_1", false)
				local function executeHeroMoveByBackOverFunc()
					self:onFrameEventEnd()
				end
				local action = cc.Sequence:create(
					cc.MoveTo:create(self.endTime, self.endPosition),
					cc.CallFunc:create(executeHeroMoveByBackOverFunc)
				)
				ccui.Helper:seekWidgetByName(root, "Panel_up_22"):runAction(action)
				
			elseif self.end_type._UP_ALL == self.endType then
				self.action:play("Panel_up_22_out_2", false)
				
			elseif self.end_type._UP_TO_TOP == self.endType then
				self.action:play("Panel_up_22_out_4", false)
				--> print("self.endPosition---", self.endPosition.x, self.endPosition.y)
				local action = cc.MoveTo:create(self.endTime, self.endPosition)
				ccui.Helper:seekWidgetByName(root, "Panel_up_22"):runAction(action)	
			elseif self.end_type._DOWN_ALL == self.endType then
				self.action:play("Panel_up_22_out_1", false)
				
				local action = cc.MoveTo:create(self.endTime, self.endPosition)
				ccui.Helper:seekWidgetByName(root, "Panel_up_22"):runAction(action)
			end
		elseif str == "over2" then
			self:onFrameEventEnd()
        elseif str == "over4" then
			self:onFrameEventEnd()
		elseif str == "over40" then
			self:onFrameEventEnd()
		end
    end)

	self:onUpdateDraw()
end

function PropertyChangeTipInfoAnimationCell:onExit()
	--state_machine.remove("property_change_tip_info_close")
end




-- 显示在哪个模块界面里
-- 文本标题
-- 数据
-- 结束动画类型
function PropertyChangeTipInfoAnimationCell:init(types, title, textData ,notShow)
	-- textData 的格式----------------------------
	-- local testdata = {
		-- {property = 1, value = 10},
		-- {property = 1, value = -10},
		-- {property = 1, value = 10},
	-- }
	-----property取得-----------------------------
	-- _property = {
		-- "生命",
		-- "攻击",
		-- "物防",
		-- "灵防",
		-- "体质",
		-- "力量",
		-- "灵力",
	-- }
	----------------------------------------------
	-- title = "武将更换换阿欢啊啊"
	if nil == endPosition then
		endPosition = cc.p(0,0)
	end
	if nil == endType then
		endType = 1
	end
	if nil == types then
		types = 1
	end
	if nil == endTime then
		endTime = 0.5
	end
	if nil ~= title then
		self.titleString = tostring(title)
	end
	if nil == textData then
		textData = {}
	end
	if notShow ~= nil then
		self.notShow = notShow
	end
	self.types = types
	self.textData = textData
	--self.endPosition = cc.p(endPosition.x - fwin._width, endPosition.y - fwin._height)
	--self.endType = endType
	if self.types  == 9 then
		self.endTime = 1
	end
	--self.panel = panel
	
	-- 计算当前数值变化 使用音效 --------------------------------
	self.changeState = 0
	local enhance = 0
	local weaken = 0
	for i = 1,#self.textData do
		if self.textData[i] ~= nil then
			local value = self.textData[i].value
			if nil ~=  value and nil ~= tonumber(value) then
				if tonumber(value) > 0  then
					enhance = enhance + 1
				elseif tonumber(value) < 0  then
					weaken = weaken + 1
				elseif  tonumber(value) == 0  then
					
				end
			end
		end
	end
	
	if weaken > 0 then
		self.changeState = -1
	elseif enhance > 0 then
		self.changeState = 1
	end
	
end

function PropertyChangeTipInfoAnimationCell:createCell()
	local cell = PropertyChangeTipInfoAnimationCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


