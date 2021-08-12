/* eval.c */
varnumber_T num_divide(varnumber_T n1, varnumber_T n2, int *failed);
varnumber_T num_modulus(varnumber_T n1, varnumber_T n2, int *failed);
void eval_init(void);
void eval_clear(void);
void fill_evalarg_from_eap(evalarg_T *evalarg, exarg_T *eap, int skip);
int eval_to_bool(char_u *arg, int *error, exarg_T *eap, int skip);
int eval_expr_valid_arg(typval_T *tv);
int eval_expr_typval(typval_T *expr, typval_T *argv, int argc, typval_T *rettv);
int eval_expr_to_bool(typval_T *expr, int *error);
char_u *eval_to_string_skip(char_u *arg, exarg_T *eap, int skip);
int skip_expr(char_u **pp, evalarg_T *evalarg);
int skip_expr_concatenate(char_u **arg, char_u **start, char_u **end, evalarg_T *evalarg);
char_u *typval2string(typval_T *tv, int convert);
char_u *eval_to_string_eap(char_u *arg, int convert, exarg_T *eap);
char_u *eval_to_string(char_u *arg, int convert);
char_u *eval_to_string_safe(char_u *arg, int use_sandbox);
varnumber_T eval_to_number(char_u *expr);
typval_T *eval_expr(char_u *arg, exarg_T *eap);
int call_vim_function(char_u *func, int argc, typval_T *argv, typval_T *rettv);
varnumber_T call_func_retnr(char_u *func, int argc, typval_T *argv);
int call_func_noret(char_u *func, int argc, typval_T *argv);
void *call_func_retstr(char_u *func, int argc, typval_T *argv);
void *call_func_retlist(char_u *func, int argc, typval_T *argv);
int eval_foldexpr(char_u *arg, int *cp);
char_u *get_lval(char_u *name, typval_T *rettv, lval_T *lp, int unlet, int skip, int flags, int fne_flags);
void clear_lval(lval_T *lp);
void set_var_lval(lval_T *lp, char_u *endp, typval_T *rettv, int copy, int flags, char_u *op, int var_idx);
int tv_op(typval_T *tv1, typval_T *tv2, char_u *op);
void *eval_for_line(char_u *arg, int *errp, exarg_T *eap, evalarg_T *evalarg);
void skip_for_lines(void *fi_void, evalarg_T *evalarg);
int next_for_item(void *fi_void, char_u *arg);
void free_for_info(void *fi_void);
void set_context_for_expression(expand_T *xp, char_u *arg, cmdidx_T cmdidx);
int pattern_match(char_u *pat, char_u *text, int ic);
char_u *skipwhite_and_linebreak(char_u *arg, evalarg_T *evalarg);
void clear_evalarg(evalarg_T *evalarg, exarg_T *eap);
int eval0(char_u *arg, typval_T *rettv, exarg_T *eap, evalarg_T *evalarg);
int eval1(char_u **arg, typval_T *rettv, evalarg_T *evalarg);
void eval_addblob(typval_T *tv1, typval_T *tv2);
int eval_addlist(typval_T *tv1, typval_T *tv2);
int eval_leader(char_u **arg, int vim9);
int check_can_index(typval_T *rettv, int evaluate, int verbose);
void f_slice(typval_T *argvars, typval_T *rettv);
int eval_index_inner(typval_T *rettv, int is_range, typval_T *var1, typval_T *var2, int exclusive, char_u *key, int keylen, int verbose);
char_u *partial_name(partial_T *pt);
void partial_unref(partial_T *pt);
int get_copyID(void);
int garbage_collect(int testing);
int set_ref_in_ht(hashtab_T *ht, int copyID, list_stack_T **list_stack);
int set_ref_in_dict(dict_T *d, int copyID);
int set_ref_in_list(list_T *ll, int copyID);
int set_ref_in_list_items(list_T *l, int copyID, ht_stack_T **ht_stack);
int set_ref_in_item(typval_T *tv, int copyID, ht_stack_T **ht_stack, list_stack_T **list_stack);
char_u *echo_string_core(typval_T *tv, char_u **tofree, char_u *numbuf, int copyID, int echo_style, int restore_copyID, int composite_val);
char_u *echo_string(typval_T *tv, char_u **tofree, char_u *numbuf, int copyID);
int buf_byteidx_to_charidx(buf_T *buf, int lnum, int byteidx);
int buf_charidx_to_byteidx(buf_T *buf, int lnum, int charidx);
pos_T *var2fpos(typval_T *varp, int dollar_lnum, int *fnum, int charcol);
int list2fpos(typval_T *arg, pos_T *posp, int *fnump, colnr_T *curswantp, int charcol);
int get_env_len(char_u **arg);
int get_id_len(char_u **arg);
int get_name_len(char_u **arg, char_u **alias, int evaluate, int verbose);
char_u *find_name_end(char_u *arg, char_u **expr_start, char_u **expr_end, int flags);
int eval_isnamec(int c);
int eval_isnamec1(int c);
int eval_isdictc(int c);
int handle_subscript(char_u **arg, typval_T *rettv, evalarg_T *evalarg, int verbose);
int item_copy(typval_T *from, typval_T *to, int deep, int copyID);
void echo_one(typval_T *rettv, int with_space, int *atstart, int *needclr);
void ex_echo(exarg_T *eap);
void ex_echohl(exarg_T *eap);
int get_echo_attr(void);
void ex_execute(exarg_T *eap);
char_u *find_option_end(char_u **arg, int *opt_flags);
void last_set_msg(sctx_T script_ctx);
char_u *do_string_sub(char_u *str, char_u *pat, char_u *sub, typval_T *expr, char_u *flags);
/* vim: set ft=c : */
