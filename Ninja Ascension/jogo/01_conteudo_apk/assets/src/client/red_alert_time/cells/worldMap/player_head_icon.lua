-----------------------------
--玩家头像icon
-----------------------------
PlayerHeadIcon = class("PlayerHeadIconClass", Window)
PlayerHeadIcon.__size = nil

function PlayerHeadIcon:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil

    app.load("client.red_alert_time.friend.RedAlertTimeFriendInfo")

    local function init_player_head_icon_cell_terminal()
        local player_head_icon_cell_look_info_terminal = {
            _name = "player_head_icon_cell_look_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("red_alert_time_friend_info_open", 0, ""..cell.m_object._user_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(player_head_icon_cell_look_info_terminal)
        state_machine.init()
    end
    init_player_head_icon_cell_terminal()
end

function PlayerHeadIcon:onEnterTransitionFinish()

end

function PlayerHeadIcon:onUpdateDraw()
    local root = self.roots[1]
	local head_data = nil
	local head_info = nil
	local head_frame = nil
	local head_image = nil
	local accessories_data = 0
	if zstring.tonumber(self.m_object._type) == 0 then
		-- 1是头像，挂饰，称号
		head_data = zstring.split(self.m_object.object, ",")
		head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
		--底框
		head_frame = head_info[2]

		--图标
		head_image = head_info[1]
		--配饰
		
		if tonumber(head_data[2]) > 0 then
			accessories_data = dms.int(dms["avatar_head"], head_data[2], avatar_head.animation)
		end
	end
	--外框
	local Sprite_quality_icon = root:getChildByName("Sprite_quality_icon")
    Sprite_quality_icon:removeAllChildren(true)
	if zstring.tonumber(self.m_object._type) == 0 then
		local max_count = dms.int(dms["base_consume"], 98, base_consume.vip_0_value + tonumber(self.m_object.vip)) -- 最大生产队列长度
		--玩家
		Sprite_quality_icon:setTexture(string.format("images/ui/icon/icon_%s.png", max_count))
		if max_count>=3 then
			local pic = nil
			local pic_name = nil
			if max_count == 3 then
				pic = "images/ui/effice/effect_quality_box_1/effect_quality_box_1.ExportJson"
				pic_name = "effect_quality_box_1"
			elseif max_count == 4 then
				pic = "images/ui/effice/effect_quality_box_2/effect_quality_box_2.ExportJson"
				pic_name = "effect_quality_box_2"
			end
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pic)
			local armature = ccs.Armature:create(pic_name)
			armature:getAnimation():playWithIndex(0)
			armature:setPosition(cc.p(Sprite_quality_icon:getContentSize().width/2,Sprite_quality_icon:getContentSize().height/2))
			Sprite_quality_icon:addChild(armature)
		end
	else
		--矿
		Sprite_quality_icon:setTexture("images/ui/icon/icon_100.png")
	end
	--头像
	local Sprite_head_icon = root:getChildByName("Sprite_head_icon")
	if zstring.tonumber(self.m_object._type) == 0 then
		Sprite_head_icon:setTexture(string.format(config_res.images.ui.props.props, head_image))
		--玩家
	elseif zstring.tonumber(self.m_object._type) == 1 then
		--矿
		local element = dms.element(dms["world_mine_mould"], self.m_object._mould_id)
		local pic = dms.atoi(element, world_mine_mould.pic)
		Sprite_head_icon:setTexture(string.format(config_res.images.ui.props.props, pic))
	elseif zstring.tonumber(self.m_object._type) == 2 then
		-- 世界的矿图标
		local element = dms.element(dms["world_mine_mould"], self.m_object._mould_id)
		local pic = dms.atoi(element, world_mine_mould.pic)
		Sprite_head_icon:setTexture("images/ui/props/props_"..pic.."_1.png")
	end

	if self.m_object._isGray == true then
		display:gray(Sprite_quality_icon)
	    display:gray(Sprite_head_icon)
	else
		display:ungray(Sprite_quality_icon)
	    display:ungray(Sprite_head_icon)
	end
	--头顶动画
	local Panel_head_effice = ccui.Helper:seekWidgetByName(root,"Panel_head_effice")
	Panel_head_effice:removeAllChildren(true)
	if zstring.tonumber(self.m_object._type) == 0 then
		if self.is_effice == 0 then
			if accessories_data > 0 then
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/biaoqing/effect_deco_1/effect_deco_1.ExportJson")
				local armature = ccs.Armature:create("effect_deco_1")
				local roleIcon = ccs.Skin:create("images/ui/biaoqing/effect_deco_" .. accessories_data .. ".png")
				armature:getBone("Layer1"):addDisplay(roleIcon, 0)
				armature:getAnimation():playWithIndex(0)
				Panel_head_effice:addChild(armature)
			end
		end
	end
	
end

function PlayerHeadIcon:init(info,isEffice)
    self.m_object = info
	self.is_effice = isEffice or 0
    -- if index ~= nil and index < 5 then
	self:onInit()
    -- end
	self:setContentSize(PlayerHeadIcon.__size)
    return self
end

function PlayerHeadIcon:onInit()
    local root = cacher.createUIRef(config_csb.cells.player.player_head_icon, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if PlayerHeadIcon.__size == nil then
        PlayerHeadIcon.__size = root:getContentSize()
    end

    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                state_machine.excute("player_head_icon_cell_look_info", 0, {_datas = {cell = self}})
            end
        end
    end

    if self.m_object._is_click == true and self.m_object._user_id > 0 then
        root:setTouchEnabled(true)
        root:setSwallowTouches(false)
        root:addTouchEventListener(panelTouchListener)
    else
        root:setTouchEnabled(false)
    end
    
    self:onUpdateDraw() 
end

function PlayerHeadIcon:clearUIInfo( ... )
    local root = self.roots[1]
	local Panel_head_effice = ccui.Helper:seekWidgetByName(root,"Panel_head_effice")
	if Panel_head_effice ~= nil then
		local Sprite_quality_icon = root:getChildByName("Sprite_quality_icon")
		local Sprite_head_icon = root:getChildByName("Sprite_head_icon")
        Sprite_quality_icon:removeAllChildren(true)
		display:ungray(Sprite_head_icon)
		display:ungray(Sprite_quality_icon)
		Panel_head_effice:removeAllChildren(true)
        root:setTouchEnabled(false)
	end
end

function PlayerHeadIcon:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PlayerHeadIcon:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_head_icon, root)
    root:removeFromParent(false)
    self.roots = {}
end

function PlayerHeadIcon:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_head_icon, self.roots[1])
end

function PlayerHeadIcon:createCell()
	local cell = PlayerHeadIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end