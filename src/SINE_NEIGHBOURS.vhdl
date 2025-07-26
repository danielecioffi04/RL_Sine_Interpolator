library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SINE_NEIGHBOURS is
    port(
        X_PRIME: in std_logic_vector(6 downto 0);               --Transformed X
        SINE_PREV: out std_logic_vector(9 downto 0);            --Sine of X previous neighbour
        SINE_NEXT: out std_logic_vector(9 downto 0)             --Sine of X next neighbour
    );
end SINE_NEIGHBOURS;

architecture Structural of SINE_NEIGHBOURS is

    component PREV_NEIGHBOUR is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);   --Transformed angle
            PN: out std_logic_vector(6 downto 0)        --Previous neighbour: previous angle multiple of 8
        );
    end component;
    
    component NEXT_NEIGHBOUR is
        port(
            PN: in std_logic_vector(6 downto 0);    --Previous neighbour: previous angle multiple of 8
            NN: out std_logic_vector(6 downto 0)    --Next neighbout: next angle multiple of 8
        );
    end component;
    
    component LUT is
        port(
            ANGLE:  in  std_logic_vector(6 downto 0);   -- input angle on 7 bits
            SINE:   out  std_logic_vector(9 downto 0)   -- sine value in fixed point notation [2 + 8]
            );
    end component;
    
    signal pn, nn: std_logic_vector(6 downto 0);

begin

    PREVN: PREV_NEIGHBOUR
        port map(
            X_PRIME => X_PRIME,
            PN => pn
        );
        
    NEXTN: NEXT_NEIGHBOUR
        port map(
            PN => pn,
            NN => nn
        );
        
    LUTPN: LUT
        port map(
            ANGLE => pn,
            SINE => SINE_PREV
        );
        
    LUTNN: LUT
        port map(
            ANGLE => nn,
            SINE => SINE_NEXT
        );

end Structural;
