--------------------------------------------------------------------------------------------------------------
--  说明：军团排行榜列表(副本，等级)
--------------------------------------------------------------------------------------------------------------
UnionRankListCell = class("UnionRankListCellClass", Window)
UnionRankListCell.__size = nil
function UnionRankListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0

	self.max = 5
    if __lua_project_id == __lua_project_l_digital then
        self.max = 8
    end

	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	app.load("client.l_digital.union.create.SmUnionInfoWindow")
	 -- Initialize union rank list cell state machine.
    local function init_union_rank_list_cell_terminal()
		--查看
        local union_rank_list_cell_to_view_terminal = {
            _name = "union_rank_list_cell_to_view",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		local cell = params._datas.cell
           		local datas = {}
                datas.example = {}
                datas.example.union_icon = cell.example.nuion_icon
                datas.example.union_kuang = 1
                datas.example.union_name = cell.example.union_name
                datas.example.union_president_name = cell.example.union_president_name
                datas.example.union_id = cell.example.union_id
                datas.example.union_rank = cell.example.union_rank
                datas.example.union_level = cell.example.union_level
                datas.example.union_member = cell.example.union_member
                datas.example.union_watchword = cell.example.watchword
                datas.example.union_science_num = cell.example.union_science_num
                state_machine.excute("sm_union_info_window_window_open", 0, datas.example)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_rank_list_cell_to_view_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_rank_list_cell_terminal()

end


function UnionRankListCell:updateDraw()
	local root = self.roots[1]

	ccui.Helper:seekWidgetByName(root, "Text_4_10"):setString(self.example.union_president_name)
	if ccui.Helper:seekWidgetByName(root, "Text_4_11") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Text_4_11"):setString(self.example.union_member)
	end
	-- ccui.Helper:seekWidgetByName(root, "Text_16"):setString(self.example.union_watchword)
	ccui.Helper:seekWidgetByName(root, "Text_274_0"):setString(self.example.union_level)
	ccui.Helper:seekWidgetByName(root, "Text_274"):setString(self.example.union_name)
	local rankcount =tonumber(self.example.union_rank)
	ccui.Helper:seekWidgetByName(root, "Image_021"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_022"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_023"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_106"):setString("")
	if rankcount == 1 then
		ccui.Helper:seekWidgetByName(root, "Image_021"):setVisible(true)
	elseif rankcount== 2 then
		ccui.Helper:seekWidgetByName(root, "Image_022"):setVisible(true)
	elseif rankcount== 3 then
		ccui.Helper:seekWidgetByName(root, "Image_023"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Text_106"):setString(rankcount)
	end
	
	local Text_fighting = ccui.Helper:seekWidgetByName(root, "Text_fighting")
	if Text_fighting ~= nil then
		Text_fighting:setString(self.example.union_fight)
	end
	local icon = ccui.Helper:seekWidgetByName(root, "Panel_365")

	local cellOne = CnionLogoIconCell:createCell()
    cellOne:init(1,tonumber(self.example.nuion_icon),2)

	icon:removeAllChildren(true)
	icon:addChild(cellOne)
end

function UnionRankListCell:onInit()

	local csbUnionRankListCell= csb.createNode("legion/legion_rank_list.csb")
    local root = csbUnionRankListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	
	 -- local action = csb.createTimeline("legion/legion_rank_list.csb")
	 -- root:runAction(action)
	 -- action:play("list_view_cell_open", false)

	 root:getChildByName("Panel_247"):setSwallowTouches(false)
	 
    self:addChild(csbUnionRankListCell)
	if UnionRankListCell.__size == nil then
		UnionRankListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	
	
	--查看工会信息
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_247"), nil, 
 --    {
 --        terminal_name = "union_rank_list_cell_to_view", 
 --        terminal_state = 0,
 --        cell = self
 --    }, 
 --    nil, 0)

    local Panel_247 = ccui.Helper:seekWidgetByName(root, "Panel_247")

    local function fourOpenTouchEvent(sender, eventType)
    	local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
		if eventType == ccui.TouchEventType.began then
    		-- sender.isMoving = false
		elseif eventType == ccui.TouchEventType.moved then 
			-- sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
        	if math.abs(__epoint.y - __spoint.y) <= 8 then
        		state_machine.excute("union_rank_list_cell_to_view",0,{ _datas = { cell = self}})
        	end
        end
	end
	Panel_247:addTouchEventListener(fourOpenTouchEvent)

	self:updateDraw()
end

function UnionRankListCell:onEnterTransitionFinish()

end

function UnionRankListCell:init(example,index,last)

	self.last = last
	self.example = example
	self.index = index
	self.activityIndex = activityIndex
	if index < self.max then
		self:onInit()
	end
	self:setContentSize(UnionRankListCell.__size)
	-- self:onInit()
	return self
end

function UnionRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/legion_list_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function UnionRankListCell:onExit()
	cacher.freeRef("legion/legion_list_list.csb", self.roots[1])
end

function UnionRankListCell:createCell()
	local cell = UnionRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
