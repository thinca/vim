/* eval.c */
varnumber_T num_divide(varnumber_T n1, varnumber_T n2);
varnumber_T num_modulus(varnumber_T n1, varnumber_T n2);
void eval_init(void);
void eval_clear(void);
int eval_to_bool(char_u *arg, int *error, char_u **nextcmd, int skip);
int eval_expr_typval(typval_T *expr, typval_T *argv, int argc, typval_T *rettv);
int eval_expr_to_bool(typval_T *expr, int *error);
char_u *eval_to_string_skip(char_u *arg, char_u **nextcmd, int skip);
int skip_expr(char_u **pp);
char_u *eval_to_string(char_u *arg, char_u **nextcmd, int convert);
char_u *eval_to_string_safe(char_u *arg, char_u **nextcmd, int use_sandbox);
varnumber_T eval_to_number(char_u *expr);
typval_T *eval_expr(char_u *arg, char_u **nextcmd);
int call_vim_function(char_u *func, int argc, typval_T *argv, typval_T *rettv);
varnumber_T call_func_retnr(char_u *func, int argc, typval_T *argv);
void *call_func_retstr(char_u *func, int argc, typval_T *argv);
void *call_func_retlist(char_u *func, int argc, typval_T *argv);
int eval_foldexpr(char_u *arg, int *cp);
char_u *get_lval(char_u *name, typval_T *rettv, lval_T *lp, int unlet, int skip, int flags, int fne_flags);
void clear_lval(lval_T *lp);
void set_var_lval(lval_T *lp, char_u *endp, typval_T *rettv, int copy, int is_const, char_u *op);
void *eval_for_line(char_u *arg, int *errp, char_u **nextcmdp, int skip);
int next_for_item(void *fi_void, char_u *arg);
void free_for_info(void *fi_void);
void set_context_for_expression(expand_T *xp, char_u *arg, cmdidx_T cmdidx);
int pattern_match(char_u *pat, char_u *text, int ic);
int eval0(char_u *arg, typval_T *rettv, char_u **nextcmd, int evaluate);
int eval1(char_u **arg, typval_T *rettv, int evaluate);
int get_option_tv(char_u **arg, typval_T *rettv, int evaluate);
char_u *partial_name(partial_T *pt);
void partial_unref(partial_T *pt);
int tv_equal(typval_T *tv1, typval_T *tv2, int ic, int recursive);
int get_copyID(void);
int garbage_collect(int testing);
int set_ref_in_ht(hashtab_T *ht, int copyID, list_stack_T **list_stack);
int set_ref_in_dict(dict_T *d, int copyID);
int set_ref_in_list(list_T *ll, int copyID);
int set_ref_in_list_items(list_T *l, int copyID, ht_stack_T **ht_stack);
int set_ref_in_item(typval_T *tv, int copyID, ht_stack_T **ht_stack, list_stack_T **list_stack);
char_u *echo_string_core(typval_T *tv, char_u **tofree, char_u *numbuf, int copyID, int echo_style, int restore_copyID, int composite_val);
char_u *echo_string(typval_T *tv, char_u **tofree, char_u *numbuf, int copyID);
char_u *tv2string(typval_T *tv, char_u **tofree, char_u *numbuf, int copyID);
char_u *string_quote(char_u *str, int function);
int string2float(char_u *text, float_T *value);
pos_T *var2fpos(typval_T *varp, int dollar_lnum, int *fnum);
int list2fpos(typval_T *arg, pos_T *posp, int *fnump, colnr_T *curswantp);
int get_env_len(char_u **arg);
int get_id_len(char_u **arg);
int get_name_len(char_u **arg, char_u **alias, int evaluate, int verbose);
char_u *find_name_end(char_u *arg, char_u **expr_start, char_u **expr_end, int flags);
int eval_isnamec(int c);
int eval_isnamec1(int c);
int handle_subscript(char_u **arg, typval_T *rettv, int evaluate, int verbose, char_u *start_leader, char_u **end_leaderp);
typval_T *alloc_tv(void);
typval_T *alloc_string_tv(char_u *s);
void free_tv(typval_T *varp);
void clear_tv(typval_T *varp);
void init_tv(typval_T *varp);
varnumber_T tv_get_number(typval_T *varp);
varnumber_T tv_get_number_chk(typval_T *varp, int *denote);
float_T tv_get_float(typval_T *varp);
char_u *tv_get_string(typval_T *varp);
char_u *tv_get_string_buf(typval_T *varp, char_u *buf);
char_u *tv_get_string_chk(typval_T *varp);
char_u *tv_get_string_buf_chk(typval_T *varp, char_u *buf);
void copy_tv(typval_T *from, typval_T *to);
int item_copy(typval_T *from, typval_T *to, int deep, int copyID);
void ex_echo(exarg_T *eap);
void ex_echohl(exarg_T *eap);
int get_echo_attr(void);
void ex_execute(exarg_T *eap);
char_u *find_option_end(char_u **arg, int *opt_flags);
void last_set_msg(sctx_T script_ctx);
int typval_compare(typval_T *typ1, typval_T *typ2, exptype_T type, int type_is, int ic);
char_u *typval_tostring(typval_T *arg);
int modify_fname(char_u *src, int tilde_file, int *usedlen, char_u **fnamep, char_u **bufp, int *fnamelen);
char_u *do_string_sub(char_u *str, char_u *pat, char_u *sub, typval_T *expr, char_u *flags);
/* vim: set ft=c : */
