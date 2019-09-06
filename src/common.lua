-- version number 0.1.0
-- common.lua
--[[
    Common function for this
--]]
-- Virink <virink@outlook.com>
-- 2019-05-09

local upload = require "resty.upload"
local cjson = require "cjson"
local resty_random = require "resty.random"

local config = ngx.shared.config;
local root = config:get('document_root')

local _M = {}

function _M.json_obj(code, msg)
    ngx.header.content_type = "application/json; charset=utf-8";
    local obj = {}
    obj["code"] = code
    obj["msg"] = msg
    return cjson.encode(obj)
end

function _M.output(data)
    ngx.say(data)
    ngx.exit(0)
end

function _M.read_file(filename)
    local file, err = io.open(filename, "r") 
    if err ~= nil then
        ngx.log(ngx.ERR, "read_file: ", err)
        return nil
    end
    io.input(file)
    if not file then
        return nil
	end
	local data = io.read("*a")
	io.close(file)
	return data
end

function _M.read_html(name)
    local data = _M.read_file(root .. "/templates/" .. name .. ".html")
    if not data then
        return _M.json_obj(1, "Error : open [" .. root .. "/templates/" .. name .. ".html] error")
	end
	return data
end

function _M.md5(s)
    local resty_md5 = require "resty.md5"
    local str = require "resty.string"
    local md5 = resty_md5:new()
    if not md5 then
        ngx.say("failed to create md5 object")
        return
    end
    local ok = md5:update(s)
    if not ok then
        ngx.say("failed to add data")
        return
    end
    local digest = md5:final()
    return str.to_hex(digest)
end

function _M.split(str, reps)
	local r = {};
    if (str == nil) then 
        return nil; 
    end
	string.gsub(str, "[^"..reps.."]+", function(w) table.insert(r, w) end);
	return r;
end

function _M.get_filename_ext(fileName)
    fileName = _M.split(fileName, ".")
    return "." .. fileName[table.getn(fileName)]
end

-- 文件上传
function _M.upload_file()
    local args = ngx.req.get_uri_args()
    local realFileName = ""
    local chunk_size = 1024
    local form, err = upload:new(chunk_size)
    if not form then
        ngx.log(ngx.ERR, "failed to new upload: ", err)
        ngx.say(_M.json_obj(1,"failed to new upload ." .. err))
        return
    end
    form:set_timeout(1000)
    local saveRootPath = root .. "/uploads/"
    local fileToSave
    local ret_save = false

    while true do
        local typ, res, err = form:read()
        if not typ then
            ngx.say(_M.json_obj(1,"failed to read " .. err))
            return nil
        end
        if typ == "header" then
            if res[1] ~= "Content-Type" then
                local filename = ngx.re.match(res[2],'(.+)filename="(.+)"(.*)')
                if filename then
                    realFileName = _M.md5(resty_random.bytes(10,0)) .. _M.get_filename_ext(filename[2])
                    fileToSave = io.open(saveRootPath .. realFileName, "w+")
                    if not fileToSave then
                        ngx.say(_M.json_obj(1,"failed to open file " .. filename))
                        return nil
                    end
                end
            end
        elseif typ == "body" then
            if fileToSave then
                fileToSave:write(res)
            end
        elseif typ == "part_end" then
            if fileToSave then
                fileToSave:close()
                fileToSave = nil
            end
            
            ret_save = true
        elseif typ == "eof" then
            break
        else
        end
    end
    return realFileName
end

return _M