--------------------------------------------------------------------------------------------------------------
-- 消息管理器框架
-- 主要用于一对多的消息广播处理
-- 同一个消息名可以指向多个对象作出响应
-- 消息名不唯一,该消息名下的对象唯一
-- 不接受同一个对象多次用同一个消息名注册
-- -------------------------------------------
-- 注册了消息句柄就要记得手动释放,请谨慎使用,避免泄露!!!
-- -------------------------------------------
-- 在"三国志"功能中有使用该对象
-- -------------------------------------------
-- 注册消息 (messageName: string 消息名, instance: userdata 响应的对象,  messageCallback: function(回调函数) or string(instance中的回调函数名))
-- ObjectMessage.addMessageListener("destiny_icon_cell_update_all_state", self, self.updateAllState)
-- return ErrorData 
-- 注:messageCallback函数格式声明(function(instance, params))

-- 删除消息 (messageName: string 消息名, instance: userdata 响应的对象)
-- ObjectMessage.removeMessageListener("destiny_icon_cell_update_all_state",self)
-- return ErrorData

-- 发起消息 (messageName: string 消息名, params: 任意对象类型(建议table) 附带参数(可选) 该参数在传递中不会被检查的,由发起者和接收者自行检查)
-- ObjectMessage.fireMessage("destiny_icon_cell_update_all_state")
-- ObjectMessage.fireMessage("destiny_icon_cell_update_all_state", params)
-- return ErrorData

-- 删除所有消息
-- ObjectMessage.removeAllMessageListener()

-- ErrorData :table 调用后返回成功或者失败的具体信息
--{
--   state = false,		-- (boolean) 当前状态. 默认false,表示无错误
--   code = -1,			-- (int) 信息码. 标示返回信息的类型.
--   info = "",			-- (string) 信息具体内容. 用于显示说明.
-- }
-- -------------------------------------------
-- to: 李彪
----------------------------------------------

-- 引入消息对象的定义事件名,以及数据格式
app.load("client.utils.objectMessage.ObjectMessageNameEnum")

-- 定义消息对象类
local function _ObjectMessage ()
	
	local LACK_MESSAGE_NAME 	= 0 -- messageName参数不正确
	local LACK_INSTANCE 		= 1 -- instance参数不正确
	local LACK_MESSAGE_CALLBACK = 2	-- messageCallback参数不正确
	local LACK_MESSAGE_REPEAT  	= 3 -- messageName参数重复注册了
	local LACK_MESSAGE_INVALID  = 4 -- messageName参数无效未注册过
	local LACK_MESSAGE_CALLBACK_INVALID = 5	-- messageCallback无效
	
	local LACK_MESSAGE_NAME_STRING 		= "messageName参数不正确"
	local LACK_INSTANCE_STRING 			= "instance参数不正确"
	local LACK_MESSAGE_CALLBACK_STRING 	= "messageCallback参数不正确"
	local LACK_MESSAGE_REPEAT_STRING 	= "messageName参数重复注册了"
	local LACK_MESSAGE_INVALID_STRING 	="messageName参数无效未注册过"
	local LACK_MESSAGE_CALLBACK_INVALID_STRING = "messageCallback无效 -> "
	
	
	-- 返回错误信息
	local function getErrorData(state, infoCode, info)
		-- local errorData = {
			-- state = false,		-- (boolean) 当前状态. 默认false,表示无错误
			-- code = -1,		-- (int) 信息码. 标示返回信息的类型.
			-- info = "",			-- (string) 信息具体内容. 用于显示说明.
		-- }
		return{
			state = state or false,		
			code = infoCode or -1,		
			info = info or "",			
		}
	end
	
	local data = {}
	
	local function _checkupParams(messageName, instance)
		if nil == messageName then
			return getErrorData(true, LACK_MESSAGE_NAME, LACK_MESSAGE_NAME_STRING)
		end
		
		if nil == instance then
			return getErrorData(true, LACK_INSTANCE, LACK_INSTANCE_STRING)
		end
	
		if type(data[messageName]) ~= "table" then
			return getErrorData(true, LACK_MESSAGE_INVALID, LACK_MESSAGE_INVALID_STRING)
		end
		return getErrorData()
	end
	
		
	local function _checkupKey(messageName, instance)
		for k,v in pairs(data[messageName]) do
			if v.instance == instance then
				return getErrorData(true, LACK_MESSAGE_REPEAT, LACK_MESSAGE_REPEAT_STRING)
			end	
		end
		return getErrorData()
	end
	
	
	local function _hasMessageListener(messageName, instance)
		local errorData = _checkupParams(messageName, instance)
		if errorData.state == true then
			return errorData
		end		
		
		errorData = _checkupKey(messageName, instance)
		if errorData.state == true then
			return errorData
		end	
		
		return getErrorData()
	end
	
	
	local function _removeMessageListener(messageName, instance)
		if nil == messageName then
			return getErrorData(true, LACK_MESSAGE_NAME, LACK_MESSAGE_NAME_STRING)
		end
		
		if nil == instance then
			return getErrorData(true, LACK_INSTANCE, LACK_INSTANCE_STRING)
		end
		
		if type(data[messageName]) ~= "table" then
			return getErrorData(true, LACK_MESSAGE_INVALID, LACK_MESSAGE_INVALID_STRING)
		end
		
		for i,v in ipairs(data[messageName]) do
			if v.instance == instance then
				data[messageName][i] = nil
				table.remove(data[messageName], i)
				if table.getn(data[messageName]) == 0 then
					--data[messageName] = nil
				end
				return getErrorData()
			end	
		end
		return getErrorData()
	end
	
	local function _addMessageListener(messageName, instance, messageCallback)
		if nil == messageCallback then
			return getErrorData(true, LACK_MESSAGE_CALLBACK, LACK_MESSAGE_CALLBACK_STRING)
		end
		
		local errorData = _hasMessageListener(messageName, instance)
		if errorData.state == true then
			if errorData.code == LACK_MESSAGE_INVALID then
				data[messageName] = {}
			else
				--return
				_removeMessageListener(messageName, instance)
			end
		end
		
		table.insert(data[messageName], {instance = instance, messageCallback = messageCallback})
		return getErrorData()
	end
	
	local function _fireMessage(messageName, params)
		if type(data[messageName]) ~= "table" then
			return getErrorData(true, LACK_MESSAGE_INVALID, LACK_MESSAGE_INVALID_STRING)
		end

		local errMessageCallback = ""
		for i,v in ipairs(data[messageName]) do
			if nil ~= v.messageCallback and nil ~= v.instance then
				if type(v.messageCallback) == "function" then
					--> print("--ms-1-----------------------------", v.instance, v.messageCallback, params)
					local _instance = v.instance
					local _messageCallback = v.messageCallback
					_messageCallback(_instance, params)
				elseif type(v.messageCallback) == "string" then
					if type(v.instance[v.messageCallback]) == "function" then
					
						--> print("--ms-2-----------------------------", v.instance, v.messageCallback, params)
						local _instance = v.instance
						local _messageCallback = v.messageCallback
						
						_instance[_messageCallback](_instance, params)
					else
						errMessageCallback = errMessageCallback.." "..tostring(v.messageCallback)
					end
				else
					errMessageCallback = errMessageCallback.." "..tostring(v.messageCallback)
				end
			end
		end
		
		if errMessageCallback ~= "" then
			return getErrorData(true, LACK_MESSAGE_CALLBACK_INVALID, LACK_MESSAGE_CALLBACK_INVALID_STRING..errMessageCallback)
		end
		return getErrorData()
	end
	
	
	local function _removeAllMessageListener()
		data = {}
	end

	return {
		
		fireMessage = _fireMessage,
		
		addMessageListener = _addMessageListener,
		
		removeMessageListener = _removeMessageListener,
		 
		removeAllMessageListener = _removeAllMessageListener,
		
		hasMessageListener = _hasMessageListener
	}	
end
ObjectMessage = _ObjectMessage()