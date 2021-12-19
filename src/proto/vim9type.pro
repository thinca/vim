/* vim9type.c */
void clear_type_list(garray_T *gap);
type_T *alloc_type(type_T *type);
void free_type(type_T *type);
type_T *get_list_type(type_T *member_type, garray_T *type_gap);
type_T *get_dict_type(type_T *member_type, garray_T *type_gap);
type_T *alloc_func_type(type_T *ret_type, int argcount, garray_T *type_gap);
type_T *get_func_type(type_T *ret_type, int argcount, garray_T *type_gap);
int func_type_add_arg_types(type_T *functype, int argcount, garray_T *type_gap);
int need_convert_to_bool(type_T *type, typval_T *tv);
type_T *typval2type(typval_T *tv, int copyID, garray_T *type_gap, int do_member);
type_T *typval2type_vimvar(typval_T *tv, garray_T *type_gap);
int check_typval_arg_type(type_T *expected, typval_T *actual_tv, char *func_name, int arg_idx);
int check_typval_type(type_T *expected, typval_T *actual_tv, where_T where);
void type_mismatch(type_T *expected, type_T *actual);
void arg_type_mismatch(type_T *expected, type_T *actual, int arg_idx);
void type_mismatch_where(type_T *expected, type_T *actual, where_T where);
int check_type(type_T *expected, type_T *actual, int give_msg, where_T where);
int check_type_maybe(type_T *expected, type_T *actual, int give_msg, where_T where);
int check_argument_types(type_T *type, typval_T *argvars, int argcount, char_u *name);
char_u *skip_type(char_u *start, int optional);
type_T *parse_type(char_u **arg, garray_T *type_gap, int give_error);
int equal_type(type_T *type1, type_T *type2, int flags);
void common_type(type_T *type1, type_T *type2, type_T **dest, garray_T *type_gap);
type_T *get_member_type_from_stack(type_T **stack_top, int count, int skip, garray_T *type_gap);
char *vartype_name(vartype_T type);
char *type_name(type_T *type, char **tofree);
void f_typename(typval_T *argvars, typval_T *rettv);
/* vim: set ft=c : */
