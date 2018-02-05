module(..., package.seeall)
local cjson = require "cjson"
local safe_cjson = require "cjson.safe"

function GetGroup(group)
        local fp = '/usr/local/nginx/conf/include/group.json'
        local f = assert(io.open(fp, 'r'))
        local data = f:read("*a")
	local result = safe_cjson.decode(data)
	f:close()
	if result == nil then
                return ngx.say('can not parse group json config')
        end
        local geturl = result[group]
	return geturl
end

function GetAuth(user, visit)
	local fp = '/usr/local/nginx/conf/include/user.json'
	local f = assert(io.open(fp, 'r'))
	local data = f:read("*a")
	local result = safe_cjson.decode(data)
	f:close()
	if result == nil then
		return ngx.say('can not parse user json config')
	end
	local getuser = result[user]
 	if getuser ~= nil then
 		local ownerurl = getuser['auth']
		if ownerurl == '*' then
			return true
		end

   		local m = string.match(ownerurl, visit)
		if m then
                	return true
 		else
			local g = getuser['group']
			if g == nil then
				return false
			end
			local groupownerurl = GetGroup(g)
			if groupownerurl == nil then
				return false
			end
			if groupownerurl == '*' then
				return true
			end
			
			local n = string.match(groupownerurl, visit)
			if n then
				return true
			end
                end
	end
	return false
end
