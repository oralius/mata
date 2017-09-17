do

local function run(msg, matches)
if matches[1]=="مقام من" and is_sudo(msg) then 
return  "*شما سازنده و صاحب ربات ميباشيد*"
elseif matches[1]=="مقام من" and is_admin(msg) then 
return  "*شما ادمين ربات و يك مقام پايين تر از صاحب ربات ميباشيد*"
elseif matches[1]=="مقام من" and is_owner(msg) then 
return  "*شما سازنده و صاحب گروه میباشید*"
elseif matches[1]=="مقام من" and is_mod(msg) then 
return  "*شما کمک مدیراین گروه میباشید*"
else
return  "*شما هیچ مقامی در ربات ندارید*"
end

end

return {
  patterns = {
    "^(مقام من)$",
    },
  run = run
}
end


--By @Tele_Sudo
-- @LuaError