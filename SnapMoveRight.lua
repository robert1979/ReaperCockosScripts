dofile (reaper.GetResourcePath()..'/Scripts/MyScripts/SnapMove.lua')
function s()
  Move(1)
end
reaper.defer(s)
