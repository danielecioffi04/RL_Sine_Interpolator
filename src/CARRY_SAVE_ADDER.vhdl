library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CARRY_SAVE_ADDER is
    port(
        X: in std_logic;        --First operand
        Y: in std_logic;        --Second operand
        Z: in std_logic;        --Third operand
        T: out std_logic;       --Sum
        COUT: out std_logic     --Carry out
    );
end CARRY_SAVE_ADDER;

architecture RTL of CARRY_SAVE_ADDER is

begin
    T <= X xor Y xor Z;
    COUT <= (X and Y) or (X and Z) or (Y and Z);
end RTL;