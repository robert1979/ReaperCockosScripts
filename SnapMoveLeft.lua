
function sign(a)
  return a/-a
end

function snapToItems(minimumPos, minimumDist, dir)

  pos = reaper.GetCursorPosition()
  itemCount = reaper.CountMediaItems(0)
  if(itemCount == 0) then
    return minPosition, minimumDist,nil
  end
  
  selectedTrack = reaper.GetSelectedTrack(0, 0)
  if selectedTrack == nil then
    return minPosition, minimumDist,nil
  end
  
  selTrackNumber = reaper.GetMediaTrackInfo_Value(selectedTrack,'IP_TRACKNUMBER')
  selTrackItemCount = reaper.CountTrackMediaItems(selectedTrack)
  ignoreSelectedTrack = selectedTrack == nil or selTrackItemCount==0 
  
  selectedItem = nil
  --reaper.ShowConsoleMsg(itemCount .. '\n')
  
  for i = 1,itemCount,1 do 
     item = reaper.GetMediaItem(0,i-1)
     track = reaper.GetMediaItemInfo_Value(item,'P_TRACK')
     cTrackNumber = reaper.GetMediaTrackInfo_Value(track,'IP_TRACKNUMBER')
     
      if ignoreSelectedTrack or selTrackNumber == cTrackNumber then
          leftPos = reaper.GetMediaItemInfo_Value(item,'D_POSITION')
          rightPos = reaper.GetMediaItemInfo_Value(item,'D_LENGTH') + leftPos
          
          diffLeft = math.abs(leftPos-pos)
          diffRight = math.abs(rightPos-pos)
          
          lSide = leftPos<pos
          rSide = rightPos<pos
          
          if(dir>0) then
            lSide = leftPos>pos
            rSide = rightPos>pos
          end

          if(diffLeft<minimumDist and lSide ) then 
           minimumPos = leftPos
           minimumDist = diffLeft
           selectedItem = item
          end
          
          if(diffRight<minimumDist and rSide ) then 
           minimumPos = rightPos
           minimumDist = diffRight
           selectedItem = item
          end

          
      end
  end
  return minimumPos, minimumDist,selectedItem
end

function snapToMarkers(minimumPos, minimumDist, dir)
  pos = reaper.GetCursorPosition()
  
  local i = 0
  reaper.ShowConsoleMsg("")
  while true do
    local ret, isrgn, mpos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if ret == 0 then
      break
    end
    --if not isrgn then -- show only region data
      reaper.ShowConsoleMsg("Pos: " .. mpos .. "\n" .. "End: " .. rgnend.. "\n" .. "Name: " .. name .. "\n\n")
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
      
      
    --end
    i = i + 1
  end
  
  return minimumPos, minimumDist
end


function Main()
  local mPos = reaper.GetCursorPosition()
  local mDist = 9999
  local selectedItem =nil
  
  mPos, mDist,selectedItem =  snapToMarkers(mPos,mDist,-1)
  mPos, mDist,selectedItem =  snapToItems(mPos,mDist,-1)
  reaper.SetEditCurPos(mPos,true,false)
end

Main()
