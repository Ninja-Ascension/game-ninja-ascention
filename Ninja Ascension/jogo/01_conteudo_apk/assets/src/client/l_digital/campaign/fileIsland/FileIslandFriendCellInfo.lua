-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛好友任务信息
-------------------------------------------------------------------------------------------------------
FileIslandFriendCellInfo = class("FileIslandFriendCellInfoClass", Window)

local FileIslandFriendCellInfo_open_terminal = {
    _name = "FileIslandFriendCellInfo_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("FileIslandFriendCellInfoClass")
        if nil == _homeWindow then
            local panel = FileIslandFriendCellInfo:new():init(params)
            fwin:open(panel, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(FileIslandFriendCellInfo_open_terminal)
state_machine.init()
    
function FileIslandFriendCellInfo:ctor()
    self.roots = {}

    local FileIslandFriendCellInfo_close_terminal = {
        _name = "FileIslandFriendCellInfo_close",
        _init = function (terminal) 
        
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local _homeWindow = fwin:find("FileIslandFriendCellInfoClass")
            if nil ~= _homeWindow then
                fwin:close(fwin:find("FileIslandFriendCellInfoClass"))
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    

    local FileIslandFriendCellInfo_goBattle_terminal = {
        _name = "FileIslandFriendCellInfo_goBattle",
        _init = function (terminal) 
            app.load("client.landscape.duplicate.pve.LPVENpc")
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local idx = params._datas.idx
            local node = params._datas.node

            local t = params._datas.node.resultNpcId[idx]

            local _LPVENpc = LPVENpc:new()
            _LPVENpc:init(tonumber(t.npcId), 
                          tonumber(t.sceneId), 
                          false,
                          0,
                          nil,
                          nil,
                          true)
            fwin:open(_LPVENpc, fwin._ui)

            -- _ED.fileIsland.fileIslandFriendCellInfo_goBattle = true

            state_machine.excute("FileIslandFriendCellInfo_close", 0, "")

            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(FileIslandFriendCellInfo_close_terminal)
    state_machine.add(FileIslandFriendCellInfo_goBattle_terminal)
    state_machine.init()

end

function FileIslandFriendCellInfo:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local sceneid = 0
    local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 0)
    for i, v in pairs(_scenes) do
        local tempSceneId = dms.atoi(v, pve_scene.id)
        if _ED.scene_current_state[tempSceneId] == nil
            or _ED.scene_current_state[tempSceneId] == ""
            or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
            then
            sceneid = i - 1
            break
        end
    end

    -- 找出当前最大解锁的关卡id
    local npcIds = {}
    local npcStates = {}
    local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(sceneid), pve_scene.npcs), ",")
    local sceneState = tonumber(_ED.scene_current_state[sceneid])
    local tIndex = 1
    for i = 1, table.getn(tempNpcIds) do
        local npcState = 0
        if sceneState + 1 == i then
            npcState = 1
            npcIds[tIndex] = tempNpcIds[i]
            npcStates[tIndex] = npcState
            break
        end
        npcIds[tIndex] = tempNpcIds[i]
        npcStates[tIndex] = npcState
        tIndex = tIndex + 1
    end

    local maxNpcId = tonumber(npcIds[#npcIds])

    self.resultNpcId = {}

    for i = 1, #self.npcInfo do
        local function_id = self.npcInfo[i]
        if function_id then
            local functionData = dms.element(dms["function_param"], function_id)
            local npcId = dms.atos(functionData, function_param.open_npc)
            if tonumber(npcId) < maxNpcId then
                local t = {}
                t.npcId = npcId
                t.sceneId = dms.atos(functionData, function_param.open_scene)
                table.insert(self.resultNpcId, t)

                local describeInfo = ""
                local describeData = zstring.split(dms.atos(functionData, function_param.describe), "|")
                for i, v in pairs(describeData) do
                    local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                    describeInfo = describeInfo .. word_info[3]
                end

                self.Panel_fb[#self.resultNpcId]:setVisible(true)
                local Text_fb_t = ccui.Helper:seekWidgetByName(root, "Text_fb_t_" .. #self.resultNpcId)
                Text_fb_t:setString(describeInfo)

                if #self.resultNpcId == 3 then
                    break
                end

            end

        end
    end

    -- 没有找到合适的关卡
    if #self.resultNpcId == 0 then
        self.Panel_fb[1]:setVisible(true)
        self.Panel_fb[1]:setTouchEnabled(false)
        local Text_fb_t_1 = ccui.Helper:seekWidgetByName(root, "Text_fb_t_1")
        Text_fb_t_1:setString(tipStringInfo_file_island_tips[7])
        local Text_fb_n_1 = ccui.Helper:seekWidgetByName(root, "Text_fb_n_1")
        Text_fb_n_1:setVisible(false)
    end

    -- 头像
    self.Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%s.png", self.my_table.headId))

end

function FileIslandFriendCellInfo:init(params)
    self.data = params or {}

    self.my_table = params.my_table
    self.npcInfo = zstring.split(params.my_table.npcInfo, ",")
    self.taskData = params.taskData

    -- 记录从好友任务跳到战斗，回来的时候进好友任务
    _ED.fileIsland.fileIslandFriendCellInfo_goBattle = false

    self:onInit()
    return self
end

function FileIslandFriendCellInfo:onInit()
    local node = csb.createNode("campaign/explore/explore_friend_infor.csb")
    local root = node:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(node)

    self.Panel_fb = {}
    for i = 1, 3 do
        local node = ccui.Helper:seekWidgetByName(root, "Panel_fb_" .. i)
        node:setVisible(false)
        table.insert(self.Panel_fb, node)

        fwin:addTouchEventListener(node, nil, 
        {
            terminal_name = "FileIslandFriendCellInfo_goBattle", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            idx = i,
            node = self,
        }, 
        nil, 0)

    end

    self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	
    self:onUpdateDraw()

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_5"), nil, 
    {
        terminal_name = "FileIslandFriendCellInfo_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function FileIslandFriendCellInfo:onExit()
    state_machine.remove("FileIslandFriendCellInfo_close") 
    state_machine.remove("FileIslandFriendCellInfo_goBattle")
end