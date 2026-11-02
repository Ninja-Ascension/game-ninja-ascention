-----------------------------
--数码主界面聊天cell
-----------------------------
TreasureChatInfoCell = class("TreasureChatInfoCellClass", Window)
TreasureChatInfoCell.y = nil 
local treasure_chat_info_cell_terminal = {
    _name = "treasure_chat_info_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = TreasureChatInfoCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_chat_info_cell_terminal)
state_machine.init()

function TreasureChatInfoCell:ctor()
    self.super:ctor()
	self.roots = {}		
    self.chat_info = nil

 	local function init_treasure_chat_info_cell_terminal()
        local treasure_chat_info_cell_updata_info_terminal = {
            _name = "treasure_chat_info_cell_updata_info",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local info = params[2]
                if info ~= nil then
                    cell.chat_info = info
                    cell:onUpdateDraw()
                else
                    cell:unload()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(treasure_chat_info_cell_updata_info_terminal)
        state_machine.init()
    end
	init_treasure_chat_info_cell_terminal()        	
end

function TreasureChatInfoCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_infor")

    local nickName = self.chat_info.name
    local reward = zstring.split(self.chat_info.value, ",")
    local char_str = tipStringInfo_pokemon_treasure_tips[7]

    local name = ""
    local quality = 0
    local rewardType = zstring.tonumber(reward[1])
    if tonumber(rewardType) == 6 then
        quality = dms.int(dms["prop_mould"], reward[2], prop_mould.prop_quality)
        name = setThePropsIcon(tonumber(reward[2]))[2]
    elseif tonumber(rewardType) == 7 then
        quality = dms.int(dms["equipment_mould"], reward[2], equipment_mould.grow_level)+1
        local nameindex = dms.int(dms["equipment_mould"], reward[2], equipment_mould.equipment_name)
        --通过索引找到word_mould
        local word_info = dms.element(dms["word_mould"], nameindex)
        name = word_info[3]
    elseif tonumber(rewardType) == 13 then
        quality = dms.int(dms["ship_mould"], reward[2], ship_mould.ship_type)+1
        local evo_image = dms.string(dms["ship_mould"], reward[2], ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(hero.evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], reward[2], ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        name = word_info[3]
    end

    char_str = string.gsub(char_str, "!x@", nickName)
    char_str = string.gsub(char_str, "!y@", name)
    char_str = string.gsub(char_str, "!n@", reward[3])
    char_str = string.gsub(char_str, "!qulity@", quality .. "")

    local max_width = 0
    if _ED.is_can_use_formatTextExt == false then
        Text_chat_infor:setString(char_str)
        max_width = Text_chat_infor:getAutoRenderSize().width
    end

    Text_chat_infor:setString("")
    Text_chat_infor:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_chat_infor:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_chat_infor:getFontSize() * 6
    end
                
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local fontsName = Text_chat_infor:getFontName()
    if verifySupportLanguage(_lua_release_language_zh_TW) == false then
        fontsName = ""
    else
        fontsName = Text_chat_infor:getFontName()
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(224, 224, 224)
        color_Type_2 = cc.c3b(224, 224, 224)
    else
        color_Type_1 = cc.c3b(189, 206, 224)
        color_Type_2 = cc.c3b(189, 206, 224)
    end

    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    fontsName, 
    Text_chat_infor:getFontSize(),
    chat_rich_text_color)
    if _ED.is_can_use_formatTextExt == false then
        _richText2:setPositionX( - _richText2:getContentSize().width / 2 )
    else
        _richText2:formatTextExt()
    end
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_chat_infor:getContentSize().height / 2 + Text_chat_infor:getFontSize() - 10)
    Text_chat_infor:addChild(_richText2)
    root:setPositionY(TreasureChatInfoCell.y +  _richText2:getContentSize().height - root:getContentSize().height)
    self:setContentSize(_richText2:getContentSize())


    --如果formatTextExt不能用 重新计算高度和位置
    -- if _ED.is_can_use_formatTextExt == false then
    --     local heightN = math.ceil( max_width / tonumber(_richText2:getContentSize().width))
    --     local height = heightN * 19
    --     root:setPositionY(TreasureChatInfoCell.y +  height - root:getContentSize().height)
    --     self:setContentSize(cc.size(_richText2:getContentSize().width , height))
    -- end
end

function TreasureChatInfoCell:onInit()
	local root = cacher.createUIRef("activity/wonderful/rare_treasure_infor_show_cell.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    if TreasureChatInfoCell.y == nil then
       TreasureChatInfoCell.y = root:getPositionY()
    end
	self:onUpdateDraw()
end

function TreasureChatInfoCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("activity/wonderful/rare_treasure_infor_show_cell.csb", root)
end

function TreasureChatInfoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TreasureChatInfoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef("activity/wonderful/rare_treasure_infor_show_cell.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function TreasureChatInfoCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_infor")
    if Text_chat_infor ~= nil then
        Text_chat_infor:setString("")
        Text_chat_infor:removeAllChildren(true)
    end
end

function TreasureChatInfoCell:init(params)
	self.chat_info = params[1]
    self._index = params[2]
	
    self:onInit()
    return self
end

function TreasureChatInfoCell:createCell()
    local cell = TreasureChatInfoCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

