library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2_1_N is
    generic( N: integer := 10 );
    port(
        SEL: in std_logic;                          --Selector
        A, B: in std_logic_vector(N-1 downto 0);    --Inputs
        Y: out std_logic_vector(N-1 downto 0)       --Output
    );
end MUX_2_1_N;

architecture RTL of MUX_2_1_N is
begin
        with SEL select
        Y <= A when '0',
             B when '1',
             (others => '-') when others;
end RTL;