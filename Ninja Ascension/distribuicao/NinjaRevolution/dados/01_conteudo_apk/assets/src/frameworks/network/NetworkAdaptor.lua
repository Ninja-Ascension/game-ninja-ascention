NetworkAdaptor = NetworkAdaptor or {reconnect_count = 0, reconnect_max_count = 3, retry_count = 0, retry_max_count = 3,
	XMLHttpRequest = {open_auto_reconnect = false}, 
	WebSocket = {socket = nil, url = nil}, 
	LuaSocket = {queue = {}, event_queue = {}, tcp = nil, url = nil, status = 1, send_count = 0, socket_event = true, heartbeat = true, heartbeat_count = 0, keepalive = true, timeout = 15, reconnect = false}
}

local socketevent = require("socketevent")
-- Fury: reloj con decimales (luasocket, socket.core va dentro de libjts.so);
-- si no estuviera, os.time() como antes.
local fury_ok_reloj, fury_socket_core = pcall(require, "socket.core")
local fury_ahora = (fury_ok_reloj and type(fury_socket_core) == "table" and fury_socket_core.gettime) or os.time

local sock = socketevent.tcp(blowfish._key)
NetworkAdaptor.LuaSocket.status = -1

sock:on("connect", function(event)
	NetworkAdaptor.LuaSocket.status = 1
	NetworkAdaptor.LuaSocket.heartbeat = true
	NetworkAdaptor.LuaSocket.heartbeat_count = 0
	NetworkAdaptor.LuaSocket.keepalive = true
	NetworkAdaptor.LuaSocket.reconnect = false
	NetworkAdaptor.reconnect_count = 0
	NetworkAdaptor.retry_count = 0
	-- print("connect: ok!")

	fwin:addService({
        callback = function ( params )
			local sendStr = NetworkProtocol.command_func(protocol_command.init_user_socket_service.code)
			-- sock:sendmessage(sendStr)
			NetworkAdaptor.socketSend(sendStr)
        end,
        delay = 0.1,
        params = nil
    })
end)

-- sock:on("data", function(event)
-- 	-- print("data: " .. event.data)
-- 	if event.data == "close\n" then
-- 		sock:close()
-- 	end
-- end)

sock:on("message", function(event)
	-- print("message: " .. event.data)
	if event.data == "close" then
		-- print("socketClose:4")
		sock:close()
	elseif event.data == "success" then
	elseif event.data == "heartbeat" or event.data == "heartbeat\n" or event.data == "heartbeat\r\n" then
		NetworkAdaptor.LuaSocket.heartbeat_count = 0
		-- print("******************")
	else
		-- NetworkProtocol.parser_socket_func(event.data)
		local lists = lua_string_split_line(event.data, "\r\n")
		local list = lua_string_splits(lists, " ")
		local data = nil
		local request = NetworkManager:findByCommandString(list[2])
		if nil ~= request then
			data = request

			data.readyState = NetworkAdaptor.XMLHttpRequest.readyState.DONE

			data.resouce = event.data
			data.resouce_serializer = list
			data.dataState = NetworkAdaptor.dataState.DONE
			data.RESPONSE_SUCCESS = true

			NetworkAdaptor.reconnect_count = 0
			NetworkAdaptor.retry_count = 0
		else
			data = list
			NetworkProtocol.parser_lua_socket_func(data)
		end
	end
	NetworkAdaptor.LuaSocket.keepalive = true
	NetworkAdaptor.LuaSocket.heartbeat = true
end)

sock:on("heartbeat", function(event)
	-- print("heartbeat", NetworkAdaptor.LuaSocket.heartbeat, NetworkAdaptor.LuaSocket.heartbeat_count)
	if NetworkAdaptor.LuaSocket.heartbeat == false then
		-- NetworkAdaptor.LuaSocket.status = -1
		-- NetworkAdaptor.LuaSocket.reconnect = false
		-- print("socketClose:5")
		sock:close()
		-- FURY: este cierre es LOCAL y no dispara el evento `close`, asi que
		-- `status` se quedaba en 1 y nadie llamaba a `reconnectSocket`: todo
		-- `socketSend` posterior caia en un socket muerto (rueda y «La red es
		-- inestable»). Es el unico detector de una red caida EN SILENCIO
		-- (sin FIN/RST), y tiene que reconectar igual que el evento `close`.
		NetworkAdaptor.LuaSocket.status = -1
		fwin:addService({
			callback = function ( params )
				if nil ~= NetworkAdaptor.LuaSocket.url and false == NetworkAdaptor.LuaSocket.reconnect then
					NetworkAdaptor.reconnectSocket()
				end
			end,
			delay = 0.1,
			params = nil
		})
		return
	end
	NetworkAdaptor.LuaSocket.heartbeat_count = NetworkAdaptor.LuaSocket.heartbeat_count + 1
	if NetworkAdaptor.LuaSocket.heartbeat_count > 2 then
		NetworkAdaptor.LuaSocket.heartbeat = false
		NetworkAdaptor.LuaSocket.heartbeat_count = 0
	end
	sock:sendmessage("heartbeat")
end)

sock:on("close", function(event)
	-- print("close: bye!")
	
	-- print("socketClose:6")
	sock:close()

	NetworkAdaptor.LuaSocket.status = -1
	-- NetworkAdaptor.LuaSocket.reconnect = false
	-- state_machine.excute("logout_tip_window_open", 0, 0)
	fwin:addService({
        callback = function ( params )
			if nil ~= NetworkAdaptor.LuaSocket.url and false == NetworkAdaptor.LuaSocket.reconnect then
				NetworkAdaptor.reconnectSocket()
			end
        end,
        delay = 0.1,
        params = nil
    })
end)

sock:on("error", function(event)
	-- print(string.format("c line: %s. error: %s. message: %s.", event.line, event.error, event.message))
	-- if 5 == event.error then
	-- 	-- print("close: bye!")
	-- 	NetworkAdaptor.LuaSocket.status = -1
	-- 	NetworkAdaptor.LuaSocket.reconnect = false
	-- 	-- state_machine.excute("logout_tip_window_open", 0, 0)
	-- 	fwin:addService({
	--         callback = function ( params )
	-- 			if nil ~= NetworkAdaptor.LuaSocket.url then
	-- 				NetworkAdaptor.reconnectSocket()
	-- 			end
	--         end,
	--         delay = 0.1,
	--         params = nil
	--     })
	-- end
end)

-- sock:on("wait", function(event)
	
-- end)

-- sock:on("timeout", function(event)
	
-- end)

local option = {
	keepalive = 1,
	keepidle = 65,
	keepintvl = 55,--10
	keepcnt = 50,--3
	keepheartbeat = 15,
}
sock:setopt(option)

function NetworkAdaptor.init( ... )
	NetworkAdaptor.mode = CreateEnumTable({
		"HTTP",
	    "SOCKET",
	    "WEBSOCKET",
	    "LUASOCKET",
	})
	NetworkAdaptor.dataState = CreateEnumTable({
		"ERROR",
		"IDLE",
		"READY",
	    "ONTHEWAY",
		"DONE",
		"ERRORNETWORK",
	    "AGAIN_REQUEST"
	})
	NetworkAdaptor.XMLHttpRequest.readyState = CreateEnumTable({
		"UNSENT",
	    "OPENED",
	    "HEADERS_RECEIVED",
	    "LOADING",
	    "DONE"
	})
	NetworkAdaptor.XMLHttpRequest.RESPONSE_SUCCESS = 200
	NetworkAdaptor.XMLHttpRequest.RESPONSE_FAIL    = 0
end

function NetworkAdaptor.socketInit(url)
	if true == NetworkAdaptor.LuaSocket.socket_event then
		-- if NetworkAdaptor.LuaSocket.status == -1 then
			NetworkAdaptor.LuaSocket.url = url
			if nil ~= NetworkAdaptor.LuaSocket.url then
				local params = zstring.split(NetworkAdaptor.LuaSocket.url, ":")
			    local host = params[1]
			    local port = zstring.tonumber(params[2])
			    -- NetworkAdaptor.LuaSocket.status = 0

				NetworkAdaptor.LuaSocket.heartbeat = true
				NetworkAdaptor.LuaSocket.keepalive = true
				-- NetworkAdaptor.LuaSocket.reconnect = false
				-- NetworkAdaptor.reconnect_count = 0
				-- NetworkAdaptor.retry_count = 0

				sock:connect(host, port)
			end
		-- end
		return
	end

	NetworkAdaptor.socketClose()
	NetworkAdaptor.LuaSocket.url = url
    local socket = require("socket")
    local params = zstring.split(NetworkAdaptor.LuaSocket.url, ":")
    local host = params[1]
    local port = zstring.tonumber(params[2])
    NetworkAdaptor.LuaSocket.tcp = socket.tcp()
    local n, e = NetworkAdaptor.LuaSocket.tcp:connect(host, port)
    -- print("connect:", n, e)
    if nil == e then
    	NetworkAdaptor.LuaSocket.tcp:settimeout(0)
    else
    	NetworkAdaptor.LuaSocket.tcp = nil
    end
end

function NetworkAdaptor.socketIsOpen()
	if true == NetworkAdaptor.LuaSocket.socket_event then
		if NetworkAdaptor.LuaSocket.status == 1 then
			return true
		else
			return false
		end
	end
	if nil ~=  NetworkAdaptor.LuaSocket.tcp 
		and nil ~= NetworkAdaptor.LuaSocket.tcp.close
		then
		return true
	end
	return false
end

function NetworkAdaptor.socketClose()
	-- print("close")
	if true == NetworkAdaptor.LuaSocket.socket_event then
		NetworkAdaptor.LuaSocket.url = nil
		
		NetworkAdaptor.LuaSocket.heartbeat = true
		
		NetworkAdaptor.LuaSocket.keepalive = true
		
		NetworkAdaptor.reconnect_count = 0
		NetworkAdaptor.LuaSocket.reconnect = false
		
		-- print("socketClose:1")
		sock:close()
		return
	end
	if nil ~=  NetworkAdaptor.LuaSocket.tcp 
		and nil ~= NetworkAdaptor.LuaSocket.tcp.close
		then
    	NetworkAdaptor.LuaSocket.tcp:close()
	end
    NetworkAdaptor.LuaSocket.tcp = nil
end

function NetworkAdaptor.reconnectSocket()
	-- if NetworkAdaptor.socketIsOpen() == false then 
		
	-- end
	if true == NetworkAdaptor.LuaSocket.socket_event then
		-- if NetworkAdaptor.reconnect_count >= NetworkAdaptor.LuaSocket.reconnect_max_count then
		-- 	NetworkAdaptor.reconnect_count = 0
		-- 	NetworkAdaptor.LuaSocket.reconnect = false
		-- 	NetworkView:connectingErase()
		-- 	state_machine.excute("reconnect_view_window_open", 0, 0)
		-- 	return
		-- end
		-- NetworkAdaptor.LuaSocket.reconnect = true
		-- NetworkAdaptor.reconnect_count = NetworkAdaptor.reconnect_count + 1

		-- fwin:addService({
	 --        callback = function ( params )
		-- 		if params == NetworkAdaptor.reconnect_count 
		-- 			and NetworkAdaptor.LuaSocket.reconnect == true
		-- 			then
		-- 			NetworkAdaptor.reconnectSocket()
		-- 		end
	 --        end,
	 --        delay = 5,
	 --        params = NetworkAdaptor.reconnect_count
	 --    })

	    if NetworkAdaptor.LuaSocket.status ~= -1 then
	    	-- print("socketClose:2")
	    	sock:close()
	    else
			-- FURY: el cerrojo APLAZA la reconexion, no la cancela.
			--
			-- `NetworkView._lock` se pone antes de lanzar una peticion
			-- HTTP y solo se limpia dentro de `onReadyStateChange`
			-- (:512). Sirve para no cerrar la ruedecita a media
			-- peticion, pero aqui, con un `return` a secas, se comia la
			-- UNICA llamada que hace el evento `close` del socket
			-- (:100-108) y el socket ya no se reconectaba NUNCA.
			--
			-- Pasa justo al volver de segundo plano: Android congela el
			-- planificador de Cocos, la respuesta pendiente no se
			-- entrega y el cerrojo sigue cerrado cuando llega el aviso
			-- de socket cerrado. A partir de ahi el juego "parece que
			-- funciona" y todo lo que se pulsa da error, que es
			-- exactamente lo que se veia.
			if true == NetworkView._lock then
				fwin:addService({
			        callback = function ( params )
						NetworkAdaptor.reconnectSocket()
			        end,
			        delay = 1,
			        params = nil
			    })
				return
			end
			fwin:addService({
		        callback = function ( params )
					NetworkView:connectingErase()
					if NetworkAdaptor.LuaSocket.reconnect == true then
						if NetworkAdaptor.reconnect_count >= NetworkAdaptor.reconnect_max_count then
							NetworkAdaptor.LuaSocket.reconnect = false
							NetworkAdaptor.retry_count = NetworkAdaptor.retry_max_count
							if NetworkAdaptor.LuaSocket.status ~= -1 then
								-- print("socketClose:3")
								sock:close()
							end
							if true == NetworkView._lock then
								return
							end
							state_machine.excute("logout_tip_window_open", 0, 0)
						else
							if true == NetworkView._lock then
								return
							end
							state_machine.excute("reconnect_view_window_open", 0, nil)
						end
					end
		        end,
		        delay = 5,
		        params = NetworkAdaptor.reconnect_count
		    })
			NetworkAdaptor.LuaSocket.reconnect = true
			NetworkAdaptor.reconnect_count = NetworkAdaptor.reconnect_count + 1
			NetworkAdaptor.intSocket()
			state_machine.excute("connecting_view_window_open", 0, 0)
	    end
	else
		NetworkAdaptor.intSocket()
	end
end

function NetworkAdaptor.restartSocket()
	local url = NetworkAdaptor.LuaSocket.url
	if nil == url then
		return
	end

	NetworkAdaptor.socketClose()

	NetworkAdaptor.LuaSocket.url = url
	NetworkAdaptor.reconnectSocket()
end

function NetworkAdaptor.socketSend(sendStr, request)
	-- local sendData = cc.DBytes:new(sendStr)
	-- cc.deflateMemory(sendData)
	-- blowfish:encrypt(sendData)
	-- -- print("send:", sendStr)
 --    local ret = NetworkAdaptor.LuaSocket.tcp:send(sendData:getBytes() .. "\n")
 --    -- print("ret : ", ret)
	-- sendData:release()

	if true == NetworkAdaptor.LuaSocket.socket_event then
		if true == NetworkAdaptor.LuaSocket.reconnect then
			return
		end

		NetworkAdaptor.LuaSocket.send_count = NetworkAdaptor.LuaSocket.send_count + 1

		if NetworkAdaptor.LuaSocket.keepalive == true then
			local timeOut = 5
			if nil ~= request and request.timeOut > 0 then
	    		timeOut = request.timeOut
	    	end
			fwin:addService({
		        callback = function ( params )
		        	local request = params.req
		        	if params.count == NetworkAdaptor.LuaSocket.send_count then
			        	if NetworkAdaptor.LuaSocket.keepalive == false and false == NetworkAdaptor.LuaSocket.reconnect then
							state_machine.excute("connecting_view_window_open", 0, 0)
							fwin:addService({
								callback = function ( params )
									local data = params
									if nil ~= data then
										NetworkAdaptor.retry_count = NetworkAdaptor.retry_count + 1
										data.dataState = NetworkAdaptor.dataState.ERRORNETWORK
										data.RESPONSE_SUCCESS = false
									end
									NetworkView:connectingErase()
								end,
								delay = 5,
								params = request
							})
						else
							if nil ~= request then
								request.dataState = NetworkAdaptor.dataState.ERRORNETWORK
								request.RESPONSE_SUCCESS = false
							end
							NetworkView:connectingErase()
						end
					else
						if nil ~= request then
							request.dataState = NetworkAdaptor.dataState.ERRORNETWORK
							request.RESPONSE_SUCCESS = false
						end
						NetworkView:connectingErase()
					end
		        end,
		        delay = timeOut,
		        params = {count = NetworkAdaptor.LuaSocket.send_count, req = request}
		    })
		else
			if NetworkAdaptor.retry_count >= NetworkAdaptor.retry_max_count then
				NetworkAdaptor.reconnectSocket()
				return
			end
			state_machine.excute("connecting_view_window_open", 0, 0)
			fwin:addService({
		        callback = function ( params )
		        	NetworkView:connectingErase()
		        	if params.count == NetworkAdaptor.LuaSocket.send_count then
						if NetworkAdaptor.LuaSocket.keepalive == false 
							and false == NetworkAdaptor.LuaSocket.reconnect 
							then
							if NetworkAdaptor.LuaSocket.status ~= -1 then
								if NetworkAdaptor.retry_count >= NetworkAdaptor.retry_max_count then
									if true == NetworkView._lock then
										return
									end
									state_machine.excute("reconnect_view_window_open", 0, nil)
								end
							end
						end
					end
		        end,
		        delay = 5,
		        params = {count = NetworkAdaptor.LuaSocket.send_count, req = request}
		    })
			NetworkAdaptor.retry_count = NetworkAdaptor.retry_count + 1
		end
		NetworkAdaptor.LuaSocket.keepalive = false
		-- sendStr = zstring.replace(sendStr, "\r\n", " ")
		-- sock:send(sendStr)
		sock:sendmessage(sendStr, blowfish._key)
		return
	end

	sendStr = zstring.replace(sendStr, "\r\n", " ")
	local ret = NetworkAdaptor.LuaSocket.tcp:send(sendStr .. "\n")
    return ret
end

function NetworkAdaptor.socketReceive()
	if nil == NetworkAdaptor.LuaSocket.tcp then
		return
	end
    local response, receive_status, overflow = NetworkAdaptor.LuaSocket.tcp:receive()
	-- print("receive:", response or "nil", receive_status or "nil")
    if receive_status ~= "closed" then
        if response and #response > 0 then
		 --    local responseData = cc.DBytes:new(response)
			-- blowfish:decrypt(responseData)
			-- cc.inflateMemory(responseData)
			-- response = string.sub(responseData:getBytes(), 1, responseData:getSize())
			-- responseData:release()
   --          print("Receive Message:", response, #response)
            NetworkProtocol.parser_socket_func(response)
        end
    else
    	NetworkAdaptor.socketClose()
    	NetworkAdaptor.LuaSocket.tcp = nil
        -- print("Service Closed!")
    end
end

-- data :
-- 	命令行参数：command
--	发送的字符串：str
-- 	请求的地址：url
-- 	通讯的方式：mode
-- 	请求的类型：nType
-- 	绑定的UI对象：node
-- 	绑定UI的回调：handler
-- 	是否显示等待loading画面：showWaitView
-- 	请求的延迟时间：timeOut
-- 	返回的信息：resouce
-- 	请求状态：readyState
-- 	网络通讯状态：status
--	发送的异常错误码：error_code
--	发送的异常错误提示：error_string
--  网络对象状态：dataState
function NetworkAdaptor.send(data)
	if nil == data.data or "" == data.data then
		data.error_code = -1
		data.error_string = "发送失败->请求的数据为：" .. (nil == data.data and "nil" or "空")
	elseif nil == data.url or "" == data.url then
		data.error_code = -2
		data.error_string = "发送失败->请求的地址为：" .. (nil == data.url and "nil" or "空")
	elseif NetworkAdaptor.mode.HTTP == data.mode then
		if nil == data.nType or "" == data.nType then
			data.error_code = -3
			data.error_string = "发送失败->数据发送类型为：" .. (nil == data.nType and "nil" or "空")
		elseif "GET" ~= data.nType and "POST" ~= data.nType then
			data.error_code = -4
			data.error_string = "发送失败->数据发送类型不合法：" .. (data.nType)
		end
	end
	-- 校验是否有参数异常
	if data.error_code < 0 then
		data.dataState = NetworkAdaptor.dataState.ERROR
		return
	end
	
	-- 对数据进行加密、压缩等待操作，在发送数据的时候由客户端先对数据进压缩，再进行加密处理，接收的的数据是逆向操作
	-- 压缩后续处理
	-- require "src/frameworks/external/blowfish/blowfish"
	if NetworkAdaptor.mode.HTTP == data.mode then
		if data.str == nil then
			 data.str = NetworkProtocol.command_func(data.command, data.data)
		end
		-- Android's native binary wrapper differs from the PC implementation.
		-- Use the server's explicit text transport only for its protocol endpoint.
		local textWire = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID
			and (data.url:match('/iniServer$') or data.url:match('/iniServer%?')) ~= nil
		local sendData
		if not textWire then
			sendData = cc.DBytes:new(data.str)
			cc.deflateMemory(sendData)
			blowfish:encrypt(sendData)
		end

		data.dataState = NetworkAdaptor.dataState.READY
		local xhr = cc.XMLHttpRequest:new()
		xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
		xhr.timeout = data.timeOut > 0 and data.timeOut or xhr.timeout
		local function onReadyStateChange()
			NetworkView._lock = false
			data.readyState = xhr.readyState
			data.status = xhr.status
			data.dataState = NetworkAdaptor.dataState.ONTHEWAY
			if xhr.readyState == NetworkAdaptor.XMLHttpRequest.readyState.DONE then
				-- debug.log(true, "=============onReadyStateChange=============DONE")
				if xhr.status >= NetworkAdaptor.XMLHttpRequest.RESPONSE_SUCCESS and xhr.status < NetworkAdaptor.XMLHttpRequest.RESPONSE_SUCCESS + 7 then
					-- 接收到的数据需要先解密再解压
					local responseData = cc.DBytes:new("0")
					xhr:data(responseData)
					if responseData:getSize() == 0 then
						print("error 01 - xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
						-- data.dataState = NetworkAdaptor.dataState.AGAIN_REQUEST
						-- data.RESPONSE_SUCCESS = true
						data.readyState   = NetworkAdaptor.XMLHttpRequest.readyState.UNSENT
						data.dataState = NetworkAdaptor.dataState.ERRORNETWORK
						data.RESPONSE_SUCCESS = false
					else
						if not textWire then
							blowfish:decrypt(responseData)
							cc.inflateMemory(responseData)
						end
						data.resouce = string.sub(responseData:getBytes(), 1, responseData:getSize())
						local lists = lua_string_split_line(data.resouce, "\r\n")
						local list = lua_string_splits(lists, " ")
						data.resouce_serializer = list
						if #list <= 1 then
							print("error 02 - xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
							data.str = list[1]
							-- data.dataState = NetworkAdaptor.dataState.AGAIN_REQUEST
							-- data.RESPONSE_SUCCESS = true
							data.readyState   = NetworkAdaptor.XMLHttpRequest.readyState.UNSENT
							data.dataState = NetworkAdaptor.dataState.ERRORNETWORK
							data.RESPONSE_SUCCESS = false
						else
							--data.resouce = blowfish.decrypt(sendData)
							-- debug.log(true, "=============data.resouce=============\r\n", #data.resouce < 1024 and data.resouce or "big data!")
							-- if #data.resouce < 512 then
								-- debug.log(true, "=============data.resouce=============\r\n", data.resouce)
								if data.command ~= 8 then
									debug.log(false, "=============data.resouce=============\r\n", data.resouce,
									"===================================\r\n")
								end
							-- end
							data.dataState = NetworkAdaptor.dataState.DONE
							data.RESPONSE_SUCCESS = true
							-- debug.log(true, "=============onReadyStateChange=============\r\nRESPONSE_SUCCESS")
						end
					end
					responseData:release()
					NetworkAdaptor.reconnect_count = 0
					NetworkAdaptor.retry_count = 0
				else
					print("error - xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
					data.readyState   = NetworkAdaptor.XMLHttpRequest.readyState.UNSENT
					data.dataState = NetworkAdaptor.dataState.ERRORNETWORK
					data.RESPONSE_SUCCESS = false
					NetworkAdaptor.retry_count = NetworkAdaptor.retry_count + 1
				end
			else
				print("xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
				data.readyState   = NetworkAdaptor.XMLHttpRequest.readyState.UNSENT
				data.dataState = NetworkAdaptor.dataState.ERRORNETWORK
				data.RESPONSE_SUCCESS = false
				NetworkAdaptor.retry_count = NetworkAdaptor.retry_count + 1
			end
			if NetworkAdaptor.retry_count < NetworkAdaptor.retry_max_count 
				and false == NetworkAdaptor.LuaSocket.reconnect
				then
				if NetworkAdaptor.LuaSocket.status == -1 
					and NetworkAdaptor.LuaSocket.url ~= nil 
					then
					NetworkAdaptor.reconnectSocket()
				end
			end
		end
		NetworkView._lock = true
		xhr:registerScriptHandler(onReadyStateChange)
		local requestUrl = data.url
		if textWire then
			requestUrl = requestUrl .. (requestUrl:find('?',1,true) and '&' or '?') .. 'nr_transport=text-v1'
		end
		xhr:open(data.nType, requestUrl)
		-- FURY (2-oct): DOS MOVILES EN LA MISMA WIFI se echaban el uno al otro,
		-- porque el servidor ataba la sesion a la IP. Cada peticion lleva el
		-- token de la cuenta (S2C 327) y el servidor distingue el movil. La
		-- marca `fury_device_header_ok` dice al 6101 que tambien lo mande
		-- (ProtocolCommanderCopyExx.lua): sin cabecera, ninguno de los dos.
		if userLoginToken ~= nil and userLoginToken ~= "" then
			fury_device_header_ok = pcall(function()
				xhr:setRequestHeader("X-Fury-Device", userLoginToken)
			end)
		end
		--xhr:send同步请求，阻塞网络，直到xhr.readyState为4并且服务器的响应被完全接收
		--xhr:abort() -- 用于中断网络，如果请求用了太长时间，而且响应不再必要的时候
		-- debug.log(true, "=============xhr:send(sendData)========start========")
		-- Fury: reloj en segundos con decimales (os.time() solo da segundos enteros)
		data.start_time = fury_ahora()
		if textWire then
			xhr:send(data.str)
		else
			xhr:send_d(sendData)
			sendData:release()
		end
		-- debug.log(true, "=============xhr:send(sendData)========over========")
	elseif NetworkAdaptor.mode.SOCKET == data.mode then
	elseif NetworkAdaptor.mode.WEBSOCKET == data.mode then
		if true then

		else
			-- 暂未实现
			local LuaWebSocket = NetworkAdaptor.WebSocket
			if LuaWebSocket.socket ~= nil then
				if LuaWebSocket.socket:getReadyState() == cc.WEBSOCKET_STATE_CONNECTING then
					-- data.dataState = NetworkAdaptor.dataState.READY
					-->__crint("创建连接中")
				elseif LuaWebSocket.socket:getReadyState() == cc.WEBSOCKET_STATE_OPEN then
					-->__crint("数据发送中")
					local sendData = cc.DBytes:new(data.str)
					cc.deflateMemory(sendData)
					blowfish:encrypt(sendData)
					-->__crint(data.str)
					LuaWebSocket.socket:sendString(data.str)
					data.dataState = NetworkAdaptor.dataState.ONTHEWAY
					sendData:release()
				elseif LuaWebSocket.socket:getReadyState() == cc.WEBSOCKET_STATE_CLOSING then
					-->__crint("连接关闭中")
					LuaWebSocket.socket:close()
				elseif LuaWebSocket.socket:getReadyState() == cc.WEBSOCKET_STATE_CLOSED then
					-->__crint("连接关闭了")
					LuaWebSocket.socket = nil
					LuaWebSocket.url = nil
				else
					LuaWebSocket.socket = nil
					LuaWebSocket.url = nil
					-->__crint("未知的状态")
				end
			end
			if LuaWebSocket.socket == nil or LuaWebSocket.url == nil or LuaWebSocket.url ~= data.url then
				local function wsOpen(strData) 
					-->__crint("Send Text WS was opened.", strData)
				end 
				  
				local function wsMessage(strData) 
				    -->__crint("response text msg: ", strData) 
				    -- 接收到的数据需要先解密再解压
					local responseData = cc.DBytes:new("0")
					xhr:data(responseData)
					blowfish:decrypt(responseData)
					cc.inflateMemory(responseData)
					data.resouce = string.sub(responseData:getBytes(), 1, responseData:getSize())

					data.dataState = NetworkAdaptor.dataState.DONE
					data.RESPONSE_SUCCESS = true
					responseData:release()
				end 
				  
				local function wsClose(strData) 
				    -->__crint("sendText websocket instance closed.", strData)
				    -->__crint("连接关闭了!")
					LuaWebSocket.socket = nil
					LuaWebSocket.url = nil
				end 
				  
				local function wsError(strData) 
				    -->__crint("sendText Error was fired", strData) 
				end
				-->__crint("创建连接:", data.url)
				LuaWebSocket.socket = cc.WebSocket:create(data.url)
				if nil ~= LuaWebSocket.socket then 
					LuaWebSocket.socket:registerScriptHandler(wsOpen,cc.WEBSOCKET_OPEN) 
					LuaWebSocket.socket:registerScriptHandler(wsMessage,cc.WEBSOCKET_MESSAGE) 
					LuaWebSocket.socket:registerScriptHandler(wsClose,cc.WEBSOCKET_CLOSE) 
					LuaWebSocket.socket:registerScriptHandler(wsError,cc.WEBSOCKET_ERROR) 
				end
				LuaWebSocket.url = data.url
			end
		end
	elseif NetworkAdaptor.mode.LUASOCKET == data.mode then
		data.dataState = NetworkAdaptor.dataState.READY
		NetworkAdaptor.socketSend(data.str, data)
	end
	-- sendData:release()
end

function NetworkAdaptor.intSocket()
	NetworkAdaptor.socketInit(NetworkAdaptor.LuaSocket.url)
	function requstSocket()
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		else
			state_machine.excute("logout_tip_window_open", 0, 0)
		end
		-- 
        -- NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.init_user_socket_service.code))
        -- NetworkAdaptor.socketSend(NetworkProtocol.command_init_user_socket_service)
	end
	if true == NetworkAdaptor.LuaSocket.socket_event then

	else
		if NetworkAdaptor.socketIsOpen() == true then
			-- requstSocket()
			NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.init_user_socket_service.code))
		-- else
		-- 	state_machine.excute("logout_tip_window_open", 0, 0)
		end
	end
end
