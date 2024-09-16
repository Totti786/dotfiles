-- reset_pos_on_next.lua
local last_file = ""

local function on_file_loaded()
    local current_file = mp.get_property("filename")
    local playlist_pos = mp.get_property_number("playlist-pos")

    if playlist_pos and playlist_pos > 0 and last_file ~= current_file then
        mp.set_property("time-pos", 0)
    end

    last_file = current_file
end

mp.register_event("file-loaded", on_file_loaded)
