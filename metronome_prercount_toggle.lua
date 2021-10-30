function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

recMode = reaper.SNM_GetIntConfigVar("projmetroen", -666)&16==0

if recMode then
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWCOUNTRECON'),0)
else 
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWCOUNTRECOFF'),0)
end

reaper.UpdateArrange()
