local function msg(str)
  reaper.ShowConsoleMsg(tostring(str).."\n")
end

function mixBus()
  local r = reaper
  r.Undo_BeginBlock()
  
  local selected_trks = r.CountSelectedTracks(0)
  
  if selected_trks<=1 then do return end end
  
  local bus = r.GetSelectedTrack(0,0)
  if bus == nil then do return end end
  
  
  bus_col = reaper.GetMediaTrackInfo_Value(bus,'I_CUSTOMCOLOR')
  
  trk_count = r.CountTracks(0)
  
  for i=0,trk_count-1 do
    local c_trk = r.GetTrack(0,i)
    if r.GetMediaTrackInfo_Value(c_trk,'I_SELECTED')==1 and c_trk~=bus then
      r.SetMediaTrackInfo_Value(c_trk, "B_MAINSEND", 0) -- disable main
      r.SetMediaTrackInfo_Value(c_trk, "I_CUSTOMCOLOR", bus_col)
      
      local trk_send_count = r.GetTrackNumSends(c_trk,0)
      local already_sending=false
      
      for u = 0, trk_send_count-1 do
      
        reaper.RemoveTrackSend(c_trk,0,u)
        --[[if r.BR_GetMediaTrackSendInfo_Track(c_trk,0,u,1) == bus then 
          already_sending= true 
        end]]--
      end
      
      if not already_sending then
        local send = r.CreateTrackSend(c_trk, bus)
        r.SetTrackSendInfo_Value(c_trk, 0, send, "D_VOL", 1)
        r.SetTrackSendInfo_Value(c_trk, 0, send, "I_SENDMODE", 0)  
      end
    end
  end
  
  r.PreventUIRefresh( -1 )
  r.TrackList_AdjustWindows( false )
  r.UpdateArrange()
  r.Undo_EndBlock("Create mix bus and route all selected tracks to it", 0)
end

mixBus()
