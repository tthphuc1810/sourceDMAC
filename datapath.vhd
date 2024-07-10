LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use work.User_Lib.all;
use ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
ENTITY Datapath IS
   GENERIC (
	    CTRL_WIDTH        :     integer   := 8; 	-- Controll bus width
            DATA_WIDTH        :     integer   := 8;     -- Data bus Width
            ADDR_WIDTH        :     integer   := 8      -- Address bus width
           
    );
   PORT ( Clock, Reset: IN STD_LOGIC ;
          
          
	  LIR, SAR0, DAR : IN STD_LOGIC_VECTOR (CTRL_WIDTH - 1 downto 0);
          a_Sel, b_Sel: IN STD_LOGIC; -- The signal selects the input data and address for memory
                    
          LD_i: IN STD_LOGIC; -- Load signal for Counter i
          En_i: IN STD_LOGIC;
          EN_A, EN_B, EN_T: IN STD_LOGIC;
          data_in : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
          addr_a, addr_b : out STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
          i_lt_L : OUT STD_LOGIC;
	  data_out : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0) ) ;
   END Datapath ;
ARCHITECTURE RTL OF Datapath IS


  signal i : std_logic_vector( ADDR_WIDTH-1 downto 0);
  signal A,B,A_in,B_in : std_logic_vector(DATA_WIDTH -1 downto 0);

BEGIN
 

  B_in <= DAR when b_sel = '0' else (B+1);
  A_in <= SAR0 when a_sel = '0' else (A+1);
  addr_a <= A;
  addr_b <= B; 


  --------------
  -- Register A
  RegA: regn
  generic map
     (
      N => DATA_WIDTH
      )
    port map (
      D => A_in, 
      Reset   => Reset,
      clock   => clock,
      En      => En_A,
      Q  => A
      
      );  
  -- Register B
  RegB: regn
  generic map
     (
      N => DATA_WIDTH
      )
    port map (
      D => B_in, 
      Reset   => Reset,
      clock   => clock,
      En      => En_B,
      Q  => B
      
      );     
   -- Register T
  RegT: regn
  generic map
     (
      N => DATA_WIDTH
      )
    port map (
      D => data_in, 
      Reset   => Reset,
      clock   => clock,
      En      => En_T,
      Q  => data_out
      
      );      
-- Counter i
Cnt_i: Counter_n
  generic map
     (
      N => CTRL_WIDTH
      )
    port map (
      clk   => clock,
      Reset   => Reset,
      Enable  => En_i,
      Load    => LD_i,
      Din => (Others => '0'), 
      Count  => i
       ); 
  --i_gt_0 <= '1' WHEN i > conv_std_logic_vector(0,ADDR_WIDTH) ELSE '0';  
	i_lt_L <= '1' WHEN i < LIR  ELSE '0';     

 
    
END RTL;   