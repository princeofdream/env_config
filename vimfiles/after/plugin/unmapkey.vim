if exists(":nmap <C-d>")
    nunmap <C-d>
elseif has_key(g:plugs, 'accelerated-smooth-scroll')
    nunmap <C-d>
endif
if exists(":nmap <LocalLeader>cb")
    unmap <LocalLeader>cb
elseif has_key(g:plugs, 'nerdcommenter')
    unmap <LocalLeader>cb
endif













































