
function toggleMarker()
  local pos = reaper.GetCursorPosition()
  local deletedMarker = false
  local i = 0
  while true do
    local ret, isrgn, mpos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if ret == 0 then
      break
    end
    
    if  not isrgn then
      if mpos == pos then
        reaper.DeleteProjectMarker(0,markrgnindexnumber,isrgn)
        deletedMarker = true
      end
    end
    i = i + 1
  end
  if not deletedMarker then
    reaper.Main_OnCommand(40157,0)
  end
end

toggleMarker()
