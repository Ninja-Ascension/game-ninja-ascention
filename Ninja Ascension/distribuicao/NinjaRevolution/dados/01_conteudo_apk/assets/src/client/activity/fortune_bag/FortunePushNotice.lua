--[[ ----------------------------------------------------------------------------
-- 排重奖励跑马灯
--]] ----------------------------------------------------------------------------
FortunePushNotice = class("FortunePushNoticeClass", Window)
FortunePushNotice.__size = nil

-- 创建Cell实例
local activity_fortune_push_notice_list_create_terminal = {
	_name = "activity_fortune_push_notice_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FortunePushNotice then
			local cell = FortunePushNotice:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_fortune_push_notice_list_create_terminal)
state_machine.init()

-- 构造器
function FortunePushNotice:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.cur_idx = 1
	self.update_time = 5
	self._stay_time = 10
	-- load lua files.

	-- Initialize sm luck draw record list page state machine.
	local function init_activity_fortune_push_notice_list_terminal()
		
	end
	-- call func init sm luck draw record list state machine.
	init_activity_fortune_push_notice_list_terminal()
end

-- 对象初始化
function FortunePushNotice:init(params)
	self._notice_infos = params[1]
	self:onInit(params)
	self:setContentSize(FortunePushNotice.__size)
	return self
end

function FortunePushNotice:onUpdateDraw()
	local root = self.roots[1]
	self.Panel_zs = ccui.Helper:seekWidgetByName(root, "Panel_zs")
	local panelWidth = root:getContentSize().width
	local panelPosY = self.Panel_zs:getPositionY()
	self.Panel_zs:setPosition(cc.p(panelWidth,panelPosY))
	-- 玩家名称
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

	-- 获得的道具名字
	self.Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
	if self._notice_infos and #self._notice_infos > 0 then
		self:runHourseCallFunc()
	end
end

-- 轮播
function FortunePushNotice:onDraw(notice)
	self.Text_player_name:setString(""..notice.nickName)
	local propData = zstring.split(notice.rewards,",")
	local propType = tonumber(propData[1])
	local propId = tonumber(propData[2])
	local porp_name = ""

	if 1 == propType or 
		2 == propType or 
		3 == propType or 
		9 == propType or
		10 == propType
		 then 
		porp_name = _my_gane_name[propType]
	elseif 4 == propType then 
		porp_name = _my_gane_name[5]
	elseif 6 == propType then
		local property = dms.int(dms["prop_mould"],propId,prop_mould.prop_name)
		local porp_name_word = dms.element(dms["word_mould"], property)
		porp_name = porp_name_word[3]
	elseif 7 == propType then 
		local nameindex = dms.int(dms["equipment_mould"], propId, equipment_mould.equipment_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3]	
	elseif 8 == propType then 
		porp_name = _my_gane_name[7]
	elseif 12 == propType then 
		porp_name = _my_gane_name[8]
	elseif 13 == propType then 
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_naruto then
			local evo_image = dms.string(dms["ship_mould"], propId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], propId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			porp_name = word_info[3]
		else
			porp_name = dms.string(dms["ship_mould"],propId, ship_mould.captain_name)
		end	
	elseif 18 == propType then 
		porp_name = _my_gane_name[6]
	elseif 20 == propType then 
		porp_name = _my_gane_name[11]
	elseif 28 == propType then 
		porp_name = _my_gane_name[13]
	elseif 31 == propType then 
		porp_name = red_alert_resouce_tip[1][1]
	elseif 33 == propType then 
		porp_name = _my_gane_name[14]
	elseif 34 == propType then 
		porp_name = _my_gane_name[15]
	elseif 71 == propType then
		local nameindex = dms.int(dms["ship_silk_bag_mould"], propId, ship_silk_bag_mould.silkbag_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3] 
	elseif 73 == propType then 
		local pos = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.pos)
		local suitId = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.suit_id)
		porp_name = dms.element(dms["word_mould"], dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos]
	end

	self.Text_props_name:setString(""..porp_name)

	
end

function FortunePushNotice:runHourseCallFunc()
	if not self._notice_infos or #self._notice_infos == 0 then
		return
	end
	self:onDraw(self._notice_infos[self.cur_idx])

	local panelWidth = self.roots[1]:getContentSize().width
	local panelPosY = self.Panel_zs:getPositionY()
	
	local moveStart = cc.MoveTo:create(0, cc.p(panelWidth,panelPosY))
	local moveAppear = cc.MoveTo:create(self.update_time, cc.p(0, panelPosY))
	local moveDisappear = cc.MoveTo:create(self.update_time, cc.p(-panelWidth, panelPosY))
	local curId = self.cur_idx
	local callfunc = cc.CallFunc:create(function ( sender )
						self.cur_idx = curId + 1
						if self._notice_infos == nil  then
							return
						end
						if self.cur_idx > #self._notice_infos then
							self.cur_idx = 1
						end
						self:runHourseCallFunc()
					end)
	local runSeqAction = cc.Sequence:create(moveStart,moveAppear,cc.DelayTime:create(self._stay_time),moveDisappear,callfunc)
	self.Panel_zs:runAction(runSeqAction)
end

function FortunePushNotice:clearUIInfo( ... )
	-- self.Text_props_name:setString('')
	-- self.Text_player_name:setString('')
end

function FortunePushNotice:onEnterTransitionFinish()
	
end

function FortunePushNotice:onInit(params)
	-- 加载FortunePushNoticeWindow界面资源.
	-- res.activity.wonderful.activity_fortune_push_notice_list = res/activity/wonderful/activity_fortune_push_notice_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/activity_fortune_push_notice_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/fortune_bag/fortune_bag_notice.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FortunePushNotice.__size == nil then
		FortunePushNotice.__size = root:getContentSize()
	end
    self:clearUIInfo()
	self:onUpdateDraw()
end

function FortunePushNotice:onExit()
	-- 释放FortunePushNoticeWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/fortune_bag/fortune_bag_notice.csb", root)
	-- ]]
end

function FortunePushNotice:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FortunePushNotice:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("activity/fortune_bag/fortune_bag_notice.csb", root)
	self:stopAllActions()
	root:removeFromParent(false)


	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------