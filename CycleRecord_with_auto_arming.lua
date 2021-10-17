

function UnselectAllTracks()
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  reaper.SetTrackSelected(first_track, false)
end

function armTrack(selectedTrack)
  reaper.Main_OnCommand(40491,0)
  recInput = reaper.GetMediaTrackInfo_Value(selectedTrack,'I_RECINPUT')/1000
  recInput = math.floor(recInput)
  isMidi = recInput == 4
  monitor =0
  
  if isMidi then
    monitor = 1
  end
  
  reaper.SetMediaTrackInfo_Value(selectedTrack,'I_RECARM',1)
  reaper.SetMediaTrackInfo_Value(selectedTrack,'I_RECMON',monitor)
end


function record()

  selectedTrack = reaper.GetSelectedTrack(0,0)
  if selectedTrack == nil then
  reaper.ShowConsoleMsg('no tracks')
    do return end
  end 
  
  armTrack(selectedTrack)
end


record()
r = reaper.GetPlayState()
if r == 5 then
 reaper.Main_OnCommand(40667,0)
else
 reaper.Main_OnCommand(1013,0)
end

