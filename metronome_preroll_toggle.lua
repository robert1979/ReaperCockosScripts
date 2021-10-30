function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

recMode = reaper.SNM_GetIntConfigVar("preroll", -666)&2==0

if recMode then r = 2 else r =0 end
reaper.SNM_SetIntConfigVar("preroll",r)
reaper.UpdateArrange()
