-- ==============================================================
-- AITHOR: FKHM
-- COMPANY: FARNAMATIC
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_vhd_in_lib_1 is
generic (
    g_data_width : integer:= 8
    );
port (
    clk_i : in  std_logic;
    rstn_i : in  std_logic;
    d_i : in std_logic;
    d_o : out std_logic_vector(g_data_width-1 downto 0)
    );

end;


architecture a_rtl of your_vhd_in_lib_1 is 



begin


 process(clk_i)
 begin 
  if (clk_i'event and clk_i = '1') then 
      if rstn_i = '0' then 
  	d_o <= (others=>'0');
      else 
        if d_i = '1' then
        d_o <= x"A5";
	end if;
      end if;
  end if;	
 end process;

end a_rtl;
