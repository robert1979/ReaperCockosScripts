

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

function sendMidi(dev,m1,m2,m3)
  reaper.StuffMIDIMessage(dev+16, m1, m2, m3)
end

function sendSys(message,dev)
  while math.fmod(#message,3)~=0 do
    local l = #message +1
    message[l]=0
  end
  
  for i=1,#message,3
  do
    sendMidi(dev,message[i],message[i+1],message[i+2])
  end
end

function deviceInquiry()
  local dev = getDevice('LPMiniMK3 MIDI In')
  sendSys({240,126,127,6,1,247},dev)
end

-- 00h (0): Session (only selectable in DAW mode)
-- 04h (4): Custom mode 1 (Drum Rack by factory default)
-- 05h (5): Custom mode 2 (Keys by factory default)
-- 06h (6): Custom mode 3 (Lighting mode in Drum Rack layout by factory default)
-- 0Dh (13): DAW Faders (only selectable in DAW mode)
-- 7Fh (127): Programmer mode

function layoutSelection(layout)
  local dev = getDevice('LPMiniMK3 MIDI In')
  sendSys({240,0,32,41,2,13,0,layout,247},dev)
end

--Where <mode> is 0 for Live mode, 1 for Programmer mode
function liveProgMode(mode,dev)
  sendSys({ 240 ,0 ,32 ,41 ,2 ,13 ,14,mode,247},dev)
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
  local msg_array ={}
  for i=1,cols,1 do
    msg_array[i] ={0,start_idx+i,0}
  end
  return msg_array
end

function flatten_array(array)
  local result = {}
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


function pressedShift()
  local section ="launchpad"
  local key = "shift"
  c_value = reaper.GetExtState(section,key)
  return c_value == 't' or c_value ==  nil
end

function getTimeSelectionActive()
  leftPos, rightPos = reaper.GetSet_LoopTimeRange(false,true,0,0,false)
  return createToggle(84,5,leftPos ~= rightPos)
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

function createToggle(led,col_on,flag)
  if not flag then
    return {0,led,0}
  else
    return {0,led,col_on}
  end
end

local device_id = -1

function setupButtons()
  if device_id == -1 then
    device_id = getDevice('LPMiniMK3 MIDI In')
    if device_id == -1 then do return end end
  end

  liveProgMode(0,device_id)
  liveProgMode(1,device_id)
  local setup_sysex = {}
  addLed(81,9,setup_sysex) -- loop start
  addLed(82,9,setup_sysex) -- loop end
  addLed(83,10,setup_sysex) -- loop select

  addLed(87,68,setup_sysex) -- undo
  addLed(88,69,setup_sysex) -- redo
  
  addLed(77,60,setup_sysex) -- region set
  addLed(78,53,setup_sysex) -- marker set
  
  addLed(66,94,setup_sysex) -- cut
  addLed(67,92,setup_sysex) -- copy
  addLed(68,93,setup_sysex) -- paste
  
  addLed(58,3,setup_sysex) -- action list
  
  addLed(75,65,setup_sysex) -- heal
  addLed(74,72,setup_sysex) -- slice
  
  addLed(89,14,setup_sysex) -- show floating fx windows for selected track
  
  -- windows sets
  addLed(95,33,setup_sysex)
  addLed(96,41,setup_sysex)
  addLed(97,49,setup_sysex)
  addLed(98,57,setup_sysex)
  
  local setup_msg = {}
  setup_msg[1] = sysl_head;
  setup_msg[2] = flatten_array(setup_sysex)
  setup_msg[3] = sysl_foot

  sendSys(flatten_array(setup_msg),device_id)
end

prev_s = {0,0,0,0,0,0,0,0}

function showTracks()

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
    
      local col =reaper.GetMediaTrackInfo_Value(track,'I_CUSTOMCOLOR')
      local r,g,b = reaper.ColorFromNative(col)
    
      local dim = 8
      mr = math.floor((col_to_midi(r))/dim)
      mg = math.floor((col_to_midi(g))/dim)
      mb = math.floor((col_to_midi(b))/dim)
      
      msg_armed[t+1] = {3,id_rec+t,mr,mg,mb}
      msg_solo[t+1] = {3,id_solo+t,mr,mg,mb}
      msg_mute[t+1] = {3,id_mute+t,mr,mg,mb}
      
    
      local sel =reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')
      if sel == 0 then
        msg_trks[t+1] = {3,id_trk+t,mr*dim,mg*dim,mb*dim}
      else
        msg_trks[t+1] = {1,id_trk+t,3,0}
      end
      
      soloed =reaper.GetMediaTrackInfo_Value(track,'I_SOLO')
      if soloed>=1 then
        msg_solo[t+1] = {sel*2,id_solo+t,9}
      end
      
      if reaper.GetMediaTrackInfo_Value(track,'B_MUTE')==1 then 
        msg_mute[t+1] = {sel*2,id_mute+t,37}
      end
      
      if armed == 1 then
        msg_armed[t+1] = {1,id_rec+t,5,0}
      end
      
    end
  end
  
  local has_selected_media = reaper.GetSelectedMediaItem(0,0)~=nil
  sys_msg ={}
  sys_msg[1] = sysl_head;
  sys_msg[2] = flatten_array(msg_armed)
  sys_msg[3] = flatten_array(msg_trks)
  sys_msg[4] = flatten_array(msg_solo)
  sys_msg[5] = flatten_array(msg_mute)
  sys_msg[6] = createToggle(19,38,pressedShift()) -- shift
  sys_msg[7] = getTimeSelectionActive()
  sys_msg[8] = createToggle(61,38,reaper.SNM_GetIntConfigVar("projmetroen", -666)&1==1) -- metronome
  sys_msg[9] = getTakesActive()
  sys_msg[10] = createToggle(62,17,reaper.SNM_GetIntConfigVar("preroll", 0)&1==1) -- pre-roll playback
  sys_msg[11] = createToggle(63,25,reaper.SNM_GetIntConfigVar("preroll", 0)&2==2) -- pre-roll record
  sys_msg[12] = createToggle(57,72,has_selected_media) -- pre-roll record
  sys_msg[13] = sysl_foot
  
  --log_array(final)
  sendSys(flatten_array(sys_msg),device_id)
end


local c =0

function midi_loop()
    local retval,  buf,  ts,  devIdx = reaper.MIDI_GetRecentInputEvent(0)
    local Buf_1 =  string.byte(buf,1)
    local Buf_2 =  string.byte(buf,2)
    local Buf_3 =  string.byte(buf,3)
    return Buf_1,Buf_2,Buf_3,ts,dev_idx
end

local section ="launchpad"
local key = "shift"

function pressedShift()
  c_value = reaper.GetExtState(section,key)
  return c_value == 't' or c_value ==  nil
end

function loop()
  
  b1,b2,b3,ts,dev_idx = midi_loop()
  if b2==19 then 
    if b3 == 0 then
      reaper.SetExtState(section,key,'f',false)
    else
      reaper.SetExtState(section,key,'t',false)
    end
  end

  c = c + 1
  if c == 5 then 
    showTracks()
    c=0
  end
  reaper.defer(loop)
end

setupButtons()
loop()
