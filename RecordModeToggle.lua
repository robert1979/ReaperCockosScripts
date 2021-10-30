

function recordModeToggle()

  recMode = reaper.SNM_GetIntConfigVar("projrecmode", -666)

  if recMode ==1 then reaper.Main_OnCommand(40076,0)
  elseif recMode == 2 then reaper.Main_OnCommand(40253,0)
  elseif recMode == 0 then reaper.Main_OnCommand(40252,0) end
  
end


recordModeToggle()
