library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PP_register_n is
    generic(N: integer := 9);
    port ( 
            CLK:   in  std_logic;                       --Clock
            RESET: in  std_logic;                       --Reset
            X:     in  std_logic_vector(N-1 downto 0);  --Input
            Y:     out std_logic_vector(N-1 downto 0)   --Output
        );
end PP_register_n;

architecture Structural of PP_register_n is

component FFD is
    port ( 
            CLK:   in  std_logic; 
            RESET: in  std_logic; 
            D:     in  std_logic; 
            Q:     out std_logic
        );
end component;

begin
    GENERATE_FFD: for I in 0 to N-1 generate
        FF_i:   FFD 
                port map (CLK => CLK, RESET => RESET, D => X(I), Q => Y(I));
    end generate;

end Structural;
