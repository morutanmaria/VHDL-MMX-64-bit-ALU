library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    port(
        btn    : in  std_logic;
        clk    : in  std_logic;
        rst    : in  std_logic;
        ENABLE : out std_logic
    );
end debouncer;

architecture Behavioral of debouncer is
    signal clk_counter : std_logic_vector(15 downto 0) := (others => '0');
    signal Q1, Q2, Q3 : std_logic := '0';
    signal sample_en   : std_logic := '0';
begin

cnt: process(clk, rst)
begin
    if rst = '1' then
        clk_counter <= (others => '0');
        sample_en   <= '0';
    elsif rising_edge(clk) then
        if clk_counter = X"FFFF" then
            clk_counter <= (others => '0');
            sample_en   <= '1';
        else
            clk_counter <= clk_counter + 1;
            sample_en   <= '0';
        end if;
    end if;
end process;

Debounce: process(clk, rst)
begin
    if rst = '1' then
        Q1 <= '0';
        Q2 <= '0';
        Q3 <= '0';
    elsif rising_edge(clk) then
        if sample_en = '1' then
            Q1 <= btn;
        end if;
        Q2 <= Q1;
        Q3 <= Q2;
    end if;
end process;

ENABLE <= Q2 AND (NOT Q3);

end Behavioral;
