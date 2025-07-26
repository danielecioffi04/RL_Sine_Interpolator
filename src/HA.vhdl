library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HA is
    port(
		  X:    in std_logic;   --Operand
          CIN:  in std_logic;   --Carry in 
          Y:    out std_logic;  --Sum
          COUT: out std_logic   --Carry out 
		  );
end HA;


architecture RTL of HA is
begin
    Y <= X xor CIN;
    COUT <= (X and CIN);
end RTL;