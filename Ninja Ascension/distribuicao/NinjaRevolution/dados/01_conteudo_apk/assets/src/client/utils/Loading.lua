
-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏的资源异步加载控制器
-- -----------------------------------------------------------------------------------------------------
Loading = {}

local textureCache = cc.Director:getInstance():getTextureCache()

function Loading.checkOver()
	if Loading.loadCount == 0 then
		if Loading.invoke ~= nil then
			Loading.invoke()
		end

		if Loading._stateMachine ~= nil then
			state_machine.excute(Loading._stateMachine[1], Loading._stateMachine[2], Loading._stateMachine[3])
		end
	end
end

function Loading.texture2DLoaded(target, texture)
	Loading.loadCount = Loading.loadCount - 1
	target.loadCount = target.loadCount - 1
	if target.loadCount == 0 then
		target:release()
	end
	Loading.checkOver()
end

function Loading.texture2DForPlistLoaded(target, texture)
	Loading.loadCount = Loading.loadCount - 1
	target.loadCount = target.loadCount - 1
	if target.loadCount == 0 then
		for i, v in pairs(target.data._plist) do
			cc.SpriteFrameCache:getInstance():addSpriteFrames(v);
		end
		target:release()
	end
	Loading.checkOver()
end

--[[
_res = { _pic = {}, _plist = {{_png = {}, _plist = {}}}, _ui = {} }
--]]
function Loading.loading(_res, _invoke, _stateMachine)
	if _res == nil then
		return
	end
	Loading.invoke = _invoke
	Loading._stateMachine = _stateMachine
	Loading.loadCount = 0
	if _res._pic ~= nil and #_res._pic > 0 then
		local  target = cc.Node:create()
		target:retain()
		target.loadCount = 0
		target.data = nil
		for i, v in pairs(_res._pic) do
			Loading.loadCount = Loading.loadCount + 1
			target.loadCount = target.loadCount + 1
			textureCache:addImageAsync(v, Loading.texture2DLoaded, target, false, true)
		end
	end

	if _res._plist ~= nil and #_res._plist > 0  then
		Loading.texture2DForPlistCount = 0
		for i, v in pairs(_res._plist) do
			if v._png ~= nil and v._plist ~= nil then
				local  target = cc.Node:create()
				target:retain()
				target.loadCount = 0
				target.data = v
				for t, p in pairs(v._png) do
					Loading.loadCount = Loading.loadCount + 1
					target.loadCount = target.loadCount + 1
					textureCache:addImageAsync(p, Loading.texture2DForPlistLoaded, target, false, true)
				end
			end
		end
	end
end
