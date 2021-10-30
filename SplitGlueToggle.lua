function msg(message)
  reaper.ShowConsoleMsg(message)
end


function splitGlue()
  local pos = reaper.GetCursorPosition()
  
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  if selectedTrack == nil then return end
  
  selTrackItemCount = reaper.CountTrackMediaItems(selectedTrack)
  if selTrackItemCount == 0 then return end
  
  spliTrack = nil
  itemCount = reaper.CountMediaItems(0)
  
  for i = 1,itemCount,1 do 
     item = reaper.GetMediaItem(0,i-1)
     track = reaper.GetMediaItemInfo_Value(item,'P_TRACK')
     
     if track==selectedTrack then 
       leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
       rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
       
       if leftPos<pos and rightPos>pos then
          splitTrack = item
          break
       end
     end
  end
  
  if splitTrack ~= null then
    --reaper.Main_OnCommand(40012,0)
    return
  end
  
  leftSide = nil
  rightSide = nil
  
  for i = 1,itemCount,1 do 
     item = reaper.GetMediaItem(0,i-1)
     track = reaper.GetMediaItemInfo_Value(item,'P_TRACK')
     
     if track==selectedTrack then 
       leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
       rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
       
       if leftPos==pos then
          leftSide = item
       end
       
       if rightPos==pos then
          rightSide = item
       end
     end
  end
  
  if leftSide ~=nil and rightSide ~= nil then
    reaper.Main_OnCommand(40769,0) --unselect everything
    reaper.SetMediaTrackInfo_Value(selectedTrack,'I_SELECTED',1)
    
    reaper.SetMediaItemInfo_Value(leftSide,'B_UISEL',1)
    reaper.SetMediaItemInfo_Value(rightSide,'B_UISEL',1)
    
    reaper.Main_OnCommand(40362,0) --glue ignoring time selection
  end
end

splitGlue()
