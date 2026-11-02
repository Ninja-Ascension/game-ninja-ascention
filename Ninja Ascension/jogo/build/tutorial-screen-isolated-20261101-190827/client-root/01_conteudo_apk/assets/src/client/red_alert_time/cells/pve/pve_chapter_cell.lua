----------------------------------------------------------------------------------------------------
-- 说明：副本章节cell
-------------------------------------------------------------------------------------------------------
PveChapterCell = class("PveChapterCellClass", Window)
PveChapterCell.__size = nil

local pve_chapter_create_cell_terminal = {
    _name = "pve_chapter_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveChapterCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_chapter_create_cell_terminal)
state_machine.init()

function PveChapterCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._index = 0
    -- 章节ID
	self._scene_id = 0
    -- 章节开启状态
    self._state = 0
 	local function init_pve_chapter_cell_terminal()
        local pve_chapter_cell_choose_terminal = {
            _name = "pve_chapter_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if zstring.tonumber(cell._state) < 0 then
                    local open_level = dms.int(dms["pve_scene"], cell._scene_id, pve_scene.open_level)
                    if tonumber(_ED.user_info.user_grade) < open_level then
                        TipDlg.drawTextDailog(string.format(red_alert_all_str[272], "" .. open_level, ""))
                    else
                        local by_open_scene = dms.int(dms["pve_scene"], cell._scene_id, pve_scene.by_open_scene)
                        if by_open_scene > 0 then
                            local scene_name = dms.string(dms["pve_scene"], by_open_scene, pve_scene.scene_name)
                            TipDlg.drawTextDailog(string.format(red_alert_time_str[25], scene_name))
                        end
                    end
                else
                    state_machine.excute("pve_map_open", 0, {cell._scene_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 通关动画
        local pve_chapter_cell_play_complete_effect_terminal = {
            _name = "pve_chapter_cell_play_complete_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:playCompleteEffect()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local pve_chapter_cell_update_info_terminal = {
            _name = "pve_chapter_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._index = params.index
                cell._scene_id = params.scene_id
                cell._state = params.state
                if cell._state ~= nil then
                    if cell._index <= 6 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_chapter_cell_choose_terminal)
        state_machine.add(pve_chapter_cell_play_complete_effect_terminal)
        state_machine.add(pve_chapter_cell_update_info_terminal)
        state_machine.init()
    end
	init_pve_chapter_cell_terminal()        	
end

function PveChapterCell:playCompleteEffect()
    local root = self.roots[1]
    checkPlayEffect(49)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boom_pve)
    local armature = ccs.Armature:create("effect_boom_pve")
    draw.initArmatureTwo(armature, nil, -1, 1000, 1, 0)

    armature:setPosition(cc.p(root:getContentSize().width/2,root:getContentSize().height/2))
    root:addChild(armature)
end

function PveChapterCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_chapter_star_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_star_n")
    local pve_scene_mould = dms.element(dms["pve_scene"], self._scene_id)
    local npcs = zstring.split(dms.atos(pve_scene_mould, pve_scene.npcs), ",")

    -- 底图
    local Panel_chapter_pic = ccui.Helper:seekWidgetByName(root, "Panel_chapter_pic")
    local pic = dms.atoi(pve_scene_mould, pve_scene.scene_entry_pic)
    -- Panel_chapter_pic:setBackGroundImage(string.format(config_res.images.ui.pve.pve_chapter_pic, pic))
	local Sprite_chapter_pic = root:getChildByName("Panel_chapter_pic"):getChildByName("Sprite_chapter_pic")
	Sprite_chapter_pic:setTexture(string.format(config_res.images.ui.pve.pve_chapter_pic, pic))
    -- 章节名
    local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
    local name = dms.atos(pve_scene_mould, pve_scene.scene_name)
    Text_chapter_name:setString(self._scene_id.."."..name)

    -- 获得星数
    local Text_chapter_star_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_star_n")
    Text_chapter_star_n:removeAllChildren(true)
    local current_star = tonumber(_ED.get_star_count[self._scene_id])
    local max_star = dms.atoi(pve_scene_mould, pve_scene.total_star)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, current_star, "fonts/simhei.ttf",28)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..max_star , "fonts/simhei.ttf",28)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_chapter_star_n:getContentSize().width/2,Text_chapter_star_n:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_chapter_star_n:getContentSize().width,28))
    _richText:ignoreAnchorPointForPosition(true)
    Text_chapter_star_n:addChild(_richText)
    local reward_need_star = zstring.split(dms.atos(pve_scene_mould, pve_scene.reward_need_star), ",")
	local openBox = {
		{1,3,5,7},
		{2,3,6,7},
		{4,5,6,7},
	}
	local Panel_box_rec = ccui.Helper:seekWidgetByName(root, "Panel_box_rec")
	Panel_box_rec:removeAllChildren(true)
    for i=1,3 do
        local Image_chapter_star = ccui.Helper:seekWidgetByName(root, "Image_chapter_star_"..i)
        Image_chapter_star:setVisible(false)
        if current_star >= tonumber(reward_need_star[i]) then
            Image_chapter_star:setVisible(true)
			if Panel_box_rec:getChildByTag(500+i) == nil then
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)
				local armature = ccs.Armature:create("effect_box_get")
				armature:getAnimation():playWithIndex(0)
				armature:setPosition(cc.p(Panel_box_rec:getContentSize().width/2,Panel_box_rec:getContentSize().height/2))
				armature:setTag(500+i)
				Panel_box_rec:addChild(armature)
			end
        end
		for j=1, 4 do
			if openBox[i][j] == tonumber(_ED.star_reward_state[self._scene_id]) then
				if Panel_box_rec:getChildByTag(500+i) ~= nil then
					Panel_box_rec:removeChildByTag(500+i)
				end
			end
		end
    end
	

    local lastNPC = tonumber(npcs[#npcs])
    local npcState = tonumber(_ED.npc_state[lastNPC])

    -- 开启条件
    local Text_chapter_open_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_open_n")
    Text_chapter_open_n:setString("")
    Text_chapter_open_n:setVisible(true)
    -- 开启状态
    local Text_checkpoint_state_n = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_state_n")
    Text_checkpoint_state_n:setString("")
    Panel_chapter_pic:setTouchEnabled(true)
    -- Panel_chapter_pic:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
	local Sprite_checkpoint_state_bg = root:getChildByName("Sprite_checkpoint_state_bg")
    local Sprite_checkpoint_state_attack_bg = root:getChildByName("Sprite_checkpoint_state_attack_bg")
    Sprite_checkpoint_state_bg:setVisible(true)
    display:gray(Sprite_checkpoint_state_bg)
    display:gray(Sprite_chapter_pic)
    if Sprite_checkpoint_state_attack_bg ~= nil then
        Sprite_checkpoint_state_attack_bg:setVisible(false)
    end
    local Text_chapter_open_n_0 = ccui.Helper:seekWidgetByName(root, "Text_chapter_open_n_0")
    local Text_chapter_open_n_1 = ccui.Helper:seekWidgetByName(root, "Text_chapter_open_n_1")
    Text_chapter_open_n_0:setVisible(false)
    Text_chapter_open_n_1:setVisible(false)
    if tonumber(self._state) < 0 then
        -- Panel_chapter_pic:setTouchEnabled(false)
        -- Panel_chapter_pic:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
        local scene_name = dms.string(dms["pve_scene"], self._scene_id - 1, pve_scene.scene_name)
        Text_chapter_open_n:setString(string.format(red_alert_time_str[25],scene_name))
        Text_checkpoint_state_n:setString(red_alert_time_str[22])
		local scene_open_lv = dms.int(dms["pve_scene"], self._scene_id, pve_scene.open_level)
		if tonumber(_ED.user_info.user_grade) >= scene_open_lv then
			Text_chapter_open_n_0:setVisible(false)
			Text_chapter_open_n_1:setVisible(false)
		else
			Text_chapter_open_n_0:setVisible(true)
			Text_chapter_open_n_1:setVisible(true)
			Text_chapter_open_n_1:setString(scene_open_lv)
			-- 显示需要等级
		end
		local by_open_scene = dms.int(dms["pve_scene"], self._scene_id, pve_scene.by_open_scene)
		local by_open = dms.string(dms["pve_scene"], by_open_scene, pve_scene.npcs)
		local by_info = zstring.split(by_open, ",")
		if by_open_scene > 0 and _ED.scene_current_state[by_open_scene] == #by_info then
			Text_chapter_open_n:setVisible(false)
		else
			Text_chapter_open_n:setVisible(true)
		end
		
    elseif tonumber(self._state) < #npcs then
        Text_checkpoint_state_n:setString(red_alert_time_str[23])
		display:ungray(Sprite_checkpoint_state_bg)
		display:ungray(Sprite_chapter_pic)
        if Sprite_checkpoint_state_attack_bg ~= nil then
            Sprite_checkpoint_state_bg:setVisible(false)
            Sprite_checkpoint_state_attack_bg:setVisible(true)
        end
    else
        Text_checkpoint_state_n:setString(red_alert_time_str[24])
		display:ungray(Sprite_checkpoint_state_bg)
		display:ungray(Sprite_chapter_pic)
    end

    if tonumber(self._state) >= 0 then
        local free_repair_info = zstring.split(dms.string(dms["fight_config"], 37, fight_config.attribute), "|")
        for k, v in pairs(free_repair_info) do
            local info = zstring.split(v, ",")
            if self._scene_id == tonumber(info[1]) then
                Text_chapter_open_n:setVisible(true)
                Text_chapter_open_n:setString(string.format(red_alert_time_str[302], tonumber(info[3]) * 100))
                break
            end
        end
    end
end

function PveChapterCell:onEnterTransitionFinish()

end

function PveChapterCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.pve.pve_chapter_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PveChapterCell.__size == nil then
		PveChapterCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic"), nil, 
    {
        terminal_name = "pve_chapter_cell_choose",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function PveChapterCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.pve.pve_chapter_cell, self.roots[1])
end

function PveChapterCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PveChapterCell:clearUIInfo()
    local root = self.roots[1]
    if root ~= nil then
        local Text_chapter_star_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_star_n")
        local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
        local Text_chapter_open_n = ccui.Helper:seekWidgetByName(root, "Text_chapter_open_n")
        local Text_checkpoint_state_n = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_state_n")
        local Panel_chapter_pic = ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic")
        local Sprite_chapter_pic = root:getChildByName("Panel_chapter_pic"):getChildByName("Sprite_chapter_pic")
        local Sprite_checkpoint_state_bg = root:getChildByName("Sprite_checkpoint_state_bg")
        local Text_chapter_open_n_0 = ccui.Helper:seekWidgetByName(root, "Text_chapter_open_n_0")
        local Text_chapter_open_n_1 = ccui.Helper:seekWidgetByName(root, "Text_chapter_open_n_1")

        if Text_chapter_star_n ~= nil then
            Text_chapter_star_n:removeAllChildren(true)
            Text_chapter_name:setString("")
            Text_chapter_open_n:setString("")
            Text_checkpoint_state_n:setString("")
            Panel_chapter_pic:setTouchEnabled(true)
            Panel_chapter_pic:removeBackGroundImage()
            display:gray(Sprite_checkpoint_state_bg)
            display:gray(Sprite_chapter_pic)
            Text_chapter_open_n_0:setVisible(false)
            Text_chapter_open_n_1:setVisible(false)
        end
    end
end

function PveChapterCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.pve.pve_chapter_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PveChapterCell:init(params)
    self._index = params[1]
    self._scene_id = params[2]
    self._state = params[3]
    if self._index <= 6 then
	   self:onInit()
    end
	self:setContentSize(PveChapterCell.__size)
end

