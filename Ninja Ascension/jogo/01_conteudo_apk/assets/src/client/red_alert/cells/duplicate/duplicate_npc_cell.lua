--------------------------------------------------------------------------------------------------------------
--  说明：地图单个npc形象控件
--------------------------------------------------------------------------------------------------------------
DuplicateNpcCell = class("DuplicateNpcCellClass", Window)

--创建cell
local duplicate_npc_create_cell_terminal = {
    _name = "duplicate_npc_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local npc_id = params[1]
        local scene_id = params[2]
        local boss_flag = params[3]
        local npc_state = params[4]   
        local index = params[5]  
        local cell = DuplicateNpcCell:new()
        cell:init(npc_id, scene_id , boss_flag , npc_state ,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_npc_create_cell_terminal)
state_machine.init()

function DuplicateNpcCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.npc_id = nil
    self.scene_id = nil
    self.boss_flag = nil
    self.npc_state = nil
    --npc 顺序
    self._index = nil
	 -- Initialize duplicate_npc_cell state machine.
    local function init_duplicate_npc_cell_terminal()
		
        -- npc 点击打开npc界面
        local duplicate_npc_cell_open_window_terminal = {
            _name = "duplicate_npc_cell_open_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell

                -- print("====点击的npc======",cell.npc_id ,
                -- cell.scene_id,
                -- cell.boss_flag,
                -- cell.npc_state )
                if cell.npc_state == nil then
                    -- print("========npc未开启")
                    return
                end
                -- 七星台npc通关成功之后取消点击响应
                if cell._scene_type == battle_enum._fight_type._fight_type_104 then
                    local scene_state = tonumber(_ED.scene_current_state[cell.scene_id])
                    if cell._index <= scene_state then
                        return
                    end
                end
                state_machine.excute("duplicate_npc_window_open",0,
                    {
                        _datas = {
                            npc_id = cell.npc_id,
                            scene_id = cell.scene_id,
                            boss_flag = cell.boss_flag,
                            npc_state = cell.npc_state,
                            index = cell._index
                        } 
                    })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
    
        state_machine.add(duplicate_npc_cell_open_window_terminal)
        state_machine.init()
    end
    
    -- call func duplicate_npc_cell create state machine.
    init_duplicate_npc_cell_terminal()

end

function DuplicateNpcCell:updateDraw()
    local root = self.roots[1]
    local Text_npc_name = ccui.Helper:seekWidgetByName(root,"Text_npc_name")    -- npc名字
    local Panel_npc_infor = ccui.Helper:seekWidgetByName(root,"Panel_npc_infor")-- npc通关星级
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")  -- 选中当前npc箭头
    local Panel_npc_now = ccui.Helper:seekWidgetByName(root,"Panel_npc_now")    -- 选中当前npc底部动画
    local Image_clear = ccui.Helper:seekWidgetByName(root,"Image_clear")        -- 已击败
    local npc_name = dms.string(dms["npc"],self.npc_id,npc.npc_name)
    Text_npc_name:setString(npc_name)
    Image_clear:setVisible(false)
    if self.boss_flag == false then
        self:setVisible(false)
    else
        self:setVisible(true)
    end
    if self.npc_state == 1 then
    --添加箭头动画
        -- Text_npc_name:setVisible(false)
        -- Panel_npc_infor:setVisible(true)
        -- self:addCurrentLevel(Panel_npc_role)
        self:setVisible(true)
        Panel_npc_now:setVisible(true)
        Text_npc_name:setVisible(true)
        Panel_npc_infor:setVisible(true)
    elseif self.npc_state == nil then
        Panel_npc_now:setVisible(false)
        Panel_npc_infor:setVisible(false)
        Text_npc_name:setVisible(true)
    else 
        Panel_npc_now:setVisible(false)
        Text_npc_name:setVisible(true)
        Panel_npc_infor:setVisible(true)
    end

    local star = 0
    if zstring.tonumber(_ED.npc_state[tonumber(""..self.npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npc_id)]) ~= 0 then
        star = tonumber(_ED.npc_max_state[tonumber(""..self.npc_id)])
    else
        star = tonumber(_ED.npc_state[tonumber(""..self.npc_id)])
    end
                    
    for i = 1 , star do
        local Image_npc_star = ccui.Helper:seekWidgetByName(root,"Image_npc_star_"..i)
        Image_npc_star:setVisible(true)
    end
    -- 七星台npc隐藏通关星级显示
    if self._scene_type == battle_enum._fight_type._fight_type_104 then
        Panel_npc_infor:setVisible(false)
        if self.npc_state == 1 then
            Text_npc_name:setVisible(true)
        elseif self.npc_state == nil then
            Text_npc_name:setVisible(false)
        else 
            Text_npc_name:setVisible(false)
        end
        if self._index <= tonumber(_ED.scene_current_state[self.scene_id]) then
            Image_clear:setVisible(true)
        end
    end
end

function DuplicateNpcCell:addCurrentLevel(panle)
    local root = self.roots[1]
    if config_res._sync_draw_open ~= nil and config_res._sync_draw_open ~= "" and config_res._sync_draw_open == true then
    else
        self.actions[1]:play("pve_npc_in", false)
    end
    -- if missionIsOver() == false then
    --     return
    -- end
    local cell = state_machine.excute("duplicate_current_level_create_cell",0,"")
    local pos_y = cell:getPositionY()
    local height = panle:getContentSize().height
    cell:setPositionY(pos_y + height)
    panle:addChild(cell)
    -- for i = 1,3 do
        -- local Image_star_bg = ccui.Helper:seekWidgetByName(root,"Image_star_bg_"..i)
        -- Image_star_bg:setVisible(false)
    -- end 
    if missionIsOver() == false then
        cell:setVisible(false)
    else
        cell:setVisible(true)
    end


    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    Panel_npc_role.show_cut_cell = cell
end

function DuplicateNpcCell:showCurrentLevelSign()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    if Panel_npc_role.show_cut_cell ~= nil then
        Panel_npc_role.show_cut_cell:setVisible(true)
    end
end

function DuplicateNpcCell:removeShortCutNpc()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    if Panel_npc_role.show_cut_cell ~= nil then
        Panel_npc_role.show_cut_cell:removeFromParent(true)
        Panel_npc_role.show_cut_cell = nil
    end
end

function DuplicateNpcCell:showShortCutNpc()
    local root = self.roots[1]
    if config_res._sync_draw_open ~= nil and config_res._sync_draw_open ~= "" and config_res._sync_draw_open == true then
    else
        self.actions[1]:play("pve_npc_in", false)
    end

    -- if missionIsOver() == false then
    --     return
    -- end

    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    local cell = state_machine.excute("duplicate_current_level_create_cell",0,"")
    local pos_y = cell:getPositionY()
    local height = Panel_npc_role:getContentSize().height
    cell:setPositionY(pos_y + height)

    if missionIsOver() == false then
        cell:setVisible(false)
    else
        cell:setVisible(true)
    end

    Panel_npc_role:addChild(cell)
    Panel_npc_role.show_cut_cell = cell

    state_machine.excute("duplicate_npc_cell_open_window", 0, {_datas = {cell = self}})
end

function DuplicateNpcCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.duplicate.duplicate_npc_cell, "root")
    -- local root = csbItem:getChildByName("root")
    -- root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    if config_res._sync_draw_open ~= nil and config_res._sync_draw_open ~= "" and config_res._sync_draw_open == true then
    else
        local action = csb.createTimeline(config_csb.cells.duplicate.duplicate_npc_cell)
        table.insert(self.actions, action)
        root:runAction(action)
        action:play("pve_npc_in_0", false)
    end

    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    Panel_npc_role.show_cut_cell = nil
    Panel_npc_role.armature = nil
    Panel_npc_role:removeAllChildren(true)

    self:addNpcTouchEvent()
	self:updateDraw()
end

--创建npc形象
function DuplicateNpcCell:createNpcAnimation(npc_id,short_cut_npc_id, armatures)
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    if Panel_npc_role.armature ~= nil then
        return
    end

    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["npc"], self.npc_id, npc.head_pic)
    -- 七星台npc绘制
    if self._scene_type == battle_enum._fight_type._fight_type_104 then
        for i = 1, dms.count( dms["seven_units_param"] ) do 
            if tonumber(self.scene_id) == dms.int(dms["seven_units_param"],i,seven_units_param.scene_id)
            and tonumber(_ED.user_info.user_grade) >= dms.int(dms["seven_units_param"],i,seven_units_param.start_level)
            and tonumber(_ED.user_info.user_grade) <= dms.int(dms["seven_units_param"],i,seven_units_param.end_level)
            then
                local image_id = zstring.split(dms.string(dms["seven_units_param"], i, seven_units_param.image_id), ",")
                temp_bust_index = image_id[self._index] + 10000
            end
        end
    else
        temp_bust_index = 10000 + temp_bust_index
        if self.npc_state ~= 1 and dms.int(dms["npc"],npc_id,npc.npc_type) == 0 then
            -- print("==========return")
            local armature = armatures[temp_bust_index]
            if nil ~= armature then
                armature:release()
                armatures[temp_bust_index] = nil
            end
            return
        end
    end
    -- print("==========1=======",os.clock())
    local armature = sp.spine_sprite(Panel_npc_role, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_11+1], true, nil, nil, cc.p(0.5, 0))
    if nil == armatures[temp_bust_index] then
        armatures[temp_bust_index] = armature
        armature:retain()
    else
        armature:setAnimation(0, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_11 + 1], true)
    end
    armature:setPosition(cc.p(Panel_npc_role:getContentSize().width/2, 0))
    -- print("==========2=======",os.clock())
    Panel_npc_role.armature = armature
    if short_cut_npc_id ~= nil then
    else
        if self.npc_state == 1 then
            self:addCurrentLevel(Panel_npc_role)
        end
    end
    return temp_bust_index, armature
end

--添加npc点击事件
function DuplicateNpcCell:addNpcTouchEvent()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    fwin:addTouchEventListener(Panel_npc_role, nil, 
    {
        terminal_name = "duplicate_npc_cell_open_window", 
        terminal_state = 0,
        cell = self,
    }, nil, 0)

end

function DuplicateNpcCell:onEnterTransitionFinish()

end

function DuplicateNpcCell:init(npc_id , scene_id ,  boss_flag , npc_state,index)
    self.npc_id = npc_id
    self.scene_id = scene_id
    self.boss_flag = boss_flag
    self.npc_state = npc_state
    self._index = index
    self._scene_type = dms.int(dms["pve_scene"],self.scene_id,pve_scene.scene_type)
	self:onInit()
end

function DuplicateNpcCell:onExit()
    local root = self.roots[1]
    local Panel_npc_role = ccui.Helper:seekWidgetByName(root,"Panel_npc_role")
    if Panel_npc_role ~= nil then
        Panel_npc_role.show_cut_cell = nil
        Panel_npc_role.armature = nil
        Panel_npc_role:removeAllChildren(true)
    end
    for i = 1, 3 do
        local Image_npc_star = ccui.Helper:seekWidgetByName(root,"Image_npc_star_"..i)
        Image_npc_star:setVisible(false)
    end
    cacher.freeRef(config_csb.cells.duplicate.duplicate_npc_cell, root)
end