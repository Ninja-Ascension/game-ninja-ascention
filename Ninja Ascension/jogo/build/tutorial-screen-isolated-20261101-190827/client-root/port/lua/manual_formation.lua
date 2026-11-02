-- Home selection must work without instantiating a tutorial formation page.
local M={}
function M.install()
    if not state_machine or not state_machine._terminals then return end
    local terminals=state_machine._terminals
    if not terminals.open_add_ship_window then
        state_machine.add({_name='open_add_ship_window',_state=0,
            _init=function()end,
            _invoke=function(_,_,params)
                app.load('client.packs.hero.HeroFormationChoiceWear')
                local data=params._datas or params
                return state_machine.excute('hero_formation_choice_wear_window_open',0,
                    {data._index,data._type or 1,-1})
            end})
    end
    if not terminals.choice_hero_battle_request then
        state_machine.add({_name='choice_hero_battle_request',_state=0,
            _init=function()end,
            _invoke=function(_,_,params)
                local ship,position=tostring(params):match('^(%d+)|(%d+)')
                assert(ship and position,'Invalid manual formation selection')
                protocol_command.formation_change.param_list=ship..'\r\n'..position..'\r\n1\r\n0'
                NetworkManager:register(protocol_command.formation_change.code,nil,nil,nil,nil,function(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS>=0 then
                        local home=fwin:find('HomeHeroClass')
                        if home then home:onUpdateDraw() end
                    end
                end,false,nil)
                return true
            end})
    end
end
return M
