NetworkProtocol = NetworkProtocol or {protocol_commands = {}, protocol_parses = {}, sequence = 0, lock = false, open_server_redirect_or_forward = false, server_redirect_or_forward_url = nil}

-- 根据协议接口序列号获取发送协议
function NetworkProtocol.find_command(code) 
	for k, v in pairs(NetworkProtocol.protocol_commands) do
		if tonumber(code) == v.code then
			return v
		end
	end
	debug.log(true, "无法找到匹配的发送接口:",code)
	return nil
end

function NetworkProtocol.find_command_string(commandString) 
	if nil == commandString then
		return nil
	end
	for k, v in pairs(NetworkProtocol.protocol_commands) do
		if commandString == v.command then
			return v
		end
	end
	debug.log(true, "无法找到匹配的发送接口:",code)
	return nil
end

-- 根据协议解析序列号获取接收协议
function NetworkProtocol.find_parser(code) 
	for k, v in pairs(NetworkProtocol.protocol_parses) do
		if tonumber(code) == v.code then
			return v
		end
	end
	debug.log(true, "无法找到匹配的解析协议:",code)
	return nil
end

-- 发送数据处理
function NetworkProtocol.command_func(code, request)
	local sequence = NetworkProtocol.sequence or 0
	local str = ""
	if true == NetworkProtocol.open_server_redirect_or_forward 
		and nil ~= NetworkProtocol.server_redirect_or_forward_url
		and nil ~= request
		and nil ~= request.url
		then
		str = str .. request.url .. "\r\n"
	end
	str = str..sequence
	local commandItem = NetworkProtocol.find_command(code)
	if commandItem ~= nil then 
		str = commandItem.command_fun(str)
	else
		str = nil
	end
	if nil ~= request then
		request.commandItem = commandItem
	end
	if NetworkProtocol.lock == false and NetworkProtocol.sequence ~= nil then
		NetworkProtocol.sequence = NetworkProtocol.sequence + 1
	end
	debug.log(true, "===============command_func=================",commandItem, code, str)
	return str
end

-- function NetworkProtocol.parser_socket_func(data)
	-- local lists = lua_string_split_line(data, "\r\n")
	-- list = lua_string_splits(lists, " ")
function NetworkProtocol.parser_socket_func(list)
	-- app.notification_center.running = true
	list.pos = 1
	while(true) do
		if list.pos > #list then
			break
		end	
		local code = list[list.pos]
		if code == nil or code == "" then
			break
		end
		code = tonumber(code)
		if code == nil or code == "" then
			break
		end
		list.pos = list.pos + 1
		debug.log(true, "protocol code:", code, "list pos:",list.pos)
		local parser = NetworkProtocol.find_parser(code)
		if nil ~= parser then
			parser.parser_fun(nil,nil,nil,nil,list,nil)
		else
			debug.log(true, "解析失败->格式错误3")
			break
		end	
	end
end

function NetworkProtocol.parser_lua_socket_func(data)
	-- app.notification_center.running = true
	local list = data.resouce_serializer
	if data.resouce_serializer == nil then
		local commandItem = NetworkProtocol.find_command_string(data[2])
		if nil ~= commandItem or data[2] == "error" then
			NetworkProtocol.parser_func({resouce_serializer = data})
		else
			NetworkProtocol.parser_socket_func(data)
		end
	else
		NetworkProtocol.parser_func(data)
	end
end

-- 接收数据处理
function NetworkProtocol.parser_func(data)
	-- app.notification_center.running = true
	local list = data.resouce_serializer
	if data.resouce_serializer == nil then
		local lists = lua_string_split_line(data.resouce, "\r\n")
		list = lua_string_splits(lists, " ")
	end

	-- -- Debug
	-- local ldata = app.fileUtils:getStringFromFile("login_init.log")
	-- if list[2] == "login_init" and (nil ~= ldata and #ldata > 10) then
	-- 	local lists = lua_string_split_line(ldata, "\r\n")
	-- 	list = lua_string_splits(lists, " ")
	-- end
	
	if #list < 3 then
		debug.log(true, "解析失败->格式错误1")
		return
	end
	if tonumber(list[1]) == nil or tonumber(list[2]) ~= nil or tonumber(list[3]) == nil then
		debug.log(true, "解析失败->格式错误2")
		return
	end
	data.PROTOCOL_STATUS = tonumber(list[3])
	state_machine.excute("mission_network_next_over", 0, list[2])
	if tonumber(list[3]) >= 0 then
		-- state_machine.excute("tuition_controller_network_node", 0, list[2])
		list.pos = 3
		list.pos = list.pos + 1
		while(true) do
			if list.pos > #list then
				break
			end	
			local code = list[list.pos]
			if code == nil or code == "" then
				break
			end
			code = tonumber(code)
			if code == nil or code == "" then
				break
			end
			list.pos = list.pos + 1
			debug.log(true, "protocol code:", code, "list pos:",list.pos)
			-- print(true, "protocol code:", code, "list pos:",list.pos)
			local parser = NetworkProtocol.find_parser(code)
			if nil ~= parser then
				if NetworkProtocol.__nr_restoring_login then print('NR_LOGIN_BLOCK_BEGIN code='..code..' pos='..list.pos) end
				parser.parser_fun(nil,nil,nil,nil,list,nil)
				if NetworkProtocol.__nr_restoring_login then print('NR_LOGIN_BLOCK_END code='..code..' pos='..list.pos) end
			else
				debug.log(true, "解析失败->格式错误3")
				break
			end	
		end
	else
		-- debug.log(true, "error code:",list[3])
		-- local errorTip = nil == list[4] and "网络无法连接,请重新连接！" or list[4]
		-- data.protocol_datas = list
		-- NetworkView:protocolErrorViewDisplay(data)

		list.pos = 3
		local code = tonumber(list[list.pos])
		if code == nil or code == "" then
			debug.log(true, "error code:",list[3])
			local errorTip = nil == list[4] and "网络无法连接,请重新连接！" or list[4]
			data.protocol_datas = list
			NetworkView:protocolErrorViewDisplay(data)
		else
			list.pos = list.pos + 1
			local parser = NetworkProtocol.find_parser(code)
			if nil ~= parser then
				parser.parser_fun(nil,nil,nil,nil,list,nil)
			else
				debug.log(true, "error code:",list[3])
				local errorTip = nil == list[4] and "网络无法连接,请重新连接！" or list[4]
				data.protocol_datas = list
				NetworkView:protocolErrorViewDisplay(data)
			end
		end
	end
end

function NetworkProtocol.npos(list)
	list.pos = list.pos + 1
	return list[list.pos - 1]
end
