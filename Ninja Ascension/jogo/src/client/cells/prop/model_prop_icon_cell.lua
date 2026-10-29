----------------------------------------------------------------------------------------------------
-- 说明：用于基本模型方式绘制 icon 道具 的小图标绘制
-- 依靠传入的配置实现对象返回.不再依赖类型if的方式.
-- 有任何需要扩展的,直接扩展配置表即可,无需改动已有的实现.
-- 避免相互之间依赖耦合代码.
--
-- to: 李彪
-- app.load("client.cells.prop.model_prop_icon_cell")
-------------------------------------------------------------------------------------------------------
ModelPropIconCell = class("ModelPropIconCellClass", Window)

function ModelPropIconCell:ctor()
    self.super:ctor()
	
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	-- 请注意,这里设置的,表示该操作是在任何应用环境均可使用的.
	-- 这里的定义的操作响应,都是通用的操作响应.
	-- 按实现功能配置,与场景无关脱离依赖耦合
	self.enum_touchShowType = { 
		_SHOW_INFO = 1,	-- 显示点击后弹出道具信息的弹窗 
		--_SHOW_INFO_(XXXX) = 2,	-- 此处可以填写显示道具信息时,切换什么之类的.
		--_SHOW_INFO_(XXXX) = 3,	-- 此处可以填写点击后就跳转到哪个场景页面
		
	}
	
end


function ModelPropIconCell:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end


function ModelPropIconCell:getPropsImg(picIndex, isBigImg)
	if true == isBigImg then  -- face\prop_head
		return getPropsPath(picIndex)
	end
	return string.format("images/ui/props/props_%d.png", picIndex)
end

function ModelPropIconCell:drawPropCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local isRecommend = self.config.isRecommend
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isDebris = false 
	local isShowBorder = self.config.isShowBorder
	
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	
	picIndex	= dms.int(dms["prop_mould"], mouldId, prop_mould.pic_index)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		picIndex = setThePropsIcon(mouldId)[1]
	end
	quality		= dms.int(dms["prop_mould"], mouldId, prop_mould.prop_quality)+1
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			name = setThePropsIcon(mouldId)[2]
		end
	end
	
	--> print("这里开始查碎片")
	--检查是否为碎片
	local prop_type = getIsPropDebris(mouldId)
	--	dms.int(dms["prop_mould"], mouldId, prop_mould.prop_type)
	if prop_type == true and true == self.config.isDebris then
		isDebris = true
	else
		isDebris = false
	end
	
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto 
		then
		if self.panel_prop ~= nil then
			local sell_tag = dms.int(dms["prop_mould"], mouldId, prop_mould.sell_tag)
			if sell_tag == 3 then
				local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
				if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
					local armature = ccs.Armature:create("effect_quality_box_1")
					draw.initArmature(armature, nil, -1, 0, 1)
					armature:setPosition(cc.p(self.panel_prop:getContentSize().width/2, self.panel_prop:getContentSize().height/2))
					self.panel_prop:addChild(armature)
				end
			end
		end
	end
end
--银币(钢铝)
function ModelPropIconCell:drawMoneyCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= tonumber(_reward_image_name[1])
	quality		= 1
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end

	
	if true == isShowName then
		name 	= _All_tip_string_info._fundName
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end
--金币(钻石)
function ModelPropIconCell:drawGemCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= _reward_image_name[2]
	quality		= 7
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end

	
	if true == isShowName then
		name 	= _All_tip_string_info._crystalName
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end
--声望(威望)
function ModelPropIconCell:drawReputationCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= _reward_image_name[3]
	quality		= 4
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= _All_tip_string_info._reputation
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end
--将魂(舰魂)
function ModelPropIconCell:drawSteelSoulCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= tonumber(_reward_image_name[4])
	quality		= 5
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= _All_tip_string_info._hero
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end
--魂玉(水雷魂)
function ModelPropIconCell:drawSoulJadeCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= _reward_image_name[5]
	quality		= 4
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= _All_tip_string_info._soulName
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end

--决斗荣誉(荣誉)
function ModelPropIconCell:drawHonourCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		if count == 0 then
			return
		end
	end
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= _reward_image_name[6]
	quality		= 4
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= _All_tip_string_info._glories
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end

-- 燃料
function ModelPropIconCell:drawEnergyCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= _reward_image_name[7]
	quality		= 5
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= _All_tip_string_info._energyName
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end

-- 弹药
function ModelPropIconCell:drawFuelCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local mouldType = tonumber(self.config.mouldType)
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	local isBigImg = self.config.isBigImg
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	picIndex	= _reward_image_name[8]
	quality		= 5
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= _All_tip_string_info._fuelName
	end
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end

function ModelPropIconCell:drawEquipCell()
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local isRecommend = self.config.isRecommend
	local isBigImg = self.config.isBigImg
	local isDebris = false 
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	
	picIndex	= dms.int(dms["equipment_mould"], mouldId, equipment_mould.pic_index)
	quality		= dms.int(dms["equipment_mould"], mouldId, equipment_mould.grow_level)+1
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		name 	= dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
	end
	
	-- --> print("这里开始查碎片")
	-- --检查是否为碎片
	-- local prop_type = getIsPropDebris(mouldId)
	-- --	dms.int(dms["prop_mould"], mouldId, prop_mould.prop_type)
	-- if prop_type == true and true == self.config.isDebris then
		-- isDebris = true
	-- else
		-- isDebris = false
	-- end
	
	-- 显示装备那么就没有碎片这一说,直接false
	
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end


function ModelPropIconCell:drawShipCell()
	-- images/ui/quality		
	local mouldId = self.config.mouldId
	local count = self.config.count
	local isShowName = self.config.isShowName
	local isRecommend = self.config.isRecommend
	local isBigImg = self.config.isBigImg
	local isDebris = false 
	local isCertainly = self.config.isCertainly
	local isShowBorder = self.config.isShowBorder
	
	local picIndex	= nil
	local quality	= nil
	local name 		= nil
	local imagePath = nil
	
	picIndex	= dms.int(dms["ship_mould"], mouldId, ship_mould.head_icon)
	quality		= dms.int(dms["ship_mould"], mouldId, ship_mould.ship_type)+1
	
	
	if nil ~= picIndex then
		imagePath = self:getPropsImg(picIndex, isBigImg)
	end
	
	if true == isShowName then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
		else
			name = dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
		end
	end
	
	-- 显示武将那么就没有碎片这一说,直接false
	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend,isBigImg, isCertainly, isShowBorder)
end

--ship_mould

-------------------------------------------------------
-- 类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气 18 威名 19 日常任务积分 20功勋 21战功) 
-------------------------------------------------------
function ModelPropIconCell:analysisConfig()
	--计算出要显示的内容,格式化为标准数据显示
	local mouldId = self.config.mouldId
	local mouldType = tonumber(self.config.mouldType)
	
	if nil == mouldType or mouldType == 6 then -- 默认是道具
	
		self:drawPropCell()
	elseif mouldType == 1 then
	
		self:drawMoneyCell()
		
	elseif mouldType == 2 then
	
		self:drawGemCell()
	elseif mouldType == 3 then	
	
		self:drawReputationCell()
		
	elseif mouldType == 4 then
		self:drawSteelSoulCell()
		
	elseif mouldType == 5 then
		self:drawSoulJadeCell()
		
	elseif mouldType == 7 then
		self:drawEquipCell()
	
		-- 8:经验 9:耐力
		-- 12:体力
		-- 16:比武积分
		-- 19 日常任务积分 20功勋 21战功
		
	elseif mouldType == 8 then
		
	elseif mouldType == 9 then
		self:drawFuelCell()
	elseif mouldType == 12 then	
	
	elseif mouldType == 16 then	
		
	elseif mouldType == 19 then	
	
	elseif mouldType == 20 then	
	
	elseif mouldType == 21 then	
	
	elseif mouldType == 13 then
		self:drawShipCell()
	elseif mouldType == 18 then
		self:drawHonourCell()
		
	end
	
end

-- 这里是直接调用的"静态"方法
function ModelPropIconCell.getGoodInfo(mouldId, mouldType)
	local name = ""
	local quality = 1
	
	mouldId = tonumber(mouldId)
	mouldType = tonumber(mouldType)
	
	
	if nil == mouldType or mouldType == 6 then -- 默认是道具
		name = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			name = setThePropsIcon(mouldId)[2]
		end
		quality = dms.int(dms["prop_mould"], mouldId, prop_mould.prop_quality)+1
		
	elseif mouldType == 1 then
		name = _All_tip_string_info._fundName
		quality = 1
		
	elseif mouldType == 2 then
		name = _All_tip_string_info._crystalName
		quality = 7
		
	elseif mouldType == 3 then	
	
		name = _All_tip_string_info._reputation
		quality = 4
		
	elseif mouldType == 4 then
		
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then 
			--数码魂
			name = _All_tip_string_info._hero
		else	
			name = _All_tip_string_info._soulName
		end
		quality = 5
		
	elseif mouldType == 5 then
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			then 
			--兽魂
			name = _All_tip_string_info._soulName
		else
			name = _All_tip_string_info._hero
		end
		quality = 4
		
	elseif mouldType == 7 then
		name 	= dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
		quality		= dms.int(dms["equipment_mould"], mouldId, equipment_mould.grow_level)+1
	
	elseif mouldType == 9 then
		name 	= _All_tip_string_info._fuelName
		quality		= 5
	
	elseif mouldType == 13 then
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
		else
			name = dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
		end
		quality	= dms.int(dms["ship_mould"], mouldId, ship_mould.ship_type)+1
		
	elseif mouldType == 18 then
		name 	= _All_tip_string_info._glories
		quality		= 5
	end


	return {
		name = name,
		quality = quality,
	}

end

function ModelPropIconCell:analysisArguments()
	local imagePath = self.darwArgumentsConfig.imagePath
	local quality = self.darwArgumentsConfig.quality
	local name = self.darwArgumentsConfig.name
	local count = self.darwArgumentsConfig.count
	local isDebris = self.darwArgumentsConfig.isDebris
	local isRecommend = self.darwArgumentsConfig.isRecommend
	local isBigImg = self.darwArgumentsConfig.isBigImg
	local isCertainly = self.darwArgumentsConfig.isCertainly
	local isShowBorder = self.darwArgumentsConfig.isShowBorder

	self:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg, isCertainly, isShowBorder)
end

function ModelPropIconCell:drawIcon(imagePath, quality, name, count, isDebris, isRecommend, isBigImg,isCertainly, isShowBorder)
	-- if nil ~= picIndex then
		-- self.panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	-- end

	if nil ~= imagePath then
		self.panel_prop:setBackGroundImage(imagePath)
	end
	
	if true == isShowBorder then
		
		if nil ~= quality then
			
			if true == isBigImg then
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					self.panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
				else
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						self.panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
					else
						self.panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
					end
				end
				-- self.panel_ditu:setBackGroundImage("images/ui/quality/icon_enemy_0.png")
			else
				self.panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
				self.panel_ditu:setBackGroundImage("images/ui/quality/icon_enemy_0.png")
			end

		end
	
	end
	-- if nil ~= count then
		-- local str = ""
		-- if type(count) == "string" then
			-- str = count
		-- elseif type(count) == "number" then
			-- if count > 10000 then
				-- local k = math.floor(count/10000)
				-- str = k .. string_equiprety_name[38]
			-- else
				-- str = count
			-- end
		-- end

		-- self.item_order_level:setVisible(true)
		-- self.item_order_level:setString("x"..str)
	-- else
		-- self.panel_num:setVisible(false)
		-- self.item_order_level:setVisible(false)
	-- end
	
	self:updateIconCount(count)
	
	if nil ~= name then
		self.item_name:setVisible(true)
		self.item_name:setString(name)
		self.item_name:setColor(self:getColor(quality))
	else
		self.item_name:setVisible(false)
	end
	
	if nil ~= self.patch then
		if true == isDebris then
			-- isDebris 是否显示碎片字样
			self.patch:setVisible(true)
		else
			self.patch:setVisible(false)
		end
	end
	
	if nil ~= self.recommend then
		if true == isRecommend then
			-- isRecommend 是否显示推荐字样
			self.recommend:setVisible(true)
		else
			self.recommend:setVisible(false)
		end
	end
	
	if nil ~= self.certainly then
		if true == isCertainly then
			self.certainly:setVisible(true)
		else
			self.certainly:setVisible(false)
		end
	end
	
	
end

function ModelPropIconCell:updateIconCount(count)
	if nil ~= count then
		local str = ""
		if type(count) == "string" then
			str = count
		elseif type(count) == "number" then
			if count > 10000 then
				local k = math.floor(count/1000)
				str = k .. string_equiprety_name[40]
			else
				str = count
			end
		end

		self.item_order_level:setVisible(true)
		self.item_order_level:setString("x"..str)
	else
		self.panel_num:setVisible(false)
		self.item_order_level:setVisible(false)
	end
end


-- 武将信息展示
function ModelPropIconCell:showShipInfo()
	app.load("client.packs.hero.HeroPatchInformation")
	local cell = HeroPatchInformation:new()
	cell:init(tostring(self.config.mouldId),nil,nil,2)
	fwin:open(cell, fwin._windows)
end

-- 装备信息展示
function ModelPropIconCell:showEquipInfo()
	local grab_rank_link = dms.int(dms["equipment_mould"], self.config.mouldId, equipment_mould.grab_rank_link)
	app.load("client.packs.equipment.EquipFragmentInfomation")
	local page = EquipFragmentInfomation:new()
	if grab_rank_link == -1 then
		page:init(self.config.mouldId,nil,2)
	else
		page:init(self.config.mouldId, 2 ,3)
	end
	fwin:open(page, fwin._windows)
end

-- 宝物信息展示
function ModelPropIconCell:showTreasure()
	app.load("client.packs.equipment.EquipFragmentInfomation")
	local page = EquipFragmentInfomation:createCell()
	page:init(self.config.mouldId, 2 ,3)
	fwin:open(page, fwin._windows)
end

-- 虚拟物品信息展示 金钱钻石类
function ModelPropIconCell:showInvisibleInfo()
	app.load("client.cells.prop.prop_money_info")
	local mouldType = tonumber(self.config.mouldType)
	local cell = propMoneyInfo:new()
	cell:init(tostring(mouldType))
	fwin:open(cell, fwin._windows)
end


function ModelPropIconCell:showPropInfo()
	-- props_type 道具类型
	-- 0 普通
	-- 1 武将碎片
	-- 2 宝箱和钥匙
	-- 3 随机宝箱（爆竹库）
	-- 4 包裹类（多种）
	-- 5 好感礼物
	-- 6 VIP等级
	-- 7 选择型包裹（爆竹库）
	-- 8 宠物碎片
	-- 9 宠物饲料
	-- 10 免战牌
	-- 11 征讨令
	
	--storage_page_index 仓库索引页
	-- 0道具
	-- 1宝物
	-- 2装备
	-- 3装备碎片
	-- 4武将
	-- 5武将碎片
	-- 6抢夺
	-- 7时装
	-- 8鬼道
	-- 9副队长
	-- 10副队碎片
	
	-- 基于上面两种判定类型,决定点击后响应信息
	local view = nil
	local mouldId = self.config.mouldId
	local props_type = dms.int(dms["prop_mould"], mouldId, prop_mould.props_type)
	local storage_page_index = dms.int(dms["prop_mould"], mouldId, prop_mould.storage_page_index)
	
	if storage_page_index == 5 then
		-- 1 是武将碎片
		app.load("client.packs.hero.HeroPatchInformation")
		view = HeroPatchInformation:new()
		-- 此处是道具id,转战船id过去
		local shipID = dms.string(dms["prop_mould"], mouldId, prop_mould.use_of_ship)
		view:init(tostring(shipID),1,nil,2)
		
	elseif 	storage_page_index == 3 then
		-- 此装备碎片
		app.load("client.packs.equipment.EquipFragmentInfomation")
		
		local eID = dms.string(dms["prop_mould"], mouldId, prop_mould.change_of_equipment)
		view = EquipFragmentInfomation:createCell()
		view:init(tostring(mouldId))

	elseif storage_page_index == 0 then
		-- 0 是 普通道具
		app.load("client.cells.prop.prop_information")
		view = propInformation:new()
		local data = view:constructionPropTemplate(mouldId)
		view:init(data,1)
		
	elseif storage_page_index == 6 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or
		 (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		  then 
			local change_of_equipment_mouldID = dms.string(dms["prop_mould"], mouldId, prop_mould.change_of_equipment)
			app.load("client.packs.equipment.EquipFragmentInfomation")
			local page = EquipFragmentInfomation:createCell()
			page:init(change_of_equipment_mouldID, 2 ,3)
			fwin:open(page, fwin._windows)
		end
	elseif storage_page_index == 15 then 
		--宠物碎片
		-- 1 是武将碎片
		app.load("client.packs.hero.HeroPatchInformation")
		view = HeroPatchInformation:new()
		local shipID = dms.int(dms["prop_mould"], mouldId, prop_mould.use_of_ship)
		view:init(shipID,2,nil,2)
	end
	
	if nil ~= view then
		fwin:open(view, fwin._windows)
	end

end

function ModelPropIconCell:showInfo()
	local mouldType = tonumber(self.config.mouldType)
	if nil == mouldType or mouldType == 6 then
		self:showPropInfo()
		
	elseif mouldType == 1 then
		self:showInvisibleInfo()

	elseif mouldType == 2 then
		self:showInvisibleInfo()
		
	elseif mouldType == 3 then	
		self:showInvisibleInfo()
		
	elseif mouldType == 4 then
		self:showInvisibleInfo()
		
	elseif mouldType == 5 then
		self:showInvisibleInfo()
		
	elseif mouldType == 7 then
		-- 装备里也可以存在宝物
		self:showEquipInfo()
	elseif mouldType == 13 then
		self:showShipInfo()
		
	elseif mouldType == 18 then
		self:showInvisibleInfo()
		
	end
end

function ModelPropIconCell:onIconCellTouchEvent()
	-- 不允许在这里直接填写结构体,请自行创建响应函数,做调用!
	if self.config.touchShowType  == self.enum_touchShowType._SHOW_INFO then
		self:showInfo()
	--elseif then
	 
	-- 不允许 出现 else 结尾 !!
	end
	
	
end

function ModelPropIconCell:registerTouchEvent(trigger, touchEvent)

	local function trigger_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				if nil ~= touchEvent then
					touchEvent(self.instance, self)
				end
				
				self:onIconCellTouchEvent()
			end
		end
	end
	trigger:addTouchEventListener(trigger_onTouchEvent)
end

function ModelPropIconCell:setBigImgLayout()
	-- local csbItem = csb.createNode("icon/item_big.csb")
	-- local root = csbItem:getChildByName("root")
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")

	else
		local csbItem = csb.createNode("icon/item_big.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	Image_2:setSwallowTouches(false)
	
	self.panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang") -- 边框
	self.panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")-- 底图
	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop") -- 实际放置层
	self.panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框--显示装备等级才使用
	self.item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	self.item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	self.item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	self.patch = ccui.Helper:seekWidgetByName(root, "Image_4")--碎片字样
	self.recommend = ccui.Helper:seekWidgetByName(root, "Image_tuijian")--推荐字样
	self.certainly = ccui.Helper:seekWidgetByName(root, "Image_bidiao")--必掉字样

	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
end

function ModelPropIconCell:setSmallImgLayout()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	Image_2:setSwallowTouches(false)
	
	self.panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang") -- 边框
	self.panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")-- 底图
	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop") -- 实际放置层
	self.panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框--显示装备等级才使用
	self.item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	self.item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	self.item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	self.patch = ccui.Helper:seekWidgetByName(root, "Image_26")--碎片字样
	self.recommend = ccui.Helper:seekWidgetByName(root, "Image_4")--推荐字样
	self.certainly = ccui.Helper:seekWidgetByName(root, "Image_bidiao")--必掉字样

	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
end

function ModelPropIconCell:onEnterTransitionFinish()
	if nil ~= self.config then
		if true == self.config.isBigImg then
			self:setBigImgLayout()
		else
			self:setSmallImgLayout()
		end
	elseif nil ~= self.darwArgumentsConfig then
		if true == self.darwArgumentsConfig.isBigImg then
			self:setBigImgLayout()
		else
			self:setSmallImgLayout()
		end
	else
		-- 关键参数缺失--------
		return
	end
	for i=1,5 do
		local Image = ccui.Helper:seekWidgetByName(self.roots[1], "Image_o_"..i)
		if Image ~= nil then
			Image:setVisible(false)
		end
		Image = ccui.Helper:seekWidgetByName(self.roots[1], "Image_o_up_"..i)
		if Image ~= nil then
			Image:setVisible(false)
		end
	end

	if nil ~= self.patch then
		self.patch:setVisible(false)
	end
	
	if nil ~= self.panel_num then
		self.panel_num:setVisible(false)
	end
	
	if nil ~= self.item_name then
		self.item_name:setVisible(false)
	end
	
	if nil ~= self.item_shuxin then
		self.item_shuxin:setVisible(false)
	end
	
	if nil ~= self.item_lv then
		self.item_lv:setVisible(false)
	end
	
	if nil ~= self.item_order_level then
		self.item_order_level:setVisible(false)
	end
	
	if nil ~= self.recommend then
		self.recommend:setVisible(false)
	end
		
	if nil ~= self.certainly then
		self.certainly:setVisible(false)
	end

	
	if nil ~= self.config then --检查配置文件
	
		-- 解析配置
		self:analysisConfig()
		
		-- 注册事件
		self:registerTouchEvent(self.panel_prop, self.onTouchEvent)
		-- self.panel_prop:setSwallowTouches(false)
		-- self.panel_prop:setTouchEnabled(false)
	
	elseif nil ~= self.darwArgumentsConfig  then -- 检查绘制参数
	
		self:analysisArguments()
	end
end


function ModelPropIconCell:setCellSwallowTouches(isSwallow)
	self.panel_prop:setSwallowTouches(isSwallow)
end

function ModelPropIconCell:setCellTouchEnabled(isTouch)
	self.panel_prop:setTouchEnabled(isTouch)
end

function ModelPropIconCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root._x ~= nil then
	    	root:setPositionX(root._x)
	    end
	    if root._y ~= nil then
	    	root:setPositionY(root._y)
	    end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function ModelPropIconCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

--------------------------------------------------------------------------------------------------------------------------
-- 创建方式
-- 1. 通过配置文件中的模板类型和id,推导出绘制参数  	--init(config,..)
-- 2. 直接指定绘制具体参数(没有模板没有id)   		--initDarwArguments(darwArguments)
--------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------
-- 配置方式创建

--在此配置参数控制模板------- 请使用第2种方式构建参数,第一种只是为了兼容简单调用.
-- 1. 可以 用传参来创建 (如:createConfig(参数1,参数2...) )
-- 2. 也可以 直接 获取空数据模板 (如  data = createConfig() 得到一个基本数据,只填写你需要的.)

-- 能用模板id取到的数据,就不要加在配置表里,只有涉及控制的参数才扩展进来.
-- 默认值的都应该是nil 或者 false.不应当出现其他的默认值,避免扩展中出现新旧冲突.
function ModelPropIconCell:createConfig(mouldId, 		--1
										count, 			--2
										isShowName, 	--3
										touchShowType, 	--4
										mouldType, 		--5
										isDebris,		--6
										isRecommend,	--7
										isBigImg,		--8
										isCertainly,	--9
										isShowBorder,	--10
										...
										)
	local data = {
		-- mouldId = nil, -- 默认这里是取 道具 模板 的数据,(如果是非道具的像金钱类填-1,并填写 mouldType为指定类型)
		-- count = nil,
		-- isShowName = false,
		-- touchShowType = nil, -- 表示被点击后显示什么界面
		-- mouldType = nil, -- 这个主要是用在金钱这些无模板id的对象上(如果填写,将以此来决定 模板id 归属于哪个类型的模板,如武将/装备等---前提是请确认上面代码是否已实现该类型处理)
		-- isDebris = false, -- 是否显示碎片字样--当道具判定为碎片时,会根据此参数决定是否显示碎片字样
		-- isRecommend = false, -- 是否显示推荐字样
		-- isBigImg = false, -- 是否显示长方形大图(默认图片使用方形的小icon)
		-- isCertainly = false, -- 是否显示必掉字样
		-- isShowBorder = true,	-- 默认边框是显示的
	}
	data.mouldId = mouldId or nil
	data.count = count or nil
	data.isShowName = isShowName or false
	data.touchShowType = touchShowType or nil
	data.mouldType = mouldType or nil 
	data.isDebris = isDebris or false
	data.isRecommend = isRecommend or false
	data.isBigImg = isBigImg or false
	data.isCertainly = isCertainly or false
	data.isShowBorder = isShowBorder or true
	return data
end


-- 可以通过 填参的方式传值创建,
function ModelPropIconCell:getConfig()
	if nil == self.config then
		self.config = self:createConfig()
	end
	return self.config
end


-- 用法1: 在配置中传入要显示的点击后的显示页面类型
-- 用法2: 在init中加入自己希望响应的回调函数,自己决定点击后做什么
-- 这两种用法可同时存在.
function ModelPropIconCell:init(config, onTouchEvent, instance)
	self.config = config
	self.onTouchEvent = onTouchEvent
	self.instance = instance
end
--onTouchEvent 的接受参数为 : (iconCell)

-- 如果要在创建后动态更改config,最好先get一次,修改参数再update进来(不要自行构建一个Object)
-- 以后需求多了,这里可以做一个配置差异比对,差异化处理更新.
function ModelPropIconCell:updateConfig(config)
	self.config = config
	self:analysisConfig()
end

function ModelPropIconCell:createCell()
	local cell = ModelPropIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

--------------------------------------------------------------------------------------------------------------------------
-- 参数方式创建


--如果没有任何模板相关的数据,只有图片id,那么就用下面的直接配置绘制参数
--这样是不通过模板id和类型去推导出显示图片,需要直接指定所需要绘制的参数
--

function ModelPropIconCell:createDarwArgumentsConfig()
	local data = {
		imagePath = nil, --全地址,非id
		quality = nil,
		name = nil,
		count = nil,
		isDebris = nil,
		isRecommend = nil,
		isBigImg = nil,
		isCertainly = nil,
		isShowBorder = true,
	}
	return data
end
-- 这里是 直接设置 绘制参数,不通过模板等信息取推导出绘制源
function ModelPropIconCell:initDarwArgumentsConfig(darwArgumentsConfig)
	self.darwArgumentsConfig = darwArgumentsConfig
end

