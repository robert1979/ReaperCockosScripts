local section ="launchpad"
local key = "shift"
local r = reaper

function armTrack(trk_id)
  c_value = r.GetExtState(section,key)
  shift_pressed = c_value == 't' or c_value ==  nil
  
  local cpage = 0
  if r.HasExtState('lp','cpg')then
    cpage =  tonumber( r.GetExtState('lp','cpg'))
  end
  p_idx = (cpage*8) + trk_id

  trk = r.GetTrack(0,p_idx)
  if trk == nil then do return end end

  if not shift_pressed then
    armed = r.GetMediaTrackInfo_Value(trk,'I_RECARM')
    if armed == 0 then armed = 1 else armed = 0 end
    r.SetMediaTrackInfo_Value(trk, 'I_RECARM', armed)

  else
    value = r.GetMediaTrackInfo_Value(trk,'I_RECMON')
    value = value +1
    if value>2 then
      value=0
    end
    r.SetMediaTrackInfo_Value(trk,'I_RECMON',value)
  end
end
