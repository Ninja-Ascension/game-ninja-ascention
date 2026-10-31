-- Explicit local tutorial convenience: skip presentation and settle once.
local M={}
local button,buttonScene
function M.allowed()
    local user=_ED and _ED.user_info
    local battle=_ED and _ED.battleData
    if not user or not battle or tonumber(battle.battle_init_type)~=0 then return false end
    local grade=tonumber(user.user_grade) or 999
    local npc=tonumber(_ED._scene_npc_id or battle.objId)
    return grade<=6 and (npc==1196 or (npc and npc>=1 and npc<=5))
end

local function finishToMenu()
    -- Same original terminal used by the final introductory cutscene. Retire
    -- old combat windows after the reward has been acknowledged and parsed.
    app.load('client.home.Menu')
    local previous=fwin:find('MenuClass')
    if previous then fwin:close(previous) end
    clearMission()
    for _,key in ipairs({'_background','_view','_viewdialog','_ui'}) do
        if fwin[key] then fwin:cleanView(fwin[key]) end
    end
    _ED._fightModule=nil
    _ED.attackData=nil
    _ED.user_info.battleCache=nil
    _ED._battle_pause=false
    _ED._battle_wait_change_scene=false
    state_machine.excute('menu_window_open_mission',0,0)
end

function M.skip()
    local fight=fwin:find('FightClass')
    if not M.allowed() or not fight or fight.__nr_skip_pending or fight._fight_is_end then return false end
    if not _ED._fightModule then return false end
    fight.__nr_skip_pending=true
    print('TUTORIAL_SKIP requested npc='..tostring(_ED._scene_npc_id))
    if tonumber(_ED._scene_npc_id)==1196 then
        -- Reuse the exact idempotent introductory XP reward. Its parser runs
        -- before this callback, so the next original mission selects l1e1.
        protocol_command.get_resource.param_list='8-0,1'
        NetworkManager:register(protocol_command.get_resource.code,nil,nil,nil,fight,function(response)
            if fwin:find('FightClass')~=fight or fight.__nr_skip_done then return end
            if not response.RESPONSE_SUCCESS or (tonumber(response.PROTOCOL_STATUS) or -1)<0 then
                fight.__nr_skip_pending=nil
                print('TUTORIAL_SKIP introductory reward rejected; retry available')
                return
            end
            fight.__nr_skip_done=true
            finishToMenu()
            print('TUTORIAL_SKIP introductory battle finished')
        end,false,nil)
    else
        -- Explicit local tutorial victory. Send the normal authenticated
        -- settlement command, then enter the original next menu mission.
        local module=_ED._fightModule
        local npc=tostring(_ED._scene_npc_id)
        protocol_command.battle_result_verify.param_list=table.concat({
            tostring(fight._scene_id),npc..'-'..npc,
            tostring(math.max(1,math.min(3,tonumber(module.star) or 1))),
            tostring(fight._difficulty or 1),'1','0,0,0,0'},'\r\n')
        NetworkManager:register(protocol_command.battle_result_verify.code,nil,nil,nil,fight,function(response)
            if fwin:find('FightClass')~=fight or fight.__nr_skip_done then return end
            if not response.RESPONSE_SUCCESS or (tonumber(response.PROTOCOL_STATUS) or -1)<0 then
                fight.__nr_skip_pending=nil
                print('TUTORIAL_SKIP settlement rejected; retry available')
                return
            end
            fight.__nr_skip_done=true
            finishToMenu()
            print('TUTORIAL_SKIP victory saved; original next mission opened')
        end,false,nil)
        print('TUTORIAL_SKIP submitted original battle verification')
    end
    return true
end

function M.refresh()
    local scene=cc.Director:getInstance():getRunningScene()
    if not scene then return end
    if buttonScene~=scene or not button or tolua.isnull(button) then
        buttonScene=scene
        button=ccui.Button:create()
        button:ignoreContentAdaptWithSize(false)
        button:setContentSize(cc.size(220,42))
        button:setAnchorPoint(cc.p(1,1))
        button:setTitleText('Pular luta do tutorial')
        button:setTitleFontSize(18)
        button:setTitleColor(cc.c3b(255,255,255))
        local background=cc.LayerColor:create(cc.c4b(15,70,105,235),220,42)
        button:addChild(background,-1)
        button:addClickEventListener(function()
            -- Leave native touch traversal before retiring any windows.
            fwin:addService({delay=0,callback=function() M.skip() end})
        end)
        scene:addChild(button,2147480000)
    end
    local size=cc.Director:getInstance():getWinSize()
    button:setPosition(cc.p(size.width-12,size.height-80))
    local fight=fwin:find('FightClass')
    button:setVisible(M.allowed() and fight~=nil and _ED._fightModule~=nil and not fight._fight_is_end)
    button:setEnabled(fight~=nil and not fight.__nr_skip_pending)
    return button
end

function M.install()
    if M.scheduler then return end
    M.scheduler=cc.Director:getInstance():getScheduler():scheduleScriptFunc(M.refresh,0.25,false)
end
return M
