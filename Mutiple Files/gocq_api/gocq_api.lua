--用法：gapi.http_post("终结点",参数1, 参数2, ......)【终结点是string，可别漏了""】
--或者：gapi.http_get("终结点",参数1, 参数2, ......)
--参数严格按照gocq帮助文档中给出的顺序（由上到下，记得注意参数的数据类型
--反正就是个函数，自己调用罢
--------------------------------------------------------------------------------------
--参数设置
local http_port = 15700 --api调用的端口号，可以自己改
--------------------------------------------------------------------------------------
local gapi = {}
local json = require("json")

function read_json(path) --读json
    local json_t = nil
    local file = io.open(path, "r")
    if file ~= nil then
        json_t = json.decode(file.read(file, "*a"))
        io.close(file)
    end
    return json_t
end

local api_list = read_json(getDiceDir() .. "/plugin/gocq_api/api_list.json")

function gapi.http_post(ept, para1, para2, para3, para4, para5)
    local para = {}
    if para1 ~= nil then
        para[api_list[ept]["para1"]] = para1
    end
    if para2 ~= nil then
        para[api_list[ept]["para2"]] = para2
    end
    if para3 ~= nil then
        para[api_list[ept]["para3"]] = para3
    end
    if para4 ~= nil then
        para[api_list[ept]["para4"]] = para4
    end
    if para5 ~= nil then
        para[api_list[ept]["para5"]] = para5
    end
    respond = http.post("http://127.0.0.1:" .. http_port .. "/" .. ept, json.encode(para))
    --访问api
    return respond
end

function gapi.http_get(ept, para1, para2, para3, para4, para5)
    local params = {}
    if para1 ~= nil then
        params[1] = api_list[ept]["para1"] .. "=" .. para1
    end
    if para2 ~= nil then
        params[2] = api_list[ept]["para2"] .. "=" .. para2
    end
    if para3 ~= nil then
        params[3] = api_list[ept]["para3"] .. "=" .. para3
    end
    if para4 ~= nil then
        params[4] = api_list[ept]["para4"] .. "=" .. para4
    end
    if para5 ~= nil then
        params[5] = api_list[ept]["para5"] .. "=" .. para5
    end
    para = table.concat(params, "&")
    respond = http.get("http://127.0.0.1:" .. http_port .. "/" .. ept .. "?" .. para)
    return respond
end

return gapi
