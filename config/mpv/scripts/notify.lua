-- based on https://github.com/rohieb/mpv-notify
-- https://unix.stackexchange.com/a/455198/119298
-- Modified by k-vernooy

lastcommand = nil
function string.shellescape(str)
   return "'"..string.gsub(str, "'", "'\"'\"'").."'"
end
function do_notify(a)
   if string.len(a) > 45 then
       a = string.sub(a, 0, 45).."..."
   end
   local command = ("notify-send -a Music -u low -i gnome-music -- %s"):format(a:shellescape()) 
   if command ~= lastcommand then
      os.execute(command)
      lastcommand = command
   end
end
function notify_current_track()
   data = mp.get_property_native("metadata")
   if data then
      local title = (data["TITLE"] or data["title"] or " ")
      if title~=" " then
         do_notify(title)
         return
      end
   end
   local data = mp.get_property("path")
   if data then
      local file = data:gsub("^.-([^/]+)$","%1")
      file = file:gsub("%....$","")
      do_notify(file)
   end
end

mp.register_event("file-loaded", notify_current_track)
