function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end

local section ="launchpad"
local key = "shift"
is_new_value, filename,sectionID,cmdID,mode, resolution, val = reaper.get_action_context()

msg(val .. '  ' .. mode .. ' ' .. tostring(is_new_value))

c_value = reaper.GetExtState(section,key)

if c_value == nil then c_value = 'f' end

if c_value == 'f' then c_value = 't' else c_value = 'f' end
reaper.SetExtState(section,key,c_value,false)
reaper.ShowConsoleMsg(c_value)
