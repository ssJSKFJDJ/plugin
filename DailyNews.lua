-------------------------------
-- @每日新闻 by 简律纯(a2c29k9)
-- @license MIT.
-------------------------------

--[[
用了api接口，代替了插件60s的效果
如何使用：.admin clock + news 7:00
接着在想要通知的窗口输入：订阅新闻
退订可以输入：退订新闻

由于通知窗口使用的是第8级，所以如果有其他的关于通知窗口的使用或更改第8级窗口的脚本存在，可能会引起冲突。

最后，
祝使用愉快。

7/27 改.
]]




task_call = {
    news = "news",
}

notice_head = ".send notice 8 "

function table_draw(tab)
    if (#tab == 0) then return "" end
    return tab[ranint(1, #tab)]
end

function printChat(msg)
    if (msg.fromGroup == "0") then
        return "QQ " .. msg.fromQQ
    else
        return "group " .. msg.fromGroup
    end
end

res, info = http.get("http://excerpt.rubaoo.com/toolman/getMiniNews")
js = require "json"
j = js.decode(info)

new = {
    "一起来每日旧闻吧",
    "[CQ:image,file=" .. j.data.image .. "]"
}

function news()
    --eventMsg(notice_head..table_draw(new), 0, getDiceQQ())
    eventMsg(notice_head .. new[2], 0, getDiceQQ())
end

msg_order = {}

function book_alarm_call(msg)
    eventMsg(".admin notice " .. printChat(msg) .. " +8", 0, getDiceQQ())
    return "已订阅{self}的每日新闻"
end

function unbook_alarm_call(msg)
    eventMsg(".admin notice " .. printChat(msg) .. " -8", 0, getDiceQQ())
    return "已退订{self}的每日新闻"
end

function dailynews(msg)
    return "[CQ:image,file=" .. j.data.image .. "]"
end

msg_order["订阅news"] = "book_alarm_call"
msg_order["退订news"] = "unbook_alarm_call"
msg_order["60s"] = "dailynews"
