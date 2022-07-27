lua << EOF
require("plugins")
require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true
    } 
}

base16 = require("base16")
theme_names = base16.theme_names()
base16_position = 1

function cycle_theme_next()
  base16_position = (base16_position % #theme_names) + 1
  print(theme_names[base16_position])
  base16(base16.themes[theme_names[base16_position]], true)
end

function cycle_theme_prev()
  base16_position = (base16_position % #theme_names) - 1
  print(theme_names[base16_position])
  base16(base16.themes[theme_names[base16_position]], true)
end

-- require('neoscroll').setup()
require('nvim-autopairs').setup()
require('telescope').setup{
}
require('telescope').load_extension('zoxide')
vim.api.nvim_set_keymap(
	"n",
	"<leader>cd",
	":lua require'telescope'.extensions.zoxide.list{}<CR>",
	{noremap = true, silent = true}
)

require'lspinstall'.setup() -- important

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap('n', '<space>c', '<cmd>lua vim.lsp.diagnostic.clear(vim.call("bufnr"))<CR>', opts)
  
end

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
--    require'lspconfig'[server].setup{ on_attach = on_attach }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

require('kommentary.config').use_extended_mappings()

local true_zen = require("true-zen")

true_zen.setup({
    ui = {
        top = {
           showtabline = 0 
        }
    },
    modes = {
        ataraxis = {
            left_padding = 2,
            right_padding = 2,
            top_padding = 1,
            bottom_padding = 1,
            ideal_writing_area_width = 0,
            just_do_it_for_me = true,
            keep_default_fold_fillchars = true,
            custome_bg = "",
            bg_configuration = true,
            affected_higroups = {NonText = {}, FoldColumn = {}, ColorColumn = {}, VertSplit = {}, StatusLine = {}, StatusLineNC = {}, SignColumn = {}}
        }
    }
})
EOF

let g:nvim_tree_disable_window_picker = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_auto_close = 1
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_width = 40
let g:nvim_tree_show_icons = {
\ 'git': 1,
\ 'folders': 1,
\ 'files': 1,
\ 'folder_arrows': 0,
\ }

lua << EOF
require('nvim-tree').setup {}
EOF

"map ,tn <Cmd>lua cycle_theme_next()<cr>
"map ,tp <Cmd>lua cycle_theme_prev()<cr>
"map , <Cmd>lua cycle_theme()<CR>
colorscheme base16-default-dark
colorscheme onedark
set termguicolors
set noswapfile
set hlsearch
set ignorecase
set hidden
set incsearch
set expandtab
set tabstop=4
set shiftwidth=4  
let mapleader=";"
set number
set foldlevel=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
" map s <Plug>(easymotion-overwin-f)
nnoremap <space> <Plug>(easymotion-prefix)
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
nnoremap <silent><leader>e :NvimTreeToggle<CR>
nnoremap <silent><leader>r :NvimTreeRefresh<CR>
nnoremap <silent><leader>n :NvimTreeFindFile<CR>
set backup 
set backupdir=~/.local/share/nvim/backup
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
nnoremap <leader>p <cmd>Telescope find_files theme=get_ivy<cr>
nnoremap <leader>o <cmd>Telescope oldfiles theme=get_ivy<cr>
nnoremap <leader>g <cmd>Telescope live_grep theme=get_ivy<cr>
nnoremap <leader>b <cmd>Telescope buffers theme=get_ivy<cr>
nnoremap <leader>fc <cmd>Telescope current_buffer_fuzzy_find theme=get_ivy<cr>
nnoremap <leader>fr <cmd>Telescope file_browser theme=get_ivy<cr>
map ;z :TZAtaraxis l0<cr><c-w>w<c-w>w<c-w>w

function CloseBuf()
    let bufnum = bufnr()
    exe "bnext"
    exe "bd " .. bufnum
endfunction

function AddBuf(num)
    let bufnum = bufnr()
    let com = "map <silent>;" .. a:num .. " :buffer " .. bufnum .. "<cr>"
    exe com
endfunction

" map <silent>;a1 :call AddBuf(1)<cr>
" map <silent>;a2 :call AddBuf(2)<cr>
" map <silent>;a3 :call AddBuf(3)<cr>
" map <silent>;a4 :call AddBuf(4)<cr>
" map <silent>;a5 :call AddBuf(5)<cr>
" map <silent>;a6 :call AddBuf(6)<cr>
" map <silent>;a7 :call AddBuf(7)<cr>
" map <silent>;a8 :call AddBuf(8)<cr>
" map <silent>;c :call CloseBuf()<cr>
nnoremap <silent>;j :bprev<cr>
nnoremap <silent>;k :bnext<cr>
map <silent>;a <cmd>lua require("harpoon.mark").add_file()<cr>
map <silent>;d <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
map <silent>;1 <cmd>lua require("harpoon.ui").nav_file(1)<cr>
map <silent>;2 <cmd>lua require("harpoon.ui").nav_file(2)<cr>
map <silent>;3 <cmd>lua require("harpoon.ui").nav_file(3)<cr>
map <silent>;4 <cmd>lua require("harpoon.ui").nav_file(4)<cr>
map <silent>;5 <cmd>lua require("harpoon.ui").nav_file(5)<cr>
map <silent>;6 <cmd>lua require("harpoon.ui").nav_file(6)<cr>
map <silent>;7 <cmd>lua require("harpoon.ui").nav_file(7)<cr>
map <silent>;8 <cmd>lua require("harpoon.ui").nav_file(8)<cr>
map <silent>;9 <cmd>lua require("harpoon.ui").nav_file(9)<cr>
" map <silent>;c :call CloseBuf()<cr>
" map <leader>t <c-w>w
set encoding=UTF-8
set wrap
set linebreak
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set noshowcmd
set noruler
let &fcs='eob: '
set shortmess+=F
set sessionoptions+=options
set timeoutlen=300
cnoremap <cr> <cr><cmd>noh<cr>
set guicursor=i:ver1
set guicursor+=a:blinkon1
set cursorline
let g:sneak#s_next = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
autocmd User SneakLeave highlight clear Sneak
set formatoptions-=r
imap <c-u> <c-x><c-o>
" set signcolumn=no

lua << EOF
require('gitsigns').setup()
EOF
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map . /

map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >
map , ?
