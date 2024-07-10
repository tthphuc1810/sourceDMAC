LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use work.User_Lib.all;
USE ieee.std_logic_unsigned.all;

ENTITY DMAC IS
   GENERIC (
            CTRL_WIDTH		: integer := 8; 	-- Control bus width
	    DATA_WIDTH        :     integer   := 8;     -- Word bus Width
            ADDR_WIDTH        :     integer   := 8      -- Address bus width
           
    );
   PORT ( Clock, nReset: IN STD_LOGIC ;
	  dreq, Hlda  : in    std_logic;
    	  Hreq, Dack  : out   std_logic;	
          
           -- Master interface
    		cs_n    : in  std_logic;
		iorin_n : in  std_logic;
		iowin_n : in  std_logic;
		ain     : in  std_logic_vector(3 downto 0);
		dbin    : inout  std_logic_vector(DATA_WIDTH - 1 downto 0); 
          
	  MemW_n: OUT STD_LOGIC;
          MemR_n: OUT STD_LOGIC;
          RDY_READ : IN STD_LOGIC;
          RDY_Wrt : IN STD_LOGIC;
          data_in : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
          addr_R : OUT STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
         
	  addr_W : OUT STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
	  data_out : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0) ) ;
   END DMAC ;
ARCHITECTURE RTL OF DMAC IS
  

  SIGNAL RIR, CIR, SAR0, SAR1, DAR : STD_LOGIC_VECTOR (CTRL_WIDTH - 1 downto 0); 
  SIGNAL    REG_MODE  :  std_logic_vector (DATA_WIDTH - 1 downto 0);
  SIGNAL    REG_SRC0  :  std_logic_vector (DATA_WIDTH - 1 downto 0);
  SIGNAL    REG_SRC1  :  std_logic_vector (DATA_WIDTH - 1 downto 0);
  SIGNAL    REG_DES   :  std_logic_vector (DATA_WIDTH - 1 downto 0);
    
  SIGNAL    REG_ROW   :  std_logic_vector (DATA_WIDTH - 1 downto 0);
  SIGNAL    REG_COL   :  std_logic_vector (DATA_WIDTH - 1 downto 0);
  SIGNAL Start:  STD_LOGIC ; 
  SIGNAL Done    :  STD_LOGIC;
BEGIN
--
U0: interface 
  
  port map(
    clock,
    nreset,
-- External
    dreq, Hlda,
    Hreq, Dack,
-- Internal
    Done,
    Start  
  );

-- Core componenet
  U1:  core
    generic map
    (
 	CTRL_WIDTH => CTRL_WIDTH,     
	DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
      )
     
    port map (
       
          Clock,
          nReset,
          Start,
	  
          RIR, SAR0, DAR,
          MemW_n,
          MemR_n,
          
          data_in,
          addr_R,
          Done,
	  addr_W,
	  data_out
      
      );
-- control register file
U2: Ctrl_reg_file
  generic map (DATA_WIDTH => DATA_WIDTH)
  port map (
    clock,
    nreset,
    -- Master interface
    cs_n,
    iorin_n ,
    iowin_n,
    ain,
    dbin,
    
    REG_MODE ,
    REG_SRC0 ,
    REG_SRC1 ,
    REG_DES ,
    
    REG_ROW   ,
    REG_COL  
  );
RIR <= REG_ROW;
CIR <= REG_COL;
SAR0 <= REG_SRC0;
SAR1 <= REG_SRC1;
DAR <= REG_DES;
END RTL;  
