#include "mcode.xname.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

//�ڴ����:

xname_stack* xname_stack__new(int stack_size)
{
	xname_stack* stack=(xname_stack*)malloc(sizeof(xname_stack));
	memset(stack,0,sizeof(xname_stack));
	
	stack->stack_len=0;
	stack->stack_size=stack_size;
	stack->stack_tmp_name=0;
	
	stack->xname_dat=(xname**)malloc(sizeof(xname*)*(stack->stack_size));
	memset(stack->xname_dat,0,sizeof(xname*)*(stack->stack_size));
	return stack;
}
xname* xname_stack__new_xname(xname_stack* stack,const char* name)
{
	//����һ��,Ȼ������.���ַ�����.
	
	//1.�Ȳ��Ҿֲ�����,�鿴�Ƿ�����ҵ�.��������ҵ�,��ô������!!
	//2.����Ҳ���,��ô�������is_local,��ô,����һ��local,���򴴽�һ����ǰglobal��
	int i;
	for(i=0;i<stack->stack_len;i++)
	{
		xname* sym=stack->xname_dat[i];
		if(strcmp(sym->name,name)==0){return sym;}
	}
	
	if(stack->stack_len<stack->stack_size)
	{
		xname* sym=(xname*)malloc(sizeof(xname));
		memset(sym,0,sizeof(xname));
		sym->stack_id=0;
		
		stack->xname_dat[stack->stack_len]=sym;
		stack->stack_len+=1;
		
		if(name==NULL)name="";
		sym->name=strdup(name);
		//printf("new_name:(%s)=(%d)\n",name,sym);
		return sym;
	}
	return NULL;
}
void xname_stack__del(xname_stack* stack)
{
	int i;
	for(i=stack->stack_len-1;i>=0;--i)
	{
		xname* sym=stack->xname_dat[i];
		if(sym)
		{
			if(sym->name){free(sym->name);sym->name=NULL;}
			free(sym);
			stack->xname_dat[i]=NULL;
		}
	}
	stack->stack_len=0;
	if(stack->xname_dat)
	{
		free(stack->xname_dat);
		stack->xname_dat=NULL;
	}
	if(stack)
	{
		free(stack);
		stack=NULL;
	}
}

