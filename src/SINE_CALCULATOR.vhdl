library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SINE_CALCULATOR is
    port(
        X: in std_logic_vector(8 downto 0);         --Angle between 0 and 359
        SINE_X: out std_logic_vector(9 downto 0);   --Sine of X
        ERR: out std_logic                          --Error signal in case angle out of bounds
    );
end SINE_CALCULATOR;

architecture Structural of SINE_CALCULATOR is
    
    component X_TRANSFORMER is
        Port (
            X : in std_logic_vector (8 downto 0);           --Angle between 0 and 359
            X_PRIME : out std_logic_vector (6 downto 0);    --Transformed angle between 0 and 90     
            ERR : out std_logic;                            --Error signal in case angle out of bounds
            SGN : out std_logic                             --Sign of the calculated sine
            );
    end component;
    
    component UNSIGNED_SINE is
        port(
            X_PRIME: in std_logic_vector(6 downto 0);           --Transformed X
            UNSIGNED_SINE: out std_logic_vector(9 downto 0)     --Interpolated sine of transformed X
        );
    end component;
    
    component SIGNED_SINE is
    port(
        SGN: in std_logic;                                  --Sign of sine
        UNSIGNED_SINE: in std_logic_vector(9 downto 0);     --Unsigned sine
        SIGNED_SINE: out std_logic_vector(9 downto 0)       --Signed sine
    );
    end component;
    
    signal x_prime: std_logic_vector(6 downto 0);
    signal sgn: std_logic;
    signal unsigned_sine_signal: std_logic_vector(9 downto 0);
    
begin

    GENERATE_X_PRIME: X_TRANSFORMER
        port map(
            X => X,
            X_PRIME => x_prime,
            SGN => sgn,
            ERR => ERR
        );
        
    GENERATE_UNSIGNED_SINE: UNSIGNED_SINE
        port map(
            X_PRIME => x_prime,
            UNSIGNED_SINE => unsigned_sine_signal
        );
        
    GENERATE_SIGNED_SINE: SIGNED_SINE
        port map(
            SGN => sgn,
            UNSIGNED_SINE => unsigned_sine_signal,
            SIGNED_SINE => SINE_X
        );

end Structural;
