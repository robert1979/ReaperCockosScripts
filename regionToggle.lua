function msg(m)
  reaper.ShowConsoleMsg(m)
end


local deletedRegion = false
local pos = reaper.GetCursorPosition()
local i = 0
while true do
  local ret, isrgn, mpos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
  if ret == 0 then
    break
  end
  
  if isrgn then
    if mpos< pos and rgnend>pos then
      reaper.DeleteProjectMarker(0,markrgnindexnumber, true)
      deletedRegion = true
    end
  end
  i = i + 1
end

if not deletedRegion then
  reaper.Main_OnCommand(40174,0)
end
