-- version number 0.1.0
-- upload.lua
--[[
    Upload Controller
--]]
-- Virink <virink@outlook.com>
-- 2019-05-09


local C = require "common"

local request_method = ngx.var.request_method

if request_method == "POST" then
    local realFileName = C.upload_file()
    if realFileName then
        C.output(C.json_obj(0,"save file ok : " .. realFileName))
    else
        ngx.redirect("/upload.gk", 302)
    end
else
    ngx.header.content_type = "text/html";
    C.output(C.read_html("upload"))
end
