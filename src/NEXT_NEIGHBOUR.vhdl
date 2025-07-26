library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NEXT_NEIGHBOUR is
    port(
        PN: in std_logic_vector(6 downto 0);    --Previous neighbour: previous angle multiple of 8
        NN: out std_logic_vector(6 downto 0)    --Next neighbout: next angle multiple of 8
    );
end NEXT_NEIGHBOUR;

architecture Structural of NEXT_NEIGHBOUR is

    component HA is
        port(
              X:    in std_logic;   --Operand
              CIN:  in std_logic;   --Carry in 
              Y:    out std_logic;  --Sum
              COUT: out std_logic   --Carry out
        );
    end component;
    
    signal carry1, carry2, carry3: std_logic;   --Generated carry bits from the 3 HA

begin
    --First 3 bits of the result are '0' since I'm adding 8 to a multiple of 8
    NN(0) <= '0';
    NN(1) <= '0';
    NN(2) <= '0';
    
    HA1: HA
        port map(
            X => PN(3),
            CIN => '1',
            Y => NN(3),
            COUT => carry1
        );
    
    HA2: HA
        port map(
            X => PN(4),
            CIN => carry1,
            Y => NN(4),
            COUT => carry2
        );
        
    HA3: HA
        port map(
            X => PN(5),
            CIN => carry2,
            Y => NN(5),
            COUT => carry3
        );
        
    HA4: HA
        port map(
            X => PN(6),
            CIN => carry3,
            Y => NN(6),
            COUT => open
        );


end Structural;
