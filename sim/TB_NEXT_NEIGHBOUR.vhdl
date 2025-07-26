library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_NEXT_NEIGHBOUR is
end TB_NEXT_NEIGHBOUR;

architecture Behavioral of TB_NEXT_NEIGHBOUR is
    component NEXT_NEIGHBOUR is
    port(
        PN: in std_logic_vector(6 downto 0);
        NN: out std_logic_vector(6 downto 0)
    );
    end component;
    
    signal pn, nn: std_logic_vector(6 downto 0);
    
begin

    DUT: NEXT_NEIGHBOUR
        port map(
            PN => pn,
            NN => nn
        );
        
    GEN: process
    begin
        pn <= "0000000"; --0
        wait for 10 ns;
        
        pn <= "0010000"; --16
        wait for 10 ns;
        
        pn <= "0011000"; --24
        wait for 10 ns;
        
        pn <= "0100000"; --32
        wait for 10 ns;
        
        pn <= "0101000"; --40
        wait for 10 ns;
        
        pn <= "0110000"; --48
        wait for 10 ns;
        
        pn <= "0111000"; --56
        wait for 10 ns;
        
        pn <= "1000000"; --64
        wait for 10 ns;
        
        pn <= "1001000"; --72
        wait;
        
    end process;

end Behavioral;
