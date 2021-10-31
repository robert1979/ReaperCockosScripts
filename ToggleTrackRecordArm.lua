local section ="launchpad"
local key = "shift"

function armTrack(trk_id)
  c_value = reaper.GetExtState(section,key)
  shift_pressed = c_value == 't' or c_value ==  nil

  trk = reaper.GetTrack(0,trk_id)
  if trk == nil then do return end end

  if not shift_pressed then
    armed = reaper.GetMediaTrackInfo_Value(trk,'I_RECARM')
    if armed == 0 then armed = 1 else armed = 0 end
    reaper.SetMediaTrackInfo_Value(trk, 'I_RECARM', armed)

  else
    value = reaper.GetMediaTrackInfo_Value(trk,'I_RECMON')
    value = value +1
    if value>2 then
      value=0
    end
    reaper.SetMediaTrackInfo_Value(trk,'I_RECMON',value)
  end
end