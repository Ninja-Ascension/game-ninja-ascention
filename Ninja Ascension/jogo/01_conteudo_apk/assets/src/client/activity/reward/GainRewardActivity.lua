-- ----------------------------------------------------------------------------------------------------
-- 说明：领奖中心
-- 创建时间2014-03-02 22:07
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

GainRewardActivity = class("GainRewardActivityClass", Window)

function GainRewardActivity:ctor()
    self.super:ctor()
	self.roots = {}
	self._index = 0
	app.load("client.cells.activity.gain_reward_list_cell")
	app.load("client.reward.DrawRareReward")
    local function init_GainRewardActivity_terminal()
		local to_get_equip_close_terminal = {
            _name = "gain_reward_centre_close",
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
		local gain_reward_news_send_terminal = {
            _name = "gain_reward_news_send",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:gainRewardNews(params[1],params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(gain_reward_news_send_terminal)
		state_machine.add(to_get_equip_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_GainRewardActivity_terminal()
end

function GainRewardActivity:gainRewardNews(_cell,reward)
	local root = self.roots[1]
	local ItmeListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local listTable = ItmeListView:getItems()
	
	self._index = self._index - 1
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		ItmeListView:removeItem(ItmeListView:getIndex(_cell))
	else
		_cell:removeFromParent(true)
	end
	for i,v in pairs(_ED._reward_centre) do
		if v == reward then
			
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then 
				--龙虎门奖励中心清除工会战奖励
				if zstring.tonumber(v._reward_type) == 14 then 
					_ED.union_fight_reward_info = nil
				end
			end
			_ED._reward_centre[i] = nil
			break
		end
	end
	
	-- for sgn, v in pairs(_ED.show_reward_list_group) do
	-- 	if 7 == v.show_reward_type then
	-- 		local getRewardWnd = DrawRareReward:new()
	-- 		getRewardWnd:init(7)
	-- 		fwin:open(getRewardWnd,fwin._windows)
	-- 	end
	-- end

	local tempRewardInfo = getSceneReward(7)
	if tempRewardInfo ~= nil then
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7, tempRewardInfo)
		fwin:open(getRewardWnd,fwin._windows)
	end
	-- print("===============",listTable,self._index,#ItmeListView:getItems())
	if listTable == nil or self._index <= 0  or #ItmeListView:getItems() == 0 then
		fwin:close(self)
		fwin:find("HomeClass"):cleanReawrd()
	end

	
	
end

function GainRewardActivity.loading_cell()

	if GainRewardActivity.itmeListView == nil then 
		return
	end	
	if _ED._reward_centre[GainRewardActivity.asnycKeys[GainRewardActivity.asnycIndex]] ~= nil then
		local cell = GainRewardListCell:createCell()
		cell:init(_ED._reward_centre[GainRewardActivity.asnycKeys[GainRewardActivity.asnycIndex]])
		GainRewardActivity.itmeListView:addChild(cell)
		GainRewardActivity.itmeListView:requestRefreshView()
	end
	GainRewardActivity.asnycIndex = GainRewardActivity.asnycIndex + 1
end

function GainRewardActivity:upDataDraw()
	local root = self.roots[1]
	local ItmeListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ItmeListView:removeAllChildren(true)
	self._index = 0
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	GainRewardActivity.itmeListView = ItmeListView
	GainRewardActivity.asnycIndex = 1
	GainRewardActivity.asnycKeys = {}

	for k,v in pairs(_ED._reward_centre) do
		self._index = self._index +1
		-- local cell = GainRewardListCell:createCell()
		-- cell:init(v)
		-- ItmeListView:addChild(cell)
		
		table.insert(GainRewardActivity.asnycKeys, k)
		
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell)
	end
end

function GainRewardActivity:onEnterTransitionFinish()
    local csbGainRewardActivity = csb.createNode("activity/award_center.csb")
    self:addChild(csbGainRewardActivity)
	local root = csbGainRewardActivity:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("activity/award_center.csb") 
	
   	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbGainRewardActivity:runAction(action)
	self:upDataDraw()
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.Home)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
		{
			terminal_name = "gain_reward_centre_close", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,2)	
	
end

function GainRewardActivity:init()
	
end


function GainRewardActivity:createCell()
	local cell = GainRewardActivity:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function GainRewardActivity:onExit()
	GainRewardActivity.itmeListView = nil
	GainRewardActivity.asnycIndex = 1
	GainRewardActivity.asnycKeys = nil
	state_machine.remove("gain_reward_centre_close")
	state_machine.remove("gain_reward_news_send")
end