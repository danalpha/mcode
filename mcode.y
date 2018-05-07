%{
# include <stdio.h>
# include "mcode.xname.h"
# include "mcode.xsymbol.h"
extern xsymbol_stack* global_xsymbol_stack;
extern xname_stack*   global_xname_stack;
%}
%union{
	double 					value_f;
	int    					value_i;
	const char*				value_s;
	struct tag_xname*		value_x;
	struct tag_xsymbol*		value_v;
}

%token TV_IFIF
%token TV_THEN
%token TV_ELSE
%token TV_ELIF
%token TV_ENDD
%token TV_LOCA
%token TV_FUNC
%token TV_RETN
%token TV_TABL
%token TV_TRUE
%token TV_FALS
%token TV_NILL
%token TV_FORR
%token TV_WHIL
%token TV_DODO
%token TV_ININ
%token TV_BREK
%token TV_GOTO
%token TV_REAP
%token <value_x> TV_NAME
%token <value_f> TV_FLOT
%token <value_i> TV_INTT
%token <value_s> TV_TEXT
%token TV_DOTT
%token TV_ASGN
%token TV_SEMI
%token TV_COMA
%token TV_KONG
%token TV_LINE
%token TV_XKBB
%token TV_XKEE
%token TV_ZKBB
%token TV_ZKEE
%token TV_DKBB
%token TV_DKEE
%token TV_ADDI
%token TV_DECI
%token TV_MULT
%token TV_DIVI
%token TV_MODI
%token TV_NEQU
%token TV_NOTT
%token TV_EQUL
%token TV_GTEQ
%token TV_GTHN
%token TV_LTEQ
%token TV_LTHN
%token TV_ANDI
%token TV_ORRR
%token TV_BAND
%token TV_BORR
%token TV_BNOT
%token TV_BXOR
%token TV_ERRR

%left TV_ADDI TV_DECI 
%left TV_MULT TV_DIVI
%left TV_XKBB TV_XKEE
%type <value_i> expression_i statement_i
%type <value_f> expression_f statement_f
%type <value_v> expression_v statement_v
%type <value_x> expression_x statement_x expression_x_asign expression_x_local_asign
%%
statement_list:
	|statement_i		TV_SEMI
	|statement_f		TV_SEMI
	|statement_v		TV_SEMI
	|statement_x		TV_SEMI
	
	|statement_i		TV_LINE
	|statement_f		TV_LINE
	|statement_v		TV_LINE
	|statement_x		TV_LINE
	
	|statement_list		statement_i TV_SEMI
	|statement_list		statement_f TV_SEMI
	|statement_list		statement_v TV_SEMI
	|statement_list		statement_x TV_SEMI

	|statement_list		statement_i TV_LINE
	|statement_list		statement_f TV_LINE
	|statement_list		statement_v TV_LINE
	|statement_list		statement_x TV_LINE
	
	|statement_list     TV_LINE
	|statement_list     TV_SEMI

	|TV_SEMI
	|TV_LINE
	;
statement_i:
	expression_i		{printf("=%d\n",$1);}
	;
expression_i:
	 expression_i		TV_ADDI				expression_i	{$$=$1+$3;}
	|expression_i		TV_DECI				expression_i	{$$=$1-$3;}
	|expression_i		TV_MULT				expression_i	{$$=$1*$3;}
	|expression_i		TV_DIVI				expression_i	{if($3==0){yyerror("diveide by zero");}else{$$=$1/$3;}}
	|TV_XKBB 			expression_i		TV_XKEE		{$$=$2;}
	|TV_ADDI			expression_i		{$$=$2;}
	|TV_DECI			expression_i		{$$=-$2;}
	|TV_INTT			{$$=$1;}
	;
statement_f:
	expression_f		{printf("=%g\n",$1);}
	;
expression_f:
	 expression_f		TV_ADDI				expression_f	{$$=$1+$3;}
	|expression_f		TV_ADDI				expression_i	{$$=$1+$3;}
	|expression_i		TV_ADDI				expression_f	{$$=$1+$3;}
	
	|expression_f		TV_DECI				expression_f	{$$=$1-$3;}
	|expression_f		TV_DECI				expression_i	{$$=$1-$3;}
	|expression_i		TV_DECI				expression_f	{$$=$1-$3;}
	
	|expression_f		TV_MULT				expression_f	{$$=$1*$3;}
	|expression_f		TV_MULT				expression_i	{$$=$1*$3;}
	|expression_i		TV_MULT				expression_f	{$$=$1*$3;}
	
	|expression_f		TV_DIVI				expression_f	{if($3==0){yyerror("diveide by zero");}else{$$=$1/$3;}}
	|expression_f		TV_DIVI				expression_i	{if($3==0){yyerror("diveide by zero");}else{$$=$1/$3;}}
	|expression_i		TV_DIVI				expression_f	{if($3==0){yyerror("diveide by zero");}else{$$=$1/$3;}}

	|TV_XKBB 			expression_f		TV_XKEE		{$$=$2;}
	|TV_ADDI			expression_f		{$$=$2;}
	|TV_DECI			expression_f		{$$=-$2;}
	|TV_FLOT			{$$=$1;}
	;
statement_v:
	 expression_v
	 ;
expression_v:
	 expression_i		TV_ADDI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_i_addi_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_i		TV_ADDI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_i_addi_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_f		TV_ADDI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_f_addi_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_ADDI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_f_addi_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_x		TV_ADDI				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_addi_i(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_ADDI				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_addi_f(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_ADDI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_addi_v(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_ADDI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_addi_v(v0,v1,v3);
															 $$=v0;
															}
	|expression_v		TV_ADDI				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_addi_i(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_ADDI				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_addi_f(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_ADDI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_addi_v(v0,$1,$3);
															 $$=v0;
															}

	|expression_v		TV_ADDI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_addi_v(v0,v1,v3);
															 $$=v0;
															}

	
	
	
	
															
	|expression_i		TV_DECI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_i_deci_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_i		TV_DECI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_i_deci_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_DECI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_f_deci_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_DECI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_f_deci_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_x		TV_DECI				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_deci_i(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_DECI				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_deci_f(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_DECI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_deci_v(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_DECI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_deci_v(v0,v1,v3);
															 $$=v0;
															}
	|expression_v		TV_DECI				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_deci_i(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_DECI				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_deci_f(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_DECI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_deci_v(v0,$1,$3);
															 $$=v0;
															}

	|expression_v		TV_DECI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_deci_v(v0,v1,v3);
															 $$=v0;
															}
	
	
	
	
	|expression_i		TV_MULT				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_i_mult_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_i		TV_MULT				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_i_mult_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_MULT				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_f_mult_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_MULT				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_f_mult_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_x		TV_MULT				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_mult_i(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_MULT				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_mult_f(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_MULT				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_mult_v(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_MULT				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_mult_v(v0,v1,v3);
															 $$=v0;
															}
	|expression_v		TV_MULT				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_mult_i(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_MULT				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_mult_f(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_MULT				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_mult_v(v0,$1,$3);
															 $$=v0;
															}

	|expression_v		TV_MULT				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_mult_v(v0,v1,v3);
															 $$=v0;
															}
	
	
	
	
	
	|expression_i		TV_DIVI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_i_divi_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_i		TV_DIVI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_i_divi_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_DIVI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_f_divi_v(v0,$1,$3);
															 $$=v0;
															}
	|expression_f		TV_DIVI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_f_divi_v(v0,$1,v3);
															 $$=v0;
															}
	|expression_x		TV_DIVI				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_divi_i(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_DIVI				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_divi_f(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_DIVI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_v_divi_v(v0,v1,$3);
															 $$=v0;
															}
	|expression_x		TV_DIVI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_divi_v(v0,v1,v3);
															 $$=v0;
															}
	|expression_v		TV_DIVI				expression_i	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_divi_i(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_DIVI				expression_f	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_divi_f(v0,$1,$3);
															 $$=v0;
															}
	|expression_v		TV_DIVI				expression_v	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol_v_divi_v(v0,$1,$3);
															 $$=v0;
															}

	|expression_v		TV_DIVI				expression_x	{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
															 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_v_divi_v(v0,v1,v3);
															 $$=v0;
															}
	
	
	
	
	|TV_ADDI 			expression_x		{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
											 xsymbol* v2=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$2->name,0);
											 xsymbol_i_addi_v(v0,0,v2);
											 $$=v0;
											}
	|TV_DECI 			expression_x		{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
											 xsymbol* v2=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$2->name,0);
											 xsymbol_i_deci_v(v0,0,v2);
											 $$=v0;
											}
	|TV_ADDI 			expression_v		{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
											 xsymbol_i_addi_v(v0,0,$2);
											 $$=v0;
											}
	|TV_DECI 			expression_v		{xsymbol* v0=xsymbol_stack__new_xsymbol_temp(global_xsymbol_stack);
											 xsymbol_i_deci_v(v0,0,$2);
											 $$=v0;
											}
	|TV_XKBB 			expression_v		TV_XKEE			{$$=$2;}
	;
	

statement_x:
	 expression_x_local_asign 	{
								 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
								 switch(v1->type){
								 case xsymbol_type_0:printf("(%s)=(%s)\n",$1->name,"nil");break;
								 case xsymbol_type_i:printf("(%s)=(%d)\n",$1->name,v1->value.value_i);break;
								 case xsymbol_type_f:printf("(%s)=(%g)\n",$1->name,v1->value.value_f);break;
								 case xsymbol_type_s:printf("(%s)=(%s)\n",$1->name,v1->value.value_s);break;
								 }
								}
	|expression_x_asign	{
						 xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
						 switch(v1->type){
						 case xsymbol_type_0:printf("(%s)=(%s)\n",$1->name,"nil");break;
						 case xsymbol_type_i:printf("(%s)=(%d)\n",$1->name,v1->value.value_i);break;
						 case xsymbol_type_f:printf("(%s)=(%g)\n",$1->name,v1->value.value_f);break;
						 case xsymbol_type_s:printf("(%s)=(%s)\n",$1->name,v1->value.value_s);break;
						 }
						}
	|expression_x		{xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
						 switch(v1->type){
						 case xsymbol_type_0:printf("(%s)=(%s)\n",$1->name,"nil");break;
						 case xsymbol_type_i:printf("(%s)=(%d)\n",$1->name,v1->value.value_i);break;
						 case xsymbol_type_f:printf("(%s)=(%g)\n",$1->name,v1->value.value_f);break;
						 case xsymbol_type_s:printf("(%s)=(%s)\n",$1->name,v1->value.value_s);break;
						 }
						}
	;
expression_x_local_asign:
	 TV_LOCA			TV_NAME 			TV_ASGN 			expression_v	{xsymbol* v2=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$2->name,1);
																				 xsymbol_set_x(v2,$4);
																				 $$=$2;
																				}
	|TV_LOCA			TV_NAME				TV_ASGN				expression_i	{xsymbol* v2=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$2->name,1);
																				 xsymbol_set_i(v2,$4);
																				 $$=$2;
																				}
	|TV_LOCA			TV_NAME				TV_ASGN				expression_f	{xsymbol* v2=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$2->name,1);
																				 xsymbol_set_f(v2,$4);
																				 $$=$2;
																				}
	|TV_LOCA			TV_NAME 			TV_ASGN				TV_NAME			{xsymbol* v2=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$2->name,1);
																				 xsymbol* v4=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$4->name,1);
																				 xsymbol_set_x(v2,v4);
																				 $$=$2; 
																				}
	;

expression_x_asign:
	 TV_NAME			TV_ASGN				expression_v	{xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_set_x(v1,$3);
															 $$=$1;
															}
	|TV_NAME			TV_ASGN				expression_i	{xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_set_i(v1,$3);
															 $$=$1;
															}
	|TV_NAME			TV_ASGN				expression_f	{xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol_set_f(v1,$3);
															 $$=$1;
															}
	|TV_NAME 			TV_ASGN				TV_NAME			{xsymbol* v1=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$1->name,0);
															 xsymbol* v3=xsymbol_stack__new_xsymbol(global_xsymbol_stack,$3->name,0);
															 xsymbol_set_x(v1,v3);
															 $$=$1; 
															}
	;
expression_x:
	 TV_XKBB 			expression_x		TV_XKEE			{$$=$2;}
	|TV_NAME			{$$=$1;}
	;
%%
xsymbol_stack* global_xsymbol_stack;
xname_stack*   global_xname_stack;
main()
{
	extern mcode_lex_init();
	global_xname_stack=xname_stack__new(4096);
	global_xsymbol_stack=xsymbol_stack__new(4096);

	mcode_lex_init();
	
	printf(">");
	yyparse();

	xsymbol_stack__del(global_xsymbol_stack);
	global_xsymbol_stack=NULL;
	
	xname_stack__del(global_xname_stack);
	global_xname_stack=NULL;
}
int yyerror(const char *s) 
{
	fprintf(stderr, "error: %s\n", s); 
	return 0;
}