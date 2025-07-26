library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_AddSub is
    generic(N: integer := 9);
    port(
        X: in std_logic_vector(N-1 downto 0);   --First operand (unsigned)
        Y: in std_logic_vector(N-1 downto 0);   --Second operand (unsigned)
        AddSub: in std_logic;                   --Operation Flag (0 = add, 1 = sub)
        RES: out std_logic_vector(N downto 0);  --Result on N+1 bits (signed)
        COUT: out std_logic                     --Carry out
    );
end CLA_AddSub;

architecture RTL of CLA_AddSub is

component FA is
    port(
        X: in std_logic;        --First operand
        Y: in std_logic;        --Second operand
        CIN: in std_logic;      --Carry in
        S: out std_logic;       --Sum
        COUT: out std_logic     --Carry out
    );
end component;

signal COMPL: std_logic_vector(N downto 0);                 --Complemented second operand
signal G: std_logic_vector(N downto 0);                     --G
signal P: std_logic_vector(N downto 0);                     --P
signal CARRY: std_logic_vector(N+1 downto 0);               --Carry array
signal SUMS: std_logic_vector(N downto 0);                  --Result of Full addres sums
signal signedX, signedY: std_logic_vector(N downto 0);      --Signed X and Y represented with N+1 bits 

begin
    --Adds sign bit
    signedX <= '0' & X;
    signedY <= '0' & Y;
    
    --Generates complemented Y if AddSub = 1 (else the complemented number is Y)
    GENERATE_COMPLEMENT_Y: for I in 0 to N generate
        COMPL(I) <= signedY(I) xor AddSub;
    end generate GENERATE_COMPLEMENT_Y;
    
    --Generates G_i, P_i, C_i
    CARRY(0) <= AddSub;
    GENERATE_GPC: for I in 0 to N generate
        G(I)   <= signedX(I) and COMPL(I);          --Generation terms: signed_first_operand(i) * complemented_second_operand(i)
        P(I)   <= signedX(I) or COMPL(I);           --Propagation terms: signed_first_operan(i) + complemented_second_operand(i)
        CARRY(I+1) <= G(I) or (P(I) and CARRY(I));  --Carry terms: C(i+1) = G(i) + (P(i) * Carry(i))
    end generate GENERATE_GPC;
    
    --Creates all the necessary full adders - first_operand(i) + complemented_second_operand(i) + Carry(i)
    GENERATE_FA: for I in 0 to N generate
        FAU: FA port map (
                        X       =>  signedX(I),
                        Y       =>  COMPL(I),
                        CIN     =>  CARRY(I),        
                        S       =>  SUMS(I),
                        COUT    =>  open 
                    );
    end generate GENERATE_FA;
        
    RES <= SUMS;
    COUT <= CARRY(N+1);
end RTL;
