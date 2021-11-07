function msg(s)
  reaper.ShowConsoleMsg(s .. '\n')
end


if not reaper.HasExtState('lp','pgs')then
  do return end
end
  
pages =  tonumber( reaper.GetExtState('lp','pgs'))

if reaper.HasExtState('lp','cpg')then
  cpage =  reaper.GetExtState('lp','cpg')
else
  cpage = 0
end

cpage = cpage +1
if cpage>=pages then cpage = 0 end

reaper.SetExtState('lp','cpg',cpage,false)

