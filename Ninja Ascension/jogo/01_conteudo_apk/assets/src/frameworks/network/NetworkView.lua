NetworkView = NetworkView or {_lock = false}

function NetworkView:register(_connectingView, _reconnectView, _networkErrorView, _protocolErrorView)
	if _connectingView ~= nil then
		NetworkView:connectingErase()
		NetworkView._connectingView = _connectingView
		NetworkView._connectingView:retain()
	end
	
	if _reconnectView ~= nil then
		NetworkView:reconnectErase()
		NetworkView._reconnectView = _reconnectView
		NetworkView._reconnectView:retain()
	end
	
	if _networkErrorView ~= nil then
		NetworkView:networkErrorViewErase()
		NetworkView._networkErrorView = _networkErrorView
		NetworkView._networkErrorView:retain()
	end
	
	if _protocolErrorView ~= nil then
		NetworkView:protocolErrorViewErase()
		NetworkView._protocolErrorView = _protocolErrorView
		NetworkView._protocolErrorView:retain()
	end
end

function NetworkView:connectingErase(request)
	if NetworkView._lock == true then
		return
	end
	state_machine.excute("connecting_view_window_close", 0, 0)
	if NetworkView._connectingView ~= nil then
		fwin:close(NetworkView._connectingView)
	else
		debug.log(true, "=============stop draw connecting icon=============")
	end
end

function NetworkView:connectingViewDisplay(request)
	if NetworkView._connectingView ~= nil then
		fwin:close(NetworkView._connectingView)
		if NetworkView._connectingView.reset ~= nil then
			NetworkView._connectingView:reset(request)
		end
		fwin:open(NetworkView._connectingView, fwin._system)
	else
		debug.log(true, "=============start draw connecting icon=============")
	end
end

function NetworkView:reconnectErase(request)
	if NetworkView._reconnectView ~= nil then
		fwin:close(NetworkView._reconnectView)
	end
end

function NetworkView:reconnectViewDisplay(request)
	if NetworkView._reconnectView ~= nil then
		fwin:close(NetworkView._reconnectView)

		if true == NetworkAdaptor.XMLHttpRequest.open_auto_reconnect then
			if NetworkAdaptor.retry_count >= NetworkAdaptor.retry_max_count then
				NetworkAdaptor.reconnect_count = NetworkAdaptor.reconnect_max_count
				state_machine.excute("logout_tip_window_open", 0, 0)
				return
			end
			NetworkAdaptor.reconnect_count = NetworkAdaptor.reconnect_count + 1
		end

		if fwin:find(NetworkView._reconnectView.__cname) == nil then
			if NetworkView._reconnectView.reset ~= nil then
				NetworkView._reconnectView:reset(request)
			end
			fwin:open(NetworkView._reconnectView, fwin._system)
		end
	else
		debug.log(true, "=============show reconnect dialog=============")
	end
end

function NetworkView:networkErrorViewErase(request)
	if NetworkView._networkErrorView ~= nil then
		fwin:close(NetworkView._networkErrorView)
	end
end

function NetworkView:networkErrorViewDisplay(request)
	if NetworkView._networkErrorView ~= nil then
		fwin:close(NetworkView._networkErrorView)
		if NetworkView._networkErrorView.reset ~= nil then
			NetworkView._networkErrorView:reset(request)
		end
		fwin:open(NetworkView._networkErrorView, fwin._system)
	else
		debug.log(true, "=============show network error dialog=============")
	end
end

function NetworkView:protocolErrorViewErase(request)
	if NetworkView._protocolErrorView ~= nil then
		fwin:close(NetworkView._protocolErrorView)
	end
end

function NetworkView:protocolErrorViewDisplay(request)
	if NetworkView._protocolErrorView ~= nil then
		fwin:close(NetworkView._protocolErrorView)
		if NetworkView._protocolErrorView.reset ~= nil then
			NetworkView._protocolErrorView:reset(request)
		end
		fwin:open(NetworkView._protocolErrorView, fwin._system)
	else
		debug.log(true, "=============show protocol error dialog=============")
	end
end