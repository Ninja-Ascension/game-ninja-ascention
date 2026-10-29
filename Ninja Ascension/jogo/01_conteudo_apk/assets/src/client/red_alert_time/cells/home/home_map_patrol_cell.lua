------------------------------------
-- 主页面巡逻兵动画
------------------------------------
HomeMapPatrolCell = class("HomeMapPatrolCellClass", Window)

local home_map_patrol_cell_create_terminal = {
    _name = "home_map_patrol_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HomeMapPatrolCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(home_map_patrol_cell_create_terminal)
state_machine.init()

function HomeMapPatrolCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._index = 0
    self._armature = nil

    self._isCanGetReward = false
    self._animation_index = 0

    self._tick_time = 0
    self._next_time = 0
    self._show_time = 0
    self._state = 0         -- 0：隐藏对话框，1：显示对话框，-1：从不显示对话框

    self._text_posy = nil
    self._text_size = nil
    self._image_posy = nil
    self._image_size = nil

    local function init_home_map_patrol_cell_terminal()
        local home_map_patrol_cell_click_terminal = {
            _name = "home_map_patrol_cell_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._isCanGetReward == true then
                    local function respondCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node._isCanGetReward = false
                                response.node:playAnimation(response.node._animation_index)
                            end
                            state_machine.excute("home_map_update_patrol_reward_state", 0, nil)
                            checkRewardObtainDraw()
                            state_machine.excute("main_window_update_userinfo", 0, nil)
                        end
                    end
                    NetworkManager:register(protocol_command.build_patrol_draw.code, nil, nil, nil, cell, respondCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_patrol_cell_play_animation_terminal = {
            _name = "home_map_patrol_cell_play_animation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local index = params[2]
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:playAnimation(index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_map_patrol_cell_click_terminal)
        state_machine.add(home_map_patrol_cell_play_animation_terminal)
        state_machine.init()
    end

    init_home_map_patrol_cell_terminal()
end

function HomeMapPatrolCell:playAnimation(index)
    if __lua_project_id == __lua_project_pacific_rim then
        self:playAnimationEX(index)
        return
    end
    self._animation_index = index
    if self._isCanGetReward == true then
        index = index + 4 
    end
    self._armature:getAnimation():play("Animation"..index)
end

function HomeMapPatrolCell:playAnimationEX( index )
    self._animation_index = index
    if self._isCanGetReward == true then
        index = index + 8
    end
    self._armature:getAnimation():playWithIndex(index)
end

function HomeMapPatrolCell:showTips()
    local root = self.roots[1]
    local Image_patrol_bubble = ccui.Helper:seekWidgetByName(root, "Image_patrol_bubble")
    local Text_patrol_bubble_infor = ccui.Helper:seekWidgetByName(root, "Text_patrol_bubble_infor")

    if self._state <= 0 then
        Image_patrol_bubble:setVisible(false)
        Text_patrol_bubble_infor:setVisible(false)
    else
        Image_patrol_bubble:setVisible(true)
        Text_patrol_bubble_infor:setVisible(true)

        local tip_index = math.random(1, #build_patrol)
        local info = build_patrol[tip_index][1]
        Text_patrol_bubble_infor:setString(info)

        local line_count = build_patrol[tip_index][2]
        local add_height = (line_count - 2) * 20

        Text_patrol_bubble_infor:setAnchorPoint(cc.p(0, 0.5))
        Image_patrol_bubble:setContentSize(self._image_size.width, self._image_size.height + add_height)
        Image_patrol_bubble:setPositionY(self._image_posy + add_height)
        Text_patrol_bubble_infor:setContentSize(self._text_size.width, self._text_size.height + add_height)
        Text_patrol_bubble_infor:setPositionY(Image_patrol_bubble:getPositionY())
    end
end

function HomeMapPatrolCell:updateDraw()
    local root = self.roots[1]
    local Panel_patrol_effect = ccui.Helper:seekWidgetByName(root, "Panel_patrol_effect")
    Panel_patrol_effect:removeAllChildren(true)

    if __lua_project_id == __lua_project_pacific_rim then
        local baseName_1 = config_res.effect.Panel_home_map
        self._armature = sp.spine(baseName_1..".json", baseName_1..".atlas", 1, 0, nil, false, nil)
        sp.initArmature(self._armature, true)
        self._armature.animationNameList = {}
        for i=1,20 do
            table.insert(self._armature.animationNameList, "animation"..i)
        end
        Panel_patrol_effect:addChild(self._armature)
        self._armature:setPosition(Panel_patrol_effect:getContentSize().width / 2, Panel_patrol_effect:getContentSize().height / 2)
        self:playAnimation(1)
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.sprite.spirte_patrol)
        self._armature = ccs.Armature:create("spirte_patrol")
        Panel_patrol_effect:addChild(self._armature)
        self._armature:setPosition(Panel_patrol_effect:getContentSize().width / 2, Panel_patrol_effect:getContentSize().height / 2)
        self:playAnimation(1)
    end

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setContentSize(Panel_patrol_effect:getContentSize())

    if self._state < 0 then
        Panel_patrol_effect:setTouchEnabled(false)
    end

    self:showTips()
end

function HomeMapPatrolCell:onUpdate(dt)
    if self.roots == nil or self.roots[1] == nil then
        return
    end

    self._tick_time = self._tick_time + dt
    if self._state == 0 and self._tick_time >= self._next_time then
        self._tick_time = 0
        self._state = 1
        self:showTips()
    elseif self._state == 1 and self._tick_time >= self._show_time then
        self._tick_time = 0
        self._state = 0
        self:showTips()
    end
end

function HomeMapPatrolCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.home.home_map_patrol_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local time_info = zstring.split(dms.string(dms["build_patrol_config"], 5, build_patrol_config.param), ",")
    self._next_time = tonumber(time_info[1])
    self._show_time = tonumber(time_info[2])
    self._tick_time = math.random(0, self._next_time)

    local Image_patrol_bubble = ccui.Helper:seekWidgetByName(root, "Image_patrol_bubble")
    local Text_patrol_bubble_infor = ccui.Helper:seekWidgetByName(root, "Text_patrol_bubble_infor")
    self._text_size = Text_patrol_bubble_infor:getContentSize()
    self._text_posy = Text_patrol_bubble_infor:getPositionY()
    self._image_size = Image_patrol_bubble:getContentSize()
    self._image_posy = Image_patrol_bubble:getPositionY()
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_patrol_effect"), nil, 
    {
        terminal_name = "home_map_patrol_cell_click",
        terminal_state = 0,
        cell = self,
    },
    nil,1)

    self:updateDraw()
end

function HomeMapPatrolCell:onEnterTransitionFinish()
end

function HomeMapPatrolCell:init(params)
    self._index = params[1]
    self._state = params[2]
    
    self:onInit()
end

function HomeMapPatrolCell:onExit()

end