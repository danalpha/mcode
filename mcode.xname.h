#ifndef __MCODE_XNAME_H__
#define __MCODE_XNAME_H__

typedef struct tag_xname{
	char* 	name;
	int     stack_id;
}xname;
typedef struct tag_xname_stack
{
	xname**	xname_dat;
	int     stack_len;
	int     stack_size;
	int     stack_tmp_name;
}xname_stack;

xname_stack* xname_stack__new(int stack_size);
void         xname_stack__del(xname_stack* stack);

xname* xname_stack__new_xname(xname_stack* stack,const char* name);
#endif
