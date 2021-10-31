

note_on = '0x9'
note_off = '0x8'

function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

function getDevice(target_device)
  local mdev_outno = reaper.GetNumMIDIOutputs() -- grab number of midi outputs in Reaper
  local i,k, target_devnum = 0 , 0,-1

  for i=1, mdev_outno, 1 do
    retval, mdev_name = reaper.GetMIDIOutputName(i, "")
    if retval then
      msg(mdev_name)
      if string.find(mdev_name,target_device) then
        msg(tostring(retval) .. ' ' .. mdev_name)
        target_devnum = i
      end
    end
  end
  return target_devnum
end

local midichan = 1
local mftbank = 1 -- Midifighter Twister Bank
local vel = 45
devnum = getDevice("Scarlett")

msg(devnum)
reaper.StuffMIDIMessage(devnum+16,
                         '0x9'..string.format("%x", midichan-1), -- NoteOn
                          71, -- MIDI note (bank-1 for MidiFighterTwister)
                          vel)  -- MIDI velocity
                          -- later we'll add a command execution list
                          
reaper.StuffMIDIMessage(devnum+16,
                         '0x9'..string.format("%x", midichan-1), -- NoteOn
                          71, -- MIDI note (bank-1 for MidiFighterTwister)
                          vel)  -- MIDI velocity
                          -- later we'll add a command execution list
retval, mdev_name = reaper.GetMIDIOutputName(devnum, "")
msg("Sent note to " .. mdev_name)


