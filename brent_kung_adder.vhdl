library ieee;
use ieee.std_logic_1164.all;

entity bret_kung_adder is
port( A,B :in std_logic_vector(31 downto 0);
		Cin:in std_logic;
		sum: buffer std_logic_vector(31 downto 0);
		Cout: buffer std_logic;
		Est_sum:in std_logic_vector(31 downto 0);
		Est_Cout:in std_logic);
end entity;

architecture structural of bret_kung_adder is 

signal P1,G1: std_logic_vector(31 downto 0);
signal P2,G2: std_logic_vector(15 downto 0);
signal P3,G3: std_logic_vector(7 downto 0);
signal P4,G4: std_logic_vector(3 downto 0);
signal P5,G5: std_logic_vector(1 downto 0);
signal P6,G6: std_logic;
signal C: std_logic_vector(31 downto 1);

component and_gate is
port(a,b: in std_logic;
	  c: out std_logic);
end component;

component xor_gate is
port(a,b: in std_logic;
	  c: out std_logic);
end component;

component a_plus_bc is
port(a,b,c: in std_logic;
	  d: out std_logic);
end component;

begin

u1:for i in 0 to 31 generate
	v1:xor_gate port map (A(i),B(i),P1(i));
	v2:and_gate port map (A(i),B(i),G1(i));
end generate;

u2:for i in 0 to 15 generate
	v3:and_gate port map (P1(2*i),P1(2*i+1),P2(i));
	v4:a_plus_bc port map (G1(2*i+1),P1(2*i+1),G1(2*i),G2(i));
end generate;

u3:for i in 0 to 7 generate
	v5:and_gate port map (P2(2*i),P2(2*i+1),P3(i));
	v6:a_plus_bc port map (G2(2*i+1),P2(2*i+1),G2(2*i),G3(i));
end generate;

u4:for i in 0 to 3 generate
	v7:and_gate port map (P3(2*i),P3(2*i+1),P4(i));
	v8:a_plus_bc port map (G3(2*i+1),P3(2*i+1),G3(2*i),G4(i));
end generate;
u5:for i in 0 to 1 generate
	v9:and_gate port map (P4(2*i),P4(2*i+1),P5(i));
	v10:a_plus_bc port map (G4(2*i+1),P4(2*i+1),G4(2*i),G5(i));
end generate;

v11:and_gate port map (P5(0),P5(1),P6);
v12:a_plus_bc port map (G5(1),P5(1),G5(0),G6);

w1: a_plus_bc port map (G1(0),P1(0),Cin,C(1));
w2: a_plus_bc port map (G2(0),P2(0),Cin,C(2));
w3: a_plus_bc port map (G3(0),P3(0),Cin,C(4));
w4: a_plus_bc port map (G4(0),P4(0),Cin,C(8));
w5: a_plus_bc port map (G5(0),P5(0),Cin,C(16));
w0: a_plus_bc port map (G6   ,P6   ,Cin,Cout);

w6: a_plus_bc port map (G1(2),P1(2),C(2),C(3));
w7: a_plus_bc port map (G1(4),P1(4),C(4),C(5));
w8: a_plus_bc port map (G1(5),P1(5),C(5),C(6));
w9: a_plus_bc port map (G1(6),P1(6),C(6),C(7));

u6: for i in 8 to 14 generate
	w0: a_plus_bc port map (G1(i),P1(i),C(i),C(i+1));
end generate;

u7: for i in 16 to 30 generate
	w0: a_plus_bc port map (G1(i),P1(i),C(i),C(i+1));
end generate;

u8:for i in 1 to 31 generate 
	t1: xor_gate port map (P1(i),C(i),Sum(i));
end generate;

t0: xor_gate port map (P1(0),Cin,Sum(0));

assert Est_sum = sum report "Sum is wrong" severity failure;
assert Est_Cout = Cout report "Carry is wrong" severity failure;
end architecture;
