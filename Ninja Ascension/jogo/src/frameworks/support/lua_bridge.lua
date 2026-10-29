local lua_bridge = lua_bridge or {}

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local luaoc = nil
local luaj = nil

function lua_bridge:init(callback)
	lua_bridge.callback = callback

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        -- local args = { 2 , 3}
        -- local sigs = "(II)I"
        -- local luaj = require "cocos.cocos2d.luaj"
        -- local className = "com/cocos2dx/lua/LuaJavaBridge"
        -- local ok,ret  = luaj.callStaticMethod(className,"addTwoNumbers",args,sigs)
        -- if not ok then
        --     print("luaj error:", ret)
        -- else
        --     print("The ret is:", ret)
        -- end

        -- local function callbackLua(param)
        --     if "success" == param then
        --         print("java call back success")
        --     end
        -- end
        -- args = { "callbacklua", callbackLua }
        -- sigs = "(Ljava/lang/String;I)V"
        -- ok = luaj.callStaticMethod(className,"callbackLua",args,sigs)
        -- if not ok then
        --     print("call callback error")
        -- end
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			luaj = require "cocos.cocos2d.luaj"
		end

        local args = {LuaMessageContentConfig.handlePlatformRequest, callback}
        local sigs = "(Ljava/lang/String;I)V"

        if LuaMessageTypeConfig.messageType == 0 then
            args = {LuaMessageContentConfig.handlePlatformRequest, callback}
            sigs = "(Ljava/lang/String;I)V"
        elseif LuaMessageTypeConfig.messageType == 1 then
            args = {callback}
            sigs = "(I)V"
        elseif LuaMessageTypeConfig.messageType == 2 then
            args = {LuaMessageContentConfig.handlePlatformRequest, callback}
            sigs = "(Ljava/lang/String;I)V"
        elseif LuaMessageTypeConfig.messageType == 3 then
            args = {LuaMessageContentConfig.handlePlatformRequest, callback}
            sigs = "(Ljava/lang/String;I)V"
        elseif LuaMessageTypeConfig.messageType == 4 then
            args = {LuaMessageContentConfig.handlePlatformRequest, callback,callback}
            sigs = "(Ljava/lang/String;II)V"
        end

		local className = LuaMessageContentConfig.LuaJavaBridge
        local ok = luaj.callStaticMethod(className, LuaMessageContentConfig.registerScriptHandler, args, sigs)
    end

    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
        -- local args = { num1 = 2 , num2 = 3 }
        -- local luaoc = require "cocos.cocos2d.luaoc"
        -- local className = "LuaObjectCBridge"
        -- local ok,ret  = luaoc.callStaticMethod(className,"addTwoNumbers",args)
        -- if not ok then
        --     Director:getInstance():resume()
        -- else
        --     print("The ret is:", ret)
        -- end

        -- local function callback(param)
        --     if "success" == param then
        --         print("object c call back success")
        --     end
        -- end
        -- luaoc.callStaticMethod(className,"registerScriptHandler", {scriptHandler = callback } )
        -- luaoc.callStaticMethod(className,"callbackScriptHandler")

        --local luaoc = require "cocos.cocos2d.luaoc"
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			luaoc = require "cocos.cocos2d.luaoc"
		end
        local className = "LuaObjectCBridge"
        luaoc.callStaticMethod(className,"registerScriptHandler", {scriptHandler = callback})
    end
end

function lua_bridge:call(params)
	local args = {platform = params[1], request = params[2], data = params[3]}
	if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = params
        local sigs = "(IILjava/lang/String;)V"

        if LuaMessageTypeConfig.messageType == 0 then
            args = params
            sigs = "(IILjava/lang/String;)V"
        elseif LuaMessageTypeConfig.messageType == 1 then
            args = {params[2] .. "|" .. params[3]}
            sigs = "(Ljava/lang/String;)V"
        elseif LuaMessageTypeConfig.messageType == 2 then
            args = {params[2],params[3]}
            sigs = "(ILjava/lang/String;)V"
        elseif LuaMessageTypeConfig.messageType == 3 then
            local sendTable = {
                [LuaMessageContentConfig.messageKeyOne] = params[2],
                [LuaMessageContentConfig.messageKeyTwo] = params[3]
            }
            local sendJson = json.encode(sendTable)
            args = {sendJson}
            sigs = "(Ljava/lang/String;)V"
        elseif LuaMessageTypeConfig.messageType == 4 then 
            args = {params[2],tostring(params[2]),tostring(params[2]),params[2],params[3]}
            sigs = "(ILjava/lang/String;Ljava/lang/String;ILjava/lang/String;)V"
        end
        
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			luaj = require "cocos.cocos2d.luaj"
		end
        local className = LuaMessageContentConfig.LuaJavaBridge
        local ok,ret  = luaj.callStaticMethod(className, LuaMessageContentConfig.handlePlatformRequest, args, sigs)
	end

	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
		-- local luaoc = require "cocos.cocos2d.luaoc"
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			luaoc = require "cocos.cocos2d.luaoc"
		end
		local className = "LuaObjectCBridge"
		luaoc.callStaticMethod(className, "handlePlatformRequest", args)
	end
end

return lua_bridge