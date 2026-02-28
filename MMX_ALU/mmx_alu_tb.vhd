----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2025 20:18:25
-- Design Name: 
-- Module Name: mmx_alu_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity mmx_alu_tb is
end entity mmx_alu_tb;

  architecture behavior of mmx_alu_tb is
component mmx_alu
    Port ( 
        CLK : in  std_logic;
        RST : in  std_logic;
        OPCODE : in  std_logic_vector(2 downto 0); 
        A_IN, B_IN : in  std_logic_vector(63 downto 0);
        RES_OUT : out std_logic_vector(63 downto 0);
        DONE_OUT : out std_logic;
        PMUL_BUSY : out std_logic;
        CARRY_OUT : out std_logic_vector(7 downto 0); 
        UNDERFLOW_OUT : out std_logic_vector(7 downto 0) 
);
end component;
constant CLK_PERIOD : time := 10 ns;
signal CLK_tb : std_logic := '0';
signal RST_tb : std_logic := '1';
signal OPCODE_tb : std_logic_vector(2 downto 0) := "000";
signal A_tb : std_logic_vector(63 downto 0) := (others => '0');
signal B_tb : std_logic_vector(63 downto 0) := (others => '0');
signal RESULT_tb : std_logic_vector(63 downto 0);
signal DONE_tb : std_logic;
signal BUSY_tb : std_logic;
signal CARRY_tb : std_logic_vector(7 downto 0); 
signal UNDERFLOW_tb : std_logic_vector(7 downto 0);

constant OP_PADD : STD_LOGIC_VECTOR(2 downto 0) := "000";
constant OP_PSUB : STD_LOGIC_VECTOR(2 downto 0) := "001";
constant OP_PAVG : STD_LOGIC_VECTOR(2 downto 0) := "010";
constant OP_PINC : STD_LOGIC_VECTOR(2 downto 0) := "011";
constant OP_PDEC : STD_LOGIC_VECTOR(2 downto 0) := "100";
constant OP_PMUL : STD_LOGIC_VECTOR(2 downto 0) := "101";
constant OP_NOP : STD_LOGIC_VECTOR(2 downto 0) := "110";

begin
uut : mmx_alu
    port map (
        CLK => CLK_tb,    
        RST => RST_tb,
        OPCODE => OPCODE_tb, 
        A_IN => A_tb,
        B_IN => B_tb,      
        RES_OUT => RESULT_tb,
        DONE_OUT => DONE_tb, 
        PMUL_BUSY => BUSY_tb,
        CARRY_OUT => CARRY_tb, 
        UNDERFLOW_OUT => UNDERFLOW_tb
    );

CLK_PROCESS : process
begin
    loop
        CLK_tb <= '0';
        wait for CLK_PERIOD / 2;
        CLK_tb <= '1';
        wait for CLK_PERIOD / 2;
    end loop;
end process CLK_PROCESS;

TEST_PROC : process
    begin
        RST_tb <= '1';
        wait for CLK_PERIOD * 5; 
        RST_tb <= '0';
        wait for CLK_PERIOD; 
        
        A_tb <= X"0102030405060708";
        B_tb <= X"0000000000000001";
        
        ---------------------------------------------------
        -- TEST 1: PADD 
        ---------------------------------------------------
        report "--- TEST 1: PADD (08+01) ---" severity NOTE;
        OPCODE_tb <= OP_PADD;
        A_tb(7 downto 0) <= X"FF"; 
        B_tb(7 downto 0) <= X"01"; 
        
        wait until rising_edge(CLK_tb); 
        
        assert DONE_tb = '1'
            report "Test 1 Failed: PADD (Single Cycle) did not assert DONE in 1 cycle."
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"00"
            report "Test 1 Failed: PADD result (FF+01) not 00."
            severity ERROR;
        assert CARRY_tb(0) = '1'
            report "Test 1 Failed: PADD Carry flag not set."
            severity ERROR;
            
        wait for CLK_PERIOD * 7; 
        OPCODE_tb <= OP_NOP;
        ---------------------------------------------------
        -- TEST 2: PSUB 
        ---------------------------------------------------
        report "--- TEST 2: PSUB (00-01) ---" severity NOTE;
        OPCODE_tb <= OP_PSUB;
        A_tb(7 downto 0) <= X"00"; 
        B_tb(7 downto 0) <= X"01"; 
        
        wait until rising_edge(CLK_tb); 

        assert DONE_tb = '1'
            report "Test 2 Failed: PSUB (Single Cycle) did not assert DONE in 1 cycle."
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"FF"
            report "Test 2 Failed: PSUB result (00-01) not FF."
            severity ERROR;
        assert UNDERFLOW_tb(0) = '1'
            report "Test 2 Failed: PSUB Underflow flag not set."
            severity ERROR;

        wait for CLK_PERIOD * 7; 
        OPCODE_tb <= OP_NOP;
        ---------------------------------------------------
        -- TEST 3: PAVG 
        ---------------------------------------------------
        report "--- TEST 3: PAVG (15,7 -> 0b) ---" severity NOTE;
        OPCODE_tb <= OP_PAVG;
        A_tb(7 downto 0) <= X"0F"; 
        B_tb(7 downto 0) <= X"07"; 
        
        wait until rising_edge(CLK_tb); 
        
        assert DONE_tb = '1'
            report "Test 3 Failed: PAVG (Single Cycle) did not assert DONE in 1 cycle."
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"0B"
            report "Test 3 Failed: PAVG result (FF+01) not 00."
            severity ERROR;
            
        wait for CLK_PERIOD * 7;
        OPCODE_tb <= OP_NOP;
        ---------------------------------------------------
        -- TEST 4: PINC 
        ---------------------------------------------------
        report "--- TEST 4: PINC (8 -> 9) ---" severity NOTE;
        OPCODE_tb <= OP_PINC;

        A_tb(7 downto 0) <= X"08";  
        
        wait until rising_edge(CLK_tb); 
        
        assert DONE_tb = '1'
            report "Test 4 Failed: PINC (Single Cycle) did not assert DONE in 1 cycle."
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"09"
            report "Test 4 Failed: PAVG result (FF+01) not 00."
            severity ERROR;
            
        wait for CLK_PERIOD * 7;
        OPCODE_tb <= OP_NOP;
        ---------------------------------------------------
        -- TEST 5: PDEC 
        ---------------------------------------------------
        report "--- TEST 5: PDEC (0f->0e) ---" severity NOTE;
        OPCODE_tb <= OP_PDEC;
        A_tb(7 downto 0) <= X"0F";  
        
        wait until rising_edge(CLK_tb); 
        
        assert DONE_tb = '1'
            report "Test 5 Failed: PDEC (Single Cycle) did not assert DONE in 1 cycle."
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"0E"
            report "Test 5 Failed: PAVG result (FF+01) not 00."
            severity ERROR;
            
        wait for CLK_PERIOD * 7;
        OPCODE_tb <= OP_NOP;
        ---------------------------------------------------
        -- TEST 6: PMUL 
        ---------------------------------------------------
        report "--- TEST 6: PMUL (Multi-Cycle 5*3=0F) ---" severity NOTE;
        OPCODE_tb <= OP_PMUL;
        A_tb <= (others => '0'); A_tb(7 downto 0) <= X"05"; 
        B_tb <= (others => '0'); B_tb(7 downto 0) <= X"03"; 
        
        wait until rising_edge(CLK_tb); 
        
        assert DONE_tb = '0'
            report "Test 6 Failed: DONE asserted too early."
            severity ERROR;

        wait for CLK_PERIOD * 7;

        wait until rising_edge(CLK_tb); 
        
        assert DONE_tb = '1'
            report "Test 6 Failed: PMUL (Multi-Cycle) did not assert DONE."
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"0F"
            report "Test 6 Failed: PMUL result (5*3) not 0F."
            severity ERROR;
        assert BUSY_tb = '0'
            report "Test 6 Failed: PMUL BUSY signal did not drop."
            severity ERROR;
            
            
        wait for CLK_PERIOD * 2;
        
        report "--- MMX ALU Tests Complete ---" severity NOTE;
        wait; 

    end process TEST_PROC;

end architecture behavior;