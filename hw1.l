%{
#ifndef _NODE_H
#define _NODE_H
#include "node.h"
#endif
#include "parser.hpp"
int line = 1;
char* yyval;
%}
%x COMMENTT
%option yylineno
%option noyywrap
%%
def	{yyval = yytext;return DEFF;}		 	
extern 	{yyval = yytext;return EXTERNN;}
[\-]	{return MINUSS;}
[\+]	{return PLUSS;}
[a-z]+[a-z0-9]*	 {yyval = yytext;return IDD;}		//id
(([0-9]+)|([0-9]*\.[0-9]+)) {yyval = yytext;return NUMBERR;}		//number
#([^\n])* {BEGIN COMMENTT;}
<COMMENTT>\n {BEGIN 0;}
[ \t]+ ;
\n {yyval = yytext;line++;}	
[^\n] {yyval = yytext;return yytext[0];}	//all symbol
%%
