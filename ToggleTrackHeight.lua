
local track_count,track,current_height,new_height = nil
track_count = reaper.CountTracks(0)
if track_count==0 then
  do return end
end

track = reaper.GetTrack(0,0)
current_height  = reaper.GetMediaTrackInfo_Value(track,'I_HEIGHTOVERRIDE')

new_height = 170
if current_height == 170 then new_height = 50 end

for i=1,track_count,1
do
  track = reaper.GetTrack(0,i-1)
  reaper.SetMediaTrackInfo_Value(track,'I_HEIGHTOVERRIDE',new_height)
end

reaper.TrackList_AdjustWindows(true)
