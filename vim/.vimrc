"----------------
"--- Основные ---
"----------------

" Установка UTF-8 стандартной кодировкой для файлов
set encoding=utf8

set number

" Показывать колонну на 120 символе строк (по счёту)
set colorcolumn=120

"----------------
" --- Plugins ---
"----------------

call plug#begin()
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'joshdick/onedark.vim'
call plug#end()

"---------------
"--- Coc Vim ---
"---------------

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"--------------------
" --- Русификация ---
" -------------------

"  " Работа с вводом (INSERT) без переключения раскладки
noremap ш i
noremap Ш I
noremap ф a
noremap Ф A
noremap щ o
noremap Щ O

" Работа с заменой (REPLACE) без переключения раскладки
noremap к r
noremap К R

" Работа с режимом выделения (VISUAL) без переключения раскладки
noremap м v
noremap М V

" Работа с поиском: следующее и предыдущее совпадение без переключения раскладки
noremap т n
noremap Т N

" Копировать, удалить и вставить без переключения раскладки
noremap н y
noremap Н Y
noremap в d
noremap В D
noremap ч x
noremap Ч X
noremap з p
noremap З P

" Перемещения к началу/концу слов без переключения раскладки
noremap ц w
noremap Ц W
noremap у e
noremap У E
noremap и b
noremap И B

" Некоторые прочие русские буквы
noremap й q
noremap Й Q
noremap с c
noremap С C
noremap п g
noremap П G

" Тут важен именно map, чтобы в дальнейшем
" можно было убрать стандартное действие
" (удаление символа/строки и переход в режим INSERT)
map ы s
map Ы S

" Одинарные кавычки: ' в режиме ввода (INSERT) по нажатию Ctrl+э
inoremap <C-э> '

"-----------------
"--- Подсветка ---
"-----------------

" Дополнительная подсветка для курсора, чтобы различать режимы
"highlight lCursor guifg=NONE guibg=Cyan


" ------------------------------------
" --- Привычные комбинации клавиш  ---
" --- для редакторов вне терминала ---
" ------------------------------------

" Ctrl+s для сохранения файла и возврата в нормальный режим (NORMAL)
"   из NORMAL
nnoremap <C-s> :w<CR>
"   из INSERT
inoremap <C-s> <Esc>:w<CR>
"   из VISUAL
vnoremap <C-s> <Esc>:w<CR>

" Ctrl+c для закрытия текущего файла, находясь в режиме NORMAL
nnoremap <C-c> :q<CR>

" Ctrl+z для отмены изменений и Ctrl+x для возврата к изменениям
" в режимах NORMAL, VISUAL и INSERT
nnoremap <C-z> :undo<CR>
vnoremap <C-z> <Esc>:undo<CR>
inoremap <C-z> <Esc>:undo<CR>i
nnoremap <C-x> :redo<CR>
vnoremap <C-x> <Esc>:redo<CR>
inoremap <C-x> <Esc>:redo<CR>i

" Двигать текущую строку в режиме NORMAL
" вверх и вниз по нажатию Ctrl+Shift+Вверх/Вниз,
" где Вверх/Вниз это соответствующие стрелки на клавиатуре
nnoremap <silent> <C-S-Up> :m .-2<CR>
nnoremap <silent> <C-S-Down> :m .+1<CR>

" Аналогично, но уже для режима VISUAL
" перемещение нескольких строк за раз
vnoremap <silent> <C-S-Up> :m '<-2<CR>gv
vnoremap <silent> <C-S-Down> :m '>+1<CR>gv

" -----------------------------
" --- Настройка отступов, -----
" --- переносов и табуляции ---
" -----------------------------

" Табуляция, использование пробелов вместо \t
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Установка smartindent и autoindent для табуляции
set smartindent

" autoindent: новые строчки копируют отступы прежних
" Иногда плохо срабатывает при вставке, можно закомментировать
set autoindent

" Менять уровень табуляции для режима VISUAL по нажатию > и <
vnoremap <silent> > >gv
vnoremap <silent> < <gv

" ---------------------
" --- Курсор и мышь ---
" ---------------------

" Работа с мышью
"   оставить только прокрутку
" set mouse-=a
"   прокрутка + корректное выделение
" set mouse=n
"   полностью включить
"   (при выделении мышью будет временно
"   переходить в режим VISUAL)
" set mouse=a
set mouse=a

" Показывать позицию курсора справа внизу (обычно, панель находится там)
set ruler


" Всегда иметь визуальные отступы в 5 строк
" от верхнего и нижнего края экрана Vim до курсора.
set scrolloff=5

" Подсвечивать строку на которой находится курсор
set cursorline

" Прекратить подсвечивать её при переходе в режим INSERT
autocmd InsertEnter,InsertLeave * set cursorline!

" -----------------------------
" --- Прочие настройки --------
" -----------------------------

" Сделать размер истории последних изменений
" для undo/redo равным 1000
set undolevels=1000
set history=1000

" «Умный» поиск:
" - при вводе только маленьких (строчных) букв
"   ищет регистро-независимо
" - а если введена хотя бы одна большая (заглавная/прописная)
"   буква, то будет искать регистро-зависимо
set ignorecase
set smartcase

" Функция, убирающая лишние пробелы на концах строк,
" лишние строки в файле, а также лишние строки под конец файла
function! CleanupBeforeWrite()

    " Запоминаем позицию курсора
    let l:line = line('.')
    let l:col = col('.')

    " Убрать лишние пробелы на концах строк
    " % перед s означает, что нужно сразу во всём файле заменять
    :%s/\s\+$//e

    " Добавить пустые строки под конец файла
    " (нужно, чтобы правильно их усечь до одной впоследствии)
    :$s/$/\=repeat("\r", 5)/e
    " Убрать лишние пустые строки в избыточном количестве
    :%s/\n\{5,}/\r\r/e
    " Странно, но при замене \r - это newline,
    " а \n - это null.
    " https://stackoverflow.com/questions/3965883/vim-replace-character-to-n
    " https://unix.stackexchange.com/questions/247329/vim-how-to-replace-one-new-line-n-with-two-ns
    " Оставляем только одну пустую строку под конец файла
    :$-1,$s/\n//e

    " Возвращаем курсор в исходное положение
    call cursor(l:line, l:col)

endfunction

" Автовызов функции выше перед сохраненем файла
autocmd BufWritePre * call CleanupBeforeWrite()

" Не обновлять экран во время исполнения скриптов и макросов,
" чтобы экран не мерцал и не подвисал на больших файлах
set lazyredraw

" Ускорить вывод символов на экран
set ttyfast

" Использовать расширенный синтаксис регулярных выражений по умолчанию
set magic

" Показывать автодополнение в режиме команд
" (EX, :) в виде меню
set wildmenu
set wildchar=<Tab>

" -------------
" --- Цвета ---
" -------------

" 256 цветов (Использовать RGB)
set t_Co=256

" Тот же параметр, но вне графического сервера (Xorg, Wayland)
if !has('gui_running')
    set t_Co=256
endif

" Включение подсветки синтаксиса
syntax enable

" Включение цветов в терминале
if has('termguicolors')
"    set termguicolors
endif

" Изменение цветовой палитры редактора на тёмную
set background=dark

" Цветовая схема
colorscheme onedark

