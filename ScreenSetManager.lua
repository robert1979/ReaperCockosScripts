
function msg(s)
  reaper.ShowConsoleMsg(s)
end


function loadStoredScreenSet()
  loadedSet =  reaper.GetExtState('sset','ls')
  if loadedSet == nil then
    loadScreenSet(1)
  else
    loadScreenSet(tonumber(loadedSet))
  end
  screenSetLoop()
end

function showOnlySelectedTrackInMixer()
  reaper.SNM_SetIntConfigVar('mixeruiflag',15)

  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWSTL_SHOWMCPEX'),0)
  
  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateTimeline()
end


function loadScreenSet(id)
  reaper.SetExtState('sset','ls', id, true)
  if id == '1' then
    reaper.Main_OnCommand(40454,0)
    showOnlySelectedTrackInMixer()
  elseif id == '2' then
    reaper.Main_OnCommand(40455,0)
    reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWSTL_SHOWALLMCP'),0)
  elseif id == '3' then
    reaper.Main_OnCommand(40456,0)
  elseif id == '4' then
    reaper.Main_OnCommand(40457,0)
  end
end

local selected_trk
local prev_id

function screenSetLoop()
  s = reaper.GetExtState('sset','ls')
  if s~=prev_id then
    loadScreenSet(s)
    prev_id = s
  end
  
  if s=='1' then
    c_trk = reaper.GetSelectedTrack(0,0)
    if c_trk~=selected_trk and c_trk~=nil then
      showOnlySelectedTrackInMixer()
      selected_trk = c_trk
    end
  end
  
  reaper.defer(screenSetLoop)
end

loadStoredScreenSet()


