" @Author: voldikss
" @Date: 2019-04-28 13:32:21
" @Last Modified by: voldikss
" @Last Modified time: 2019-06-20 18:57:36

function! s:check_job() abort
  if exists('*jobstart') || exists('*job_start')
    call v:lua.vim.health.ok('Async check passed')
  else
    call v:lua.vim.health.error('Job feature is required but not found')
  endif
endfunction

function! s:check_floating_window() abort
  " nvim, but doesn't have floating window
  if !exists('*nvim_open_win')
    call v:lua.vim.health.error(
      \ 'Floating window is missed on the current version Nvim',
      \ 'Upgrade your Nvim")'
      \ )
    return
  endif

  " has floating window, but different parameters(old version)
  try
    let test_win = nvim_open_win(bufnr('%'), v:false, {
      \ 'relative': 'editor',
      \ 'row': 0,
      \ 'col': 0,
      \ 'width': 1,
      \ 'height': 1,
      \ })
    call nvim_win_close(test_win, v:true)
  catch /^Vim\%((\a\+)\)\=:E119/
    call v:lua.vim.health.error(
      \ 'The newest floating window feature is missed on the current version Nvim',
      \ 'Upgrade your Nvim")'
      \ )
    return
  endtry
  call v:lua.vim.health.ok('Floating window check passed')
endfunction

function! s:check_python() abort
  if exists('g:python3_host_prog') && executable('g:python3_host_prog')
    let translator_python_host = g:python3_host_prog
  elseif executable('python3')
    let translator_python_host = 'python3'
  elseif executable('python')
    let translator_python_host = 'python'
  else
    call v:lua.vim.health.error('Python is required but not executable: ' . translator_python_host)
    return
  endif
  call v:lua.vim.health.ok('Using '.translator_python_host)
endfunction

function! health#translator#check() abort
  call s:check_job()
  call s:check_floating_window()
  call s:check_python()
endfunction
