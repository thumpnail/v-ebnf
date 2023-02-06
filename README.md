# v-ebnf
EBNF parser module written in v

currently not optimized for ease of use.
Many functions may be private.
Bugs are expected.

## syntax
```ebnf
rule := 'literal' (sub_rule | 'a');
sub_rule := 'repeat' { ',' sub_rule};
opt := 'var' name [':' typename] '=' value;
```
