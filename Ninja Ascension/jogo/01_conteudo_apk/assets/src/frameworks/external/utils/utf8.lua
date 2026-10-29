local utf8 = utf8 or {}

local pattern = "[%z\1-\194-\244][\128-\191]*"

utf8.chars = function ( unicode_string )
	local map = {}

   if string.gfind ~= nil then
      for uchar in string.gfind(unicode_string, "([%z\1-\127\194-\244][\128-\191]*)") do
         table.insert(map, uchar)
      end
   else
      for uchar in string.gmatch(unicode_string, "([%z\1-\127\194-\244][\128-\191]*)") do
         table.insert(map, uchar)
      end
   end
	
   return map
end

utf8.findChinese = function ( map )
   local isHaveChinese = false
   for k,v in pairs(map) do
      if string.len(v) > 1 then
         isHaveChinese = true
         break
      end
   end
   return isHaveChinese
end

utf8.count = function ( unicode_string )
	local _, count = string.gsub(unicode_string, "[^\128-\193]", "")
	return count
end

utf8.reverse = function(unicode_string)
	unicode_string = unicode_string:gsub(pattern, function(src)
		return (#src > 1 and src:reverse())
	end)
  return unicode_string:reverse()
end

function utf8.charbytes (s, i)
   -- argument defaults
   i = i or 1
   local c = string.byte(s, i)
   
   -- determine bytes needed for character, based on RFC 3629
   if c > 0 and c <= 127 then
      -- UTF8-1
      return 1
   elseif c >= 194 and c <= 223 then
      -- UTF8-2
      local c2 = string.byte(s, i + 1)
      return 2
   elseif c >= 224 and c <= 239 then
      -- UTF8-3
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      return 3
   elseif c >= 240 and c <= 244 then
      -- UTF8-4
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      local c4 = s:byte(i + 3)
      return 4
   end
end

-- returns the number of characters in a UTF-8 string
function utf8.len (s)
   local pos = 1
   local bytes = string.len(s)
   local len = 0
   
   while pos <= bytes and len ~= chars do
      local c = string.byte(s,pos)
      len = len + 1
      
      pos = pos + utf8.charbytes(s, pos)
   end
   
   if chars ~= nil then
      return pos - 1
   end
   
   return len
end

-- functions identically to string.sub except that i and j are UTF-8 characters
-- instead of bytes
function utf8.sub (s, i, j)
   j = j or -1

   if i == nil then
      return ""
   end
   
   local pos = 1
   local bytes = string.len(s)
   local len = 0

   -- only set l if i or j is negative
   local l = (i >= 0 and j >= 0) or utf8.len(s)
   local startChar = (i >= 0) and i or l + i + 1
   local endChar = (j >= 0) and j or l + j + 1

   -- can't have start before end!
   if startChar > endChar then
      return ""
   end
   
   -- byte offsets to pass to string.sub
   local startByte, endByte = 1, bytes
   
   while pos <= bytes do
      len = len + 1
      
      if len == startChar then
	 startByte = pos
      end
      
      pos = pos + utf8.charbytes(s, pos)
      
      if len == endChar then
	 endByte = pos - 1
	 break
      end
   end
   
   return string.sub(s, startByte, endByte)
end

-- replace UTF-8 characters based on a mapping table
function utf8.replace (s, t, p)
	local chars = utf8.chars(s)
	local keys = utf8.chars(t)
	local map = {}
	local pos = 1
	local count = #chars
	local kCount = #keys
	local newstr = ""
	while pos <= count do
		if chars[pos] == keys[1] then
			local c = true
			for m, n in pairs(keys) do
				if n ~= chars[pos + m - 1] then
					c = false
					break
				end
			end
			if c then
				newstr = table.concat({newstr, p})
				pos = pos + kCount
			else
				pos = pos + 1
			end
		else
			newstr = table.concat({newstr, chars[pos]})
			pos = pos + 1
		end
	end

	-- for i = 1, #chars do
	-- 	if chars[i] == keys[1] then
	-- 		local c = true
	-- 		for m, n in pairs(keys) do
	-- 			if n ~= chars[i + m] then
	-- 				c = false
	-- 			end
	-- 		end
	-- 		if c then

	-- 		end
	-- 	end
	-- end

	-- local mapping = {}
	-- local pos = 1
	-- local bytes = string.len(s)
	-- local charbytes
	-- local newstr = ""

	-- while pos <= bytes do
	-- 	charbytes = utf8.charbytes(s, pos)
	-- 	local c = string.sub(s, pos, pos + charbytes - 1)
	-- 	newstr = newstr .. (mapping[c] or c)
	-- 	pos = pos + charbytes
	-- end

	return newstr
end

if not string.utf8 then
	string.utf8 = utf8
end