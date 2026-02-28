----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2025 22:53:41
-- Design Name: 
-- Module Name: mmx_alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity mmx_alu is
    Port ( 
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        OPCODE : in STD_LOGIC_VECTOR(2 downto 0);
        A_IN : in STD_LOGIC_VECTOR(63 downto 0);
        B_IN : in STD_LOGIC_VECTOR(63 downto 0);
        RES_OUT : out STD_LOGIC_VECTOR(63 downto 0);
        DONE_OUT : out STD_LOGIC;
        PMUL_BUSY : out STD_LOGIC;
        CARRY_OUT : out STD_LOGIC_VECTOR(7 downto 0);
        UNDERFLOW_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end mmx_alu;

architecture Behavioral of mmx_alu is
constant OP_PADD : STD_LOGIC_VECTOR(2 downto 0) := "000";
constant OP_PSUB : STD_LOGIC_VECTOR(2 downto 0) := "001";
constant OP_PAVG : STD_LOGIC_VECTOR(2 downto 0) := "010";
constant OP_PINC : STD_LOGIC_VECTOR(2 downto 0) := "011";
constant OP_PDEC : STD_LOGIC_VECTOR(2 downto 0) := "100";
constant OP_PMUL : STD_LOGIC_VECTOR(2 downto 0) := "101";
constant OP_NOP  : STD_LOGIC_VECTOR(2 downto 0) := "110";

signal RES_PADD, RES_PSUB, RES_PAVG, RES_PINC, RES_PDEC, RES_PMUL : STD_LOGIC_VECTOR(63 downto 0);
signal PADD_CARRY, PSUB_UNDER : STD_LOGIC_VECTOR(7 downto 0);
signal START_PMUL, DONE_PMUL : STD_LOGIC;

signal RES_MUX : STD_LOGIC_VECTOR(63 downto 0);

signal RES_REG : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal CARRY_REG : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal UNDER_REG : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal DONE_REG : STD_LOGIC := '0';
signal BUSY_REG : STD_LOGIC := '0';

component padd 
    Port(
        A, B: in  std_logic_vector(63 downto 0);
        CARRY_FLAG : out std_logic_vector(7 downto 0);
        RESULT : out std_logic_vector(63 downto 0);
        VALID : out std_logic
    );
end component;

component psub
    Port(
        A, B : in  std_logic_vector(63 downto 0);
        UNDERFLOW_FLAG : out std_logic_vector(7 downto 0);
        RESULT : out std_logic_vector(63 downto 0);
        VALID : out std_logic
    );
end component;

component pavg
    Port ( 
        A : in STD_LOGIC_VECTOR(63 downto 0);
        B : in STD_LOGIC_VECTOR(63 downto 0);
        RESULT : out STD_LOGIC_VECTOR(63 downto 0);
        VALID : out STD_LOGIC
    );
end component;

component pinc 
    Port ( 
        A : in STD_LOGIC_VECTOR(63 downto 0);
        RESULT : out STD_LOGIC_VECTOR(63 downto 0);
        VALID : out STD_LOGIC
    );
end component;

component pdec 
    Port ( 
        A : in STD_LOGIC_VECTOR(63 downto 0);
        RESULT : out STD_LOGIC_VECTOR(63 downto 0);
        VALID : out STD_LOGIC
    );
end component;

component pmul 
    Port ( 
        CLK : in  std_logic;
        RST : in  std_logic;
        START : in  std_logic;
        A, B : in  std_logic_vector(63 downto 0);
        RESULT : out std_logic_vector(63 downto 0);
        DONE : out std_logic;
        VALID : out std_logic
    );
end component;

begin

padd_comp : padd port map (
    A => A_IN,
    B => B_IN,
    CARRY_FLAG => PADD_CARRY,
    RESULT => RES_PADD,
    VALID => open
);

psub_comp : psub port map (
    A => A_IN,
    B => B_IN,
    UNDERFLOW_FLAG => PSUB_UNDER,
    RESULT => RES_PSUB,
    VALID => open
);

pavg_comp : pavg port map (
    A => A_IN,
    B => B_IN,
    RESULT => RES_PAVG,
    VALID => open
);

pdec_comp : pdec port map (
    A => A_IN,
    RESULT => RES_PDEC,
    VALID => open
);

pinc_comp : pinc port map (
    A => A_IN,
    RESULT => RES_PINC,
    VALID => open
);

pmul_comp : pmul port map (
    CLK => CLK,
    RST => RST,
    START => START_PMUL,
    A => A_IN,
    B => B_IN,
    RESULT => RES_PMUL,
    DONE => DONE_PMUL,
    VALID => open
);

with OPCODE select
    RES_MUX <= RES_PADD when OP_PADD,
               RES_PSUB when OP_PSUB,
               RES_PAVG when OP_PAVG,
               RES_PINC when OP_PINC,
               RES_PDEC when OP_PDEC,
               RES_PMUL when OP_PMUL,
               (others => '0') when others;

process(CLK, RST)
begin
    if RST = '1' then
        RES_REG    <= (others => '0');
        CARRY_REG  <= (others => '0');
        UNDER_REG  <= (others => '0');
        DONE_REG   <= '0';
        BUSY_REG   <= '0';
        START_PMUL <= '0';

    elsif rising_edge(CLK) then
        START_PMUL <= '0';
        DONE_REG   <= '0';

        if BUSY_REG = '1' then
            if DONE_PMUL = '1' then
                RES_REG  <= RES_PMUL;
                DONE_REG <= '1';
                BUSY_REG <= '0';
            end if;

        elsif OPCODE = OP_PMUL then
            START_PMUL <= '1'; 
            BUSY_REG   <= '1';

        else
            RES_REG <= RES_MUX;
            DONE_REG <= '1';

            if OPCODE = OP_PADD then
                CARRY_REG <= PADD_CARRY;
            elsif OPCODE = OP_PSUB then
                UNDER_REG <= PSUB_UNDER;
            end if;
        end if;
    end if;
end process;

RES_OUT <= RES_REG;
DONE_OUT <= DONE_REG;
PMUL_BUSY <= BUSY_REG;
CARRY_OUT <= CARRY_REG;
UNDERFLOW_OUT <= UNDER_REG;

end Behavioral;
