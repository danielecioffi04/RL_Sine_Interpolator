library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_UNSIGNED_SINE is
end TB_UNSIGNED_SINE;

architecture Behavioral of TB_UNSIGNED_SINE is
    
    component UNSIGNED_SINE is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);
            UNSIGNED_SINE: out std_logic_vector(9 downto 0)
        );
    end component;
    
    signal x_prime: std_logic_vector(6 downto 0);
    signal result: std_logic_vector(9 downto 0);
    
begin

    DUT: UNSIGNED_SINE
        port map(
            X_PRIME => x_prime,
            UNSIGNED_SINE => result
        );
        
    GEN: process
    begin
        x_prime <= "0100100"; --36
        wait for 10 ns;
        
        x_prime <= "0000000"; --0
        wait for 10 ns;
        
        x_prime <= "0011000"; --24
        wait for 10 ns;
        
        x_prime <= "1011001"; --89
        wait;
    
    end process;

end Behavioral;
