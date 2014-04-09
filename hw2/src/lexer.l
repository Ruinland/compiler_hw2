%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
symtab * lookup();
symtab * ptr;
void     insertID();
void 	 printSymTab();
int i;
/* You need to define for all tokens in C--, here are some examples */
#define INT		10
#define FLOAT 		11 
#define OP_ASSIGN 	12 
#define OP_OR 		13 
#define MK_LPAREN 	14 
#define MK_RPAREN 	15 
#define ERROR 		100 

%}

letter   [A-Za-z]
digit    [0-9]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+

Flp  {digit}*\.{digit}+    
Exp  ([eE][+-]?{digit}+) 


/* You need to define the following RE's */

Float_constant  (({Flp}{Exp}?)|{digit}+{Exp})
String_constant  "\""([^"\\]|\\.)*"\""
Comment          ("/*"([^*]|[\r\n]|("*"([^*/]|[\r\n])))*"*"+"/")|("//".*)

OP_mul           "*" 
OP_assign        "="
OP_add           "+"
OP_sub           "-"
OP_div           "/" 
OP_or   "||"

/* Other operators appear here */ 


newline  "\n"

DL_lparen "("
DL_rparen ")"
DL_lbrace "{"
DL_rbrace "}"
DL_comma  ","
DL_semicol ";"
DL_dot  "."

/* Other separators appear here */


error    .

%%


{Int_constant}  {}

{Float_constant}  {}


{String_constant} {}

{Comment}       {  printf("%s\n", yytext);
                   for(i=0; yytext[i]!='\0'; i++ )
                      if(yytext[i] == '\n')
                          linenumber +=1;
                }  
{WS}            {}
{ID}            { 
                 if( strcmp(yytext,"return") && strcmp(yytext,"typedef") &&
                        strcmp(yytext,"if") && 
                        strcmp(yytext,"else") && 
                        strcmp(yytext,"int")  &&
                        strcmp(yytext,"float")  && 
                        strcmp(yytext,"for")  &&
                        strcmp(yytext,"struct") && 
                        strcmp(yytext,"union")  &&
                        strcmp(yytext,"while")
                ){  
			     ptr = lookup(yytext);
			     if (ptr == NULL)
			       insertID(yytext);	
			     else 
			       ptr->counter++;
                 }
		        }
{OP_assign}     {} 
{OP_add}        {}
{OP_sub}        {}  
{OP_mul}        {} 
{OP_div}        {}   
{OP_or}         {}  /* return OP_OR; */
{DL_lparen}     {} /* return MK_LPAREN; */
{DL_rparen}     {} /* return MK_RPAREN; */
{DL_lbrace}     {} /* return MK_LBRACE; */
{DL_rbrace}     {}   /* return MK_RBRACE; */
{DL_comma}      {}
{DL_semicol}    {}
{newline}       { linenumber += 1;}
{DL_dot}        {}
{error}         { printf("ERR at line %d , which is %s.\n Exiting...", linenumber+1, yytext); exit(1); }  /* return ERROR; */


%%

main(int argc, char **argv)
{
 argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   yylex();
   printSymTab();
}

