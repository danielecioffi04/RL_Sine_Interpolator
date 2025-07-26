library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_MULT_10_3 is
end TB_MULT_10_3;

architecture Behavioral of TB_MULT_10_3 is
    component MULT_10_3 is
        port(
            X: in std_logic_vector(9 downto 0);
            Y: in std_logic_vector(2 downto 0);
            M: out std_logic_vector(13 downto 0)
        );
    end component;
    
    signal x: std_logic_vector(9 downto 0);
    signal y: std_logic_vector(2 downto 0);
    signal m: std_logic_vector(13 downto 0);
    
begin

    DUT: MULT_10_3
        port map(
            X => x,
            Y => y,
            M => m
        );
        
    GEN: process
    begin
        x <= "1001111011";  --635
        y <= "101";         --5
        wait for 10 ns;
        
        x <= "1001101010";  --618
        y <= "010";         --2
        wait for 10 ns;
        
        x <= "1110101101";  --941
        y <= "110";         --6
        wait;
    
    end process;


end Behavioral;
