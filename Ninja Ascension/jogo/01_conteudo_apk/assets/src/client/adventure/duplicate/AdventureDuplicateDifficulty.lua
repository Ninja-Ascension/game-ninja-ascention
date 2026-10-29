-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本难度的显示
-------------------------------------------------------------------------------------------------------
AdventureDuplicateDifficulty = class("AdventureDuplicateDifficultyClass", Window)
    
function AdventureDuplicateDifficulty:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1

    -- Initialize adventure duplicate difficulty state machine.
    local function init_adventure_duplicate_difficulty_terminal()
        -- change scene difficulty
        local adventure_duplicate_difficulty_change_scene_difficulty_terminal = {
            _name = "adventure_duplicate_difficulty_change_scene_difficulty",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local but = params
                if but._isOpened == true then
                    state_machine.excute("adventure_duplicate_change_duplicate_difficulty", 0, params._datas.difficulty)
                end
                state_machine.excute("adventure_duplicate_difficulty_close_window", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- close window
        local adventure_duplicate_difficulty_close_window_terminal = {
            _name = "adventure_duplicate_difficulty_close_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureDuplicateDifficultyClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_difficulty_change_scene_difficulty_terminal)
        state_machine.add(adventure_duplicate_difficulty_close_window_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate difficulty state machine.
    init_adventure_duplicate_difficulty_terminal()
end

function AdventureDuplicateDifficulty:init(sceneId)
    self.selectSceneId = sceneId
	return self
end

function AdventureDuplicateDifficulty:initDraw()
    local root = self.roots[1]

end

function AdventureDuplicateDifficulty:onEnterTransitionFinish()
	local csbAdventureDuplicateDifficulty = csb.createNode("duplicate/maoxian_difficulty.csb")
    local root = csbAdventureDuplicateDifficulty:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateDifficulty)

    -- initailize in page button call func.
    local button_names = {
        "Button_jiandan",
        "Button_putong",
        "Button_kunnan",
    }
    local open_text_names = {
        "Text_jiandan",
        "Text_putong",
        "Text_kunnan",
    }
    local close_text_names = {
        "Text_jiandan",
        "Text_putong_no",
        "Text_kunnan_no",
    }
    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, button_names[i]),       nil, 
        {
            terminal_name = "adventure_duplicate_difficulty_change_scene_difficulty",   
            cell = self,    
            difficulty = i,  
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_nandu"),       nil, 
	{
		terminal_name = "adventure_duplicate_difficulty_close_window", 
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 2):setSwallowTouches(false)
	
    -- 绘制关卡的星星-根据通过难度来绘制
    local Image_star_s = {
        ccui.Helper:seekWidgetByName(root, "Image_liang_" .. 1),
        ccui.Helper:seekWidgetByName(root, "Image_liang_" .. 2),
        ccui.Helper:seekWidgetByName(root, "Image_liang_" .. 3)
    }
    local npcs = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    for i, v in pairs(lists) do
        if v ~= "" then
            local list = zstring.split(v, ",")
            local _id = tonumber(list[1])
            local _max_id = tonumber(list[#list])
            local Image_star = Image_star_s[i]
            local sceneState = tonumber(_ED.npc_state[_id])
            local maxSceneState = tonumber(_ED.npc_state[_max_id])
            if sceneState ~= nil then
                local but = ccui.Helper:seekWidgetByName(root, button_names[i])
                but:setVisible(true)
                if sceneState >= 0 then
                    Image_star:setVisible(maxSceneState > 0)
                    ccui.Helper:seekWidgetByName(root, close_text_names[i]):setVisible(false)
                    ccui.Helper:seekWidgetByName(root, open_text_names[i]):setVisible(true)
                    but._isOpened = true
                else
                    ccui.Helper:seekWidgetByName(root, close_text_names[i]):setVisible(true)
                end
            end
        end
    end

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateDifficultyClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 2)

    -- initailize draw state of difficulty page.
    self:initDraw()
end

function AdventureDuplicateDifficulty:onExit()
    state_machine.remove("adventure_duplicate_difficulty_change_scene_difficulty")
    state_machine.remove("adventure_duplicate_difficulty_close_window")
end