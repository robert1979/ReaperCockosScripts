function msg(message)
  reaper.ShowConsoleMsg(message)
end


function Glue()
  local pos = reaper.GetCursorPosition()
  leftSide = nil
  rightSide = nil
  itemCount = reaper.CountMediaItems(0)
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  
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
    
    reaper.Main_OnCommand(42432,0) --glue ignoring time selection
  end
end

Glue()
