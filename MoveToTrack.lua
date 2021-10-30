function moveToTrack(dir)
  
  trackCount = reaper.CountTracks(0)
  
  selectedTrack = reaper.GetSelectedTrack(0,0)
  
  if selectedTrack ~= nil then
    idx = reaper.GetMediaTrackInfo_Value(selectedTrack,'IP_TRACKNUMBER')-1
    idx = idx + (dir * 4)
    
    if idx<0 then idx=0 end
    if idx>=trackCount then idx=trackCount-1 end
    
    
    for i=0,trackCount-1,1
    do
      track = reaper.GetTrack(0,i);
      local sel =0
      if i==idx then sel = 1 end
      reaper.SetMediaTrackInfo_Value(track,'I_SELECTED',sel)
    end
  end
  reaper.UpdateArrange()
end

moveToTrack(1)

