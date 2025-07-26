library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_PREV_NEIGHBOUR is
end TB_PREV_NEIGHBOUR;

architecture Behavioral of TB_PREV_NEIGHBOUR is
    component PREV_NEIGHBOUR is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);
            PN: out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal x_prime, pn: std_logic_vector(6 downto 0);
    
begin

    DUT: PREV_NEIGHBOUR
        port map(
            X_PRIME => x_prime,
            PN => pn
        );
        
    GEN: process
    begin
        x_prime <= "0000001"; --1
        wait for 10 ns;
        
        x_prime <= "0010010"; --18
        wait for 10 ns;
        
        x_prime <= "0011011"; --27
        wait for 10 ns;
        
        x_prime <= "0100100"; --36
        wait for 10 ns;
        
        x_prime <= "0101101"; --45
        wait for 10 ns;
        
        x_prime <= "0110110"; --54
        wait for 10 ns;
        
        x_prime <= "0111111"; --63
        wait for 10 ns;
        
        x_prime <= "1001000"; --72
        wait;
        
    end process;

end Behavioral;
