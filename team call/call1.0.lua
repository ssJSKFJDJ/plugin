--仿SitaNya的.team call指令插件.  ver1.0  made by 地窖上的松
--灵感来自于塔骰的team功能
--发布更新于dice!论坛与简律纯的黑船（划  项目：https://github.com/ssJSKFJDJ/plugin

--[[目前已知的漏洞：
1.清空群team后会遗留下来空表占用内存
2.show部分中文字符会出现乱码
3.指令所有人均可用，没有是否是kp的限制]] --


sleep_time = 1021 --这是艾特与show时的间歇时间（毫秒数），设为0可能会有风险，太长了可能影响使用

--核心函数部分--

list_name = "list.json"
global_path = getDiceDir() .. "/plugin/call/"
json = require "json"

function read_json(path) --读json
    local json_t = nil
    local file = io.open(path, "r") --打开外置json
    if (file ~= nil) then
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
if (call_list == nil) then
    call_list = {}
end

function table.search(array, value) --从数组array中检索value并返回下标,没有的话就返回false
    --（说起来我一直没有搞懂数组和表到底有什么区别#移目）--
    for i = 1, #array do
        if array[i] == value then
            return i
        end
    end
    return false
end

function index_search(array) --检索是否有这个table
    if (array ~= nil) then --如果table存在且不为空则返回ture
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
    if (#Gid < 5) then --如果消息是从私聊窗口发出的，Gid的值会是"G0"，所以随便写一个条件判断就能筛去私聊窗口发出的指令
        return "请在群聊中使用此插件"
    else
        if (#adder == nil or #adder <= 4) then
            return "请使用.team add+@调查员 来将调查员加入本群team" --如果add后面跟了奇奇怪怪的东西就返回这个
        elseif (#adder >= 13) then
            return "请保证每次只添加一名调查员" --如果add后面同时艾特了一个以上就返回这个
        else
            local j = call_list[Gid]
            local if_have_team = index_search(call_list[Gid]) --判断本群是否已有team列表
            if (if_have_team == false) then --如果本群没有team列表（json中没有对应G【q群号】的数组）则新建此数组
                call_list[Gid] = { 0 } --第一个元素设置为0，这样就算清除全队之后表中也不会是空的，能被index_search检索到
                save_json(global_path .. list_name, call_list) --保存
            end
            local if_in_team = table.search(call_list[Gid], adder)
            if (if_in_team ~= false) then --判断此人是否在team中
                return "此人已在本群team中" --在team中就不执行这些
            else
                table.insert(call_list[Gid], adder) --将此人QQ号加入表中
                save_json(global_path .. list_name, call_list) --储存
                return "成功将此人加入本群team"
            end
        end
    end
end

function team_del(msg) --删除个人
    local deler = string.match(msg.fromMsg, "%d+")
    local Gid = "G" .. msg.fromGroup
    if (#Gid < 5) then
        return "请在群聊中使用此插件"
    else
        if (#deler == nil or #deler <= 4) then
            return "请使用.team del+@调查员 来将调查员移出本群team"
        elseif (#deler >= 13) then
            return "请保证每次只移出一名调查员"
        else
            local if_have_team = index_search(call_list[Gid])
            if (if_have_team == false) then --以防万一写出来的条件判断，要是用不到是最好的
                return "本群team为空，若出现bug请使用。send联系骰主"
            else
                local if_in_team = table.search(call_list[Gid], deler)
                if (if_in_team == false) then --判断此人是否不在team里面
                    return "此人不在本群team中x"
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
    if (#Gid < 5) then
        return "请在群聊中使用此插件"
    else
        call_list[Gid] = { 0 } --直接简单粗暴重新定义
        save_json(global_path .. list_name, call_list) --将空表储存
        return "已清除本群team"
    end
end

function call(msg) --呼叫队员
    local Gid = "G" .. msg.fromGroup
    if (#Gid < 5) then
        return "请在群聊中使用此插件"
    else
        local k = index_search(call_list[Gid]) --首先检索此群是否有相应的team表，以免报错
        if (k == false) then
            return "本群team为空"
        elseif (#call_list[Gid] == 1) then --如果此群team表中只有一个0，即没有任何成员
            return "本群team为空"
        else
            local j = call_list[Gid] --将call_list表中对应本群的team列表取出，不然没法子作为参数写进函数里
            for i = 2, #j do --用循环实现呼叫全体队员，i的初始值为2时因为team列表中第一个元素为0
                eventMsg("at_oneself", msg.fromGroup, j[i]) --艾特
                sleepTime(sleep_time) --休息一下下免得艾特太快被tx鲨掉
            end
        end
    end
end

function team_show(msg) --展示本群team成员
    local Gid = "G" .. msg.fromGroup
    if (#Gid < 5) then
        return "请在群聊中使用此插件"
    else
        local k = index_search(call_list[Gid])
        if (k == false) then
            return "本群team为空"
        elseif (#call_list[Gid] > 1) then
            local j = call_list[Gid]
            sendMsg("本群team成员有：", msg.fromGroup, 0)
            for i = 2, #j do --同call，用循环实现show
                sleepTime(sleep_time)
                local k = getPlayerCardAttr(j[i], msg.fromGroup, "__Name", j) --获取群员名字，为空则展示qq号
                sendMsg(k, msg.fromGroup, 0)
            end
        else
            return "本群team为空"
        end
    end
end

function call_help()
    return "仿塔骰的team call插件，方便kp开团或公布信息时艾特调查员们。\nver  1.0   made by 地窖上的松\n.add+@调查员//添加调查员（请保证每次只添加一名调查员，若@多名则只会添加第一名）\n.del+@调查员//移出调查员\n.team clear//清空本群team\n.team call//呼唤team中的调查员\n.team show//展示本群team列表"
end

msg_order = {}
msg_order[".add"] = "team_add"
msg_order[".del"] = "team_del"
msg_order[".team clear"] = "team_clear"
msg_order[".team call"] = "call"
msg_order["at_oneself"] = "at_oneself"
msg_order[".team show"] = "team_show"
msg_order[".call help"] = "call_help"
