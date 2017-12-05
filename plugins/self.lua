local function pre_process(msg)
 if msg.content_.ID == "MessageUnsupported" and redis:get("mute-video-not"..msg.to.id) and not is_mod(msg) then
 tdcli.deleteMessages(msg.chat_id_, {[0] = tonumber(msg.id_)} , dl_cb , nil) 
 end
end
local function run(msg, matches)
 if (matches[1] == "mute self" or matches[1] == "پاک شدن سلفی") and not redis:get("mute-video-not"..msg.to.id) and is_mod(msg) then
  hash = "mute-video-not"..msg.to.id
  redis:set(hash , true)
  tdcli.sendMessage(msg.to.id,msg.id_ ,0, "*پاک شدن  فیلم سلفی فعال شد*", 0, "md")
 elseif (matches[1] == "mute self" or matches[1] == "پاک شدن سلفی") and redis:get("mute-video-not"..msg.to.id) and is_mod(msg) then
  tdcli.sendMessage(msg.to.id,msg.id_ ,0, "*پاک شدن  فیلم سلفی فعال بود*", 0, "md")
 elseif matches[1] == "unmute self" or matches[1] == "پاک نشدن سلفی" and not redis:get("mute-video-not"..msg.to.id) and is_mod(msg) then
  tdcli.sendMessage(msg.to.id,msg.id_ ,0, "* پاک  نشدن فیلم سلفی فعال شد*", 0, "md")
 elseif matches[1] == "unmute self" or matches[1] == "پاک نشدن سلفی" and redis:get("mute-video-not"..msg.to.id) and is_mod(msg) then
  redis:del("mute-video-not"..msg.to.id)
  tdcli.sendMessage(msg.to.id,msg.id_ ,0, "*پاک نشدن فیلم سلفی غیر فعال بود*", 0, "md")
 end
end

return {
   patterns = {
      '^[/!#](mute self)$',
      '^[/!#](unmute self)$',
	  '^(پاک شدن سلفی)$',
	  '^(پاک نشدن سلفی)$',
 },
  run = run,
  pre_process = pre_process
}