; Keywords
[
  "struct"
  "enum"
  "impl"
  "fnc"
  "ret"
  "yld"
  "brk"
  "if"
  "elif"
  "else"
  "match"
  "loop"
  "as"
] @keyword

; Operators
[
  "="
  "~="
  ":="
  "->"
  "..."
] @operator

; Literals
(int_lit) @constant.numeric.integer
(float_lit) @constant.numeric.float
(string_lit) @string
(char_lit) @string.special
"bln" @constant.builtin.boolean

; Types and Declarations
(struct_decl (identifier) @type)
(enum_decl (identifier) @type)
(impl_decl (identifier) @type)
(base_type (identifier) @type)

; Functions
(function_decl (identifier) @function)

; Variables
(variable_decl (identifier) @variable)
(parameter (identifier) @variable.parameter)
(field_decl (identifier) @variable.other.member)

; Fallback for all other identifiers
(identifier) @variable

; Comments
(comment) @comment
