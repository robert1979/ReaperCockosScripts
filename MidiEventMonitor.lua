function print(val)
    reaper.ShowConsoleMsg(tostring(val)..'\n')
end

function midi_loop()
    local retval,  buf,  ts,  devIdx = reaper.MIDI_GetRecentInputEvent(0)
    Buf_1 =  string.byte(buf,1)
    Buf_2 =  string.byte(buf,2)
    Buf_3 =  string.byte(buf,3)
end

local ctx = reaper.ImGui_CreateContext('My scripts')

function loop()
   reaper.ImGui_SetNextWindowSize(ctx, 400, 80, reaper.ImGui_Cond_FirstUseEver())
  local visible, open = reaper.ImGui_Begin(ctx, 'My window', true)
  if visible then
    midi_loop()
    reaper.ImGui_Text(ctx, 'Status Byte  '..Buf_1)
    reaper.ImGui_Text(ctx, 'Data Byte 1  '..Buf_2)
    reaper.ImGui_Text(ctx, 'Data Byte 2  '..Buf_3)
    reaper.ImGui_End(ctx)
  end
  
  if open then
    reaper.defer(loop)
  else
    reaper.ImGui_DestroyContext(ctx)
  end
end

reaper.defer(loop)
