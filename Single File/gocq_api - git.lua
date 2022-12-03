-------------------------------
-- @gocq_api by 地窖上的松 QQ602380092
-- @license MIT.
-------------------------------

--用法：gapi.http_post("终结点",参数1, 参数2, ......)【终结点是string，可别漏了""】
--或者：gapi.http_get("终结点",参数1, 参数2, ......)
--参数严格按照gocq帮助文档中给出的顺序（由上到下，记得注意参数的数据类型
--反正就是个函数，自己调用罢
--函数部分请跳至322行

--------------------------------------------------------------------------------------
--参数设置
local http_port = 15700 --api调用的端口号，可以自己改
--------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------
--------------------------api终结点与参数储存表，请勿随意改动---------------------------
--------------------------------------------------------------------------------------
api_list = {
    set_group_kick = {
        para2 = "user_id",
        para3 = "reject_add_request",
        para1 = "group_id"
    },
    set_group_ban = {
        para2 = "user_id",
        para3 = "duration",
        para1 = "group_id"
    },
    set_group_name = {
        para2 = "group_name",
        para1 = "group_id"
    },

    send_msg = {
        para4 = "message",
        para1 = "message_type",
        para2 = "user_id",
        para5 = "auto_escape",
        para3 = "group_id"
    },

    send_group_msg = {
        para2 = "message",
        para3 = "auto_escape",
        para1 = "group_id"
    },

    set_group_special_title = {
        para2 = "user_id",
        para3 = "special_title",
        para1 = "group_id"
    },

    set_group_card = {
        para2 = "user_id",
        para3 = "card",
        para1 = "group_id"
    },

    set_group_admin = {
        para2 = "user_id",
        para3 = "enable",
        para1 = "group_id"
    },

    set_group_whole_ban = {
        para2 = "enable",
        para3 = "x",
        para1 = "group_id"
    },

    send_private_msg = {
        para2 = "message",
        para4 = "user_id",
        para3 = "auto_escape",
        para1 = "group_id"
    },

    delete_msg = {
        para1 = "message_id"
    },

    send_group_forward_msg = {
        para2 = "messages",
        para1 = "group_id"
    },

    get_msg = {
        para1 = "message_id"
    },
    --版本需要区分

    get_forward_msg = {
        para1 = "message_id"
    },

    get_image = {
        para1 = "file"
    },

    mark_msg_as_read = {
        para1 = "message_id"
    },

    set_group_anonymous_ban = {
        para1 = "group_id",
        para2 = "anonymous",
        para3 = "anonymous_flag",
        para4 = "duration"
    },

    set_group_leave = {
        para1 = "group_id",
        para2 = "is_dismiss"
    },

    send_group_sign = {
        para1 = "group_id"
    },

    set_friend_add_request = {
        para1 = "flag",
        para2 = "approve",
        para3 = "remark"
    },

    set_group_add_request = {
        para1 = "flag",
        para2 = "sub_type",
        para3 = "approve",
        para4 = "reason"
    },

    get_login_info = {},

    qidian_get_account_info = {},

    set_qq_profile = {
        para1 = "nickname",
        para2 = "company",
        para3 = "email",
        para4 = "college",
        para5 = "personal_note"
    },

    get_stranger_info = {
        para1 = "user_id",
        para2 = "nocache"
    },

    get_friend_list = {},

    get_unidirectional_friend_list = {},

    delete_friend = {
        para1 = "friend_id"
    },

    get_group_info = {
        para1 = "group_id",
        para2 = "no_cache"
    },

    get_group_list = {},

    get_group_member = {
        para1 = "group_id",
        para2 = "no_cache"
    },

    get_group_honor_info = {
        para1 = "group_id",
        para2 = "type"
    },

    can_send_image = {
        para1 = "yes"
    },

    can_send_record = {
        para1 = "yes"
    },

    get_version_info = {},

    set_restart = {},

    set_group_portrait = {
        para1 = "group_id",
        para2 = "file",
        para3 = "cache"
    },

    ocr_image = {
        para1 = "image"
    },

    get_group_system_msg = {
        para1 = "invited_requests",
        para2 = "join_requests"
    },

    upload_private_file = {
        para1 = "user_id",
        para2 = "file",
        para3 = "name"
    },

    upload_group_file = {
        para1 = "group_id",
        para2 = "file",
        para3 = "name",
        para4 = "folder"
    },

    get_group_file_system_info = {
        para1 = "group_id"
    },

    get_group_root_files = {
        para1 = "group_id"
    },

    get_group_files_by_folder = {
        para1 = "group_id",
        para2 = "folder_id"
    },

    creat_group_file_folder = {
        para1 = "group_id",
        para2 = "name",
        para3 = "parent_id"
    },

    delete_group_file = {
        para1 = "group_id",
        para2 = "file_id",
        para3 = "busid"
    },

    get_group_file_url = {
        para1 = "group_id",
        para2 = "file_id",
        para3 = "busid"
    },

    get_status = {},

    get_group_at_all_remain = {
        para1 = "group_id"
    },

    _send_group_notice = {
        para1 = "group_id",
        para2 = "content",
        para3 = "image"
    },

    _get_group_nitice = {
        para1 = "group_id"
    },

    reload_event_filter = {
        para1 = "file"
    },

    download_file = {
        para1 = "url",
        para2 = "thread_count",
        para3 = "headers"
    },

    get_online_clients = {
        para1 = "no_cache"
    },

    get_group_msg_history = {
        para1 = "message_seq",
        para2 = "group_id"
    },

    set_essence_msg = {
        para1 = "message_id"
    },

    delete_essence_msg = {
        para1 = "message_id"
    },

    get_essence_msg_list = {
        para1 = "group_id"
    },

    check_url_safely = {
        para1 = "url"
    },

    _get_model_show = {
        para1 = "model"
    },

    _set_model_show = {
        para1 = "model",
        para2 = "model_show"
    },

    send_private_forward_msg = {
        para1 = "user_id",
        para2 = "messages"
    },

    delete_undirectional_friend = {
        para1 = "user_id"
    }
}
api_list[".ocr_image"] = {
    para1 = "image"
}
--------------------------------------------------------------------------------------
---------------------------api终结点与参数储存表部分结束--------------------------------
--------------------------------------------------------------------------------------


local gapi = {}
local json = require("json")

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
    stat, data = http.post("http://127.0.0.1:" .. http_port .. "/" .. ept, json.encode(para))
    --访问api
    return stat, data
end

function gapi.http_get(ept, para1, para2, para3, para4, para5)
    local params = {}
    local k = 1
    if para1 ~= nil then
        params[k] = api_list[ept]["para1"] .. "=" .. para1
        k = k + 1
    end
    if para2 ~= nil then
        params[k] = api_list[ept]["para2"] .. "=" .. para2
        k = k + 1
    end
    if para3 ~= nil then
        params[k] = api_list[ept]["para3"] .. "=" .. para3
        k = k + 1
    end
    if para4 ~= nil then
        params[k] = api_list[ept]["para4"] .. "=" .. para4
        k = k + 1
    end
    if para5 ~= nil then
        params[k] = api_list[ept]["para5"] .. "=" .. para5
    end
    para = table.concat(params, "&")
    stat, data = http.get("http://127.0.0.1:" .. http_port .. "/" .. ept .. "?" .. para)
    return stat, data
end

return gapi
