
function lerp(a, b, t)
  return a + (b - a) * t
end

is_new_value,filename,sectionID,cmdID,mode,resolution,val  = reaper.get_action_context()
length = reaper.GetProjectLength()
minStart = 0
minEnd = length + (length * 0.2)

cpos = reaper.GetCursorPosition()

f = 1-((val)/127)


l = math.min((length*1.5),180)

halflength = lerp(l,10,f)

--reaper.ShowConsoleMsg(halflength .. '  ')
startPos =  cpos-halflength
endPos = cpos + halflength



--viewportStartTime,viewPortEndTime = reaper.GetSet_ArrangeView2(0,false,0,0,10,20)

--reaper.ShowConsoleMsg(viewportStartTime .. '   ' .. viewPortEndTime)


viewportStartTime,viewPortEndTime = reaper.GetSet_ArrangeView2(0,true,0,0,startPos,endPos)
