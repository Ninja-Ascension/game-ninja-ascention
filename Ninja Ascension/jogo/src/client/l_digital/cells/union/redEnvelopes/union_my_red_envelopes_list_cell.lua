--------------------------------------------------------------------------------------------------------------
--  说明：公会我抢的红包信息
--------------------------------------------------------------------------------------------------------------
unionMyRedEnvelopesListCell = class("unionMyRedEnvelopesListCellClass", Window)
unionMyRedEnvelopesListCell.__size = nil
function unionMyRedEnvelopesListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	 -- Initialize union rank list cell state machine.
    local function init_union_my_red_envelopes_list_cell_terminal()
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_my_red_envelopes_list_cell_terminal()

end

function unionMyRedEnvelopesListCell:updateDraw()
	local root = self.roots[1]

	local data = zstring.split(self.example, ",")

	local Text_info = ccui.Helper:seekWidgetByName(root, "Text_info")
	local m_type = zstring.tonumber(data[5])
	if m_type == 6 then
		m_type = 3
	end
	-- for i,v in pairs(_ED.union_red_envelopes_can_be_snatched) do
	-- 	if tonumber(data[4]) == tonumber(v.times) then
	-- 		m_type = dms.int(dms["union_red_reward"], v.mould_id, union_red_reward.m_type)
	-- 		break
	-- 	end
	-- end
	Text_info:setString(string.format(_new_interface_text[78],data[2],data[3])..union_red_envelopes_tips[m_type])
end

function unionMyRedEnvelopesListCell:onInit()

	local csbunionMyRedEnvelopesListCell= csb.createNode("legion/sm_legion_red_packet_tab_3_list_2.csb")
    local root = csbunionMyRedEnvelopesListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionMyRedEnvelopesListCell)
	if unionMyRedEnvelopesListCell.__size == nil then
		unionMyRedEnvelopesListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	
	-- ccui.Helper:seekWidgetByName(root,"Panel_247"):setTouchEnabled(false)

	self:updateDraw()

end

function unionMyRedEnvelopesListCell:onEnterTransitionFinish()

end

function unionMyRedEnvelopesListCell:init(example,index)
	self.example = example
	self.index = index
	-- if index < 5 then
		self:onInit()
	-- end
	self:setContentSize(unionMyRedEnvelopesListCell.__size)
	-- self:onInit()
	return self
end

function unionMyRedEnvelopesListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionMyRedEnvelopesListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_red_packet_tab_3_list_2.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionMyRedEnvelopesListCell:onExit()
	cacher.freeRef("legion/sm_legion_red_packet_tab_3_list_2.csb", self.roots[1])
end

function unionMyRedEnvelopesListCell:createCell()
	local cell = unionMyRedEnvelopesListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
