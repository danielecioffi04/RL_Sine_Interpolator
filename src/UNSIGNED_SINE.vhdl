library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UNSIGNED_SINE is
    port(
        X_PRIME: in std_logic_vector(6 downto 0);           --Transformed X
        UNSIGNED_SINE: out std_logic_vector(9 downto 0)     --Interpolated sine of transformed X
    );
end UNSIGNED_SINE;

architecture Structural of UNSIGNED_SINE is
    
    component LUT is
        port(
            ANGLE:  in  std_logic_vector(6 downto 0);   -- input angle on 7 bits
            SINE:   out  std_logic_vector(9 downto 0)   -- sine value in fixed point notation [2 + 8]
            );
    end component;
    
    component SINE_NEIGHBOURS is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);               --Transformed X
            SINE_PREV: out std_logic_vector(9 downto 0);            --Sine of X previous neighbour
            SINE_NEXT: out std_logic_vector(9 downto 0)             --Sine of X next neighbour
        );
    end component;
    
    component SINE_INTERPOLATION is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);               --Transformed X
            SINE_PREV: in std_logic_vector(9 downto 0);             --Sine of previous neighbour
            SINE_NEXT: in std_logic_vector(9 downto 0);             --Sine of next neighbour
            INTERPOLATED_SINE: out std_logic_vector(9 downto 0)     --Unsigned interpolated X sine
        );
    end component;
    
    component MUX_2_1_N is
        generic( N: integer := 10 );
        port(
            SEL: in std_logic;                          --Selector
            A, B: in std_logic_vector(N-1 downto 0);    --Inputs
            Y: out std_logic_vector(N-1 downto 0)       --Output
        );
    end component;
    
    signal mux_selector: std_logic;                             --Selects between interpolated sine (1) and the result of the LUT (0)
    signal LUT_output: std_logic_vector(9 downto 0);            --LUT(X_PRIME)
    signal sine_prev, sine_next: std_logic_vector(9 downto 0);  --Signals for SINE(PN) and SINE(NN)
    signal interpolated_sine: std_logic_vector(9 downto 0);     --Result of the interpolation on 10 bits
begin
    
    --Access LUT for SINE(X_PRIME)
    LUT1: LUT
        port map(
            ANGLE => X_PRIME,
            SINE => LUT_output
        );
    
    --Result of the LUT access - If MSB = 1 then X_PRIME is not in the LUT
    mux_selector <= LUT_output(9);
    
    GENERATE_NEIGHBOURS: SINE_NEIGHBOURS
        port map(
            X_PRIME => X_PRIME,
            SINE_PREV => sine_prev,
            SINE_NEXT => sine_next
        );
        
    GENERATE_INTERPOLATION: SINE_INTERPOLATION
        port map(
            X_PRIME => X_PRIME,
            SINE_PREV => sine_prev,
            SINE_NEXT => sine_next,
            INTERPOLATED_SINE => interpolated_sine
        );
    
    --Selects between interpolated sine and LUT output
    MUX_2_1_10: MUX_2_1_N
        generic map(N => 10)
        port map(
            SEL => mux_selector,
            A => LUT_output,
            B => interpolated_sine,
            Y => UNSIGNED_SINE
        );

end Structural;
