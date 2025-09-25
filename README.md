### CashFlow — Entrega 1 (EBNF)

---

## 1) Ideia da linguagem

A CashFlow é uma linguagem em português, pensada para scripts de caixa eletrônico (ATM).

- Tipos: inteiro, booleano
- Estruturas: var, se/senao, enquanto
- ATM built-ins:
  - Statements: ler_pin(x), sacar(n), depositar(n), mensagem(cod), ejetar_cartao()
  - Funções: saldo() : inteiro, cartao_inserido() : booleano


---

## 2) Palavras-reservadas

programa, inicio, fim, var, inteiro, booleano, se, senao, enquanto, verdadeiro, falso, e, ou, nao, ler_pin, sacar, depositar, mensagem, ejetar_cartao, saldo, cartao_inserido

## 3) EBNF
``` ebnf

Programa   = "programa" Ident ";" Bloco ;

Bloco      = "inicio" { Declaracao | Comando } "fim" ;

Declaracao = "var" Ident ":" Tipo [ "=" Expressao ] ";" ;
Tipo       = "inteiro" | "booleano" ;

Comando    = Atribuicao ";"
           | Se
           | Enquanto
           | ComandoATM ";"
           | Bloco ;

Atribuicao = Ident "=" Expressao ;

Se         = "se" "(" Expressao ")" Bloco [ "senao" Bloco ] ;
Enquanto   = "enquanto" "(" Expressao ")" Bloco ;

ComandoATM = "ler_pin" "(" Ident ")"
           | "sacar" "(" Expressao ")"
           | "depositar" "(" Expressao ")"
           | "mensagem" "(" Expressao ")"
           | "ejetar_cartao" "(" ")" ;

Expressao  = ExpOu ;
ExpOu      = ExpE   { "ou" ExpE } ;
ExpE       = ExpCmp { "e"  ExpCmp } ;
ExpCmp     = ExpAdd { ( "==" | "!=" | "<" | "<=" | ">" | ">=" ) ExpAdd } ;
ExpAdd     = ExpMul { ( "+" | "-" ) ExpMul } ;
ExpMul     = ExpUn  { ( "*" | "/" | "%" ) ExpUn } ;
ExpUn      = [ "nao" | "-" ] Primario ;

Primario   = Numero
           | "verdadeiro" | "falso"
           | Ident
           | "saldo" "(" ")"
           | "cartao_inserido" "(" ")"
           | "(" Expressao ")" ;
```