-- based on https://github.com/rohieb/mpv-notify
-- https://unix.stackexchange.com/a/455198/119298
-- Modified by k-vernooy

function do_notify()
   local command = "bash /home/kai/scripts/music/mpv-controller.sh info"
   os.execute(command)
end

mp.register_event("file-loaded", do_notify)
