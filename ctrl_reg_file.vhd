library ieee;
use ieee.std_logic_1164.all;
use work.User_lib.all;

entity Ctrl_reg_file is
  generic (DATA_WIDTH : integer := 8);
  port (
    clk       : in  std_logic;
    rst_n     : in  std_logic;
    -- Master interface
    cs_n    : in  std_logic;
		iorin_n : in  std_logic;
		iowin_n : in  std_logic;
		ain     : in  std_logic_vector(3 downto 0);
		dbin    : inout  std_logic_vector(DATA_WIDTH - 1 downto 0);
    	
    REG_MODE  : buffer std_logic_vector (DATA_WIDTH - 1 downto 0);
    REG_SRC0  : buffer std_logic_vector (DATA_WIDTH - 1 downto 0);
    REG_SRC1  : buffer std_logic_vector (DATA_WIDTH - 1 downto 0);
    REG_DES   : buffer std_logic_vector (DATA_WIDTH - 1 downto 0);
    
    REG_ROW   : buffer std_logic_vector (DATA_WIDTH - 1 downto 0);
    REG_COL   : buffer std_logic_vector (DATA_WIDTH - 1 downto 0)
  );
end entity;
architecture struct of Ctrl_reg_file is
signal load_n: std_logic;
signal store_n: std_logic;

begin
  load_n <= cs_n or iowin_n;
  store_n <= cs_n or iorin_n;
  DECODE: process (clk, rst_n, Ain)
  begin
    if (rst_n = '0') then
      REG_MODE <= (others => '0');
      REG_SRC0 <= (others => '0');
      REG_SRC1 <= (others => '0');
      REG_DES  <= (others => '0');
     
      REG_ROW  <= (others => '0');
      REG_COL  <= (others => '0');
      dbin <= (others =>'Z');
    elsif rising_edge (clk) then
      if Load_n = '0' then
        case Ain is
          when "0000" =>
            REG_MODE <= dbin;
          when "0001" =>
            REG_SRC0 <= dbin;
          when "0010" =>
            REG_SRC1 <= dbin;
          when "0011" =>
            REG_DES <= dbin;
          when "0100" =>
            REG_ROW  <= dbin;
          when "0101" =>
            REG_COL  <= dbin;
          
          when others =>
           
        end case;
      end if;
      if Store_n = '0' then
        case Ain is
          when "0000" =>
            dbin <= REG_MODE;
          when "0001" =>
            dbin <= REG_SRC0;
          when "0010" =>
            dbin <= REG_SRC1;
          when "0011" =>
            dbin <= REG_DES;
          when "0100" =>
            dbin <= REG_ROW;
          when "0101" =>
            dbin <= REG_COL;
          when "0110" =>
            
          when others =>
           dbin <= (others =>'Z');
        end case;
      end if;
    end if;
  end process;



end architecture;

