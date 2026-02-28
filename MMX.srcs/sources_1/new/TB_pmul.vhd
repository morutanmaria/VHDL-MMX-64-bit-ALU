library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity pmul_tb is
end entity pmul_tb;

architecture behavior of pmul_tb is
component pmul
    Port ( 
        CLK: in  std_logic;
        RST: in  std_logic;
        START: in  std_logic;
        A, B: in  std_logic_vector(63 downto 0);
        RESULT: out std_logic_vector(63 downto 0);
        DONE: out std_logic;
        VALID: out std_logic
    );
end component;

constant CLK_PERIOD : time := 10 ns;
signal CLK_tb: std_logic := '0';
signal RST_tb: std_logic := '1';
signal START_tb: std_logic := '0';
signal A_tb: std_logic_vector(63 downto 0) := (others => '0');
signal B_tb: std_logic_vector(63 downto 0) := (others => '0');
signal RESULT_tb: std_logic_vector(63 downto 0);
signal DONE_tb: std_logic;
signal VALID_tb: std_logic;

begin

uut : pmul
    port map (
        CLK => CLK_tb,
        RST => RST_tb,
        START => START_tb,
        A => A_tb,
        B => B_tb,
        RESULT => RESULT_tb,
        DONE => DONE_tb,
        VALID => VALID_tb
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

        report "--- STARTING TEST CASE 1 (5 * 3) ---" severity NOTE;

        A_tb <= (others => '0'); 
        B_tb <= (others => '0');
        wait for CLK_PERIOD;
        
        A_tb(7 downto 0)  <= X"05"; 
        B_tb(7 downto 0)  <= X"03"; 
        
        START_tb <= '1';
        wait until rising_edge(CLK_tb);
        START_tb <= '0'; 

        wait until DONE_tb = '1';
        wait for CLK_PERIOD; 

        assert RESULT_tb(7 downto 0) = X"0F" 
            report "Test 1 FAILED: Lane 0 (5 * 3) did not equal X'0F'"
            severity ERROR;

        wait for CLK_PERIOD * 5; 

        report "--- STARTING TEST CASE 2 (SIMD) ---" severity NOTE;
        
        RST_tb <= '1';
        wait for CLK_PERIOD * 3;
        RST_tb <= '0';
        wait for CLK_PERIOD;
        
        A_tb(63 downto 56) <= X"0A"; 
        B_tb(63 downto 56) <= X"0A";
        A_tb(7 downto 0)   <= X"1E"; 
        B_tb(7 downto 0)   <= X"0A"; 

        START_tb <= '1';
        wait until rising_edge(CLK_tb);
        START_tb <= '0'; 

        wait until DONE_tb = '1';
        wait for CLK_PERIOD; 

        assert RESULT_tb(63 downto 56) = X"64" 
            report "Test 2 FAILED (L7): 10*10 did not equal X'64'" 
            severity ERROR;
        assert RESULT_tb(7 downto 0) = X"2C" 
            report "Test 2 FAILED (L0): Overflow test did not equal X'2C'" 
            severity ERROR;

        wait for CLK_PERIOD * 5;
        wait; 

end process TEST_PROC;

end architecture behavior;