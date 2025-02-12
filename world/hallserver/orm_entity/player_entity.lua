local ormtable = require "skynet-fly.db.orm.ormtable"
local ormadapter_mysql = require "skynet-fly.db.ormadapter.ormadapter_mysql"
local skynet = require "skynet"
local env_util = require "skynet-fly.utils.env_util"

local ipairs = ipairs
local table = table
local assert = assert
local pairs = pairs

local g_ormobj = nil

local M = {}
local handle = {}

--玩家信息
function M.init()
    local adapter = ormadapter_mysql:new("orm_db")
    g_ormobj = ormtable:new("player")
    :int64("player_id")         --玩家id
    :string32("nickname")       --昵称
    :int8("sex")                --性别
    :uint16("level")            --等级
    :uint16("viplevel")         --vip等级
    --:string256("head_url")    --头像url    弃用
    :int32("head_frame_id")     --头像框id
    :int32("head_id")           --头像id
    :int64("create_time")       --创建时间
    :int64("last_login_time")   --最后登录时间
    :int64("last_logout_time")  --最后登出时间
    :int32("rank_score")        --段位积分
    :set_keys("player_id")
    :set_cache(60 * 60 * 100, 500, 100000)    --缓存1个小时，5秒同步一次更改，最大缓存10万条数据
    :builder(adapter)
    return g_ormobj
end

function handle.get_player_info(player_id, field_map)
    local entry = g_ormobj:get_one_entry(player_id)
    if entry then
        local entry_data = entry:get_entry_data()

        local info = {}
        for field in pairs(field_map) do
            assert(entry_data[field], "get_player_info field not exists :" .. field)
            info[field] = entry_data[field]
        end
        return info
    end
end

function handle.get_players_info(player_list, field_map)
    local ret_map = {}
    for i = 1, #player_list do
        local player_id = player_list[i]
        local entry = g_ormobj:get_one_entry(player_id)
        if entry then
            local entry_data = entry:get_entry_data()

            local info = {}
            for field in pairs(field_map) do
                assert(entry_data[field], "get_players_info field not exists :" .. field)
                info[field] = entry_data[field]
            end
            ret_map[player_id] = info
        end
    end

    return ret_map
end

function handle.change_rank_score(player_id, score)
    local entry = g_ormobj:get_one_entry(player_id)
    assert(entry, "change_rank_score not exists" .. player_id)

    local rank_score = entry:get('rank_score')
    rank_score = rank_score + score
    entry:set('rank_score', rank_score)

    return rank_score
end

M.handle = handle

return M