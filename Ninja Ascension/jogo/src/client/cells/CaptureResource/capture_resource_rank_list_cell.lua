-- ----------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

CaptureResourceRankListCell = class("CaptureResourceRankListCellClass", Window)
CaptureResourceRankListCell.__size = nil
function CaptureResourceRankListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.hero_data = nil

    local function init_capture_resource_rank_list_cell_terminal()
		
		local capture_resource_rank_list_cell_show_info_terminal = {
            _name = "capture_resource_rank_list_cell_show_info",
            _init = function (terminal) 
                app.load("client.chat.ChatFriendInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = ChatFriendInfo:createCell()
				cell:init(params._datas._id,1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(capture_resource_rank_list_cell_show_info_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_capture_resource_rank_list_cell_terminal()
end



function CaptureResourceRankListCell:onEnterTransitionFinish()

end

function CaptureResourceRankListCell:onInit()

	local root = cacher.createUIRef("secret_society/secret_rank_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if CaptureResourceRankListCell.__size == nil then
	 	local Panel_269 = ccui.Helper:seekWidgetByName(root, "Panel_269")
		local MySize = Panel_269:getContentSize()
	 	CaptureResourceRankListCell.__size = MySize
	end
	local user_id = self.hero_data.user_id
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_box")
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "capture_resource_rank_list_cell_show_info", 	
		_id = user_id,
		terminal_state = 0,
	}, 
	nil, 0)
	self:updateDraw()
end

function CaptureResourceRankListCell:updateDraw()
	local root = self.roots[1]
	local level = self.hero_data.user_level
	local score = self.hero_data.order_value	
	local user_name = self.hero_data.user_name
	local order = tonumber(self.hero_data.order)
	local Text_7 = ccui.Helper:seekWidgetByName(root, "Text_7") --积分
	Text_7:setString(score)
	local Text_103_0_1 = ccui.Helper:seekWidgetByName(root,"Text_103_0_1") -- 等级
	Text_103_0_1:setString(level)
	local Text_103 = ccui.Helper:seekWidgetByName(root,"Text_103") -- 名字
	Text_103:setString(user_name)

	local first = ccui.Helper:seekWidgetByName(root,"Image_232")
	local second = ccui.Helper:seekWidgetByName(root,"Image_420")
	local Third = ccui.Helper:seekWidgetByName(root,"Image_560")
	local Text_mingci_00 = ccui.Helper:seekWidgetByName(root, "Text_mingci_00") --名次
	Text_mingci_00:setString("")
	first:setVisible(false)
	second:setVisible(false)
	Third:setVisible(false)

	if order == 1 then
		first:setVisible(true)
	elseif order == 2 then
		second:setVisible(true)
	elseif order == 3 then
		Third:setVisible(true)
	else
		Text_mingci_00:setString(order)
	end		

	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_box")
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_3_ro")
	local quality = dms.int(dms["ship_mould"], self.hero_data.user_mould, ship_mould.ship_type)
	local pic = dms.int(dms["ship_mould"], self.hero_data.user_mould, ship_mould.head_icon)
	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	Panel_kuang:removeBackGroundImage()
	Panel_kuang:setBackGroundImage(quality_path)
	Panel_head:removeBackGroundImage()
	Panel_head:setBackGroundImage(big_icon_path)

	local Image_item_vip = ccui.Helper:seekWidgetByName(root, "Image_vip")
	Image_item_vip:setVisible(false)
	if tonumber(self.hero_data.vip_grade) > 0 then
		Image_item_vip:setVisible(true)
	end

end

function CaptureResourceRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CaptureResourceRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("secret_society/secret_rank_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function CaptureResourceRankListCell:init(hero_data,index)
	self.hero_data = hero_data
	self.index = index
	if index ~= nil and index < 5 then
		self:onInit()
	end
	self:setContentSize(CaptureResourceRankListCell.__size)
	return self
end

function CaptureResourceRankListCell:createCell()
	local cell = CaptureResourceRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function CaptureResourceRankListCell:onExit()
	cacher.freeRef("secret_society/secret_rank_list.csb", self.roots[1])
end

