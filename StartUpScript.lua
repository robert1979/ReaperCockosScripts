dofile (reaper.GetResourcePath()..'/Scripts/MyScripts/LaunchPadControl.lua')


--showTracks()
local starttime=os.time()
local lasttime=starttime
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

reaper.ShowMessageBox('StartUp','Action StartUp',0)
setupButtons()
loop()
