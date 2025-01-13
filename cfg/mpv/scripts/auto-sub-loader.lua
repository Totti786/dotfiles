local msg = require 'mp.msg'
local utils = require 'mp.utils'

local sub_dir = 'Subs'
local sub_langs = {'English', 'Arabic', 'German', 'French', 'Spanish'}

function find_and_add()
	local path = mp.get_property('path', '')
	local dir, fn = utils.split_path(path)
	local sd = utils.join_path(dir, sub_dir)
	local selected = false

	local list = utils.readdir(sd, 'files')
	if not list then
		return
	end
	if #list == 0 then
		local fn_no_ext = mp.get_property('filename/no-ext')
		sd = utils.join_path(sd, fn_no_ext)
		list = utils.readdir(sd, 'files')
		if not list or #list == 0 then
			return
		end
	end

	table.sort(list)
	for lang_id = 1,#sub_langs do
		local lang_lower = string.lower(sub_langs[lang_id])
		for file_id = 1,#list do
			if string.find(string.lower(list[file_id]), lang_lower) then
				local flags = 'auto'
				if not selected then
					flags = 'select'
					selected = true
				end
				mp.commandv('sub-add', utils.join_path(sd, list[file_id]), flags, list[file_id], string.sub(string.lower(sub_langs[lang_id]), 1, 3))
			end
		end
	end
end

mp.register_event('file-loaded', find_and_add)
