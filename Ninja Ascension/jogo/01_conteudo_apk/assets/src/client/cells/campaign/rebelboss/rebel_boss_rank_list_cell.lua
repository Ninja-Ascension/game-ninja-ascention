-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军积分排行榜
-------------------------------------------------------------------------------------------------------

RebelBossRankListCell = class("RebelBossRankListCellClass", Window)
    
function RebelBossRankListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self._rank = nil
	self._current_type = 1 --积分 2，伤害
	self._rankId = 1 --第几名

    -- Initialize RebelBossRankListCell page state machine.
    local function init_rebel_boss_rank_list_cell()

    end
    
    -- call func init hom state machine.
    init_rebel_boss_rank_list_cell()
end

function RebelBossRankListCell:initDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	-- Text_998 积分，最高伤害
	ccui.Helper:seekWidgetByName(root, "Text_999"):setString(self:convertValue(self._rank._integral))
	ccui.Helper:seekWidgetByName(root, "Text_3_0"):setString(self:convertValue(self._rank._fight))
	ccui.Helper:seekWidgetByName(root, "Text_ph_name"):setString(self._rank._name)
	if self._rank._union == nil or self._rank._union == "" then 
		ccui.Helper:seekWidgetByName(root, "Text_gh"):setString(tipStringInfo_union_str[69])
	else
		ccui.Helper:seekWidgetByName(root, "Text_gh"):setString(self._rank._union)
	end
	for i=1,3 do
		local rankImage = ccui.Helper:seekWidgetByName(root, "Image_ph_" .. i .. "st")
		rankImage:setVisible(false)
		if self._rankId <= 3 and i == self._rankId then 
			rankImage:setVisible(true)
		end
	end
	if self._rankId > 3 then 
		ccui.Helper:seekWidgetByName(root, "Text_ph_st"):setString("".. self._rankId)
	end
end

 -- _ED.rebelBoss.integral_rank = {}
 --                for i=1,4 do
 --                    _ED.rebelBoss.integral_rank[i] = {}
 --                    for j=1,5 do
 --                        local player = {
 --                            _id = j ,
 --                            _mould_id = 1102,
 --                            _name = "abb".. j,
 --                            _union = "wo qu"..j,
 --                            _fight = 151515 + j,
 --                            _integral = 7777 + j
 --                        }   
 --                    _ED.rebelBoss.integral_rank[i][j] = player
 --                    end
 --                end

function RebelBossRankListCell:convertValue(num)
    local numStr = "" .. num
    if num >= 10000 then
        numStr =  math.floor(num / 10000).._string_piece_info[150]
    end
    return numStr
end

function RebelBossRankListCell:createConfig(winMouldId, 	
												index,		
												experience,
												money, 		
												spoilsMouldId,
												spoilsType, 
												spoilsCount
												)
	-- winMouldId:  如果空,就表示该条显示的是失败信息,否则显示获得的物品名和文字品质
	local data = {}
	data.winMouldId 	= winMouldId or nil
	data.index 			= index or nil
	data.experience 	= experience or nil
	data.money 			= money or nil
	data.spoilsMouldId 	= spoilsMouldId or nil
	data.spoilsType 	= spoilsType or nil
	data.spoilsCount 	= spoilsCount or nil
	return data
end

function RebelBossRankListCell:onEnterTransitionFinish()
	
    local csbArenaLadder = csb.createNode("campaign/WorldBoss/wordBoss_phb_list_1.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	
	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_phb_list_1.csb")
    table.insert(self.actions, action)
    csbArenaLadder:runAction(action)
    action:play("list_view_cell_open", false)

	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_ph_list")
	tmpPanel:setSwallowTouches(false)
	self:setContentSize(tmpPanel:getContentSize())
	self:initDraw()
end

function RebelBossRankListCell:createCell()
	local cell = RebelBossRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function RebelBossRankListCell:init(reward,types,index)
	self._rank = reward
	self._current_type = types
	self._rankId = index
end

function RebelBossRankListCell:onExit()
end
