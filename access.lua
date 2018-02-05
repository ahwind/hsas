local auth = require "auth"

local uri = ngx.var.uri

local accessuri = {}
for c in string.gmatch(uri, '([^/]+)') do
    table.insert(accessuri, c)
end
local geturi = accessuri[1]

if geturi == 'index.html' or geturi == nil  then
   return
end
local h = ngx.req.get_headers()

local a = h['Authorization']

local content = {}

for c in string.gmatch(a, "%S+") do
    table.insert(content, c)
end

local pw = ngx.decode_base64(content[2])
local accessuser = {}
for u in string.gmatch(pw, "%w+") do
    table.insert(accessuser, u)
end

local getuser = accessuser[1]

local m = auth.GetAuth(getuser, geturi)

if m then

    return
else
    if err then
        ngx.say(ngx.ERR, "error: ", err)
    else
        return ngx.redirect("/403.html")
    end
end
--ngx.say(accessuser[1])
