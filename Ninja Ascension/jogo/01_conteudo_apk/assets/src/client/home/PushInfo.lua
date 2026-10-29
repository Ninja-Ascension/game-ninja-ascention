-- ----------------------------------------------------------------------------------------------------
-- 说明：首页服务信息推送
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PushInfo = class("PushInfoClass", Window)

function PushInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.str = nil
    -- Initialize PushInfo page state machine.
    local function init_menu_terminal()
    	local push_info_update_draw_terminal = {
				_name = "push_info_update_draw",
				_init = function (terminal) 
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
	
					instance:onUpdateDraw()

					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
		state_machine.add(push_info_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_menu_terminal()
end
function PushInfo:cutStringMain(str, height, fontSize, width)
	local mRoot = ccui.RichText:create()
	fontSize = fontSize or 10
	local l = string.len(self.str)
	mRoot:ignoreContentAdaptWithSize(false)
	local count = 0
	while (l > 0) do
		local f,e = string.find(self.str, "%%%C-%%")
		if f == nil or e == nil then
			local re = nil
			if __lua_project_id == __lua_project_adventure then
				re = ccui.RichElementText:create(1, cc.c3b(199, 171, 120), 255, self.str, "fonts/chinese.ttf", fontSize)
			else
				re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, self.str, "fonts/FZYiHei-M20S.ttf", fontSize)
			end
			
			mRoot:pushBackElement(re)
			count = count + zstring.utfstrlen(self.str)
			break
		end
		if f > 1 then
			local strsub = string.sub(self.str, 1, f-1)
			count = count + zstring.utfstrlen(strsub)
			local re = nil
			if __lua_project_id == __lua_project_adventure then
				re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, strsub, "fonts/chinese.ttf", fontSize)
			else
				re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, strsub, "fonts/FZYiHei-M20S.ttf", fontSize)
			end
			
			mRoot:pushBackElement(re)
		end
		local name = string.sub(self.str, f+1, e-1)
		local f1, e1 = string.find(name, "%d+")
		if name == nil or f1 == nil or e1 == nil then
			mRoot:removeAllChildrenWithCleanup(true)
			break
		end
		local quality = string.sub(name, f1, e1)
		local color = tonumber(quality) + 1
		name = string.sub(name, e1+2, string.len(name))
		count = count + zstring.utfstrlen(name)
		if color == nil or color <= 0 or color > 11 then
			mRoot:removeAllChildrenWithCleanup(true)
			break
		end
		local re1 = nil
		if __lua_project_id == __lua_project_adventure then
			re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, "fonts/chinese.ttf", fontSize)
		else
			re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, "fonts/FZYiHei-M20S.ttf", fontSize)
		end
		mRoot:pushBackElement(re1)
		self.str = string.sub(self.str, e+1, l)
		l = string.len(self.str)
	end
	if width ~= nil and width > 0 then
		mRoot:setContentSize(cc.size(width+15, height+20))
	else
		mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
	end
	
	return mRoot, count
end
function PushInfo:onUpdateDraw()
	local root = self.roots[1]
	local array = {}

	local _headLayer = ccui.Helper:seekWidgetByName(root, "ImageView_notice")
	local fontSize = 20/CC_CONTENT_SCALE_FACTOR()
	for i, v in pairs(_ED.send_information) do
		self.str = v.information_content
		
		local _rootm = _headLayer:getContentSize()
		local _richText, l = self:cutStringMain(self.str, _rootm.height, fontSize)
		local _pos = cc.p(_richText:getPositionX() - _rootm.width, _richText:getPositionY())
		local actions  = cc.MoveTo:create(10, _pos)
		table.insert(array, actions)
		local seq = cc.Sequence:create(array)
		_richText:runAction(seq)
		if __lua_project_id == __lua_project_adventure then
			_headLayer:addChild(_richText, -1)
			local anchor = _richText:getAnchorPoint()
			_richText:setPosition(cc.p((l*fontSize+_rootm.width)*anchor.x+200, -_rootm.height*anchor.y/2+10))
		else
			_headLayer:addChild(_richText, 100)
			local anchor = _richText:getAnchorPoint()
			_richText:setPosition(cc.p((l*fontSize+_rootm.width)*anchor.x+200, -_rootm.height*anchor.y/2+20))	
		end
		
		table.remove(_ED.send_information, i)
		break
	end
end

function PushInfo:onEnterTransitionFinish()
    local csbPushInfo = csb.createNode("home/home_notice.csb")
	local root = csbPushInfo:getChildByName("root")
    table.insert(self.roots, root)
	self:onUpdateDraw()

    self:addChild(csbPushInfo)
	
end

function PushInfo:onExit()
	state_machine.remove("push_info_update_draw")
end
function PushInfo:init()
end

function PushInfo:createCell()
	local cell = PushInfo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end