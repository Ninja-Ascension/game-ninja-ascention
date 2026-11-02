--------------------------------------------------------------------------------------------------------------
--  说明：公会红包排行榜信息
--------------------------------------------------------------------------------------------------------------
unionRedEnvelopesRankListCell = class("unionRedEnvelopesRankListCellClass", Window)
unionRedEnvelopesRankListCell.__size = nil
function unionRedEnvelopesRankListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.campaign.icon.arena_role_icon_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_red_envelopes_rank_list_cell_terminal()
    	-- 发红包
        -- local union_red_envelopes_rank_list_cell_hair_terminal = {
            -- _name = "union_red_envelopes_rank_list_cell_hair",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	-- local cell = params._datas.cell
                -- local function responseCallback( response )
                    -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then

                        -- end 
                    -- end
                -- end
                -- protocol_command.union_red_packet_send.param_list = (tonumber(cell.example[2])-1).."\r\n"..cell.example[1]
                -- NetworkManager:register(protocol_command.union_red_packet_send.code, nil, nil, nil, instance, responseCallback, false, nil)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(union_red_envelopes_rank_list_cell_hair_terminal)

        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_red_envelopes_rank_list_cell_terminal()

end

function unionRedEnvelopesRankListCell:updateDraw()
	local root = self.roots[1]
	
	for i=1, 3 do
		ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(false)
		if tonumber(self.index) == i then
			ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_ranking"):setString("")
		end	
	end
	if tonumber(self.index) < 3 then
		ccui.Helper:seekWidgetByName(root, "Text_ranking"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Text_ranking"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_ranking"):setString(self.index)
	end
			
	--头像
	local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	Panel_player_icon:removeAllChildren(true)
	local icon = ArenaRoleIconCell:createCell()
	icon:init(tonumber(self.example.user_head), 1)
	Panel_player_icon:addChild(icon)

	--名字
	local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
	Text_player_name:setString(self.example.name)

	--次数
	local Text_cishu_n = ccui.Helper:seekWidgetByName(root, "Text_cishu_n")
	

	--价值
	local Text_jiazhi_n = ccui.Helper:seekWidgetByName(root, "Text_jiazhi_n")
	
	if tonumber(self.m_type) < 10 then
		Text_cishu_n:setString("")
		Text_jiazhi_n:setString(self.example.snatch_quota)
	else
		Text_cishu_n:setString(self.example.snatch_number)
		Text_jiazhi_n:setString(self.example.snatch_value)
	end
end

function unionRedEnvelopesRankListCell:onInit()

	local csbunionRedEnvelopesRankListCell= csb.createNode("legion/sm_legion_red_packet_rank_list.csb")
    local root = csbunionRedEnvelopesRankListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionRedEnvelopesRankListCell)
	if unionRedEnvelopesRankListCell.__size == nil then
		unionRedEnvelopesRankListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

	self:updateDraw()

	-- 发红包
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_qiang"), nil, 
    -- {
        -- terminal_name = "union_red_envelopes_rank_list_cell_hair",
        -- terminal_state = 0,
        -- cell = self,
        -- touch_black = true,
        -- isPressedActionEnabled = true
    -- },
    -- nil,0)
end

function unionRedEnvelopesRankListCell:onEnterTransitionFinish()

end

function unionRedEnvelopesRankListCell:init(example,index,m_type)
	self.example = example
	self.index = index
	self.m_type = m_type
	self:onInit()
	self:setContentSize(unionRedEnvelopesRankListCell.__size)
	-- self:onInit()
	return self
end

function unionRedEnvelopesRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionRedEnvelopesRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_red_packet_rank_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionRedEnvelopesRankListCell:onExit()
	cacher.freeRef("legion/sm_legion_red_packet_rank_list.csb", self.roots[1])
end

function unionRedEnvelopesRankListCell:createCell()
	local cell = unionRedEnvelopesRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
