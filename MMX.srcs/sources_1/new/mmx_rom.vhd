----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 14:30:38
-- Design Name: 
-- Module Name: mmx_rom - Behavioral
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

entity mmx_rom is
    Port ( ADDR : in STD_LOGIC_VECTOR (3 downto 0);
           DATA : out STD_LOGIC_VECTOR (130 downto 0));
end mmx_rom;

architecture Behavioral of mmx_rom is
type rom_array is array (0 to 15) of STD_LOGIC_VECTOR(127 downto 0);
constant ROM : rom_array := (
    0 => x"000000000000000A" & x"0000000000000002", 
    1 => x"000000000000F0FF" & x"0000000000000101", 
    2 => x"0000000000000004" & x"0000000000000001", 
    3 => x"000000000000000F" & x"000000000000000E", 
    4 => x"0000000000001003" & x"0000000000000001", 
    others => (others => '0'));
begin
    DATA <= "000" & ROM(conv_integer(ADDR)); 
end Behavioral;