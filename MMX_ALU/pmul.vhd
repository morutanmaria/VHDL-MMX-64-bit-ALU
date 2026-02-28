----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2025 22:02:09
-- Design Name: 
-- Module Name: pmul - Behavioral
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

entity pmul is
    Port ( 
        CLK : in  std_logic;
        RST : in  std_logic;
        START : in  std_logic;
        A, B : in  std_logic_vector(63 downto 0);
        RESULT : out std_logic_vector(63 downto 0);
        DONE : out std_logic;
        VALID : out std_logic
    );
end pmul;

architecture Behavioral of pmul is
signal lane_status : std_logic_vector(7 downto 0); 
signal done_aux : std_logic;

component mul_8bit is
    Port(
    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;
    START_MUL : IN STD_LOGIC;
    A_MCAND : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    B_MPLIER : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RESULT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    VALID : OUT STD_LOGIC
    ); 
end component;

begin   
lane_0 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(7 downto 0),
    B_MPLIER => B(7 downto 0),
    RESULT => RESULT(7 downto 0),
    VALID => lane_status(0)
    ); 
lane_1 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(15 downto 8),
    B_MPLIER => B(15 downto 8),
    RESULT => RESULT(15 downto 8),
    VALID => lane_status(1)
    );
lane_2 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(23 downto 16),
    B_MPLIER => B(23 downto 16),
    RESULT => RESULT(23 downto 16),
    VALID => lane_status(2)
    );
lane_3 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(31 downto 24),
    B_MPLIER => B(31 downto 24),
    RESULT => RESULT(31 downto 24),
    VALID => lane_status(3)
    );
lane_4 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(39 downto 32),
    B_MPLIER => B(39 downto 32),
    RESULT => RESULT(39 downto 32),
    VALID => lane_status(4)
    );
lane_5 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(47 downto 40),
    B_MPLIER => B(47 downto 40),
    RESULT => RESULT(47 downto 40),
    VALID => lane_status(5)
    );
lane_6 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(55 downto 48),
    B_MPLIER => B(55 downto 48),
    RESULT => RESULT(55 downto 48),
    VALID => lane_status(6)
    );
lane_7 : mul_8bit 
    Port map (
    CLK  => CLK,
    RST => RST,
    START_MUL => START,
    A_MCAND => A(63 downto 56),
    B_MPLIER => B(63 downto 56),
    RESULT => RESULT(63 downto 56),
    VALID => lane_status(7)
    );

    done_aux <= lane_status(0) and lane_status(1) and lane_status(2) and lane_status(3) and 
            lane_status(4) and lane_status(5) and lane_status(6) and lane_status(7);
    DONE <= done_aux;
    VALID <= done_aux;
end Behavioral;

