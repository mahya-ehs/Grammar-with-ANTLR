grammar proj;

//parser
start: codes* EOF;
codes: imports | class | var | object_instantiation | loops | if | switch_case | exception | constructor | function | print | expression;


//import section
imports: import_type1 | import_type2;

import_type1: 'import' library ';' ;
import_type2: 'from' ID('.'ID)* 'import' (library | '*') ';';

library: ID('=>'ID)?(','ID('=>'ID)?)* | ID('.'ID)*;

/*------------------------------------------------------------------------------------------*/

//variables
var: ACCESS? variables;

variables: variables1 | variables2 | variables3;

variables1: const_var ID ':' data_types ('='initial_value)? shortcut';' ;
variables2: 'const' ID (':' data_types )? '=' string shortcut ';';
variables3: const_var ID ':' 'new' 'Array' '['data_types']' '(' INTEGER_NUM ')' shortcut';'
| const_var ID '=' 'Array' '('(DOUBLE_NUM | INTEGER_NUM)(','(DOUBLE_NUM | INTEGER_NUM))*')' shortcut ';';

shortcut:
(',' ID ':' data_types ('='initial_value)?)*
(',' ID (':' data_types)? '='string)*
(',' ID ':' 'new' 'Array' '['data_types']' '(' INTEGER_NUM ')')*
(',' ID '=' 'Array' '('DOUBLE_NUM(','DOUBLE_NUM)*')')* ;

initial_value: BOOL | DOUBLE_NUM | INTEGER_NUM | string;
const_var: CONST | VAR;
data_types: 'Int' | 'Double' | 'Float' | 'Boolean' | 'String';
return_type: data_types | 'void';

/*------------------------------------------------------------------------------------------*/

//class
class: ACCESS? 'class' ID extends? implements? '{' class_body '}';
extends: 'extends' ID;
implements: 'implements' ID 'with' ID (',''with' ID)*;

class_body: (function | constructor | code)* ;

constructor: ACCESS? ID '('(argumant(','argumant)*)?')''{'(('this.'ID '=' ID';')| function_body)*'}';
argumant: data_types ID ('='initial_value)?;

/*------------------------------------------------------------------------------------------*/

//function
function: ACCESS? return_type ID '('( argumant(','argumant)*)?')''{'function_body*'}';
function_body: code return?;
return: 'return' (ID | STRING | INTEGER_NUM | DOUBLE_NUM) ';';

/*------------------------------------------------------------------------------------------*/

//instantiations
object_instantiation: const_var ID ':' 'new' (ID | data_types)'('((DOUBLE_NUM | INTEGER_NUM) (','(DOUBLE_NUM | INTEGER_NUM))*)?')'';';

/*------------------------------------------------------------------------------------------*/

//for loops    ---> ok
loops: while_loop | for_loop | do_while_loop;
while_loop: 'while' '('condition')' '{' code* '}';
for_loop: 'for''('(for_type1 | for_type2)')''{' code* '}' ;
for_type1: ('var')? ID 'in' ID;
for_type2: initialization ';' condition+ ';' inc_dec;
do_while_loop: 'do''{' code* '}''while''(' condition')';

initialization: expression*;
inc_dec: ID (INCREMENT | DECREMENT);

/*------------------------------------------------------------------------------------------*/

//conditional senteces   ----> ok
if: 'if' '(' condition ')' '{' code* '}' elseif* else?;
else: 'else' '{' code* '}';
elseif: 'elif' '(' condition')' '{' code*'}';

condition: BOOL | ID | expression;

/*------------------------------------------------------------------------------------------*/

//switch case   ----> ok
switch_case: 'switch' '(' (ID | STRING) ')' '{' (case+ default?)'}';
case: 'case' (ID | STRING | BOOL | expression) ':' code* ('break' ';')? ;
default: 'default' ':' code* ('break')? ;

/*------------------------------------------------------------------------------------------*/

//expressions (priorities)
expression : '(' expression ')'
 | expression '[' expression ']'
 | expression POWER expression
 | COMPLEMENT expression
 | PLUS expression
 | MINUS expression
 | expression (INCREMENT  | DECREMENT)
 | expression (STAR | SLASH | MODULUS | FLOOR_DIVISION) expression
 | expression (PLUS | MINUS) expression
 | expression (LEFT_SHIFT | RIGHT_SHIFT) expression
 | expression (AND_BINARY | OR_BINARY | XOR_BINARY) expression
 | expression (DOUBLE_EQUAL | NOT_EQUAL | NOT_EQUAL2) expression
 | expression (GREATER | LESS | GREATER_EQ | LESS_EQ) expression
 | expression (AND | OR ) expression
 | NOT expression
 | expression (EQUAL | operator_equal) expression
 | (DOUBLE_NUM | INTEGER_NUM)
 | ID | STRING;

operator_equal: '**=' | '<<=' | '>>=' | '+=' |'*=' | '-=' | '/=' | '//=' |'%=' | '~=' | '&='| '|=' | '^=';

/*------------------------------------------------------------------------------------------*/

//other codes

//print
print: 'print''('((string) | ID | DOUBLE_NUM)(','string | ','ID | ','DOUBLE_NUM)*')'';';

//getter setter add
add: ID'.add''('values')'';';
values: ID('.'ID)? | ID(','ID)* | STRING | INTEGER_NUM | DOUBLE_NUM;

/*------------------------------------------------------------------------------------------*/

//exceptions  ---> ok
exception: try catch_ex*;
try: 'try' '{' code* '}';
catch_ex: 'on' ID ('catch' '(' ID ')')? '{' code* '}' | 'catch' '(' ID ')''{' code* '}';

/*------------------------------------------------------------------------------------------*/

code : var | object_instantiation | print | exception | expression ';'? | switch_case | if | loops | add;

/*------------------------------------------------------------------------------------------*/

//string interpolation
string: interpolation*;
interpolation:STRING;

/*--------------------------------------------------------------------------------------------*/

//lexer rules
SINGLE_COMMENT: '//' ~[\r\n]+ -> channel(HIDDEN) ;
WHITESPACE: [ \t\r\n]+ -> skip;
MULTI_COMMENT : '/*' .*? '*/' -> skip ;


//fragments
fragment LETTERS: [a-zA-Z];
fragment DIGITS: [0-9];
fragment UNDERLINE: '_';
fragment UNARY: '-';
fragment STR: '${' ID '}';

//keywords and signs
IMPORT: 'import';
FROM: 'from';
VAR: 'var';
CONST: 'const';
VOID: 'void';
ARRAY: 'Array';
NEW: 'new';
CLASS: 'class';
EXTENDS: 'extends';
IMPLEMENTS: 'implements';
WITH: 'with';
THIS: 'this';
FOR: 'for';
WHILE: 'while';
DO: 'do';
IF: 'if';
ELSE: 'else';
ELSEIF: 'elseif';
IN: 'in';
SWITCH: 'switch';
CASE: 'case';
DEFAULT: 'default';
BREAK: 'break';
ADD: 'add';
PRINT: 'print';
TRY: 'try';
CATCH_EXCEPTION: 'catch';
POWER: '**';
COMPLEMENT: '~';
STAR: '*';
SLASH : '/' ;
FLOOR_DIVISION: '//';
PLUS : '+' ;
MINUS : '-' ;
MODULUS: '%';
LEFT_SHIFT: '<<';
RIGHT_SHIFT: '>>';
AND_BINARY: '&';
OR_BINARY: '|';
XOR_BINARY: '^';
INCREMENT: '++';
DECREMENT: '--';
DOUBLE_EQUAL: '==';
EQUAL: '=';
NOT_EQUAL: '!=';
NOT_EQUAL2: '<>';
GREATER: '>';
LESS: '<';
GREATER_EQ: '>=';
LESS_EQ: '<=';
AND: '&&';
OR: '||';
NOT: '!';
PAR_L: '(';
PAR_R: ')';
DOLLAR_SIGN: '$';
SEMI: ';';
COLON: ':';

ACCESS: ('private' | 'protected' | 'public')' '*('static' | 'final')?;
BOOL: 'true' | 'false';

STRING: '"' ~('$' | '{' | '}')+ '"';

ID: [a-zA-Z][a-zA-Z_$0-9][a-zA-Z_$0-9]*;
INTEGER_NUM: UNARY? DIGITS+;
DOUBLE_NUM : (UNARY | '.')? DIGITS+ ('.' DIGITS+)? ('e-'DIGITS+)?;
