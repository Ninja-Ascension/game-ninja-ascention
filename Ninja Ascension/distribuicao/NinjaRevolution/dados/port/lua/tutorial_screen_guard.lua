-- Trace and retire the character screen if it is recreated over a battle.
local M={}

local function window(name)
    if not fwin or type(fwin.find)~='function' then return nil end
    local ok,value=pcall(function() return fwin:find(name) end)
    if ok then return value end
    return nil
end

local function visible(node)
    if not node then return false end
    local ok,value=pcall(function() return node:isVisible() end)
    return ok and value==true
end

local function battleActive()
    return visible(window('BattleSceneClass')) or visible(window('FightClass'))
end

function M.note(stage,detail)
    local tutorial='unknown'
    pcall(function() tutorial=require('initial_tutorial').state end)
    local hero=window('HomeHeroClass')
    local battle=window('BattleSceneClass')
    local fight=window('FightClass')
    local active={}
    for _,item in ipairs((fwin and fwin._list) or {}) do
        if item then
            local name=tostring(item.__cname or item.__name or 'Window')
            local visible='?'
            pcall(function() visible=tostring(item:isVisible()) end)
            active[#active+1]=name..':'..visible
        end
    end
    local message='stage='..tostring(stage)
        ..' tutorial='..tostring(tutorial)
        ..' HomeHero='..tostring(hero~=nil)
        ..' HomeHeroVisible='..tostring(visible(hero))
        ..' BattleScene='..tostring(battle~=nil)
        ..' BattleSceneVisible='..tostring(visible(battle))
        ..' Fight='..tostring(fight~=nil)
        ..' FightVisible='..tostring(visible(fight))
        ..' windows={'..table.concat(active,',')..'}'
        ..(detail and (' '..tostring(detail)) or '')
    print('INITIAL_TUTORIAL_SCREEN '..message)
    local ok,path=pcall(function()
        return cc.FileUtils:getInstance():getWritablePath()..'initial-tutorial-screen.log'
    end)
    if ok and path then
        local file=io.open(path,'a')
        if file then
            file:write(os.date('%Y-%m-%d %H:%M:%S')..' '..message..'\n')
            file:close()
        end
    end
end

function M.closeCharacterScreen(stage)
    local hero=window('HomeHeroClass')
    if not hero then return false end
    M.note(stage..'-before-close')
    local ok,err=pcall(function() fwin:close(hero) end)
    M.note(stage..(ok and '-closed' or '-close-failed'),err)
    return ok
end

function M.installHomeHero(class)
    if type(class)~='table' or class.__nr_tutorial_screen_guard then return end
    local original=class.onEnterTransitionFinish
    if type(original)~='function' then return end
    class.__nr_tutorial_screen_guard=true
    class.onEnterTransitionFinish=function(self,...)
        local result={original(self,...)}
        if battleActive() then
            M.note('character-screen-entered-during-battle')
            local function retire()
                if battleActive() then
                    M.closeCharacterScreen('character-screen-entered-during-battle')
                end
            end
            if fwin and type(fwin.addService)=='function' then
                fwin:addService({delay=0,callback=retire})
            else
                retire()
            end
        end
        return unpack(result)
    end
end

function M.installTuitionController(class)
    if type(class)~='table' or class.__nr_screen_trace then return end
    class.__nr_screen_trace=true
    for _,name in ipairs({'showWindow','executeMission'}) do
        local original=class[name]
        if type(original)=='function' then
            class[name]=function(self,...)
                M.note('tutorial-'..name..'-begin')
                local result={original(self,...)}
                M.note('tutorial-'..name..'-end')
                return unpack(result)
            end
        end
    end
end

return M
