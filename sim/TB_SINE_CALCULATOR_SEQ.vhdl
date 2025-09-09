library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

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
    
    signal test_angle: std_logic_vector(8 downto 0) := "000000000";
    --signal x: std_logic_vector(8 downto 0);
    --signal x_signal_test: std_logic_vector(8 downto 0);
    signal clk, reset, err: std_logic;
    signal z: std_logic_vector(9 downto 0);
    
    constant CLK_PERIOD : time := 5 ns;
    constant HALF_CLOCK : time := 2.5 ns;
    constant RESET_TIME : time := 150 ns;
    
begin

    DUT: SINE_CALCULATOR_SEQ
    port map(
        X => test_angle,
        CLK => clk,
        RESET => reset,
        Z => z,
        ERR => err
        --X_SIGNAL_TEST => x_signal_test
    );

    GEN: process
    begin
        reset <= '1';
        wait for RESET_TIME;
        
        reset <= '0';
        for I in 0 to 511 loop
            wait for CLK_PERIOD;
            test_angle <= test_angle + 1;
        end loop;
    end process;
    
    CLK_GEN: process
    begin
        clk <= '0';
        wait for HALF_CLOCK;
        clk <= '1';
        wait for HALF_CLOCK;
    end process;

end Behavioral;
