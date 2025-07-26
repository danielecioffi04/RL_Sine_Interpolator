library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SINE_CALCULATOR_SEQ is
    port(
        X: in std_logic_vector(8 downto 0);     --Input angle
        CLK: in std_logic;                      --Clock of the PP registers and FFD
        RESET: in std_logic;                    --Reset signals for PP registers and FFD
        Z: out std_logic_vector(9 downto 0);    --Output sine of X
        ERR: out std_logic                      --Error signal in case angle out of bounds
        --X_SIGNAL_TEST: out std_logic_vector(8 downto 0)
    );
end SINE_CALCULATOR_SEQ;

architecture Structural of SINE_CALCULATOR_SEQ is
    component SINE_CALCULATOR is
        port(
            X: in std_logic_vector(8 downto 0);         --Angle between 0 and 359
            SINE_X: out std_logic_vector(9 downto 0);   --Sine of X
            ERR: out std_logic                          --Error signal in case angle out of bounds
        );
    end component;
    
    component PP_register_n is
        generic(N: integer := 9);
        port ( 
                CLK:   in  std_logic;                       --Clock
                RESET: in  std_logic;                       --Reset
                X:     in  std_logic_vector(N-1 downto 0);  --Input
                Y:     out std_logic_vector(N-1 downto 0)   --Output
            );
    end component;
    
    component FFD is
    port ( 
            CLK:   in  std_logic; --Clock 
            RESET: in  std_logic; --Reset
            D:     in  std_logic; --Input
            Q:     out std_logic  --Output
        );
    end component;
    
    signal x_signal: std_logic_vector(8 downto 0);
    signal sine_x: std_logic_vector(9 downto 0);
    signal err_signal: std_logic;
    
begin
    
    INPUT_REG: PP_register_n
        generic map(N => 9)
        port map(
            CLK => CLK,
            RESET => RESET,
            X => X,
            Y => x_signal
        );
    
    --X_SIGNAL_TEST <= x_signal;
    
    CALCULATE: SINE_CALCULATOR
        port map(
            X => x_signal,
            SINE_X => sine_x,
            ERR => err_signal
        );
        
    OUTPUT_REG: PP_register_n
        generic map(N => 10)
        port map(
            CLK => CLK,
            RESET => RESET,
            X => sine_x,
            Y => Z
        );
        
    ERROR_REG: FFD
        port map(
            CLK => CLK,
            RESET => RESET,
            D => err_signal,
            Q => ERR
        );
    
    
    

end Structural;
