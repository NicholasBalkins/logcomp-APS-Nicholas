%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct YYLTYPE;
union  YYSTYPE;

int  yylex (union YYSTYPE *yylval, struct YYLTYPE *yylloc);
void yyerror(struct YYLTYPE *loc, const char *s);
%}

%define parse.error detailed
%define api.pure full
%locations

%union {
  int    ival;
  char*  sval;
}

%token <ival> NUM
%token <sval> IDENT

%token PROGRAM INICIO FIM VAR TINTEIRO TBOOLEANO SE SENAO ENQUANTO
%token VERDADEIRO FALSO E OU NAO
%token LER_PIN SACAR DEPOSITAR MENSAGEM EJETAR_CARTAO SALDO CARTAO_INSERIDO

%token ASSIGN PLUS MINUS MUL DIV MOD
%token EQ NE LT LE GT GE
%token SEMI COLON COMMA LPAREN RPAREN
%token ERROR

%left OU
%left E
%nonassoc EQ NE LT LE GT GE
%left PLUS MINUS
%left MUL DIV MOD
%right UMINUS
%right NAO

%start programa

%%

programa
  : PROGRAM IDENT SEMI bloco                { printf("Programa valido.\n"); }
  ;

bloco
  : INICIO itens FIM
  ;

itens
  : %empty
  | itens item
  ;

item
  : declaracao
  | comando
  ;

declaracao
  : VAR IDENT COLON tipo opt_init SEMI
  ;

tipo
  : TINTEIRO
  | TBOOLEANO
  ;

opt_init
  : %empty
  | ASSIGN expressao
  ;

comando
  : atribuicao SEMI
  | se
  | enquanto
  | comando_atm SEMI
  | bloco
  ;

atribuicao
  : IDENT ASSIGN expressao
  ;

se
  : SE LPAREN expressao RPAREN bloco opt_senao
  ;

opt_senao
  : %empty
  | SENAO bloco
  ;

enquanto
  : ENQUANTO LPAREN expressao RPAREN bloco
  ;

comando_atm
  : LER_PIN LPAREN IDENT RPAREN
  | SACAR LPAREN expressao RPAREN
  | DEPOSITAR LPAREN expressao RPAREN
  | MENSAGEM LPAREN expressao RPAREN
  | EJETAR_CARTAO LPAREN RPAREN
  ;

expressao
  : exp_ou
  ;

exp_ou
  : exp_e
  | exp_ou OU exp_e
  ;

exp_e
  : exp_cmp
  | exp_e E exp_cmp
  ;

exp_cmp
  : exp_add
  | exp_add EQ exp_add
  | exp_add NE exp_add
  | exp_add LT exp_add
  | exp_add LE exp_add
  | exp_add GT exp_add
  | exp_add GE exp_add
  ;

exp_add
  : exp_mul
  | exp_add PLUS  exp_mul
  | exp_add MINUS exp_mul
  ;

exp_mul
  : exp_un
  | exp_mul MUL exp_un
  | exp_mul DIV exp_un
  | exp_mul MOD exp_un
  ;

exp_un
  : MINUS exp_un           %prec UMINUS
  | NAO   exp_un
  | primario
  ;

primario
  : NUM
  | VERDADEIRO
  | FALSO
  | IDENT
  | SALDO LPAREN RPAREN
  | CARTAO_INSERIDO LPAREN RPAREN
  | LPAREN expressao RPAREN
  ;

%%

void yyerror(YYLTYPE *loc, const char *msg) {
  fprintf(stderr, "Erro sintatico: %s (linha %d, coluna %d)\n",
          msg, loc->first_line, loc->first_column);
}

extern FILE *yyin;
int yyparse(void);

int main(int argc, char **argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("erro abrindo o arquivo"); return 1; }
  }
  int rc = yyparse();
  if (argc > 1 && yyin) fclose(yyin);
  return rc ? 1 : 0;
}