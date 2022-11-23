--[[目前已知的漏洞：
1.show部分中文字符会出现乱码，目前没有解决方案
2.指令所有人均可用，没有是否是kp的限制，往后也许会添加设定kp的.kp指令（不过这真的有必要吗）]] --

--本来是想写自定义回执部分的，但是太麻烦还是算了。想改回执的骰主可以在插件运行流程那里改，不会的话可以直接来找我
call_help_text = "仿塔骰的team call插件，方便kp开团或公布信息时艾特调查员们。\nver  2.1  made by 地窖上的松\n.team set+@调查员//添加调查员(一次可添加多名调查员)\n.team del+@调查员//移出调查员\n.team clr//清空本群team\n.team call//呼唤team中的调查员\n.team show//展示本群team列表"


-------------------------------------------------------------------------
--核心函数--
-------------------------------------------------------------------------

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

function table.search(array, value) --从数组array中检索value并返回下标,没有的话就返回nil（要求有array这个数组存在且不为空，不然会报错）
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

function string.split(str) --将str中的一个个艾特的cq码中的QQ号取出，然后分别存入table中
    local str_tab = {} --初始化table
    while (true) do --直到遇到break都会一直循环
        local findstart, findend = string.find(str, "%d+") --找到QQ号前的“at:”，返回a所对应的位置与:所对应的位置
        if not (findstart and findend) then
            break

        end
        local sub_str = string.sub(str, findstart, findend) --截取一个QQ号
        if not table.search(str_tab, sub_str) then --如果不重复，则加入表中(待完善)
            table.insert(str_tab, sub_str) --将截取的部分加到表中
        end
        str = string.sub(str, findend + 1, #str) --将截出QQ号后的cq码删掉
    end
    return str_tab --将成果返回
end

-------------------------------------------------------------------------
--插件运行流程--
-------------------------------------------------------------------------

function team(msg) --指令优先级：call > show > clr > set > del > help
    local str = string.match(msg.fromMsg, "(.*)", 6) --将team后的字符全部取出
    local Gid = "G" .. msg.fromGroup
    if #Gid < 5 then --总之先把私聊信息排除掉
        return "仿塔骰的team call插件，方便kp开团或公布信息时艾特调查员们。\nver  2.1  made by 地窖上的松\n.team set+@调查员//添加调查员(一次可添加多名调查员)\n.team del+@调查员//移出调查员\n.team clr//清空本群team\n.team call//呼唤team中的调查员\n.team show//展示本群team列表\n请在群聊中使用此插件"


    elseif string.match(str, "show") then
        if not index_search(call_list[Gid]) then --检索本群是否有team
            return "本群team为空x"
        else
            local j = call_list[Gid] --将本群team从call_list中取出，以进行后续操作
            show_list = {} --初始化show_list表
            for i = 1, #j do --将调查员一个个加入show_list中
                local name = getPlayerCardAttr(j[i], msg.fromGroup, "__Name", "角色卡") --获取群员名字
                if name == "角色卡" then
                    name = getUserConf(j[i], "nick#" .. msg.fromGroup, j[i]) --如果没有用nn指令设置名字的话就使用群名，群名都没有（应该不会吧）的话就使用QQ号
                end
                table.insert(show_list, name)
            end
            local showlist = table.concat(show_list, "\n") --将show_list中的调查员取出，在一个字符串中连接起来
            return "本群team成员有：\n" .. showlist
        end


    elseif string.match(str, "call") then --如果从指令中匹配到call就执行call
        if not index_search(call_list[Gid]) then --检索本群是否有team，即json中是否有以"Gid"为名的数组
            return "本群team为空x"
        else
            local j = call_list[Gid] --将本群team从call_list中取出，以进行后续操作
            local CallList = table.concat(j, "]\n[CQ:at,id=") --将show_list中的调查员取出，在一个字符串中连接起来
            return "守秘人正在呼唤以下调查员：\n[CQ:at,id=" .. CallList .. "]"
        end


    elseif string.match(str, "clr") then
        if not index_search(call_list[Gid]) then --检索本群是否有team
            return "本群team为空x"
        else
            call_list[Gid] = nil --直接删除本群team表，以防留下空表占用内存
            save_json(global_path .. list_name, call_list) --储存
            return "已清除本群team ✓"
        end


    elseif string.match(str, "set") then
        local adder_list = string.split(str) --从接收的命令中提取QQ号
        if not index_search(call_list[Gid]) then --如果本群没有team列表，那就创建一个
            call_list[Gid] = adder_list --新建本群team表并把调查员直接加进去
            save_json(global_path .. list_name, call_list) --储存
            return "成功将" .. #adder_list .. "名调查员加入本群team✓"
        else
            local add_number = #adder_list
            for i = 1, #adder_list do --用循环一个个判断调查员是否在list中
                if table.search(call_list[Gid], adder_list[i]) then --如果在list中就先把此调查员从list中移除，然后再一起加入list。如果把此调查员从adder_list中移出的话总感觉会陷入什么坑中所以稍微绕一下路
                    local k = table.search(call_list[Gid], adder_list[i])
                    table.remove(call_list[Gid], k)
                    --save_json(global_path .. list_name, call_list)
                    add_number = add_number - 1
                end
            end
            for i = 1, #adder_list do --再一个个把调查员加入list中
                table.insert(call_list[Gid], adder_list[i])
            end
            save_json(global_path .. list_name, call_list) --储存
            if add_number ~= 0 then
                return "成功将" .. add_number .. "名调查员加入本群team✓"
            else
                return "这些调查员已经在本群team中x"
            end
        end


    elseif string.match(str, "del") then
        deler_list = string.split(str) --提取QQ号
        local deler_number = #deler_list
        if index_search(call_list[Gid]) == false then --如果本群无team表则不执行下面的操作，不然会报错
            return "本群team为空x"
        else
            for i = 1, #deler_list do --用循环一个个查找deler_list中的调查员在list中的位置并移出
                local k = table.search(call_list[Gid], deler_list[i])
                if k then --如果此调查员在list中就移出，不然就啥都不做
                    if #call_list[Gid] == 1 then --判断此人是否为team中最后一个，如果是最后一个就直接删除本群team表，以防留下空表占用内存
                        call_list[Gid] = nil
                    else --如果不是最后一个就正常移出
                        table.remove(call_list[Gid], k)
                    end
                else
                    deler_number = deler_number - 1
                end
            end
            save_json(global_path .. list_name, call_list) --储存
            if deler_number ~= 0 then
                return "成功将" .. deler_number .. "名调查员移出本群team✓"
            else
                return "这些调查员都不在本群team中x"
            end
        end


    else --如果一个指令都匹配不上，就返回help信息
        return call_help_text
    end
end

msg_order = {}
msg_order[".team"] = "team"
msg_order[".add"] = help_text --先写个指令在这免得更新之后还有骰子用户使用旧版指令（
function help_text()
    return call_help_text
end
