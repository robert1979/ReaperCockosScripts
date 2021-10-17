

function toggleModifier()
  is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  state  = reaper.GetToggleCommandState(cmdID)
  --reaper.ShowConsoleMsg(state)
  
  if(state<=0) then state =1 else state =0 end
  
  reaper.SetToggleCommandState(sectionID,cmdID, state)
end

--dofile(reaper.GetResourcePath().."/Scripts/tenfour-step/include/tenfour-foundation.lua")
function getModifierState()
  is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  return reaper.GetToggleCommandState(cmdID)
end
