msg_order={}
     function record(msg)
     local rest = string.match(msg.fromMsg,"^转语音:(.+)$")
     if(rest == nil)then
     return ""
     else
     if(msg.gid ~= nil)then
     local api = "https://api.vvhan.com/api/song?txt="..rest.."&per=3"
     return "[CQ:record,url="..api.."]"
     else
     return"{nick}，目前本功能不支持私聊哦~"
     end
     end
     end
     msg_order["转语音:"]="record"
