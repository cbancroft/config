function _G.reload_config()
	for name, _ in pairs(package.loaded) do
		if name:match('^config') or name:match('^plugins') then
			print('Clearing ' .. name )
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
	vim.notify('Nvim configuration reloaded', vim.log.levels.INFO)
end

