library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRENC_4 is
    port(
        ENC_IN: in std_logic_vector(3 downto 0);        --Input
        ENC_OUT: out std_logic_vector(1 downto 0)       --Output
    );
end PRENC_4;

architecture RTL of PRENC_4 is
begin
    --tried with "when ENC_IN select" but doesn't properly updates the output when running behavioural simulation.
    --Implemented the output with Karnaugh
    ENC_OUT(1) <= ENC_IN(3) or ENC_IN(2);                       
    ENC_OUT(0) <= ENC_IN(3) or (ENC_IN(1) and (not ENC_IN(2)));
end RTL;
