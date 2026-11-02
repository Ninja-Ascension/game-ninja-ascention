-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本战力提示
-------------------------------------------------------------------------------------------------------
AdventureDuplicateCapacityTipDlg = class("AdventureDuplicateCapacityTipDlgClass", Window)
    
function AdventureDuplicateCapacityTipDlg:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1
    self._scene_difficulty_index = 1
    self.Panel_zhanli = nil
    self.Panel_next = nil


    app.load("client.adventure.utils.AdventureShareGradeDialog")
    -- Initialize adventure duplicate capacity tip dialog state machine.
    local function init_adventure_duplicate_capacity_tip_dialog_terminal()
        -- change scene
        local adventure_duplicate_capacity_tip_dialog_change_scene_terminal = {
            _name = "adventure_duplicate_capacity_tip_dialog_change_scene",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("adventure_duplicate_change_map", 0, cell.selectSceneId)
                state_machine.excute("adventure_duplicate_map_list_view_close_window", 0, 0)
                state_machine.excute("adventure_duplicate_update_next_scene",0,cell.selectSceneId)
                instance:checkShareGrade()
                fwin:close(fwin:find("AdventureDuplicateCapacityTipDlgClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_duplicate_capacity_tip_dialog_strengthen_scene_terminal = {
            _name = "adventure_duplicate_capacity_tip_dialog_strengthen_scene",
            _init = function (terminal)
                app.load("client.adventure.packs.hero.AdventureHeroStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        
                fwin:close(fwin:find("AdventureDuplicateCapacityTipDlgClass"))
                state_machine.excute("menu_clean_page_state_for_streng", 0,"")
                state_machine.excute("menu_adventure_open_button",0,"")
                fwin:open(AdventureHeroStorage:new():init(), fwin._view)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_capacity_tip_dialog_change_scene_terminal)
        state_machine.add(adventure_duplicate_capacity_tip_dialog_strengthen_scene_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure duplicate capacity tip dialog state machine.
    init_adventure_duplicate_capacity_tip_dialog_terminal()
end


function AdventureDuplicateCapacityTipDlg:checkShareGrade()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if zstring.tonumber("".._ED.server_review) == 0 then 
        if (cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD) == targetPlatform and app.configJson.PayOperatorName == "app" and zstring.tonumber(_game_platform_version_type) ~= 4 then 
            if _share_grade_scene_id == nil then
                return
            end
            for k,v in pairs(_share_grade_scene_id) do
                local shareDate = cc.UserDefault:getInstance():getStringForKey(getKey("share_grade_" .. v),"0")
                if shareDate == "0" and tonumber(v) == tonumber(self.selectSceneId) then 
                    -- 需要弹出
                    fwin:open(AdventureShareGradeDialog:new():init(), fwin._ui)      
                    cc.UserDefault:getInstance():setStringForKey(getKey("share_grade_" .. v),"1")
                    break
                end
            end 
        end
    end
end

function AdventureDuplicateCapacityTipDlg:init(sceneId)
    self.selectSceneId = sceneId
	return self
end

function AdventureDuplicateCapacityTipDlg:onEnterTransitionFinish()
	local csbAdventureDuplicateCapacityTipDlg = csb.createNode("duplicate/maoxian_dalu_info.csb")
    local root = csbAdventureDuplicateCapacityTipDlg:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateCapacityTipDlg)

    -- 绘制当前场景的名称
    local scene_name = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.scene_name)
    ccui.Helper:seekWidgetByName(root, "Text_mapname"):setString(scene_name)

    -- 绘制当前场景的描述信息
    local open_condition_describe = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.open_condition_describe)
   
    local zlbzText_tip = ccui.Helper:seekWidgetByName(root, "Text_map_info_0")
    local nextText_tip =  ccui.Helper:seekWidgetByName(root, "Text_map_info")
    nextText_tip:setString(open_condition_describe)
    -- 绘制场景开启战力需求
    local capacity = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.combat_force)
    ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString(capacity)
    -- 这个地方可能会出现问题
    local Button_next = ccui.Helper:seekWidgetByName(root, "Button_next")
    local Button_zhanli = ccui.Helper:seekWidgetByName(root, "Button_zhanli")
    local current_zhanli_Text = ccui.Helper:seekWidgetByName(root, "Text_zhanli_0")

    current_zhanli_Text:setString("" .. _ED.user_info.fight_capacity)
    if zstring.tonumber(capacity) < zstring.tonumber(_ED.user_info.fight_capacity)  then
        --显示下一区域
        current_zhanli_Text:setColor(cc.c3b(255, 255, 255))
        Button_zhanli:setVisible(false)
        Button_next:setVisible(true)
        zlbzText_tip:setVisible(false)
        nextText_tip:setVisible(true)
    else
        --显示战力不足
        current_zhanli_Text:setColor(cc.c3b(255,37,37))
        Button_zhanli:setVisible(true)
        Button_next:setVisible(false)
        zlbzText_tip:setVisible(true)
        nextText_tip:setVisible(false)
    end

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateCapacityTipDlgClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

        -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanli_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateCapacityTipDlgClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanli"),       nil, 
    {
        terminal_name = "adventure_duplicate_capacity_tip_dialog_strengthen_scene",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 切换场景
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"),       nil, 
    {
        terminal_name = "adventure_duplicate_capacity_tip_dialog_change_scene",   
        cell = self,      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateCapacityTipDlg:onExit()
    state_machine.remove("adventure_duplicate_capacity_tip_dialog_change_scene")
    state_machine.remove("adventure_duplicate_capacity_tip_dialog_strengthen_scene")
end