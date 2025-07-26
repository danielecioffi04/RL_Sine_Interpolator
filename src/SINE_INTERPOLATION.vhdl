library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SINE_INTERPOLATION is
    port(
        X_PRIME: in std_logic_vector(6 downto 0);               --Transformed X
        SINE_PREV: in std_logic_vector(9 downto 0);             --Sine of previous neighbour
        SINE_NEXT: in std_logic_vector(9 downto 0);             --Sine of next neighbour
        INTERPOLATED_SINE: out std_logic_vector(9 downto 0)     --Unsigned interpolated X sine
    );
end SINE_INTERPOLATION;

architecture Structural of SINE_INTERPOLATION is

    component CLA_AddSub is
        generic(N: integer := 9);
        port(
            X: in std_logic_vector(N-1 downto 0);   --First operand (unsigned)
            Y: in std_logic_vector(N-1 downto 0);   --Second operand (unsigned)
            AddSub: in std_logic;                   --Operation Flag (0 = add, 1 = sub)
            RES: out std_logic_vector(N downto 0);  --Result on N+1 bits (signed)
            COUT: out std_logic                     --Carry out
        );
    end component;

    component MULT_10_3 is
        port(
            X: in std_logic_vector(9 downto 0);     --First operand
            Y: in std_logic_vector(2 downto 0);     --Second operand
            M: out std_logic_vector(13 downto 0)    --Mult
        );
    end component;
    
    signal sine_prev_module, sine_next_module: std_logic_vector(8 downto 0);    --module of sine_next and sine_prev
    signal angle_diff: std_logic_vector(2 downto 0);                            --difference between X_PRIME and PN
    signal sine_diff: std_logic_vector(9 downto 0);                             --difference between SINE(NN) and SINE(PN)
    signal mult_result: std_logic_vector(13 downto 0);                          --result of (SINE(NN)-SINE(PN)) * (X_PRIME - PN)
    signal shifted_mult: std_logic_vector(8 downto 0);                          --shifted mult
    
begin
    
    sine_prev_module <= SINE_PREV(8 downto 0);
    sine_next_module <= SINE_NEXT(8 downto 0);
    
    --Calculates SINE(NN) - SINE(PN)
    CALC_SINE_DIFF: CLA_AddSub
        generic map(N => 9)
        port map(
            X => sine_next_module,
            Y => sine_prev_module,
            AddSub => '1',
            RES => sine_diff,
            COUT => open
        );
    
    --Calculates X_PRIME - PN
    angle_diff <= X_PRIME(2) & X_PRIME(1) & X_PRIME(0);
    
    --Calculates (SINE(NN)-SINE(PN)) * (X_PRIME - PN)
    MULT: MULT_10_3
        port map(
            X => sine_diff,
            Y => angle_diff,
            M => mult_result
        );
    
    --Result shifted by 3 bits to the right - (SINE(NN)-SINE(PN)) * (X_PRIME - PN) / 8
    shifted_mult <= mult_result(11 downto 3);
    
    --Calculates SINE(PN) + (SINE(NN)-SINE(PN)) * (X_PRIME - PN) / 8
    CALCULATE_INTERPOLATION: CLA_AddSub
        generic map(N => 9)
        port map(
            X => shifted_mult,
            Y => sine_prev_module,
            AddSub => '0',
            RES => INTERPOLATED_SINE,
            COUT => open
        );

end Structural;
