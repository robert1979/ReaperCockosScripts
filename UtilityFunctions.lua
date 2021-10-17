

function TimeToBeats(time)
  nearestBeat,measure = reaper.TimeMap2_timeToBeats(0,pos)
  
  return math.floor(nearestBeat) + (measure * 4)
end


--dofile(reaper.GetResourcePath().."/Scripts/tenfour-step/include/tenfour-foundation.lua")
function getModifierState()
  local scriptB = reaper.NamedCommandLookup('_RS112e37157abd07a7a99efab82f44a07a1334a9da')
  state = reaper.GetToggleCommandState(scriptB)
  if(state == -1) then state =0 end
  return state
end
