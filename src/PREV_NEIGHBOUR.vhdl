library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PREV_NEIGHBOUR is
    port(
        X_PRIME: in std_logic_vector(6 downto 0);   --Transformed angle
        PN: out std_logic_vector(6 downto 0)        --Previous neighbour: previous angle multiple of 8
    );
end PREV_NEIGHBOUR;

architecture RTL of PREV_NEIGHBOUR is
begin
    PN <= X_PRIME(6) & X_PRIME(5) & X_PRIME(4) & X_PRIME(3) & '0' & '0' & '0';
end RTL;
