--[[ ----------------------------------------------------------------------------
-- 连携cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsLeagueCell = class("MythicalAnimalsLeagueCellClass", Window)
MythicalAnimalsLeagueCell.__size = nil

-- 创建Cell实例
local mythical_animals_league_cell_create_terminal = {
	_name = "mythical_animals_league_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsLeagueCell then
			local cell = MythicalAnimalsLeagueCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_league_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsLeagueCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_league_cell_terminal()
		local mythical_animals_league_cell_activate_terminal = {
			_name = "mythical_animals_league_cell_activate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local _self = params._datas._self

					state_machine.lock("mythical_animals_league_cell_activate")

					local animalsMouldId = _self._animalsMouldId
					local index = _self._index - 1

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- 战力飘字
							smFightingChange()

							state_machine.excute("mythical_animals_league_refresh_ui", 0, nil)
							
							state_machine.excute("mythical_animals_refresh_ui", 0, nil)

							state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

							state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

							state_machine.unlock("mythical_animals_league_cell_activate")
						else
							state_machine.unlock("mythical_animals_league_cell_activate")
						end
					end
					protocol_command.magical_animals_relevant_active.param_list = "" .. animalsMouldId .. "\r\n" .. index
					NetworkManager:register(protocol_command.magical_animals_relevant_active.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_league_cell_activate_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_league_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsLeagueCell:init(params)
	self._index = params.index
	self._activateState = params.activateState
	self._leagueMouldId = params.leagueMouldId

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsLeagueCell.__size)
	return self
end

function MythicalAnimalsLeagueCell:onUpdateDraw()
	local root = self.roots[1]

	-- 激活
	self.Button_activte = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activte"), nil,
	{
		terminal_name = "mythical_animals_league_cell_activate",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self
	}, nil, 0)	

	-- 连携A
	self.Panel_animal_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_animal_icon_1")
	-- 连携B
	self.Panel_animal_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_animal_icon_2")
	-- 神兽星级激活
	self.Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")
	-- 激活按钮光效
	self.Panel_activty_animation = ccui.Helper:seekWidgetByName(root, "Panel_activty_animation")
	-- 已激活
	self.Image_activited = ccui.Helper:seekWidgetByName(root, "Image_activited")

	self.ListView_text = ccui.Helper:seekWidgetByName(root, "ListView_text")

	self:updateUI()
end


function MythicalAnimalsLeagueCell:updateUI()
	self.Button_activte:setVisible(false)
	self.Image_activited:setVisible(false)
	self.Panel_activty_animation:removeAllChildren(true)

	-- 0未激活 1可激活 2已激活
	if self._activateState == 0 then
		self.Button_activte:setVisible(true)
		self.Button_activte:setTouchEnabled(false)
		self.Button_activte:setBright(false)
	elseif self._activateState == 1 then
		self.Button_activte:setVisible(true)
		self.Button_activte:setTouchEnabled(true)
		self.Button_activte:setBright(true)

		self:playButtonAni()
	elseif self._activateState == 2 then
		self.Image_activited:setVisible(true)
	end

	local needStar = dms.int(dms["magical_animals_relevant_mould"], self._leagueMouldId, magical_animals_relevant_mould.needStar)

	self.Text_title:setString(string.format(tipStringInfo_magical_animals_word[6], needStar))

	local animalIdsStr = dms.string(dms["magical_animals_relevant_mould"], self._leagueMouldId, magical_animals_relevant_mould.animalIds)
	local animalIds = zstring.split(animalIdsStr, ",")

	-- 设置神兽Id
	self._animalsMouldId = tonumber(animalIds[1])

	self.Panel_animal_icon_1:removeAllChildren(true)
	self.Panel_animal_icon_1:removeBackGroundImage()
	if animalIds[1] ~= nil then
		local cell = DrawHandle.drawIcon({72, tonumber(animalIds[1]), 1, needStar})
		self.Panel_animal_icon_1:addChild(cell)
	end
	
	self.Panel_animal_icon_2:removeAllChildren(true)
	self.Panel_animal_icon_2:removeBackGroundImage()
	if animalIds[2] ~= nil then
		local cell = DrawHandle.drawIcon({72, tonumber(animalIds[2]), 1, needStar})
		self.Panel_animal_icon_2:addChild(cell)
	end

	-- 属性
	local propertyData = MythicalAnimalsHandle.getAnimalsLeaguePropertyByLeagueId(self._leagueMouldId)

	local result = {}
	for k, v in pairs(propertyData) do
		table.insert(result, {propertyType = k, propertyValue = v})
	end

	self.ListView_text:removeAllItems()
	for _, v in ipairs(result) do
		local cell = state_machine.excute("mythical_animals_league_property_cell_create", 0, v)
		self.ListView_text:addChild(cell)
	end
end

-- 按钮动画
function MythicalAnimalsLeagueCell:playButtonAni()
	self.Panel_activty_animation:removeAllChildren(true)

	local jsonFile = "images/ui/effice/effect_illustration2/effect_illustration2.json"
	local atlasFile = "images/ui/effice/effect_illustration2/effect_illustration2.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, "animation", true)
	animation:setPosition(self.Panel_activty_animation:getContentSize().width / 2, self.Panel_activty_animation:getContentSize().height / 2)
	self.Panel_activty_animation:addChild(animation)
end

function MythicalAnimalsLeagueCell:onInit(params)
	-- 加载MythicalAnimalsLeagueCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_comb_cell = res/cultivate/Mythical_animals/mythical_animals_comb_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_comb_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_comb_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsLeagueCell.__size == nil then
		MythicalAnimalsLeagueCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsLeagueCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_animal_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_animal_icon_1")
	self.Panel_animal_icon_1:removeAllChildren(true)

	self.Panel_animal_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_animal_icon_2")
	self.Panel_animal_icon_2:removeAllChildren(true)

	self.Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")
	self.Text_title:setString("")

	self.Panel_activty_animation = ccui.Helper:seekWidgetByName(root, "Panel_activty_animation")
	self.Panel_activty_animation:removeAllChildren(true)

	self.Image_activited = ccui.Helper:seekWidgetByName(root, "Image_activited")
	self.Image_activited:setVisible(false)

	self.ListView_text = ccui.Helper:seekWidgetByName(root, "ListView_text")
	self.ListView_text:removeAllItems()
end

function MythicalAnimalsLeagueCell:onExit()
	-- 释放MythicalAnimalsLeagueCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_comb_cell.csb", root)
	-- ]]
end

function MythicalAnimalsLeagueCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsLeagueCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_comb_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
