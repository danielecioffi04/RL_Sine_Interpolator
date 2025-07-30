library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SINE_CALCULATOR_SEQ is
end TB_SINE_CALCULATOR_SEQ;

architecture Behavioral of TB_SINE_CALCULATOR_SEQ is
    component SINE_CALCULATOR_SEQ is
    port(
        X: in std_logic_vector(8 downto 0);
        CLK: in std_logic;
        RESET: in std_logic;
        Z: out std_logic_vector(9 downto 0);
        ERR: out std_logic
        --X_SIGNAL_TEST: out std_logic_vector(8 downto 0)
    );
    end component;
    
    signal x: std_logic_vector(8 downto 0);
    --signal x_signal_test: std_logic_vector(8 downto 0);
    signal clk, reset, err: std_logic;
    signal z: std_logic_vector(9 downto 0);
    
    constant CLK_PERIOD : time := 4 ns;
    constant HALF_CLOCK : time := 2 ns;
    constant RESET_TIME : time := 152 ns;
    
begin

    DUT: SINE_CALCULATOR_SEQ
    port map(
        X => x,
        CLK => clk,
        RESET => reset,
        Z => z,
        ERR => err
        --X_SIGNAL_TEST => x_signal_test
    );

    GEN: process
    begin
        reset <= '1';
        x <= "000000001"; --1
        wait for RESET_TIME;
        
        reset <= '0';
        x <= "000000000"; --0
        wait for CLK_PERIOD;

        x <= "000110010"; --50
        wait for CLK_PERIOD;

        x <= "001011010"; --90
        wait for CLK_PERIOD;

        x <= "010010110"; --150
        wait for CLK_PERIOD;

        x <= "010110100"; --180
        wait for CLK_PERIOD;

        x <= "011111010"; --250
        wait for CLK_PERIOD;

        x <= "100001110"; --270
        wait for CLK_PERIOD;

        x <= "101011110"; --350
        wait for CLK_PERIOD;

        x <= "101101000"; --360
        wait for CLK_PERIOD;
        
        x <= "110011111"; --415
        wait;
    end process;
    
    CLK_GEN: process
    begin
        clk <= '0';
        wait for HALF_CLOCK;
        clk <= '1';
        wait for HALF_CLOCK;
    end process;

end Behavioral;
