-- version number 0.1.0
-- files.lua
--[[
    Files filter for uploads/*
--]]
-- Virink <virink@outlook.com>
-- 2019-05-09

local C = require "common"

local request_method = ngx.var.request_method
local html = ngx.arg[1]

-- 修改 title
html = ngx.re.gsub(html, "<h1>(.+)</h1>", "<h1>Ginkgo Download</h1>")

-- 添加 Preview
local html, n, err = ngx.re.gsub(html, "<a href=\"([a-z0-9.]+)\">(.*?)</a>", "<a href=\"/preview?f=$1\">Preview</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"$1\">$1</a>", "i")


ngx.arg[1] = html