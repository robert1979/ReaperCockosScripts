
function itemSnap()
  local minimumDist = 9999
  local minimumPos = 9999
  is_new_value,filename,sectionID,cmdID,mode,resolution,val  = reaper.get_action_context()
  length = reaper.GetProjectLength()
  
  pos = (length/127) * val
  if length == 0 then
    pos = 30/127 * val
  end
  
  itemCount = reaper.CountMediaItems(0)
  
  if(length == 0) then
    do return end
  end
  
-- Media track snapping
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  if selectedTrack ~= nil then 
    selTrackNumber = reaper.GetMediaTrackInfo_Value(selectedTrack,'IP_TRACKNUMBER')
    selTrackItemCount = reaper.CountTrackMediaItems(selectedTrack)
    ignoreSelectedTrack = selectedTrack == nil or selTrackItemCount==0 
    
    selectedItem = nil
    
    for i = 1,itemCount,1 do 
       item = reaper.GetMediaItem(0,i-1)
       track = reaper.GetMediaItemInfo_Value(item,'P_TRACK')
       cTrackNumber = reaper.GetMediaTrackInfo_Value(track,'IP_TRACKNUMBER')
       
       if ignoreSelectedTrack or selTrackNumber == cTrackNumber then
       
         leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
         rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
         
         diffLeft = math.abs(leftPos-pos)
         diffRight = math.abs(rightPos-pos)
         
         if(diffLeft<=minimumDist) then 
          minimumPos = leftPos
          minimumDist = diffLeft
          selectedItem = item
         end
         
         if(diffRight<=minimumDist) then 
          minimumPos = rightPos
          minimumDist = diffRight
          selectedItem = item
         end
      end
    end
  end


-- Snap to marker
  count,markers,regions = reaper.CountProjectMarkers(0)
  if markers ~= nil then
    for i = 1,markers,1 do
      retval, isrgn, mpos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
      --reaper.ShowConsoleMsg(i .. "  " .. pos .. "\n")
      
      markerDiff = math.abs(mpos -pos)
      if markerDiff<= minimumDist then
        minimumDist = markerDiff
        minimumPos = mpos
      end
      
    end
  end

  
-- Highlight Media Items
  for i = 1,itemCount,1 do 
     item = reaper.GetMediaItem(0,i-1)
     reaper.SetMediaItemSelected(item,(item==selectedItem))
  end
  
  if minimumPos~=9999 then
    reaper.SetEditCurPos(minimumPos,true,false)
  end
end
