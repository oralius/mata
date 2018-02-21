local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {ID = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {ID = group_id, type = 'group'}
  end

  return chat
end
local function delmsg (Beyond,Team)
msgs = Beyond.msgs 
for k,v in pairs(Team.messages_) do
msgs = msgs - 1
del_msg(v.chat_id_, v.id_)
if msgs == 1 then
del_msg(Team.messages_[0].chat_id_, Team.messages_[0].id_)
return false
end
end
tdcli.getChatHistory(Team.messages_[0].chat_id_, Team.messages_[0].id_,0 , 100, delmsg, {msgs=msgs})
end
function run(msg, matches) 
local Chash = "cmd_lang:"..msg.to.id
local Clang = redis:get(Chash)

	if (matches[1]:lower() == 'rmsgs' and not Clang) or (matches[1]:lower() == 'پاکسازی گروه' and Clang) then 
	if msg.to.type == "channel" then
	tdcli.getChatHistory(msg.to.id, msg.id_,0 , 100, delmsg, {msgs=1})
	local function delete_msgs_pro(arg,data)
local delall = data.members_
if not delall[0] then
return ''
else
for k, v in pairs(data.members_) do  
tdcli.deleteMessagesFromUser(msg.to.id, v.user_id_, dl_cb, nil)
end
end
end
local function delete_msgs_proo(arg,data)
local delall = data.members_
if not delall[0] then
return ''
else
for k, v in pairs(data.members_) do  
tdcli.deleteMessagesFromUser(msg.to.id, v.user_id_, dl_cb, nil)
end
end
end
tdcli_function ({
ID = "GetChannelMembers",
channel_id_ = getChatId(msg.chat_id_).ID,
filter_ = {
ID = "ChannelMembersRecent"
},
offset_ = 0,
limit_ = 10000
}, delete_msgs_pro, nil)
tdcli_function ({
ID = "GetChannelMembers",
channel_id_ = getChatId(msg.chat_id_).ID,
filter_ = {
ID = "ChannelMembersKicked"
},
offset_ = 0,
limit_ = 10000
}, delete_msgs_proo, nil)
	else
	tdcli.sendMessage(msg.chat_id_, 0, 1, ' فقط در سوپرگروه امکان پذیر است !', 1, 'html', dl_cb, nil)
end	
	end
end
return {               
	patterns = {
      "^[!/#](rmsgs)$",
	  "^(پاکسازی گروه)$",
		}, 
	run = run,
	}

--#by @AliAmiralizadeh 
