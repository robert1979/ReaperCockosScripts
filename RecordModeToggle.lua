

function recordModeToggle()

 -- reaper.Main_OnCommand(40252,0) --normal recordh
 -- reaper.Main_OnCommand(40076,0) --time selection auto punch
 -- reaper.Main_OnCommand(40253,0) --item selection auto punch
  
  --recMode = reaper..SNM_GetIntConfigVar("projrecmode", -666)
  recMode = reaper.SNM_GetIntConfigVar("projrecmode", -666)

  if recMode ==1 then reaper.Main_OnCommand(40076,0)
  elseif recMode == 2 then reaper.Main_OnCommand(40253,0)
  elseif recMode == 0 then reaper.Main_OnCommand(40252,0) end
  
end


recordModeToggle()
