
dofile (reaper.GetResourcePath()..'/Scripts/MyScripts/UtilityFunctions.lua')
dofile (reaper.GetResourcePath()..'/Scripts/MyScripts/CursorScrollItemSnap.lua')

--reaper.Undo_BeginBlock()
if getModifierState() == 0 then
  is_new_value,filename,sectionID,cmdID,mode,resolution,val  = reaper.get_action_context()
  
  pos = getCursorPosition(val,127,true)
  snapEnabled = (reaper.SNM_GetIntConfigVar('projshowgrid', -666)&256 ==0)
  
  if(snapEnabled) then
    beats = TimeToBeats(pos)
    nearestBeatTime = reaper.TimeMap2_beatsToTime(0,beats)
    setCursorPosition(nearestBeatTime,true)
  else
    setCursorPosition(pos,true)
  end
  selectCursorItemForSelectedTrack(pos)
else
  itemSnap()
end
--reaper.Undo_EndBlock('bobby scrub',0)
--reaper.CSurf_FlushUndo(

--reaper.Undo_OnStateChange("No Undo Point")
--reaper.CSurf_FlushUndo(true);
reaper.defer(function() end)
