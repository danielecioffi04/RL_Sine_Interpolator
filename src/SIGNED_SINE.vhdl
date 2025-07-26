library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIGNED_SINE is
    port(
        SGN: in std_logic;                                  --Sign of sine
        UNSIGNED_SINE: in std_logic_vector(9 downto 0);     --Unsigned sine
        SIGNED_SINE: out std_logic_vector(9 downto 0)       --Signed sine
    );
end SIGNED_SINE;

architecture Structural of SIGNED_SINE is

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
    
    component MUX_2_1_N is
    generic( N: integer := 10 );
        port(
            SEL: in std_logic;                          --Selector
            A, B: in std_logic_vector(N-1 downto 0);    --Inputs
            Y: out std_logic_vector(N-1 downto 0)       --Output
        );
    end component;
    
    signal reduced_unsigned_sine: std_logic_vector(8 downto 0); --unsigned_sine without MSB
    signal result: std_logic_vector(9 downto 0);
    
    
begin
    
    reduced_unsigned_sine <= UNSIGNED_SINE(8 downto 0);
    
    --Calculates -reduced_unsigned_sine
    COMPL2: CLA_AddSub
        generic map(N => 9)
        port map(
            X => "000000000",
            Y => reduced_unsigned_sine,
            AddSub => '1',
            RES => result,
            COUT => open
        );
    
    --Selects between unsigned sine and signed sine
    MUX_2_1_10: MUX_2_1_N
        generic map(N => 10)
        port map(
            SEL => SGN,
            A => UNSIGNED_SINE,
            B => result,
            Y => SIGNED_SINE
        );

end Structural;
