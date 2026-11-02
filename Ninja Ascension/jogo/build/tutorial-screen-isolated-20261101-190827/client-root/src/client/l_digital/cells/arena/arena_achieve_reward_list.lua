-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场成就列表
-------------------------------------------------------------------------------------------------------

ArenaAchieveRewardCell = class("ArenaAchieveRewardCellClass", Window)
ArenaAchieveRewardCell.__size = nil

local arena_achieve_reward_cell_creat_terminal = {
    _name = "arena_achieve_reward_cell_creat",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaAchieveRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_achieve_reward_cell_creat_terminal)
state_machine.init()

    
function ArenaAchieveRewardCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._index = 0
	self.reward_type = 0
	app.load("client.cells.utils.resources_icon_cell")
    self.reworld_sorting = {}
    local function init_arena_achieve_reward_cell_terminal()
	
		 local arena_achieve_reward_cell_reward_request_terminal = {
            _name = "arena_achieve_reward_cell_reward_request",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cells
            	if cell.reward_type == 0 then
            		TipDlg.drawTextDailog(_new_interface_text[40])
            	elseif cell.reward_type == 1 then
	                local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("arena_achieve_reward_all_get_update" , 0 , cell._index)
							if response.node ~= nil and response.node.roots[1] ~= nil then
								response.node:onUpdateDraw()
                                state_machine.unlock("arena_achieve_reward_cell_reward_request", 0, "")
							end
                            fwin:close(fwin:find("DrawRareRewardClass"))
                            app.load("client.reward.DrawRareReward")
	                        local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(14,nil,cell.reworld_sorting)
	                        -- getRewardWnd:init(14)
	                        fwin:open(getRewardWnd, fwin._windows)
	                    end
	                end
                    state_machine.lock("arena_achieve_reward_cell_reward_request", 0, "")
	                protocol_command.draw_arena_order_reward.param_list = ""..cell._index
					NetworkManager:register(protocol_command.draw_arena_order_reward.code, nil, nil, nil, cell, recruitCallBack, false, nil)
				else
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local arena_achieve_reward_cell_updata_terminal = {
            _name = "arena_achieve_reward_cell_updata",
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
	
		state_machine.add(arena_achieve_reward_cell_updata_terminal)
		state_machine.add(arena_achieve_reward_cell_reward_request_terminal)
        state_machine.init()
    end

    init_arena_achieve_reward_cell_terminal()
end


function ArenaAchieveRewardCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_reward_bg = ccui.Helper:seekWidgetByName(root, "Panel_reward_bg")
    Panel_reward_bg:setBackGroundImage("images/ui/activity/ranking_reward_bg.png")
    ccui.Helper:seekWidgetByName(root, "Image_jifen_icon"):setVisible(false)
	local reward_info = dms.element(dms["arena_welfare"], self._index)
	local Text_jifen_to = ccui.Helper:seekWidgetByName(root, "Text_jifen_to")
	local rank_target = dms.atoi(reward_info , arena_welfare.rank_target)
	Text_jifen_to:setString(string.format(_new_interface_text[39], rank_target))

	local reward = zstring.split(dms.atos(reward_info , arena_welfare.reward_info), "|")

    local index = 1
	for i = 1 , #reward do
		local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
		Panel_reward:removeAllChildren(true)
		local data = zstring.split( reward[i], ",") 
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(data[1], data[3], data[2],nil,nil,nil,true)
		-- Panel_reward:addChild(cell)
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data[1],data[2],data[3]},false,true,false,true})
        Panel_reward:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = data[1]
        rewardinfo.id = data[2]
        rewardinfo.number = data[3]
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
	end

	local Panel_received = ccui.Helper:seekWidgetByName(root, "Panel_received")
	local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
	Panel_dh:removeAllChildren(true)
	Panel_received:setVisible(false)
	self.reward_type = 1
	local myMaxRank = zstring.tonumber(_ED.user_arena_max_order)
	if myMaxRank <= tonumber(rank_target) then
        for j , w in pairs(_ED.user_arena_order_reward_draw_state) do 
            if self._index == tonumber(w) then
                self.reward_type = 2
            end
        end
    else
    	self.reward_type = 0
    end
	if self.reward_type == 0 then
	elseif self.reward_type == 1 then
		local jsonFile = "sprite/spirte_arena_gx.json"
        local atlasFile = "sprite/spirte_arena_gx.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_dh:addChild(animation)
	else
		Panel_received:setVisible(true)
	end
end

function ArenaAchieveRewardCell:onEnterTransitionFinish()

end

function ArenaAchieveRewardCell:onInit()
    -- local csbItem = csb.createNode("campaign/ArenaStorage/sm_arena_reward_list.csb")
    -- local root = csbItem:getChildByName("root")
    -- table.insert(self.roots, root)
    -- root:removeFromParent(false)
    -- self:addChild(root)
	local root = cacher.createUIRef("campaign/ArenaStorage/sm_arena_reward_list.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if ArenaAchieveRewardCell.__size == nil then
		ArenaAchieveRewardCell.__size = root:getContentSize()
	end
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_reward_bg"), nil, 
    {
        terminal_name = "arena_achieve_reward_cell_reward_request", 
        terminal_state = 0, 
        cells = self,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function ArenaAchieveRewardCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/sm_arena_reward_list.csb", root)
end

function ArenaAchieveRewardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaAchieveRewardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/sm_arena_reward_list.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaAchieveRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
    if Panel_dh ~= nil then
        Panel_dh:removeAllChildren(true)
        for i=1,4 do
            local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
            Panel_reward:removeAllChildren(true)
        end
    end
end

function ArenaAchieveRewardCell:init(params)
	self._index = tonumber(params)
	if self._index ~= nil and self._index <= 5 then
        self:onInit()
    end
	self:setContentSize(ArenaAchieveRewardCell.__size)
    return self
end
