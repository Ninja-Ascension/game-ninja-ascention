-- nGenTime: 产生时间戳（也可以是一个未来的时间，比如CD时间戳）
-- nDuration: 固定的有效期间，单位秒，计算某个未来时间的剩余时间时不需要指定
-- 返回3个结果，第一个是剩余到期时间的字符串，"HH:MM:SS", 不足2位自动补零；第二个是bool，标识nGenTime是否到期；第三个是剩余秒数
function expireTimeString( nGenTime, nDuration )
    local nNow = tonumber(_ED.system_time) --BTUtil:getSvrTimeInterval()
    local nViewSec = (nDuration or 0) - (nNow - nGenTime)
    return getTimeString(nViewSec), nViewSec <= 0, nViewSec
end


--得到一个时间戳timeInt与当前时间的相隔天数
--offset是偏移量,例如凌晨4点:4*60*60
--return type is integer, 0--当天, n--不在同一天,相差n天
function getDifferDay(timeInt, offset)
	timeInt = tonumber(timeInt or 0)
	offset = tonumber(offset or 0)
    local curTime = tonumber(_ED.system_time) --tonumber(BTUtil:getSvrTimeInterval()) - offset
    if(os.date("%j",curTime) == 1 and os.date("%j",timeInt - offset) ~= 1)then
    	return os.date("%j",curTime) - (os.date("%j",timeInt - offset) - os.date("%j",curTime-24*60*60))
    else--if(os.date("%j",curTime) ~= os.date("%j",timeInt - offset))then
    	return os.date("%j",curTime) - os.date("%j",timeInt - offset)
    end
end

-- 指定一个日期时间字符串，返回与之对应的东八区（服务器时区）时间戳, zhangqi, 20130702
-- sTime: 格式 "2013-07-02 20:00:00"
function getIntervalByTimeString( sTime )
	local t = string.split(sTime, " ")
	local tDate = string.split(t[1], "-")
	local tTime = string.split(t[2], ":")

	local tt = os.time({year = tDate[1], month = tDate[2], day = tDate[3], hour = tTime[1], min = tTime[2], sec = tTime[3]})
	local ut = os.date("!*t", tt)
	local east8 = os.time(ut) + 8*60*60 -- UTC时间+8小时转为东八区北京时间
	return east8
end

--给一个时间如:153000,得到今天15:30:00的时间戳 
function getIntervalByTime( time )
	local curTime = tonumber(_ED.system_time) --BTUtil:getSvrTimeInterval()
	local temp = os.date("*t",curTime)
	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s

    return timeString
end



--把一个hh:mm:ss这样的时间段转换成时间戳
function getIntervalByTimeSegment( timeString )
	local timeInfo = string.split(timeString,":")
	return tonumber(timeInfo[1])*3600 + tonumber(timeInfo[2])*60 + tonumber(timeInfo[3])
end

-- 把一个时间戳转换为 ”n天n小时n分钟n秒“ 如果某一项为0则不显示这一项
-- timeInt:时间戳
function getTimeDesByInterval( timeInt )

	local result = ""
	local oh	 = math.floor(timeInt/3600)
	local om 	 = math.floor((timeInt - oh*3600)/60)
	local os 	 = math.floor(timeInt - oh*3600 - om*60)
	local hour = oh
	local day  = 0
	if(oh>=24) then
		day  = math.floor(hour/24)
		hour = oh - day*24
	end
	if(day ~= 0) then
		result = result .. day .. "天"
	end
	if(hour ~= 0) then
		result = result .. hour .."小时"
	end
	if(om ~= 0) then
		result = result .. om .. "分钟"
	end
	if(os ~= 0) then
		result = result .. os .. "秒"
	end
	return result
end

-- 把一个时间戳转换为 ”n天n小时n分钟n秒“ 如果某一项为0则不显示这一项
-- timeInt:时间戳
function getTimeDesByIntervalEx( timeInt )

	local result = ""
	local oh	 = math.floor(timeInt/3600)
	local om 	 = math.floor((timeInt - oh*3600)/60)
	local os 	 = math.floor(timeInt - oh*3600 - om*60)
	local hour = oh
	local day  = 0
	if(oh>=24) then
		day  = math.floor(hour/24)
		hour = oh - day*24
	end
	if(day ~= 0) then
		result = result .. day .. ":"
	end
	if(hour ~= 0) then
		if hour < 10 then
			result = result .."0".. hour ..":"
		else
			result = result .. hour ..":"
		end
	else
		result = result .. "00:"
	end
	if(om ~= 0) then
		if om < 10 then
			result = result .."0".. om .. ":"
		else
			result = result .. om .. ":"
		end
	else
		result = result .. "00:"
	end
	if(os ~= 0) then
		if os < 10 then
			result = result .."0".. os
		else
			result = result .. os
		end
	else
		result = result .. "00"
	end
	return result
end

-- 设备时间的东八区时间  zhangqi
function getDevCurTimeInterval()
	return (os.time(os.date("!*t", os.time()))+28800)
end

--给一个时间如:153000,得到今天15:30:00的时间戳 相对于设备的东八区时间
function getDevIntervalByTime( time )
	local curTime = getDevCurTimeInterval()
	local temp = os.date("*t",curTime)

	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s
    local timeInt = TimeUtil.getIntervalByTimeString(timeString)

    return timeInt
end

--给一个时间如:153000,得到今天15:30:00的时间戳 相对于服务器的东八区时间 -- add by chengliang
function getSvrIntervalByTime( time )
	local curTime = getSvrTimeByOffset()
	local temp = os.date("*t",curTime)

	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s
    local timeInt = TimeUtil.getIntervalByTimeString(timeString)

    return timeInt
end

-- 得到服务器时间
-- 参数second_num:偏移的秒数  负数：比服务器慢，正数：比服务器快，默认-1
function getSvrTimeByOffset( second_num )
	-- 当前服务器时间
    local curServerTime = tonumber(_ED.system_time) --BTUtil:getSvrTimeInterval()
    local offset = tonumber(second_num) or -1
    return curServerTime+offset
end

-- 给一个时间戳，得到类似：2012-12-12,得string，精确到天
function getTimeForDay( timeInt)
	local timeInt= tonumber(timeInt)
	local temp = os.date("*t",timeInt)

	time = string.format("%06d", timeInt)
	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)")
	
	local timeString=  temp.year .."-".. temp.month .."-".. temp.day.._string_piece_info[159].. string.format("%02d", temp.hour) .. "点"
	return timeString
end


-- para：时间戳  return：时间格式：2014-06-01 01:01:01  add by chengliang
function getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year .."-".. m_month .."-".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

-- para：时间戳  return：时间格式：2014-06-01 01:01  add by licong  精确到分钟
function getTimeToMin( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)

	local timeString = temp.year .."-".. m_month .."-".. m_day .."  ".. m_hour ..":".. m_min 

    return timeString
end

-- para：时间戳  return：时间格式： 01:01  add by 李攀 只要 小时和分钟

function getTimeOnlyMin( m_time )
	local temp = os.date("*t",m_time)

	-- local m_month 	= string.format("%02d", temp.month)
	-- local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)

	local timeString = m_hour ..":".. m_min 

    return timeString
end

-- para:时间段  X分钟、X小时、X天
function getTimeDisplayText( time_interval)
	time_interval = tonumber(time_interval)
	local d_text = ""
	if(time_interval<60*60)then
		-- 分钟
		d_text = math.ceil(time_interval/60) .. "分钟"
	elseif(time_interval<60*60*24)then
		-- 小时
		d_text = math.ceil(time_interval/(60*60)) .. "小时"
	else
		-- 天
		d_text = math.ceil(time_interval/(60*60*24) ) .. "天"
	end

	return d_text
end


-- 返回格式化时间,参数是秒
function formatTime (second)
	local timeTabel = {}
	local day = 0
	local hour = math.floor(tonumber(second)/3600)
	local minute = math.floor((tonumber(second)%3600)/60)
	local second = math.ceil(tonumber(second)%60)
	if second == 60 then
		second = 0
		minute = minute + 1
	end
	if minute == 60 then
		minute = 0
		hour = hour + 1
	end
	if hour >= 24 then
		day = math.floor(hour / 24)
		hour = hour % 24
	end
	timeTabel.day = day
	timeTabel.hour = hour
	timeTabel.minute = minute
	timeTabel.second = second
	return timeTabel
end

-- 转换星期7为星期日
function getWeekX(_int_num)
	_int_num = tonumber(_int_num)
	local d_text = ""
	if _int_num == 1 then
		d_text = timeUtil_WeekX[1]
	elseif _int_num == 2 then
		d_text = timeUtil_WeekX[2]
	elseif _int_num == 3 then
		d_text = timeUtil_WeekX[3]
	elseif _int_num == 4 then
		d_text = timeUtil_WeekX[4]
	elseif _int_num == 5 then
		d_text = timeUtil_WeekX[5]
	elseif _int_num == 6 then
		d_text = timeUtil_WeekX[6]
	elseif _int_num == 7 then
		d_text = timeUtil_WeekX[7]
	end
	return d_text
end

function get_date_time_string(time_mil_seconds)
	local obj = os.date("*t", tonumber(time_mil_seconds)/1000)
	return string.format("%04d-%02d-%02d %02d:%02d:%02d", obj.year, obj.month, obj.day, obj.hour, obj.min, obj.sec)
end