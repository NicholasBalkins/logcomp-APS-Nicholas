%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "bison.tab.h"

void yyerror(YYLTYPE *loc, const char *msg);

%}

%option noyywrap
%option yylineno
%option nodefault
%option bison-bridge
%option bison-locations
%option noinput
%option nounput

DIG      [0-9]
ID_HEAD  [A-Za-z_]
ID_TAIL  [A-Za-z0-9_]
WS       [ \t\r]+

%%

{WS}                                 { }
\n                                   { }

"programa"           { return PROGRAM; }
"inicio"             { return INICIO; }
"fim"                { return FIM; }
"var"                { return VAR; }
"inteiro"            { return TINTEIRO; }
"booleano"           { return TBOOLEANO; }
"se"                 { return SE; }
"senao"              { return SENAO; }
"enquanto"           { return ENQUANTO; }
"verdadeiro"         { return VERDADEIRO; }
"falso"              { return FALSO; }
"e"                  { return E; }
"ou"                 { return OU; }
"nao"                { return NAO; }

"ler_pin"            { return LER_PIN; }
"sacar"              { return SACAR; }
"depositar"          { return DEPOSITAR; }
"mensagem"           { return MENSAGEM; }
"ejetar_cartao"      { return EJETAR_CARTAO; }

"saldo"              { return SALDO; }
"cartao_inserido"    { return CARTAO_INSERIDO; }

{DIG}+               { yylval->ival = atoi(yytext); return NUM; }
{ID_HEAD}{ID_TAIL}*  { yylval->sval = strdup(yytext); return IDENT; }

"=="                 { return EQ; }
"!="                 { return NE; }
"<="                 { return LE; }
">="                 { return GE; }
"<"                  { return LT; }
">"                  { return GT; }
"="                  { return ASSIGN; }
"+"                  { return PLUS; }
"-"                  { return MINUS; }
"*"                  { return MUL; }
"/"                  { return DIV; }
"%"                  { return MOD; }
";"                  { return SEMI; }
":"                  { return COLON; }
","                  { return COMMA; }
"("                  { return LPAREN; }
")"                  { return RPAREN; }

.                    {
  char buf[128];
  snprintf(buf, sizeof(buf), "símbolo invalido: '%s'", yytext);
  yyerror(NULL, buf);
  return ERROR;
}

%%