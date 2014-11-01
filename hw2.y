%{
#include <iostream>
#include <string>
#ifndef _NODE_H
#define _NODE_H 
#include "node.h"
#endif

int yylex(void);
void yyerror(const char*);
using namespace std;
extern int line;
extern A_TopList* aroot
#define YYERROR_VERBOSE 1

%}


%union
{
	A_TopList* topList;
	A_Top* top;
	A_Prototype* proto;
	A_Definition* def;
	A_Identifier* id;
	A_Expr* exp;
	A_NumberExpr* num;
	A_VariableExpr* var;
	A_BinaryExpr* bin;
	A_CallExpr* call;
	A_External* external;
	vector<A_Identifier*>* identList;	
	A_TopList* expressionList;
	char Str;
	double val;	
}

%type <expressionList> expressionList
%type <topList> topList 
%type <top> top
%type <proto> prototype
%type <def> definition
%type <id> identifier
%type <exp> expression
%type <num> numberExpr
%type <var> variableExpr
%type <bin> binaryExpr
%type <call> callExpr
%type <external> external
%type <identList> identifierList
%token <Str> IDD PLUSS MINUSS STARR DEFF EXTERNN COMMNETT
%token <val> NUMBERR

%start program
%locations

%%

program : topList{aroot=$1;};
topList : top ';'{$$ = new A_TopList; $$->push_back($1);}
	|topList top ';'{$$=$1;$1->push_back($2);};
top : definition{$$=$1;}
	|external{$$=$1;}
	|expression{$$=$1;}
	;
definition : DEFF prototype expression{$$=new A_Definition(*$2,*$3);}
	;
prototype : identifier '('')'{$$=new A_Prototype(*$1,0);}
	|identifier'('identifierList')'{$$=new A_Prototype(*$1,$3)}
	;
identifier : IDD{char* d = &$1;string tmp=d;$$=new A_Identifier(tmp);}
	;
identifierList : identifier{$$=new vector<A_Identifier*>;$$->push_back($1);}
	|identifierList ',' identifier{$$=$1;$$->push_back($3);}
	;
expression : numberExpr{$$=$1;}
	|variableExpr{$$=$1;}
	|binaryExpr{$$=$1;}
	|callExpr{$$=$1;}
	|'('expression')'{$$=$2;}
	;
numberExpr : NUMBERR{$$=new A_NumberExpr($1);}
	| PLUSS NUMBERR{$$=new A_NumberExpr($2);}
	|MINUSS NUMBERR{$$=new A_NumberExpr(-$2);}
	;
variableExpr : identifier{$$=new A_VariableExpr(*$1);};
binaryExpr : expression PLUSS expression{$$=new A_BinaryExpr($2,*$1,*$3);}
	|expression MINUSS expression{$$=new A_BinaryExpr($2,*$1,*$3);}
	|expression '*' expression{/*$$=new A_BinaryExpr($2,*$1,*$3*/);}
	;
callExpr : identifier '('')'{$$=new A_CallExpr(*$1,NULL);}
	|identifier'('expressionList')'{$$=new A_CallExpr(*$1,$3);}
	;
expressionList : expression{$$=new A_TopList;$$->push_back($1);}
	|expressionList','expression{$$=$1;$$;$$->push_back($3);}
	;
external : EXTERNN prototype{$$=new A_External(*$2);}
	;

%%

void yyerror(const char* s)
{
	cout<<"FAIL!"<<endl;
//	cout<<"ERROR: line "<<line<<endl;
	cout<<s<<endl;
	
}
