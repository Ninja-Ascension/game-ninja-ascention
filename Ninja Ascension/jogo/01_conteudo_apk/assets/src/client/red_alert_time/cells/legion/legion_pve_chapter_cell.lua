----------------------------------------------------------------------------------------------------
-- 说明：军团副本章节cell
-------------------------------------------------------------------------------------------------------
LegionPveChapterCell = class("LegionPveChapterCellClass", Window)
LegionPveChapterCell.__size = nil

local legion_pve_chapter_create_cell_terminal = {
    _name = "legion_pve_chapter_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionPveChapterCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_pve_chapter_create_cell_terminal)
state_machine.init()

function LegionPveChapterCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    -- 章节ID
    self._scene_id = 0
    -- 章节开启状态
    self._state = 0

    app.load("client.red_alert_time.pve.PveMap")
    app.load("client.red_alert_time.cells.pve.pve_npc_cell")
    local function init_legion_pve_chapter_cell_terminal()
        local legion_pve_chapter_cell_choose_terminal = {
            _name = "legion_pve_chapter_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("pve_map_open", 0, {cell._scene_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(legion_pve_chapter_cell_choose_terminal)
        state_machine.init()
    end
    init_legion_pve_chapter_cell_terminal()            
end

function LegionPveChapterCell:onUpdateDraw()
    local root = self.roots[1]
    local pve_scene_mould = dms.element(dms["pve_scene"], self._scene_id)
    -- 底图
    local Panel_chapter_pic = ccui.Helper:seekWidgetByName(root, "Panel_chapter_pic")
    Panel_chapter_pic:removeBackGroundImage()
    local pic = dms.atoi(pve_scene_mould, pve_scene.scene_entry_pic)
    Panel_chapter_pic:setBackGroundImage(string.format(config_res.images.ui.pve.pve_chapter_pic, pic))
    Panel_chapter_pic:setTouchEnabled(true)
    Panel_chapter_pic:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    -- 章节名
    local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
    local name = dms.atos(pve_scene_mould, pve_scene.scene_name)
    Text_chapter_name:setString(name)

    for i=1,5 do
        local Image_chapter_star = ccui.Helper:seekWidgetByName(root, "Image_chapter_star_"..i)
        Image_chapter_star:setVisible(false)
        if i <= self._index then
            Image_chapter_star:setVisible(true)
        end
    end
    local Image_locked = ccui.Helper:seekWidgetByName(root, "Image_locked")
    Image_locked:setVisible(false)

    local Text_clear_n = ccui.Helper:seekWidgetByName(root, "Text_clear_n")
    local Text_reward_n = ccui.Helper:seekWidgetByName(root, "Text_reward_n")
    local npcs = zstring.split(dms.string(dms["pve_scene"], tonumber(self._scene_id), pve_scene.npcs), ",")
    local scene_id = dms.int(dms["pve_scene"], self._scene_id, pve_scene.scene_id) 
    local npc_max = 0
    for i=1,scene_id do
        npc_max = npc_max + #npcs[i]
    end
    local npc_min = npc_max - #npcs[scene_id] + 1
    local is_lock = true
    local beat_level = 0
    local have_receive = 0
    local is_receive = zstring.split(_ED.union_pve_is_receive[scene_id], ",")
    for i = 1,#npcs do
        local scene_npc_state  = _ED.union_pve_info[""..scene_id][""..i].npc_state
        local scene_is_receive = tonumber(is_receive[i])
        if scene_npc_state >= 0 then
            is_lock = false
        end   
        if scene_npc_state == 1 then
            beat_level = beat_level + 1
            if scene_is_receive == 0 then
                have_receive = have_receive + 1
            end
        end
    end
    if is_lock == true then
        Image_locked:setVisible(true)
        Panel_chapter_pic:setTouchEnabled(false)
        Panel_chapter_pic:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
    end
    Text_clear_n:setString(beat_level.."/".. #npcs)
    Text_reward_n:setString(have_receive.."/".. beat_level)   

    local Panel_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_reward_box")
    Panel_reward_box:removeAllChildren(true)
    if have_receive > 0 then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)
        local armature = ccs.Armature:create("effect_box_get")
        armature:getAnimation():playWithIndex(0)
        armature:setPosition(cc.p(Panel_reward_box:getContentSize().width/2,Panel_reward_box:getContentSize().height/2))
        Panel_reward_box:addChild(armature)
    end

end

function LegionPveChapterCell:onEnterTransitionFinish()

end

function LegionPveChapterCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_pve_chapter_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionPveChapterCell.__size == nil then
        LegionPveChapterCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic"), nil, 
    {
        terminal_name = "legion_pve_chapter_cell_choose",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function LegionPveChapterCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_pve_chapter_cell, self.roots[1])
end

function LegionPveChapterCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionPveChapterCell:clearUIInfo()
    local root = self.roots[1]
    local Text_chapter_name = ccui.Helper:seekWidgetByName(root, "Text_chapter_name")
    local Panel_chapter_pic = ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic")
    local Text_clear_n = ccui.Helper:seekWidgetByName(root, "Text_clear_n")
    local Text_reward_n = ccui.Helper:seekWidgetByName(root, "Text_reward_n")
    if Text_chapter_name ~= nil then
        Text_chapter_name:setString("")
        Panel_chapter_pic:setTouchEnabled(true)
        Panel_chapter_pic:removeBackGroundImage()
        Text_clear_n:setString("")
        Text_reward_n:setString("")
    end
    for i=1,5 do
        local Image_chapter_star = ccui.Helper:seekWidgetByName(root, "Image_chapter_star_"..i)
        if Image_chapter_star ~= nil then
            Image_chapter_star:setVisible(false)
        end
    end
end

function LegionPveChapterCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_pve_chapter_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionPveChapterCell:init(params)
    self._index = params[1]
    self._scene_id = params[2]
    self._state = params[3]
    if self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(LegionPveChapterCell.__size)
end

