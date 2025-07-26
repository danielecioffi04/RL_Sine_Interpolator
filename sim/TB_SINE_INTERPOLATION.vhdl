library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SINE_INTERPOLATION is
end TB_SINE_INTERPOLATION;

architecture Behavioral of TB_SINE_INTERPOLATION is

    component SINE_INTERPOLATION is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);
            SINE_PREV: in std_logic_vector(9 downto 0);
            SINE_NEXT: in std_logic_vector(9 downto 0);
            INTERPOLATED_SINE: out std_logic_vector(9 downto 0)
        );
    end component;
    
    signal x_prime: std_logic_vector(6 downto 0);
    signal sine_prev, sine_next, interpolated_sine: std_logic_vector(9 downto 0);
    
begin

    DUT: SINE_INTERPOLATION
        port map(
            X_PRIME => x_prime,
            SINE_PREV => sine_prev,
            SINE_NEXT => sine_next,
            INTERPOLATED_SINE => interpolated_sine
        );
        
    GEN: process
    begin
        
        x_prime <= "0100100"; --36
        sine_prev <= "0010000111"; --sin(32)
        sine_next <= "0010100100"; --sin(40)
        wait for 10 ns;
        
        x_prime <= "1000010"; --66
        sine_prev <= "0011100110"; --sin(64)
        sine_next <= "0011110011"; --sin(72)
        wait for 10 ns;
        
        x_prime <= "1001000"; --72
        sine_prev <= "0011110011"; --sin(72)
        sine_next <= "0011111100"; --sin(80)
        wait;
    
    end process;

end Behavioral;
