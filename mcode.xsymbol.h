#ifndef __MCODE_XSYMBOL_H__
#define __MCODE_XSYMBOL_H__

typedef enum   tag_xsymbol_type{
	xsymbol_type_0,
	xsymbol_type_b,
	xsymbol_type_i,
	xsymbol_type_f,
	xsymbol_type_s
}xsymbol_type;
typedef union tag_xsymbol_value{
		int          value_b;
		int    		 value_i;
		double 		 value_f;
		const char*  value_s;
}xsymbol_value;
typedef struct tag_xsymbol{
	const char* 	name;
	xsymbol_type	type;
	xsymbol_value 	value;
	int          	stack_id;
}xsymbol;
typedef struct tag_xsymbol_stack
{
	xsymbol**	xsymbol_dat;
	int     	stack_id;
	int         stack_len;
	int     	stack_size;
}xsymbol_stack;

xsymbol_stack* xsymbol_stack__new(int stack_size);
void           xsymbol_stack__del(xsymbol_stack* stack);

xsymbol* xsymbol_stack__new_xsymbol(xsymbol_stack* stack,const char* name,int islocal);
xsymbol* xsymbol_stack__new_xsymbol_temp(xsymbol_stack* stack);
void xsymbol_set_0(xsymbol* sym);
void xsymbol_set_b(xsymbol* sym,int b);
void xsymbol_set_i(xsymbol* sym,int i);
void xsymbol_set_f(xsymbol* sym,double f);
void xsymbol_set_s(xsymbol* sym,const char* s);
void xsymbol_set_x(xsymbol* sym,const xsymbol* x);

void xsymbol_v_addi_i(xsymbol* sym,xsymbol* v,int i);
void xsymbol_i_addi_v(xsymbol* sym,int i,xsymbol* v);
void xsymbol_v_deci_i(xsymbol* sym,xsymbol* v,int i);
void xsymbol_i_deci_v(xsymbol* sym,int i,xsymbol* v);
void xsymbol_v_mult_i(xsymbol* sym,xsymbol* v,int i);
void xsymbol_i_mult_v(xsymbol* sym,int i,xsymbol* v);
void xsymbol_v_divi_i(xsymbol* sym,xsymbol* v,int i);
void xsymbol_i_divi_v(xsymbol* sym,int i,xsymbol* v);

void xsymbol_v_addi_f(xsymbol* sym,xsymbol* v,double f);
void xsymbol_f_addi_v(xsymbol* sym,double f,xsymbol* v);
void xsymbol_v_deci_f(xsymbol* sym,xsymbol* v,double f);
void xsymbol_f_deci_v(xsymbol* sym,double f,xsymbol* v);
void xsymbol_v_mult_f(xsymbol* sym,xsymbol* v,double f);
void xsymbol_f_mult_v(xsymbol* sym,double f,xsymbol* v);
void xsymbol_v_divi_f(xsymbol* sym,xsymbol* v,double f);
void xsymbol_f_divi_v(xsymbol* sym,double f,xsymbol* v);

void xsymbol_v_addi_v(xsymbol* sym,xsymbol* v1,xsymbol* v2);
void xsymbol_v_deci_v(xsymbol* sym,xsymbol* v1,xsymbol* v2);
void xsymbol_v_mult_v(xsymbol* sym,xsymbol* v1,xsymbol* v2);
void xsymbol_v_divi_v(xsymbol* sym,xsymbol* v1,xsymbol* v2);

int xsymbol_v_equal_b(xsymbol* v1,int i);
int xsymbol_v_equal_i(xsymbol* v1,int i);
int xsymbol_v_equal_f(xsymbol* v1,double f);
int xsymbol_v_equal_v(xsymbol* v1,xsymbol* v2);
int xsymbol_is_nil(xsymbol* v);

#endif
