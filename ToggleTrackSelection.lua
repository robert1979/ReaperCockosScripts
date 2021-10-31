
local section ="launchpad"
local key = "shift"

function toggle_track_selection(idx)
  c_value = reaper.GetExtState(section,key)
  shift_pressed = c_value == 't' or c_value ==  nil

  trk = reaper.GetTrack(0,idx)
  if trk ~= nil then
    if shift_pressed then
      sel = reaper.GetMediaTrackInfo_Value(trk,'I_SELECTED')
      if sel == 1 then sel = 0 else sel=1 end
      reaper.SetMediaTrackInfo_Value(trk,'I_SELECTED',sel)
      reaper.Main_OnCommand(40913,0)
    else
      trk_count = reaper.CountTracks(0)
      sel = reaper.GetMediaTrackInfo_Value(trk,'I_SELECTED')
      if sel == 1 then sel = 0 else sel=1 end
      result =0;
      
      for i=0,trk_count-1 do
        ct = reaper.GetTrack(0,i)
        if ct == trk then 
          result = sel 
        else 
          result = 0 
        end
        reaper.SetMediaTrackInfo_Value(ct,'I_SELECTED',result)
      end
      reaper.Main_OnCommand(40913,0)
    end
  end
end
