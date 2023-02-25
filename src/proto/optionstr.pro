/* optionstr.c */
void didset_string_options(void);
void trigger_optionset_string(int opt_idx, int opt_flags, char_u *oldval, char_u *oldval_l, char_u *oldval_g, char_u *newval);
void check_buf_options(buf_T *buf);
void free_string_option(char_u *p);
void clear_string_option(char_u **pp);
void check_string_option(char_u **pp);
void set_string_option_direct(char_u *name, int opt_idx, char_u *val, int opt_flags, int set_sid);
void set_string_option_direct_in_win(win_T *wp, char_u *name, int opt_idx, char_u *val, int opt_flags, int set_sid);
void set_string_option_direct_in_buf(buf_T *buf, char_u *name, int opt_idx, char_u *val, int opt_flags, int set_sid);
char *set_string_option(int opt_idx, char_u *value, int opt_flags, char *errbuf);
char *did_set_backupcopy(optset_T *args);
char *did_set_backupext_or_patchmode(optset_T *args);
char *did_set_breakindentopt(optset_T *args);
char *did_set_helpfile(optset_T *args);
char *did_set_colorcolumn(optset_T *args);
char *did_set_cursorlineopt(optset_T *args);
char *did_set_helplang(optset_T *args);
char *did_set_highlight(optset_T *args);
char *did_set_belloff(optset_T *args);
char *did_set_casemap(optset_T *args);
char *did_set_scrollopt(optset_T *args);
char *did_set_selectmode(optset_T *args);
char *did_set_showcmdloc(optset_T *args);
char *did_set_splitkeep(optset_T *args);
char *did_set_switchbuf(optset_T *args);
char *did_set_sessionoptions(optset_T *args);
char *did_set_viewoptions(optset_T *args);
char *did_set_ambiwidth(optset_T *args);
char *did_set_background(optset_T *args);
char *did_set_wildmode(optset_T *args);
char *did_set_wildoptions(optset_T *args);
char *did_set_winaltkeys(optset_T *args);
char *did_set_wincolor(optset_T *args);
char *did_set_eadirection(optset_T *args);
char *did_set_eventignore(optset_T *args);
char *did_set_printencoding(optset_T *args);
char *did_set_imactivatekey(optset_T *args);
char *did_set_fileformat(optset_T *args);
char *did_set_fileformats(optset_T *args);
char *did_set_cryptkey(optset_T *args);
char *did_set_cryptmethod(optset_T *args);
char *did_set_matchpairs(optset_T *args);
char *did_set_comments(optset_T *args);
char *did_set_verbosefile(optset_T *args);
char *did_set_viminfo(optset_T *args);
char *did_set_showbreak(optset_T *args);
char *did_set_guicursor(optset_T *args);
char *did_set_guifont(optset_T *args);
char *did_set_guifontset(optset_T *args);
char *did_set_guifontwide(optset_T *args);
char *did_set_guiligatures(optset_T *args);
char *did_set_mouseshape(optset_T *args);
char *did_set_titlestring(optset_T *args);
char *did_set_iconstring(optset_T *args);
char *did_set_guioptions(optset_T *args);
char *did_set_guitablabel(optset_T *args);
char *did_set_ttymouse(optset_T *args);
char *did_set_selection(optset_T *args);
char *did_set_browsedir(optset_T *args);
char *did_set_keymodel(optset_T *args);
char *did_set_keyprotocol(optset_T *args);
char *did_set_mousemodel(optset_T *args);
char *did_set_debug(optset_T *args);
char *did_set_display(optset_T *args);
char *did_set_spellfile(optset_T *args);
char *did_set_spelllang(optset_T *args);
char *did_set_spellcapcheck(optset_T *args);
char *did_set_spelloptions(optset_T *args);
char *did_set_spellsuggest(optset_T *args);
char *did_set_mkspellmem(optset_T *args);
char *did_set_nrformats(optset_T *args);
char *did_set_buftype(optset_T *args);
char *did_set_statusline(optset_T *args);
char *did_set_tabline(optset_T *args);
char *did_set_rulerformat(optset_T *args);
char *did_set_complete(optset_T *args);
char *did_set_completeopt(optset_T *args);
char *did_set_completeslash(optset_T *args);
char *did_set_signcolumn(optset_T *args);
char *did_set_toolbar(optset_T *args);
char *did_set_toolbariconsize(optset_T *args);
char *did_set_pastetoggle(optset_T *args);
char *did_set_backspace(optset_T *args);
char *did_set_bufhidden(optset_T *args);
char *did_set_tagcase(optset_T *args);
char *did_set_diffopt(optset_T *args);
char *did_set_foldmethod(optset_T *args);
char *did_set_foldmarker(optset_T *args);
char *did_set_commentstring(optset_T *args);
char *did_set_foldignore(optset_T *args);
char *did_set_foldclose(optset_T *args);
char *did_set_foldopen(optset_T *args);
char *did_set_virtualedit(optset_T *args);
char *did_set_cscopequickfix(optset_T *args);
char *did_set_cinoptions(optset_T *args);
char *did_set_lispoptions(optset_T *args);
char *did_set_renderoptions(optset_T *args);
char *did_set_termwinkey(optset_T *args);
char *did_set_termwinsize(optset_T *args);
char *did_set_termwintype(optset_T *args);
char *did_set_varsofttabstop(optset_T *args);
char *did_set_vartabstop(optset_T *args);
char *did_set_previewpopup(optset_T *args);
char *did_set_completepopup(optset_T *args);
char *did_set_optexpr(optset_T *args);
char *did_set_foldexpr(optset_T *args);
char *did_set_concealcursor(optset_T *args);
char *did_set_cpoptions(optset_T *args);
char *did_set_formatoptions(optset_T *args);
char *did_set_mouse(optset_T *args);
char *did_set_shortmess(optset_T *args);
char *did_set_whichwrap(optset_T *args);
char *did_set_string_option(int opt_idx, char_u **varp, char_u *oldval, char_u *value, char *errbuf, int opt_flags, int *value_checked);
int check_ff_value(char_u *p);
void save_clear_shm_value(void);
void restore_shm_value(void);
/* vim: set ft=c : */
