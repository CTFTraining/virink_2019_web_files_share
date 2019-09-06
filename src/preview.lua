-- version number 0.1.0
-- preview.lua
--[[
    Preview Controller
--]] -- Virink <virink@outlook.com>
-- 2019-05-09
local C = require "common"

local config = ngx.shared.config
local root = config:get('document_root')

local banStr = "../"

-- 获取参数的值
args = ngx.req.get_uri_args()

local filePath = args['f']
if filePath == nil then C.output(C.json_obj(1, "Param 'f' not found!")) end

filePath = string.gsub(filePath, "../", "")
filePath = string.gsub(filePath, "preview", "[Banned By Virink]")

local fileExt = C.get_filename_ext(filePath)
if fileExt == "png" or fileExt == "jpg" or fileExt == "gif" then
    ngx.header.content_type = "image/" .. fileExt
else
    ngx.header.content_type = "text/plain"
end

local f = C.read_file(root .. "/uploads/" .. filePath)
if f ~= nil then
    C.output(f)
else
    C.output(C.json_obj(1, "File " .. filePath .. " not found!"))
end
