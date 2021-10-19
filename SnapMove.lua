function sign(a)
  return a/-a
end

function snapToItems(minimumPos, minimumDist, dir)

  local pos = reaper.GetCursorPosition()
  local itemCount = reaper.CountMediaItems(0)
  if(itemCount == 0) then
    return minimumPos, minimumDist,nil
  end
  
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  if selectedTrack == nil then
    return minimumPos, minimumDist,nil
  end
  
  local selTrackNumber = reaper.GetMediaTrackInfo_Value(selectedTrack,'IP_TRACKNUMBER')
  local selTrackItemCount = reaper.CountTrackMediaItems(selectedTrack)
  local ignoreSelectedTrack = selectedTrack == nil or selTrackItemCount==0 
  
  local selectedItem = nil
  
  for i = 1,itemCount,1 do 
     local item = reaper.GetMediaItem(0,i-1)
     local track = reaper.GetMediaItemInfo_Value(item,'P_TRACK')
     cTrackNumber = reaper.GetMediaTrackInfo_Value(track,'IP_TRACKNUMBER')
     
      if ignoreSelectedTrack or selTrackNumber == cTrackNumber then
          leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
          rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
          
          local diffLeft = math.abs(leftPos-pos)
          local diffRight = math.abs(rightPos-pos)
          
          local lSide = leftPos<pos
          local rSide = rightPos<pos
          
          if(dir>0) then
            lSide = leftPos>pos
            rSide = rightPos>pos
          end

          if(diffLeft<=minimumDist and lSide ) then 
           minimumPos = leftPos
           minimumDist = diffLeft
           selectedItem = item
          end
          
          if(diffRight<=minimumDist and rSide ) then 
           minimumPos = rightPos
           minimumDist = diffRight
           selectedItem = item
          end

      end
  end
  return minimumPos, minimumDist,selectedItem
end

function snapToMarkers(minimumPos, minimumDist, dir)
  local pos = reaper.GetCursorPosition()
  
  local i = 0
  while true do
    local ret, isrgn, mpos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if ret == 0 then
      break
    end
    --if not isrgn then -- show only region data
      --reaper.ShowConsoleMsg("Pos: " .. mpos .. "\n" .. "End: " .. rgnend.. "\n" .. "Name: " .. name .. "\n\n")
      markerDiff = math.abs(mpos - pos)
      
      
      mSide = mpos<pos
      
      if(dir>0) then
        mSide = mpos>pos
      end
      
      if markerDiff< minimumDist and mSide then
        minimumDist = markerDiff
        minimumPos = mpos
      end
      
      if isrgn then
        markerDiff = math.abs(rgnend - pos)
        mSide = rgnend<pos
        
        if(dir>0) then
          mSide = rgnend>pos
        end
        
        if markerDiff< minimumDist and mSide then
          minimumDist = markerDiff
          minimumPos = rgnend
        end
      end

    i = i + 1
  end
  
  return minimumPos, minimumDist
end

function snapToSelection(minimumPos, minimumDist, dir)
  local pos = reaper.GetCursorPosition()
  leftPos, rightPos = reaper.GetSet_LoopTimeRange(false,true,0,0,false)
  
  if leftPos == rightPos == 0 then
    do return end
  end
  
  local diffLeft = math.abs(leftPos-pos)
  local diffRight = math.abs(rightPos-pos)
  
  local lSide = leftPos<pos
  local rSide = rightPos<pos
  
    if(dir>0) then
     lSide = leftPos>pos
     rSide = rightPos>pos
    end
    
    if(diffLeft<minimumDist and lSide ) then 
      minimumPos = leftPos
      minimumDist = diffLeft
    end
    
    if(diffRight<minimumDist and rSide ) then 
      minimumPos = rightPos
      minimumDist = diffRight
    end
   
  return minimumPos, minimumDist
end

function snapToStart(minimumPos, minimumDist, dir)
  local pos = reaper.GetCursorPosition()
  local diffLeft = math.abs(0-pos)
  local lSide = 0<pos
  
  if(dir>0) then
   lSide = 0>pos
  end
  
  if(diffLeft<minimumDist and lSide ) then 
    minimumPos = 0
    minimumDist = diffLeft
  end
  return minimumPos, minimumDist
end

function Move(dir)
  mPos = reaper.GetCursorPosition()
  local mDist = 9999
  selectedItem =nil
  
  mPos, mDist =  snapToStart(mPos,mDist,dir)
  mPos, mDist =  snapToSelection(mPos,mDist,dir)
  mPos, mDist =  snapToMarkers(mPos,mDist,dir)
  mPos, mDist,selectedItem =  snapToItems(mPos,mDist,dir)
  reaper.SetEditCurPos(mPos,true,false)
  

    itemCount = reaper.CountMediaItems(0)
    for i = 1,itemCount,1 do 
       item = reaper.GetMediaItem(0,i-1)
       reaper.SetMediaItemSelected(item,(item==selectedItem))
    end
end

