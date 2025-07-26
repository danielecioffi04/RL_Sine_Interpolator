library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_4_1_N is
    generic( N: integer := 9);
    port(
        SEL: in std_logic_vector(1 downto 0);           --Selector
        A, B, C, D: in std_logic_vector(N-1 downto 0);  --Inputs
        Y: out std_logic_vector(N-1 downto 0)           --Output
    );
end MUX_4_1_N;

architecture RTL of MUX_4_1_N is
begin
        with SEL select
        Y <= A when "00",
             B when "01",
             C when "10",
             D when "11",
             (others => '-') when others;
end RTL;
