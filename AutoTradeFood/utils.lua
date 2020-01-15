---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by hydra.
--- DateTime: 2020-01-05 13:13
---

local addonName, L = ...

function L.F.create_macro_button(button_name, macro_text)
  local cframe = CreateFrame("Button", button_name, UIParent, "SecureActionButtonTemplate");
--  cframe:RegisterForClicks("AnyUp");
  cframe:SetAttribute("type", "macro");
  cframe:SetAttribute("macrotext", macro_text);
  return cframe
end

function L.F.search_str_contains(s, tbl, position)
  for _, ss in pairs(tbl) do
    if s and string.lower(s):find(ss) then
      local l, u = string.find(string.lower(s), ss)
      local mid_ss = (l + u) / 2
      local mid_s = (1 + string.len(s)) / 2
      if position == "left" then
        return mid_ss <= mid_s
      elseif position == "right" then
        return mid_ss >= mid_s
      else
        return true
      end
    end
  end
  return false
end

function L.F.my_position()
  local mapID = C_Map.GetBestMapForUnit("player")
  local tempTable = C_Map.GetPlayerMapPosition(mapID, "player")
  local x, y = tempTable.x, tempTable.y
  return string.format("(%.1f,%.1f)", x * 100, y * 100)
end

function L.F.check_buff(buff_name, remain, is_debuff)
  local buff_func = UnitBuff
  if is_debuff then
    buff_func = UnitDebuff
  end
  local i = 1;
  if remain == nil then
    remain = 0
  end
  while true do
    local buff, _, _,   _, dur, ts = buff_func("player", i);
    if buff == nil then
      return false
    elseif buff == buff_name then
      local remaining
      if ts and ts > 0 then
        remaining = ts - GetTime()
      else
        remaining = 9999
      end
      return remaining > remain
    end
    i = i + 1;
  end;
end


function L.F.invite_player(player)
  if GetNumGroupMembers() >= 5 and not(IsInRaid()) then
    ConvertToRaid()
  elseif GetNumGroupMembers() <= 3 and IsInRaid() then
    ConvertToParty()
  end
  InviteUnit(player)
end


function L.F.nil_fallback_zero(value)
  if value == nil then
    return 0
  else
    return value
  end
end


function L.F.player_is_admin(player)
  if L.admin_names[player] then
    return true
  else
    return false
  end
end
