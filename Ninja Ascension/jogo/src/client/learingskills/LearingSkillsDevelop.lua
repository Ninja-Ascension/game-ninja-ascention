-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingSkillsDevelop = class("LearingSkillsDevelopClass", Window)
app.load("client.learingskills.LearingSkillsFavorUp")
app.load("client.learingskills.LearingListviewDragons")
app.load("client.learingskills.LearingListviewDemons")
app.load("client.learingskills.LearingListviewHeroes")
app.load("client.learingskills.LearingListviewLotus")
app.load("client.learingskills.cells.learing_change_list_cell")
app.load("client.learingskills.LearingListviewEquipDragons")
app.load("client.learingskills.LearingListviewEquipDemons")
app.load("client.learingskills.LearingListviewEquipHeroes")
app.load("client.learingskills.LearingListviewEquipLotus")
app.load("client.learingskills.LearingSkillsTip")
app.load("client.learingskills.LearingSkillsSeeEvent")
app.load("client.cells.utils.property_change_tip_info_cell") 
app.load("client.learingskills.LearingSkillsEvent")
local learing_skills_develop_open_terminal = {
    _name = "learing_skills_develop_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("learing_skills_develop_open")
        if from_type == 1 then --主页
            state_machine.excute("menu_hide_event",0,"")
        end        
        local from_type = params[1]
        local pageIndex = params[2]
        local _LearingSkillsDevelop = LearingSkillsDevelop:new()
        _LearingSkillsDevelop:init(from_type,pageIndex)
        fwin:open(_LearingSkillsDevelop,fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(learing_skills_develop_open_terminal)
state_machine.init()
function LearingSkillsDevelop:ctor()
    self.super:ctor()
	self.roots = {}
    self.listviews_learn = {
        dragons = nil, --龙虎
        demons = nil, --罗刹
        heroes = nil, --白莲
        lotus = nil -- 群英
        }
    self.listviews_change = {
        dragons = nil, --龙虎
        demons = nil, --罗刹
        heroes = nil, --白莲
        lotus = nil -- 群英
        }
    self.from_type = nil
    self.pageIndex = nil
    self.nowlistpage = nil
    -- Initialize EmailManager page state machine.
    local function init_learing_skills_develop_terminal()
        --manager
        local learing_skills_develop_manager_terminal = {
        _name = "learing_skills_develop_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)

            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                for i, v in pairs(instance.listviews_learn) do
                    if v ~= nil then
                        v:setVisible(false)
                    end
                end
                for i, v in pairs(instance.listviews_change) do
                    if v ~= nil then
                        v:setVisible(false)
                    end
                end
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }
        --关闭界面
        local learing_skills_develop_close_terminal = {
            _name = "learing_skills_develop_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i , v in pairs(instance.listviews_learn) do
                    if v ~= nil then
                        fwin:close(v)
                    end
                end
                for i , v in pairs(instance.listviews_change) do
                    if v ~= nil then
                        fwin:close(v)
                    end
                end
                if instance.from_type == 1 then --主页
                    fwin:close(instance)
                    state_machine.excute("menu_back_home_page", 0, "") 
                    state_machine.excute("menu_clean_page_state", 0, "")
                    state_machine.excute("menu_show_event",0,"")
                elseif instance.from_type == 2 then --阵容
                    fwin:close(instance)
                    state_machine.excute("formation_update_all_hero",0,"")
                    state_machine.excute("hero_develop_update_skill",0,"")
                    state_machine.excute("hero_develop_play_hero_animation",0,"begin")
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local learing_skills_develop_open_dragons_terminal = {
            _name = "learing_skills_develop_open_dragons",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local data = params._datas

                local isfirst_open = false
                if data == nil then
                    isfirst_open = false
                else
                    isfirst_open = data.isfirst_open
                end
                 
                instance.nowlistpage = 1
                function showDragons()
                    if instance.pageIndex == 1 then
                        if instance.listviews_learn.dragons == nil then
                            instance.listviews_learn.dragons = LearingListviewDragons:new()
                            instance.listviews_learn.dragons:init()
                            fwin:open(instance.listviews_learn.dragons,fwin._windows)
                        end
                        instance.listviews_learn.dragons:setVisible(true)
                    else
                        if instance.listviews_change.dragons == nil then
                            instance.listviews_change.dragons = LearingListviewEquipDragons:new()
                            instance.listviews_change.dragons:init()
                            fwin:open(instance.listviews_change.dragons,fwin._windows)
                        end
                        instance.listviews_change.dragons:setVisible(true)
                    end                  
                end
                if isfirst_open == true then    
                    cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
                    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,showDragons, instance)                                
                else
                    showDragons()
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local learing_skills_develop_open_demons_terminal = {
            _name = "learing_skills_develop_open_demons",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.nowlistpage = 2
                if instance.pageIndex == 1 then
                    if instance.listviews_learn.demons == nil then
                        instance.listviews_learn.demons = LearingListviewDemons:new()
                        instance.listviews_learn.demons:init()
                        fwin:open(instance.listviews_learn.demons,fwin._windows)
                    end
                    instance.listviews_learn.demons:setVisible(true)            
                else
                    if instance.listviews_change.demons == nil then
                        instance.listviews_change.demons = LearingListviewEquipDemons:new()
                        instance.listviews_change.demons:init()
                        fwin:open(instance.listviews_change.demons,fwin._windows)
                    end
                    instance.listviews_change.demons:setVisible(true)                        
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local learing_skills_develop_open_heroes_terminal = {
            _name = "learing_skills_develop_open_heroes",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.nowlistpage = 4
                if instance.pageIndex == 1 then
                    if instance.listviews_learn.heroes == nil then
                        instance.listviews_learn.heroes = LearingListviewHeroes:new()
                        instance.listviews_learn.heroes:init()
                        fwin:open(instance.listviews_learn.heroes,fwin._windows)
                    end
                    instance.listviews_learn.heroes:setVisible(true)    
                else
                    if instance.listviews_change.heroes == nil then
                        instance.listviews_change.heroes = LearingListviewEquipHeroes:new()
                        instance.listviews_change.heroes:init()
                        fwin:open(instance.listviews_change.heroes,fwin._windows)
                    end
                    instance.listviews_change.heroes:setVisible(true)    
                end        
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local learing_skills_develop_open_lotus_terminal = {
            _name = "learing_skills_develop_open_lotus",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.nowlistpage = 3
                if instance.pageIndex == 1 then
                    if instance.listviews_learn.lotus == nil then
                        instance.listviews_learn.lotus = LearingListviewLotus:new()
                        instance.listviews_learn.lotus:init()
                        fwin:open(instance.listviews_learn.lotus,fwin._windows)
                    end
                    instance.listviews_learn.lotus:setVisible(true)
                else
                    if instance.listviews_change.lotus == nil then
                        instance.listviews_change.lotus = LearingListviewEquipLotus:new()
                        instance.listviews_change.lotus:init()
                        fwin:open(instance.listviews_change.lotus,fwin._windows)
                    end
                    instance.listviews_change.lotus:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local learing_skills_develop_change_pack_terminal = {
            _name = "learing_skills_develop_change_pack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local pageIndex = params._datas.pageIndex
                if instance.pageIndex == pageIndex then
                    return
                end
                instance:changePack(pageIndex)
                instance:showSkillNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local learing_skills_develop_update_skills_number_terminal = {
            _name = "learing_skills_develop_update_skills_number",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showSkillNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }        
        state_machine.add(learing_skills_develop_manager_terminal)
        state_machine.add(learing_skills_develop_close_terminal)
        state_machine.add(learing_skills_develop_open_dragons_terminal)
        state_machine.add(learing_skills_develop_open_demons_terminal)
        state_machine.add(learing_skills_develop_open_heroes_terminal)
        state_machine.add(learing_skills_develop_open_lotus_terminal)
        state_machine.add(learing_skills_develop_change_pack_terminal)
        state_machine.add(learing_skills_develop_update_skills_number_terminal)
        state_machine.init()
    end
    -- call func init hom state machine.
    init_learing_skills_develop_terminal()
end
function LearingSkillsDevelop:showSkillNumber()
    local root = self.roots[1]
    -- local Panel_skills_num = ccui.Helper:seekWidgetByName(root,"Panel_skills_num")
    -- local Text_skills_cs = ccui.Helper:seekWidgetByName(root,"Text_skills_cs")
    -- Panel_skills_num:setVisible(true)
    -- Text_skills_cs:setString(_ED.free_learn_skill_count)   
    local skillnumber = nowLearnSkillsNumber()
    -- print("===========",skillnumber)
    local getskillnumber = nowGetSkillsNumber()
    -- print("===========",getskillnumber)
    -- local allskillnumber = skillnumber + getskillnumber
    local Panel_line_xx = ccui.Helper:seekWidgetByName(root,"Panel_line_xx")
    local Panel_skills_xx = ccui.Helper:seekWidgetByName(root,"Panel_skills_xx")
    -- if self.pageIndex == 1 then    
    --     Panel_line_xx:setVisible(true)
    --     Panel_skills_xx:setVisible(false)
    --     local Text_line_xx_num = ccui.Helper:seekWidgetByName(root,"Text_line_xx_num")
    --     Text_line_xx_num:setString(getskillnumber)
    -- else
        Panel_line_xx:setVisible(false)
        Panel_skills_xx:setVisible(true)
        local Text_skills_xx_num = ccui.Helper:seekWidgetByName(root,"Text_skills_xx_num")
        Text_skills_xx_num:setString(skillnumber)
    -- end
end
function LearingSkillsDevelop:onInit()
	local csbItem = csb.createNode("skills/skills_list.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)

    self:showSkillNumber()
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_skills_back"), nil, 
    {
        terminal_name = "learing_skills_develop_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--龙虎
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_lognhumen"), nil, 
    {
        terminal_name = "learing_skills_develop_manager",     
        next_terminal_name = "learing_skills_develop_open_dragons", 
        current_button_name = "Button_zy_lognhumen",   
        but_image = "",     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    --罗刹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_luochajiao"), nil, 
    {
        terminal_name = "learing_skills_develop_manager",     
        next_terminal_name = "learing_skills_develop_open_demons", 
        current_button_name = "Button_zy_luochajiao",   
        but_image = "",     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    --白莲
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_bailianjiao"), nil, 
    {
        terminal_name = "learing_skills_develop_manager",     
        next_terminal_name = "learing_skills_develop_open_lotus", 
        current_button_name = "Button_zy_bailianjiao",   
        but_image = "",     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)   
    --群英 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_qunyinghui"), nil, 
    {
        terminal_name = "learing_skills_develop_manager",     
        next_terminal_name = "learing_skills_develop_open_heroes", 
        current_button_name = "Button_zy_lognhumen",   
        but_image = "",     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)    
    --切换仓库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xuexi_skills"), nil, 
    {
        terminal_name = "learing_skills_develop_change_pack",
        terminal_state = 0, 
        pageIndex = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)   
    --切换仓库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_genghuan_skills"), nil, 
    {
        terminal_name = "learing_skills_develop_change_pack",
        terminal_state = 0, 
        pageIndex = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)  
    self:onUpdateDraw()
end

function LearingSkillsDevelop:changePack(pageIndex)
    self.pageIndex = pageIndex
    local root = self.roots[1]
    local genghuan = ccui.Helper:seekWidgetByName(root, "Button_genghuan_skills")
    local Button_xuexi_skills = ccui.Helper:seekWidgetByName(root, "Button_xuexi_skills")
    if self.pageIndex == 1 then
        Button_xuexi_skills:setHighlighted(true)
        genghuan:setHighlighted(false)    
    else
        Button_xuexi_skills:setHighlighted(false)
        genghuan:setHighlighted(true)
    end
    for i, v in pairs(self.listviews_learn) do
        if v ~= nil then
            v:setVisible(false)
        end
    end
    for i, v in pairs(self.listviews_change) do
        if v ~= nil then
            v:setVisible(false)
        end
    end

    if self.nowlistpage == 1 then
        state_machine.excute("learing_skills_develop_open_dragons",0,"")
    elseif self.nowlistpage == 2 then
        state_machine.excute("learing_skills_develop_open_demons",0,"")
    elseif self.nowlistpage == 3 then
        state_machine.excute("learing_skills_develop_open_lotus",0,"")       
    elseif self.nowlistpage == 4 then
        state_machine.excute("learing_skills_develop_open_heroes",0,"")      
    end
end
function LearingSkillsDevelop:onUpdateDraw()
    local root = self.roots[1]
    local genghuan = ccui.Helper:seekWidgetByName(root, "Button_genghuan_skills")
    local Button_xuexi_skills = ccui.Helper:seekWidgetByName(root, "Button_xuexi_skills")
    if self.pageIndex == 1 then
        Button_xuexi_skills:setHighlighted(true)
        genghuan:setHighlighted(false)    
    else
        Button_xuexi_skills:setHighlighted(false)
        genghuan:setHighlighted(true)
    end
    state_machine.excute("learing_skills_develop_manager",0,{
        _datas =
           {
            terminal_name = "learing_skills_develop_manager",     
            next_terminal_name = "learing_skills_develop_open_dragons", 
            current_button_name = "Button_zy_lognhumen",   
            but_image = "",     
            terminal_state = 0, 
            isfirst_open = true,
            isPressedActionEnabled = false

            }
    })
	state_machine.unlock("learing_skills_develop_open")
end
function LearingSkillsDevelop:init(from_type, pageIndex)
	self.from_type = from_type
    self.pageIndex = pageIndex
    self:onInit()
end
function LearingSkillsDevelop:onEnterTransitionFinish()

end

function LearingSkillsDevelop:onExit()
    state_machine.remove("learing_skills_develop_manager")
    state_machine.remove("learing_skills_develop_close")
    state_machine.remove("learing_skills_develop_open_dragons")
    state_machine.remove("learing_skills_develop_open_demons")
    state_machine.remove("learing_skills_develop_open_heroes")
    state_machine.remove("learing_skills_develop_open_lotus")
    state_machine.remove("learing_skills_develop_change_pack")
    state_machine.remove("learing_skills_develop_update_skills_number")
end