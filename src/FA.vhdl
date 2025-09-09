library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    port(
        X: in std_logic;        --First operand
        Y: in std_logic;        --Second operand
        CIN: in std_logic;      --Carry in
        S: out std_logic;       --Sum
        COUT: out std_logic     --Carry out
    );
end FA;

architecture RTL of FA is

begin
    S <= X xor Y xor CIN;
    COUT <= (X and Y) or (X and CIN) or (Y and CIN);
end RTL;