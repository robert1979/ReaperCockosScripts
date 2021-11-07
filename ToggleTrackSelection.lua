
function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

local section ="launchpad"
local key = "shift"
local r = reaper

function toggle_track_selection(idx)
  local c_value = r.GetExtState(section,key)
  local shift_pressed = c_value == 't' or c_value ==  nil

  local cpage = 0
  if r.HasExtState('lp','cpg')then
    cpage =  tonumber( r.GetExtState('lp','cpg'))
  end
    
  p_idx = (cpage*8) + idx

  trk = r.GetTrack(0,p_idx)
  if trk ~= nil then
    if shift_pressed then
      sel = r.GetMediaTrackInfo_Value(trk,'I_SELECTED')
      if sel == 1 then sel = 0 else sel=1 end
      r.SetMediaTrackInfo_Value(trk,'I_SELECTED',sel)
      r.Main_OnCommand(40913,0)
    else
      trk_count = r.CountTracks(0)
      sel = r.GetMediaTrackInfo_Value(trk,'I_SELECTED')
      if sel == 1 then sel = 0 else sel=1 end
      result =0;
      
      for i=0,trk_count-1 do
        ct = r.GetTrack(0,i)
        if ct == trk then 
          result = sel 
        else 
          result = 0 
        end
        r.SetMediaTrackInfo_Value(ct,'I_SELECTED',result)
      end
      r.Main_OnCommand(40913,0)
    end
  end
end
