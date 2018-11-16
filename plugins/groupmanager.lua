local function modadd(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
   if not lang then
        return '_You are not bot admin_'
else
     return '*شما مالک ربات نمیباشید*'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
if not lang then
   return '_Group is already added_'
else
return '*گروه در لیست گروه های ربات ثبت بوده است*'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      whitelist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          welcome = 'no',
		  lock_join = 'no',
		  lock_edit = 'no',
		  lock_arabic = 'no',
		  lock_mention = 'no',
		  lock_all = 'no',
		  num_msg_max = '5',
		  set_char = '40',
		  time_check = '2',
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photo = 'no',
                  mute_gif = 'no',
                  mute_location = 'no',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                  mute_all = 'no',
				  mute_keyboard = 'no',
				  mute_game = 'no',
				  mute_inline = 'no',
				  mute_tgservice = 'no',
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
    if not lang then
  return '*Group has been added*'..msg_caption
else
  return '*گروه به صورت کامل در این ربات افزوده شد*'..msg_caption
end
end

local function modrem(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
     if not lang then
        return '_You are not bot admin_'
   else
        return '*شما مالک ربات نمیباشید*'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
  if not lang then
    return '_Group is not added_'
else
    return '*گروه به لیست گروه های این ربات افزوده نشده است*'
   end
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '*Group has been removed*'
 else
  return 'ربات با موفقيت از اين گروه حذف شد'
end
end

local function filter_word(msg, word)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
if data[tostring(msg.to.id)]['filterlist'][(word)] then
   if not lang then
         return "_Word_ *"..word.."* _is already filtered_"
            else
         return "_کلمه_ *"..word.."* _از قبل فیلتر بود_"
    end
end
   data[tostring(msg.to.id)]['filterlist'][(word)] = true
     save_data(_config.moderation.data, data)
   if not lang then
         return "_Word_ *"..word.."* _added to filtered words list_"
            else
         return "_کلمه_ *"..word.."* _به لیست کلمات فیلتر شده اضافه شد_"
    end
end

local function unfilter_word(msg, word)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
       save_data(_config.moderation.data, data)
       if not lang then
         return "_Word_ *"..word.."* _removed from filtered words list_"
       elseif lang then
         return "_کلمه_ *"..word.."* _از لیست کلمات فیلتر شده حذف شد_"
     end
      else
       if not lang then
         return "_Word_ *"..word.."* _is not filtered_"
       elseif lang then
         return "_کلمه_ *"..word.."* _از قبل فیلتر نبود_"
      end
   end
end

local function modlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "_Group is not added_"
 else
    return "*گروه به لیست گروه های این ربات افزوده نشده است*"
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
  if not lang then
    return "_No_ *moderator* _in this group_"
else
   return "در حال حاضر هیچ مدیری برای ربات انتخاب نشده است"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
if not lang then
    return "_Group is not added_"..msg_caption
else
return "*گروه به لیست گروه های این ربات افزوده نشده است*"
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
 if not lang then
    return "_No_ *owner* _in this group_"
else
    return "در حال حاضر هیچ مالکی برای ربات انتخاب نشده است"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مالکین گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_*گروه به لیست گروه های این ربات افزوده نشده است*_", 0, "md")
     end
  end
    if cmd == "setwhitelist" then
local function setwhitelist_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already in_ *white list*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل در لیست سفید بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been added to_ *white list*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به لیست سفید اضافه شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, setwhitelist_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "remwhitelist" then
local function remwhitelist_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not in_ *white list*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل در لیست سفید نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been removed from_ *white list*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از لیست سفید حذف شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, remwhitelist_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مالک ربات در این گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مالک ربات در این گروه منصوب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر ربات بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر ربات منصوب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل مالک ربات در این گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مالک ربات در این گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر ربات نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر ربات برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not arg.username then return false end
   if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
    if cmd == "setwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already in_ *white list*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل در لیست سفید بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been added to_ *white list*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به لیست سفید اضافه شد*", 0, "md")
   end
end
    if cmd == "remwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not in_ *white list*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل در لیست سفید نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been removed from_ *white list*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از لیست سفید حذف شد*", 0, "md")
   end
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مالک ربات در این گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مالک ربات در این گروه منصوب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر ربات بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر ربات منصوب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل مالک ربات در این گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مالک ربات در این گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر ربات نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر ربات برکنار شد*", 0, "md")
   end
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ "..check_markdown(data.type_.user_.username_).." ] :\n"
    .. ""..check_markdown(data.title_).."\n"
    .. " ["..data.id_.."]"
  else
     text = "اطلاعات برای [ "..check_markdown(data.type_.user_.username_).." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
         end
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
    if cmd == "setwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already in_ *white list*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل در لیست سفید بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been added to_ *white list*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به لیست سفید اضافه شد*", 0, "md")
   end
end
    if cmd == "remwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not in_ *white list*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل در لیست سفید نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been removed from_ *white list*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از لیست سفید حذف شد*", 0, "md")
   end
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مالک ربات در این گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مالک ربات در این گروه منصوب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر ربات بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر ربات منصوب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل مالک ربات در این گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مالک ربات در این گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر ربات نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر ربات برکنار شد*", 0, "md")
   end
end
    if cmd == "whois" then
if data.username_ then
username = '@'..check_markdown(data.username_)
else
if not lang then
username = 'not found'
 else
username = 'ندارد'
  end
end
     if not lang then
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'Info for [ '..data.id_..' ] :\nUserName : '..username..'\nName : '..data.first_name_, 1)
   else
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'اطلاعات برای [ '..data.id_..' ] :\nیوزرنیم : '..username..'\nنام : '..data.first_name_, 1)
      end
   end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not founded_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
    end
  end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "*Link* _Posting Is Already Locked_"
elseif lang then
 return "*ارسال لينك ممنوع بوده است.*براي خريد ربات به ايدي زير پيام دهيد"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Link* _Posting Has Been Locked_"
else
 return "*ارسال لینک در گروه ممنوع شد.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "*Link* _Posting Is Not Locked_" 
elseif lang then
return "*ارسال لینک در گروه ممنوع نمیباشد.*براي خريد ربات به ايدي زير پيام دهيد"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Link* _Posting Has Been Unlocked_" 
else
return "*ارسال لینک در گروه آزاد شد.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "*Tag* _Posting Is Already Locked_"
elseif lang then
 return "*ارسال مطالب آي دي دار ممنوع بوده است.*براي خريد ربات به ايدي زير پيام دهيد"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tag* _Posting Has Been Locked_"
else
 return "*ارسال مطالب ايدي دار ممنوع شد.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "*Tag* _Posting Is Not Locked_" 
elseif lang then
return "*ارسال مطالب ايدي دار قفل نيست.*براي خريد ربات به ايدي زير پيام دهيد"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Tag* _Posting Has Been Unlocked_" 
else
return "*ارسال مطالب ايدي دار مجاز شد.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "*Mention* _Posting Is Already Locked_"
elseif lang then
 return "*ارسال فراخوانی افراد هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mention* _Posting Has Been Locked_"
else 
 return "*ارسال فراخوانی افراد در گروه ممنوع شد*"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "*Mention* _Posting Is Not Locked_" 
elseif lang then
return "*ارسال فراخوانی افراد در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Mention* _Posting Has Been Unlocked_" 
else
return "*ارسال فراخوانی افراد در گروه آزاد شد*"
end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
if not lang then
 return "*Arabic/Persian* _Posting Is Already Locked_"
elseif lang then
 return "*ارسال کلمات عربی/فارسی در گروه هم اکنون ممنوع است*"
end
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Arabic/Persian* _Posting Has Been Locked_"
else
 return "*ارسال کلمات عربی/فارسی در گروه ممنوع شد*"
end
end
end

local function unlock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
if not lang then
return "*Arabic/Persian* _Posting Is Not Locked_" 
elseif lang then
return "*ارسال کلمات عربی/فارسی در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Arabic/Persian* _Posting Has Been Unlocked_" 
else
return "*ارسال کلمات عربی/فارسی در گروه آزاد شد*"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "*Editing* _Is Already Locked_"
elseif lang then
 return "*ویرایش پیام هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Editing* _Has Been Locked_"
else
 return "*ویرایش پیام در گروه ممنوع شد*"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "*Editing* _Is Not Locked_" 
elseif lang then
return "*ویرایش پیام در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Editing* _Has Been Unlocked_" 
else
return "*ویرایش پیام در گروه آزاد شد*"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "*Spam* _Is Already Locked_"
elseif lang then
 return "*ارسال اسپم  در حال حاضر ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Spam* _Has Been Locked_"
else
 return "*ارسال اسپم ممنوع شد*"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "*Spam* _Posting Is Not Locked_" 
elseif lang then
 return "*ارسال اسپم قفل نيست*"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data)
if not lang then 
return "*Spam* _Posting Has Been Unlocked_" 
else
 return "*ارسال اسپم در گروه آزاد شد*"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
if not lang then
 return "*Flooding* _Is Already Locked_"
elseif lang then
 return "*ارسال پیام رگباري در حال حاضر ممنوع است.*براي خريد ربات به ايدي زير پيام دهيد"
end
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Flooding* _Has Been Locked_"
else
 return "*ارسال پیام رگباري در گروه ممنوع است.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
if not lang then
return "*Flooding* _Is Not Locked_" 
elseif lang then
return "*ارسال پیام رگباري در گروه مجاز بود.*براي خريد ربات به ايدي زير پيام دهيد"
end
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Flooding* _Has Been Unlocked_" 
else
return "*ارسال پیام رگباري در گروه مجاز شد.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "*Bots* _Protection Is Already Enabled_"
elseif lang then
 return "*مبارزه با رباتها در حال حاضر فعال است*"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Bots* _Protection Has Been Enabled_"
else
 return "*مبارزه با رباتها در حال حاضر فعال شد*"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "*Bots* _Protection Is Not Enabled_" 
elseif lang then
return "*مبارزه با رباتها در حال حاضر غير فعال است*"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Bots* _Protection Has Been Disabled_" 
else
return "*مبارزه با رباتها در حال حاضر غير فعال شد*"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "*Markdown* _Posting Is Already Locked_"
elseif lang then
 return "ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Markdown* _Posting Has Been Locked_"
else
 return "*ارسال پیام های دارای فونت در گروه ممنوع شد*"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "*Markdown* _Posting Is Not Locked_"
elseif lang then
return "*ارسال پیام های دارای فونت در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Markdown* _Posting Has Been Unlocked_"
else
return "*ارسال پیام های دارای فونت در گروه آزاد شد*"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "*Webpage* _Is Already Locked_"
elseif lang then
 return "ارسال صفحات وب در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Webpage* _Has Been Locked_"
else
 return "*ارسال صفحات وب در گروه ممنوع شد*"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "*Webpage* _Is Not Locked_" 
elseif lang then
return "*ارسال صفحات وب در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Webpage* _Has Been Unlocked_" 
else
return "*ارسال صفحات وب در گروه آزاد شد*"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "شما مدیر ربات نمیباشید"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

if not lang then
local settings = data[tostring(target)]["settings"] 
 text = "*Group Settings:*\n_Lock edit :_ *"..settings.lock_edit.."*\n_Lock links :_ *"..settings.lock_link.."*\n_Lock tags :_ *"..settings.lock_tag.."*\n_Lock flood :_ *"..settings.flood.."*\n_Lock spam :_ *"..settings.lock_spam.."*\n_Lock mention :_ *"..settings.lock_mention.."*\n_Lock arabic :_ *"..settings.lock_arabic.."*\n_Lock webpage :_ *"..settings.lock_webpage.."*\n_Lock markdown :_ *"..settings.lock_markdown.."*\n_Group welcome :_ *"..settings.welcome.."*\n_Bots protection :_ *"..settings.lock_bots.."*\n_Flood sensitivity :_ *"..NUM_MSG_MAX.."*\n*____________________*\n*we channel*: https://telegram.me/joinchat/AAAAAEOADFWjbLtUsQcJ5g\n*Group Language* : *EN*"
else
local settings = data[tostring(target)]["settings"] 
 text = "*تنظیمات گروه:*\n_🔐قفل ویرایش پیام :_ *"..settings.lock_edit.."*\n_🔐قفل لینک :_ *"..settings.lock_link.."*\n_🔐قفل تگ :_ *"..settings.lock_tag.."*\n_🔐قفل پیام رگباری :_ *"..settings.flood.."*\n_🔐قفل اسپم  :_ *"..settings.lock_spam.."*\n_🔐قفل فراخوانی :_ *"..settings.lock_mention.."*\n_🔐قفل عربی :_ *"..settings.lock_arabic.."*\n_🔐قفل صفحات وب :_ *"..settings.lock_webpage.."*\n_🔐قفل فونت :_ *"..settings.lock_markdown.."*\n_پیام خوشآمد گویی :_ *"..settings.welcome.."*\n_محافظت در برابر ربات ها :_ *"..settings.lock_bots.."*\n_حداکثر پیام مجاز رگباری :_ *"..NUM_MSG_MAX.."*\n*____________________*\n*کانال ما*: https://telegram.me/joinchat/AAAAAEOADFWjbLtUsQcJ5g\n_زبان سوپرگروه_ : *FA*"
end
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "شما مدیر ربات نمیباشید"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "*Mute All* _Is Already Enabled_" 
elseif lang then
return "*چت و ارسال مطلب ممنوع بود.*براي خريد ربات به ايدي زير پيام دهيد"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Enabled_" 
else
return "*چت و ارسال مطلب  فعلا ممنوع شد.*براي خريد ربات به ايدي زير پيام دهيد"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "شما مدیر ربات نمیباشید"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "*Mute All* _Is Already Disabled_" 
elseif lang then
return "*چت و ارسال مطلب در گروه ممنوع نبود.*براي خريد ربات به ايدي زير پيام دهيد"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Disabled_" 
else
return "*چت و ارسال مطلب در گروه مجددا آزاد شد.*براي خريد ربات به ايدي زير پيام دهيد"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "*Mute Gif* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن گيف فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "*Mute Gif* _Has Been Enabled_"
else
 return "*پاك كردن گيف فعال شد*"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "*Mute Gif* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن گيف غير فعال بود*"
end
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Gif* _Has Been Disabled_" 
else
return "*پاك كردن گيف غير فعال شد*"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
if not lang then
 return "*Mute Game* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن بازيها فعال بوده است*"
end
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Game* _Has Been Enabled_"
else
 return "*پاك كردن بازيها فعال شد*"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end 
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
if not lang then
return "*Mute Game* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن بازيها غير فعال بوده است*"
end
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Game* _Has Been Disabled_" 
else
return "*پاك كردن بازيها غير فعال شد*"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
if not lang then
 return "*Mute Inline* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن بنر شيشه اي فعال بود*"
end
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Inline* _Has Been Enabled_"
else
 return "*پاك كردن بنر شيشه اي فعال شد*"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
if not lang then
return "*Mute Inline* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن بنر شيشه اي غير فعال بود*"
end
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Inline* _Has Been Disabled_" 
else
return "*پاك كردن بنر شيشه اي غير فعال شد*"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "*Mute Text* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن متن فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Text* _Has Been Enabled_"
else
 return "*پاك كردن متن فعال شد*"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end 
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
if not lang then
return "*Mute Text* _Is Already Disabled_"
elseif lang then
return "*پاك كردن متن غير فعال است*" 
end
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Text* _Has Been Disabled_" 
else
return "*پاك كردن متن غير فعال شد*"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
 return "*Mute Photo* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن عكس فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Photo* _Has Been Enabled_"
else
 return "*پاك كردن عكس فعال شد*"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
return "*Mute Photo* _Is Already Disabled_" 
elseif lang then
return "پاك كردن عكس غير فعال بوده است"
end
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Photo* _Has Been Disabled_" 
else
return "*پاك كردن عكس غير فعال شد*"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "*Mute Video* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن فيلم فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mute Video* _Has Been Enabled_"
else
 return "*پاك كردن فيلم فعال شد*"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "*Mute Video* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن فيلم غير فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Video* _Has Been Disabled_" 
else
return "*پاك كردن فيلم غير فعال شد*"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "*Mute Audio* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن موزيك فعال بود*"
end
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Audio* _Has Been Enabled_"
else 
return "*پاك كردن موزيك فعال شد*"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "*Mute Audio* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن موزيك غير فعال بود*"
end
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Audio* _Has Been Disabled_"
else
return "*پاك كردن موزيك غير فعال شد*" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "*Mute Voice* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن صدا فعال بود*"
end
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Voice* _Has Been Enabled_"
else
 return "*پاك كردن صدا فعال شد*"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "*Mute Voice* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن صدا غير فعال بود*"
end
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Voice* _Has Been Disabled_" 
else
return "*پاك كردن صدا غير فعال شد*"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "*Mute Sticker* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن استيكر فعال بود*"
end
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Sticker* _Has Been Enabled_"
else
 return "*پاك كردن استيكر فعال شد*"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end 
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "*Mute Sticker* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن استيكر غير فعال بود*"
end
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Sticker* _Has Been Disabled_"
else
return "*پاك كردن استيكر غير فعال شد*"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "*Mute Contact* _Is Already Enabled_"
elseif lang then
 return "ارسال شماره تلفن ممنوع بوده است"
end
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Contact* _Has Been Enabled_"
else
 return "*ارسال شماره تلفن ممنوع شد*"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "*Mute Contact* _Is Already Disabled_" 
elseif lang then
return "*ارسال شماره تلفن ممنوع نبوده است*"
end
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Contact* _Has Been Disabled_" 
else
return "*ارسال شماره تلفن مجاز شد*"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "*Mute Forward* _Is Already Enabled_"
elseif lang then
 return "*فوروارد ممنوع بود*"
end
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Forward* _Has Been Enabled_"
else
 return "*فوروارد ممنوع شد*"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "*Mute Forward* _Is Already Disabled_"
elseif lang then
return "*فوروارد مجاز بود*"
end 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Forward* _Has Been Disabled_" 
else
return "*فوروارد مجاز شد*"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "*Mute Location* _Is Already Enabled_"
elseif lang then
 return "*پاك کردن موقعیت فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "*Mute Location* _Has Been Enabled_"
else
 return "*پاك کردن موقعیت فعال شد*"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "*Mute Location* _Is Already Disabled_" 
elseif lang then
return "*پاك کردن موقعیت غير فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Location* _Has Been Disabled_" 
else
return "*پاك کردن موقعیت غير فعال شد*"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "*Mute Document* _Is Already Enabled_"
elseif lang then
 return "*پاك كردن فايل فعال بوده است*"
end
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Document* _Has Been Enabled_"
else
 return "*پاك كردن فايل فعال شد*"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نمیباشید"
end
end 

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "*Mute Document* _Is Already Disabled_" 
elseif lang then
return "*پاك كردن فايل غير فعال بوده است*"
end
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Document* _Has Been Disabled_" 
else
return "*ارسال فايل مجاز شد*"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر ربات نمیباشید"
end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "*Mute TgService* _Is Already Enabled_"
elseif lang then
 return "*خدمات تلگرام فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute TgService* _Has Been Enabled_"
else
return "*پاك كردن خدمات تلگرام فعال شد*"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر ربات نیستید"
end 
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "*Mute TgService* _Is Already Disabled_"
elseif lang then
return "*خدمات تلگرام غير فعال بود*"
end 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute TgService* _Has Been Disabled_"
else
return "*پاك كردن خدمات تلگرام غير فعال شد*"
end 
end
end
----------MuteList---------
local function mutes(msg, target) 	
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"	
else
 return "شما مدیر ربات نیستید"
end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_keyboard"] then			
data[tostring(target)]["mutes"]["mute_keyboard"] = "no"		
end
end
if not lang then
local mutes = data[tostring(target)]["mutes"] 
 text = " *Group Mute List* : \n_Mute all : _ *"..mutes.mute_all.."*\n_Mute gif :_ *"..mutes.mute_gif.."*\n_Mute text :_ *"..mutes.mute_text.."*\n_Mute inline :_ *"..mutes.mute_inline.."*\n_Mute game :_ *"..mutes.mute_game.."*\n_Mute photo :_ *"..mutes.mute_photo.."*\n_Mute video :_ *"..mutes.mute_video.."*\n_Mute audio :_ *"..mutes.mute_audio.."*\n_Mute voice :_ *"..mutes.mute_voice.."*\n_Mute sticker :_ *"..mutes.mute_sticker.."*\n_Mute contact :_ *"..mutes.mute_contact.."*\n_Mute forward :_ *"..mutes.mute_forward.."*\n_Mute location :_ *"..mutes.mute_location.."*\n_Mute document :_ *"..mutes.mute_document.."*\n_Mute TgService :_ *"..mutes.mute_tgservice.."*\n_Mute Keyboard :_ *"..mutes.mute_keyboard.."*\n*____________________*\n*Bot channel*: @activebots\n*Group Language* : *EN*"
else
local mutes = data[tostring(target)]["mutes"] 
 text = " *لیست 🔐قفل رسانه ها* : \n_تعطیل بودن گپ : _ *"..mutes.mute_all.."*\n_پاک شدن تصاویر گيف :_ *"..mutes.mute_gif.."*\n_پاک شدن متن :_ *"..mutes.mute_text.."*\n_پاک شدن بنر شيشه اي:_ *"..mutes.mute_inline.."*\n_پاک شدن بازی ها :_ *"..mutes.mute_game.."*\n_پاک شدن عکس :_ *"..mutes.mute_photo.."*\n_پاک شدن فیلم :_ *"..mutes.mute_video.."*\n_پاک شدن آهنگ :_ *"..mutes.mute_audio.."*\n_پاک شدن صدا :_ *"..mutes.mute_voice.."*\n_پاک شدن استيكر :_ *"..mutes.mute_sticker.."*\n_پاک شدن مخاطب :_ *"..mutes.mute_contact.."*\n_پاک شدن فوروارد :_ *"..mutes.mute_forward.."*\n_پاک شدن موقعیت :_ *"..mutes.mute_location.."*\n_پاک شدن اسناد :_ *"..mutes.mute_document.."*\n_پاک شدن خدمات تلگرام :_ *"..mutes.mute_tgservice.."*\n_پاک شدن صفحه کلید :_ *"..mutes.mute_keyboard.."*\n*____________________*\n*Bot channel*: @activebots\n_زبان سوپرگروه_ : *FA*"
end
return text
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local Chash = "cmd_lang:"..msg.to.id
local Clang = redis:get(Chash)
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
if msg.to.type ~= 'pv' then
if ((matches[1] == "add" and not Clang) or (matches[1] == "ادد" and Clang)) then
return modadd(msg)
end
if ((matches[1] == "rem" and not Clang) or (matches[1] == "حذف ربات" and Clang)) then
return modrem(msg)
end
if not data[tostring(msg.to.id)] then return end
if (matches[1] == "id" and not Clang) or (matches[1] == "ایدی" and Clang) then
if not matches[2] and not msg.reply_id then
local function getpro(arg, data)
   if data.photos_[0] then
       if not lang then
            tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,'Chat ID : '..msg.to.id..'\nUser ID : '..msg.from.id,dl_cb,nil)
       elseif lang then
          tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,'شناسه گروه : '..msg.to.id..'\nشناسه شما : '..msg.from.id,dl_cb,nil)
     end
   else
       if not lang then
      tdcli.sendMessage(msg.to.id, msg.id_, 1, "`You Have Not Profile Photo...!`\n\n> *Chat ID :* `"..msg.to.id.."`\n*User ID :* `"..msg.from.id.."`", 1, 'md')
       elseif lang then
      tdcli.sendMessage(msg.to.id, msg.id_, 1, "_شما هیچ عکسی ندارید...!_\n\n> _شناسه گروه :_ `"..msg.to.id.."`\n_شناسه شما :_ `"..msg.from.id.."`", 1, 'md')
            end
        end
   end
   tdcli_function ({
    ID = "GetUserProfilePhotos",
    user_id_ = msg.from.id,
    offset_ = 0,
    limit_ = 1
  }, getpro, nil)
end
if msg.reply_id and not matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="id"})
  end
if matches[2] and is_mod(msg) then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id"})
      end
   end
if ((matches[1] == "pin" and not Clang) or (matches[1] == "سنجاق" and Clang)) and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
if not lang then
return "*Message Has Been Pinned*"
elseif lang then
return "*پیام سجاق شد*"
end
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
if not lang then
return "*Message Has Been Pinned*"
elseif lang then
return "*پیام سجاق شد*"
end
end
end
if ((matches[1] == 'unpin' and not Clang) or (matches[1] == "حذف سنجاق" and Clang)) and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
tdcli.unpinChannelMessage(msg.to.id)
if not lang then
return "*Pin message has been unpinned*"
elseif lang then
return "*پیام سنجاق شده پاک شد*"
end
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
tdcli.unpinChannelMessage(msg.to.id)
if not lang then
return "*Pin message has been unpinned*"
elseif lang then
return "*پیام سنجاق شده پاک شد*"
end
end
end
if ((matches[1]:lower() == "whitelist" and not Clang) or (matches[1] == "لیست سفید" and Clang)) and matches[2] == "+" and is_mod(msg) then
if not matches[3] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setwhitelist"})
  end
  if matches[3] and string.match(matches[3], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[3],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[3],cmd="setwhitelist"})
    end
  if matches[3] and not string.match(matches[3], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[3]
    }, action_by_username, {chat_id=msg.to.id,username=matches[3],cmd="setwhitelist"})
      end
   end
if ((matches[1]:lower() == "whitelist" and not Clang) or (matches[1] == "لیست سفید" and Clang)) and matches[2] == "-" and is_mod(msg) then
if not matches[3] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remwhitelist"})
  end
  if matches[3] and string.match(matches[3], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[3],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[3],cmd="remwhitelist"})
    end
  if matches[3] and not string.match(matches[3], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[3]
    }, action_by_username, {chat_id=msg.to.id,username=matches[3],cmd="remwhitelist"})
      end
   end
if ((matches[1] == "setowner" and not Clang) or (matches[1] == 'مالک' and Clang)) and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="setowner"})
      end
   end
if ((matches[1] == "remowner" and not Clang) or (matches[1] == "حذف مالک" and Clang)) and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="remowner"})
      end
   end
if ((matches[1] == "promote" and not Clang) or (matches[1] == "مدیر" and Clang)) and is_owner(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="promote"})
      end
   end
if ((matches[1] == "demote" and not Clang) or (matches[1] == "حذف مدیر" and Clang)) and is_owner(msg) then
if not matches[2] and msg.reply_id then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="demote"})
      end
   end

if ((matches[1] == "lock" and not Clang) or (matches[1] == "قفل" and Clang)) and is_mod(msg) then
local target = msg.to.id
if ((matches[2] == "link" and not Clang) or (matches[2] == "لینک" and Clang)) then
return lock_link(msg, data, target)
end
if ((matches[2] == "tag" and not Clang) or (matches[2] == "تگ" and Clang)) then
return lock_tag(msg, data, target)
end
if ((matches[2] == "mention" and not Clang) or (matches[2] == "فراخوانی" and Clang)) then
return lock_mention(msg, data, target)
end
if ((matches[2] == "arabic" and not Clang) or (matches[2] == "عربی" and Clang)) then
return lock_arabic(msg, data, target)
end
if ((matches[2] == "edit" and not Clang) or (matches[2] == "ویرایش" and Clang)) then
return lock_edit(msg, data, target)
end
if ((matches[2] == "spam" and not Clang) or (matches[2] == "اسپم" and Clang)) then
return lock_spam(msg, data, target)
end
if ((matches[2] == "flood" and not Clang) or (matches[2] == "رگبار" and Clang)) then
return lock_flood(msg, data, target)
end
if ((matches[2] == "bots" and not Clang) or (matches[2] == "ربات" and Clang)) then
return lock_bots(msg, data, target)
end
if ((matches[2] == "markdown" and not Clang) or (matches[2] == "فونت" and Clang)) then
return lock_markdown(msg, data, target)
end
if ((matches[2] == "webpage" and not Clang) or (matches[2] == "وب" and Clang)) then
return lock_webpage(msg, data, target)
end
if ((matches[2] == "pin" and not Clang) or (matches[2] == "سنجاق" and Clang)) and is_owner(msg) then
return lock_pin(msg, data, target)
end
if ((matches[2] == "join" and not Clang) or (matches[2] == "ورود" and Clang)) then
return lock_join(msg, data, target)
end
end

if ((matches[1] == "unlock" and not Clang) or (matches[1] == "باز کردن" and Clang)) and is_mod(msg) then
local target = msg.to.id
if ((matches[2] == "link" and not Clang) or (matches[2] == "لینک" and Clang)) then
return unlock_link(msg, data, target)
end
if ((matches[2] == "tag" and not Clang) or (matches[2] == "تگ" and Clang)) then
return unlock_tag(msg, data, target)
end
if ((matches[2] == "mention" and not Clang) or (matches[2] == "فراخوانی" and Clang)) then
return unlock_mention(msg, data, target)
end
if ((matches[2] == "arabic" and not Clang) or (matches[2] == "عربی" and Clang)) then
return unlock_arabic(msg, data, target)
end
if ((matches[2] == "edit" and not Clang) or (matches[2] == "ویرایش" and Clang)) then
return unlock_edit(msg, data, target)
end
if ((matches[2] == "spam" and not Clang) or (matches[2] == "اسپم" and Clang)) then
return unlock_spam(msg, data, target)
end
if ((matches[2] == "flood" and not Clang) or (matches[2] == "رگبار" and Clang)) then
return unlock_flood(msg, data, target)
end
if ((matches[2] == "bots" and not Clang) or (matches[2] == "ربات" and Clang)) then
return unlock_bots(msg, data, target)
end
if ((matches[2] == "markdown" and not Clang) or (matches[2] == "فونت" and Clang)) then
return unlock_markdown(msg, data, target)
end
if ((matches[2] == "webpage" and not Clang) or (matches[2] == "وب" and Clang)) then
return unlock_webpage(msg, data, target)
end
if ((matches[2] == "pin" and not Clang) or (matches[2] == "سنجاق" and Clang)) and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if ((matches[2] == "join" and not Clang) or (matches[2] == "ورود" and Clang)) then
return unlock_join(msg, data, target)
end
end
if ((matches[1] == "mute" and not Clang) or (matches[1] == "پاک شدن" and Clang)) and is_mod(msg) then
local target = msg.to.id
if ((matches[2] == "all" and not Clang) or (matches[2] == "همه" and Clang)) then
return mute_all(msg, data, target)
end
if ((matches[2] == "gif" and not Clang) or (matches[2] == "گیف" and Clang)) then
return mute_gif(msg, data, target)
end
if ((matches[2] == "text" and not Clang) or (matches[2] == "متن" and Clang)) then
return mute_text(msg ,data, target)
end
if ((matches[2] == "photo" and not Clang) or (matches[2] == "عکس" and Clang)) then
return mute_photo(msg ,data, target)
end
if ((matches[2] == "video" and not Clang) or (matches[2] == "فیلم" and Clang)) then
return mute_video(msg ,data, target)
end
if ((matches[2] == "audio" and not Clang) or (matches[2] == "اهنگ" and Clang)) then
return mute_audio(msg ,data, target)
end
if ((matches[2] == "voice" and not Clang) or (matches[2] == "صدا" and Clang)) then
return mute_voice(msg ,data, target)
end
if ((matches[2] == "sticker" and not Clang) or (matches[2] == "استیکر" and Clang)) then
return mute_sticker(msg ,data, target)
end
if ((matches[2] == "contact" and not Clang) or (matches[2] == "مخاطب" and Clang)) then
return mute_contact(msg ,data, target)
end
if ((matches[2] == "forward" and not Clang) or (matches[2] == "فوروارد" and Clang)) then
return mute_forward(msg ,data, target)
end
if ((matches[2] == "location" and not Clang) or (matches[2] == "موقعیت" and Clang)) then
return mute_location(msg ,data, target)
end
if ((matches[2] == "document" and not Clang) or (matches[2] == "اسناد" and Clang)) then
return mute_document(msg ,data, target)
end
if ((matches[2] == "tgservice" and not Clang) or (matches[2] == "خدمات تلگرام" and Clang)) then
return mute_tgservice(msg ,data, target)
end
if ((matches[2] == "inline" and not Clang) or (matches[2] == "بنر" and Clang)) then
return mute_inline(msg ,data, target)
end
if ((matches[2] == "game" and not Clang) or (matches[2] == "بازی" and Clang)) then
return mute_game(msg ,data, target)
end
if ((matches[2] == "keyboard" and not Clang) or (matches[2] == "صفحه کلید" and Clang)) then
return mute_keyboard(msg ,data, target)
end
end

if ((matches[1] == "unmute" and not Clang) or (matches[1] == "پاک نشدن" and Clang)) and is_mod(msg) then
local target = msg.to.id
if ((matches[2] == "all" and not Clang) or (matches[2] == "همه" and Clang)) then
return unmute_all(msg, data, target)
end
if ((matches[2] == "gif" and not Clang) or (matches[2] == "گیف" and Clang)) then
return unmute_gif(msg, data, target)
end
if ((matches[2] == "text" and not Clang) or (matches[2] == "متن" and Clang)) then
return unmute_text(msg, data, target)
end
if ((matches[2] == "photo" and not Clang) or (matches[2] == "عکس" and Clang)) then
return unmute_photo(msg ,data, target)
end
if ((matches[2] == "video" and not Clang) or (matches[2] == "فیلم" and Clang)) then
return unmute_video(msg ,data, target)
end
if ((matches[2] == "audio" and not Clang) or (matches[2] == "اهنگ" and Clang)) then
return unmute_audio(msg ,data, target)
end
if ((matches[2] == "voice" and not Clang) or (matches[2] == "صدا" and Clang)) then
return unmute_voice(msg ,data, target)
end
if ((matches[2] == "sticker" and not Clang) or (matches[2] == "استیکر" and Clang)) then
return unmute_sticker(msg ,data, target)
end
if ((matches[2] == "contact" and not Clang) or (matches[2] == "مخاطب" and Clang)) then
return unmute_contact(msg ,data, target)
end
if ((matches[2] == "forward" and not Clang) or (matches[2] == "فوروارد" and Clang)) then
return unmute_forward(msg ,data, target)
end
if ((matches[2] == "location" and not Clang) or (matches[2] == "موقعیت" and Clang)) then
return unmute_location(msg ,data, target)
end
if ((matches[2] == "document" and not Clang) or (matches[2] == "اسناد" and Clang)) then
return unmute_document(msg ,data, target)
end
if ((matches[2] == "tgservice" and not Clang) or (matches[2] == "خدمات تلگرام" and Clang)) then
return unmute_tgservice(msg ,data, target)
end
if ((matches[2] == "inline" and not Clang) or (matches[2] == "بنر" and Clang)) then
return unmute_inline(msg ,data, target)
end
if ((matches[2] == "game" and not Clang) or (matches[2] == "بازی" and Clang)) then
return unmute_game(msg ,data, target)
end
if ((matches[2] == "keyboard" and not Clang) or (matches[2] == "صفحه کلید" and Clang)) then
return unmute_keyboard(msg ,data, target)
end
end
if ((matches[1] == "gpinfo" and not Clang) or (matches[1] == "اطلاعات گروه" and Clang)) and is_mod(msg) and msg.to.type == "channel" then
local function group_info(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not lang then
ginfo = "*Group Info :*\n_Admin Count :_ *"..data.administrator_count_.."*\n_Member Count :_ *"..data.member_count_.."*\n_Kicked Count :_ *"..data.kicked_count_.."*\n_Group ID :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
elseif lang then
ginfo = "*اطلاعات گروه :*\n_تعداد مدیران :_ *"..data.administrator_count_.."*\n_تعداد اعضا :_ *"..data.member_count_.."*\n_تعداد اعضای حذف شده :_ *"..data.kicked_count_.."*\n_شناسه گروه :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
end
if ((matches[1] == 'newlink' and not Clang) or (matches[1] == "لینک جدید" and Clang)) and is_mod(msg) then
			local function callback_link (arg, data)
   local hash = "gp_lang:"..msg.to.id
   local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data) 
				if not data.invite_link_ then
					administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
					save_data(_config.moderation.data, administration)
       if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_Bot is not group creator_\n_set a link for group with using_ /setlink"..msg_caption, 1, 'md')
       elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_ربات سازنده گروه نیست_\n_با دستور_ setlink/ _لینک جدیدی برای گروه ثبت کنید_"..msg_caption, 1, 'md')
    end
				else
					administration[tostring(msg.to.id)]['settings']['linkgp'] = data.invite_link_
					save_data(_config.moderation.data, administration)
        if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "*Newlink Created*", 1, 'md')
        elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_لینک جدید ساخته شد_", 1, 'md')
            end
				end
			end
 tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
		end
		if ((matches[1] == 'setlink' and not Clang) or (matches[1] == "تنظیم لینک" and Clang)) and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
      if not lang then
			return '_Please send the new group_ *link* _now_'
    else 
         return 'لطفا لینک گروه خود را ارسال کنید'
       end
		end

		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
            if not lang then
				return "*Newlink* _has been set_"
           else
           return "لینک جدید ذخیره شد"
		 	end
       end
		end
    if ((matches[1] == 'link' and not Clang) or (matches[1] == "لینک" and Clang)) and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First create a link for group with using_ /newlink\n_If bot not group creator set a link with using_ /setlink"
     else
        return "ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"
      end
      end
     if not lang then
       text = "<b>Group Link :</b>\n"..linkgp..msg_caption
     else
      text = "<b>لینک گروه :</b>\n"..linkgp..msg_caption
         end
        return tdcli.sendMessage(chat, msg.id, 1, text, 1, 'html')
     end
    if ((matches[1] == 'linkpv' and not Clang) or (matches[1] == "لینک خصوصی" and Clang)) and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First create a link for group with using_ /newlink\n_If bot not group creator set a link with using_ /setlink"
     else
        return "ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"
      end
      end
     if not lang then
     tdcli.sendMessage(user, "", 1, "<b>Group Link "..msg.to.title.." :</b>\n"..linkgp..msg_caption, 1, 'html')
     else
      tdcli.sendMessage(user, "", 1, "<b>لینک گروه "..msg.to.title.." :</b>\n"..linkgp..msg_caption, 1, 'html')
         end
      if not lang then
        return "*Group Link Was Send In Your Private Message*"
       else
        return "_لینک گروه به چت خصوصی شما ارسال شد_"
        end
     end
  if ((matches[1] == "setrules" and not Clang) or (matches[1] == "تنظیم قوانین" and Clang)) and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "*Group rules* _has been set_"
   else 
  return "قوانین گروه ثبت شد"
   end
  end
  if ((matches[1] == "rules" and not Clang) or (matches[1] == "قوانین" and Clang)) then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban."..msg_caption
    elseif lang then
       rules = "ℹ️ قوانین عمومي:\n1⃣ ارسال پیام رگبار ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ لطفا از موضوع گروه خارج نشید.\n5⃣ هرنوع نژاد پرستی, سیاسی، شیطان پرستی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود."..msg_caption
 end
        else
     rules = "*Group Rules :*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if ((matches[1] == "res" and not Clang) or (matches[1] == "کاربری" and Clang)) and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="res"})
  end
if ((matches[1] == "whois" and not Clang) or (matches[1] == "شناسه" and Clang)) and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="whois"})
  end
		if ((matches[1]:lower() == 'setchar' and not Clang) or (matches[1] == "حداکثر حروف مجاز" and Clang)) then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
    if not lang then
     return "*Character sensitivity* _has been set to :_ *[ "..matches[2].." ]*"
   else
     return "_حداکثر حروف مجاز در پیام تنظیم شد به :_ *[ "..matches[2].." ]*"
		end
  end
  if ((matches[1]:lower() == 'setflood' and not Clang) or (matches[1] == "رگبار" and Clang)) and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "_Wrong number, range is_ *[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			if not lang then
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
    else
    return '_محدودیت پیام رگباري به_ *'..tonumber(matches[2])..'* _تنظیم شد._'
    end
       end
  if ((matches[1]:lower() == 'setfloodtime' and not Clang) or (matches[1] == "تنظیم زمان بررسی" and Clang)) and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "_Wrong number, range is_ *[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(chat)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
			if not lang then
    return "_Group_ *flood* _check time has been set to :_ *[ "..matches[2].." ]*"
    else
    return "_حداکثر زمان بررسی پیام های رگباری تنظیم شد به :_ *[ "..matches[2].." ]*"
    end
       end
		if ((matches[1]:lower() == 'clean' and not Clang) or (matches[1] == "پاک کردن" and Clang)) and is_owner(msg) then
			if ((matches[2] == 'mods' and not Clang) or (matches[2] == "مدیران" and Clang)) then
				if next(data[tostring(chat)]['mods']) == nil then
            if not lang then
					return "_No_ *moderators* _in this group_"
             else
                return "هیچ مدیری برای گروه انتخاب نشده است"
				end
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *moderators* _has been demoted_"
          else
            return "تمام مدیران گروه تنزیل مقام شدند"
			end
         end
			if ((matches[2] == 'filterlist' and not Clang) or (matches[2] == "لیست فیلتر" and Clang)) then
				if next(data[tostring(chat)]['filterlist']) == nil then
     if not lang then
					return "*Filtered words list* _is empty_"
         else
					return "_لیست کلمات فیلتر شده خالی است_"
             end
				end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
       if not lang then
				return "*Filtered words list* _has been cleaned_"
           else
				return "_لیست کلمات فیلتر شده پاک شد_"
           end
			end
			if ((matches[2] == 'rules' and not Clang) or (matches[2] == "قوانین" and Clang)) then
				if not data[tostring(chat)]['rules'] then
            if not lang then
					return "_No_ *rules* _available_"
             else
               return "قوانین برای گروه ثبت نشده است"
             end
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Group rules* _has been cleaned_"
          else
            return "قوانین گروه پاک شد"
			end
       end
			if ((matches[2] == 'welcome' and not Clang) or (matches[2] == "خوشامد" and Clang)) then
				if not data[tostring(chat)]['setwelcome'] then
            if not lang then
					return "*Welcome Message not set*"
             else
               return "پیام خوشآمد گویی ثبت نشده است"
             end
				end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Welcome message* _has been cleaned_"
          else
            return "پیام خوشآمد گویی پاک شد"
			end
       end
			if ((matches[2] == 'about' and not Clang) or (matches[2] == "درباره" and Clang)) then
        if msg.to.type == "chat" then
				if not data[tostring(chat)]['about'] then
            if not lang then
					return "_No_ *description* _available_"
            else
              return "پیامی مبنی بر درباره گروه ثبت نشده است"
          end
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
             if not lang then
				return "*Group description* _has been cleaned_"
           else
              return "پیام مبنی بر درباره گروه پاک شد"
             end
		   	end
        end
		if ((matches[1]:lower() == 'clean' and not Clang) or (matches[1] == "پاک کردن" and Clang)) and is_admin(msg) then
			if ((matches[2] == 'owners' and not Clang) or (matches[2] == "مالکان" and Clang)) then
				if next(data[tostring(chat)]['owners']) == nil then
             if not lang then
					return "_No_ *owners* _in this group_"
            else
                return "مالکی برای گروه انتخاب نشده است"
            end
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *owners* _has been demoted_"
           else
            return "تمامی مالکان گروه تنزیل مقام شدند"
          end
			end
     end
if ((matches[1] == "setname" and not Clang) or (matches[1] == "تنظیم نام" and Clang)) and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if ((matches[1] == "setabout" and not Clang) or (matches[1] == "تنظیم درباره" and Clang)) and matches[2] and is_mod(msg) then
     if msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif msg.to.type == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "*Group description* _has been set_"
    else
     return "پیام مبنی بر درباره گروه ثبت شد"
      end
  end
  if ((matches[1] == "about" and not Clang) or (matches[1] == "درباره" and Clang)) and msg.to.type == "chat" and is_owner(msg) then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "پیامی مبنی بر درباره گروه ثبت نشده است"
       end
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
  if ((matches[1] == 'filter' and not Clang) or (matches[1] == "فیلتر" and Clang)) and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if ((matches[1] == 'unfilter' and not Clang) or (matches[1] == "حذف فیلتر" and Clang)) and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if ((matches[1] == 'filterlist' and not Clang) or (matches[1] == "لیست فیلتر" and Clang)) and is_mod(msg) then
    return filter_list(msg)
  end
if ((matches[1] == "settings" and not Clang) or (matches[1] == "تنظیمات" and Clang)) and is_mod(msg) then
return group_settings(msg, target)
end
if ((matches[1] == "mutelist" and not Clang) or (matches[1] == "لیست پاک شدن ها" and Clang)) and is_mod(msg) then
return mutes(msg, target)
end
if ((matches[1] == "modlist" and not Clang) or (matches[1] == "لیست مدیران" and Clang)) and is_mod(msg) then
return modlist(msg)
end
if ((matches[1] == "ownerlist" and not Clang) or (matches[1] == "لیست مالکان" and Clang)) and is_owner(msg) then
return ownerlist(msg)
end
if ((matches[1] == "whitelist" and not Clang) or (matches[1] == "لیست سفید" and Clang)) and not matches[2] and is_mod(msg) then
return whitelist(msg.to.id)
end

if ((matches[1]:lower() == "opt" and not Clang) or (matches[1] == "تنظیمات کل" and Clang)) and is_mod(msg) then
local function found_helper(TM, Beyond)
local function inline_query_cb(TM, BD)
      if BD.results_ and BD.results_[0] then
		tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, BD.inline_query_id_, BD.results_[0].id_, dl_cb, nil)
    else
    if not lang then
    text = "*Helper is offline*\n\n"
        elseif lang then
    text = "_ربات هلپر خاموش است_\n\n"
    end
  return tdcli.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
   end
end
tdcli.getInlineQueryResults(Beyond.id_, msg.to.id, 0, 0, msg.to.id, 0, inline_query_cb, nil)
end
tdcli.searchPublicChat(tostring(helper_username), found_helper, nil)
end

if (matches[1]:lower() == "setlang" and not Clang) and is_owner(msg) then
local hash = "gp_lang:"..msg.to.id
if matches[2] == "fa" then
redis:set(hash, true)
return "*🇮🇷زبان گروه تنظیم شد به : فارسی🇮🇷*"..msg_caption
  elseif matches[2] == "en" then
 redis:del(hash)
return "_Group Language Set To:_ EN"..msg_caption
end
end
if (matches[1] == 'زبان' and Clang) and is_owner(msg) then
local hash = "gp_lang:"..msg.to.id
if matches[2] == "فارسی" then
redis:set(hash, true)
return "*🇮🇷زبان گروه تنظیم شد به : فارسی🇮🇷*"..msg_caption
  elseif matches[2] == "انگلیسی" then
 redis:del(hash)
return "_Group Language Set To:_ EN"..msg_caption
end
end

if (matches[1]:lower() == "setcmd" and not Clang) and is_owner(msg) then
local hash = "cmd_lang:"..msg.to.id
if matches[2] == "fa" then
redis:set(hash, true)
   if lang then
return "*🇮🇷زبان دستورات ربات تنظیم شد به : فارسی🇮🇷*"..msg_caption
else
return "_Bot Commands Language Set To:_ Fa"..msg_caption
end
end
end

if (matches[1]:lower() == "دستورات انگلیسی" and Clang) and is_owner(msg) then
local hash = "cmd_lang:"..msg.to.id
redis:del(hash)
   if lang then
return "*🇬🇧زبان دستورات ربات تنظیم شد به : انگلیسی*"..msg_caption
else
return "_Bot Commands Language Set To:_ EN"..msg_caption
end
end

if (matches[1] == "help" and not Clang) and is_mod(msg) then
if not lang then
text = [[
*Bot Commands:*

*!setowner* `[username|id|reply]` 
_Set Group Owner(Multi Owner)_

*!remowner* `[username|id|reply]` 
 _Remove User From Owner List_

*!promote* `[username|id|reply]` 
_Promote User To Group Admin_

*!demote* `[username|id|reply]` 
_Demote User From Group Admins List_

*!setflood* `[1-50]`
_Set Flooding Number_

*!setchar* `[Number]`
_Set Flooding Characters_

*!setfloodtime* `[1-10]`
_Set Flooding Time_

*!silent* `[username|id|reply]` 
_Silent User From Group_

*!unsilent* `[username|id|reply]` 
_Unsilent User From Group_

*!kick* `[username|id|reply]` 
_Kick User From Group_

*!ban* `[username|id|reply]` 
_Ban User From Group_

*!unban* `[username|id|reply]` 
_UnBan User From Group_

*!whitelist* [+-] `[username|id|reply]` 
_Add Or Remove User From White List_

*!res* `[username]`
_Show User ID_

*!id* `[reply]`
_Show User ID_

*!whois* `[id]`
_Show User's Username And Name_

*!lock* `[link | join | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin | cmds]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
_If This Actions Unlock, Bot Not Delete Them_

*!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

*!set*`[rules | name | photo | link | about | welcome]`
_Bot Set Them_

*!clean* `[bans | mods | bots | rules | about | silentlist | filtelist | welcome]`   
_Bot Clean Them_

*!filter* `[word]`
_Word filter_

*!unfilter* `[word]`
_Word unfilter_

*!pin* `[reply]`
_Pin Your Message_

*!unpin* 
_Unpin Pinned Message_

*!welcome enable/disable*
_Enable Or Disable Group Welcome_

*!settings*
_Show Group Settings_

*!mutelist*
_Show Mutes List_

*!silentlist*
_Show Silented Users List_

*!filterlist*
_Show Filtered Words List_

*!banlist*
_Show Banned Users List_

*!ownerlist*
_Show Group Owners List_ 

*!modlist* 
_Show Group Moderators List_

*!whitelist* 
_Show Group White List Users_

*!rules*
_Show Group Rules_

*!about*
_Show Group Description_

*!id*
_Show Your And Chat ID_

*!gpinfo*
_Show Group Information_

*!newlink*
_Create A New Link_

*!link*
_Show Group Link_

*!linkpv*
_Send Group Link In Your Private Message_

*!setwelcome [text]*
_set Welcome Message_

*!setlang [fa | en]*
_Set Persian/English Language_

*!setcmd [fa | en]*
_Set CMD Persian/English Language_

*!helptools*
_Show Tools Help_

*!helpfun*
_Show Fun Help_

_You Can Use_ *[!/#]* _To Run The Commands_
_This Help List Only For_ *Moderators/Owners*
_Its Means, Only Group_ *Moderators/Owners* _Can Use It!_

*Good luck براي خريد ربات به ايدي زير پيام دهيد;)*]]

elseif lang then

text = [[
_دستورات ربات :_

*!setowner* `[username|id|reply]`
_انتخاب مالک گروه(قابل انتخاب چند مالک)_✅

*!remowner* `[username|id|reply]`
_حذف کردن فرد از فهرست مالکان گروه_✅

*!promote* `[username|id|reply]`
_ارتقا مقام کاربر به مدیر ربات_✅

*!demote* `[username|id|reply]`
_تنزیل مقام مدیر به کاربر_✅

*!setflood* `[1-50]`
_تنظیم حداکثر تعداد پیام رگباری_✅

*!setchar* `[Number]`
_تنظیم حداکثر کاراکتر پیام رگباری_✅

*!setfloodtime* `[1-10]`
_تنظیم زمان ارسال پیام رگباری_✅

*!silent* `[username|id|reply]`
_ساکت کردن کاربر در گروه_✅

*!unsilent* `[username|id|reply]`
_در آوردن کاربر از حالت ساکت در گروه_✅

*!kick* `[username|id|reply]`
_حذف کاربر از گروه_✅

*!ban* `[username|id|reply]`
_مسدود کردن کاربر از گروه_✅

*!unban* `[username|id|reply]`
_در آوردن از حالت مسدودیت کاربر از گروه_✅

*!whitelist* `[+|-]` `[یوزرنیم|ایدی|ریپلی]` 
_افزودن افراد به لیست سفید_✅

*!res* `[username]`
_نمایش شناسه کاربر_✅

*!id* `[reply]`
نمایش شناسه کاربر✅

*!whois* `[id]`
_نمایش نام کاربر, نام کاربری و اطلاعات حساب_✅

*!lock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
_در صورت 🔐قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_✅

*!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
_در صورت 🔐قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_✅

*!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدد بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_✅

*!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_در صورت ساکت نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_✅

*!set*`[rules | name | photo | link | about | welcome]`
_ربات آنهارا ثبت خواهد کرد_✅

*!clean* `[bans | mods | rules | about | silentlist | filterlist | welcome]`
_ربات آنهارا پاک خواهد کرد_✅

*!filter* `[word]`
_فیلتر‌کلمه مورد نظر_✅

*!unfilter* `[word]`
_ازاد کردن کلمه مورد نظر_✅

*!pin* `[reply]`
_ربات پیام شمارا در گروه سنجاق خواهد کرد_✅

*!unpin *
ربات پیام سنجاق شده در گروه را حذف خواهد کرد✅

*!welcome* `enable/disable`
_فعال یا غیرفعال کردن خوشامد گویی_✅

*!settings*
_نمایش تنظیمات گروه_✅

*!mutelist*
_نمایش فهرست رسانه های گروه_✅

*!silentlist*
_نمایش فهرست افراد ساکت_✅

*!filterlist*
_نمایش لیست کلمات فیلتر شده_✅

*!banlist*
_نمایش افراد مسدود شده از گروه_✅

*!ownerlist*
_نمایش فهرست مالکان گروه_✅

*!modlist*
_نمایش فهرست مدیران گروه_✅

*!whitelist*
_نمایش افراد سفید شده از گروه_✅

*!rules*
_نمایش قوانین گروه_✅

*!about*
_نمایش درباره گروه_✅

*!id*
_نمایش شناسه شما و گروه_✅

*!gpinfo*
_نمایش اطلاعات گروه_✅

*!newlink*
_ساخت لینک جدید_✅

*!setlink*
_تنظیم لینک جدید_✅

*!link*
_نمایش لینک گروه_✅

*!linkpv*
_ارسال لینک گروه به چت خصوصی شما_✅

*!setwelcome* `[text]`
_ثبت پیام خوش آمد گویی_✅

*!setlang* `[fa | en]`
_تنظیم زبان ربات به فارسی یا انگلیسی_✅

*!setcmd* `[fa | en]`
_تنظیم زبان دستورات ربات به فارسی یا انگلیسی_✅

*!helptools*
_نمایش راهنمای ابزار_✅

*!helpfun*
_نمایش راهنمای سرگرمی_✅

_شما میتوانید از [!/#] در اول دستورات استفاده کنید_

_این راهنما فقط برای مدیران/مالکان گروه میباشد!_

_*موفق باشید.*براي خريد ربات به ايدي زير پيام دهيد*_
]]
end
return text..msg_caption
end

if (matches[1] == "راهنما" and Clang) and is_mod(msg) then
if not lang then
text = [[
*Bot Commands:*

*مالک* `[username|id|reply]` 
_Set Group Owner(Multi Owner)_

*حذف مالک* `[username|id|reply]` 
 _Remove User From Owner List_

*مدیر* `[username|id|reply]` 
_Promote User To Group Admin_

*حذف مدیر* `[username|id|reply]` 
_Demote User From Group Admins List_

*رگبار* `[5 - 50]`
_Set Flooding Number_

*حداکثر حروف مجاز* `[عدد]`
_Set Flooding Characters_

*تنظیم زمان بررسی* `[1-10]`
_Set Flooding Time_

*سکوت* `[username|id|reply]` 
_Silent User From Group_

*حذف سکوت* `[username|id|reply]` 
_Unsilent User From Group_

*اخراج* `[username|id|reply]` 
_Kick User From Group_

*بن* `[username|id|reply]` 
_Ban User From Group_

*حذف بن* `[username|id|reply]` 
_UnBan User From Group_

*لیست سفید* [+-] `[username|id|reply]` 
_Add Or Remove User From White List_

*کاربری* `[username]`
_Show User ID_

*ایدی* `[reply]`
_Show User ID_

*شناسه* `[id]`
_Show User's Username And Name_

*قفل* `[لینک | ورود | تگ | ویرایش | عربی | وب | ربات |اسپم | پیام رگباری | فونت | فراخوانی | سنجاق]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*باز کردن* `[لینک | ورود | تگ | ویرایش | عربی | وب | ربات |اسپم | پیام رگباری | فونت | فراخوانی | سنجاق]`
_If This Actions Unlock, Bot Not Delete Them_

*پاک شدن* `[همه | گیف | عکس | اسناد | استیکر | صفحه کلید | فیلم | متن | فوروارد | موقعیت | اهنگ | صدا | مخاطب | بنر شیشه ای|بازی|خدمات تلگرام]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*پاک نشدن* `[همه | گیف | عکس | اسناد | استیکر | صفحه کلید | فیلم | متن | فوروارد | موقعیت | اهنگ | صدا | مخاطب | بنر شیشه ای|بازی|خدمات تلگرام]`
_If This Actions Unlock, Bot Not Delete Them_

*تنظیم*`[قوانین | نام | لینک | درباره | خوشامد]`
_Bot Set Them_

*پاک کردن* `[بن | مدیران | ربات | قوانین | درباره | لیست سکوت | خوشامد]`   
_Bot Clean Them_

*فیلتر* `[word]`
_Word filter_

*حذف فیلتر* `[word]`
_Word unfilter_

*سنجاق* `[reply]`
_Pin Your Message_

*حذف سنجاق* 
_Unpin Pinned Message_

*خوشامد فعال/غیرفعال*
_Enable Or Disable Group Welcome_

*تنظیمات*
_Show Group Settings_

*لیست پاک کردن ها*
_Show Mutes List_

*لیست سکوت*
_Show Silented Users List_

*لیست فیلتر*
_Show Filtered Words List_

*لیست بن*
_Show Banned Users List_

*لیست مالکان*
_Show Group Owners List_ 

*لیست مدیران* 
_Show Group Moderators List_

*لیست سفید* 
_Show Group White List Users_

*قوانین*
_Show Group Rules_

*درباره*
_Show Group Description_

*ایدی*
_Show Your And Chat ID_

*اطلاعات گروه*
_Show Group Information_

*لینک جدید*
_Create A New Link_

*تنظیم لینک*
_Set A New Link_

*لینک*
_Show Group Link_

*لینک خصوصی*
_Send Group Link In Your Private Message_

*تنظیم خوشامد [text]*
_set Welcome Message_

*زبان [فارسی | انگلیسی]*
_Set Persian/English Language_

*دستورات [فارسی | انگلیسی]*
_Set CMD Persian/English Language_

*راهنمای ابزار*
_Show Tools Help_

*راهنمای سرگرمی*
_Show Fun Help_

_This Help List Only For_ *Moderators/Owners!*
_Its Means, Only Group_ *Moderators/Owners* _Can Use It!/*براي خريد اين ربات به آيدي زير مراجعه كنيد*
_ شاد باشيد

*Good luck ;)*]]

elseif lang then

text = [[
*دستورات ربات :*

*مالک* `[یوزرنیم|ایدی|ریپلی]` 
_انتخاب مالک گروه(قابل انتخاب چند مالک)_✅

*حذف مالک* `[یوزرنیم|ایدی|ریپلی]` 
 _حذف کردن فرد از فهرست مالکان گروه_✅

*مدیر* `[یوزرنیم|ایدی|ریپلی]` 
_ارتقا مقام کاربر به مدیر ربات_✅

*حذف مدیر* `[یوزرنیم|ایدی|ریپلی]` 
_تنزیل مقام مدیر به کاربر_✅

*رگبار* `[5 - 50]`
_تنظیم حداکثر تعداد پیام رگباری_✅

*حداکثر حروف مجاز* `[عدد]`
_تنظیم حداکثر کاراکتر پیام رگباری_✅

*تنظیم زمان بررسی* `[1-10]`
_تنظیم زمان ارسال پیام رگباری_✅

*سکوت* `[یوزرنیم|ایدی|ریپلی]` 
_ساکت کردن کاربر در گروه_✅

*حذف سکوت* `[یوزرنیم|ایدی|ریپلی]` 
_در آوردن کاربر از حالت ساکت در گروه_✅

*اخراج* `[یوزرنیم|ایدی|ریپلی]` 
_حذف کاربر از گروه_✅

*بن* `[یوزرنیم|ایدی|ریپلی]` 
_مسدود کردن کاربر از گروه_✅

*حذف بن* `[یوزرنیم|ایدی|ریپلی]` 
_در آوردن از حالت مسدودیت کاربر از گروه_✅

*کاربری* `[یوزرنیم]`
_نمایش شناسه کاربر_✅

*ایدی* `[ریپلی]`
_نمایش شناسه کاربر_✅

*شناسه* `[ایدی]`
_نمایش نام کاربر, نام کاربری و اطلاعات حساب_✅

*🔐قفل* `[لینک | ورود | تگ | ویرایش | عربی | وب | ربات |اسپم | رگبار | فونت | فراخوانی | سنجاق]`
✅*در صورت 🔐قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد*

*باز کردن* `[لینک | ورود | تگ | ویرایش | عربی | وب | ربات |اسپم | رگبار| فونت | فراخوانی | سنجاق]`
✅*در صورت 🔐قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد*

*پاک شدن* [ |همه | گيف | متن | عكس | فيلم | اهنگ | صدا | استيكر | مخاطب | فوروارد | موقعيت | اسناد | خدمات تلگرام | بنرشيشه اي | بازي | بازي | صفحه كليد |]
✅*در صورت پاک شدن بودن ربات موارد ارسالي را پاك ميكند*

*پاک نشدن* `[ | همه | گيف | متن | عكس | فيلم | اهنگ | صدا | استيكر | مخاطب | فوروارد | موقعيت | اسناد | خدمات تلگرام | بنرشيشه اي | بازي | صفحه كليد ]`
✅*در صورت پاک نشدن بودن ربات موارد ارسالي را پاك نميكند*

*تنظیم*`[قوانین | نام | لینک | درباره | خوشامد]`
_ربات آنهارا ثبت خواهد کرد_✅

*پاک کردن* `[بن | مدیران | ربات | قوانین | درباره | لیست سکوت | خوشامد]`   
_ربات آنهارا پاک خواهد کرد_✅

*لیست سفید* `[+|-]` `[یوزرنیم|ایدی|ریپلی]` 
_افزودن افراد به لیست سفید_✅

*فیلتر* `[کلمه]`
_فیلتر‌کلمه مورد نظر_✅

*حذف فیلتر* `[کلمه]`
_ازاد کردن کلمه مورد نظر_✅

*سنجاق* `[reply]`
_ربات پیام شمارا در گروه سنجاق خواهد کرد_✅

*حذف سنجاق* 
_ربات پیام سنجاق شده در گروه را حذف خواهد کرد_✅

*!خوشامد فعال/غیرفعال*
_فعال یا غیرفعال کردن خوشامد گویی_✅

*تنظیمات*
_نمایش تنظیمات گروه_✅

*لیست پاک شدن ها*
_نمایش فهرست رسانه های گروه_✅

*لیست سکوت*
_نمایش فهرست افراد ساکت_✅

*لیست فیلتر*
_نمایش لیست کلمات فیلتر شده_✅

*لیست سفید*
_نمایش افراد سفید شده از گروه_✅

*لیست بن*
_نمایش افراد مسدود شده از گروه_✅

*لیست مالکان*
_نمایش فهرست مالکان گروه_✅ 

*لیست مدیران* 
_نمایش فهرست مدیران گروه_✅

*قوانین*
_نمایش قوانین گروه_✅

*درباره*
_نمایش درباره گروه_✅

*ایدی*
_نمایش شناسه شما و گروه_✅

*اطلاعات گروه*
_نمایش اطلاعات گروه_✅

*لینک جدید*
_ساخت لینک جدید_✅

*لینک*
_نمایش لینک گروه_✅

*تنظیم لینک*
_تنظیم لینک جدید برای گروه_✅

*لینک خصوصی*
_ارسال لینک گروه به چت خصوصی شما_✅

*زبان انگلیسی*
_تنظیم زبان انگلیسی_✅

*زبان فارسی*
_تنظیم زبان فارسی_✅

*دستورات انگلیسی*
_تنظیم دستورات انگلیسی_✅

*دستورات فارسی*
_تنظیم دستورات فارسی_✅

*تنظیم خوشامد [متن]*
_ثبت پیام خوش آمد گویی_✅

*راهنمای ابزار*
_نمایش راهنمای ابزار_✅

*راهنمای سرگرمی*
_نمایش راهنمای سرگرمی_✅

_این راهنما فقط برای مدیران/مالکان گروه میباشد!
*براي خريد ربات به ايدي زير پيام دهيد*
!_
*موفق باشید ;)*]]
end
return text..msg_caption
end
--------------------- Welcome -----------------------
	if ((matches[1] == "welcome" and not Clang) or (matches[1] == "خوشامد" and Clang)) and is_mod(msg) then
		if ((matches[2] == "enable" and not Clang) or (matches[2] == "فعال" and Clang)) then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
       if not lang then
				return "_Group_ *welcome* _is already enabled_"
       elseif lang then
				return "_خوشآمد گویی از قبل فعال بود_"
           end
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
       if not lang then
				return "_Group_ *welcome* _has been enabled_"
       elseif lang then
				return "_خوشآمد گویی فعال شد_"
          end
			end
		end
		
		if ((matches[2] == "disable" and not Clang) or (matches[2] == "غیرفعال" and Clang)) then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
      if not lang then
				return "_Group_ *Welcome* _is already disabled_"
      elseif lang then
				return "_خوشآمد گویی از قبل فعال نبود_"
         end
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
      if not lang then
				return "_Group_ *welcome* _has been disabled_"
      elseif lang then
				return "_خوشآمد گویی غیرفعال شد_"
          end
			end
		end
	end
	if ((matches[1] == "setwelcome" and not Clang) or (matches[1] == "تنظیم خوشامد" and Clang)) and matches[2] and is_mod(msg) then
		data[tostring(chat)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
       if not lang then
		return "_Welcome Message Has Been Set To :_\n*"..matches[2].."*\n\n*You can use :*\n_{gpname} Group Name_\n_{rules} ➣ Show Group Rules_\n_{time} ➣ Show time english _\n_{date} ➣ Show date english _\n_{timefa} ➣ Show time persian _\n_{datefa} ➣ show date persian _\n_{name} ➣ New Member First Name_\n_{username} ➣ New Member Username_"..msg_caption
       else
		return "_پیام خوشآمد گویی تنظیم شد به :_\n*"..matches[2].."*\n\n*شما میتوانید از*\n_{gpname} نام گروه_\n_{rules} ➣ نمایش قوانین گروه_\n_{time} ➣ ساعت به زبان انگلیسی _\n_{date} ➣ تاریخ به زبان انگلیسی _\n_{timefa} ➣ ساعت به زبان فارسی _\n_{datefa} ➣ تاریخ به زبان فارسی _\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n_استفاده کنید_"..msg_caption
        end
     end
	end
end
-----------------------------------------
local checkmod = true

local function pre_process(msg)
local chat = msg.to.id
local user = msg.from.id
local hash = "gp_lang:"..chat
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
 if checkmod and msg.text and msg.to.type == 'channel' then
 	checkmod = false
	tdcli.getChannelMembers(msg.to.id, 0, 'Administrators', 200, function(a, b)
	local secchk = true
		for k,v in pairs(b.members_) do
			if v.user_id_ == tonumber(our_id) then
				secchk = false
			end
		end
		if secchk then
			checkmod = false
			if not lang then
				return tdcli.sendMessage(msg.to.id, 0, 1, '_Robot isn\'t Administrator, Please promote to Admin!_', 1, "md")
			else
				return tdcli.sendMessage(msg.to.id, 0, 1, '_لطفا برای کارکرد کامل دستورات، ربات را به مدیر گروه ارتقا دهید._', 1, "md")
			end
		end
	end, nil)
 end
	local function welcome_cb(arg, data)
	local url , res = http.request('http://irapi.ir/time/')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
		administration = load_data(_config.moderation.data)
    if administration[arg.chat_id]['setwelcome'] then
     welcome = administration[arg.chat_id]['setwelcome']
      else
     if not lang then
     welcome = "*Welcome*"
    elseif lang then
     welcome = "_خوش آمدید_"
        end
     end
 if administration[tostring(arg.chat_id)]['rules'] then
rules = administration[arg.chat_id]['rules']
else
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@oralius"
    elseif lang then
       rules = "ℹ️ قوانین عمومي:\n1⃣ ارسال پیام رگبار ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ لطفا از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, سیاست ، شیطان پرستی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@oralius"
 end
end
if data.username_ then
user_name = "@"..check_markdown(data.username_)
else
user_name = ""
end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name_..' '..(data.last_name_ or '')))
		local welcome = welcome:gsub("{username}", user_name)
		local welcome = welcome:gsub("{time}", jdat.ENtime)
		local welcome = welcome:gsub("{date}", jdat.ENdate)
		local welcome = welcome:gsub("{timefa}", jdat.FAtime)
		local welcome = welcome:gsub("{datefa}", jdat.FAdate)
		local welcome = welcome:gsub("{gpname}", arg.gp_name)
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
	if msg.adduser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli.getUser(msg.adduser, welcome_cb, {chat_id=chat,msg_id=msg.id_,gp_name=msg.to.title})
		else
			return false
		end
	end
	if msg.joinuser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli.getUser(msg.sender_user_id_, welcome_cb, {chat_id=chat,msg_id=msg.id_,gp_name=msg.to.title})
		else
			return false
        end
		end
	end

 end
 
return {
patterns ={
"^[!/#](id)$",
"^[!/#](id) (.*)$",
"^[!/#](pin)$",
"^[!/#](unpin)$",
"^[!/#](gpinfo)$",
"^[!/#](test)$",
"^[!/#](add)$",
"^[!/#](rem)$",
"^[!/#](opt)$",
"^[!/#](whitelist) ([+-])$",
"^[!/#](whitelist) ([+-]) (.*)$",
"^[#!/](whitelist)$",
"^[!/#](setowner)$",
"^[!/#](setowner) (.*)$",
"^[!/#](remowner)$",
"^[!/#](remowner) (.*)$",
"^[!/#](promote)$",
"^[!/#](promote) (.*)$",
"^[!/#](demote)$",
"^[!/#](demote) (.*)$",
"^[!/#](modlist)$",
"^[!/#](ownerlist)$",
"^[!/#](lock) (.*)$",
"^[!/#](unlock) (.*)$",
"^[!/#](settings)$",
"^[!/#](mutelist)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](link)$",
"^[!/#](linkpv)$",
"^[!/#](setlink)$",
"^[!/#](newlink)$",
"^[!/#](rules)$",
"^[!/#](setrules) (.*)$",
"^[!/#](about)$",
"^[!/#](setabout) (.*)$",
"^[!/#](setname) (.*)$",
"^[!/#](clean) (.*)$",
"^[!/#](setflood) (%d+)$",
"^[!/#](setchar) (%d+)$",
"^[!/#](setfloodtime) (%d+)$",
"^[!/#](res) (.*)$",
"^[!/#](whois) (%d+)$",
"^[!/#](help)$",
"^[!/#](setlang) (.*)$",
"^[!/#](setcmd) (.*)$",
"^[#!/](filter) (.*)$",
"^[#!/](unfilter) (.*)$",
"^[#!/](filterlist)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^[!/#](setwelcome) (.*)",
"^[!/#](welcome) (.*)$",
"^(زبان) (.*)$",
"^(دستورات انگلیسی)$",
"^(ایدی)$",
"^(ایدی) (.*)$",
'^(تنظیمات)$',
'^(تنظیمات کل)$',
'^(سنجاق)$',
'^(حذف سنجاق)$',
'^(ادد)$',
'^(حذف ربات)$',
'^(ادمین گروه)$',
'^(ادمین گروه) (.*)$',
'^(حذف ادمین گروه) (.*)$',
'^(حذف ادمین گروه)$',
'^(لیست سفید) ([+-]) (.*)$',
'^(لیست سفید) ([+-])$',
'^(لیست سفید)$',
'^(مالک)$',
'^(مالک) (.*)$',
'^(حذف مالک) (.*)$',
'^(حذف مالک)$',
'^(مدیر)$',
'^(مدیر) (.*)$',
'^(حذف مدیر)$',
'^(حذف مدیر) (.*)$',
'^(قفل) (.*)$',
'^(باز کردن) (.*)$',
'^(پاک شدن) (.*)$',
'^(پاک نشدن) (.*)$',
'^(لینک جدید)$',
'^(لینک جدید) (خصوصی)$',
'^(اطلاعات گروه)$',
'^(دستورات) (.*)$',
'^(قوانین)$',
'^(لینک)$',
'^(تنظیم لینک)$',
'^(تنظیم قوانین) (.*)$',
'^(لینک) (خصوصی)$',
'^(کاربری) (.*)$',
'^(شناسه) (%d+)$',
'^(رگبار) (%d+)$',
'^(تنظیم زمان بررسی) (%d+)$',
'^(حداکثر حروف مجاز) (%d+)$',
'^(پاک کردن) (.*)$',
'^(درباره)$',
'^(تنظیم نام) (.*)$',
'^(تنظیم درباره) (.*)$',
'^(لیست فیلتر)$',
'^(لیست پاک شدن ها)$',
'^(لیست مالکان)$',
'^(لیست مدیران)$',
'^(راهنما)$',
'^(فیلتر) (.*)$',
'^(حذف فیلتر) (.*)$',
'^(خوشامد) (.*)$',
'^(تنظیم خوشامد) (.*)$',


},
run=run,
pre_process = pre_process
}
--end groupmanager.lua #beyond team#
