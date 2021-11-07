function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

function toggle_track_solo(idx)
  local section ="launchpad"
  local key = "shift"
  local r = reaper
  local cpage = 0
  
  if r.HasExtState('lp','cpg')then
    cpage =  tonumber( r.GetExtState('lp','cpg'))
  end
    
  local p_idx = (cpage*8) + idx

  local trk = r.GetTrack(0,p_idx)
  if trk ~= nil then
      sel = r.GetMediaTrackInfo_Value(trk,'I_SOLO')
      if sel == 1 then sel = 0 else sel=1 end
      r.SetMediaTrackInfo_Value(trk,'I_SOLO',sel)
  end
end

