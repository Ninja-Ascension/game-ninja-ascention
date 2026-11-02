-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场积分列表
-------------------------------------------------------------------------------------------------------

ArenaPointCell = class("ArenaPointCellClass", Window)
ArenaPointCell.__size = nil

local arene_point_cell_creat_terminal = {
    _name = "arene_point_cell_creat",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaPointCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arene_point_cell_creat_terminal)
state_machine.init()

    
function ArenaPointCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._index = 0
	self.canReward = false
	app.load("client.cells.utils.resources_icon_cell")
	self.reworld_sorting = {}
    local function init_arene_point_cell_terminal()
	
		 local arena_point_cell_reward_request_terminal = {
            _name = "arena_point_cell_reward_request",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		local cell = params._datas.cells
        		if cell.canReward == false then
        			return
        		end
                local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots[1] ~= nil then
							response.node:onUpdateDraw()
						end
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(14,nil,cell.reworld_sorting)
                        -- getRewardWnd:init(14)
                        fwin:open(getRewardWnd, fwin._windows)
                        state_machine.excute("arena_point_window_update_reward_state", 0, "")
                    end
                end
                protocol_command.draw_arena_score_reward.param_list = ""..cell._index
				NetworkManager:register(protocol_command.draw_arena_score_reward.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local arena_point_cell_updata_terminal = {
            _name = "arena_point_cell_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas._cell
				cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(arena_point_cell_updata_terminal)
		state_machine.add(arena_point_cell_reward_request_terminal)
        state_machine.init()
    end

    init_arene_point_cell_terminal()
end


function ArenaPointCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_tip_bar = ccui.Helper:seekWidgetByName(root, "Panel_tip_bar")
	local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward")
	Panel_tip_bar:setVisible(false)
	Panel_reward:setVisible(false)
	local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
	Text_jifen:setString(self._index * 2)

	local myPoint = tonumber(_ED.user_arena_score)
	local Image_link = ccui.Helper:seekWidgetByName(root, "Image_link") 
	Image_link:setVisible(false)
	if self._index < #dms["arena_score"] then
		local next_index = self._index + 1
		local next_reward_target = dms.int(dms["arena_score"], next_index, arena_score.point_target)
		if myPoint >= next_reward_target then
			Image_link:setVisible(true)
		end
	end
	if self._index == 0 then
		Panel_tip_bar:setVisible(true)
		return
	end
	Panel_reward:setVisible(true)
	local reward_info = dms.element(dms["arena_score"], self._index)
	local reward = zstring.split(dms.atos(reward_info , arena_score.reward_info), "|")

	local ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")
	ListView_reward_icon:removeAllItems()
	local index = 1
	for i = 1 , #reward do
		local data = zstring.split(reward[i], ",") 
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(data[1], data[3], data[2],nil,nil,nil,true)
		-- ListView_reward_icon:addChild(cell)
		local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data[1],data[2],data[3]},false,true,false,true})
        ListView_reward_icon:addChild(cell)
		-- ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"):setSwallowTouches(false)
		local rewardinfo = {}
        rewardinfo.type = data[1]
        rewardinfo.id = data[2]
        rewardinfo.number = data[3]
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
	end

	local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no")
	local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
	local Panel_receive = ccui.Helper:seekWidgetByName(root, "Panel_receive")
	local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
	Panel_klq:removeAllChildren(true)
	Image_no:setVisible(false)
	Image_over:setVisible(false)
	Panel_receive:setVisible(false)
	local reward_type = 1
	local reward_target = dms.atoi(reward_info ,arena_score.point_target) 
	if myPoint >= tonumber(reward_target) then
        for j , w in pairs(_ED.user_arena_order_score_draw_state) do 
            if self._index == tonumber(w) then
                reward_type = 2
            end
        end
    else
    	reward_type = 0
    end
    self.canReward = false
	if reward_type == 0 then
		Image_no:setVisible(true)
	elseif reward_type == 1 then
		self.canReward = true
		Panel_receive:setVisible(true)
		local jsonFile = "sprite/spirte_kelingqu.json"
        local atlasFile = "sprite/spirte_kelingqu.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_klq:addChild(animation)
	else
		Image_over:setVisible(true)
	end
end

function ArenaPointCell:onEnterTransitionFinish()

end

function ArenaPointCell:onInit()
	local root = cacher.createUIRef(config_csb.campaign.ArenaStorage.ArenaStorage_jifen_list, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if ArenaPointCell.__size == nil then
		ArenaPointCell.__size = root:getContentSize()
	end
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_receive"), nil, 
    {
        terminal_name = "arena_point_cell_reward_request", 
        terminal_state = 0, 
        cells = self,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function ArenaPointCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.campaign.ArenaStorage.ArenaStorage_jifen_list, root)
end

function ArenaPointCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaPointCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.campaign.ArenaStorage.ArenaStorage_jifen_list, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaPointCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")
    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
    local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
    if ListView_reward_icon ~= nil then
        ListView_reward_icon:removeAllItems()
        Text_jifen:setString("")
        Panel_klq:removeAllChildren(true)
    end
end

function ArenaPointCell:init(params)
	self._index = tonumber(params)
	if self._index ~= nil and self._index <= 4 then
        self:onInit()
    end
	self:setContentSize(ArenaPointCell.__size)
    return self
end
