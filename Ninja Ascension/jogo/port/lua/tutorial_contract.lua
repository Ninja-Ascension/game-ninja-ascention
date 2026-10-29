-- Isolated native regression: execute the recovered next-wave window,
-- including its Spine completion callback, without an account or network.
local M={}
function M.run()
    app.load('client.battle.fight.FightRound')
    local execute,close,music=state_machine.excute,fwin.close,playEffectMusic
    local project=__lua_project_id
    local spine=sp.spine
    local created
    local started,closed=0,0
    local window=ccui.Layout:create()
    window.roots={};window._currentRountCount=2;window._totalRoundCount=2
    local ok,err=xpcall(function()
        __lua_project_id=assert(__lua_project_l_naruto,'Naruto project constant missing')
        state_machine.excute=function(name,...)
            if name=='fight_attack_check_boss_instro' then return false end
            if name=='fight_attack_round_start' then started=started+1;return true end
            error('Unexpected next-wave command: '..tostring(name))
        end
        fwin.close=function(self,target)
            assert(target==window,'Transition closed an unrelated window')
            closed=closed+1
        end
        playEffectMusic=function() end
        sp.spine=function(...)
            created=spine(...)
            return created
        end
        FightRound.onEnterTransitionFinish(window)
        local animation=assert(created,'Next-wave animation missing')
        assert(animation:getParent(),'Next-wave animation not attached')
        assert(started==0 and closed==0,'Wave started before transition completed')
        local duration=animation:getAnimationDurationEx('animation2')
        assert(duration>0,'Next-wave animation duration missing')
        -- Match normal rendering ticks; Spine 2.1's loop detection compares
        -- successive sample times and cannot infer a whole skipped cycle.
        local steps=math.ceil((duration+0.02)*60)
        for i=1,steps do cc.nrSpineCommand(animation,'advance',1/60) end
        assert(closed==1 and started==1,'Completion did not release wave 2 exactly once: closed='
            ..closed..' started='..started..' duration='..duration)
        animation:clearTracks()
    end,debug.traceback)
    state_machine.excute=execute;fwin.close=close;playEffectMusic=music
    __lua_project_id=project
    sp.spine=spine
    if not ok then error(err,0) end
    print('NATIVE_TUTORIAL_WAVE2_PASSED original window and real completion callback')
end
return M
