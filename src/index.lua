-- version number 0.1.0
-- index.lua
--[[
    Index Controller
--]]
-- Virink <virink@outlook.com>
-- 2019-05-09

local C = require "common"

ngx.header.content_type = "text/html";
local html = C.read_html("index")
C.output(html)