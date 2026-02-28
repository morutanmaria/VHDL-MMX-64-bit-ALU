library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mmx_basys is
    Port ( 
        CLK    : in STD_LOGIC;
        BTN    : in STD_LOGIC; 
        BTNRST : in STD_LOGIC; 
        SW     : in STD_LOGIC_VECTOR (15 downto 0); 
        LED    : out STD_LOGIC_VECTOR (7 downto 0);
        SEG    : out STD_LOGIC_VECTOR (6 downto 0);
        AN     : out STD_LOGIC_VECTOR (3 downto 0)
    );
end mmx_basys;

architecture Behavioral of mmx_basys is
signal rom_addr    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal rom_data    : STD_LOGIC_VECTOR(130 downto 0);
signal alu_res     : STD_LOGIC_VECTOR(63 downto 0);
signal view_data   : STD_LOGIC_VECTOR(15 downto 0);
signal next_addr_pulse : std_logic;
    
signal done_s, busy_s : STD_LOGIC;
signal carry_s, under_s : STD_LOGIC_VECTOR(7 downto 0);
signal alu_rst_internal : std_logic;

component mmx_rom is
    Port ( ADDR : in STD_LOGIC_VECTOR (3 downto 0);
           DATA : out STD_LOGIC_VECTOR (130 downto 0));
end component;

component mmx_alu is
    Port ( CLK : in STD_LOGIC; 
           RST : in STD_LOGIC;
           OPCODE : in STD_LOGIC_VECTOR (2 downto 0);
           A_IN : in STD_LOGIC_VECTOR (63 downto 0);
           B_IN : in STD_LOGIC_VECTOR (63 downto 0);
           RES_OUT : out STD_LOGIC_VECTOR (63 downto 0);
           DONE_OUT : out STD_LOGIC;
           PMUL_BUSY : out STD_LOGIC;
           CARRY_OUT : out STD_LOGIC_VECTOR(7 downto 0);
           UNDERFLOW_OUT : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component ssd is
      Port ( input : in STD_LOGIC_VECTOR (15 downto 0);
             clk : in STD_LOGIC;
             an : out STD_LOGIC_VECTOR (3 downto 0); 
             cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component debouncer is
        port( btn: in std_logic; 
              clk: in std_logic; 
              rst: in std_logic; 
              ENABLE: out std_logic );
end component;

begin
    rom_comp : mmx_rom port map( ADDR => rom_addr, DATA => rom_data);
    
alu_rst_internal <= BTNRST or next_addr_pulse;
-- 000:PADD, 001:PSUB, 010:PAVG, 011:PINC, 100:PDEC, 101:PMUL
    alu_comp : mmx_alu port map (
        CLK => CLK, 
        RST => alu_rst_internal,
        OPCODE => SW(15 downto 13), 
        A_IN => rom_data(127 downto 64), 
        B_IN => rom_data(63 downto 0),   
        RES_OUT => alu_res, 
        DONE_OUT => done_s,
        PMUL_BUSY => busy_s,
        CARRY_OUT => carry_s,
        UNDERFLOW_OUT => under_s
    );  

    debouncer_addr : debouncer port map( btn => BTN, clk => CLK, rst => BTNRST, ENABLE => next_addr_pulse );
    
    process(CLK) begin
        if rising_edge(CLK) then
            if BTNRST = '1' then rom_addr <= (others => '0');
            elsif next_addr_pulse = '1' then rom_addr <= rom_addr + 1;
            end if;
        end if;
    end process;

    process(SW, alu_res) begin
        case SW(1 downto 0) is
            when "00"   => view_data <= alu_res(15 downto 0);
            when "01"   => view_data <= alu_res(31 downto 16);
            when "10"   => view_data <= alu_res(47 downto 32);
            when others => view_data <= alu_res(63 downto 48);
        end case;
    end process;

    display_comp : ssd port map ( clk => CLK, input => view_data, cat => SEG, an => AN );
    
    LED(3 downto 0) <= rom_addr;
    LED(4) <= busy_s;
    LED(5) <= done_s;
    LED(7 downto 6) <= SW(15 downto 14);

end Behavioral;