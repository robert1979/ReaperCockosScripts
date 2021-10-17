
dofile (reaper.GetResourcePath()..'/Scripts/MyScripts/UtilityFunctions.lua')
is_new_value,filename,sectionID,cmdID,mode,resolution,val  = reaper.get_action_context()
length = reaper.GetProjectLength()

state =getModifierState()

pos = (length/127) * val

if length == 0 then
  pos = 30/127 * val
end

if(state == 1) then
  beats = TimeToBeats(pos)
  nearestBeatTime = reaper.TimeMap2_beatsToTime(0,beats)
  reaper.SetEditCurPos(nearestBeatTime,true,false)
else
  reaper.SetEditCurPos(pos,true,false)
end



--reaper.ShowConsoleMsg(length)
