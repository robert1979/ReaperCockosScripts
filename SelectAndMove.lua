
function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

function selectMove()
  
  reaper.SetCursorContext(1) -- FOCUS on arrange view
  local pos = reaper.GetCursorPosition()
  local itemCount = reaper.CountMediaItems(0)
  
  if(itemCount == 0) then
    do return end
  end
  
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  selectedItem = nil
  
  for i = 1,itemCount,1 do 
    local item = reaper.GetMediaItem(0,i-1)
    leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
    rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
    local track = reaper.GetMediaItem_Track(item)
    
    if( leftPos<=pos and rightPos>pos and track == selectedTrack) then
      selectedItem = item
    end
  end
  
  if selectedItem == reaper.GetSelectedMediaItem(0,0) then
    reaper.Main_OnCommand(reaper.NamedCommandLookup( '_XENAKIOS_MOVEITEMSTOEDITCURSOR'),0)
    do return end
  end
  
  
  if selectedItem ~= nil then
    itemCount = reaper.CountMediaItems(0)
    for i = 1,itemCount,1 do 
       item = reaper.GetMediaItem(0,i-1)
       reaper.SetMediaItemSelected(item,(item==selectedItem))
    end
  else
    selectedItemCount =0
    itemCount = reaper.CountMediaItems(0)
    for i = 1,itemCount,1 do 
       item = reaper.GetMediaItem(0,i-1)
       selectedItemCount = selectedItemCount+ reaper.GetMediaItemInfo_Value(item,'B_UISEL')
    end
    
    if selectedItemCount==1 then
      reaper.Main_OnCommand(reaper.NamedCommandLookup( '_XENAKIOS_MOVEITEMSTOEDITCURSOR'),0)
    end
  end

  reaper.UpdateArrange()
  

end


selectMove()
