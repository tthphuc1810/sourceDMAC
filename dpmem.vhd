library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
-------------------------------------------------------------------------------
-- Synchronous Dual Port Memory
-------------------------------------------------------------------------------
entity dpmem is
  generic (
    DATA_WIDTH        :     integer   := 8;     -- Word Width
    ADDR_WIDTH        :     integer   := 8      -- Address width
    );

  port (
    -- Writing
    	Clk              : in  std_logic;          -- clock
	nReset             : in  std_logic; -- Reset input
    	-- Writing Port
	addr_W            : in  std_logic_vector(ADDR_WIDTH -1 downto 0);   --  Address
	Wen               : in  std_logic;          -- Write Enable
    	Datain            : in  std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0');   -- Input Data
    -- Reading Port
    	addr_R            : in  std_logic_vector(ADDR_WIDTH -1 downto 0);   --  Address
    	Ren               : in  std_logic;          -- Read Enable
    	Dataout           : buffer std_logic_vector(DATA_WIDTH -1 downto 0)   -- Output data
    
    );
end dpmem;
 
architecture dpmem_arch of dpmem is
   
  type DATA_ARRAY is array (integer range <>) of std_logic_vector(DATA_WIDTH -1 downto 0); -- Memory Type
  signal   M       :     DATA_ARRAY(0 to (2**ADDR_WIDTH) -1) := (others => (others => '0'));  -- Memory model
-- you can add more code for your application by increase the PM_Size

begin  -- dpmem_arch
	
	
  --  Read/Write process

  RW_Proc : process (clk, nReset)
  begin  
    if nReset = '0' then
          Dataout <= (others => '0');
          M <= (others => (others => '0')); -- initialize memory
    elsif (clk'event and clk = '1') then   -- rising clock edge
        if Wen = '0' then
			   M(conv_integer(addr_W))      <= Datain; -- ensure that data cant overwrite on program
        else
			   if Ren = '0' then
				    Dataout <= M(conv_integer(addr_R));
			   else
				   Dataout <= Dataout;
			   end if;
		   end if;
      end if;
  end process  RW_Proc;
     
end dpmem_arch;