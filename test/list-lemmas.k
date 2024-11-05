requires "evm.md"
requires "foundry.md"
// requires "keccak.md"

module LIST-LEMMAS
    imports EVM
    imports FOUNDRY
    imports INT-SYMBOLIC
    imports MAP-SYMBOLIC
    imports SET-SYMBOLIC
    // imports KECCAK-LEMMAS

    syntax StepSort ::= Int
                      | Bool
                      | Bytes
                      | Map
                      | Set
 // -------------------------

    syntax KItem ::= runLemma ( StepSort )
                   | doneLemma( StepSort )
 // --------------------------------------
    rule <k> runLemma(T) => doneLemma(T) ... </k>

    rule [keccak-slots-disjoint]:
      keccak ( A ) ==Int keccak ( B ) +Int C => false
      requires notBool 0 ==Int C
      [simplification, concrete(C), comm]

    rule [keccak-slots-disjoint-ml-l]:
      { keccak ( A ) #Equals keccak ( B ) +Int C } => #Bottom
      requires notBool 0 ==Int C
      [simplification, concrete(C)]

    rule [keccak-slots-disjoint-ml-r]:
      { keccak ( B ) +Int C #Equals keccak ( A ) } => #Bottom
      requires notBool 0 ==Int C
      [simplification, concrete(C)]

    rule K1 in_keys((K2 |-> _ ) M) => K1 ==Int K2 orBool K1 in_keys(M) [simplification]


endmodule

module LIST-LEMMAS-SPEC
    imports LIST-LEMMAS

endmodule