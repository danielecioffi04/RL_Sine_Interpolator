library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_CLA_AddSub is
end TB_CLA_AddSub;

architecture Behavioral of TB_CLA_AddSub is
    component CLA_AddSub is
        generic(N: integer := 9);
        port(
            X: in std_logic_vector(N-1 downto 0);   --First operand
            Y: in std_logic_vector(N-1 downto 0);   --Second operand
            AddSub: in std_logic;                   --Operation Flag (0 = add, 1 = sub)
            RES: out std_logic_vector(N downto 0);  --Result on N+1 bits
            COUT: out std_logic                     --Carry out
        );
    end component;
    
    signal a, b: std_logic_vector(8 downto 0);
    signal res: std_logic_vector(9 downto 0);
    signal as: std_logic;
begin
    
    DUT: CLA_AddSub
        generic map(N => 9)
        port map(
            X => a,
            Y => b,
            AddSub => as,
            RES => res
        );
        
    GEN: process
    begin
        --Test sum
        as <= '0';
        
        a <= "000101010";
        b <= "110101011";
        wait for 10ns;
        
        --Test sub
        as <= '1';
        
        a <= "000110010"; --50
        b <= "001011010"; --90
        wait for 10 ns;
        
        a <= "010010110"; --150
        b <= "010110100"; --180
        wait for 10 ns;
        
        a <= "011111010"; --250
        b <= "100001110"; --270
        wait for 10 ns;
        
        a <= "101011110"; --350
        b <= "101101000"; --360
        wait for 10 ns;
        
        a <= "111111111"; --511
        b <= "101101000"; --360
        
        a <= "000000000"; --0
        b <= "101101000"; --360
        wait;
        
    end process;
        
    

end Behavioral;
