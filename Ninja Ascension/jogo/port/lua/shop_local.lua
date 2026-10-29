-- Local weapon-shop state, separate from recruitment/tutorial protocols.
local M={}
local function historyValue(ship)
    return ship.ship_health..ship.ship_wisdom..ship.ship_leader..ship.ship_courage..ship.ship_intellect..ship.ship_quick
end
function M.applyStats(ship,info)
    if ship.history_info then
        assert(aeslua.decrypt('jar-world',ship.history_info,aeslua.AES128,aeslua.ECBMODE)==historyValue(ship),'Character state changed outside server update')
    end
    for _,key in ipairs({'health','courage','intellect','quick'}) do
        ship['ship_'..key]=math.floor(info[key])
        ship['ship_base_'..key]=info[key]
    end
    if info.speed~=nil then ship.ship_wisdom=tostring(info.speed) end
    ship.history_info=aeslua.encrypt('jar-world',historyValue(ship),aeslua.AES128,aeslua.ECBMODE)
end
function M.refreshPower()
    if not _ED or not _ED.user_ship or not calPowerForNotOwn then return end
    local total=0
    for _,ship in pairs(_ED.user_ship) do
        if ship.skillLevel and ship.StarRating then ship.hero_fight=tostring(calPowerForNotOwn(ship)) end
    end
    for i=2,7 do
        local id=_ED.formetion and _ED.formetion[i]
        local ship=id and _ED.user_ship[tostring(id)]
        if ship then total=total+(tonumber(ship.hero_fight) or 0) end
    end
    _ED.user_info.fight_capacity=tostring(total)
    M.totalPower=total
    local header=fwin and fwin:find('UserInformationClass')
    if header and header.setLocalPower then header:setLocalPower(total) end
end
function M.install()
    -- Power gain toast: CombatEffectivenessUp:onInit opens
    -- config_csb.utils.fight_up, but res/configs/csb/config.lua is not loaded
    -- in normal play, so the original window (bitmap font + animation) was
    -- replaced by the plain white fallback label. Point it at the original csb.
    local powerUp=rawget(_G,'CombatEffectivenessUp')
    if powerUp and powerUp.onInit and not powerUp.__nr_csb then
        powerUp.__nr_csb=true
        local onInit=powerUp.onInit
        powerUp.onInit=function(self,...)
            config_csb=rawget(_G,'config_csb') or {}
            config_csb.utils=config_csb.utils or {}
            config_csb.utils.fight_up=config_csb.utils.fight_up or "utils/fight_up.csb"
            config_csb.utils.fight_down=config_csb.utils.fight_down or "utils/fight_down.csb"
            return onInit(self,...)
        end
    end
    -- "Avanço rápido" (SmAutoUpProduct.lua:291) uses ShipIconCell without
    -- loading it; load client/cells/ship/ship_icon_cell.lua before it opens.
    local autoUp=rawget(_G,'SmAutoUpProduct')
    if autoUp and autoUp.onInit and not autoUp.__nr_ship_icon then
        autoUp.__nr_ship_icon=true
        local onInit=autoUp.onInit
        autoUp.onInit=function(self,...)
            if rawget(_G,'ShipIconCell')==nil then app.load("client.cells.ship.ship_icon_cell") end
            return onInit(self,...)
        end
    end
    -- Use/open item windows set the max to the whole stack and pre-select it
    -- (ComExchange.lua:790/802, SmPropChoose.lua:468). The server opens at
    -- most 999 per request (prop_use_local.py), so the selector stops there.
    for _,className in ipairs({'ComExchange','SmPropChoose','SmPropWarehouseBatchUse'}) do
        local cls=rawget(_G,className)
        if cls and cls.setSelectNum and not cls.__nr_use_cap then
            cls.__nr_use_cap=true
            local setSelectNum=cls.setSelectNum
            cls.setSelectNum=function(self,num,...)
                if tonumber(self._max_select_num) and tonumber(self._max_select_num)>999 then self._max_select_num=999 end
                if tonumber(num) and tonumber(num)>999 then num=999 end
                return setSelectNum(self,num,...)
            end
        end
    end
    -- Ranking window reads the 1st place of the clan list (page 5) without a
    -- nil check (SmRankingMainInterface.lua:523/335); with no clan on the
    -- server the list is empty and the window crashed. Skip those draws then.
    local rankWindow=rawget(_G,'SmRankingMainInterface')
    if rankWindow and not rankWindow.__nr_empty_guard then
        rankWindow.__nr_empty_guard=true
        for _,name in ipairs({'updateDrawIcon','UpdateDrawLeftInterface'}) do
            local original=rankWindow[name]
            if original then
                rankWindow[name]=function(self,...)
                    local list=_ED.union and _ED.union.rank_union_list_info
                    if tonumber(self._current_page)==5 and (list==nil or list[1]==nil) then return end
                    return original(self,...)
                end
            end
        end
    end
    -- Main quest (achievement_list_cell_new.lua:505-506) shows achieve.txt
    -- title/description as stored, and the language files escape spaces as
    -- "&nbsp;". dms keeps each row as its text line until dms.element splits
    -- it, so the lines are unescaped once, right after the table loads.
    local achieveRows=rawget(_G,'dms') and rawget(dms,'achieve')
    if type(achieveRows)=='table' and package.__nr_achieve_text~=achieveRows then
        package.__nr_achieve_text=achieveRows
        for i,line in pairs(achieveRows) do
            if type(line)=='string' then
                achieveRows[i]=line:gsub('&nbsp;',' '):gsub('&amp;','&')
            elseif type(line)=='table' then
                for k,v in pairs(line) do
                    if type(v)=='string' then line[k]=v:gsub('&nbsp;',' '):gsub('&amp;','&') end
                end
            end
        end
    end
    -- Shamanism 10x: SmCultivateArtifactChoose is a child of Panel_tab_1 but
    -- also lives in fwin._list. openResult() clears the panel with
    -- removeAllChildren(true), freeing the node while fwin.updateLua keeps
    -- calling its onUpdate -> native crash right after confirming. Close it
    -- through fwin first (also lets the next 10x open a fresh list).
    local artifactWindow=rawget(_G,'SmCultivateArtifactWindow')
    if artifactWindow and not artifactWindow.__nr_close_choose then
        artifactWindow.__nr_close_choose=true
        local openResult=artifactWindow.openResult
        artifactWindow.openResult=function(self,...)
            local choose=fwin:find('SmCultivateArtifactChooseClass')
            if choose~=nil then fwin:close(choose) end
            return openResult(self,...)
        end
    end
    if not NetworkProtocol or not NetworkProtocol.protocol_parses then return end
    if not NetworkProtocol.find_parser(15997) then
        table.insert(NetworkProtocol.protocol_parses,{code=15997,parser='local_ninja_school',parser_fun=function(_,_,_,_,list)
            local values=json.decode(npos(list))
            -- Per-ninja spirit text is authoritative server state: always apply it.
            local spirits=values.local_ship_spirit
            values.local_ship_spirit=nil
            if type(spirits)=='table' and _ED.user_ship then
                for id,text in pairs(spirits) do
                    local ship=_ED.user_ship[tostring(id)]
                    if ship then ship.shipSpirit=text end
                end
            end
            -- Index cards are persisted server state (index_local.py): always apply.
            if values.illustration_info_init~=nil then
                _ED.illustration_info_init=values.illustration_info_init
                values.illustration_info_init=nil
            end
            -- Initialize absent collections; never erase inventory already parsed.
            for key,value in pairs(values) do
                if _ED[key]==nil then _ED[key]=value end
            end
            if constellationRedotData then constellationRedotData() end
        end})
    end
    if not NetworkProtocol.find_parser(15990) then
        table.insert(NetworkProtocol.protocol_parses,{code=15990,parser='local_shop',parser_fun=function(_,_,_,_,list)
            local info=require('fast_json').decode(npos(list))
            _ED.user_equiment=_ED.user_equiment or {}
            for _,id in ipairs(info.removedEquipment or {}) do
                _ED.user_equiment[tostring(id)]=nil
            end
            for _,equip in ipairs(info.equipment or {}) do
                _ED.user_equiment[tostring(equip.user_equiment_id)]=equip
            end
            -- Compact form [rowid, mould]: rebuild the same object the server
            -- used to send (shop_local.py equipment()) from equipment_mould.
            if info.equipmentCompact and dms["equipment_mould"]==nil then dms.load("data/mould/equipment_mould.txt") end
            for _,pair in ipairs(info.equipmentCompact or {}) do
                local id=tostring(2000000000+tonumber(pair[1]))
                local r=dms.element(dms["equipment_mould"],tonumber(pair[2])) or {}
                local function c(n) return tostring(r[n+1] or '0') end
                local equip={user_equiment_id=id,user_equiment_template=tostring(pair[2]),
                    user_equiment_name=c(1),sell_price=c(11),user_equiment_influence_type=c(3),equipment_type=c(4),
                    user_equiment_ability=c(5),user_equiment_grade=c(27),user_equiment_exprience='0',
                    user_equiment_growup_grade='0',growup_value='0',adorn_need_ship=c(10),equiment_picture=c(16),
                    equiment_track_remark=c(18),equiment_track_scene=c(19),equiment_track_npc=c(20),
                    equiment_track_npc_index=c(21),ship_id='0',grow_level=c(8),equiment_refine_param='0',
                    current_star_level=c(7),current_star_exp='0',add_attribute='0',luck_value=0}
                for _,field in ipairs({'equiment_refine_level','refining_times','prop_timestamp','refining_value_life',
                    'refining_value_temp_life','refining_value_attack','refining_value_temp_attack',
                    'refining_value_physical_defence','refining_value_temp_physical_defence','refining_value_skill_defence',
                    'refining_value_temp_skill_defence','refining_value_final_damange','refining_value_temp_final_damange',
                    'refining_value_final_lessen_damange','refining_value_temp_final_lessen_damange'}) do equip[field]='0' end
                _ED.user_equiment[id]=equip
            end
            local count=0
            for _ in pairs(_ED.user_equiment) do count=count+1 end
            _ED.user_equiment_number=count
            _ED.free_info=_ED.free_info or {}
            _ED.free_info[3]=_ED.free_info[3] or {}
            local free=_ED.free_info[3]
            free.surplus_free_number=tonumber(info.free)
            free.next_free_time=0;free.free_start=os.time()
            free.first_satus=1
            _ED.user_accumulate_camp_god=tonumber(info.draws)
            if info.results then
                _ED.new_reward_object=info.results
                _ED.new_prop_object={}
                _ED.recruit_success_ship_id='0'
                for _,reward in ipairs(info.results) do
                    if tonumber(reward.m_type)==6 then
                        table.insert(_ED.new_prop_object,{user_prop_id=tostring(reward.mould_id),number=reward.number})
                    end
                end
            end
        end})
    end
    if not NetworkProtocol.find_parser(15991) then
        table.insert(NetworkProtocol.protocol_parses,{code=15991,parser='local_special_shop',parser_fun=function(_,_,_,_,list)
            local info=json.decode(npos(list))
            _ED.local_special_shop=true
            _ED.union=_ED.union or {}
            _ED.union.user_union_info=_ED.union.user_union_info or {}
            _ED.union.union_shop_info=_ED.union.union_shop_info or {}
            _ED.union.union_shop_info.treasure=_ED.union.union_shop_info.treasure or {}
            if info.clan then
                _ED.union.union_info=_ED.union.union_info or {}
                _ED.union.union_info.union_id=tostring(info.clan.id)
                _ED.union.union_info.union_name=(info.clan.nameHex or ''):gsub('%x%x',function(pair) return string.char(tonumber(pair,16)) end)
                _ED.union.user_union_info.union_last_enter_time=0
            elseif info.clan==false then
                _ED.union.union_info=_ED.union.union_info or {}
                _ED.union.union_info.union_id=''
            end
            if info.wallet then
                _ED.user_info.user_honour=tonumber(info.wallet['3'])
                _ED.user_info.all_glories=tonumber(info.wallet['4'])
                _ED.union.user_union_info.rest_contribution=tonumber(info.wallet['5'])
            end
            local page=tonumber(info.page)
            if page then
                local rows={}
                for _,offer in ipairs(info.offers) do
                    if page==3 then table.insert(rows,{good_id=tostring(offer.id),exchange_times=tostring(offer.bought)})
                    elseif page==4 then table.insert(rows,{goods_id=tostring(offer.id),goods_exchange_times=tostring(offer.bought)})
                    else table.insert(rows,{goods_id=tostring(offer.id),remain_times=tostring(offer.bought),union_remain_times=tostring(offer.bought)}) end
                end
                if page==3 then _ED.arena_good=rows;_ED.arena_shop_refreash_times=info.refreshes
                elseif page==4 then _ED.glories_shop_info=rows;_ED.glories_shop_refreash_times=info.refreshes
                else
                    local treasure=_ED.union.union_shop_info.treasure
                    treasure.goods_info=rows;treasure.goods_count=#rows;treasure.refresh_count=info.refreshes
                    treasure.refresh_time=0;treasure.os_time=os.time()
                end
            end
        end})
    end
    if not NetworkProtocol.find_parser(15996) then
        table.insert(NetworkProtocol.protocol_parses,{code=15996,parser='local_hero_gates',parser_fun=function(_,_,_,_,list)
            local values=json.decode(npos(list))
            _ED.mega_info={}
            for _,entry in ipairs(values) do
                _ED.mega_info[#_ED.mega_info+1]={shipId=entry.shipId,info=json.encode(entry.info)}
            end
        end})
    end
    if not NetworkProtocol.find_parser(15995) then
        table.insert(NetworkProtocol.protocol_parses,{code=15995,parser='local_hero_attributes',parser_fun=function(_,_,_,_,list)
            local values=json.decode(npos(list))
            for _,info in ipairs(values) do
                local ship=_ED.user_ship[info.ship]
                if ship then
                    M.applyStats(ship,info)
                    ship.property_values=info.property_values
                    ship.relationship=info.bonds
                    ship.relationship_count=tostring(#info.bonds)
                end
            end
            M.refreshPower()
        end})
    end
    if not NetworkProtocol.find_parser(15994) then
        table.insert(NetworkProtocol.protocol_parses,{code=15994,parser='local_hero_development',parser_fun=function(_,_,_,_,list)
            local info=json.decode(npos(list))
            _ED.user_ship[info.ship].ship_fighting_spirit=info.soul
            M.refreshPower()
        end})
    end
    if not NetworkProtocol.find_parser(15993) then
        table.insert(NetworkProtocol.protocol_parses,{code=15993,parser='local_hero_level',parser_fun=function(_,_,_,_,list)
            local info=json.decode(npos(list))
            local ship=assert(_ED.user_ship[info.ship], 'Level update for unknown hero')
            ship.ship_grade=tostring(info.level)
            ship.exprience=tostring(info.experience)
            ship.grade_need_exprience=tostring(info.needed)
            M.applyStats(ship,info)
            M.refreshPower()
        end})
    end
    if not NetworkProtocol.__nr_power then
        NetworkProtocol.__nr_power=true
        local original=NetworkProtocol.parser_func
        NetworkProtocol.parser_func=function(...)
            local response=select(1,...)
            local body=type(response)=='table' and response.resouce or nil
            local command=type(body)=='string' and body:match('^%S+%s+(%S+)%s+0%s')
            if command=='login_init' or command=='login_init_again' then
                -- A full server snapshot replaces user_info. Validate the old
                -- snapshot first, then start its new speed integrity baseline.
                if _ED.old_speed_sum and _ED.user_info.speed_sum~=nil then
                    assert(tonumber(aeslua.decrypt('jar-world',_ED.old_speed_sum,aeslua.AES128,aeslua.ECBMODE))==tonumber(_ED.user_info.speed_sum),'Team speed changed outside server update')
                end
                _ED.old_speed_sum=nil
            end
            local result=original(...)
            M.refreshPower()
            return result
        end
    end
    for _,name in ipairs({'magical_animals_activate_fate','magical_animals_activate','magical_animals_advance_star','magical_animals_forging','magical_animals_steps_rebirth','magical_animals_relevant_active','magical_animals_set_skill','magical_animals_set_skill_release_method','biographies_activate','biographies_advance','biographies_rebirth','biographies_mark_synthesis','biographies_buy_prop','biographies_draw','biographies_get_extra_reward','biographies_achieve_activate','constellation_buy','constellation_exchange','artifact_unlock','artifact_culture','artifact_confirm','ship_metal_set','ship_metal_escalate','ship_metal_onekey_escalate','ship_metal_dissolve','draw_matrix_reward','user_card_info_activate','user_card_info_advance','ship_talent_level_up','ship_talent_reset','ship_spirit_level_up','ship_spirit_batch_level_up','ship_bounty','ship_batch_bounty','shop_frags_exchange','secret_shop_exchange','secret_shop_refresh','arena_shop_exchange','glories_shop_exchange','union_shop_exchange','shop_request_product_refresh','equipment_up_star','equipment_harden','equipment_harden_replace','equipment_harden_locking','treasure_escalate','treasure_onekey_escalate','equipment_escalate','ship_grow_up','ship_escalate','ship_awaken','ship_skill_level_up','ship_skill_level_up_one_key','ship_soul_level_up','new_recruitment_shop_buy','mega_unblock','mega_level_up','mega_use_skill','fight_spirit_change','fight_spirit_lock','fight_spirit_change','fight_spirit_lock'}) do
        local command=protocol_command and protocol_command[name]
        if command and not command.__nr_shop_request then
            command.__nr_shop_request=true
            local original=command.command_fun
            command.command_fun=function(...)
                local result=original(...)
                M.counter=(M.counter or 0)+1
                return result:gsub('[\r\n]+$','')..'\r\n'..tostring(os.time())..':'..tostring(math.floor(os.clock()*1000000))..':'..M.counter
            end
        end
    end
end
return M
