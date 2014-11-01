#include <iostream>
#include <stdlib.h>
#include "node.h"
#include <typeinfo>
#include "parser.hpp"

extern int yyparse();
extern FILE *yyin;

void StartParse(char *path)
{
	/*
	채워넣기
	*/
	yyin = fopen(path,"r");
	if(yyin == NULL)
	{
		fprintf(stderr," can't open %s\n",path);
		exit(1); 
	}
	if(yyparse() == 0) std::cout<<"PASS!"<<std::endl;	

}

int main(int argc, char** argv)
{
	if(argc != 2){
		printf("usage: parser filename\n");
		exit(1);
	}
	cout<<"Parsing..."<<endl;
	StartParse(argv[1]);
	return 0;
}

