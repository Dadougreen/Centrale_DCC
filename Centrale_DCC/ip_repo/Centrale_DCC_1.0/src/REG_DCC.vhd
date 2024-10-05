
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity REG_DCC is
  Port (
    clk100 : in std_logic;
    reset : in std_logic;
    
    trame : in std_logic_vector(50 downto 0);
    load : in std_logic;
    shift : in std_logic;
    
    msb_trame : out std_logic
  );
end REG_DCC;

architecture Behavioral of REG_DCC is
signal sig_trame : std_logic_vector(50 downto 0);
begin
    process(clk100, reset)
    begin
        if(reset = '1') then
            sig_trame <= (others => '0');
        elsif(rising_edge(clk100)) then
            if(load = '1') then
                sig_trame <= trame;
            elsif(shift = '1') then
                sig_trame <= sig_trame(49 downto 0) & '0';
            end if;
        end if;
         
    end process;
msb_trame <= sig_trame(50);   
end Behavioral;
