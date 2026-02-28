library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul_8bit is
    Port (
        CLK : in  std_logic;
        RST : in  std_logic;
        START_MUL : in  std_logic;
        A_MCAND : in  std_logic_vector(7 downto 0);
        B_MPLIER : in  std_logic_vector(7 downto 0);
        RESULT : out std_logic_vector(7 downto 0);
        VALID : out std_logic
    );
end mul_8bit;

architecture Behavioral of mul_8bit is
type state_t is (IDLE, RUN, DONE);
signal state : state_t := IDLE;
signal M : unsigned(7 downto 0);
signal A : unsigned(7 downto 0);
signal Q : unsigned(7 downto 0);
signal count : integer range 0 to 8 := 0;
begin

process(CLK)
variable sum : unsigned(8 downto 0);
begin
    if rising_edge(CLK) then
        if RST = '1' then
            state <= IDLE;
            A <= (others => '0');
            Q <= (others => '0');
            M <= (others => '0');
            count <= 0;
            VALID <= '0';

        else
            case state is
                when IDLE =>
                    VALID <= '0';
                    if START_MUL = '1' then
                        M <= unsigned(A_MCAND);
                        Q <= unsigned(B_MPLIER);
                        A <= (others => '0');
                        count <= 0;
                        state <= RUN;
                    end if;

                when RUN =>
                    if Q(0) = '1' then
                        sum := ('0' & A) + ('0' & M);
                    else
                        sum := ('0' & A);
                    end if;
                    A <= sum(8 downto 1);
                    Q <= sum(0) & Q(7 downto 1);
                    if count = 7 then
                        state <= DONE;
                    else
                        count <= count + 1;
                    end if;
                when DONE =>
                    VALID <= '1';
                    state <= DONE; 
            end case;
        end if;
    end if;
end process;

RESULT <= std_logic_vector(Q); 

end Behavioral;
