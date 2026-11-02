-- ---------------------------
-- 配件补给扫荡奖励
-- ---------------------------
PvePartsSupplySweepCell = class("PvePartsSupplySweepCellClass", Window)
PvePartsSupplySweepCell.__size = nil

local pve_parts_supply_sweep_create_cell_terminal = {
    _name = "pve_parts_supply_sweep_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local reward_data = params[1]
        local scene_name = params[2]
        local index = params[3]
        local cell = PvePartsSupplySweepCell:new()
        cell:init(reward_data,scene_name,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_parts_supply_sweep_create_cell_terminal)
state_machine.init()

function PvePartsSupplySweepCell:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --奖励信息
    self.reward_data = nil
    --当前层名
    self._scene_name = nil
    self._is_init = true

    local function init_pve_parts_supply_sweep_cell_terminal()
        local pve_parts_supply_sweep_cell_animation_play_terminal = {
            _name = "pve_parts_supply_sweep_cell_animation_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:animationCellPlay()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(pve_parts_supply_sweep_cell_animation_play_terminal)
        state_machine.init()
    end
    
    -- call func equipment_parts_tab create state machine.
    init_pve_parts_supply_sweep_cell_terminal()
end


function PvePartsSupplySweepCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_sweep_number = ccui.Helper:seekWidgetByName(root, "Text_sweep_number")
    Text_sweep_number:setString(self._scene_name)

    local Text_sweep_p = ccui.Helper:seekWidgetByName(root, "Text_sweep_p")
    Text_sweep_p:setVisible(false)
    if self.reward_data == nil then
        Text_sweep_p:setVisible(true)
    else
        local index = 1
        for k,v in pairs(self.reward_data) do
            local Panel_sweep_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_sweep_reward_icon_"..index)
            if Panel_sweep_reward_icon ~= nil then
                Panel_sweep_reward_icon:removeAllChildren(true)
                if tonumber(v.prop_type) ~= 44 then
                    local prop_id = tonumber(v.prop_item)
                    local prop_type = 1
                    if tonumber(prop_id) == -1 then
                        prop_id = resource_prop_id[tonumber(v.prop_type)]
                        prop_type = 1
                    end
                    local show_type = 6
                    local prop_from_type = 3
                    if tonumber(v.prop_type) == 13 then --坦克
                        prop_type = 3
                        prop_from_type = 10
                    elseif tonumber(v.prop_type) == 6 then --道具 
                        prop_type = 1
                        prop_from_type = 1
                    elseif tonumber(v.prop_type) == 7 then --配件 
                        prop_type = 7
                        prop_from_type = 14
                    else
                        prop_type = 1
                        prop_from_type = 1
                    end
                    local cell = nil
                    if prop_type == 7 then
                        cell = state_machine.excute("props_icon_create_cell",0,{8, prop_from_type, prop_id, 15, nil, true})
                    else
                        cell = state_machine.excute("props_icon_create_cell", 0, {show_type, prop_from_type, prop_id, prop_type, v.item_value})
                        ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
                        ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
                    end
                    Panel_sweep_reward_icon:addChild(cell)
                    if self._is_init == true then
                        Panel_sweep_reward_icon:setVisible(false)
                    end
                    index = index + 1
                end
            end
        end
    end
    if self._is_init == true then
        self:setVisible(false)
        state_machine.excute("pve_parts_supply_sweep_update_zidi", 0, 0)
    end
    self._is_init = false
end

function PvePartsSupplySweepCell:animationCellPlay()
    local root = self.roots[1]
    self:setVisible(true)
    if self.reward_data ~= nil then
        local index = 1
        local function callback()
            local Panel_sweep_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_sweep_reward_icon_"..index) 
            if Panel_sweep_reward_icon ~= nil then
                index = index + 1
                Panel_sweep_reward_icon:setVisible(true)

                local armature = ccs.Armature:create("effice_recruit_get_light")
                draw.initArmature(armature, nil, -1, 0, 1)
                armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                armature:setPosition(cc.p(Panel_sweep_reward_icon:getContentSize().width/2, Panel_sweep_reward_icon:getContentSize().height/2))
                armature:getAnimation():playWithIndex(0)
                Panel_sweep_reward_icon:addChild(armature)

                self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(callback)))
            else
                state_machine.excute("pve_parts_supply_sweep_next_reward", 0, "")
            end
        end

        callback()
    end
end

function PvePartsSupplySweepCell:onEnterTransitionFinish()

end

function PvePartsSupplySweepCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.pve.pve_parts_supply_sweep_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)

    if PvePartsSupplySweepCell.__size == nil then
        PvePartsSupplySweepCell.__size = root:getContentSize()
    end

	self:onUpdateDraw()	
end


function PvePartsSupplySweepCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PvePartsSupplySweepCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.pve.pve_parts_supply_sweep_cell)
    root:removeFromParent(false)
    self.roots = {}
end

function PvePartsSupplySweepCell:clearUIInfo()
    local root = self.roots[1]
    local Text_sweep_number = ccui.Helper:seekWidgetByName(root, "Text_sweep_number")
    local Panel_sweep_reward_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_sweep_reward_icon_1")
    local Panel_sweep_reward_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_sweep_reward_icon_2")

    if Text_sweep_number ~= nil then
        Panel_sweep_reward_icon_1:removeAllChildren(true)
        Panel_sweep_reward_icon_2:removeAllChildren(true)
        Panel_sweep_reward_icon_1:setVisible(true)
        Panel_sweep_reward_icon_2:setVisible(true)
        Text_sweep_number:setString("")
    end
end

function PvePartsSupplySweepCell:init(reward_data,scene_name,index)
    self.reward_data = reward_data
    self._scene_name = scene_name
    if index ~= nil and index < 6 then
	   self:onInit()
    end
    self:setContentSize(PvePartsSupplySweepCell.__size)

    return self
end

function PvePartsSupplySweepCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.pve.pve_parts_supply_sweep_cell,self.roots[1])
end
