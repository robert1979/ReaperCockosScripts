dofile (reaper.GetResourcePath()..'/Scripts/MyScripts/TakesSelector.lua')
function s()
  selectTake(-1)
end

reaper.defer(s)
