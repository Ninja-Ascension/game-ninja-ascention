-- Explicit native diagnostic only; never used by the normal launcher.
-- Project root from the launcher/test (NR_GAME_ROOT); the old N: mapping is only a fallback.
local NR_PROBE_ROOT=((os.getenv('NR_GAME_ROOT') or 'N:'):gsub('\\','/'):gsub('/+$',''))..'/'
local ok,err=xpcall(function()
    if os.getenv('NR_PROBE_LOGIN_TRACE')=='1' then
        local original=npos
        local reads=0
        npos=function(list)
            local line=debug.getinfo(2,'l').currentline
            local value=original(list);reads=reads+1
            if reads<125 then print('LOGIN_FIELD_TRACE read='..reads..' line='..line..' value='..tostring(value)) end
            return value
        end
    end
    if os.getenv('NR_PROBE_SHADER_PATH_TEST')=='1' then
        local files=cc.FileUtils:getInstance()
        local original=files:getSearchPaths()
        local stripped={}
        for _,path in ipairs(original) do
            if not path:gsub('\\','/'):find('/axslc',1,true) then stripped[#stripped+1]=path end
        end
        for iteration=1,3 do
            files:setSearchPaths(stripped)
            assert(#files:getStringFromFile('positionColorLengthTexture_vs')>0)
            assert(#files:getStringFromFile('positionColorLengthTexture_fs')>0)
            local chat=assert(csb.createNode('Chat/chat_home_window.csb'),'Chat CSB creation failed')
            chat:retain();chat:release()
        end
        files:setSearchPaths(original)
        print('ENGINE_SHADER_PATH_NATIVE_PASSED direct replacements and original chat layout created three times')
        return
    end
    dofile(NR_PROBE_ROOT..'01_conteudo_apk/assets/res/configs/operation/config.lua')
    -- Explicit isolated identity for local cache keys; never a player account.
    _ED.default_user=1;_ED.user_platform={[1]={platform_account='__nr_menu_probe__'}}
    _ED.selected_server=1;_ED.all_servers={[1]={server_number='1'}}
    _ED.system_time=os.time()
    _ED.native_time=os.time();_ED.open_server_time=os.time()*1000
    _ED.scene_current_state={};_ED.scene_max_state={};_ED.get_star_count={};_ED.star_reward_state={}
    for i=1,500 do
        _ED.scene_current_state[i]=i==1 and '0' or '-1'
        _ED.scene_max_state[i]=_ED.scene_current_state[i]
        _ED.get_star_count[i]='0';_ED.star_reward_state[i]='0'
    end
    __lua_project_id=__lua_project_l_naruto
    _ED.user_info.user_id='1';_ED.user_info.user_grade='1';_ED.user_info.user_experience='1'
    _ED.user_info.user_food='60';_ED.user_info.max_user_food='60'
    if os.getenv('NR_PROBE_SAGA_UI')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        app.load('client.cells.utils.resources_icon_cell')
        app.load('client.l_digital.cultivate.roleBiography.RoleBiographyHandle')
        app.load('client.l_digital.cultivate.roleBiography.RoleBiographyDivine')
        dofile(NR_PROBE_ROOT..'res/configs/csb/config.lua')
        _ED.push_user_ship_info=nil
        NetworkManager.register=function() return {} end
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(NR_PROBE_ROOT..'build/saga-ui-login.txt')})
        local window=RoleBiographyDivine:new():init({});window:retain()
        local loaded,detail=pcall(window.onEnterTransitionFinish,window)
        assert(loaded,tostring(detail))
        assert(window.Text_alloy_buy_jb_one_n:getString()=='1/2')
        assert(window.Text_alloy_buy_one_time_n:getString()=='50/50')
        assert(window.Text_alloy_buy_ten_time_n:getString()=='11/8000')
        assert(not window.Text_buy_2:getString():find('%%s'))
        _ED.biographies_draw_info.normalDrawFreeNumber=1
        _ED.biographies_draw_info.advanceDrawFreeNumber=1
        window:onUpdateDraw()
        assert(window.Text_gm10:getString()~='','Free normal draw label missing')
        assert(window.Text_gm1_0:getString()~='','Free advanced draw label missing')
        local originalX=window.Text_alloy_buy_jb_one_n:getPositionX()
        window:onUpdateDraw();window:onUpdateDraw()
        assert(window.Text_alloy_buy_jb_one_n:getPositionX()==originalX,'Refresh shifted costs')
        local panel=assert(ccui.Helper:seekWidgetByName(window.roots[1],'Panel_sp'))
        local order={'Text_alloy_draw_infor_t_1','Text_alloy_draw_infor_n_1','Text_alloy_draw_infor_t_1_0','Text_alloy_draw_infor_n_2','Text_alloy_draw_infor_t_1_0_0'}
        local edge=-math.huge
        for _,name in ipairs(order) do
            local label=assert(ccui.Helper:seekWidgetByName(panel,name))
            assert(label:getPositionX()>=edge,'Translated labels overlap')
            edge=label:getPositionX()+label:getContentSize().width*label:getScaleX()
        end
        app.load('client.player.UserTopInfoA')
        app.load('client.l_digital.cultivate.roleBiography.RoleBiographyChapter')
        local chapter=RoleBiographyChapter:new();chapter:retain();chapter:init();chapter:onEnterTransitionFinish()
        assert(chapter.Text and chapter.Text:getString()~='','Saga achievement label missing')
        local view=cc.Director:getInstance():getOpenGLView()
        local frame=view:getFrameSize()
        view:setFrameSize(1280,720)
        local fitted=window.roots[1]:getParent()
        require('saga_layout').fit(fitted,0)
        assert(math.abs(fitted:getScaleX()-.84375)<.001,'Saga distorted in widescreen')
        local close=window.Button_draw_back
        local box=close:getBoundingBox()
        local right=close:getParent():convertToWorldSpace(cc.p(box.x+box.width,box.y))
        assert(right.x<=960,'Close button outside widescreen canvas')
        view:setFrameSize(frame.width,frame.height)

        return
    end
    if os.getenv('NR_PROBE_NINJA_SCHOOL')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        dofile(NR_PROBE_ROOT..'res/configs/csb/config.lua')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(NR_PROBE_ROOT..'build/school-login.txt')})
        app.load('client.l_digital.cultivate.SmCultivateWindow')
        app.load('client.player.UserTopInfoA')
        local menu=SmCultivateWindow:new();menu:retain();menu:init()
        local names={'SmTalentMainWindow','SmCultivateSpiritWindow','SmCultivateArtifactWindow','SmCultivateAchieveWindow','SmCultivateConstellationWindow','AlloyMatrixWindow','SoulWardingWindow','SilkBags','CombinationCardWindow','Illustration','RoleBiographyChapter','MythicalAnimalsMainUI'}
        local failures={}
        for _,name in ipairs(names) do
            local window
            local success,problem=xpcall(function()
                window=_G[name]:new();window:retain();window:init(name=='AlloyMatrixWindow' and {} or nil)
            end,debug.traceback)
            if success then print('SCHOOL_VIEW_OK '..name)
            else failures[#failures+1]=name..': '..tostring(problem);print('SCHOOL_VIEW_FAIL '..failures[#failures]) end
            -- Keep nodes alive to avoid destroying retained timeline targets while inspecting other views.
        end
        assert(#failures==0,table.concat(failures,'; '))
        print('NINJA_SCHOOL_NATIVE_PASSED twelve original view initializations')
        return
    end
    if os.getenv('NR_PROBE_GATES_LANGUAGE')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        dofile(NR_PROBE_ROOT..'res/configs/csb/config.lua')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/gates-login.txt')})
        local language=require('language_assets_local')
        language.apply('pt_BR')
        assert(files:fullPathForFilename('data/TipStringInfo.lua'):find('/language/pt_BR/',1,true),'Portuguese text pack has no priority')
        assert(_new_interface_text[1]:find('Nv.',1,true),'Portuguese strings were not loaded')
        assert(files:fullPathForFilename('cocostudio/battle/sm_battle_victory.csb'):find('/language/pt_BR/',1,true),'Portuguese layout has no priority')
        language.apply('es');assert(files:fullPathForFilename('data/TipStringInfo.lua'):find('/language/es/',1,true),'Spanish pack has no priority')
        language.apply('pt_BR')
        local ship=_ED.user_ship['100013']
        local info=nil
        for _,entry in ipairs(_ED.mega_info) do if entry.shipId==ship.ship_id then info=json.decode(entry.info) end end
        assert(info and info.megaLevel['1']==10,'Gate progress lost after login')
        app.load('client.formation.mega.MegaWindow')
        app.load('client.formation.mega.MegaBigTree')
        app.load('client.formation.mega.MegaSmallTree')
        local parent=cc.Node:create();parent:retain()
        local big=MegaBigTree:new():init({ship,parent,1});parent:addChild(big);big:onEnterTransitionFinish()
        for _,cell in pairs(big.cells) do if not cell.roots[1] then cell:onEnterTransitionFinish() end end
        assert(big:judgeType(9,-1,3)==false,'Missing alloys cannot fulfill the original gate requirement')
        local small=MegaSmallTree:new():init({ship,parent,1});parent:addChild(small);small:onEnterTransitionFinish()
        for _,cell in pairs(small.cells) do if not cell.roots[1] then cell:onEnterTransitionFinish() end end
        local home=csb.createNode('home/home_juese.csb');home:retain()
        local root=home:getChildByName('root') or home
        require('home_hero_labels').apply(root,1,ship)
        local name=ccui.Helper:seekWidgetByName(root,'Text_name_1')
        local stars=ccui.Helper:seekWidgetByName(root,'Panel_star_1')
        assert(name:getContentSize().width<=152 and name:getFontSize()==14,'Hero caption not constrained')
        assert(require('home_hero_labels').shortName('Rinne Sharingan - Sasuke')=='Sasuke')
        assert(require('home_hero_labels').shortName('Madara Uchiha - Edo Tensei (Auge)')=='Madara')
        local caption=ccui.Helper:seekWidgetByName(root,'Panel_role_name_1')
        local level=caption:getChildByName('__desktop_hero_level')
        assert(level:getColor().r==255 and level:getColor().g==0 and level:getColor().b==0,'Level is not red')
        assert(level:getPositionY()==name:getPositionY() and level:getPositionX()>name:getPositionX(),'Level not inline after name')
        local starLayer=assert(stars:getChildByTag(95270),'Original star renderer missing')
        assert(#starLayer:getChildren()==tonumber(ship.StarRating),'Wrong star count')
        local beforeY=ccui.Helper:seekWidgetByName(root,'Panel_role_name_1'):getPositionY()
        require('home_hero_labels').apply(root,1,ship)
        assert(ccui.Helper:seekWidgetByName(root,'Panel_role_name_1'):getPositionY()==beforeY,'Caption offset accumulated')
        for index=1,6 do
            assert(require('home_hero_labels').safeApply(root,index,ship),'Caption failed at slot '..index)
            local caption=ccui.Helper:seekWidgetByName(root,'Panel_role_name_'..index)
            assert(caption:getChildByName('__desktop_hero_level'):getString()~='', 'Hero label update stopped at slot '..index)
        end
        home:release();parent:release()
        print('GATES_LANGUAGE_NATIVE_PASSED gate views, saved progress, original PT/ES assets and hero captions')
        return
    end
    if os.getenv('NR_PROBE_HERO_STATS')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/stats-before-login.txt')})
        local before=tonumber(_ED.user_ship['100013'].hero_fight)
        local oldSpeed=tonumber(_ED.user_info.speed_sum)
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/stats-update.txt')})
        local ship=_ED.user_ship['100013']
        assert(tonumber(ship.ship_wisdom)==25,'Advance +5 and promotion +20 were not applied')
        assert(tonumber(_ED.user_info.speed_sum)==oldSpeed+25,'Team speed was not updated')
        assert(tonumber(ship.hero_fight)>before,'Power did not increase with effective stats')
        local after=tonumber(ship.hero_fight)
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/stats-update.txt')})
        assert(tonumber(ship.hero_fight)==after and tonumber(ship.ship_wisdom)==25,'Repeated snapshot added bonuses twice')
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/stats-after-login.txt')})
        ship=_ED.user_ship['100013']
        assert(tonumber(ship.ship_wisdom)==25 and tonumber(_ED.user_info.speed_sum)==25,'Speed lost after login')
        local expected=ship.ship_health..ship.ship_wisdom..ship.ship_leader..ship.ship_courage..ship.ship_intellect..ship.ship_quick
        assert(aeslua.decrypt('jar-world',ship.history_info,aeslua.AES128,aeslua.ECBMODE)==expected,'Attribute integrity mismatch')
        assert(tonumber(ship.relationship_count)>0)
        app.load('client.battle.fight.FightEnum');app.load('client.battle.report.BattleReport')
        local module=FightModule:new();_ED._fightModule=module
        module:initBattleField(ConfigDB.load('npc',1),1,0,nil,nil,false)
        assert(_ED.user_info.battleCache and not module._error,'Battle rejected the updated attributes')
        assert(tonumber(_ED.user_info.battleCache.attackerSpeedValue)==25,'Battle used another initiative value')
        dofile(NR_PROBE_ROOT..'res/configs/csb/config.lua')
        app.load('client.red_alert_time.utils.combatEffectivenessUp')
        _ED.last_fight_number=tonumber(_ED.user_info.fight_capacity)-100
        local toast=CombatEffectivenessUp:new():init(0)
        assert(toast._hostPowerToastTime or toast.roots[1],'Power notification failed')
        app.load('client.player.UserInformation')
        local total=0
        for i=2,7 do
            local id=_ED.formetion[i]
            local hero=id and _ED.user_ship[tostring(id)]
            if hero then total=total+tonumber(hero.hero_fight) end
        end
        assert(tonumber(_ED.user_info.fight_capacity)==total,'Home power differs from the deployed heroes')
        local label=ccui.Text:create();label:retain()
        local header={_BitmapFontLabel_5=label}
        UserInformation.setLocalPower(header,total)
        assert(tonumber(header.fight_capacity)==total and label:getString()~='','Home header was not refreshed')
        label:release()
        print('HERO_STATS_NATIVE_PASSED power, exact speed, bonds, integrity, battle and power notification')
        return
    end
    if os.getenv('NR_PROBE_HERO_DEVELOPMENT')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/hero-development-login.txt')})
        local ship=_ED.user_ship['100013']
        assert(tonumber(ship.StarRating)==2 and ship.skillLevel=='5,1,1,1,1,1')
        assert(tonumber(zstring.split(zstring.split(ship.ship_fighting_spirit,'|')[1],',')[1])>1)
        local power=tonumber(ship.hero_fight)
        assert(power>0)
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/hero-development-reply.txt')})
        assert(tonumber(ship.hero_fight)==power,'Power drift after identical update')
        local layout=require('desktop_layout')
        local defaults=cc.UserDefault:getInstance()
        local language=defaults:getStringForKey('current_language','')
        defaults:setStringForKey('current_language','pt-BR');assert(layout.translate('Promote')=='Promover')
        defaults:setStringForKey('current_language','en');assert(layout.translate('Promote')=='Promote')
        defaults:setStringForKey('current_language',language)
        local parent=cc.Node:create();parent:retain()
        for _,name in ipairs({'SmRoleStrengthenTabSkill','SmRoleStrengthenTabRisingStar','SmRoleStrengthenTabFightingSpirit'}) do
            app.load('client.packs.hero.'..name)
            print('DEVELOPMENT_TAB_OPEN '..name)
            local tab=_G[name]:new();parent:addChild(tab)
            tab:init({parent,'100013'})
        end
        parent:release()
        for _,name in ipairs({'SmRoleStrengthenTabFightingSpiritStrengthen','SmRoleStrengthenTabFightingSpiritOld'}) do
            app.load('client.packs.hero.'..name)
            local tab=_G[name]:new()
            tab:init({_datas={index=2,shipId='100013'}})
            local materialCount=0
            for _,prop in ipairs(tab:getSortedHeroes()) do
                assert(dms.int(dms['prop_mould'],prop.user_prop_template,prop_mould.reward_type)>0,'Invalid EXP material shown')
                if tonumber(prop.user_prop_template)==243 then materialCount=materialCount+1 end
            end
            assert(materialCount==1,'Primary essence must appear exactly once')
            print('CURSED_SEAL_MATERIAL_UI_PASSED '..name)
        end
        print('HERO_DEVELOPMENT_NATIVE_PASSED persisted tabs, power and selected language')
        return
    end
    if os.getenv('NR_PROBE_EQUIPMENT_DEVELOPMENT')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        app.load('client.cells.utils.resources_icon_cell')
        app.load('client.packs.EquipStorage.SmEquipmentQunenchingHandle')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        local function parse(name)
            local text=files:getStringFromFile(NR_PROBE_ROOT..'build/'..name..'.txt')
            NetworkProtocol.parser_func({resouce=text})
            return text
        end
        parse('equip-awaken-before-login')
        local count=_ED.user_ship_number
        parse('equip-awaken-reply')
        local hero=assert(_ED.user_ship['100013'])
        local parts=zstring.split(hero.equipInfo,'|')
        assert(zstring.split(parts[4],',')[1]=='5','Awaken stars missing')
        assert(zstring.split(parts[5],',')[1]=='104','Awaken template missing')
        assert(_ED.user_ship_number==count,'Awaken duplicated hero')
        parse('equip-quench-before-login')
        app.load('client.packs.EquipStorage.SmEquipmentQianghuaTab3Window1')
        local window=SmEquipmentQianghuaTab3Window1:new();window:retain();window:init({})
        window.equip={ship_id='100013',m_index=1,user_equiment_template='104',user_equiment_grade='1'}
        window:onUpdateDraw()
        local reply=parse('equip-quench-reply')
        hero=assert(_ED.user_ship['100013'])
        local state=assert(hero.hardensInfo[1])
        assert(state.level==3 and state.lockIndex==0 and #state.entryInfos==2,'Quench state missing')
        window:onUpdateDraw()
        app.load('client.packs.EquipStorage.SmEquipmentQianghuaTab3')
        local replacement=SmEquipmentQianghuaTab3:new();replacement:retain();replacement:init({window.equip})
        local stats=json.decode(reply:match('15995 (%S+)'))
        assert(hero.property_values==stats[1].property_values,'Quench attributes missing')
        parse('equip-developed-login')
        assert(_ED.user_ship['100013'].hardensInfo[1].level==3,'Quench lost on login')
        replacement:release();window:release()
        print('EQUIPMENT_DEVELOPMENT_NATIVE_PASSED Awaken, Quench, lock, attributes, original windows and persisted login')
        return
    end
    if os.getenv('NR_PROBE_TREASURE')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        local function parse(name)
            local text=files:getStringFromFile(NR_PROBE_ROOT..'build/'..name..'.txt')
            NetworkProtocol.parser_func({resouce=text})
            return text
        end
        parse('treasure-before-login')
        local count=_ED.user_ship_number
        local reply=parse('treasure-normal-reply')
        local hero=assert(_ED.user_ship['100013'])
        local parts=zstring.split(hero.equipInfo,'|')
        assert(zstring.split(parts[1],',')[6]=='2','Book level missing')
        assert(zstring.split(parts[3],',')[6]=='15','Book EXP missing')
        local payload=json.decode(reply:match('15990 (%S+)'))
        for _,id in ipairs(payload.removedEquipment) do assert(_ED.user_equiment[id]==nil,'Spent book still in inventory') end
        parse('treasure-quick-before-login')
        reply=parse('treasure-quick-reply')
        hero=assert(_ED.user_ship['100013']);parts=zstring.split(hero.equipInfo,'|')
        assert(zstring.split(parts[1],',')[6]=='20' and zstring.split(parts[2],',')[6]=='1')
        payload=json.decode(reply:match('15990 (%S+)'))
        for _,id in ipairs(payload.removedEquipment) do assert(_ED.user_equiment[id]==nil,'Quick upgrade material retained') end
        assert(_ED.user_ship_number==count,'Book upgrade duplicated hero')
        local stats=json.decode(reply:match('15995 (%S+)'))
        assert(hero.property_values==stats[1].property_values,'Book properties missing')
        print('TREASURE_NATIVE_PASSED level, EXP, promotion, inventory removal and stats')
        return
    end
    if os.getenv('NR_PROBE_QUICK_UPGRADES')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        local function parse(name)
            local text=files:getStringFromFile(NR_PROBE_ROOT..'build/'..name..'.txt')
            NetworkProtocol.parser_func({resouce=text})
            return text
        end
        parse('quick-before-login')
        local count=_ED.user_ship_number
        local reply=parse('quick-equipment-reply')
        local hero=assert(_ED.user_ship['100013'])
        assert(hero.equipInfo:match('^10,1,1,1,1,1|'),'Equipment metadata not applied')
        local attributes=json.decode(reply:match('15995 (%S+)'))
        assert(tonumber(hero.ship_health)==math.floor(attributes[1].health),'Equipment attributes not applied')
        assert(_ED.user_ship_number==count,'Equipment upgrade duplicated hero')
        parse('quick-ninja-before-login')
        reply=parse('quick-ninja-reply')
        local expected=json.decode(reply:match('15993 (%S+)'))
        hero=assert(_ED.user_ship[expected.ship])
        assert(tonumber(hero.ship_grade)==10 and tonumber(hero.exprience)==expected.experience)
        assert(tonumber(hero.ship_health)==math.floor(expected.health),'Ninja attributes not applied')
        print('QUICK_UPGRADES_NATIVE_PASSED equipment metadata, ninja level, EXP, stats and hero count')
        return
    end
    if os.getenv('NR_PROBE_HERO_LEVEL')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        local reply=files:getStringFromFile(NR_PROBE_ROOT..'build/hero-level-reply.txt')
        local expected=json.decode(reply:match('15993 (.+)$'))
        local login=files:getStringFromFile(NR_PROBE_ROOT..'build/hero-level-login.txt')
        NetworkProtocol.parser_func({resouce=login})
        local hero=assert(_ED.user_ship[expected.ship])
        assert(tonumber(hero.ship_grade)==expected.level,'Level lost on login')
        assert(tonumber(hero.exprience)==expected.experience,'EXP lost on login')
        assert(tonumber(hero.grade_need_exprience)==expected.needed,'EXP requirement differs')
        local count=_ED.user_ship_number
        NetworkProtocol.parser_func({resouce=reply})
        assert(tonumber(hero.ship_grade)==expected.level)
        assert(_ED.user_ship_number==count,'Upgrade duplicated hero count')
        assert(tonumber(hero.ship_health)==math.floor(expected.health))
        print('HERO_LEVEL_NATIVE_PASSED level, remaining EXP, stats, login and existing hero count')
        return
    end
    if os.getenv('NR_PROBE_QUALITY_BATTLE')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return {} end
        _ED.push_user_ship_info=nil
        local files=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/quality-login.txt')})
        for _,ship in pairs(_ED.user_ship) do assert(tonumber(ship.Order)==3,'Advancement lost after login') end
        app.load('client.packs.FightSpirit.FightSpiritHandle')
        _ED.all_fight_spirits=nil;_ED.all_ship_fight_spirit_info=nil
        assert(FightSpiritHandle.getFightSpiritById(-1)==nil)
        assert(#FightSpiritHandle.getShipFightSpiritInfoById(100013)==4)
        assert(next(FightSpiritHandle.getAllFightSpirits())==nil)
        app.load('client.battle.fight.FightEnum')
        app.load('client.battle.report.BattleReport')
        local module=FightModule:new();_ED._fightModule=module
        local npc=ConfigDB.load('npc',1)
        module:initBattleField(npc,1,0,nil,nil,false)
        assert(_ED.user_info.battleCache,'Adventure battle cache was not generated')
        -- Compile all paths implicated by the live account's crash reports.
        local checked = {
            'cells/equip/equip_icon_cell.lua',
            'battle/fight/Fight.lua',
            'notification/push_notification_sm_hero_develop.lua',
            'packs/hero/SmRoleStrengthenTabSkill.lua',
            'packs/hero/SmRoleStrengthenTabFightingSpirit.lua',
            'packs/hero/SmRoleStrengthenTabRisingStar.lua',
            'l_digital/cultivate/roleBiography/RoleBiographyHandle.lua',
            'formation/mega/MegaWindow.lua',
            'formation/mega/MegaSmallTree.lua',
            'formation/mega/MegaBigTree.lua'
        }
        for _,path in ipairs(checked) do
            assert(loadfile(NR_PROBE_ROOT..'01_conteudo_apk/assets/src/client/'..path))
        end
        app.load('client.notification.push_notification_sm_hero_develop')
        assert(equipmentIsCanEvolution(nil,1)==false)
        assert(equipmentIsCanAwake(nil,1)==false)
        assert(equipmentIsCanLevelUp(nil,1)==false)
        assert(equipmentIsCanHarden(nil,1)==false)
        app.load('client.cells.equip.equip_icon_cell')
        local push = cc.Node:create();push:retain()
        local arrow = cc.Node:create();arrow:retain()
        assert(EquipIconCell:pushUpdate({push_node=push,push_arrow=arrow,
            current_type=-1,enum_type={_UP_SUCCESS=999},equip={ship_id='0'}})==false)
        assert(not push:isVisible() and not arrow:isVisible())
        push:release();arrow:release()
        print('ACCOUNT_UI_ERROR_PATHS_NATIVE_PASSED syntax and unassigned equipment notification')
        print('QUALITY_ADVENTURE_NATIVE_PASSED saved advancement and actual normal battle initialization without spirits')
        return
    end
    if os.getenv('NR_PROBE_QUEST')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        require('quest_local').install()
        _ED.push_user_ship_info=nil
        local response,node
        NetworkManager.register=function(self,code,a,b,c,owner,callback)
            if code==protocol_command.daily_mission_init.code then response=callback;node=owner end
            return {}
        end
        local files=cc.FileUtils:getInstance()
        local function parse(name) NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/quest-'..name..'.txt')}) end
        parse('login');parse('init')
        assert(#_ED.daily_task_info>10 and _ED.daily_task_integral==25)
        assert(_ED.daily_task_draw_index[1]=='1','Claimed activity chest not restored')
        app.load('client.activity.dailytask.DailyTask')
        local window=DailyTask:new();window:retain();window:onEnterTransitionFinish()
        assert(response and node==window,'Quest did not request its daily catalog')
        response({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0,node=window})
        assert(window.roots and window.roots[1],'Quest layout missing')
        window:initDailyTaskPage()
        assert(window.dailyTaskListView and #window.dailyTaskListView:getItems()>0,'Quest task list did not render')
        parse('reward')
        assert(tonumber(_ED.user_info.user_experience)==90)
        window:release()
        print('QUEST_NATIVE_PASSED catalog, task UI, saved claims and rewards')
        return
    end
    if os.getenv('NR_PROBE_SPECIAL_SHOP')=='1' then
        app.load('client.login.LoginLoading');app.load('client.home.Menu')
        NetworkManager.register=function() return false end
        _ED.push_user_ship_info=nil
        require('shop_local').install()
        local files=cc.FileUtils:getInstance()
        local function parse(name) NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/special-shop-'..name..'.txt')}) end
        parse('login')
        assert(_ED.union.union_info.union_id=='1','Saved clan membership missing')
        app.load('client.cells.utils.sm_item_icon_cell')
        app.load('client.l_digital.shop.SmShopTab')
        for page=3,5 do
            parse(tostring(page))
            local tab=SmShopTab:new():init(page);tab:retain()
            local rows=page==3 and _ED.arena_good or page==4 and _ED.glories_shop_info or _ED.union.union_shop_info.treasure.goods_info
            assert(#rows>0,'Special shop catalog empty')
            local prop=tab:getPropByType(rows[1],1)
            assert(tonumber(prop.sale_percentage)>0 and tonumber(prop.number)>0,'Invalid price or quantity')
            if page==4 then
                local row=dms.element(dms.glories_shop_info,rows[1].goods_id)
                assert(prop.sale_percentage==dms.atoi(row,glories_shop_info.need_glories))
                assert(prop.number==dms.atoi(row,glories_shop_info.sell_count))
            end
            app.load('client.l_digital.shop.SmShopBuy')
            local buy=SmShopBuy:new():init({prop,{page=page},1})
            buy:retain();buy:release()
            local refresh=SmShopRefreshWindow:new():init(page)
            refresh:retain()
            assert(refresh.cost_number==30,'Second refresh must cost 30 gold')
            refresh:release()
            tab:release()
        end
        print('SHOP_SPECIAL_NATIVE_PASSED Arena, Trial, Clan catalogs, balances and prices')
        return
    end
    if os.getenv('NR_PROBE_SHOP')=='1' then
        app.load('client.login.LoginLoading')
        app.load('client.home.Menu')
        NetworkManager.register=function() return false end
        _ED.push_user_ship_info=nil
        require('shop_local').install()
        local files=cc.FileUtils:getInstance()
        local function parse(name)
            NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/shop-'..name..'.txt')})
        end
        parse('login')
        assert(_ED.free_info[3].surplus_free_number==0)
        local count=0;for _ in pairs(_ED.user_equiment) do count=count+1 end
        assert(count>0,'Equipment must survive relogin')
        protocol_command.ship_bounty.param_list='3'
        assert(protocol_command.ship_bounty.command_fun('1'):match('%d+:%d+:%d+$'),'Chest request ID missing')
        protocol_command.secret_shop_init.param_list=''
        local wire=protocol_command.secret_shop_init.command_fun('1')
        assert(wire:sub(-2)=='\r\n','Expected original empty General Shop parameter')
        protocol_command.secret_shop_refresh.param_list=''
        local refreshWire=protocol_command.secret_shop_refresh.command_fun('1')
        assert(refreshWire:match('secret_shop_refresh\r\n%d+\r\n%d+:%d+:%d+$'),'Malformed refresh request')
        app.load('client.l_digital.shop.SmShopChestStore')
        local store=SmShopChestStore:new():init(1)
        store:retain()
        for _,mode in ipairs({'single','ten','equipment'}) do
            _ED.new_reward_object={};parse(mode)
            assert(#_ED.new_reward_object==(mode=='ten' and 10 or 1),'Wrong chest result count')
            local class=mode=='ten' and TreasureChestOfferSuccessTen or TreasureChestOfferSuccess
            local result=class:new()
            result:setRanking(nil,3,true);result:retain();result:onEnterTransitionFinish()
            assert(result.roots and result.roots[1],'Chest result screen missing')
            if mode=='ten' then
                for index=1,10 do
                    local panel=ccui.Helper:seekWidgetByName(result.roots[1],'Panel_show_hero_'..index)
                    assert(not panel:getChildByName('ProjectNode_2'):getChildByName('root'):isVisible(),'Placeholder hero detail visible in chest x10')
                end
            else
                local panel=ccui.Helper:seekWidgetByName(result.roots[1],'Panel_23')
                assert(not panel:getChildByName('ProjectNode_1'):getChildByName('root'):isVisible(),'Placeholder Naruto visible in weapon chest')
                assert(ccui.Helper:seekWidgetByName(result.roots[1],'Panel_icon'):getChildrenCount()>0,'Actual chest reward icon missing')
            end
            result:release()
        end
        parse('exchange')
        parse('general')
        assert(tonumber(_ED.secret_shop_init_info.goods_count)>0,'General shop empty')
        assert(tonumber(_ED.secret_shop_init_info.goods_info[1].remain_times)==0,'Purchased stock not restored')
        app.load('client.l_digital.shop.SmShopTab')
        local tab=SmShopTab:new():init(2)
        tab:retain()
        parse('refresh')
        assert(tonumber(_ED.secret_shop_init_info.refresh_count)==1,'Refresh counter incorrect')
        assert(tonumber(_ED.secret_shop_init_info.goods_info[1].remain_times)==1,'Refreshed stock unavailable')
        tab:onUpdateDraw();tab:release()
        app.load('client.l_digital.shop.SmShopDebrisExchange')
        local exchange=SmShopDebrisExchange:new():init()
        exchange:retain();exchange:release();store:release()
        print('SHOP_LOCAL_NATIVE_PASSED single, ten, equipment, relogin and fragment exchange')
        return
    end
    if os.getenv('NR_PROBE_SKIP_UI')=='1' then
        _ED.battleData={battle_init_type=0,objId=1};_ED._scene_npc_id=1;_ED._fightModule={}
        local find=fwin.find
        local fakeFight={}
        fwin.find=function(self,name)
            if name=='FightClass' then return fakeFight end
            return find(self,name)
        end
        local button=require('tutorial_battle_skip').refresh()
        assert(button:isVisible() and button:isEnabled())
        assert(button:getTitleText()=='Pular luta do tutorial')
        print('TUTORIAL_SKIP_UI_NATIVE_PASSED visible button above guide layers')
        return
    end
    app.load('client.login.LoginLoading')
    app.load('client.home.Menu')
    if os.getenv('NR_PROBE_LEGACY_RECRUIT_UI')=='1' then
        dofile(NR_PROBE_ROOT..(os.getenv('NR_PROBE_RECRUIT_RESULTS')=='1' and 'tools/probe_recruit_results.lua' or 'tools/probe_legacy_recruit.lua'))
        return
    end
    if os.getenv('NR_PROBE_NORMAL_RECRUIT')=='1' then
        NetworkManager.register=function() return false end
        local files=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/normal-recruit-login.txt')})
        for index,name in ipairs({'one','duplicate','ten'}) do
            if index==3 and os.getenv('NR_PROBE_RECRUIT_SINGLE_UI')=='1' then break end
            _ED.new_reward_object={};_ED.new_prop_object={};_ED.recruit_success_ship_ids=''
            NetworkProtocol.parser_func({resouce=files:getStringFromFile(NR_PROBE_ROOT..'build/normal-recruit-'..name..'.txt')})
            assert(#_ED.new_reward_object==(index==3 and 10 or 1),'Recruit results incomplete')
            if index==1 then assert(_ED.new_reward_object[1].m_type==13) end
            if index==2 then assert(_ED.new_reward_object[1].m_type==6 and #_ED.new_prop_object==1) end
        end
        local count=0;for _ in pairs(_ED.user_ship) do count=count+1 end
        local single=os.getenv('NR_PROBE_RECRUIT_SINGLE_UI')=='1'
        assert(count==(single and 4 or 5) and _ED.newRecruitInfo.cur_draw_times==(single and 2 or 12))
        assert(tonumber(_ED.user_info.user_gold)==(single and 99760 or 97480))
        assert(executeMissionExt(mission_mould_tuition)==false and missionIsOver()==true)
        if os.getenv('NR_PROBE_RECRUIT_UI')=='1' then
            app.load(single and 'client.shop.recruit.HeroRecruitSuccess' or 'client.shop.recruit.HeroRecruitSuccessTen')
            local results=single and HeroRecruitSuccess:new() or HeroRecruitSuccessTen:new()
            results:setRanking(nil,15,true)
            results:retain()
            results:onEnterTransitionFinish()
            assert(results.roots and results.roots[1],'Result screen failed to initialize')
            assert(results.__nr_opening_pending and not results.__nr_opening_finished,'Opening must not reveal during its synchronous start callback')
            local opening=assert(results.__nr_opening_node,'Original opening Spine missing')
            opening:retain()
            local animation=opening.animationNameList[opening._actionIndex+1]
            local duration=opening:getAnimationDurationEx(animation)
            cc.nrSpineCommand(opening,'advance',math.min(.01,duration/4))
            assert(results.__nr_opening_pending,'Results appeared before the original animation finished')
            for tick=1,math.ceil((duration+.1)*60) do
                if not results.__nr_opening_finished then cc.nrSpineCommand(opening,'advance',1/60) end
            end
            assert(results.__nr_opening_finished and not results.__nr_opening_pending,'Original completion must reveal results')
            opening:release()
              if not single then
                  for index,data in ipairs(results.recruitment_data) do
                      if tonumber(data.m_type)==13 then results.heroIndex=index;break end
                  end
                  results:openNewShowActionSpecial()
                  results:changeHeroAnimation(0,results.heroIndex)
                  local hero=assert(results.hero_animations[results.heroIndex].hero)
                  local p=hero:convertToWorldSpace(cc.p(0,0))
                  print('RECRUIT_DETAIL_POSITION',p.x,p.y,hero:isVisible(),hero:getParent():isVisible())
                  results.heroIndex=results.number
                  results:closePageEvent()
                  local summary=assert(results.__nr_ten_summary,'Ten-result summary missing')
                  assert(summary:getChildrenCount()==10,'Summary must display all ten rewards')
                  results:closePageEvent()
                  assert(results.__nr_ten_summary==summary,'Summary must not duplicate on repeated completion')
                  for index=1,results.number do
                      assert(not ccui.Helper:seekWidgetByName(results.roots[1],'Panel_show_hero_'..index):isVisible(),'Detail overlay remained over final results')
                  end
              end
            results:release()
        end
        print('NORMAL_RECRUIT_NATIVE_PASSED x1, duplicate fragments, ten results, counters, gold, tutorial off')
        return
    end
    if os.getenv('NR_PROBE_DIRECT_MENU')=='1' then
        local fu=cc.FileUtils:getInstance()
        if os.getenv('NR_PROBE_COLD_STATES')=='1' then
            _ED.scene_current_state=nil;_ED.scene_max_state=nil;_ED.npc_state=nil
        end
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(os.getenv('NR_PROBE_LOGIN_REPLY') or NR_PROBE_ROOT..'build/direct-menu-login.txt')})
        local owned={};local count=0
        for _,hero in pairs(_ED.user_ship) do owned[hero.ship_template_id]=true;count=count+1 end
        assert(count==tonumber(os.getenv('NR_PROBE_EXPECT_HEROES') or '3') and owned['13'] and owned['35'] and owned['50'])
        local active=0
        for position=1,6 do
            local id=_ED.formetion[position+1]
            if id and id~='0' then
                assert(_ED.user_ship[id].formation_index==tostring(position),'Occupied slot missing from active hero count')
                active=active+1
            end
        end
        assert(active==3,'Starter formation does not count all three characters')
        if os.getenv('NR_PROBE_EXPECT_ITEMS') then
            assert(tonumber(getPropAllCountByMouldId(68))==3 and tonumber(getPropAllCountByMouldId(69))==7,'Login inventory fields shifted')
        end
        assert(tonumber(_ED.user_info.user_experience)>0 and _ED.user_info.user_food==(os.getenv('NR_PROBE_EXPECT_FOOD') or '60'))
        if os.getenv('NR_PROBE_EXPECT_LEVEL') then
            assert(_ED.user_info.user_grade==os.getenv('NR_PROBE_EXPECT_LEVEL'))
            assert(_ED.user_info.user_silver=='900000000' and _ED.user_info.user_gold=='1000000')
        end
        assert(type(_ED.scene_current_state)=='table' and #_ED.scene_current_state==500)
        assert(require('catalogo_ninjas').instalar())
        local missing,synth=HeroListView.getUnlockedShip({})
        assert(#missing>0,'Unowned Ninja catalog must not be empty with zero fragments')
        for _,prop in ipairs(missing) do
            local row=dms.element(dms['prop_mould'],prop)
            local mould=tostring(dms.atoi(row,40))
            assert(not owned[mould],'Owned Ninja leaked into the unowned catalog')
        end
        print('UNOWNED_CATALOG_NATIVE_PASSED',#missing,#synth)
        assert(type(_ED.daily_task_draw_index)=='table','Daily reward indices must be a list before Home opens')
        app.load('client.notification.push_notification_activity')
        assert(getActivityActivePush()==false,'Empty local daily tasks must not offer a reward')
        assert(executeMissionExt(mission_mould_tuition)==false)
        assert(executeMissionExt(mission_mould_battle)==false)
        assert(missionIsOver()==true)
        if os.getenv('NR_PROBE_LOGIN_ONLY')=='1' then
            NetworkProtocol.parser_func({resouce='2 user_info_modify 0 12033 '.._ED.user_info.user_id..' Ninja&nbsp;&amp;&nbsp;Teste'})
            assert(_ED.user_info.user_name=='Ninja & Teste','Rename response must update the displayed name')
            app.load('client.home.Home')
            local homeLayout=assert(csb.createNode('home/home_button.csb'))
            local homeRoot=assert(homeLayout:getChildByName('root'))
            local homeStub={roots={homeRoot}}
            Home.hideLocalPromotionShortcuts(homeStub)
            assert(#homeStub._localPromotionNodes>=3,'Promotion shortcut widgets missing from layout')
            assert(not ccui.Helper:seekWidgetByName(homeRoot,'Button_gm_connect'):isVisible(),'FAQ must be hidden')
            for _,node in ipairs(homeStub._localPromotionNodes) do assert(not node:isVisible() and not node:isTouchEnabled()) end
            local desktop=require('desktop_layout')
            assert(desktop.translate('Name was successfully modified')=='Nome alterado com sucesso')
            local layoutEntry=assert(desktop.entries[homeLayout])
            assert(layoutEntry.bottomArrow and layoutEntry.rightArrow,'Both fold arrows must be present')
            desktop.toggle(homeLayout,'bottom')
            for _,item in ipairs(layoutEntry.items) do
                if item.kind=='bottom' then
                    assert(item.node:isVisible()==(item.order==1 or item.order>=8),'Trial/Adventure must remain independent of the folded group')
                    if item.order>=8 then
                        local n=item.node;local s=n:getContentSize()
                        local center=homeLayout:convertToNodeSpace(n:convertToWorldSpace(cc.p(s.width/2,s.height/2)))
                        local expected=item.order==8 and 836 or 912
                        assert(math.abs(center.x-expected)<.1,'Trial/Adventure must form the compact right-hand group')
                    end
                end
            end
            desktop.toggle(homeLayout,'bottom')
            desktop.toggle(homeLayout,'right')
            for _,item in ipairs(layoutEntry.items) do
                if item.kind=='right' then assert(item.node:isVisible()==(item.name=='Button_sign'),'Folded sidebar must leave only Sign in') end
            end
            desktop.toggle(homeLayout,'right')
            assert(not ccui.Helper:seekWidgetByName(homeRoot,'Panel_effice_piaoluo'):isVisible(),'Seasonal flakes must be hidden')
            local header=assert(csb.createNode('player/user_information.csb'))
            local headerEntry=assert(desktop.entries[header]);local adjustedHeader=0
            for _,item in ipairs(headerEntry.items) do
                if item.kind=='resources' then
                    adjustedHeader=adjustedHeader+1
                    local n=item.node;local a=n:getAnchorPoint();local h=n:getContentSize().height
                    local before=item.py+(.5-a.y)*h*item.sy
                    local after=n:getPositionY()+(.5-a.y)*h*n:getScaleY()
                    assert(math.abs(after-before+18)<.01 and math.abs(n:getScaleY()-item.sy*.96)<.01,'Each currency must retain the lower row and updated size')
                elseif item.kind=='profileText' then
                    assert(item.node:getPositionY()==item.py,'Name and Power must keep their original height')
                end
            end
            assert(adjustedHeader==3,'All three currency widgets must be adjusted')
            desktop.apply(homeLayout,layoutEntry,1280)
            assert(math.abs(homeLayout:getPositionX()-layoutEntry.x-160)<.01)
            local heroLayout=assert(csb.createNode('home/home_juese.csb'))
            local heroEntry=assert(desktop.entries[heroLayout])
            local actorCount,backgroundCount=0,0
            for _,item in ipairs(heroEntry.items) do
                if item.kind=='hero' then actorCount=actorCount+1 end
                if item.kind=='background' then backgroundCount=backgroundCount+1 end
            end
            assert(actorCount==6 and backgroundCount>=1,'Desktop layout must adapt all six actors and the real background')
            desktop.apply(heroLayout,heroEntry,1280)
            for _,path in ipairs({'packs/HeroStorage/generals_list_sui.csb','packs/warehouse_list.csb','shop/shop_1.csb'}) do
                local before=cc.Director:getInstance():getOpenGLView():getFrameSize()
                local screen=assert(csb.createNode(path),'Full-screen layout failed: '..path)
                local after=cc.Director:getInstance():getOpenGLView():getFrameSize()
                assert(before.width==after.width and before.height==after.height,'Opening screens must preserve the selected window size')
                local function noCaption(n)
                    assert(n:getName()~='__desktop_caption','Extra caption boxes must remain removed')
                    for _,child in ipairs(n:getChildren()) do noCaption(child) end
                end
                noCaption(screen)
            end
            local view=cc.Director:getInstance():getOpenGLView()
            for _,size in ipairs({{960,640},{1280,720},{1280,800},{800,600}}) do
                view:setFrameSize(size[1],size[2])
                view:setDesignResolutionSize(960,640,cc.ResolutionPolicy.EXACT_FIT)
                local frame=view:getFrameSize();local viewport=view:getViewPortRect()
                assert(math.abs(viewport.x)<.01 and math.abs(viewport.y)<.01,'Viewport must have no unused margins')
                assert(math.abs(viewport.width-frame.width)<1 and math.abs(viewport.height-frame.height)<1,'Every scene must fill the client area')
                desktop.apply(heroLayout,heroEntry,960)
                local correction=desktop.aspectCorrection()
                for _,item in ipairs(heroEntry.items) do
                    if item.kind=='hero' then
                        assert(math.abs((item.node:getScaleX()/item.sx)/(item.node:getScaleY()/item.sy)-correction)<.001,'Home actor must retain physical proportions')
                    end
                end
                local portrait=assert(csb.createNode('packs/HeroStorage/sm_list_generals_big.csb'))
                local previousX=portrait:getPositionX()
                desktop.preserve(portrait)
                assert(math.abs(portrait:getScaleX()-correction)<.001,'Ninja card must compensate viewport stretch')
                assert(portrait:getPositionX()==previousX+18,'Ninja cards must shift right without moving the window')
            end
            assert(not csb.createNode('Chat/chat_home_window.csb'):isVisible(),'Compact chat panel must be hidden')
            NetworkProtocol.parser_func({resouce='2 trigger_scene_surprise 0 12561 5 9999999999999 12562 1 171 1 0'})
            assert(_ED.every_day_online_reward_times==5)
            app.load('client.notification.push_notification_cultivate')
            getCultivateSpiritPush()
            _ED.digital_talent_page_is_lock=nil
            assert(getCultivateTalentPush()==0,'Uninitialized talents must not interrupt formation notifications')
            _ED.user_artifact_achieve_info=nil
            assert(getCultivateAchieveBtnPush(1)==false,'Missing achievements must not interrupt character touches')
            assert(type(_ED._add_enger_info)=='string' and #zstring.split(_ED._add_enger_info,'|')==4,'Home energy data missing before entering menu')
            NetworkProtocol.parser_func({resouce='2 get_web_recharge_state 0 476 0 0'})
            assert(_ED.webRechargeState==0,'Local web recharge state not initialized')
            print('LOGIN_LAYOUT_NATIVE_PASSED original header, items, characters, metadata and formation')
            return
        end
        -- Diagnostic profile has no real session; do not send its menu
        -- notification requests to the player's live server.
        NetworkManager.register=function()return false end
        state_machine.excute('menu_window_open_mission',0,0)
        assert(fwin:find('MenuClass') and not fwin:find('FightLoadingCellClass'))
        assert(not fwin:find('TuitionControllerClass'))
        print('DIRECT_MENU_NATIVE_PASSED menu, three fixed heroes, no tutorial or introductory loading')
        return
    end
    if os.getenv('NR_PROBE_CHEST_TEST')=='1' then
        local fu=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/chest-test-login.txt')})
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/chest-test-reply.txt')})
        assert(_ED.user_info.user_silver=='6000' and _ED.user_info.user_gold=='50')
        assert(tonumber(getPropAllCountByMouldId(68))==5 and tonumber(getPropAllCountByMouldId(57))==10)
        assert(_ED.star_reward_state[1]=='1' and tonumber(_ED.scene_max_state[2])==0)
        print('SCENE_CHEST_NATIVE_PASSED original currency/inventory/reward parsers, received flag, next chapter unlocked')
        return
    end
    if os.getenv('NR_PROBE_FORMATION_SIX')=='1' then
        local fu=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/formation-six-login.txt')})
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/formation-six-reply.txt')})
        assert(_ED.user_comb_can_filed_mould_num=='0','Original combo-card limit missing')
        local seen={}
        for i=1,6 do
            local ship=_ED.user_formetion_status[i]
            assert(ship and ship~='0' and not seen[ship] and _ED.user_ship[ship])
            assert(_ED.formetion[i+1]==ship,'Formation response overwrote the six-slot snapshot')
            assert(_ED.user_ship[ship].formation_index==tostring(i),'Hero in sixth slot omitted or assigned incorrect formation position')
            seen[ship]=true
        end
        print('FORMATION_SIX_NATIVE_PASSED six distinct heroes, original response, combo count and relogin')
        return
    end
    if os.getenv('NR_PROBE_SYNTHESIS_TEST')=='1' then
        local fu=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/synthesis-test-login.txt')})
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/synthesis-test-reply.txt')})
        local ship=assert(_ED.recruit_success_ship_id,'Synthesis callback character missing')
        assert(_ED.user_ship[ship] and _ED.user_ship[ship].ship_template_id=='1')
        assert(tonumber(getPropAllCountByMouldId(2))==0,'Consumed fragments remained in inventory')
        print('SYNTHESIS_NATIVE_PASSED original parser, callback character, fragments and relogin')
        return
    end
    if os.getenv('NR_PROBE_SAVED_RESUME')=='1' then
        local path=assert(os.getenv('NR_PROBE_LOGIN_REPLY'))
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(path)})
        local saved=require('tutorial_resume').checkpoint
        assert(saved and saved.group==tonumber(os.getenv('NR_PROBE_EXPECT_GROUP')),'Saved lesson was not restored')
        assert(_ED.user_info.user_id==os.getenv('NR_PROBE_EXPECT_ACCOUNT'),'Wrong restored identity')
        assert(_ED.user_formetion_status[2] and _ED.user_ship[_ED.user_formetion_status[2]],'Initial hero missing after login')
        print('SAVED_PROFILE_NATIVE_PASSED identity, checkpoint, inventory and formation parsed')
        return
    end
    if os.getenv('NR_PROBE_FORMATION_LIFETIME')=='1' then
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(NR_PROBE_ROOT..'build/hero-training-login.txt')})
        app.load('client.formation.FormationTigerGate')
        local ship=_ED.user_ship[_ED.user_formetion_status[2]]
        state_machine.excute('formation_open_instance_window',0,{_datas={_shipInstance=ship,_enter_type='home'}})
        assert(_ED.user_info.user_fight=='6','Formation seats differ from original table')
        print('FORMATION_OPEN_NATIVE_PASSED')
        return
    end
    if os.getenv('NR_PROBE_HERO_RESTORE')=='1' then
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(NR_PROBE_ROOT..'build/hero-training-after.txt')})
        local ship=_ED.user_formetion_status[2]
        assert(_ED.user_ship[ship].Order=='1' and _ED.user_info.user_silver=='198')
        assert(tonumber(getPropAllCountByMouldId(68))==0,'Consumed training material returned after login')
        print('HERO_TRAINING_RESTORE_PASSED quality, balance, consumed resources and starter restored')
        return
    end
    if os.getenv('NR_PROBE_HERO_TRAINING')=='1' then
        local fu=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/hero-training-login.txt')})
        local ship=_ED.user_formetion_status[2]
        assert(ship and _ED.user_ship[ship].ship_template_id=='13','Initial Naruto missing')
        local sprite=cc.Sprite:create('images/face/big_head/big_head_110201.png')
        local originalProgram=sprite:getProgramState():getProgram():getProgramType()
        cc.setGray(sprite)
        assert(sprite:getProgramState():getProgram():getProgramType()==15)
        gray.removeGray(sprite)
        assert(sprite:getProgramState():getProgram():getProgramType()==originalProgram)
        local layer=cc.Layer:create();layer:setTouchEnabled(true);layer:setTouchEnabled(false)
        print('HERO_UI_NATIVE_PASSED real grayscale shader, restore and touch blocker')
        app.load('client.packs.hero.SmRoleStrengthenTabUpProduct')
        app.load('client.packs.hero.GeneralsStarUpSuccessWindow')
        local register=NetworkManager.register
        NetworkManager.register=function(self,code,a,b,c,node,callback,...)
            if code==protocol_command.ship_grow_up.code then
                NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/hero-training-upgrade.txt')})
                callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0,node=node})
                assert(_ED.user_ship[ship].Order=='1')
                assert(fwin:find('GeneralsStarUpSuccessWindowClass'),'Quality result did not open')
                print('HERO_TRAINING_NATIVE_PASSED original upgrade callback, consumed resources, quality result')
            else return register(self,code,a,b,c,node,callback,...) end
        end
        state_machine.excute('sm_role_strengthen_tab_up_product_open',0,{nil,ship})
        fwin:addService({delay=0,callback=function()
            local window=fwin:find('SmRoleStrengthenTabUpProductClass')
            assert(window.materialEnough and window.goodsEnough and window.levelEnough)
            state_machine.excute('sm_role_strengthen_tab_up_product_request',0,0)
        end})
        return
    end
    if os.getenv('NR_PROBE_RECRUIT_RESTORE')=='1' then
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(NR_PROBE_ROOT..'build/recruit-test-relogin.txt')})
        local id=_ED.user_formetion_status[6]
        assert(id and _ED.user_ship[id] and _ED.user_ship[id].ship_template_id=='50')
        assert(_ED.newRecruitInfo.free_times==0 and _ED.newRecruitInfo.cur_draw_times==1)
        print('RECRUITMENT_RELOGIN_NATIVE_PASSED saved Sakura and formation restored')
        return
    end
    if os.getenv('NR_PROBE_GUIDE_TEST')=='1' then
        local scene=cc.Director:getInstance():getRunningScene()
        NetworkProtocol.parser_func({resouce=cc.FileUtils:getInstance():getStringFromFile(NR_PROBE_ROOT..'build/recruit-test-login.txt')})
        app.load('client.shop.newrecruit.NewRecruitMain')
        state_machine.excute('new_recruit_main_window_open',0,0)
        local guide=csb.createNode('utils/teaching.csb')
        scene:addChild(guide,9999)
        local root=guide:getChildByName('root')
        local panel=ccui.Helper:seekWidgetByName(root,'Panel_4')
        panel:setTouchEnabled(true)
        require('tutorial_guide_visual').apply({roots={root}})
        assert(panel:getBackGroundColorOpacity()==0 and panel:isTouchEnabled())
        local rim=ccui.Helper:seekWidgetByName(root,'Image_1')
        assert(rim and rim:getOpacity()==0,'Black corner mask still visible')
        print('TUTORIAL_GUIDE_NATIVE_PASSED transparent mask with input geometry preserved')
        return
    end
    if os.getenv('NR_PROBE_RECRUIT_TEST')=='1' then
        local fu=cc.FileUtils:getInstance()
        NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/recruit-test-login.txt')})
        app.load('client.shop.newrecruit.NewRecruitMain')
        local register=NetworkManager.register
        NetworkManager.register=function(self,code,a,b,c,node,callback,...)
            if code==protocol_command.new_recruitment_system.code then
                NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/recruit-test-draw.txt')})
                assert(_ED.recruit_success_ship_id and _ED.user_ship[_ED.recruit_success_ship_id])
                NetworkProtocol.parser_func({resouce=fu:getStringFromFile(NR_PROBE_ROOT..'build/recruit-test-formation.txt')})
                assert(_ED.user_formetion_status[6]==_ED.recruit_success_ship_id)
                print('RECRUITMENT_FORMATION_NATIVE_PASSED persisted hero in original formation parsers')
                callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0,node=node})
                assert(fwin:find('HeroRecruitSuccessClass'),'Original reward window did not open')
                print('RECRUITMENT_NATIVE_PASSED original Draw x1 callback and obtained hero window')
                fwin:addService({delay=0,callback=function()
                    local reward=fwin:find('HeroRecruitSuccessClass')
                    local function advance(node)
                        local children=node:getChildren()
                        if node.__nrSpineHandlers then cc.nrSpineCommand(node,'advance',10) end
                        if node.getAnimation then
                            local animation=node:getAnimation()
                            if animation and animation.setSpeedScale then animation:setSpeedScale(100) end
                        end
                        for _,child in ipairs(children) do if not tolua.isnull(child) then advance(child) end end
                    end
                    for _,root in ipairs(reward.roots or {}) do advance(root) end
                    print('RECRUITMENT_NATIVE animation advanced through real completion callback')
                end})
            else return register(self,code,a,b,c,node,callback,...) end
        end
        state_machine.excute('new_recruit_main_window_open',0,0)
        local opening=HeroRecruitSuccess.playOpeningAnimation
        local show=HeroRecruitSuccess.ShowUI
        HeroRecruitSuccess.ShowUI=function(self,...)
            local result={show(self,...)}
            if self.hero_animation then
                assert(self.hero_animation:isVisible() and self.hero_animation:getOpacity()>0)
                assert(cc.nrSpineCommand(self.hero_animation,'geometry')>0,'Reward character has no geometry before touch')
                print('RECRUIT_HERO_VISIBLE_NATIVE_PASSED original hero sampled before any tap')
            end
            return unpack(result)
        end
        HeroRecruitSuccess.playOpeningAnimation=function(self,panel,completion)
            return opening(self,panel,function(node)
                completion(node)
                assert(ccui.Helper:seekWidgetByName(self.roots[1],'Panel_icon'):isVisible())
                print('RECRUITMENT_CONFIRM_NATIVE_PASSED original animation finished; obtained hero revealed')
            end)
        end
        fwin:addService({delay=0,callback=function()
            print('RECRUITMENT_NATIVE attempting original draw')
            state_machine.excute('new_recruit_main_get_reward',0,{_datas={times=1,m_type=1}})
        end})
        return
    end
    if os.getenv('NR_PROBE_LOGIN_REPLY') then
        -- A cold login has no parsed scene tables. Do not let the map fixture
        -- conceal ordering dependencies between the actual protocol parsers.
        _ED.scene_max_state='';_ED.scene_current_state=''
        print('COLD_LOGIN_FORMULA_BEFORE '..type(getUserFight))
        local text=cc.FileUtils:getInstance():getStringFromFile(os.getenv('NR_PROBE_LOGIN_REPLY'))
        NetworkProtocol.parser_func({resouce=text})
        assert(type(_ED.scene_max_state)=='table','Login did not initialize scenes')
        assert(type(_ED.npc_state)=='table','Login did not initialize NPCs')
        assert(type(getUserFight)=='function','Profile dependency not loaded by runtime adapter')
        assert(_ED.user_info.user_grade=='3','Login lost persisted grade')
        print('COLD_LOGIN_NATIVE_PASSED full original login and ordered scene/NPC parsers')
        return
    end
    if os.getenv('NR_PROBE_CAMPAIGN_REPLY') then
        local text=cc.FileUtils:getInstance():getStringFromFile(os.getenv('NR_PROBE_CAMPAIGN_REPLY'))
        local tokens={}
        for value in text:gmatch('%S+') do tokens[#tokens+1]=value end
        NetworkProtocol.parser_func({resouce_serializer=tokens})
        assert(_ED.user_info.user_grade=='2','Victory did not reach original level-up parser')
        assert(_ED.scene_current_state[1]=='1','Victory did not reach original map parser')
        assert(tonumber(_ED.npc_state[1])>0,'Cleared NPC would replay its battle tutorial')
        print('CAMPAIGN_REPLY_NATIVE_PASSED original level, NPC and scene parsers')
    end
    print('MENU_BOOT_PROBE module loaded')
    do
        local passed,trace=xpcall(function()
            state_machine.excute('menu_window_open_mission',0,0)
        end,debug.traceback)
        print('MENU_BOOT_PROBE_TRANSITION '..tostring(passed)..' '..tostring(trace))
    end
end,debug.traceback)
print('MENU_BOOT_PROBE_RESULT '..tostring(ok)..' '..tostring(err))
if os.getenv('NR_PROBE_LEGACY_RECRUIT_UI')=='1' then
    local result=assert(io.open(NR_PROBE_ROOT..'build/legacy-recruit-native/result.txt','w'))
    result:write(tostring(ok)..' '..tostring(err));result:close()
end
if os.getenv('NR_PROBE_QUICK_UPGRADES')=='1' or os.getenv('NR_PROBE_TREASURE')=='1' or os.getenv('NR_PROBE_EQUIPMENT_DEVELOPMENT')=='1' or os.getenv('NR_PROBE_SAGA_UI')=='1' then
    local name=os.getenv('NR_PROBE_SAGA_UI')=='1' and 'saga-ui' or (os.getenv('NR_PROBE_EQUIPMENT_DEVELOPMENT')=='1' and 'equipment-development' or (os.getenv('NR_PROBE_TREASURE')=='1' and 'treasure' or 'quick-upgrades'))
    local result=assert(io.open(NR_PROBE_ROOT..'build/'..name..'-native-result.txt','w'))
    result:write(tostring(ok)..' '..tostring(err));result:close()
end
return ok and 1 or 0
