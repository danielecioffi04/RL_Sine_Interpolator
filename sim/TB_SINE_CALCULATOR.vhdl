library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SINE_CALCULATOR is
end TB_SINE_CALCULATOR;

architecture Behavioral of TB_SINE_CALCULATOR is
    component SINE_CALCULATOR is
        port(
            X: in std_logic_vector(8 downto 0);
            SINE_X: out std_logic_vector(9 downto 0);
            ERR: out std_logic
        );
    end component;
    
    signal x: std_logic_vector(8 downto 0);
    signal sine_x: std_logic_vector(9 downto 0);
    signal err: std_logic;
    
begin

    DUT: SINE_CALCULATOR
        port map(
            X => x,
            SINE_X => sine_x,
            ERR => err
        );
    
    GEN: process
    begin
        x <= "000000000"; --0
        wait for 10 ns;

        x <= "000110010"; --50
        wait for 10 ns;

        x <= "001011010"; --90
        wait for 10 ns;

        x <= "010010110"; --150
        wait for 10 ns;

        x <= "010110100"; --180
        wait for 10 ns;

        x <= "011111010"; --250
        wait for 10 ns;

        x <= "100001110"; --270
        wait for 10 ns;

        x <= "101011110"; --350
        wait for 10 ns;

        x <= "101101000"; --360
        wait;
    end process;

end Behavioral;
