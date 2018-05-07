#include "mcode.xsymbol.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

//内存管理:

xsymbol_stack* xsymbol_stack__new(int stack_size)
{
	xsymbol_stack* stack=(xsymbol_stack*)malloc(sizeof(xsymbol_stack));
	memset(stack,0,sizeof(xsymbol_stack));
	
	stack->stack_id=0;
	stack->stack_len=0;
	stack->stack_size=stack_size;

	stack->xsymbol_dat=(xsymbol**)malloc(sizeof(xsymbol*)*(stack->stack_size));
	memset(stack->xsymbol_dat,0,sizeof(xsymbol*)*(stack->stack_size));
	return stack;
}
//传入当前stackid,传入islocal.用完就会被pop掉.!!
xsymbol* xsymbol_stack__new_xsymbol(xsymbol_stack* stack,const char* name,int islocal)
{
	int i;
	//查找第一个stackid最大的那个
	
	//如果是全局查找,并且找到了,那么就立即返回
	if(islocal)
	{
		xsymbol* sym_out=NULL;
		for(i=0;i<stack->stack_len;i++)
		{
			xsymbol* sym=stack->xsymbol_dat[i];
			if(name==sym->name&&sym->stack_id==stack->stack_id){//直接比较地址!!
				sym_out=sym;
				break;
			}
		}
		if(sym_out)
		{
			xsymbol_set_0(sym_out);
			return sym_out;
		}
	}
	else
	{
		xsymbol* sym_out=NULL;
		for(i=0;i<stack->stack_len;i++)
		{
			xsymbol* sym=stack->xsymbol_dat[i];
			if(name==sym->name){//直接比较地址!!
				if(sym_out==NULL)
				{
					if(sym->stack_id<=stack->stack_id)
					{
						sym_out=sym;
					}
				}
				else
				{
					if(sym->stack_id<sym_out->stack_id)
					{
						sym_out=sym;
					}
				}
			}
		}
		if(sym_out)
		{
			//找到了,就使用
			return sym_out;
		}
	}
	//创建一个新的
	if(stack->stack_len<stack->stack_size)
	{
		xsymbol* sym=(xsymbol*)malloc(sizeof(xsymbol));
		memset(sym,0,sizeof(xsymbol));
		if(islocal)
		{
			sym->stack_id=stack->stack_id;
		}
		else
		{	//local的唯一意义就是可以直接开启一个新变量,而不是改掉之前的值.
			sym->stack_id=stack->stack_id;//0;
		}		
		stack->xsymbol_dat[stack->stack_len]=sym;
		stack->stack_len+=1;
		sym->name=name;
		printf("new_var:(%s)=(%d)\n",name,sym);
		return sym;
	}
	
	return NULL;
}
xsymbol* xsymbol_stack__new_xsymbol_temp(xsymbol_stack* stack)
{
	if(stack->stack_len<stack->stack_size)
	{
		xsymbol* sym=(xsymbol*)malloc(sizeof(xsymbol));
		memset(sym,0,sizeof(xsymbol));
		sym->stack_id=stack->stack_id;
		
		stack->xsymbol_dat[stack->stack_len]=sym;
		stack->stack_len+=1;
		sym->name=NULL;
		printf("new_tmp_var:(%d)\n",sym);
		return sym;
	}
	return NULL;
}
void xsymbol_set_0(xsymbol* sym)
{
	sym->type=xsymbol_type_0;
	sym->value.value_s=NULL;
}
void xsymbol_set_i(xsymbol* sym,int i)
{
	sym->type=xsymbol_type_i;
	sym->value.value_i=i;
}
void xsymbol_set_f(xsymbol* sym,double f)
{
	sym->type=xsymbol_type_f;
	sym->value.value_f=f;
}
void xsymbol_set_s(xsymbol* sym,const char* s)
{
	sym->type=xsymbol_type_f;
	sym->value.value_s=s;
}
void xsymbol_set_x(xsymbol* sym,const xsymbol* x)
{
	sym->type=x->type;
	//memcpy(&sym->value,&x->value,sizeof(sym->value));
	sym->value=x->value;
	
	// switch(x->type){
	// case xsymbol_type_0:printf("xsymbol_set_x....%d,%s|  %d,%s\n",x->type,"nil",sym->type,"nil");break;
	// case xsymbol_type_i:printf("xsymbol_set_x....%d,%d|  %d,%d\n",x->type,x->value.value_i,sym->type,sym->value.value_i);break;
	// case xsymbol_type_f:printf("xsymbol_set_x....%d,%g|  %d,%g\n",x->type,x->value.value_f,sym->type,sym->value.value_f);break;
	// case xsymbol_type_s:printf("xsymbol_set_x....%d,%s|  %d,%s\n",x->type,x->value.value_s,sym->type,sym->value.value_s);break;
	// }
}
void xsymbol_v_addi_i(xsymbol* sym,xsymbol* v,int i)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=v->value.value_i+i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f+i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_i_addi_v(xsymbol* sym,int i,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=v->value.value_i+i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f+i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_v_deci_i(xsymbol* sym,xsymbol* v,int i)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=v->value.value_i-i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f-i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_i_deci_v(xsymbol* sym,int i,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=-v->value.value_i+i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=-v->value.value_f+i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_v_mult_i(xsymbol* sym,xsymbol* v,int i)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=v->value.value_i*i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f*i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_i_mult_v(xsymbol* sym,int i,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=v->value.value_i*i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f*i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_v_divi_i(xsymbol* sym,xsymbol* v,int i)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=v->value.value_i/i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f/i;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_i_divi_v(xsymbol* sym,int i,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_i;sym->value.value_i=i/v->value.value_i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=i/v->value.value_f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}

void xsymbol_v_addi_f(xsymbol* sym,xsymbol* v,double f)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_i+f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f+f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_f_addi_v(xsymbol* sym,double f,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_i+f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f+f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_v_deci_f(xsymbol* sym,xsymbol* v,double f)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_i-f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f-f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_f_deci_v(xsymbol* sym,double f,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=-v->value.value_i+f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=-v->value.value_f+f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_v_mult_f(xsymbol* sym,xsymbol* v,double f)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_i*f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f*f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_f_mult_v(xsymbol* sym,double f,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_i*f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f*f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_v_divi_f(xsymbol* sym,xsymbol* v,double f)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_i/f;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=v->value.value_f/f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}
void xsymbol_f_divi_v(xsymbol* sym,double f,xsymbol* v)
{
	switch(v->type)
	{
	case xsymbol_type_i:{sym->type=xsymbol_type_f;sym->value.value_f=f/v->value.value_i;}break;
	case xsymbol_type_f:{sym->type=xsymbol_type_f;sym->value.value_f=f/v->value.value_f;}break;
	default: printf("%s\n","语法错误,不能相加");break;//
	}
}


void xsymbol_v_addi_v(xsymbol* sym,xsymbol* v1,xsymbol* v2)
{
	if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_i;sym->value.value_i=v1->value.value_i+v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_i+v2->value.value_f;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f+v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f+v2->value.value_f;
	}
	else
	{
		//print(语法错误,不能相加)
	}

}
void xsymbol_v_deci_v(xsymbol* sym,xsymbol* v1,xsymbol* v2)
{
	if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_i;sym->value.value_i=v1->value.value_i-v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_i-v2->value.value_f;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f-v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f-v2->value.value_f;
	}
	else
	{
		//print(语法错误,不能相加)
	}
}
void xsymbol_v_mult_v(xsymbol* sym,xsymbol* v1,xsymbol* v2)
{
	if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_i;sym->value.value_i=v1->value.value_i*v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_i*v2->value.value_f;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f*v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f*v2->value.value_f;
	}
	else
	{
		//print(语法错误,不能相加)
	}
}
void xsymbol_v_divi_v(xsymbol* sym,xsymbol* v1,xsymbol* v2)
{
	if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_i;sym->value.value_i=v1->value.value_i/v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_i&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_i/v2->value.value_f;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_i)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f/v2->value.value_i;
	}
	else if(v1->type==xsymbol_type_f&&v2->type==xsymbol_type_f)
	{
		sym->type=xsymbol_type_f;sym->value.value_f=v1->value.value_f/v2->value.value_f;
	}
	else
	{
		//print(语法错误,不能相加)
	}
}


void xsymbol_stack__del(xsymbol_stack* stack)
{
	int i;
	for(i=stack->stack_len-1;i>=0;--i)
	{
		xsymbol* sym=stack->xsymbol_dat[i];
		if(sym)
		{
			if(sym->name){sym->name=NULL;}
			free(sym);
			stack->xsymbol_dat[i]=NULL;
		}
	}
	stack->stack_len=0;
	stack->stack_id=0;
	if(stack->xsymbol_dat)
	{
		free(stack->xsymbol_dat);
		stack->xsymbol_dat=NULL;
	}
	if(stack)
	{
		free(stack);
		stack=NULL;
	}
}

