LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use work.User_Lib.all;
USE ieee.std_logic_unsigned.all;

ENTITY core IS
   GENERIC (
            CTRL_WIDTH		: integer := 8; 	-- Control bus width
	    DATA_WIDTH        :     integer   := 8;     -- Word bus Width
            ADDR_WIDTH        :     integer   := 2      -- Address bus width
           
    );
   PORT ( Clock, nReset: IN STD_LOGIC ;
          Start: IN STD_LOGIC ;
          
          LIR, SAR0, DAR : IN STD_LOGIC_VECTOR (CTRL_WIDTH - 1 downto 0);
	  MemW_n: OUT STD_LOGIC;
          MemR_n: OUT STD_LOGIC;
          
          data_in : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
          addr_R : OUT STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
          Done    : OUT STD_LOGIC;
	  addr_W : OUT STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
	  data_out : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0) ) ;
   END core ;
ARCHITECTURE RTL OF core IS
  SIGNAL a_Sel, b_Sel: STD_LOGIC;

  SIGNAL LD_i:  STD_LOGIC; -- Load signal for Counter i
  SIGNAL En_i:  STD_LOGIC;
  SIGNAL EN_A, EN_B, EN_T:  STD_LOGIC; 
  SIGNAL i_lt_L : STD_LOGIC;  
  SIGNAL MemW,MemR : STD_LOGIC;
  SIGNAL addr_A, addr_B :  STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
  SIGNAL D_out : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
  SIGNAL Reset : STD_LOGIC;     
BEGIN
CRTL_U: Controller 
   PORT MAP( Clock,
             nReset,
             Start,
          
          i_lt_L,
          
          a_sel,
          b_sel,
          MemR,
          MemW,
          
          LD_i,
          
          En_i,
         
          EN_A,
          EN_B,
	  EN_T,
          reset,
	  Done) ;
   
Datapath_U: Datapath
  GENERIC MAP(
            CTRL_WIDTH => CTRL_WIDTH,	  -- control width
	    DATA_WIDTH => DATA_WIDTH,     -- Word Width
            ADDR_WIDTH => ADDR_WIDTH      -- Address width
           
          )
   PORT MAP( Clock, 
          Reset,
          
          LIR, SAR0, DAR,
          a_Sel, 
          b_Sel, -- The signal selects the input data and address for memory
          
          LD_i, 
         
          En_i,
          
          EN_A,
          EN_B,
	  EN_T,
          data_in,
          addr_A, -- addr_A
	  addr_B, -- addr_B
          i_lt_L,
          
	  D_out ) ;
--- Tr--state buffer
 MemR_n <= MemR WHEN Start = '1' ELSE 'Z' ;  
 MemW_n <= MemW WHEN Start = '1' ELSE 'Z' ;  
 Addr_R <= Addr_A When Start = '1' ELSE (Others => 'Z');
 Addr_W <= Addr_B When Start = '1' ELSE (Others => 'Z');
 Data_out <= D_out When Start = '1' ELSE (Others => 'Z');
END RTL;  