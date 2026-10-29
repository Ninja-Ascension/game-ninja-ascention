-- Fury: reloj con decimales (luasocket, socket.core va dentro de libjts.so);
-- si no estuviera, os.time() como antes.
local fury_ok_reloj, fury_socket_core = pcall(require, "socket.core")
local fury_ahora = (fury_ok_reloj and type(fury_socket_core) == "table" and fury_socket_core.gettime) or os.time
NetworkManager = NetworkManager or {queue = {}, _url = nil, _wsurl = nil, _keepAliveCommand = nil, _keepAliveInterval = -1, _keepAliveElapsed = 0, _socketReceiveInterval = 0.5}

-------------------------------------------------------------------------------
--  网络对象【data】:
-------------------------------------------------------------------------------
-- 	命令行参数：			 command
--	发送的字符串：			 str
-- 	请求的地址：			 url
-- 	通讯的方式：			 mode
-- 	请求的类型：			 nType
-- 	绑定的UI对象：			 node
-- 	绑定UI的回调：			 handler
-- 	是否显示等待loading画面：showWaitView
-- 	请求的延迟时间：		 timeOut
-- 	返回的信息：			 resouce
-- 	请求状态：				 readyState
-- 	网络通讯状态码：		 status
--	发送的异常错误码：		 error_code
--	发送的异常错误提示：	 error_string
--  网络对象状态：			 dataState
--	请求成功				 RESPONSE_SUCCESS
--	协议状态码 		 		 PROTOCOL_STATUS
--	协议数据 		 		 protocol_datas
--	发送的起始时间 		 start_time
-------------------------------------------------------------------------------

-- 返回队列头部的元素，如果队列为空，则返回nil
function NetworkManager:peek()
	return nil == self.queue[1] and nil or self.queue[1]
end

-- 返回指定请求序列号的网络对象，若队列为空或不存在指定对象，则返回nil
function NetworkManager:find(command)
	if nil == NetworkManager:peek() then
		return nil
	end
	for k, v in ipairs(self.queue) do
		if command == v.command then
			return v
		end	
	end
	return nil
end

-- 检查队列头部的网络对象的发送是否结束
function NetworkManager:isQueueHeaderOver()
	local bRet = false
	-- 请求完成，但不一定返回成功
	if NetworkManager:peek().readyState == NetworkAdaptor.XMLHttpRequest.readyState.DONE 
		then
		bRet = true
	end
	return bRet
end

-- 添加网络对象
function NetworkManager:offer(data)
	table.insert(self.queue, data)
end

-- 移除并返回队列头部的网络对象，如果队列为空，则返回nil
function NetworkManager:poll()
	local tempData = NetworkManager:peek()
	if nil == tempData then
		return nil
	end
	table.remove(self.queue, 1)
	-- Ventana destruida mientras volaba la peticion: cocos 3.5 deja su peer vacio
	-- (roots y metodos a nil). El handler la ve como nil y sus guardas la saltan.
	if type(tempData.node) == "userdata" and tolua.isnull(tempData.node) then tempData.node = nil end
	if nil ~= tempData.handler then
		tempData.handler(tempData)
	end
	return tempData
end

function NetworkManager:findByCommandString(commandString)
	if nil == commandString or nil == NetworkManager:peek() then
		return nil
	end
	for k, v in ipairs(self.queue) do
		if nil ~= v.commandItem and commandString == v.commandItem.command then
			return v
		end	
	end
	return nil
end

function NetworkManager:removeGet(commandString)
	if nil == commandString or nil == NetworkManager:peek() then
		return nil
	end
	for k, v in ipairs(self.queue) do
		if nil ~= v.commandItem and commandString == v.commandItem.command then
			table.remove(self.queue, k, 1)
			return v
		end	
	end
	return nil
end

function NetworkManager:insertSet(pos, request)
	table.insert(self.queue, pos, request)
end

function NetworkManager:registerUrl(_url, _wsurl, _url_rf)
	NetworkManager._url = _url
	NetworkManager._wsurl = _wsurl
	NetworkProtocol.server_redirect_or_forward_url = _url_rf
end

function NetworkManager:registerKeepAlive(keepAliveCommand, keepAliveInterval)
	NetworkManager._keepAliveCommand = keepAliveCommand
	NetworkManager._keepAliveInterval = keepAliveInterval
end

-- 注册网络对象
function NetworkManager:register(_command, _url, _mode, _nType, _node, _handler, _showWaitView, _timeOut, _unreconnect, _str, _pos)
	if nil == _command or "number" ~= type(_command) then
		debug.log(true, "注册失败->网络序列号不可为"..(nil == _command and "nil" or "非number"))
		return nil
	end
	local _data = NetworkManager:find(_command) 
	if nil ~= _data then
		debug.log(true, "注册失败->网络队列已存在该请求")
	else
		
		_data = {}
		_data.command      = _command
		_data.commandItem  = nil
		_data.url          = (_url or NetworkManager._url)
		-- _data.str          = _str or NetworkProtocol.command_func(_command, _data)
		_data.data          = _data
		_data.mode         = _mode or NetworkAdaptor.mode.HTTP
		_data.nType        = _nType or "POST"
		_data.node         = _node
		_data.handler      = _handler
		_data.showWaitView = true == _showWaitView and true or false
		_data.timeOut      = nil == _timeOut and 0 or _timeOut
		_data.unreconnect = _unreconnect or false
		_data.resouce      = nil
		_data.readyState   = NetworkAdaptor.XMLHttpRequest.readyState.UNSENT
		_data.status       = nil
		_data.error_code   = 0
		_data.error_string = ""
		_data.dataState	   = NetworkAdaptor.dataState.IDLE
		_data.RESPONSE_SUCCESS = false
		_data.PROTOCOL_STATUS = 0
		_data.protocol_datas = {}
		_data.start_time = 0
		_data.delay = 0
		_data.againRequestCount = 100
		_data.resouce_serializer = nil

		if true == NetworkProtocol.open_server_redirect_or_forward 
			and nil ~= NetworkProtocol.server_redirect_or_forward_url
			then
			_data.url = NetworkProtocol.server_redirect_or_forward_url
		end
		
		if _data.mode == NetworkAdaptor.mode.HTTP then
			local targetPlatform = cc.Application:getInstance():getTargetPlatform()
			if cc.PLATFORM_OS_IPHONE == targetPlatform
				or cc.PLATFORM_OS_ANDROID == targetPlatform
				or cc.PLATFORM_OS_MAC == targetPlatform
				or cc.PLATFORM_OS_IPAD == targetPlatform
				then
				local s, e = string.find(_data.url, "http://")
				if s ~= nil and s > 0 then
				else
					s, e = string.find(_data.url, "https://")
					if s ~= nil and s > 0 then
					else
						_data.url = "http://" .. _data.url
					end
				end
			end
		elseif _data.mode == NetworkAdaptor.mode.LUASOCKET then
		else
			_data.url 		= (_url or NetworkManager._wsurl)
		end
		
		if nil ~= _pos and _pos > 0 then
			NetworkManager:insertSet(_pos, _data)
		else
			NetworkManager:offer(_data)
		end
	end	
	return _data
end


-- UN COMANDO POR SOCKET QUE ESPERA LA RESPUESTA.
--
-- `NetworkAdaptor.socketSend` a pelo no devuelve nada, asi que los cuatro
-- sitios que lo usaban para `send_message` se INVENTABAN el exito: llamaban
-- a su propio callback en la linea siguiente con RESPONSE_SUCCESS = true.
-- El cartel de «invitacion enviada» salia igual aunque no saliera nada.
--
-- Registrando la peticion, la respuesta del socket la casa por el NOMBRE del
-- comando (NetworkAdaptor.lua:52 -> NetworkManager:findByCommandString) y la
-- cola llama al callback con el estado de verdad. Un error del protocolo sale
-- por el aviso normal (NetworkProtocol.lua:137) y un corte de red por la rueda
-- de reconectar, que es justo lo que hacia falta.
function NetworkManager:socketRequest(_command, _node, _handler)
	local commandItem = NetworkProtocol.find_command(_command)
	if nil == commandItem or nil ~= NetworkManager:find(_command) then
		return nil
	end
	local request = NetworkManager:register(_command, nil, NetworkAdaptor.mode.LUASOCKET,
	                                        nil, _node, _handler, true, nil)
	if nil == request then
		return nil
	end
	-- El sobre se arma SIN pasarle la peticion: por socket no hay url que
	-- anteponer y `command_func` la antepondria si el reenvio estuviera
	-- encendido.
	request.commandItem = commandItem
	request.str = NetworkProtocol.command_func(_command)
	return request
end

-- 每帧管理网络请求队列的定时器
function NetworkManager.updateRequestQueue(dt)
	NetworkManager._socketReceiveInterval = NetworkManager._socketReceiveInterval + dt
	if NetworkManager._socketReceiveInterval > 0.5 then
		-- NetworkManager._socketReceiveInterval = 0
		NetworkAdaptor.socketReceive()
	end
	if NetworkManager._keepAliveCommand ~= nil and NetworkManager._keepAliveCommand > 0
		and NetworkManager._keepAliveInterval ~= nil and NetworkManager._keepAliveInterval > 0 then
		NetworkManager._keepAliveElapsed = NetworkManager._keepAliveElapsed + dt
		if NetworkManager._keepAliveElapsed > NetworkManager._keepAliveInterval then
			NetworkManager._keepAliveElapsed = 0
			NetworkManager:register(NetworkManager._keepAliveCommand, nil, nil, nil, nil, nil, false, nil, true)
		end
	end
	local request = NetworkManager:peek()
	if nil == request or NetworkAdaptor.LuaSocket.reconnect == true then
		return
	end
	if false == request.showWaitView and request.start_time ~= 0 then
		-- Fury: la ruedecita de las peticiones de fondo a los 5 s (antes 3-5 s con os.time())
		if (fury_ahora() - request.start_time) > 5 then
			request.showWaitView = true
			NetworkView:connectingViewDisplay(request)
		end
	end
	
	if NetworkManager:isQueueHeaderOver() then
		if request.dataState == NetworkAdaptor.dataState.AGAIN_REQUEST then
			request.againRequestCount = request.againRequestCount - 1
			if request.againRequestCount >= 0 then
				request.readyState   = NetworkAdaptor.XMLHttpRequest.readyState.UNSENT
				request.dataState = NetworkAdaptor.dataState.IDLE
				request.delay = request.delay + 0.5
				if request.delay > 3 then
					request.delay = 3
				end
			else
				request.dataState = NetworkAdaptor.dataState.ERRORNETWORK
				request.RESPONSE_SUCCESS = false
			end
		else
			if true == request.showWaitView then
				NetworkView:connectingErase()
			end	
			NetworkProtocol.parser_func(request)
			NetworkManager:poll()
			return
		end
	end
	
	if NetworkAdaptor.dataState.IDLE == request.dataState then
		request.delay = request.delay - dt
		if request.delay > 0.000001 then
			return
		end
		if true == request.showWaitView then
			NetworkView:connectingViewDisplay(request)
		end	
		NetworkAdaptor.send(request)
	elseif NetworkAdaptor.dataState.ERROR == request.dataState then
		if true == request.showWaitView then
			NetworkView:connectingErase(request)
		end	
		NetworkView:networkErrorViewDisplay(request)
		NetworkManager:poll()
	elseif request.dataState == NetworkAdaptor.dataState.ERRORNETWORK then
		if (fury_ahora() - request.start_time) < 6 then
			if false == request.showWaitView then
				request.showWaitView = true
				NetworkView:connectingViewDisplay(request)
			end	
			return
		end
		if true == request.showWaitView then
			NetworkView:connectingErase(request)
		end
		if request.unreconnect == true then
		else
			NetworkView:reconnectViewDisplay(request)
		end
		NetworkManager:poll()
	end
end