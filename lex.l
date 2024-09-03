%{
#include "y.tab.h"
extern char *yytext;
extern int yylval;
int num_value; 
char *identifier_value; 
%}

%%

"main"	    { return MAIN; }
"if"        { return IF; }
"else"      { return ELSE; }
"int"       { return INT; }
"printf"    { return PRINTF; }
"return"    { return RETURN; }
"scanf"     { return SCANF; }
"while"     { return WHILE; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULTIPLY; }
"/"         { return DIVIDE; }
"="         { return ASSIGN; }
"=="        { return EQUAL; }
"!="        { return NOTEQUAL; }
"<"         { return LESS; }
">"         { return GREATER; }
"<="        { return LESSEQUAL; }
">="        { return GREATEREQUAL; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
\".*\"      { return STRING; }
","	    {;}
"&"         {;}

[0-9]+      { yylval = atoi(yytext); return NUMBER; } 
[a-zA-Z][a-zA-Z0-9]*    { identifier_value = strdup(yytext); return IDENTIFIER; } 
[ \t \n]+    ;  


.           { printf("Unknown character: %d\n", yytext[0]); }
%%

int yywrap() {
    return 1;
}
