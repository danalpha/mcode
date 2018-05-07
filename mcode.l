%option noyywrap
%{
#include "mcode.tab.h"
#include "mcode.xname.h"
#include "mcode.xsymbol.h"
enum  mcode_keyword{
		V_IFIF,
		V_THEN,
		V_ELSE,
		V_ELIF,
		V_ENDD,
		V_LOCA,
		V_FUNC,
		V_RETN,
		V_TABL,
		V_TRUE,
		V_FALS,
		V_NILL,
		V_FORR,
		V_WHIL,
		V_DODO,
		V_ININ,
		V_BREK,
		V_GOTO,
		V_REAP,
		V_NAME,
		V_FLOT,
		V_INTT,
		V_TEXT,
		V_DOTT,
		V_ASGN,
		V_SEMI,
		V_COMA,
		V_KONG,
		V_LINE,
		V_XKBB,
		V_XKEE,
		V_ZKBB,
		V_ZKEE,
		V_DKBB,
		V_DKEE,
		V_ADDI,
		V_DECI,
		V_MULT,
		V_DIVI,
		V_MODI,
		V_NEQU,
		V_NOTT,
		V_EQUL,
		V_GTEQ,
		V_GTHN,
		V_LTEQ,
		V_LTHN,
		V_ANDI,
		V_ORRR,
		V_BAND,
		V_BORR,
		V_BNOT,
		V_BXOR,
		V_ERRR,
	};
void mcode_lex_do(enum mcode_keyword keyword);
#define MCODE_LEX_DO(code)	mcode_lex_do(code);return T##code;
%}
%%
(\")(([^\\\"])*((\\\\)*(\\\"))*)*(\")	{MCODE_LEX_DO(V_TEXT);}
(\')(([^\\\'])*((\\\\)*(\\\'))*)*(\')	{MCODE_LEX_DO(V_TEXT);}
([A-Za-z_])+([A-Za-z_0-9])*				{
										if(strcmp(yytext,"if")==0)
										{MCODE_LEX_DO(V_IFIF);}
										else if(strcmp(yytext,"then")==0)
										{MCODE_LEX_DO(V_THEN);}
										else if(strcmp(yytext,"else")==0)
										{MCODE_LEX_DO(V_ELSE);}
										else if(strcmp(yytext,"elif")==0)
										{MCODE_LEX_DO(V_ELIF);}
										else if(strcmp(yytext,"end")==0)
										{MCODE_LEX_DO(V_ENDD);}
										else if(strcmp(yytext,"and")==0)
										{MCODE_LEX_DO(V_ANDI);}
										else if(strcmp(yytext,"or")==0)
										{MCODE_LEX_DO(V_ORRR);}
										else if(strcmp(yytext,"not")==0)
										{MCODE_LEX_DO(V_NOTT);}
										else if(strcmp(yytext,"b_and")==0)
										{MCODE_LEX_DO(V_BAND);}
										else if(strcmp(yytext,"b_or")==0)
										{MCODE_LEX_DO(V_BORR);}
										else if(strcmp(yytext,"b_not")==0)
										{MCODE_LEX_DO(V_BNOT);}
										else if(strcmp(yytext,"b_xor")==0)
										{MCODE_LEX_DO(V_BXOR);}
										else if(strcmp(yytext,"local")==0)
										{MCODE_LEX_DO(V_LOCA);}
										else if(strcmp(yytext,"function")==0)
										{MCODE_LEX_DO(V_FUNC);}
										else if(strcmp(yytext,"return")==0)
										{MCODE_LEX_DO(V_RETN);}
										else if(strcmp(yytext,"true")==0)
										{MCODE_LEX_DO(V_TRUE);}
										else if(strcmp(yytext,"false")==0)
										{MCODE_LEX_DO(V_FALS);}
										else if(strcmp(yytext,"nil")==0)
										{MCODE_LEX_DO(V_NILL);}
										else if(strcmp(yytext,"table")==0)
										{MCODE_LEX_DO(V_TABL);}
										else if(strcmp(yytext,"for")==0)
										{MCODE_LEX_DO(V_FORR);}
										else if(strcmp(yytext,"while")==0)
										{MCODE_LEX_DO(V_WHIL);}
										else if(strcmp(yytext,"do")==0)
										{MCODE_LEX_DO(V_DODO);}
										else if(strcmp(yytext,"in")==0)
										{MCODE_LEX_DO(V_ININ);}
										else if(strcmp(yytext,"break")==0)
										{MCODE_LEX_DO(V_BREK);}
										else if(strcmp(yytext,"goto")==0)
										{MCODE_LEX_DO(V_GOTO);}
										else if(strcmp(yytext,"repeat")==0)
										{MCODE_LEX_DO(V_REAP);}
										else
										{MCODE_LEX_DO(V_NAME);}
										}
([0-9])+(\.)([0-9])*					{MCODE_LEX_DO(V_FLOT);}
([0-9])+								{MCODE_LEX_DO(V_INTT);}
(0x)([0-9A-Fa-f])+						{MCODE_LEX_DO(V_INTT);}
(0X)([0-9A-Fa-f])+						{MCODE_LEX_DO(V_INTT);}
[\.]									{MCODE_LEX_DO(V_DOTT);}
[\+]									{MCODE_LEX_DO(V_ADDI);}
[\-]									{MCODE_LEX_DO(V_DECI);}
[\*]									{MCODE_LEX_DO(V_MULT);}
[\/]									{MCODE_LEX_DO(V_DIVI);}
[\%]									{MCODE_LEX_DO(V_MODI);}
	
(\~\=)									{MCODE_LEX_DO(V_NEQU);}
(\!\=)									{MCODE_LEX_DO(V_NEQU);}
(\!)									{MCODE_LEX_DO(V_NOTT);}
(\=\=)									{MCODE_LEX_DO(V_EQUL);}
(\>\=)									{MCODE_LEX_DO(V_GTEQ);}
(\>)									{MCODE_LEX_DO(V_GTHN);}
(\<\=)									{MCODE_LEX_DO(V_LTEQ);}
(\<)									{MCODE_LEX_DO(V_LTHN);}
(\=)									{MCODE_LEX_DO(V_ASGN);}
(\&\&)									{MCODE_LEX_DO(V_ANDI);}
(\|\|)									{MCODE_LEX_DO(V_ORRR);}
	
(\~)									{MCODE_LEX_DO(V_BNOT);}
(\&)									{MCODE_LEX_DO(V_BAND);}
(\|)									{MCODE_LEX_DO(V_BORR);}
(\^)									{MCODE_LEX_DO(V_BXOR);}
	
(\;)									{MCODE_LEX_DO(V_SEMI);}
(\,)									{MCODE_LEX_DO(V_COMA);}
([\t ])+								{MCODE_LEX_DO(V_KONG);}
(\()									{MCODE_LEX_DO(V_XKBB);}
(\))									{MCODE_LEX_DO(V_XKEE);}
(\[)									{MCODE_LEX_DO(V_ZKBB);}
(\])									{MCODE_LEX_DO(V_ZKEE);}
(\{)									{MCODE_LEX_DO(V_DKBB);}
(\})									{MCODE_LEX_DO(V_DKEE);}
(\n)									{MCODE_LEX_DO(V_LINE);}
.  										{MCODE_LEX_DO(V_ERRR);}

%%
typedef struct{
	const char* desc;
	const char* desc2;
}mcode_keyword_desc_struct;
mcode_keyword_desc_struct mcode_keyword_desc[256];
void mcode_keyword_desc_init_detail(int pos,const char* v_desc,const char* v_desc2)
{
	mcode_keyword_desc[pos].desc=v_desc;
	mcode_keyword_desc[pos].desc2=v_desc2;
}
void mcode_keyword_desc_init(){
	mcode_keyword_desc_init_detail(V_IFIF,"V_IFIF","if");
	mcode_keyword_desc_init_detail(V_THEN,"V_THEN","then");
	mcode_keyword_desc_init_detail(V_ELSE,"V_ELSE","else");
	mcode_keyword_desc_init_detail(V_ELIF,"V_ELIF","elif");
	mcode_keyword_desc_init_detail(V_ENDD,"V_ENDD","end");
	mcode_keyword_desc_init_detail(V_LOCA,"V_LOCA","local");
	mcode_keyword_desc_init_detail(V_FUNC,"V_FUNC","function");
	mcode_keyword_desc_init_detail(V_RETN,"V_RETN","return");
	mcode_keyword_desc_init_detail(V_TABL,"V_TABL","table");
	mcode_keyword_desc_init_detail(V_TRUE,"V_TRUE","true");
	mcode_keyword_desc_init_detail(V_FALS,"V_FALS","false");
	mcode_keyword_desc_init_detail(V_NILL,"V_NILL","nil");
	mcode_keyword_desc_init_detail(V_FORR,"V_FORR","for");
	mcode_keyword_desc_init_detail(V_WHIL,"V_WHIL","while");
	mcode_keyword_desc_init_detail(V_DODO,"V_DODO","do");
	mcode_keyword_desc_init_detail(V_ININ,"V_ININ","in");
	mcode_keyword_desc_init_detail(V_BREK,"V_BREK","break");
	mcode_keyword_desc_init_detail(V_GOTO,"V_GOTO","goto");
	mcode_keyword_desc_init_detail(V_REAP,"V_REAP","repeat");
	mcode_keyword_desc_init_detail(V_NAME,"V_NAME","");
	mcode_keyword_desc_init_detail(V_FLOT,"V_FLOT","");
	mcode_keyword_desc_init_detail(V_INTT,"V_INTT","");
	mcode_keyword_desc_init_detail(V_TEXT,"V_TEXT","");
	mcode_keyword_desc_init_detail(V_DOTT,"V_DOTT",".");
	mcode_keyword_desc_init_detail(V_ASGN,"V_ASGN","=");
	mcode_keyword_desc_init_detail(V_SEMI,"V_SEMI",";");
	mcode_keyword_desc_init_detail(V_COMA,"V_COMA",",");
	mcode_keyword_desc_init_detail(V_KONG,"V_KONG"," ");
	mcode_keyword_desc_init_detail(V_LINE,"V_LINE"," ");
	mcode_keyword_desc_init_detail(V_XKBB,"V_XKBB","(");
	mcode_keyword_desc_init_detail(V_XKEE,"V_XKEE",")");
	mcode_keyword_desc_init_detail(V_ZKBB,"V_ZKBB","[");
	mcode_keyword_desc_init_detail(V_ZKEE,"V_ZKEE","]");
	mcode_keyword_desc_init_detail(V_DKBB,"V_DKBB","{");
	mcode_keyword_desc_init_detail(V_DKEE,"V_DKEE","}");
	mcode_keyword_desc_init_detail(V_ADDI,"V_ADDI","+");
	mcode_keyword_desc_init_detail(V_DECI,"V_DECI","-");
	mcode_keyword_desc_init_detail(V_MULT,"V_MULT","*");
	mcode_keyword_desc_init_detail(V_DIVI,"V_DIVI","/");
	mcode_keyword_desc_init_detail(V_MODI,"V_MODI","%");
	mcode_keyword_desc_init_detail(V_NEQU,"V_NEQU","!=");
	mcode_keyword_desc_init_detail(V_NOTT,"V_NOTT","!");
	mcode_keyword_desc_init_detail(V_EQUL,"V_EQUL","==");
	mcode_keyword_desc_init_detail(V_GTEQ,"V_GTEQ",">=");
	mcode_keyword_desc_init_detail(V_GTHN,"V_GTHN",">");
	mcode_keyword_desc_init_detail(V_LTEQ,"V_LTEQ","<=");
	mcode_keyword_desc_init_detail(V_LTHN,"V_LTHN","<");
	mcode_keyword_desc_init_detail(V_ANDI,"V_ANDI","&&");
	mcode_keyword_desc_init_detail(V_ORRR,"V_ORRR","||");
	mcode_keyword_desc_init_detail(V_BAND,"V_BAND","&");
	mcode_keyword_desc_init_detail(V_BORR,"V_BORR","|");
	mcode_keyword_desc_init_detail(V_BNOT,"V_BNOT","~");
	mcode_keyword_desc_init_detail(V_BXOR,"V_BXOR","^");
	mcode_keyword_desc_init_detail(V_ERRR,"V_ERRR","");
}
void mcode_lex_do(enum mcode_keyword keyword)
{
	extern xname_stack* global_xname_stack;
	
	const char* desc=mcode_keyword_desc[keyword].desc;
	int 		len =yyleng;
	const char* text=yytext;
	if(mcode_keyword_desc[keyword].desc2[0]!=0){text=mcode_keyword_desc[keyword].desc2;}
	
	printf("%s:% 4d:  %s\n",desc,len,text);
	switch(keyword)
	{
	case V_ERRR:yyerror(text);break;
	case V_NAME:yylval.value_x=xname_stack__new_xname(global_xname_stack,text);break;
	case V_INTT:yylval.value_i=atoi(text);break;
	case V_FLOT:yylval.value_f=atof(text);break;
	}
}
void mcode_lex_init()
{
	mcode_keyword_desc_init();
}
//void main(int argc,char** argv)
//{
//	mcode_lex_init();
//    if(argc>1){
//        yyin=fopen(argv[1],"r");
//    }else{
//        yyin=stdin;
//    }
//    yylex();
//}
