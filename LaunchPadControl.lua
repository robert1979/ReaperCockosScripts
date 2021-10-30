

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
        msg(tostring(retval) .. ' ' .. mdev_name)
        target_devnum = i
      end
    end
  end
  return target_devnum
end

function lshift(x, by)
  return x * 2 ^ by
end

function rshift(x, by)
  return math.floor(x / 2 ^ by)
end

function sendMidi(devnum,m1,m2,m3)
  reaper.StuffMIDIMessage(devnum+16,
                         m1, -- NoteOn
                          m2, -- MIDI note (bank-1 for MidiFighterTwister)
                          m3)  -- MIDI velocity
                          -- later we'll add a command execution list
end



function sendSys(message)
  dev = getDevice('LPMiniMK3 MIDI In')
  
  while math.fmod(#message,3)~=0 do
    l = #message +1
    message[l]=0
  end
  
  for i=1,#message,3
  do
    sendMidi(dev,message[i],message[i+1],message[i+2])
  end
end

function deviceInquiry()
  dev = getDevice('LPMiniMK3 MIDI In')
  sendSys({240,126,127,6,1,247})
end

-- 00h (0): Session (only selectable in DAW mode)
-- 04h (4): Custom mode 1 (Drum Rack by factory default)
-- 05h (5): Custom mode 2 (Keys by factory default)
-- 06h (6): Custom mode 3 (Lighting mode in Drum Rack layout by factory default)
-- 0Dh (13): DAW Faders (only selectable in DAW mode)
-- 7Fh (127): Programmer mode

function layoutSelection(layout)
  dev = getDevice('LPMiniMK3 MIDI In')
  sendSys({240,0,32,41,2,13,0,layout,247})
end

--Where <mode> is 0 for Live mode, 1 for Programmer mode
function liveProgMode(mode)
  dev = getDevice('LPMiniMK3 MIDI In')
  sendSys({ 240 ,0 ,32 ,41 ,2 ,13 ,14,mode,247})
end

function log_multi_array(message)

  for i=1,#message,1 do
    msg(message[i][1] .. ' ' .. message[i][2] .. ' ' .. message[i][3])
  end
end

function log_array(array)
  for i=1,#array,1 do
    reaper.ShowConsoleMsg(tostring(array[i]) .. ' ')
  end
  reaper.ShowConsoleMsg('\n')
end

function get_empty_row(start_idx,cols)
  start_idx = start_idx-1
  msg_array ={}
  for i=1,cols,1 do
    msg_array[i] ={0,start_idx+i,0}
  end
  
  for i=1,cols,1 do
    msg_array[i] ={0,start_idx+i,0}
  end
  return msg_array
end

function flatten_array(array)
  result = {}
  c = 1
  for i =1,#array,1 do
    for u =1,#array[i] do
      result[c] = array[i][u]
      c = c + 1
    end
  end
  return result
end


local sysl_head ={240, 0, 32, 41, 2 ,13, 3}
local sysl_foot = {247}


function showTracks()
  liveProgMode(0)
  liveProgMode(1)
  reaper.ClearConsole()
  track_count = reaper.CountTracks(0)
  if track_count == 0 then do return end end
  
  local msg_array =get_empty_row(21,8)
  
  
  for t =0,track_count-1,1 do
    track = reaper.GetTrack(0,t)
    armed =reaper.GetMediaTrackInfo_Value(track,'I_RECARM')
    if armed == 1 and t<#msg_array then
      msg_array[t+1] = {0,21+t,5}
    end
    --msg(armed)
  end
  
  sys_msg = {}
  sys_msg[1] = sysl_head;
  sys_msg[2] = flatten_array(msg_array)
  sys_msg[3] = sysl_foot
  
  final = flatten_array(sys_msg)
  
  log_array(final)
  sendSys(final)
end

showTracks()

--[[sendSys({240, 0, 32, 41, 2 ,13, 3, 
0, 11, 5, 
2 ,12 ,12, 
2, 15, 13,
2, 17, 13,
247})]]--
