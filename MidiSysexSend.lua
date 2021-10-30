function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

function sendSysex(message)

    name = ''
    found = false
    mt=reaper.GetMasterTrack(0)
    fx_count = reaper.TrackFX_GetCount(mt)
    fx_id=0x1000000 --first slot of monitor fx (0x1000000 + 1 for second slot etc..)
    
    retval, buf = reaper.TrackFX_GetFXName(mt, fx_id,"")
    
    if not retval then
      reaper.ShowMessageBox('Error','Make sure you add \'Send sysex to KPA\' in the first slot of the monitor fx',0)
      do return end
    end
    
    v = reaper.TrackFX_GetByName(mt,buf,false)
    msg(buf) -- print out the name of the fx , just to make sure
    
    retval , buf = reaper.TrackFX_GetParamName(mt,fx_id,0)
    msg(buf .. ' ' .. tostring(retval) .. '  ' .. v)
    
    for i=1,#message,1 do
      reaper.TrackFX_SetParam(mt,fx_id,0,message[i])
    end
end

message = {240,10,16,0,0,32,51,247}
sendSysex(message)
