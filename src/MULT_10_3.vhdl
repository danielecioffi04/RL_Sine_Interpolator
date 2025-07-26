library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULT_10_3 is
    port(
        X: in std_logic_vector(9 downto 0);     --First operand
        Y: in std_logic_vector(2 downto 0);     --Second operand
        M: out std_logic_vector(13 downto 0)    --Mult
    );
end MULT_10_3;

architecture Structural of MULT_10_3 is

    component CARRY_SAVE_ADDER is
        port(
            X: in std_logic;        --First operand
            Y: in std_logic;        --Second operand
            Z: in std_logic;        --Third operand
            T: out std_logic;       --Sum
            COUT: out std_logic     --Carry out
        );
    end component;
    
    component FA is
        port(
            X: in std_logic;        --First operand
            Y: in std_logic;        --Second operand
            CIN: in std_logic;      --Carry in
            S: out std_logic;       --Sum
            COUT: out std_logic     --Carry out
        );
    end component;
    
    signal t,w,p: std_logic_vector(11 downto 0);        --Vectors of partial products
    signal CS_carry: std_logic_vector(11 downto 0);     --Carry from the CarrySaveAdders
    signal CS_sums: std_logic_vector(11 downto 0);      --Sums from the CarrySaveAdders
    signal FA_carry: std_logic_vector(11 downto 0);     --Sums from the FullAdders

begin
    --LSB of second partial product is '0'
    w(0) <= '0';
    
    --Last two LSBs of third partial product are '0'
    p(0) <= '0';
    p(1) <= '0';
    
    --Generates partial products
    GENERATE_ADDENDUMS: for I in 0 to 9 generate
        t(i) <= X(i) and Y(0);
        w(i+1) <= X(i) and Y(1);
        p(i+2) <= X(i) and Y(2);
    end generate;
    
    --First two MSBs of first partial product are '0'
    t(10) <= '0';
    t(11) <= '0';
    
    --MSB of second partial product is '0'
    w(11) <= '0';
    
    GENERATE_CARRYSAVES: for I in 0 to 11 generate
        CS_I: CARRY_SAVE_ADDER
            port map(
                X => t(i),
                Y => w(i),
                Z => p(i),
                T => CS_sums(i),
                COUT => CS_carry(i)
            );
    end generate;
    
    --LSB of result is the sum from the first CS
    M(0) <= CS_sums(0);
    
    FIRST_FA: FA
        port map(
            X => CS_sums(1),
            Y => CS_carry(0),
            CIN => '0',
            S => M(1),
            COUT => FA_carry(0)
        );
    
    GENERATE_MID_FA: for I in 1 to 10 generate
        FA_I: FA
            port map(
                X => CS_sums(i+1),
                Y => CS_carry(i),
                CIN => FA_carry(i-1),
                S => M(i+1),
                COUT => FA_carry(i)
            );
    end generate;
    
    LAST_FA: FA
        port map(
            X => '0',
            Y => CS_carry(11),
            CIN => FA_carry(10),
            S => M(12),
            COUT => M(13)
        );



end Structural;
