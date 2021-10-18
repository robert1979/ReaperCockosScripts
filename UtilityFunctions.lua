

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

function setCursorPosition(pos,restrictToViewPort)
  reaper.SetEditCurPos(pos,not restrictToViewPort,false)
end

function getCursorPosition(val,knobMaxValue,restrictToViewPort)
  pos =0

  if restrictToViewPort then
    viewportStartTime,viewPortEndTime = reaper.GetSet_ArrangeView2(0,false,0,0,10,20)
    length = viewPortEndTime - viewportStartTime
    
    pos = ((length/knobMaxValue) * val) + viewportStartTime
    
  else
    length = reaper.GetProjectLength() + 1
    pos = (length/knobMaxValue) * val
    if length == 0 then
      pos = 30/knobMaxValue * val
    end
  end
  return pos
end

function selectCursorItemForSelectedTrack(pos)
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  if selectedTrack == nil then 
    do return end 
  end
  
  selTrackNumber = reaper.GetMediaTrackInfo_Value(selectedTrack,'IP_TRACKNUMBER')
  selTrackItemCount = reaper.CountTrackMediaItems(selectedTrack)
  ignoreSelectedTrack = selectedTrack == nil or selTrackItemCount==0 
  itemCount = reaper.CountMediaItems(0)
  
  if(length == 0) then
    do return end
  end
  
  selectedItem = nil
  
  for i = 1,itemCount,1 do 
     item = reaper.GetMediaItem(0,i-1)
     track = reaper.GetMediaItemInfo_Value(item,'P_TRACK')
     cTrackNumber = reaper.GetMediaTrackInfo_Value(track,'IP_TRACKNUMBER')
     
     if ignoreSelectedTrack or selTrackNumber == cTrackNumber then
     
       leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
       rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
       
       if(pos>=leftPos and pos<=rightPos) then
        selectedItem = item
       end
    end
  end
  
  for i = 1,itemCount,1 do 
     item = reaper.GetMediaItem(0,i-1)
     reaper.SetMediaItemSelected(item,(item==selectedItem))
  end
  
end
