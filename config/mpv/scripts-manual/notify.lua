-- based on https://github.com/rohieb/mpv-notify
-- https://unix.stackexchange.com/a/455198/119298

function do_notify()
   local command = "bash ~/scripts/music/mpv-controller.sh notif"
   os.execute(command)
end

--function add_play()
--   local time_played = mp.get_property('playback-time')
--   local time_played_percent = mp.get_property('percent-pos')
--   
--   if (tonumber(time_played) > 300 or tonumber(time_played_percent) > 70) then
--      os.execute("echo $(date) $(sha1sum '" .. mp.get_property('path') .. "' | cut -d ' ' -f1) >> plays.txt")
--   end 
--end


-- mp.add_hook('on_load', 50, do_notify)
-- mp.add_hook('on_unload', 50, add_play)

mp.register_event("file-loaded", do_notify)
