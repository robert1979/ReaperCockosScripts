
--8 = Note Off 
--9 = Note On 
--10 = AfterTouch (ie, key pressure) 
--11 = Control Change 
--12 = Program (patch) change 
--13 = Channel Pressure 
--14 = Pitch Wheel


function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

function getDevice(target_device)
  local mdev_outno = reaper.GetNumMIDIOutputs() -- grab number of midi outputs in Reaper
  local i,k, target_devnum = 0 , 0,-1

  for i=1, mdev_outno, 1 do
    retval, mdev_name = reaper.GetMIDIOutputName(i, "")
    if retval then
      --msg(mdev_name)
      if string.find(mdev_name,target_device) then
        --msg(tostring(retval) .. ' ' .. mdev_name)
        target_devnum = i
      end
    end
  end
  return target_devnum
end

prgChangeCode = 12

function sendProgramChange(devnum, prg, midichan)
  --msg('sending..' .. prg)
  reaper.StuffMIDIMessage(devnum+16,
                           prgChangeCode*16, -- NoteOn
                            tonumber(prg-1), -- MIDI note (bank-1 for MidiFighterTwister)
                            1)  -- MIDI velocity
                            -- later we'll add a command execution list
end

local starttime=os.time()
local lasttime=starttime
local c =0
local lastSelectedTrack = nil
FXNAME = 'JS: Kemper Program Select'

--[[reaper.ShowMessageBox('Kemper midi track selection started','Action StartUp',0)
    
function wait_for_playback()

  local newtime=os.time()
    newTrack = reaper.GetSelectedTrack(0,0)
    if newTrack~=lastSelectedTrack and newTrack~=nil then
      lastSelectedTrack = newTrack
      
      fx_cnt =reaper.TrackFX_GetCount(newTrack)
      for i=0,fx_cnt-1,1 do
        retval, buf = reaper.TrackFX_GetFXName(newTrack,i)
        if string.match(buf, FXNAME) then
          r, param_name = reaper.TrackFX_GetParamName(newTrack,i,0)
          r, min,max = reaper.TrackFX_GetParam(newTrack,i,0)
          devnum = getDevice("Scarlett")
          sendProgramChange(devnum,math.floor(r),0)
          --msg(r .. '  ' .. devnum .. '\n')
        end
      end
    end
  reaper.defer(wait_for_playback)
end]]--

u = reaper.SNM_GetIntConfigVar("preroll", 0)&2
msg(u)
