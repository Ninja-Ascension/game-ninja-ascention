----------------------------------------------------------------------------------------------------
-- 说明：点击拜访好友后的弹窗
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerFriendList = class("MineManagerFriendListClass", Window)
    
function MineManagerFriendList:ctor()
    self.super:ctor()
	app.load("client.cells.prop.model_prop_icon_cell")
	
    self.roots = {}
	self.friend_info = nil
	
    -- Initialize MineManager page state machine.
    local function init_mine_manager_friend_list_terminal()
	
		--返回
		local mine_manager_friend_list_into_mine_goto_friend_terminal = {
            _name = "mine_manager_friend_list_into_mine_goto_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params._datas._cell:intoMine(params._datas._uid)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_friend_list_into_mine_goto_friend_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_friend_list_terminal()
end

function MineManagerFriendList:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end

function MineManagerFriendList:onUpdateDraw()
	local root = self.roots[1]
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_009")			--名称
	local headPic = ccui.Helper:seekWidgetByName(root, "Panel_5")			--头像
	local leaveTime = ccui.Helper:seekWidgetByName(root, "Text_0010")		--离线时间
	local levelText = ccui.Helper:seekWidgetByName(root, "Text_0011")		--等级
	local haveCity = ccui.Helper:seekWidgetByName(root, "Text_0015")		--已有城池
	local patrolCity = ccui.Helper:seekWidgetByName(root, "Text_0016")		--巡逻城池
	local riotCity = ccui.Helper:seekWidgetByName(root, "Text_0017")		--暴动城池
	local riotCityImg = ccui.Helper:seekWidgetByName(root, "Image_1870")	--暴动城池的图标
	
	
	-- 填文本
	
	ccui.Helper:seekWidgetByName(root, "Text_12"):setString(tipStringInfo_mine_info[28])
	
	ccui.Helper:seekWidgetByName(root, "Text_13"):setString(tipStringInfo_mine_info[29])
	
	ccui.Helper:seekWidgetByName(root, "Text_14"):setString(tipStringInfo_mine_info[30])
	
	
	
	nameText:setString(self.friend_info.name)
	--leaveTime
	if verifySupportLanguage(_lua_release_language_en) == true then
		levelText:setString(tipStringInfo_mine_info[27]..self.friend_info.level)
	else
		levelText:setString(self.friend_info.level..tipStringInfo_mine_info[27])
	end
	haveCity:setString(self.friend_info.have_city)
	patrolCity:setString(self.friend_info.patrol_city)
	riotCity:setString(self.friend_info.riot_city)
	
	if tonumber(self.friend_info.riot_city) > 0 then
		riotCityImg:setVisible(true)
	else
		riotCityImg:setVisible(false)
	end
	
	-- 头像 模板id
	local icon = ModelPropIconCell:createCell()
	local data = icon:createDarwArgumentsConfig()
	data.imagePath = string.format("images/ui/props/props_%d.png", self.friend_info.head_picIndex)
	data.quality = self.friend_info.quality+1
	icon:initDarwArgumentsConfig(data)
	headPic:addChild(icon)
	
	-- 品质
	nameText:setColor(self:getColor(self.friend_info.quality+1))
	-- 用户id
	
	-- 在线时间 0 表示在线, 大于0表示离线时间,毫秒转为分钟做单位,直接取整
	local current_interval = math.floor(tonumber(self.friend_info.offline)/1000)
	local timeString = tipStringInfo_mine_info[1]
	if current_interval > 0 then
		
		local week	= math.floor(tonumber(current_interval)/3600/24/7)
		local day	= math.floor(tonumber(current_interval)/3600/24)
		local hour = math.floor(tonumber(current_interval)/3600%24)
		local minute  = math.floor((tonumber(current_interval)%3600)/60)
		minute = math.max(minute,1)
		
		
		if week > 0 then
			timeString = timeString..week..tipStringInfo_mine_info[3]
		elseif day > 0 then
			timeString = timeString..day..tipStringInfo_mine_info[4]
		elseif hour > 0 then
			timeString = timeString..hour..tipStringInfo_mine_info[5]
		elseif minute > 0 then
			timeString = timeString..minute..tipStringInfo_mine_info[6]
		end
	
	else
		timeString = tipStringInfo_mine_info[32]
	
	end
	
	leaveTime:setString(timeString)
end


function MineManagerFriendList:intoMine(uid)
	
	-- 记录下当前好友形象
	local friend_info = self.friend_info
	
	fwin:close(fwin:find("MineManagerFriendClass"))
	fwin:close(fwin:find("MineManagerClass"))
	
	local view = MineManager:new()
	view:init(uid, friend_info)
	fwin:open(view, fwin._view)
end

function MineManagerFriendList:onEnterTransitionFinish()

    local csbMineManager = csb.createNode("campaign/MineManager/attack_territory_frd_list.csb")
    self:addChild(csbMineManager)
	
   	local root = csbMineManager:getChildByName("root")
	table.insert(self.roots, root)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_gr_list_4")
	local size = panel:getContentSize()
	self:setContentSize(size)
	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_007_as"), nil, 
	{
		terminal_name = "mine_manager_friend_list_into_mine_goto_friend", 
		terminal_state = 0, 
		_cell = self,
		_uid = self.friend_info.uid,
		isPressedActionEnabled = true
	},
	nil,0)
		
		
	self:onUpdateDraw()
end

function MineManagerFriendList:init(info)
	self.friend_info = info		
end

function MineManagerFriendList:onExit()
	state_machine.remove("mine_manager_friend_list_into_mine_goto_friend")
end

function MineManagerFriendList:createCell()
	local cell = MineManagerFriendList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end