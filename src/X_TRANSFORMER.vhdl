library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity X_TRANSFORMER is
    Port (
        X : in std_logic_vector (8 downto 0);           --Angle between 0 and 359
        X_PRIME : out std_logic_vector (6 downto 0);    --Transformed angle between 0 and 90     
        ERR : out std_logic;                            --Error signal in case Angle out of bounds
        SGN : out std_logic                             --Sign of the calculated sine
        );
end X_TRANSFORMER;

architecture Structural of X_TRANSFORMER is

component PRENC_4 is
    port(
        ENC_IN: in std_logic_vector(3 downto 0);        --Input
        ENC_OUT: out std_logic_vector(1 downto 0)       --Output
    );
end component;

component MUX_4_1_N is
    generic( N: integer := 9 );
    port(
        SEL: in std_logic_vector(1 downto 0);           --Selector
        A, B, C, D: in std_logic_vector(N-1 downto 0);  --Inputs
        Y: out std_logic_vector(N-1 downto 0)           --Output
    );
end component;

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

signal signedX: std_logic_vector(9 downto 0);                                                           --Signed X, select by the mux when X is already between 0 and 90
signal less_than_90, less_than_180, less_than_270, less_than_360: std_logic_vector(9 downto 0);         --Signals used to define if X is in first, second, third or fourth quadrant. MSB used as inputs in the PRENC
signal prenc_input: std_logic_vector(3 downto 0);                                                       --Concatenation of less_than_90(8) & less_than_180(8) & less_than_270(8) & less_than_360(8)
signal mux_selector: std_logic_vector(1 downto 0);                                                      --Signal used to select the correct calculated X_prime and SGN
signal mux_output: std_logic_vector(9 downto 0);                                                        --X_PRIME on 10 bits
signal sgn_vector: std_logic_vector(0 downto 0);                                                        --Output of sgn mux is defined as a vector so i need a signal as vector to store it
signal X_second_quad, X_third_quad, X_fourth_quad: std_logic_vector(9 downto 0);                        --Transformed X via trigonometric formulas

begin
    signedX <= '0' & X;
    
    --Calculates X-90
    CLA_LESS_THAN_90: CLA_AddSub
        generic map(N => 9)
        port map(
            X => X,
            Y => "001011010",
            AddSub => '1',
            RES => less_than_90,
            COUT => open
        );
    
    --Calculates X-180
    CLA_LESS_THAN_180: CLA_AddSub
        generic map(N => 9)
        port map(
            X => X,
            Y => "010110100",
            AddSub => '1',
            RES => less_than_180,
            COUT => open
        );
    
    --Calculates X-270
    CLA_LESS_THAN_270: CLA_AddSub
        generic map(N => 9)
        port map(
            X => X,
            Y => "100001110",
            AddSub => '1',
            RES => less_than_270,
            COUT => open
        );
    
    --Calculates X-360
    CLA_LESS_THAN_360: CLA_AddSub
        generic map(N => 9)
        port map(
            X => X,
            Y => "101101000",
            AddSub => '1',
            RES => less_than_360,
            COUT => open
        );
    
    --Defining ERR flag
    ERR <= not less_than_360(9); --If X > 359 then less_than_360(8) = 0 so ERR = 1
    
    --Calculates 180-X (transformed X if it is in the second quadrant)
    CLA_SECOND_QUAD: CLA_AddSub
        generic map(N => 9)
        port map(
            X => "010110100", --180
            Y => X,
            AddSub => '1',
            RES => X_second_quad,
            COUT => open
        );
    
    --Calculates X-180 (transformed X if it is in the third quadrant)
    CLA_THIRD_QUAD: CLA_AddSub
        generic map(N => 9)
        port map(
            X => X,
            Y => "010110100", --180
            AddSub => '1',
            RES => X_third_quad,
            COUT => open
        );
    
    --Calculates 360-X (transformed X if it is in the fourth quadrant)
    CLA_FOURTH_QUAD: CLA_AddSub
        generic map(N => 9)
        port map(
            X => "101101000", --360
            Y => X,
            AddSub => '1',
            RES => X_fourth_quad,
            COUT => open
        );
        
    --Creation of the PRENC input
    prenc_input <= less_than_90(9) & less_than_180(9) & less_than_270(9) & less_than_360(9);
    
    --PRENC that creates the MUX selector
    PRENC_SELECTOR: PRENC_4
        port map(
            ENC_IN => prenc_input,
            ENC_OUT => mux_selector
        );
    
    --MUX that selects the correct transformed X
    MUX_X_PRIME: MUX_4_1_N
        generic map(N => 10)
        port map(
            SEL => mux_selector,
            A => X_fourth_quad,
            B => X_third_quad,
            C => X_second_quad,
            D => signedX,
            Y => mux_output
        );
   
   --X_PRIME on 7 bits (slicing of mux_output)
    X_PRIME <= mux_output(6 downto 0);
    
    --MUX that selects if sgn = 1 (-) or 0 (+)
    MUX_SGN: MUX_4_1_N
        generic map(N => 1)
        port map(
            SEL => mux_selector,
            A => "1",
            B => "1",
            C => "0",
            D => "0",
            Y => sgn_vector
        );
    
    --Casting from vector to single bit
    SGN <= sgn_vector(0);

end Structural;
