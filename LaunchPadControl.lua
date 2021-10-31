

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


function col_to_midi(c)
  return math.floor(c/255 * 127)
end

local sysl_head ={240, 0, 32, 41, 2 ,13, 3}
local sysl_foot = {247}
local id_trk,id_rec,id_solo,id_mute = 11,21,31,41


function addLed(id,col,sysex)
  c = #sysex + 1
  sysex[c] = {0,id,col}
end

function setupButtons()
  liveProgMode(0)
  liveProgMode(1)
  local sysex = {}
  addLed(81,9,sysex) -- loop start
  addLed(82,9,sysex) -- loop end
  addLed(83,10,sysex) -- loop select

  addLed(87,68,sysex) -- undo
  addLed(88,69,sysex) -- redo
  
  addLed(77,60,sysex) -- region set
  addLed(78,53,sysex) -- marker set
  
  addLed(66,94,sysex) -- cut
  addLed(67,92,sysex) -- copy
  addLed(68,93,sysex) -- paste
  
  addLed(57,72,sysex) -- delete
  addLed(58,3,sysex) -- action list
  
  addLed(74,72,sysex) -- slice
  addLed(75,65,sysex) -- heal
  
  local sys_msg = {}
  sys_msg[1] = sysl_head;
  sys_msg[2] = flatten_array(sysex)
  sys_msg[3] = sysl_foot
  local final = flatten_array(sys_msg)
  --log_array(final)
  sendSys(final)
end


function pressedShift()
  local section ="launchpad"
  local key = "shift"
  c_value = reaper.GetExtState(section,key)
  return c_value == 't' or c_value ==  nil
end

function getShiftState()
  if pressedShift() then
    return {0,19,0}
  else
    return {0,19,38}
  end
end

function getMetronomeState()
  if reaper.SNM_GetIntConfigVar("projmetroen", -666)&1==0 then
    return {0,61,0}
  else
    return {0,61,38}
  end
end

function getTimeSelectionActive()
  leftPos, rightPos = reaper.GetSet_LoopTimeRange(false,true,0,0,false)
  if leftPos == rightPos then
    return {0,84,0}
  else
    return {0,84,5}
  end
end

function getTakesActive()
  local takesOn = {0,71,16,0,72,16,0,73,17}
  local takesOff = {0,71,0,0,72,0,0,73,0}
  
  local mediaItem = reaper.GetSelectedMediaItem(0,0)
  if mediaItem == nil then
    return takesOff
  else
    take_count = reaper.GetMediaItemNumTakes(mediaItem)
    if take_count >1 then
      return takesOn
    else
      return takesOff
    end
  end
end

function showTracks()
  liveProgMode(1)
  local track_count = reaper.CountTracks(0)
  if track_count == 0 then do return end end
  
  local msg_trks =get_empty_row(id_trk,8)
  local msg_armed =get_empty_row(id_rec,8)
  local msg_solo =get_empty_row(id_solo,8)
  local msg_mute =get_empty_row(id_mute,8)
  
  
  for t =0,track_count-1,1 do
    local track = reaper.GetTrack(0,t)
    local armed =reaper.GetMediaTrackInfo_Value(track,'I_RECARM')
    if t<#msg_armed then
    
      col =reaper.GetMediaTrackInfo_Value(track,'I_CUSTOMCOLOR')
      r,g,b = reaper.ColorFromNative(col)
    
      sel =reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')
      --msg_trks[t+1] = {sel*2,11+t,22+(sel*2)}
      if sel == 0 then
        msg_trks[t+1] = {3,id_trk+t,col_to_midi(r),col_to_midi(g),col_to_midi(b)}
      else
        msg_trks[t+1] = {1,id_trk+t,3,0}
      end
      
      soloed =reaper.GetMediaTrackInfo_Value(track,'I_SOLO')
      if soloed>1 then soloed =1 end
      
      msg_solo[t+1] = {sel*2,id_solo+t,9 * soloed}
      
      muted = 0
      if reaper.GetMediaTrackInfo_Value(track,'B_MUTE')==1 then muted =1 end
      msg_mute[t+1] = {sel*2,id_mute+t,37 * muted}
      
     
      if armed == 1 then
        msg_armed[t+1] = {sel*2,id_rec+t,5}
      end
    end
    --msg(armed)
  end
  
  local sys_msg = {}
  sys_msg[1] = sysl_head;
  sys_msg[2] = flatten_array(msg_armed)
  sys_msg[3] = flatten_array(msg_trks)
  sys_msg[4] = flatten_array(msg_solo)
  sys_msg[5] = flatten_array(msg_mute)
  sys_msg[6] = getShiftState()
  sys_msg[7] = getTimeSelectionActive()
  sys_msg[8] = getMetronomeState()
  sys_msg[9] = getTakesActive()
  
  
  sys_msg[10] = sysl_foot
  
  --log_array(final)
  sendSys(flatten_array(sys_msg))
end

