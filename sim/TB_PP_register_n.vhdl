library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_PP_register_n is
end TB_PP_register_n;

architecture Behavioral of TB_PP_register_n is
    
    component PP_register_n is
    generic(N: integer);
    port ( 
            CLK:   in  std_logic; 
            RESET: in  std_logic; 
            X:     in  std_logic_vector(N-1 downto 0); 
            Y:     out std_logic_vector(N-1 downto 0) 
        );
    end component;
    
    signal clk, reset: std_logic;
    signal x,y: std_logic_vector(8 downto 0);
    
begin

    DUT: PP_register_n
        generic map(N => 9)
        port map (
            CLK   => clk,
            RESET => reset,
            X     => x,
            Y     => y
        );
    
    GEN: process
    begin
        reset <= '0';
        x <= "000000000"; -- I don't expect this value to be shown on the exit of the register because in the first 10ns the clock is low
        wait for 10ns;
        
        x <= "111111111";
        wait for 10ns;
        
        x <= "000001101";
        wait for 10ns;
        
        reset <= '1';
        wait;
    end process;
    
    CLK_GEN: process
    begin
        clk <= '0';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
    end process;

end Behavioral;
