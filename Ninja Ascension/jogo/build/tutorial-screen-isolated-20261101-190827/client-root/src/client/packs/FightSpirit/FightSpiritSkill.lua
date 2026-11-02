--[[ ----------------------------------------------------------------------------
-- 技能详情
--]] ----------------------------------------------------------------------------
FightSpiritSkill = class("FightSpiritSkillClass", Window)

-- 打开窗口
local fight_spirit_skill_window_open_terminal = {
	_name = "fight_spirit_skill_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritSkillClass") then
			fwin:open(FightSpiritSkill:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_skill_window_close_terminal = {
	_name = "fight_spirit_skill_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritSkillClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_skill_window_open_terminal)
state_machine.add(fight_spirit_skill_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritSkill:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.packs.FightSpirit.fightspiritskill1")
	app.load("client.cells.utils.resources_icon_cell")

	-- Initialize fight spirit skill page state machine.
	local function init_fight_spirit_skill_terminal()
		-- 打开角色创建窗口
		local fight_spirit_skill_open_terminal = {
			_name = "fight_spirit_skill_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local fight_spirit_skill_close_terminal = {
			_name = "fight_spirit_skill_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance.fightSpirit1.id then
					local fightSpirit = FightSpiritHandle.getFightSpiritById(instance.fightSpirit1.id)
					local needRefresh = instance.fightSpirit1.lockStatus ~= fightSpirit.lockStatus
					if not needRefresh and instance.fightSpirit2 then
						fightSpirit = FightSpiritHandle.getFightSpiritById(instance.fightSpirit2.id)
						needRefresh = instance.fightSpirit2.lockStatus ~= fightSpirit.lockStatus
					end
					if needRefresh then
						state_machine.excute("fight_spirit_main_update_detail", 0, {})
						state_machine.excute("fight_spirit_qianghua_lock_refresh", 0, {})
						if fwin:find("FightSpiritSelectClass") then
							fwin:find("FightSpiritSelectClass"):onUpdateDraw()
						end
					end
				end
				state_machine.excute("fight_spirit_skill_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_skill_show_terminal = {
			_name = "fight_spirit_skill_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local fight_spirit_skill_hide_terminal = {
			_name = "fight_spirit_skill_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击按钮
		local fight_spirit_skill_click_button_terminal = {
			_name = "fight_spirit_skill_click_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local name = params._datas.name
				if name == "qianghua" then
					if FightSpiritHandle.canStrength(instance.fightSpirit1.id) then
						state_machine.excute("fight_spirit_qianghua_window_open", nil, {fightSpiritId = instance.fightSpirit1.id})
					else
						TipDlg.drawTextDailog(tipStringInfo_fight_spirit[28])
						return
					end
				elseif name == "genghuan" or name == "zhuangbei" then
					if not instance.fightSpirit2 and name == "genghuan" then
						local pos = dms.int(dms["fight_spirit_mould"], instance.fightSpirit1.mouldId, fight_spirit_mould.pos)
						state_machine.excute("fight_spirit_zh_equip_window_open", 0, {pos = pos, hasEquip = true, shipId = instance.shipId})
					else
						FightSpiritHandle.setShipFightSpirit(instance.shipId, instance.fightSpirit1.id)
					end
				elseif name == "xiexia" then
					local pos = dms.int(dms["fight_spirit_mould"], instance.fightSpirit1.mouldId, fight_spirit_mould.pos)
					FightSpiritHandle.unloadShipFightSpirit(instance.shipId, pos)
				elseif name == "juexing" or name == "xilian" then
					local wnd = fwin:find("FightSpiritClass")
					if not wnd then
						state_machine.excute("fight_spirit_window_open", 0, {page = 3, curShipId = instance.shipId, types = instance.types})
						wnd = fwin:find("FightSpiritClass")
					end
					wnd:changeSelectPage(3)
					wnd = fwin:find("FightSpiritCell2Class")
					wnd:updateRightLayout(instance.fightSpirit1)
				end
				state_machine.excute("fight_spirit_skill_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_skill_open_terminal)
		state_machine.add(fight_spirit_skill_close_terminal)
		state_machine.add(fight_spirit_skill_show_terminal)
		state_machine.add(fight_spirit_skill_hide_terminal)
		state_machine.add(fight_spirit_skill_click_button_terminal)
		state_machine.init()
	end
	-- call func init fight spirit skill state machine.
	init_fight_spirit_skill_terminal()
end

-- 对象初始化
function FightSpiritSkill:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritSkill:onInit(params)
	self.fightSpirit1 = params._datas.fightSpirit1
	self.fightSpirit2 = params._datas.fightSpirit2
	self.btnList = params._datas.btnList or {}
	self.shipId = params._datas.shipId
	self.previewType = params._datas.previewType
	self.types = params.types
end

function FightSpiritSkill:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_fight_soul = ccui.Helper:seekWidgetByName(root, "Panel_fight_soul")

	local cell = state_machine.excute("fight_spirit_skill1_create", 0, {fightSpirit = self.fightSpirit1, previewType = self.previewType})
	self.Panel_fight_soul:addChild(cell)

	local btnNode = cc.Node:create()
	local btnList = {}
	for _,name in ipairs(self.btnList) do
		local btnLayer = csb.createNode("packs/FightSpirit/FightSpirit_skill_btn.csb")
		local btnRoot = btnLayer:getChildByName("root")
		local children = btnRoot:getChildren()
		for _,v in ipairs(children) do
			if v:getName() == "Button_"..name then
				v:setVisible(true)
				fwin:addTouchEventListener(v, nil,
				{
					terminal_name = "fight_spirit_skill_click_button",
					terminal_state = 0,
					isPressedActionEnabled = true,
					name = name,
				}, nil, 0)
			else
				v:setVisible(false)
			end
		end
		btnNode:addChild(btnLayer)
		for _,btn in ipairs(btnList) do
			btn:setPositionY(btn:getPositionY() + 45)
		end
		table.insert(btnList, btnLayer)
	end
	self.Panel_fight_soul:addChild(btnNode)

	if self.fightSpirit2 then
		cell:setPosition(460,60)
		local cell2 = state_machine.excute("fight_spirit_skill1_create", 0, {fightSpirit = self.fightSpirit2, previewType = self.previewType})
		self.Panel_fight_soul:addChild(cell2)
		cell2:setPosition(76,60)
		btnNode:setPosition(844,60)
	else
		cell:setPosition(288,60)
		btnNode:setPosition(672,60)
	end
end

function FightSpiritSkill:onEnterTransitionFinish()
	-- 加载FightSpiritSkillWindow界面资源.
	-- res.packs.FightSpirit.FightSpirit_skill = res/packs/FightSpirit/FightSpirit_skill.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_skill.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	ccui.Helper:seekWidgetByName(root, "Panel_fight_soul"):setSwallowTouches(false)
	
	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "fight_spirit_skill_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function FightSpiritSkill:onExit()
	-- 释放FightSpiritSkillWindow界面资源.
	state_machine.remove("fight_spirit_skill_open")
	state_machine.remove("fight_spirit_skill_close")
	state_machine.remove("fight_spirit_skill_show")
	state_machine.remove("fight_spirit_skill_hide")
	state_machine.remove("fight_spirit_skill_click_button")
end

function FightSpiritSkill:close()
	-- window event : close.
	
end

function FightSpiritSkill:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
