----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 21:49:50
-- Design Name: 
-- Module Name: pinc - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pinc is
    Port ( A : in STD_LOGIC_VECTOR (63 downto 0);
           RESULT : out STD_LOGIC_VECTOR (63 downto 0);
           VALID : out STD_LOGIC
    );
end pinc;

architecture Behavioral of pinc is

begin
process(A)
variable a_byte: std_logic_vector(7 downto 0);
variable temp: std_logic_vector(63 downto 0);
begin
    temp := (others => '0');
    for i in 0 to 7 loop
        a_byte := (A(i*8+7 downto i*8));
        temp(i*8+7 downto i*8) := a_byte + "00000001";
    end loop;
RESULT <= temp;
VALID <= '1'; 
end process;
end Behavioral;
