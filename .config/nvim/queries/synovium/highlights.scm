;; ============================================================================
;; SYNOVIUM HIGHLIGHTS (AST-Aligned & Hierarchy Fixed)
;; ============================================================================

;; 1. Global Fallbacks (Lowest Priority)
;; ----------------------------------------------------------------------------
;; Catch-all for identifiers. Must be at the top so specific rules override it!
(identifier) @variable

;; 2. Literals & Primitives
;; ----------------------------------------------------------------------------
(int_lit) @constant.numeric.integer
(float_lit) @constant.numeric.float
(string_lit) @string
(char_lit) @character
["true" "false"] @constant.builtin.boolean

;; 3. Keywords, Operators, Punctuation
;; ----------------------------------------------------------------------------
[
    "struct" "enum" "impl" "fnc" 
    "ret" "yld" "brk" 
    "loop" "if" "elif" "else" 
    "match" "as"
] @keyword

[
    ":=" "=" "~=" "+=" "-=" "*=" "/=" "%="
    "==" "!=" "<" "<=" ">" ">="
    "+" "-" "*" "/" "%"
    "|" "&" "^" "<<" ">>"
    "||" "&&" "..." "?" "->"
] @operator

[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket
[ "." "," ";" ":" ] @punctuation.delimiter

(comment) @comment

;; 4. Types
;; ----------------------------------------------------------------------------
(struct_decl name: (identifier) @type)
(enum_decl name: (identifier) @type)
(impl_decl name: (identifier) @type)

;; Catches all types in parameters, variables, and return types
(type_identifier (identifier) @type)

;; 5. Functions & Methods
;; ----------------------------------------------------------------------------
;; Function Declarations
(function_decl name: (identifier) @function)

;; Standard function calls (e.g., some_fallible_call())
(call_expr 
    function: (expression 
        (primary_expr (identifier) @function)))

;; Method calls (e.g., v1.magnitude_sq())
(call_expr 
    function: (expression 
        (field_access_expr field: (identifier) @function.method)))

;; 6. Variables, Parameters, & Fields
;; ----------------------------------------------------------------------------
(variable_decl name: (identifier) @variable)
(variable_decl_no_semi name: (identifier) @variable)
(parameter name: (identifier) @variable.parameter)

;; Pattern matching payloads
(pattern (identifier_list (identifier) @variable))

;; Struct Fields & Object Properties
(field_decl name: (identifier) @variable.other.member)
(field_access_expr field: (identifier) @variable.other.member)
(struct_init_field name: (identifier) @variable.other.member)
