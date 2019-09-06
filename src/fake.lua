-- version number 0.1.0
-- fake.lua
--[[
    Fake Server with Index
--]]
-- Virink <virink@outlook.com>
-- 2019-05-09

local C = require "common"

ngx.header.content_type = "text/html";
ngx.status = ngx.OK
local uri = ngx.var.request_uri
local scriptExt = ngx.re.gsub(uri, "(.*?)\\.(.*?)\\?(.*)","$2")
if string.find(scriptExt, "php") then
    ngx.header.Server = 'Nginx/1.8.0'
elseif string.find(scriptExt, "jsp") then
    ngx.header.Server = 'Apache Tomcat/7.0.6'
elseif string.find(scriptExt, "asp") then
    ngx.header.Server = 'Microsoft-IIS/7.5'
else
    ngx.header.Server = 'Gunicorn/19.9.0'
end
C.output(C.read_html("index"))