----------------------------------------------------------------------------------------------------
-- 说明：获得物品,单件的模板
-- to:李彪
-------------------------------------------------------------------------------------------------------
-- app.load("client.reward.AcquireRewad")
AcquireRewad = class("AcquireRewadClass", Window)

function AcquireRewad:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	app.load("client.cells.prop.model_prop_icon_cell")
	
	self.enum_type = {
		_PROP_MOULD = 1,	
	}
	local function init_acquire_rewad_terminal()
		local acquire_rewad_close_terminal = {
            _name = "acquire_rewad_close",
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
		
		state_machine.add(acquire_rewad_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_acquire_rewad_terminal()
end

function AcquireRewad:onUpdateDraw()
	
	local cell = self.config.cell
	local name = self.config.name
	local quality = self.config.quality
	
	if cell then
		self.iconPanel:addChild(cell)
	end
	
	if name then
		self.nameText:setString(name)
	end
	
	if quality then
		self.nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	end
end

function AcquireRewad:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/snatch_prompt.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	--exit
	local action = csb.createTimeline("campaign/Snatch/snatch_prompt.csb")
	root:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then
			fwin:close(self)
		elseif  str == "exit" then
			fwin:close(self)
		end
	
	end)
	
	-- 图片框
	self.iconPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_huode_2_6")
	-- 文字
	self.nameText = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_2_0")

	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2_11"), nil, 
	{
		terminal_name = "acquire_rewad_close", 
		cell = self,
	
	},
	nil, 1)	
end

function AcquireRewad:onExit()
	state_machine.remove("acquire_rewad_close")
end

----------------------------------------------------------------
-- 道具类创建

function AcquireRewad:getPropConfig(count, mtype)	
	app.load("client.cells.prop.model_prop_icon_cell")
	count = count or 1
	local cell = ModelPropIconCell:createCell()
	
	local cellConfig = cell:createConfig()
	
	cellConfig.mouldId = self.mouldId
	cellConfig.count = count
	cellConfig.isShowName = true
	cellConfig.mouldType = mtype
	cellConfig.isDebris = true
	
	cell:init(cellConfig)

	local name = dms.string(dms["prop_mould"], self.mouldId, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        name = setThePropsIcon(self.mouldId)[2]
    end
	local quality = dms.int(dms["prop_mould"], self.mouldId, prop_mould.prop_quality)+1
	
	local config = self:createConfig(cell, name, quality)
	return config
end

----------------------------------------------------------------
-- 装备类创建

function AcquireRewad:getEquipmentConfig(count)	
	app.load("client.cells.equip.equip_icon_cell")
	local cell = EquipIconCell:createCell()
	cell:init(8, nil, self.mouldId, nil)
	
	local name = dms.string(dms["equipment_mould"], self.mouldId, equipment_mould.equipment_name)
	local quality = dms.int(dms["equipment_mould"], self.mouldId, equipment_mould.grow_level)+1
	
	local config = self:createConfig(cell, name, quality)
	return config
end
----------------------------------------------------------------
-- 武将类创建

function AcquireRewad:getHeroConfig(count)	
	app.load("client.cells.ship.ship_head_cell")
	count = count or 1
	local cell = ShipHeadCell:createCell()

	cell:init(nil,12,self.mouldId,1)
	local name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self.mouldId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(self.ship.evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.mouldId, ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        hero_name = word_info[3]
    else 
		name = dms.string(dms["ship_mould"], self.mouldId, ship_mould.captain_name)
	end

	local quality = dms.int(dms["ship_mould"], self.mouldId, ship_mould.ship_type)+1

	local config = self:createConfig(cell, name, quality)
	return config
end

----------------------------------------------------------------
-- 杂货类创建

---------------------------------------------------
-- 初始化数据的方式只有两种
-- init 是只接受标准参数的,它只关心要显示的元素,不知道显示的具体是什么
-- initXXXXX 则是,指定显示哪种类型的对象,它会自动初始化配置,然后调用init实现


function AcquireRewad:createConfig(cell, name, quality)
	local data = {
		-- cell = nil,		-- 一个cell对象,可以addChild的对象
		-- name = nil,		-- 显示获得的物品名字
		-- quality = false,-- 显示物品名字的品质颜色
	}
	data.cell = cell or nil	
	data.name = name or nil	
	data.quality = quality or nil
	
	return data
end

-- init只接受标准参数
function AcquireRewad:init(config)
	self.config = config
end

--如果要显示 银币
function AcquireRewad:initSilver(count)
	self.mouldId = -1
	local config = self:getPropConfig(count, 1)
	self:init(config)
end

--如果要显示 道具
function AcquireRewad:initProp(mouldId, count)
	self.mouldId = mouldId
	local config = self:getPropConfig(count)
	self:init(config)
end

--如果要显示 英雄
function AcquireRewad:initHero(mouldId, count)
--> print("奖励 武将-111---------------------",mouldId )
	self.mouldId = mouldId
	local config = self:getHeroConfig(count)
	self:init(config)
end

--如果要显示 装备
function AcquireRewad:initEquipment(mouldId, count)
	self.mouldId = mouldId
	local config = self:getEquipmentConfig(count)
	self:init(config)
end

--如果不知道要显示什么,就将171的奖励数据扔进来
-- 格式:
-- 171 -->不需要
-- 4 -->不需要
-- 1 -->不需要
-- 133 13 1  -->这一段数据传进来
-- 如这样: rewardList = getSceneReward(2)
-- 类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气)	
function AcquireRewad:initRewad171(rewardList)
	self.mouldId = mouldId
	
	local list = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17} -- 这里是 类型表
	local fun = { -- 这里是响应函数表
	} 
	
	fun[1] = function(reward) --1:银币
		self:initSilver(reward.item_value)
		
		end
	fun[2] = function(reward) --2:金币
			
		
		end
	fun[3] = function(reward) --3:声望
			
		
		end
	fun[4] = function(reward) --4:将魂
			
		
		end
	fun[5] = function(reward) --5:魂玉
			
		
		end
	fun[6] = function(reward) --6:道具
		self:initProp(reward.prop_item, reward.item_value)
		end
	fun[7] = function(reward) --7:装备
		self:initEquipment(reward.prop_item, reward.item_value)	
		
		end
	fun[8] = function(reward) --8:经验
			
		
		end
	fun[9] = function(reward) --9:耐力
			
		
		end
	fun[10] = function(reward) --10:功能点
			
		
		end
	fun[11] = function(reward) --11:上阵人数
			
		
		end
	fun[12] = function(reward) --12:体力
			
		
		end
	fun[13] = function(reward) --13:武将
		self:initHero(reward.prop_item, reward.item_value)	
		
		end
	fun[14] = function(reward) --14竞技场排名
			
		
		end
	fun[15] = function(reward) --15:伤害 
			
		
		end
	fun[16] = function(reward) --16:比武积分
			
		
		end
	fun[17] = function(reward) --17:霸气
			
		
		end


	local function forReward()
		for i, v in ipairs(list) do
			local _reward = getRewardItemWithType(rewardList, v)
			if nil ~= _reward then
				return fun[i](_reward) -- 直接调设置好的响应函数
			end
		end
		return nil
	end
	
	forReward()
end