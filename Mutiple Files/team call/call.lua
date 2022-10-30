--[[目前已知的漏洞：
1.show部分中文字符会出现乱码，目前没有解决方案
2.指令所有人均可用，没有是否是kp的限制，往后也许会添加设定kp的.kp指令]] --

sleep_time = 1021 --这是艾特与show时的间歇时间（毫秒数），设为0可能会有风险，太长了可能影响使用

--核心函数部分--

list_name = "list.json"
global_path = getDiceDir() .. "/plugin/call/"
json = require "json"

function read_json(path) --读json
    local json_t = nil
    local file = io.open(path, "r") --打开外置json
    if file ~= nil then
        json_t = json.decode(file.read(file, "*a")) --将json中的数组解码为table
        io.close(file) --关闭json
    end
    return json_t
end

function save_json(path, table) --保存json
    local json_t = json.encode(table) --将table编码为json数组
    file = io.open(path, "w")
    file.write(file, json_t) --将json中原本的数组替换为新的，即保存
    io.close(file)
    return true
end

call_list = read_json(global_path .. list_name) --将解码来的table保存在table中
if call_list == nil then
    call_list = {}
end

function table.search(array, value) --从数组array中检索value并返回下标,没有的话就返回nil（要求有array这个数组存在，不然会报错）
    --（说起来我一直没有搞懂数组和表到底有什么区别#移目）--
    for i = 1, #array do
        if array[i] == value then
            return i
        end
    end
    return nil
end

function index_search(array) --检索是否有这个table
    if array ~= nil then --如果table存在且不为空则返回ture
        return true
    else
        return false
    end
end

function at_oneself() --艾特的核心函数（
    return "{at}"
end

--指令部分--

function team_add(msg) --添加个人
    local adder = string.match(msg.fromMsg, "%d+") --从接收的命令中提取QQ号
    local Gid = "G" .. msg.fromGroup --将群号保存为变量，方便写入索引
    if #Gid < 5 then --如果消息是从私聊窗口发出的，Gid的值会是"G0"，所以随便写一个条件判断就能筛去私聊窗口发出的指令
        return "请在群聊中使用此指令"
    else
        if adder == nil or #adder <= 4 then
            return "请使用.team add+@调查员 来将调查员加入本群team" --如果add后面跟了奇奇怪怪的东西或者为空就返回这个
        elseif #adder >= 13 then
            return "请保证每次只添加一名调查员" --如果add后面同时艾特了一个以上就返回这个
        else
            local if_have_team = index_search(call_list[Gid]) --判断本群是否已有team列表
            if if_have_team == false then --如果本群没有team列表（json中没有对应G【q群号】的数组）则新建一个
                call_list[Gid] = { adder } --新建本群team表
                save_json(global_path .. list_name, call_list) --储存
                return "成功将此人加入本群team"
            else --如果本群已有team表
                local if_in_team = table.search(call_list[Gid], adder)
                if if_in_team ~= nil then --判断此人是否在team中
                    return "此人已在本群team中" --在team中就不执行这些
                else
                    table.insert(call_list[Gid], adder) --将此人QQ号加入表中
                    save_json(global_path .. list_name, call_list) --储存
                    return "成功将此人加入本群team"
                end
            end
        end
    end
end

function team_del(msg) --删除个人
    local deler = string.match(msg.fromMsg, "%d+")
    local Gid = "G" .. msg.fromGroup
    local if_have_team = index_search(call_list[Gid])
    if #Gid < 5 then --同上，检测是否为私聊窗口的指令
        return "请在群聊中使用此指令"
    else
        if #deler == nil or #deler <= 4 then
            return "请使用.team del+@调查员 来将调查员移出本群team"
        elseif #deler >= 13 then
            return "请保证每次只移出一名调查员"
        elseif if_have_team == false then --如果本群无team表则不执行下面的操作，不然会报错
            return "本群team为空"
        else
            local if_in_team = table.search(call_list[Gid], deler)
            if if_in_team == nil then --判断此人是否不在team里面
                return "此人不在本群team中"
            else
                local k = #call_list[Gid]
                if k == 1 then --判断此人是否为team中最后一个
                    call_list[Gid] = nil --删除本群team表，以防留下空表占用内存
                    save_json(global_path .. list_name, call_list) --储存
                    return "成功将此人移出本群team"
                else
                    table.remove(call_list[Gid], if_in_team) --将此人QQ号移出表
                    save_json(global_path .. list_name, call_list) --储存
                    return "成功将此人移出本群team"
                end
            end
        end
    end
end

function team_clear(msg) --删除全队
    local Gid = "G" .. msg.fromGroup
    if #Gid < 5 then
        return "请在群聊中使用此指令"
    else
        local if_have_team = index_search(call_list[Gid]) --判断本群有无team列表
        if if_have_team == false then --如果没有的话
            return "本群team为空"
        else
            call_list[Gid] = nil --直接删除本群team表，以防留下空表占用内存
            save_json(global_path .. list_name, call_list) --储存
            return "已清除本群team"
        end
    end
end

function call(msg) --呼叫队员
    local Gid = "G" .. msg.fromGroup
    if #Gid < 5 then
        return "请在群聊中使用此指令"
    else
        local if_have_team = index_search(call_list[Gid]) --判断本群有无team列表
        if if_have_team == false then --如果没有的话
            return "本群team为空"
        else
            sendMsg("守秘人正在呼唤以下调查员：", msg.fromGroup, 0)
            local j = call_list[Gid] --将call_list表中对应本群的team列表取出，不然没法子作为参数写进函数里
            for i = 1, #j do --用循环实现呼叫全体队员
                eventMsg("at_oneself", msg.fromGroup, j[i]) --艾特
                sleepTime(sleep_time) --休息一下下免得艾特太快被tx鲨掉
            end
        end
    end
end

function team_show(msg) --展示本群team成员
    local Gid = "G" .. msg.fromGroup
    if #Gid < 5 then
        return "请在群聊中使用此指令"
    else
        local if_have_team = index_search(call_list[Gid]) --判断本群有无team列表
        if if_have_team == false then --如果没有的话
            return "本群team为空"
        else
            local j = call_list[Gid]
            sendMsg("本群team成员有：", msg.fromGroup, 0)
            for i = 1, #j do --同call，用循环实现show
                sleepTime(sleep_time)
                local k = getPlayerCardAttr(j[i], msg.fromGroup, "__Name", "角色卡") --获取群员名字
                if k == "角色卡" then
                    k = getUserConf(j[i], "nick#" .. msg.fromGroup, j[i]) --如果没有用nn指令设置名字的话就使用群名，群名都没有（应该不会吧）的话就使用QQ号
                end
                sendMsg(k, msg.fromGroup, 0)
            end
        end
    end
end

function call_help()
    return "仿塔骰的team call插件，方便kp开团或公布信息时艾特调查员们。\nver  1.1  made by 地窖上的松\n.add+@调查员//添加调查员\n.del+@调查员//移出调查员\n.team clear//清空本群team\n.team call//呼唤team中的调查员\n.team show//展示本群team列表"
end

msg_order = {}
msg_order[".add"] = "team_add"
msg_order[".del"] = "team_del"
msg_order[".team clear"] = "team_clear"
msg_order[".team call"] = "call"
msg_order["at_oneself"] = "at_oneself"
msg_order[".team show"] = "team_show"
msg_order[".call help"] = "call_help"
