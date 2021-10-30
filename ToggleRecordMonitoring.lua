
function toggleRecordMonitoring()

  selectedTrack = reaper.GetSelectedTrack(0,0)
  if selectedTrack == nil then
    do return end
  end 
  
  value = reaper.GetMediaTrackInfo_Value(selectedTrack,'I_RECMON')
  value = value +1
  if value>2 then
    value=0
  end
  reaper.SetMediaTrackInfo_Value(selectedTrack,'I_RECARM',1)
  reaper.SetMediaTrackInfo_Value(selectedTrack,'I_RECMON',value)
end

toggleRecordMonitoring()
