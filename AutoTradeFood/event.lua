---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by hydra.
--- DateTime: 2020-01-05 14:24
---

local addonName, L = ...

local frame = CreateFrame("FRAME", "ATFFrame")
frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("TRADE_ACCEPT_UPDATE")
frame:RegisterEvent("PARTY_INVITE_REQUEST")

local tclass_food = L.food.tclass_food


local function say_pos(to_player)
  SendChatMessage(
    "我目前位于坐标"..L.F.my_position()..", 如不便查看，可M我“"..L.cmds.invite_cmd.."”进组", "WHISPER", "Common", to_player
  )
end


local function say_scale(to_player)
  SendChatMessage("食水分配比例如下：", "WHISPER", "Common", to_player)
  for tclass, sc in pairs(tclass_food) do
    SendChatMessage(string.format("%s: 水%d 面包%d", tclass, sc[1], sc[2]), "WHISPER", "Common", to_player)
  end
  SendChatMessage("萨满: 6根寒冰箭", "WHISPER", "Common", to_player)
end


local function player_want_trade_gold(msg)

  msg = string.gsub(string.lower(msg), "金", "g")
  if string.match(msg, "%dg") or string.match(msg, "给g") then
    return true
  else
    return false
  end
end


local function eventHandler(self, event, msg, author, ...)
  if event == "CHAT_MSG_WHISPER" then
    author = string.match(author, "([^-]+)")
    if L.atfr_run == true then
      if string.lower(msg) == L.cmds.help_cmd or msg == "1" or string.lower(msg) == "help" then
        L.F.say_help(author)
      elseif string.lower(msg) == L.cmds.retrieve_position then
        say_pos(author)
      elseif msg == L.cmds.busy_cmd or msg == "2" then
        L.F.say_busy(author)
      elseif msg == L.cmds.invite_cmd then
        L.F.invite_player(author)
      elseif msg == "3" then
        SendChatMessage("请M我【"..L.cmds.invite_cmd.."】进组，而不是M我3，zu，组，谢谢", "WHISPER", "Common", author)
      elseif msg == "4" or msg == L.cmds.refill_help_cmd then
        L.F.refill_help(author)
      elseif msg == L.cmds.refill_cmd then
        L.F.refill_request(author)
      elseif msg == L.cmds.scale_cmd then
        say_scale(author)
      elseif msg == L.cmds.low_level_cmd then
        L.F.low_level_food_request(author)
      elseif msg == L.cmds.low_level_help_cmd or msg == "7" or L.F.search_str_contains(msg, {"45", "35", "25", "小水", "小面包"}) then
        L.F.say_low_level_help(author)
      elseif L.F.search_str_contains(msg, {"交易", "收到"}) then
        -- do nothing, auto sent by BurningTrade addons.
      elseif player_want_trade_gold(msg) then
        SendChatMessage("米豪不收取任何金币，需要开门，请M我【传送门】查看步骤；需要吃喝，请直接交易。详情M我【帮助】", "WHISPER", "Common", author)
      elseif L.F.may_set_scale(msg, author) then
        -- do nothing
      elseif msg == "5" then
        SendChatMessage(
                "请这样M我来设置比例： 【2组水，3组面包】，或者【法师，可不可以来水3组，面包2组？】或者，【2水】，等等，然后交易我。",
                "WHISPER", "Common", author)
      elseif L.F.search_str_contains(msg, {"暴风城", "铁炉堡", "苏斯"}) then
        L.F.gate_request(author, msg)
      elseif L.F.search_str_contains(msg, {"门", "暴风", "铁", "精灵", L.cmds.gate_help_cmd}) or msg == "6" then
        L.F.say_gate_help(author)
      elseif msg == L.cmds.say_ack then
        L.F.say_acknowledgements(author)
      elseif L.F.search_str_contains(msg, {"脚本", "外挂", "机器", "自动", "宏"}) then
        SendChatMessage("是的，我是纯公益机器人，请亲手下留情，爱你哦！", "WHISPER", "Common", author)
      elseif L.F.search_str_contains(msg, {"谢", "蟹", "xie", "3q"}, "left") then
        SendChatMessage("小事不言谢，欢迎随时回来薅羊毛！", "WHISPER", "Common", author)
      else
        if not(author == UnitName("player")) then
          SendChatMessage(
                  "【渴了？饿了？经济舱？找米豪！请直接交易我！需要帮助，请M我“"
                          ..L.cmds.help_cmd.."”需要进组，请M我【"
                          ..L.cmds.invite_cmd.."】】",
                  "WHISPER", "Common", author
          )
        end
      end
    elseif L.atfr_run == "maintain" then
      SendChatMessage("米豪正在停机维护，暂时无法为您提供服务……", "WHISPER", "Common", author)
    end
  elseif event == "PARTY_INVITE_REQUEST" then
    if L.atfr_run then
      DeclineGroup()
      StaticPopup_Hide("PARTY_INVITE")
      SendChatMessage("请勿邀请我进组，您可以M我【"..L.cmds.invite_cmd.."】进组，谢谢！", "WHISPER", "Common", msg)
      L.F.invite_player(msg)
    end
  end
end


frame:SetScript("OnEvent", eventHandler)


local easter_egg_frame = CreateFrame("FRAME")
easter_egg_frame:RegisterEvent("CHAT_MSG_SAY")


local function easter_eggs(self, event, message, author, ...)
  if L.atfr_run then
    if event == "CHAT_MSG_SAY" then
      author = string.match(author, "([^-]+)")
      if author == UnitName("player") then
        return
      end
      if L.F.search_str_contains(message, {"卑微的侏儒"}) then
        SendChatMessage("卑微？！伙计。我不在乎你是谁，没有人敢说强大的米尔豪斯是一个”卑微“的侏儒！", "say")
      elseif L.F.search_str_contains(message, {"十点法力值", "10点法力值"}) then
        SendChatMessage("愿青龙指引你钓上一整天的鱼", "say")
      elseif L.F.search_str_contains(message, {"等死吧"}) then
        SendChatMessage("等等，我要先准备一下。你们先上，我先来做点水", "say")
      end
    end
  end
end

easter_egg_frame:SetScript("OnEvent", easter_eggs)
