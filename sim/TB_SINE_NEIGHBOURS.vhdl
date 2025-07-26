library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SINE_NEIGHBOURS is
end TB_SINE_NEIGHBOURS;

architecture Behavioral of TB_SINE_NEIGHBOURS is
    component SINE_NEIGHBOURS is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);
            PN_TEST, NN_TEST: out std_logic_vector(6 downto 0);
            SINE_PREV: out std_logic_vector(9 downto 0);
            SINE_NEXT: out std_logic_vector(9 downto 0)
        );
    end component;
    
    signal x_prime: std_logic_vector(6 downto 0);
    signal sine_prev, sine_next: std_logic_vector(9 downto 0);
    signal pn_test, nn_test: std_logic_vector(6 downto 0);
    
begin

    DUT: SINE_NEIGHBOURS
        port map(
            X_PRIME => x_prime,
            PN_TEST => pn_test,
            NN_TEST => nn_test,
            SINE_PREV => sine_prev,
            SINE_NEXT => sine_next
        );
        
    GEN: process
    begin
         x_prime <= "0000001"; --1
        wait for 100 ns;
        
        x_prime <= "0010010"; --18
        wait for 100 ns;
        
        x_prime <= "0011011"; --27
        wait for 100 ns;
        
        x_prime <= "0100100"; --36
        wait for 100 ns;
        
        x_prime <= "0101101"; --45
        wait for 100 ns;
        
        x_prime <= "0110110"; --54
        wait for 100 ns;
        
        x_prime <= "0111111"; --63
        wait for 100 ns;
        
        x_prime <= "1001000"; --72
        wait;
    end process;

end Behavioral;
