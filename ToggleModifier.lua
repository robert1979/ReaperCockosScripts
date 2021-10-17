--dofile(reaper.GetResourcePath().."/Scripts/UtilityFunctions.lua")
--toggleModifier()

function toggleModifier()
  is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  state  = reaper.GetToggleCommandState(cmdID)
  --reaper.ShowConsoleMsg(state)
  
  if(state<=0) then state =1 else state =0 end
  reaper.SetToggleCommandState(sectionID,cmdID, state)
end

toggleModifier()
