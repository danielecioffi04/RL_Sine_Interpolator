library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_PRENC_4 is
end TB_PRENC_4;

architecture Behavioral of TB_PRENC_4 is
    component PRENC_4 is
    port(
        ENC_IN: in std_logic_vector(3 downto 0);
        ENC_OUT: out std_logic_vector(1 downto 0)
    );
    end component;
    
    signal enc_in: std_logic_vector(3 downto 0);
    signal enc_out: std_logic_vector(1 downto 0);
    
begin

    DUT: PRENC_4
        port map(
            ENC_IN => enc_in,
            ENC_OUT => enc_out
        );
        
    GEN: process
    begin
        enc_in <= "0001";
        wait for 10 ns;
        
        enc_in <= "0010";
        wait for 10 ns;
        
        enc_in <= "0011";
        wait for 10 ns;
        
        enc_in <= "0100";
        wait for 10 ns;
        
        enc_in <= "0101";
        wait for 10 ns;
        
        enc_in <= "0110";
        wait for 10 ns;
        
        enc_in <= "0111";
        wait for 10 ns;
        
        enc_in <= "1000";
        wait for 10 ns;
        
        enc_in <= "1001";
        wait for 10 ns;
        
        enc_in <= "1010";
        wait for 10 ns;
        
        enc_in <= "1011";
        wait for 10 ns;
        
        enc_in <= "1100";
        wait for 10 ns;
        
        enc_in <= "1101";
        wait for 10 ns;
        
        enc_in <= "1110";
        wait for 10 ns;
        
        enc_in <= "1111";
        wait;
    end process;

end Behavioral;
