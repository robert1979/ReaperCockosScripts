is_new_value,filename,sectionID,cmdID,mode,resolution,val  = reaper.get_action_context()

viewportStartTime,viewPortEndTime = reaper.GetSet_ArrangeView2(0,false,0,0,10,20)
length = viewPortEndTime - viewportStartTime

pos = ((length/127) * val) + viewportStartTime

if length == 0 then
  pos = 30/127 * val
end

reaper.SetEditCurPos(pos,false,false)
--reaper.ShowConsoleMsg(length)
