

function print(val)
    reaper.ShowConsoleMsg(val..'\n')
end

function midi_loop()
    local retval,  buf,  ts,  devIdx = reaper.MIDI_GetRecentInputEvent(0)
    local Buf_1 =  string.byte(buf,1)
    local Buf_2 =  string.byte(buf,2)
    local Buf_3 =  string.byte(buf,3)
    return Buf_1,Buf_2,Buf_3,ts,dev_idx
end


local prev_vel =0

local trk_sel = {11,12,13,14,15,16,17,18}
local trk_arm = {21,22,23,24,25,26,27,28}
local trk_sol = {31,32,33,34,35,36,37,38}
local trk_mut = {41,42,43,44,45,46,47,48}

function validate(note,data)
  for i=1,#data do
   --print(note .. ' ' .. data[i])
    if note == data[i] then 
      return true 
    end
  end
  return false
end

function get_track_value(note,offset,param)
  trk_idx = note-offset
  local track = reaper.GetTrack(0,trk_idx)
  if track ~=nil then
    val = reaper.GetMediaTrackInfo_Value(track,param)
    if val == 0 then val = 1 else val = 0 end
    --print ('sel' .. val)
    reaper.SetMediaTrackInfo_Value(track,param,val)
  end
  return -1,nil
end

function process_trk_sel(note)
  result = validate(note,trk_sel)
  if result then
    val, trk = get_track_value(note,11,'I_SELECTED')
  end
  return result
end

function process_trk_arm(note)
  result = validate(note,trk_arm)
  if result then
    val, trk = get_track_value(note,21,'I_RECARM')
  end
  return result
end

function process_trk_sol(note)
  result = validate(note,trk_sol)
  if result then
    val, trk = get_track_value(note,31,'I_SOLO')
  end
  return result
end

function process_trk_mut(note)
  result = validate(note,trk_mut)
  if result then
    val, trk = get_track_value(note,41,'B_MUTE')
  end
  return result
end


function loop()
  b1,b2,b3,ts, dev_idx = midi_loop()
  
  if b3~=prev_vel  then
    if b3 == 127 then
      local was_processed = false
      if not was_processed then was_processed = process_trk_sel(b2) end
      if not was_processed then was_processed = process_trk_arm(b2) end
      if not was_processed then was_processed = process_trk_sol(b2) end
      if not was_processed then was_processed = process_trk_mut(b2) end
    end
    prev_vel = b3
  end
  reaper.defer(loop)
end
loop()

