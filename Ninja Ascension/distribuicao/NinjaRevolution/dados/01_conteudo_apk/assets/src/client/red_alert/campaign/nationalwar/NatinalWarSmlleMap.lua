-----------------------------
--小地图
-----------------------------
NatinalWarSmlleMap = class("NatinalWarSmlleMapClass", Window)

local natinal_war_smlle_map_window_open_terminal = {
    _name = "natinal_war_smlle_map_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NatinalWarSmlleMapClass") == nil then
            fwin:open(NatinalWarSmlleMap:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(natinal_war_smlle_map_window_open_terminal)
state_machine.init()

function NatinalWarSmlleMap:ctor()
    self.super:ctor()
    self.roots = {}
    self.now_persent_x = nil
    self.now_persent_y = nil

    self._my_resource_effect = nil
    -- Initialize natinal_war_smllemap machine.
    local function init_natinal_war_smllemap_terminal()

        -- 改变坐标 小框
        local natinal_war_smllemap_change_pos_terminal = {
            _name = "natinal_war_smllemap_change_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local now_persent_x = params[1]
                local now_persent_y = params[2]
                instance:changePos(now_persent_x,now_persent_y)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 状态
        local natinal_war_smllemap_update_state_terminal = {
            _name = "natinal_war_smllemap_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 号令
        local natinal_war_smllemap_update_decree_terminal = {
            _name = "natinal_war_smllemap_update_decree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawDecree()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 坐标
        local natinal_war_smllemap_update_pos_terminal = {
            _name = "natinal_war_smllemap_update_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawPos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 更新小地图资源品质显示
        local natinal_war_smllemap_update_draw_resource_quality_terminal = {
            _name = "natinal_war_smllemap_update_draw_resource_quality",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawResourceQuality(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 更新小地图自己所在的位置显示
        local natinal_war_smllemap_update_draw_myself_city_terminal = {
            _name = "natinal_war_smllemap_update_draw_myself_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawMySelfCity(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local natinal_war_smllemap_add_my_resource_effect_terminal = {
            _name = "natinal_war_smllemap_add_my_resource_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addMyResourceEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local natinal_war_smllemap_update_raiderscut_info_terminal = {
            _name = "natinal_war_smllemap_update_raiderscut_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateRaiderscutInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(natinal_war_smllemap_change_pos_terminal)    
        state_machine.add(natinal_war_smllemap_update_state_terminal)
        state_machine.add(natinal_war_smllemap_update_decree_terminal)
        state_machine.add(natinal_war_smllemap_update_pos_terminal)
        state_machine.add(natinal_war_smllemap_update_draw_resource_quality_terminal)
        state_machine.add(natinal_war_smllemap_update_draw_myself_city_terminal)
        state_machine.add(natinal_war_smllemap_add_my_resource_effect_terminal)
        state_machine.add(natinal_war_smllemap_update_raiderscut_info_terminal)
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_natinal_war_smllemap_terminal()
end

function NatinalWarSmlleMap:updateRaiderscutInfo( ... )
    local Panel_raiderscut = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_raiderscut")
    Panel_raiderscut:setVisible(true)
    for i=1,10 do
        local Image_raiderscut = ccui.Helper:seekWidgetByName(self.roots[1],"Image_raiderscut_"..i)
        Image_raiderscut:setVisible(false)
    end
    if _ED.raiders_user_info ~= nil then
        for k,v in pairs(_ED.raiders_user_info) do
            local Image_raiderscut = ccui.Helper:seekWidgetByName(self.roots[1],"Image_raiderscut_"..v.pos_index)
            Image_raiderscut:setVisible(true)
        end
    end
end

function NatinalWarSmlleMap:addMyResourceEffect( ... )
    if self._my_resource_effect ~= nil then
        self._my_resource_effect:removeFromParent(true)
        self._my_resource_effect = nil
    end
    if _ED.city_resource_user_info ~= nil and tonumber(_ED.city_resource_user_info.my_city_id) > 0 then
        local Panel_build_pos = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_build_pos")
        local Panel_ani = Panel_build_pos:getChildByName("Panel_build_s_".._ED.city_resource_user_info.my_city_id)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_map_judian/effice_map_judian.ExportJson")
        self._my_resource_effect = ccs.Armature:create("effice_map_judian")
        self._my_resource_effect:getAnimation():playWithIndex(0)
        self._my_resource_effect:setPosition(cc.p(Panel_ani:getContentSize().width/2, Panel_ani:getContentSize().height/2))
        Panel_ani:addChild(self._my_resource_effect)
    end
end

function NatinalWarSmlleMap:changePos(now_persent_x,now_persent_y) 
    if self.now_persent_x == now_persent_x and self.now_persent_y == now_persent_y then
        return
    end  
    -- print("===========================移动")
    self.now_persent_x = now_persent_x
    self.now_persent_y = now_persent_y
    local x = now_persent_x*(self.panel_par_size.width - self.move_panel:getContentSize().width ) 
    local y = now_persent_y*(self.panel_par_size.height - self.move_panel:getContentSize().height ) 
    -- print("==============",x,y,now_persent_x,now_persent_y)

    self.move_panel:setPosition(cc.p(x,y))

    self.move_panel.posx = self.move_panel:getPositionX()
    self.move_panel.posy = self.move_panel:getPositionY()   
end

function NatinalWarSmlleMap:onUpdateDraw()
    local root = self.roots[1]
    local Panel_build_ani = ccui.Helper:seekWidgetByName(root,"Panel_build_ani")
    local Panel_build_fight = ccui.Helper:seekWidgetByName(root,"Panel_build_fight")
    local Panel_build_pos = ccui.Helper:seekWidgetByName(root,"Panel_build_pos")    
    for i,v in ipairs(_ED.warfareCityInfo) do
        local state = v.state
        local camp = tonumber(v.camp)
        local city_id = tonumber(v.city_id)
        local Panel_ani = Panel_build_ani:getChildByName("Panel_build_s_"..i)
        local Panel_fight = Panel_build_fight:getChildByName("Panel_build_s_"..i) 
        local Panel_pos = Panel_build_pos:getChildByName("Panel_build_s_"..i)
        Panel_ani:removeAllChildren(true)
        Panel_fight:removeAllChildren(true)
        Panel_pos:removeAllChildren(true)
        Panel_fight:removeBackGroundImage()
        Panel_fight:setBackGroundImage("images/ui/play/nationalwar/path_camp_".._ED.warfareCityInfo[i].camp..".png")
        local state_table = zstring.split(v.state,",")
        -- 城池状态0,0,0,0,0,0(1:正常,2:可突进,3:包围,4:进攻任务,5:防守任务,6:交战状态)

        if _ED.war_decree_time[i] ~= nil and (zstring.tonumber(_ED.war_decree_time[i].country_leave_time) > 0 or 
            zstring.tonumber(_ED.war_decree_time[i].family_leave_time) > 0) then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_qi/effect_qi.ExportJson")
            local effice = ccs.Armature:create("effect_qi")
            effice:getAnimation():playWithIndex(0)
            effice:setPosition(cc.p(Panel_ani:getContentSize().width/2, Panel_ani:getContentSize().height/2))
            Panel_ani:addChild(effice)
        end
        if tonumber(state_table[4]) == 1 or tonumber(state_table[5]) == 1 or tonumber(state_table[6]) == 1 then -- 非正常
            local sprite = cc.Sprite:create("images/ui/play/nationalwar/path_light.png")
            sprite:setPosition(cc.p(Panel_fight:getContentSize().width/2, Panel_fight:getContentSize().height/2))
            Panel_fight:addChild(sprite)
        end

        if _ED.war_user_at_city_id == i then
            local sprite = cc.Sprite:create("images/ui/play/nationalwar/path_dingwei.png")
            local height = sprite:getContentSize().height
            sprite:setPosition(cc.p(Panel_pos:getContentSize().width/2,height/2))
            Panel_pos:addChild(sprite)
        end
    end
    self:addMyResourceEffect()
end

function NatinalWarSmlleMap:onUpdateDrawState()
    local root = self.roots[1]
    local Panel_build_fight = ccui.Helper:seekWidgetByName(root,"Panel_build_fight")
    for i,v in ipairs(_ED.warfareCityInfo) do
        local Panel_fight = Panel_build_fight:getChildByName("Panel_build_s_"..i) 
        Panel_fight:removeAllChildren(true)
        local state_table = zstring.split(v.state,",")
        if tonumber(state_table[4]) == 1 or tonumber(state_table[5]) == 1 or tonumber(state_table[6]) == 1 then -- 非正常
            local sprite = cc.Sprite:create("images/ui/play/nationalwar/path_light.png")
            sprite:setPosition(cc.p(Panel_fight:getContentSize().width/2, Panel_fight:getContentSize().height/2))
            Panel_fight:addChild(sprite)
        end
        Panel_fight:removeBackGroundImage()
        Panel_fight:setBackGroundImage("images/ui/play/nationalwar/path_camp_".._ED.warfareCityInfo[i].camp..".png")  
    end
end

function NatinalWarSmlleMap:onUpdateDrawDecree()
    local root = self.roots[1]
    local Panel_build_ani = ccui.Helper:seekWidgetByName(root,"Panel_build_ani") 
    local Panel_build_fight = ccui.Helper:seekWidgetByName(root,"Panel_build_fight")  
    for i,v in ipairs(_ED.warfareCityInfo) do
        local Panel_ani = Panel_build_ani:getChildByName("Panel_build_s_"..i)
        Panel_ani:removeAllChildren(true)
        if _ED.war_decree_time[i] ~= nil and (zstring.tonumber(_ED.war_decree_time[i].country_leave_time) > 0 or 
            zstring.tonumber(_ED.war_decree_time[i].family_leave_time) > 0) then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_qi/effect_qi.ExportJson")
            local effice = ccs.Armature:create("effect_qi")
            effice:getAnimation():playWithIndex(0)
            effice:setPosition(cc.p(Panel_ani:getContentSize().width/2, Panel_ani:getContentSize().height/2))
            Panel_ani:addChild(effice)
        end
    end
end

function NatinalWarSmlleMap:onUpdateDrawPos()
    local root = self.roots[1]
    local Panel_build_pos = ccui.Helper:seekWidgetByName(root,"Panel_build_pos")
    for i,v in ipairs(_ED.warfareCityInfo) do
        local Panel_pos = Panel_build_pos:getChildByName("Panel_build_s_"..i)
        Panel_pos:removeAllChildren(true)
        if _ED.war_user_at_city_id == i then
            local sprite = cc.Sprite:create("images/ui/play/nationalwar/path_dingwei.png")
            local height = sprite:getContentSize().height
            sprite:setPosition(cc.p(Panel_pos:getContentSize().width/2, height/2))
            Panel_pos:addChild(sprite)
        end
    end
end

function NatinalWarSmlleMap:updateDrawResourceQuality(params)
    local cityId = params[1]
    local quality = params[2]
    local resourceType = params[3]
    local root = self.roots[1]
    local Panel_build_pos = ccui.Helper:seekWidgetByName(root,"Panel_build_pos")
    local Panel_pos = Panel_build_pos:getChildByName("Panel_build_s_"..cityId)
    if tonumber(quality) >= 0 and tonumber(quality) < 2 then
        Panel_pos._qualityPng = "images/ui/play/big_map/path_grade_".. (quality + 1) ..".png"
        Panel_pos:setBackGroundImage(Panel_pos._qualityPng)
    elseif tonumber(quality) >= 2 then 
        local effect_paths = "images/ui/effice/effice_big_map_path/effice_big_map_path.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("effice_big_map_path")
        draw.initArmature(armature, nil, -1, 0, 1)
        armature:getAnimation():playWithIndex(quality-2)
        armature:setPosition(cc.p(Panel_pos:getContentSize().width/2, Panel_pos:getContentSize().height/2))
        Panel_pos:addChild(armature)
    end
end

function NatinalWarSmlleMap:updateDrawMySelfCity(params)
    local cityId = zstring.tonumber(params[1])
    if cityId < 0 then
        cityId = 42
    end
    local root = self.roots[1]
    local Panel_build_pos = ccui.Helper:seekWidgetByName(root,"Panel_build_pos")
    local Panel_pos = Panel_build_pos:getChildByName("Panel_build_s_"..cityId)
    if nil ~= self._myselfPanelPos then
        -- if self._myselfPanelPos._qualityPng ~= nil then
        --     self._myselfPanelPos:setBackGroundImage(self._myselfPanelPos._qualityPng)
        -- else
        --     self._myselfPanelPos:removeBackGroundImage()
        -- end
        if self._myselfPanelPos._fspx ~= nil then
            self._myselfPanelPos._fspx:removeFromParent(true)
            self._myselfPanelPos._fspx = nil
        end
    end
    if nil ~= Panel_pos then
        -- Panel_pos:setBackGroundImage("images/ui/play/nationalwar/path_dingwei.png")
        self._myselfPanelPos = Panel_pos

        local sprite = cc.Sprite:create("images/ui/play/nationalwar/path_dingwei.png")
        sprite:setAnchorPoint(cc.p(0.5, 0))
        local size = Panel_pos:getContentSize()
        local pos = cc.p(Panel_pos:getPosition())
        pos.x = pos.x + size.width / 2
        pos.y = pos.y + size.height / 2
        sprite:setPosition(pos)
        Panel_pos:getParent():addChild(sprite)
        Panel_pos._fspx = sprite
    end
end

function NatinalWarSmlleMap:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.natinalwar_smlle_map)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self.move_panel = ccui.Helper:seekWidgetByName(root,"Panel_map_smlle_light")
    self.parent_panel = ccui.Helper:seekWidgetByName(root,"Panel_par")
    self.panel_par_size = self.parent_panel:getContentSize()
    self:onUpdateDraw() 

    self.move_panel:addTouchEventListener(self.panelTouchListener)
    self.move_panel.posx = self.move_panel:getPositionX()
    self.move_panel.posy = self.move_panel:getPositionY()
    self.move_panel.par_size = self.panel_par_size
end

function NatinalWarSmlleMap.panelTouchListener(sender, eventType)
    local __spoint = sender:getTouchBeganPosition()
    local __mpoint = sender:getTouchMovePosition()
    local __epoint = sender:getTouchEndPosition()

    if ccui.TouchEventType.began == eventType then
        
    elseif ccui.TouchEventType.moved == eventType then
        local x = __mpoint.x - __spoint.x
        local y = __mpoint.y - __spoint.y
        local nowx = sender.posx + x
        local nowy = sender.posy + y
        nowx = math.max(0,nowx)
        nowx = math.min(nowx,sender.par_size.width - sender:getContentSize().width)
        nowy = math.max(0,nowy)
        nowy = math.min(nowy,sender.par_size.height - sender:getContentSize().height)          
        sender:setPosition(cc.p(nowx , nowy))
        local pensert_x = nowx/(sender.par_size.width - sender:getContentSize().width )
        local pensert_y = nowy/(sender.par_size.height - sender:getContentSize().height )           
        state_machine.excute("natinal_war_map_scroll_change_pos",0,{pensert_x,pensert_y})
    elseif ccui.TouchEventType.ended == eventType then
        sender.posx = sender:getPositionX()
        sender.posy = sender:getPositionY()

        local pensert_x = sender.posx/(sender.par_size.width - sender:getContentSize().width )
        local pensert_y = sender.posy/(sender.par_size.height - sender:getContentSize().height )   
        state_machine.excute("natinal_war_map_scroll_change_pos",0,{pensert_x,pensert_y})
    end
end

function NatinalWarSmlleMap:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function NatinalWarSmlleMap:onExit()
    state_machine.remove("natinal_war_smllemap_change_pos")    
    state_machine.remove("natinal_war_smllemap_update_state")
    state_machine.remove("natinal_war_smllemap_update_decree")
    state_machine.remove("natinal_war_smllemap_update_pos")
    state_machine.remove("natinal_war_smllemap_update_draw_resource_quality")
    state_machine.remove("natinal_war_smllemap_update_draw_myself_city")
    state_machine.remove("natinal_war_smllemap_add_my_resource_effect")
    state_machine.remove("natinal_war_smllemap_update_raiderscut_info")
end
