function msg(message)
  reaper.ShowConsoleMsg(message)
end

function selectTake(dir)
  local sm = reaper.GetSelectedMediaItem(0,0)
  if sm == nil then
    do return end
  end 
  
  take_count = reaper.GetMediaItemNumTakes(sm)
  
  c_take = reaper.GetMediaItemInfo_Value(sm, "I_CURTAKE")
  next_take = c_take + dir
  
  if next_take == take_count then
    next_take = 0
  end
  
  if next_take < 0 then
    next_take = take_count-1
  end
  reaper.SetMediaItemInfo_Value(sm, "I_CURTAKE", next_take)
  reaper.UpdateArrange()
end
