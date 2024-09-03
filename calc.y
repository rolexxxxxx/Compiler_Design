%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int top=-1;
struct Symbol_Table
{
	char sym_name[10];
	char sym_type[10];
	int value;
}Sym[10];

int sym_cnt=0;
int search_symbol(char []);
void make_symtab_entry(char [],char [],double);
void display_sym_tab();
void push();
void pusha();
void codegen();
void codegen_assign();
void if1();
void if3();
void ifelse1();
void ifelse2();
void ifelse3();
void while1();
void while2();
void while3();


int yyerror(const char *s);
extern int yylex(); // Declare yylex function
extern char* identifier_value; // Declare identifier_value as an external variable
extern int yylval; // Declare yylval as an external variable
extern char *yytext;

%}

%token IF ELSE INT PRINTF RETURN SCANF WHILE PLUS MINUS MULTIPLY DIVIDE ASSIGN EQUAL NOTEQUAL LESS GREATER LESSEQUAL GREATEREQUAL LPAREN RPAREN LBRACE RBRACE SEMICOLON NUMBER MAIN STRING IDENTIFIER

%left '+' '-'
%left '*' '/'

%%
program : INT MAIN LPAREN RPAREN LBRACE statement_list RBRACE
        ;
        
statement_list : statement
               | statement_list statement
               ;

statement : expression_statement
          | if_statement
          | while_statement
          | declaration_statement
          | print_statement
          | scan_statement
          | ret_statement
          ;

expression_statement : expression SEMICOLON { ; }
                      ;

expression : IDENTIFIER {pusha();} ASSIGN {push();} expression {codegen_assign();}
           | simple_expression { $$ = $1; }
           | STRING { ;}
           | expression expression
           ;

simple_expression : additive_expression
                  | simple_expression EQUAL {push();} additive_expression { $$ = ($1 == $3) ? 1 : 0; codegen();}
                  | simple_expression NOTEQUAL {push();} additive_expression { $$ = ($1 != $3) ? 1 : 0; codegen();}
                  | simple_expression LESS {push();} additive_expression { $$ = ($1 < $3) ? 1 : 0; codegen();}
                  | simple_expression GREATER {push();} additive_expression { $$ = ($1 > $3) ? 1 : 0; codegen();}
                  | simple_expression LESSEQUAL {push();} additive_expression { $$ = ($1 <= $3) ? 1 : 0; codegen();}
                  | simple_expression GREATEREQUAL {push();} additive_expression { $$ = ($1 >= $3) ? 1 : 0; codegen();}
                  ;

additive_expression : multiplicative_expression
                     | additive_expression PLUS {push();} multiplicative_expression { $$ = $1 + $3; codegen();}
                     | additive_expression MINUS {push();} multiplicative_expression { $$ = $1 - $3; codegen();}
                     ;

multiplicative_expression : primary_expression
                           | multiplicative_expression MULTIPLY {push();} primary_expression { $$ = $1 * $3; codegen();}
                           | multiplicative_expression DIVIDE {push();} primary_expression { $$ = $1 / $3; codegen();}
                           ;

primary_expression : IDENTIFIER { $$ = atoi(identifier_value); pusha();}
                    | NUMBER { $$ = yylval; push();}
                    | LPAREN expression RPAREN { $$ = $2; }
                    ;

if_statement : IF LPAREN expression RPAREN {ifelse1();} LBRACE statement_list RBRACE {ifelse2();} ELSE LBRACE statement_list RBRACE {ifelse3();}
      	     | IF LPAREN expression RPAREN {if1();} LBRACE statement_list RBRACE {if3();}
             ;

while_statement : WHILE {while1();} LPAREN expression RPAREN {while2();} LBRACE statement_list RBRACE {while3();}
                ;

declaration_statement : INT IDENTIFIER SEMICOLON {make_symtab_entry(identifier_value,"int",0);}
                       ;

print_statement : PRINTF LPAREN expression RPAREN SEMICOLON
                ;

scan_statement : SCANF LPAREN expression RPAREN SEMICOLON
               ;

ret_statement : RETURN expression_statement
	      ;


%%
char st[100][100];

int temp_i=0;
char tmp_i[3];
char temp[2]="t";
int label[20];
int lnum=0;
int ltop=0;
int l_while[10]={0,0,0,0,0,0,0,0,0,0};
int wtop=0;

extern FILE *yyin;
int yyerror(const char *s) {
    printf("Parse error: %s\n", s);
    return 0;
}

int main(){
	yyin = fopen("input.txt","r");
	if(yyparse()==0)
	{
		printf("\n\nParse Success\n");
	}
	display_sym_tab();
	printf("\n\n");
	return 0;
}
int search_symbol(char sym[10])
{
	int i,flag=0;
	for(i=0;i<sym_cnt;i++)
	{
		if(strcmp(Sym[i].sym_name,sym)==0)
		{
			flag=1;
			break;
		}
	}
	if(flag==0)
		return(-1);
	else
		return(i);
}
void make_symtab_entry(char sym[10],char dtype[10],double val)
{
	strcpy(Sym[sym_cnt].sym_name,sym);
	strcpy(Sym[sym_cnt].sym_type,dtype);
	Sym[sym_cnt].value=val;
	sym_cnt++;
}
void display_sym_tab()
{
	int i;
	printf("\n\n The Symbol Table \n\n");
	printf("Name\t\tType\tValue");
	for(i=0;i<sym_cnt;i++)
		printf("\n%s\t\t%s\t%d",Sym[i].sym_name,Sym[i].sym_type,Sym[i].value);
}
void push()
{
strcpy(st[++top],yytext);
}
void pusha()
{
strcpy(st[++top],identifier_value);
}

void codegen()
{
    strcpy(temp,"T");
    sprintf(tmp_i, "%d", temp_i);
    strcat(temp,tmp_i);
    printf("%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
    top-=2;
    strcpy(st[top],temp);

temp_i++;
}


void codegen_assign()
{
    printf("%s = %s\n",st[top-2],st[top]);
    top-=3;
}

void if1()
{
 lnum++;
 strcpy(temp,"T");
 sprintf(tmp_i, "%d", temp_i);
 strcat(temp,tmp_i);
 printf("if %s goto L%d\n",temp,lnum);
 temp_i++;
 label[++ltop]=lnum;
}

void if3()
{
    int y;
    y=label[ltop--];
    printf("L%d: \n",y);
    
}

void ifelse1()
{
    lnum++;
    strcpy(temp,"T");
    sprintf(tmp_i, "%d", temp_i);
    strcat(temp,tmp_i);
    printf("if %s goto L%d\n",st[top],lnum);
    label[++ltop]=lnum;
}

void ifelse2()
{
    int x;
    lnum++;
    x=label[ltop--];
    printf("goto L%d\n",lnum);
    printf("L%d: \n",x);
    label[++ltop]=lnum;
}

void ifelse3()
{
	int y;
	y=label[ltop--];
	printf("L%d: \n",y);
	lnum++;
}


void while1()
{

    l_while[wtop++] = ++lnum;
    printf("L%d: \n",lnum);
 
}

void while2()
{
 strcpy(temp,"T");
 sprintf(tmp_i, "%d", temp_i);
 strcat(temp,tmp_i);
    printf("if %s goto L%d\n",st[top],++lnum);
    printf("goto L%d\n", lnum + 1);
    printf("L%d:\n", lnum);
    lnum++;
 }

void while3()
{

printf("goto L%d \n",l_while[--wtop]);
    printf("L%d: \n",lnum++);
}

