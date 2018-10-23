function s:findRoot()
	let result = system('git rev-parse --show-toplevel')
	if v:shell_error == 0
		return substitute(result, '\n*$', '', 'g')
	endif

	return "."
endfunction

function s:collect(...)
	let root = getcwd()
	if has('nvim')
		let path = getline(1)
	else
		let path = term_getline(b:term_buf, 1)
	endif

	silent close

	if filereadable(path)
		execute 'edit '.root.'/'.path
	endif
endfunction

let s:OnExit = function('s:collect')

function! fzf#Open()
	keepalt below 9 new

	let root = s:findRoot()
	if root != '.'
		execute 'lcd '.root
	endif

	if has('nvim')
		let options = {'on_exit': s:OnExit}
		call termopen('fzf', options)
		startinsert
	else
		let options = {'term_name':'FZF','curwin':1,'exit_cb':s:OnExit}
		let b:term_buf = term_start('fzf', options)
	endif
endfunction
