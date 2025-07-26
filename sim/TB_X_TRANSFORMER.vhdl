library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_X_TRANSFORMER is
end TB_X_TRANSFORMER;

architecture Behavioral of TB_X_TRANSFORMER is

component X_TRANSFORMER is
    Port (
        X : in std_logic_vector (8 downto 0);
        X_PRIME : out std_logic_vector (6 downto 0);
        ERR : out std_logic;
        SGN : out std_logic
        );
end component;

signal a: std_logic_vector(8 downto 0);
signal a_prime: std_logic_vector(6 downto 0);
signal err: std_logic;
signal sgn: std_logic;

begin

    DUT: X_TRANSFORMER
        port map(
            X => a,
            X_PRIME => a_prime,
            ERR => err,
            SGN => sgn
        );
    
    GEN: process
    begin
    
        a <= "000000000"; --0
        wait for 10 ns;

        a <= "000110010"; --50
        wait for 10 ns;

        a <= "001011010"; --90
        wait for 10 ns;

        a <= "010010110"; --150
        wait for 10 ns;

        a <= "010110100"; --180
        wait for 10 ns;

        a <= "011111010"; --250
        wait for 10 ns;

        a <= "100001110"; --270
        wait for 10 ns;

        a <= "101011110"; --350
        wait for 10 ns;

        a <= "101101000"; --360
        wait;
        
    end process;
    


end Behavioral;
