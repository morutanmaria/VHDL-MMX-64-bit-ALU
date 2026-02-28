----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2025 23:22:23
-- Design Name: 
-- Module Name: psub - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity psub is
  port(
    A, B    : in  std_logic_vector(63 downto 0);
    UNDERFLOW_FLAG : out std_logic_vector(7 downto 0);
    RESULT  : out std_logic_vector(63 downto 0);
    VALID   : out std_logic
  );
end entity psub;

architecture Behavioral of psub is
signal ifunder : STD_LOGIC_VECTOR(8 downto 0);
signal local_under : STD_LOGIC_VECTOR(7 downto 0);
begin
process(A, B)
variable a_byte, b_byte : STD_LOGIC_VECTOR(7 downto 0);
variable temp : STD_LOGIC_VECTOR(63 downto 0);
  begin
    temp := (others => '0');
        for i in 0 to 7 loop
          a_byte := (A(i*8+7 downto i*8));
          b_byte := (B(i*8+7 downto i*8));
          ifunder <= ('0' & a_byte) - ('0' & b_byte);
          temp(i*8+7 downto i*8) := std_logic_vector(a_byte - b_byte);

          if ifunder(8) = '1' then
            local_under(i) <= '1';
            else 
            local_under(i) <= '0';
          end if; 
        end loop;

RESULT <= temp;
VALID  <= '1';

end process;
UNDERFLOW_FLAG <= local_under;
end architecture Behavioral;
