--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritSkill1 = class("FightSpiritSkill1Class", Window)
FightSpiritSkill1.__size = nil

local Color = {
	Normal = cc.c3b(tipStringInfo_fight_spirit[32][1], tipStringInfo_fight_spirit[32][2], tipStringInfo_fight_spirit[32][3]),
	Active = cc.c3b(tipStringInfo_fight_spirit[31][1], tipStringInfo_fight_spirit[31][2], tipStringInfo_fight_spirit[31][3]),
	NoActive = cc.c3b(tipStringInfo_fight_spirit[33][1], tipStringInfo_fight_spirit[33][2], tipStringInfo_fight_spirit[33][3]),
}

-- 创建Cell实例
local fight_spirit_skill1_create_terminal = {
	_name = "fight_spirit_skill1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritSkill1 then
			local cell = FightSpiritSkill1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 创建Cell实例
local fight_spirit_skill1_close_terminal = {
	_name = "fight_spirit_skill1_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritSkill1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_skill1_create_terminal)
state_machine.add(fight_spirit_skill1_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritSkill1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit skill1 page state machine.
	local function init_fight_spirit_skill1_terminal()
		-- 上锁解锁
        local fight_spirit_skill1_lock_terminal = {
            _name = "fight_spirit_skill1_lock",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas._self
                local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        				local isLock = true
						_self.Button_lock:setVisible(isLock)
						_self.Button_unlock:setVisible(not isLock)
        			end
        		end
		    	protocol_command.fight_spirit_lock.param_list = "".._self.fightSpirit.id .. "\r\n" .. 1
				NetworkManager:register(protocol_command.fight_spirit_lock.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_spirit_skill1_unlock_terminal = {
            _name = "fight_spirit_skill1_unlock",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas._self
                local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local isLock = false
						_self.Button_lock:setVisible(isLock)
						_self.Button_unlock:setVisible(not isLock)
        			end
        		end
		    	protocol_command.fight_spirit_lock.param_list = "".._self.fightSpirit.id .. "\r\n" .. 0
				NetworkManager:register(protocol_command.fight_spirit_lock.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fight_spirit_skill1_lock_terminal)
        state_machine.add(fight_spirit_skill1_unlock_terminal)
	end
	-- call func init fight spirit skill1 state machine.
	init_fight_spirit_skill1_terminal()
end

-- 对象初始化
function FightSpiritSkill1:init(params)
	self.fightSpirit = params.fightSpirit
	--1、随机预览，2、觉醒预览
	self.previewType = params.previewType
	--读取最新数据
	if self.fightSpirit.id and not self.previewType then
		self.fightSpirit = FightSpiritHandle.getFightSpiritById(self.fightSpirit.id)
	end
	
	self.widget = params.widget
	if nil ~= self.widget then
		local screenSize = cc.Director:getInstance():getWinSize() 
		self:setAnchorPoint(cc.p(0.5,0.5))
		self:setPosition(cc.p(screenSize.width / 2 / app.scaleFactor,screenSize.height / 2 / app.scaleFactor))
	end
	self:onInit(params)
	self:setContentSize(FightSpiritSkill1.__size)
	return self
end

function FightSpiritSkill1:onUpdateDraw()
	local root = self.roots[1]
	
	local fightSpirit = self.fightSpirit
	local cell = ResourcesIconCell:createCell()
	cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit = fightSpirit})
	ccui.Helper:seekWidgetByName(root, "Panel_skill_icon"):addChild(cell)
	
	local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
	ccui.Helper:seekWidgetByName(root, "Text_skill_cd"):setString(chinese_num[pos]..tipStringInfo_fight_spirit[1])
	local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(dms.element(dms["word_mould"], 
		dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos])

	if fightSpirit.shipId then
		ccui.Helper:seekWidgetByName(root, "Image_yzb"):setVisible(fightSpirit.shipId > 0)
	end

	local listview = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listview:removeAllItems()
	
	local totalHeight = 0
	function createLabel(index)
		local label = csb.createNode("packs/FightSpirit/FightSpirit_skill_list_"..index..".csb")

		local root = label:getChildByName("root")
		if __lua_project_id == __lua_project_l_digital then
			if root then
				label:setContentSize(root:getContentSize())
			end
		end

		return root
	end

	function addLabel(label, height)
		if __lua_project_id == __lua_project_l_digital then
			height = label:getContentSize().height + 10
		end
		local layout = ccui.Layout:create()
		layout:setContentSize(listview:getContentSize().width, height)
		layout:addChild(label)
		listview:addChild(layout)
		totalHeight = totalHeight + height
	end

	function splitAttr(attrs)
		local retAttrs = {}
		local attrList = zstring.split(attrs, "|")
        for _,attrItem in ipairs(attrList) do
            local attrItem = zstring.split(attrItem, ",", function (value) return tonumber(value) end)
            table.insert(retAttrs, attrItem)
        end
        return retAttrs
	end

	--主属性
	local titleRoot = createLabel(1)
	ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[2])
	addLabel(titleRoot:getParent(), 72)
	local attrs
	if self.previewType and self.previewType == 1 then
		local libId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.main_lib_id)
		local rows = dms.searchs(dms["fight_spirit_talent_mould"], fight_spirit_talent_mould.lib_type, 2,
			fight_spirit_talent_mould.lib_id, libId)
		local row = dms.searchs(rows, fight_spirit_talent_mould.quality, fightSpirit.quality + 1)[1]
		attrs = dms.atos(row, fight_spirit_talent_mould.strength_attr)
		attrs = zstring.split(attrs, "|")
		for i,v in ipairs(attrs) do
			local attr1 = zstring.split(v, ":")
			local attr2 = zstring.split(attr1[1], ",")
			attrs[i] = {tonumber(attr2[1]),tonumber(attr2[2]),0}
		end
	elseif self.previewType == 2 then
		attrs = self.fightSpirit.awakeShowAttrs
	else
		attrs = splitAttr(fightSpirit.addProperty.main)
	end
	for _,attr in ipairs(attrs) do
		local attrRoot = createLabel(2)
		local name, value = getHardenPropertyNameAndValue(attr[1], attr[2])
		ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString(name)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setString(value)
		local name, value = getHardenPropertyNameAndValue(attr[1], attr[3])
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString(attr[3] == 0 and "" or string.format(tipStringInfo_fight_spirit[18], value))
		addLabel(attrRoot:getParent(), 30)
	end

	--随机属性
	if self.previewType and self.previewType == 1 then
		local titleRoot = createLabel(1)
		ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[3])
		addLabel(titleRoot:getParent(), 72)

		local attrRoot = createLabel(2)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString("")
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString("")
		local text = ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1")

		local str = zstring.split(dms.string(dms["play_config"], 227, pirates_config.param), "|")
		local num = zstring.split(str[fightSpirit.quality], ",")[2]
		text:setString(string.format(tipStringInfo_fight_spirit[26], num))
		text:setAnchorPoint(cc.p(0.5,0))
		text:setPositionX(200)
		addLabel(attrRoot:getParent(), 30)
	elseif fightSpirit.addProperty.random then
		local titleRoot = createLabel(1)
		ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[3])
		addLabel(titleRoot:getParent(), 72)
		local attrs = splitAttr(fightSpirit.addProperty.random)
		for _,attr in ipairs(attrs) do
			local attrRoot = createLabel(2)
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[2])
			ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString(name)
			ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setString(value)
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[3])
			ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString(attr[3] == 0 and "" or string.format(tipStringInfo_fight_spirit[18], value))
			addLabel(attrRoot:getParent(), 30)
		end
	end
	
	--觉醒属性
	if self.previewType and self.previewType == 2 then
		local titleRoot = createLabel(1)
		ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[4])
		addLabel(titleRoot:getParent(), 72)

		local attrRoot = createLabel(2)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString("")
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString("")
		local text = ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1")
		text:setString(tipStringInfo_fight_spirit[27])
		text:setAnchorPoint(cc.p(0.5,0))
		text:setPositionX(200)
		addLabel(attrRoot:getParent(), 30)
	elseif fightSpirit.addProperty and fightSpirit.addProperty.awake and fightSpirit.addProperty.awake > 0 then
		local titleRoot = createLabel(1)
		ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[4])
		addLabel(titleRoot:getParent(), 72)

		local attrRoot = createLabel(2)
		local skillNameId = dms.string(dms["talent_mould"], fightSpirit.addProperty.awake, talent_mould.talent_describe)
	    local word_info = dms.element(dms["word_mould"], skillNameId)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString(word_info[3])
		ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setColor(Color.Active)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setString("")
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString("")
		addLabel(attrRoot:getParent(), 30)
	end

	--套装属性
	local titleRoot = createLabel(1)
	ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[5])
	addLabel(titleRoot:getParent(), 72)
	local attrsStr = dms.string(dms["play_config"], 225, play_config.param)
	local attrs = zstring.split(attrsStr, "|")
	local attr2 = zstring.split(attrs[1], ",")
	local attr4 = zstring.split(attrs[2], ",")
	local attrRoot = createLabel(2)
	local name, value = getHardenPropertyNameAndValue(attr2[1], attr2[2])
	ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString(name)
	ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setString(value)
	ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString("")
	if fightSpirit.extraInfo and fightSpirit.extraInfo.suit2Active then
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setColor(Color.Active)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setColor(Color.Active)
	else
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setColor(Color.NoActive)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setColor(Color.NoActive)
	end
	addLabel(attrRoot:getParent(), 30)
	
	local attrRoot = createLabel(2)
	local name, value = getHardenPropertyNameAndValue(attr4[1], attr4[2])
	ccui.Helper:seekWidgetByName(attrRoot, "Text_atk"):setString(name)
	ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setString(value)
	ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setString("")
	if fightSpirit.extraInfo and fightSpirit.extraInfo.suit4Active then
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setColor(Color.Active)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setColor(Color.Active)
	else
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_1"):setColor(Color.NoActive)
		ccui.Helper:seekWidgetByName(attrRoot, "Text_val_2"):setColor(Color.NoActive)
	end
	addLabel(attrRoot:getParent(), 30)
	
	--套装技能
	local titleRoot = createLabel(1)
	ccui.Helper:seekWidgetByName(titleRoot, "Text_1"):setString(tipStringInfo_fight_spirit[6])
	addLabel(titleRoot:getParent(), 72)
	local attrRoot = createLabel(3)
	local descId = dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.desc)
	local label = ccui.Helper:seekWidgetByName(attrRoot, "Text_skill")
	label:setString(dms.element(dms["word_mould"], descId)[3])
	if fightSpirit.extraInfo and fightSpirit.extraInfo.suit4Active then
		ccui.Helper:seekWidgetByName(attrRoot, "Text_skill"):setColor(Color.Active)
	else
		ccui.Helper:seekWidgetByName(attrRoot, "Text_skill"):setColor(Color.NoActive)
	end

	local autoRenderSize = label:getAutoRenderSize()
	local virtualRendererSize = label:getVirtualRendererSize()
	local needRowNumber = math.ceil(autoRenderSize.width / virtualRendererSize.width)
    local currRowNumber = math.floor(virtualRendererSize.height / autoRenderSize.height)
    local curHeight = 0

    curHeight = (needRowNumber - currRowNumber) * autoRenderSize.height + label:getFontSize() + 10
    label:setContentSize(label:getContentSize().width, label:getContentSize().height + curHeight)
    addLabel(attrRoot:getParent(), label:getContentSize().height + 12)

	listview:jumpToTop()
	listview:requestRefreshView()

	if not self.previewType then
		self.Button_lock:setVisible(fightSpirit.lockStatus == 1)
		self.Button_unlock:setVisible(fightSpirit.lockStatus ~= 1)
	else
		self.Button_lock:setVisible(false)
		self.Button_unlock:setVisible(false)
	end
	
end

function FightSpiritSkill1:onEnterTransitionFinish()
	
end

function FightSpiritSkill1:onInit(params)
	local csbItem = csb.createNode("packs/FightSpirit/FightSpirit_skill_1.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbItem)

	if FightSpiritSkill1.__size == nil then
		FightSpiritSkill1.__size = root:getContentSize()
	end

	self.Button_lock = ccui.Helper:seekWidgetByName(root, "Button_lock")
	fwin:addTouchEventListener(self.Button_lock, nil, 
	{
		terminal_name = "fight_spirit_skill1_unlock", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	}, nil, 0)
	
	self.Button_unlock = ccui.Helper:seekWidgetByName(root, "Button_unlock")
	fwin:addTouchEventListener(self.Button_unlock, nil, 
	{
		terminal_name = "fight_spirit_skill1_lock", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	}, nil, 0)
	if self.widget then 
		ccui.Helper:seekWidgetByName(root, "ListView_1"):setSwallowTouches(false)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1"), nil, 
	{
		terminal_name = "fight_spirit_skill1_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	}, nil, 0)
	end
	
	self:onUpdateDraw()
end

function FightSpiritSkill1:onExit()
	-- 释放FightSpiritSkill1Window界面资源.
	state_machine.remove("fight_spirit_skill1_lock")
	state_machine.remove("fight_spirit_skill1_unlock")
end

-- ~END
-- ----------------------------------------------------------------------------
