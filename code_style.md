# Code style
# 1. RTL代码规范的益处
RTL代码被验证后，可以⽤于其它或者后续项⽬，好的代码规范可以避免误解，不必要的修改，减⼩重⽤代码时可能引⼊的问题。
同⼀项⽬中，好的代码规范可以减少协作时的沟通成本，降低出错的可能性
RTL代码完成后，在后续的维护过程中，好的代码规范可以⼤⼤减⼩后续⼯作量
RTL代码编码⼯程中，好的代码规范可以提⾼代码可读性，减少编码本⾝带来的问题
# 2. 规则违法情况级别说明
•M1 Mandatory 1 禁⽌级别1
规则必须遵守，如有违反，必须修改代码
•M2 Mandatory 2 禁⽌级别2
规则必须遵守，如有违反，必须做出书⾯说明
•R Recommend 建议级别
规则仅供参考
# 3. 命名规范
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>NAME.1</td><td>各种命名中只支持字符数字和下划线</td></tr><tr><td>NAME.2</td><td>名字以字母开头，不能以数字和下划线开头</td></tr><tr><td>NAME.3</td><td>不能仅通过名字中的大小写进行名字区分</td></tr><tr><td>NAME.4</td><td>名字中的多个单词通过下划线区分</td></tr><tr><td>NAME.5</td><td>每个设计中使用统一的命名规则</td></tr><tr><td>NAME.6</td><td>每个文件至多包含一个模块</td></tr><tr><td>NAME.7</td><td>文件名和模块名同名</td></tr><tr><td>NAME.8</td><td>parameter和define使用大写字母</td></tr><tr><td>NAME.9</td><td>instance, signal, block使用小写字母</td></tr><tr><td>NAME.10</td><td>使用有物理意义的命名</td></tr><tr><td>NAME.11</td><td>使用统一的时钟命名</td></tr><tr><td>NAME.12</td><td>使用统一的reset命名</td></tr><tr><td>NAME.13</td><td>FSM状态机命名cur_state,next_state</td></tr><tr><td>NAME.14</td><td>Latch信号以_lat结尾</td></tr><tr><td>NAME.15</td><td>tri信号以_tri结尾</td></tr><tr><td>NAME.16</td><td>asynchronous信号以_async结尾</td></tr><tr><td>NAME.17</td><td>命名字符个数不超过32</td></tr><tr><td>NAME.18</td><td>instance名为u_module</td></tr><tr><td>NAME.19</td><td>总线位宽顺序始终为bus[高位：地位]</td></tr><tr><td>NAME.20</td><td>使用统一的简写表</td></tr><tr><td>NAME.21</td><td>模块端口后缀</td></tr><tr><td>NAME.22</td><td>同一个模块设计文件和子模块名带上统一模块名作为</td></tr></table>
# NAME.1各种命名中只支持字符数字和下划线
# 代码块
reg 1 data_ud_d0; 
reg 2 data_ud_d?$; // ⾮法命名
# NAME.2名字以字母开头，不能以数字和下划线开头
# 代码块
1 wire dat_ud; 
wire 2 _dat_ud; // ⾮法命名
3 wire 8dat_ud; // ⾮法命名}
# NAME.3不能仅通过名字中的大小写进行名字区分
# 代码块
wire 1 ACK; 
⼀个模块⾥出现这样的命名是⾮法的
# NAME.4名字中的多个单词通过下划线区分
# 代码块
wire 1 block1left; 
wire2 block1_left; 
建议使⽤下划线进⾏单词区分
# NAME.5每个设计中使用统一的命名规则
# 代码块
1 reg dat_ud; 
reg 2 data_update; 
每个⼈的代码⻛格应该在⼀个项⽬⾥应该统⼀起来，不能像上⾯这样混⽤
# NAME.6 每个文件至多包含一个模块
# 代码块
file.v1 
2 module a(); 
3 endmodule 
4 
module5 b(); 
endmodule6 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/5c8a114a2d5a5888bf1b32a8e3865af505df304527fa2ea47242d1c095ab1842.jpg)

# 代码块
a.v 1 
module 2 a(); 
endmodule3 
# 代码块
1 b.v 
2 module b(); 
endmodule3 
# NAME.7 文件名和模块名同名
# 代码块
1 b.v 
2 
3 module a(); 
endmodule4 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/3a95ba952b4bbf102ec58cf18aa8e4bc7b9ea94e80836c47d421d5d4fcd42e4e.jpg)

# 代码块
a.v1 
2 
3 module a(); 
endmodule4 
# NAME.8 parameter和define使用大写字母
# 代码块
`define fsdb1 
2 parameter dw = 10; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/e3731524bd185de97652c6092f29b4dae198dfcddfcb763dc2c9492f4d2dc6ad.jpg)

# 代码块
define FSDB1 
2 parameter DW = 10; 
# NAME.9
# instance，signal，block使用小写字母
# 代码块
1 module top(); 

wire3 
SIGNAL; 
a u_A();4 
5 endmodule 
6 
always7 
8 begin:BLOC 
K 
9 end 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/b38ed2c602393a895d95dc7fe5eb90fde51f3f0467af3ad3e251819ee713b507.jpg)

# 代码块
1 module top(); 
2 
wire3 
signal; 
a u_a();4 
endmodule5 
6 
always7 
8 begin:bloc 
k 
9 end 
# NAME.10
# 使用有物理意义的命名
# 代码块
reg 1 
[3:0] i; 
2 wire 
a; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/4c6c4a30769bc60df97d8cdd05be9dcfdeea84c2325cba963d384e4fc9da8470.jpg)

# 代码块
reg 1 [3:0] 
cnt; 
2 wire 
cnt_incr; 
# NAME.11
# 使用统一的时钟命名
# 代码块
1 project prj 
2 
3 module a() 
input clk;4 
endmodule5 
6 
7 module 
8 Input ck; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/28bfa794c71727320be79e5b8c334c7e5ca5e9763e560de80feea9699ad13663.jpg)

# 代码块
project1 
prj 

3 module a() 
input clk;4 
endmodule5 
6 
module7 
b(); 
8 Input clk; 
endmodule9 
10 
module 11 c(); 
12 Input clock; 
endmodule13 
endmodule9 
10 
11 module c(); 
Input clk;12 
13 endmodule 
# NAME.12 使用统一的reset命名
# 代码块
project 1 prj 
2 
3 module a() 
4 input reset; 
5 endmodule 
6 
7 module b(); 
8 Input rstn; 
endmodule9 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/84ef92899271f85fffc39e2528481a3549eff79f1d9af6607df520b1dee06d3d.jpg)

# 代码块
1 project prj 

3 module a() 
4 input rstn; 
endmodule5 
6 
7 module b(); 
8 Input rstn; 
endmodule9 
# NAME.13 FSM 状态机命名cur_state,next_state
# 代码块
reg 1 reg 
[3:0] 
cur_state; 
reg [3:0]2 
next_state; 
# NAME.14 Latch信号以_lat结尾
# 代码块
reg 1 
signal_lat; 
# NAME.15tri信号以_tri结尾
代码块
tri1 
signal_tri; 
# NAME.16 asynchronous信号以_async结尾
代码块
input1 
signal_async; 
# NAME.17 命名字符个数不超过32
代码块
1 Wire 
comucation_cycle_counter_in crease; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/a13cde0ccd7c1533cd7f8b85e0deed08b9516fdee2479538889966dbe33eedad.jpg)

代码块
1 wire com_cycle_cnt_incr; 
# NAME.18 instance 名为u_module
代码块
1 module top(); 
2 a u_xxxx(); 
3 endmodule 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/224b1bb9b70d604cb4b582b67de4c7e5cd84f409ba6ff3d5aedfff1d627eef5d.jpg)

代码块
1 module top(); 
a u_a();2 
3 endmodule 
# NAME.19总线位宽顺序始终为bus[高位：低位]
代码块reg 1 [19:0]
cnt0; 
reg 2 [0:19] 
cnt1; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/0b84af40e40af02df6d46e0f174b2b062558a716a17c4e1161118502dc7ebb65.jpg)

代码块reg1 [19:0]
cnt0; 
reg2 [19:0] 
cnt1; 
# NAME.20使用统一的简写表
统⼀的简写表，可以避免理解的不⼀致性，提⾼代码的可读性，可维护性；
统⼀的简写表也可以提供命名的参考，避免命名时的困惑。
具体简写表请参⻅附录
# NAME.21 模块端口后缀
模块输⼊输出端⼝⽤_i和_o区分
module a(); 
input clk_i; 
output data_o; 
# NAME.22同一个模块设计文件和子模块名带上统一模块名作为前
# 代码块
module NAME1();1 
2 submodule u_NAME2(); 
3 endmodule 
4 
5 module submodule(); 
6 endmodule 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/25ada9dda7a97352fa6430cf816ae9d666bff2718c3403608df19fdf6b880393.jpg)

# 代码块
module NAME1();1 
2 submodule u_NAME1_NAME2(); 
3 endmodule 

5 module submodule(); 
6 endmodule 
# 4. 标准头⽂件
代码块
1 
//- 
// © Copyright CUBLAZER All Right Reserved.2 
//3 
// Abstract4 ：模块功能简述
// File Name5 ：file_name.v 
// Module Name ：Module Name6 
// Revision Histrory:7 
8 // verx.x 作者名 email project_Name Date
9 // 修改说明
//10 
11 ---- 
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>FH.1</td><td>版权说明</td></tr><tr><td>FH.2</td><td>模块功能简述</td></tr><tr><td>FH.3</td><td>文件名</td></tr><tr><td>FH.4</td><td>模块名</td></tr><tr><td>FH.5</td><td>版本号</td></tr><tr><td>FH.6</td><td>作者名</td></tr><tr><td>FH.7</td><td>作者邮箱</td></tr><tr><td>FH.8</td><td>项目名</td></tr><tr><td>FH.9</td><td>修改时间</td></tr><tr><td>FH.10</td><td>修改记录</td></tr></table>
# 5. 注释
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>COM.1</td><td>输入输出接口说明</td></tr><tr><td>COM.2</td><td>内部信号说明</td></tr><tr><td>COM.3</td><td>块功能说明</td></tr><tr><td>COM.4</td><td>说明简洁，占一行即可</td></tr><tr><td>COM.5</td><td>模块调用说明</td></tr><tr><td>COM.6</td><td>综合指令放入注释</td></tr><tr><td>COM.7</td><td>预编译指令说明</td></tr><tr><td>COM.8</td><td>引起版本更新的修改部分要有对应于版本号的指引说明</td></tr></table>
# Note：
•修改代码时相应注释也要做修改
•注释要能帮助理解代码的设计思想
•接⼝注释位于⾏尾
•版本相关修改代码注释中要包含版本号
# COM.1 输入输出接口说明
# 代码块
1 input clk; \\ Global Clock; Frequency Range 2 input rstn; \\ Global Asynchronous Reset, Negative Level is valid 
# COM.2 内部信号说明
# 代码块
wire dat_ud; \\ xxx Data Update signal, 1 active1 
# COM.3
# 块功能说明
# 代码块
```txt
1 // xxx Operation time length selection in Different Mode,0 for x seconds, m  
for m*x seconds  
2 always @(*)  
3 begin  
4 case(mode)  
5 0: cycle_len = 0;  
6 1: cycle_len = m;  
7 default :  
8 cycle_len = 0;  
9 end 
```
# COM.4
# 说明简洁
# 代码块
```txt
1 input clk; \Global Clock; Frequency Range 2 input rstn; \Global Asynchronous Reset, Negative Level is valid 
```
# COM.5
# 模块调用说明
# 代码块
```txt
1 // 12 bit div for unsigned data, operation need 4 clock cycles  
2 div u_div(...); 
```
# COM.6
# 综合指令放入注释
# 代码块
```txt
1 code; // synopsys directive 
```
# COM.7 预编译指令说明
# 代码块
```txt
1 `ifdef MIX_SIM \Mix Simulation  
2 `elseif \Normal RTL Simulaiton  
3 `endif 
```
# COM.8引起版本更新的修改部分要有对应于版本号的指引说
# 代码块
```javascript
1 //Verx   
2 //12bitdivfor unsigned data，operation need4clockcycles   
3 //divu_div(...);   
4 //Very   
5 mulu.mul(...); 
```
# 6. Coding Style
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>CS.1</td><td>代码中有对应关系的代码应该对齐</td></tr><tr><td>CS.2</td><td>代码中的缩进使用空格，不能使用tab键</td></tr><tr><td>CS.3</td><td>每行代码最多包含一个信号的赋值</td></tr><tr><td>CS.4</td><td>每行代码最多包含一个输入输出信号的定义</td></tr><tr><td>CS.5</td><td>端口调用说明和端口在模块内部的说明保持一致</td></tr><tr><td>CS.6</td><td>所有的内部信号说明统一放在一起</td></tr><tr><td>CS.7</td><td>每行字母个数控制在200以内</td></tr><tr><td>CS.8</td><td>保持常量间的关系</td></tr><tr><td>CS.9</td><td>模块实例化时，不能使用位置进行关联</td></tr><tr><td>CS.10</td><td>端口连接时不能使用表达式</td></tr><tr><td>CS.10</td><td>输出信号不能使用表达式</td></tr><tr><td>CS.11</td><td>状态编码使用parameter进行定义</td></tr><tr><td>CS.12</td><td>复杂的逻辑关系中使用括号进行优先级管理</td></tr><tr><td>CS.13</td><td>wire必须被显示定义</td></tr><tr><td>CS.14</td><td>表达式中相关操作数位宽要保持一致</td></tr><tr><td>CS.15</td><td>赋值和条件判断时注明数据位宽</td></tr><tr><td>CS.16</td><td>条件语句中的条件中不直接使用多bit数据作为条件</td></tr><tr><td>CS.17</td><td>状态机使用三段式风格</td></tr><tr><td>CS.18</td><td>always块中只进行一个变量的赋值</td></tr><tr><td>CS.19</td><td>不能在多个always块中对同一给变量进行多次赋值</td></tr><tr><td>CS.20</td><td>参数化模块设计</td></tr><tr><td>CS.21</td><td>parameter, define使用大写</td></tr><tr><td>CS.22</td><td>代码编写使用小写字母,下划线分隔字母</td></tr><tr><td>CS.23</td><td>数值部分使用十进制,控制使用二进制,编码根据需要</td></tr><tr><td>CS.24</td><td>数值0不做位宽限定</td></tr><tr><td>CS.25</td><td>复用重复的组合逻辑</td></tr><tr><td>CS.26</td><td>逻辑操作和按位逻辑操作不混用</td></tr><tr><td>CS.27</td><td>大量信号4个一组进行分隔</td></tr><tr><td>CS.28</td><td>赋值语句两边位宽保持一致,进行部分操作时需明确位</td></tr><tr><td>CS.29</td><td>总线定义使用little ending方式进行定义</td></tr><tr><td>CS.30</td><td>define 每行一个声明</td></tr><tr><td>CS.31</td><td>使用parameter进行参数传递,不使用define进行传递</td></tr></table>

# CS.1代码中有对应关系的代码应该对齐
代码块
1 module();   
2   
3 Input din;   
4 Output dout;   
5 always @(\*)   
6 begin   
7 if()   
8 begin   
9 if()   
10 else   
11 end   
12 else   
13 begin   
14 end   
15 End   
16 always $@(\star)$ 17 Begin   
18 case()   
19 0 :   
20 begin   
21 end   
22 1:   
23 default :   
24 endcase   
25 end   
26 endmodule 
# CS.2 代码中的缩进使用空格，不能使用tab键
代 码 块
in p u t  \ t 1 c l k ; 
2 i n p u t  \ t r s t n ; 
3 i n p u t c l k ; 
4 i n p u t r s t n ; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/2ed09760139149aa6398578b80f02c690b808d06963a55df9a20f1360abdb71f.jpg)

代码块
in p u t  \ s \ s \ s \ s1 c l k ; 
2 i n p u t  \ s \ s \ s \ s r s t n ; 
i n p u t3 c l k ; 
i n p u t 4 r s t n ; 
# CS.3每行代码最多包含一个信号的赋值
# 代码块
1 $\mathtt { a } ~ = ~ \mathtt { b }$ ; c 
$\mathbf { \Sigma } = \mathbf { \Sigma } { \mathsf { d } }$ 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/c06a36f63184857f5f88aecdc169495fd0ab2dcd3ad318f26461e913b1a9b35f.jpg)

# 代码块
1 ${ \sf a } = { \sf b } ;$ 
2 $\texttt { c } = \texttt { d }$ 
# CS.4 每行代码最多包含一个输入输出信号的定义
# 代码块
1 input a,b,c,d; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/9aa8eaeaa60b35c5e714d17bc39a9e04336a48c756f637e7b2162fb109a079c3.jpg)

# 代码块
input 1 a; 
input 2 b; 
3 input c; 
4 input d; 
# CS.5 端口调用说明和端口在模块内部的说明保持一致
# 代码块
reg 1 [19:0] cnt0; 
reg 2 [0:19] cnt1; 
module a(3 
signal1;4 
signal2,5 
signal36 
);7 
8 
9 endmodule 
10 
module top();11 
a u_a(12 
13 .signal3 (signal3 ), 
14 .signal1 (signal1 ), 
15 .signal2 (signal2 ) 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/acb0cd66fe4bdc210f3557af7a4710867dce8bd62b74405eed8966f8d89578ca.jpg)

# 代码块
reg1 [19:0] cnt0; 
reg 2 [19:0] cnt1; 
module a(3 
signal1;4 
signal2,5 
signal36 
);7 
8 
endmodule9 

module top();11 
a u_a(12 
13 .signal1 (signal1 ), 
14 .signal2 (signal2 ), 
15 .signal3 (signal3 ) 
);16 
endmodule17 
);16 
endmodule17 
# CS.6 所有的内部信号说明统一放在一起
# 代码块
wire 1 a; 
wire b;2 
wire 3 
signal1; 
4 
assign 5 
signal1 = 
a&&b; 

always @()7 
begin 
9 end 
10 
wire11 
signal2; 
12 assign 
signal2 $=$ a 
|| b; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/66527753cadb9646f6348db9d61fd249450aa817a4911be353eb3dcf24c61805.jpg)

# 代码块
wire 1 a; 
wire b;2 
3 wire signal1; 
4 wire signal2; 
5 
6 assign signal1 $=$ a&&b; 
7 
always @()8 
9 begin 
10 end 
11 
assign signal2 =12 a || b; 
# CS.7每行字母个数控制在200以内
# CS.8 保持常量间的关系
# 代码块
1 parameter BYTEW = 8; 
2 parameter WORDW = 16; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/a71080f3ec4b0ac0103452013f74de2de2e743926202ab1c1c0d25ebc2e1a132.jpg)

# 代码块
1 parameter BYTEW = 8; 
2 parameter WORDW = 2*BYTEW; 
# CS.9
# 模块实例化时，不能使用位置进行关联
# 代码块
module a( 1 
signal1;2 
signal2,3 
signal34 
);5 
6 
endmodule7 
8 module 
top(); 
a u_a(9 
10 
. 
(signalx 
11 
. 
(signaly 
), 
12 
. 
(signalz 
) 
);13 
endmodule14 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/29430d9a5c6903ee3a610d5ddc4e7589de8b615c1341e603273a3c669860a6f4.jpg)

# 代码块
module a(1 
signal1;2 
signal2,3 
signal34 
);5 
6 
endmodule7 
8 module top(); 
a u_a(9 
10 
.signal1 
(signalx ), 
11 
.signal2 
(signaly ), 
12 
.signal3 
(signalz ) 
);13 
endmodule14 
# cs.10
# 端口连接时不能使用表达式
# 代码块
module top();1 
a u_a(2 
3 .signal1 
(x&&y ), 
4 .signal2 
(signaly ), 
5 .signal3 
(signalz ) 
);6 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/84b86f0ec12124ca1a64dacc767640c1df0c210d9ee8ab3b9b0dd987a8fbc0c6.jpg)

# 代码块
module top();1 
wire z;2 
assign 3 $z ~ = ~ \times ~ \& \&$ y; 
a u_a(5 
6 .signal1 
(z ), 
7 .signal2 
(signaly ), 
7 endmodule 
```txt
8 李氏8698 .signal3 (signalz ）   
9 ）；   
10 endmodule
```
# CS.11 状态编码使用parameter进行定义
# 代码块
module 1 top(); 
2 
3 always @(*) 
begin 
5 
case(cur_s tate) 
6 
7 
8 
9 
10 
default :11 
12 end 
13 endmodule 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/4c9784648ed7bec4017915286cd1de149e95e4f76a8322c8482462cb1cbdad88.jpg)

# 代码块
1 module top();   
2   
3 parameter IDLE $=$ 4'd0;   
4 parameter PRECHG = 4'd1;   
5 parameter RFRSH = 4'd2;   
6 parameter RADDR = 4'd3;   
7 parameter CADDR = 4'd4;   
8   
9 always @(\*)   
10 begin   
11 case(cur_state)   
12     :   
13     : PRECHG :   
14     : RFRSH :   
15     : RADDR :   
16     : CADDR :   
17     : default :   
18 end   
19 endmodule 
# CS.12复杂的逻辑关系中使用括号进行优先级管理
# 代码块
assign a1 $=$ b&& c !=d || e; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/a374f955d78cefa0504f4f7a1890b9fda6b2838c600461ce8e7cd74b659bf475.jpg)

# 代码块
1 assign a $=$ (b&& (c !=d)) || e; 
# cS.13 wire必须被显示定义
# 代码块
module top();1 
2 
a u_a(3 
4 .signal1 
(z ), 
5 .signal2 
(signaly ), 
6 .signal3 
(signalz ) 
);7 
b u_b(8 
9 .signal1 
(z ), 
10 .signal2 
(signaly ), 
11 .signal3 
(signalz ) 
);12 
endmodule13 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/07367a7cc1acb96b26d7bcdc3640078abfbffdc28d33e25564e7872b1f6bb7e6.jpg)

# 代码块
reg 1 [19:0] cnt0; 
reg 2 [19:0] cnt1; 
3 
module top();4 
wire z;5 
6 wire signaly; 
7 wire signalz; 
8 
a u_a(9 
10 .signal1 (z 
11 .signal2 
(signaly ), 
12 .signal3 
(signalz ) 
);13 
b u_b(14 
15 .signal1 (z 
16 .signal2 
(signaly ), 
17 .signal3 
(signalz ) 
);18 
19 endmodule 
# CS.14 表达式中相关操作数位宽要保持一致
# 代码块
1 Wire [3:0] 
data_x; 
Wire 2 [6:0] 
data_y; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/21f38621cc69268f8c4875e76ccf656f85294da898f27cccedeae404af654ff0.jpg)

# 代码块
1 reg [19:0] cnt0; 
reg 2 [19:0] cnt1; 
3 Wire [3:0] data_x; 
Wire4 [6:0] data_y; 
5 Wire [6:0] data_z; 
```txt
3 Wire [6:0] data_z;  
4 assign data_z = data_x & data_y; 
```
```txt
6 assign data_z = {3'b111,data_x} & data_y; 
```
# CS.15赋值和条件判断时数据需要注明位宽
# 代码块
```txt
1 wire [3:0] cnt;   
2 if(cnt == 5) 
```
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/bbbf9ecaead2f174b405c70485cf0c8a43c7bfafbc7654f4cc9d01d16f00533e.jpg)

# 代码块
```txt
1 wire [3:0] cnt;   
2 if(cnt == 4'd5) 
```
# CS.16 条件语句中的条件中不直接使用多bit数据作为逻辑判
# 代码块
```txt
1 wire [3:0] cnt;   
2 if(cnt) 
```
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/12872dbbe075a715476963d6d549420bae3756a7ee060b0c184b41c3da305411.jpg)

# 代码块
```txt
1 wire [3:0] cnt;   
2 if(cnt>0) 
```
# CS.17 状态机使用三段式风格
# 代码块
```txt
1 //保存状态  
2 always @(posedge clk or negedge rstn)  
3 if()  
4 else  
5 cur_state <=# next_state;  
6 //切换状态  
7 always @(\*)  
8 begin  
9 case(cur_state)  
10 xxxx: next_state = ???;  
11 endcase
```
```txt
12 end  
13  
14 // Moore FSM  
15 always @(\*)  
16 begin  
17 case(cur_state)  
18 xxxx : out = m;  
19 end  
20  
21 // 使用状态  
22 // Mealy FSM  
23 always @(\*)  
24 Begin  
25 if((cur_state == xxx) && x)  
26 out1 = m;  
27 else  
28 out1 = n;  
29 end
```
# CS.18 always块中只进行一个变量的赋值
# 代码块
always @()1 
if()2 
3 begin 
4 a = 
x1; 
5 b = 
6 else 
if()7 
begin 
9 a = 
x1; 
10 b = 

11 end 
12 else 
begin13 
14 a = x; 
15 b = 
16 end 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/234933ae8c02190147ec84fc0525d93b423d79d13deff060b458b5505bc7a0c2.jpg)

# 代码块
always @()1 
if()2 
3 $\texttt { a } = \texttt { x l }$ ; 
4 else 
5 a = x; 
always @()6 
if()7 
8 b = x2; 
9 else 
if()10 
11 b = 
x3; 
else12 
13 b = 
x4; 
# CS.19 不在多个always块中对同一给变量进行多次赋值
# 代码块
always(*)1 
begin 2 
3 $\texttt { a } = \texttt { 1 } ;$ 
4 end 
always(*)5 
6 begin 
7 a = 2; 
8 end 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/dfbc343d956ea6a0c7082cc5b0e5323cb78d8efa0fc1c07bab514f62f9bd0a81.jpg)

# 代码块
always(*)1 
begin2 
3 if() 
4 
$$
a = 1;
$$
5 else 
6 
$$
a = 2
$$
7 end 
# CS.20 参数化模块设计
# 代码块
1 input [31:0] din; 2 output 
[15:0] dout; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/9a526eb96fd029680b8daa97abb564f880f6ec3d543967478c1026429b99ffb4.jpg)

# 代码块
1 parameter DIW 32 - 1; 
parameter DOW2 16 - 1; 
3 input [DIW:0] din; 
4 output [DOW:0] dout; 
# CS.21 parameter， define使用大写
# 代码块
input 1 [31:0] din; 
2 output [15:0] dout; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/a1186c38317e4f676a883e0bdc7cec96ae75822637b9cb666f864bba6e902f78.jpg)

# 代码块
1 `define SID = 4; 
parameter DIW = 32 -1; 
3 parameter DOW $= \ 1 6 \ - \ 1$ ; 
4 input [DIW:0] din; 
```txt
5 output [DOW:0] dout; 
```
# CS.22 代码编写使用小写字母，下划线分隔字母
# 代码块
1 input DinValid; 
2 input [31:0] Din; 
3 output doutValid; 
4 output [15:0] dout; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/59346178ae820d2a2a11c8c91df04a4132245491fde36ca1524c5a00743c7f9b.jpg)

# 代码块
1 input din_valid; 
2 input [31:0] din; 
3 output dout_valid; 
4 output [15:0] dout; 
# CS.23 数值部分使用十进制，控制使用二进制，编码根据需要
# 代码块
1 if(mode == 4’d13) 
2 pat = 8’b0000_1111; 
3 else 
4 if(mode == 4’hC) 
5 pat = 8’d165; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/5f8808bf0c72822337f4f7caa76bf93f5e6ae495fdee3a786f8c723addab01e4.jpg)

# 代码块
1 if(mode == 4’b1101) 
2 pat = 8’d15; 
else3 
4 if(mode == 4’d1100) 
5 pat = 8’ha5; 
# CS.24 数值0不做位宽限定
# 代码块
always @()1 
if()2 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/0eb04ee65eb63f2762e5d5c5f1aa52d89b84ea503c5f248e14e88b6eec55099a.jpg)

# 代码块
1 always @() 
3 din $<   =$ 17'b0_0000_0000_0000_00 00; 
2 if() 3 dir $<   =$ 0; 
# CS.25 复用重复的组合逻辑
# 代码块
a = cnt1 $= =$ 4’d15 && mode 2’b10 ; 
b2 $=$ cnt $= =$ 4’d15 && mode $= =$ 2’b10 && enable; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/9261b8d018e9cf43f17183faead96b9cac64ba60fd2f24b24860a8c1136e7bc4.jpg)

# 代码块
a = cnt == 4’d15 &&1 
mode $= = 2 ^ { \prime } \mathsf { b } 1 \Theta$ ; 
b2 $=$ cnt $= =$ a && enable; 
# CS.26 逻辑操作和按位逻辑操作不混用
# 代码块
wire 1 [3:0] mask; 
reg 2 enable; 
3 assign x = mask && 4’b0001 & enable; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/702cd248edfe589d432bc7840f5b51606cc4aa48e34b489fccc663d287fe3c70.jpg)

# 代码块
wire 1 [3:0] mask; 
reg 2 enable; 
3 assign x = mask & 4’b0001 && enable; 
# CS.27 大量信号4个一组进行分隔
# 代码块
1 a =( b == 16’b1010101100001101) ; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/6a0f5d85e84c6ec44809858aa45c381d8b222a65c5d2f32d8a6a7691d2c7d7e0.jpg)

# 代码块
1 a =( b == 16’b1010_1011_0000_1101); 
# CS.28 赋值语句两边位宽保持一致，进行部分操作时需明确
# 代码块
# 代码块
```txt
1 wire [31:0] a;   
2 wire [31:0] b; 
```
```txt
3 wire [63:0] c; 
```
```txt
4 wire [255:0] d; 
```
```txt
5 
```
```txt
6 assign d = {a,b,c}; 
```
7 assign $a = c$ 
8 assign $d = c$ 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/94715ba00ce4340905e6e970223a70771348d4d8d524e596ae7d4349bb3d52ba.jpg)

```txt
1 wire [31:0] a;  
2 wire [31:0] b;  
3 wire [63:0] c;  
4 wire [255:0] d; 
```
```txt
5 
```
```javascript
6 assign d[63:0] = c; 
```
```javascript
7 assign d[95:64] = b; 
```
```javascript
8 assign d[127:96] = a; 
```
```txt
9 assign a 
```
$= \mathrm{c}[31:0]$ 
```javascript
10 assign d[63:0] = c; 
```
# CS.29总线定义使用littleending方式进行定义
# 代码块
```txt
1 wire [0:31] a; 
```
```txt
2 wire [0:31] b; 
```
```txt
3 wire [0:63] c; 
```
```javascript
4 wire [0:255] d; 
```
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/6a7b5850c1da15eb4fd58378b9359ed867f519507abf16b64eb44319154031f7.jpg)

# 代码块
```txt
1 wire [31:0] a; 
```
```txt
2 wire [31:0] b; 
```
```txt
3 wire [63:0] c; 
```
```txt
4 wire [255:0] d; 
```
# CS.30 define 每行一个声明
# 代码块
```txt
1 define RSIM, BASEDIE_ONLY 
```
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/b8066745eb93c1c5321c2cf453fc7fd8b94a932dacc8d0d01dc4fdadfe2b66d3.jpg)

# 代码块
```txt
1 define RSIM 
```
```txt
2 define BASEDIE_ONLY 
```
# CS.31 使用parameter进行参数传递，不使用define传递参
代码块define DW 101
input2 
[`DW:0] din; 
代码块parameter1
$\mathsf { D } \mathsf { W } \ = \ \mathsf { 1 } \odot$ 
input2 
[DW:0] 
din 
# 7. 综合代码规范
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>SYN.1</td><td>使用可综合的代码进行编码</td></tr><tr><td>SYN.2</td><td>不在RTL代码中使用综合脚本命令</td></tr><tr><td>SYN.3</td><td>不在case语句中使用综合指示符</td></tr><tr><td>SYN.4</td><td>组合逻辑条件要完备</td></tr><tr><td>SYN.5</td><td>禁用Verilog原语</td></tr><tr><td>SYN.6</td><td>所有输入都必须被驱动，即使内部未使用</td></tr><tr><td>SYN.7</td><td>避免在顶层加入glue logic</td></tr><tr><td>SYN.8</td><td>组合逻辑的case语句中default状态必须完备</td></tr><tr><td>SYN.9</td><td>FSM中的状态必须具有default状态</td></tr></table>
# SYN.1 使用可综合的代码进行编码
# 代码块
不可综合代码：
Time， 
3 $function ， 
4 fork join， 
5 initial， 
6 Wait， 
# 代码块
parameter $\mathsf { D } \mathsf { W } \ = \ \mathsf { 1 } \odot$ 
input 2 
[DW:0] 
din 
3 综合⼯具依赖的代码：
4 casex， casez， 
#delay，7 
8 UDP 
wand,wor,5 
6 triand,tri or, 
real,array ,memory, 
8 while,repe at,forever ， 
disable9 
task10 
# SYN.2 不在RTL代码中使用综合脚本命令
# 代码块
module top();1 
reg 2 [3:0] cnt; // set_dont_touch 
endmodule3 
# SYN.3 不在case语句中使用综合指示符
# 代码块
module top();1 
case() // synopsys parallel_case2 
endcase3 
4 case() // synopsys full_case 
endcase5 
6 endmodule 
# SYN.4 组合逻辑条件要完备
# 代码块
always 1 $\Theta ( \star )$ 
if2 $\mathit { \Pi } ( \ a \ = \ 1 )$ 
3 $\flat \ = \ 4$ ; 
always (*)4 
case()5 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/5d5cd33abdad45e15a0f859afb7c32278dc3e551964ed159f63d300519a134cf.jpg)

# 代码块
always 1 $\Theta ( \star )$ 
if2 $\mathsf { a } \ \mathsf { \Omega } = \mathsf { \Omega } _ { 1 } \mathsf { \Omega } _ { }$ 
3 $\textup { b } = \ 4 ;$ 
4 else 
5 $b = ?$ 
```txt
6 0:李8698 1   
7 c=5;   
8 default:   
9 endcase
```
6 李兵8698  
7 always $(\star)$ 8 case()  
9 0 : 1  
: c = 5;  
10 2:  
c = ?;  
11 default: c = x;  
12 endcase
# SYN.5 禁用Verilog原语

代码块

```html
1 <code class="language-plaintext hljs"  
2 primitive name  
3 endprimitive  
4 <\code> 
```
# SYN.6所有输入都必须被驱动，即使内部未使用

代码块

```txt
1 module a();   
2   
3 input x;   
4 Input y;   
5 output z   
6   
7 assign z = x;   
8 endmodule   
9   
10 module top();   
11 a u_a( .x (m),   
13 .z (n)   
14 ）； 
```
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/47e7b6abf1c1058aa2866945fbd3562be6c37c601720903170667631fe1cc091.jpg)


代码块

```txt
1 module a();   
2   
3 Input x;   
4 input y;   
5 output z;   
6   
7 assign z = x;   
8 endmodule   
9   
10 module top();   
11 a u_a( .x (m),   
13 .y (0) , 
```
15 endmodule 
```txt
14 .z (n) 
```
);15 
endmodule16 
# SYN.7. 避免在顶层加入glue logic
# 代码块
1 module top(); 
assign z2 $\boldsymbol { \mathsf { \Sigma } } = \boldsymbol { \mathsf { X } } \mathsf { \Sigma } + \boldsymbol { \mathsf { \Sigma } } \boldsymbol { \mathsf { y } }$ ; 
a u_a();3 
endmodule4 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/62a6822389805382ef188eb4ee719314a88687dec4eed2d69a7f00adf0dad100.jpg)

# 代码块
module1 add(); 
endmodule2 
3 
4 module top(); 
5 add u_add(); 
a u_a();6 
endmodule7 
# SYN.8 组合逻辑的case语句中default状态必须完备
# 代码块
always @(*)1 
2 $\mathfrak { i } \ f ( \textsf { a } \ = \ 1 )$ 
3 $\flat \ = \ 4$ 
4 
always (*)5 
case()6 
7 0 : 
```txt
c = 1; 
```
8 1 : 
$c = 5$ 
9 2 : 
$c = 6$ 
10 endcase 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/673343ce04ebd2c57452cd60e722e6e530fe477bfafe59d2da34f3612bf8d97e.jpg)

# 代码块
always @(*)1 
if2 $\ l ( \mathsf { a }  &  = \mathsf { \Omega } _ { 1 } \ r )$ 
3 $\textup { b } = \ 4 ;$ 
4 else 
5 $\begin{array} { l } { \displaystyle { \ b \ = \ \Theta } } \end{array}$ 
6 
always (*)7 
8 case() 
9 0 c 1; 
10 1 : c = 5; 
11 2 : c 6; 
12 default : c 2; 
13 endcase 
# SYN.9 FSM中的状态必须具有default状态
# 代码块
always @(*)1 
Case(cur_state)2 
3 STATE1 : 
next_state $=$ STATE2; 
4 STATE2 : 
next_state $=$ STATE3; 
5 STATE3 : 
next_state $=$ STATEX; 
endcase6 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/c1faf08fd573db08386c7b97a7d11c9a7e596e089f8cb11af573b773ad0d37d3.jpg)

# 代码块
always @(*)1 
Case(cur_state)2 
3 STATE1 : 
next_state $=$ STATE2; 
4 STATE2 : 
next_state $=$ STATE3; 
5 STATE3 : 
next_state $=$ STATEX; 
6 default : 
next_state $=$ STATEZ; 
endcase7 
# 8. STA Rules
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>STA.1</td><td>避免组合逻辑的递归调用</td></tr><tr><td>STA.2</td><td>跨时钟域需要独立的同步模块</td></tr><tr><td>STA.3</td><td>每个模块使用唯一的时钟源</td></tr><tr><td>STA.4</td><td>避免multicycle 和false path</td></tr><tr><td>STA.5</td><td>时钟不作为普通的信号进行使用</td></tr><tr><td>STA.6</td><td>避免出现latch</td></tr></table>
# STA.1 避免组合逻辑的递归调用
# 代码块
assign a1 $=$ b && c; 
assign c2 $=$ d && e; 
assign e = |a；3 
4 always @(posedge clk or negedge rstn) 
If()5 
else 6 
7 f <= a; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/49fdd3208b56cea069543cdc374b556fc187ff5284812b4196b37809817a4348.jpg)

# STA.2 跨时钟域需要独立的同步模块
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/e650157f8c54f8a48c61626f6dab75d4e903bcd134b1f6be6885fae2551a49aa.jpg)

# STA.3 每个模块使用唯一的时钟源
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/0f5e2783b3d8991d6bd9581e3aefac6fbe5c060b0ab396cd9eef571da6c2aaf9.jpg)

不同时钟交互，需要的同步⽅式是不⼀样的；
使⽤多个时钟的模块，正常的⼯作依赖于时钟之间的关系，⽽这种关系在代码表现上是不清楚的，跨项⽬很难使⽤
将时钟同步独⽴出来，在不同的时钟关系下只要选择相应的时钟同步模块即可
clk1 
clk1同频不同相
频率大于clk1
频率小于clk1
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/cca8ddef4c7580f4b2ec41f635bf2d2d5945c4deaa84f89cb40d9616405e4c97.jpg)

# STA.4 避免multicycle 和false path
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/a26d7f94afc16d471e5dc2b46c1f08f9cb65cdd9f306e2603c28e86690b5f800.jpg)


multicycle 可⽤情况

false path 是指不需要进⾏timing分析的路径，常出现于：
时钟Gating信号
常电平信号(metal option)
相对不变的信号(例如模块设置，使能等)
false path可⽤情况
# STA.5 时钟不作为普通的信号进行使用
# 代码块
1 clk1 1Khz   
2 clk2 1Mhz   
3 wire signal;   
4 assign signal $=$ xxx && CLK1;   
5   
6 always @(posedge clk2 or negedge rstn)   
7 if(~rstn)   
8 else   
9 if(signal) 
# STA.6 避免出现latch
# 代码块
```txt
1 reg signal;  
2 always @(\*)  
3 if()  
4 signal = 1; 
```
⽆驱动时钟不易进⾏timing分析，不易复位，Latch这种特性，需要慎⽤；对于组合逻辑错误⽣成的Latch需要去除。
# 9. 仿真代码规范
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>SIM.1</td><td>时序电路always块中使用&lt;=进行赋值</td></tr><tr><td>SIM.2</td><td>组合逻辑always块中使用 = 进行赋值</td></tr><tr><td>SIM.3</td><td>组合逻辑always敏感列表使用 *</td></tr><tr><td>SIM.4</td><td>时序电路需要显式初始化</td></tr><tr><td>SIM.5</td><td>不使用 x 进行赋值</td></tr><tr><td>SIM.6</td><td>禁止在RTL 代码中使用#delay</td></tr></table>
# SIM.1 时序电路always块中使用 $< =$ 进行赋值
# 代码块
always @（posedge clk or negedge1 rstn) 
if(~rstn)2 
else3 
begin4 
5 a $\angle = \mathrm { ~ \underline { ~ } { ~ 1 ~ } ~ }$ ; 
6 b $\scriptstyle < = \ a$ 
7 $c \ < = \ \mathsf { b }$ 
8 end 
a 
b 
C 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/0faf3962a4de4eae2b04cc0a250c462044a22575b25e9c8b9d0dcb6275b35622.jpg)

# SIM.2 组合逻辑电路语句中使用 $=$ 进行赋值
代码块
always @（*)1 
if()2 
3 begin 
4 a = 1; 
5 b = a; 
6 c = b; 
end7 
a 
b 
C 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/93416760842dd825ed59fbbae78a7389f5369f877e0b9f0ec6c385727b0aa707.jpg)

# SIM.3 组合逻辑always敏感列表使用*
# 代码块
always @（b or e)1 
if(c || e)2 
3 begin 
4 a = b; 
5 end 
a 
b 
C 
e 
unexpected 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/9b2f42a69ef46e76201f28b4b9b3b9dca71b2f0a82d2f535c57e4673755619af.jpg)

# SIM.4 时序电路需要显式初始化
# 代码块
always @（posedge clk)1 
if(b)2 
b3 egin 
4 a <= 1; 
5 end 
# 代码块
1 always @（posedge clk or negedge rstn) 
if(~rstn) // 不可或缺2
3 else 
If(b)4 
begin5 
6 a <= 1; 
7 end 
a 
b 
rstn 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/cc0a12a76a63b37da441957d99801fadb1ea29b10fc9cf3d5869d7afedb188fa.jpg)

# SIM.5 不使用 $\pmb { \times }$ 进行赋值
# 代码块
assign1 $\sf { a } \ = \ \sf { x }$ 
assign2 $\texttt { b } = \texttt { a } ? \texttt { 1 } : \texttt { \Theta }$ 
3 由于a的赋值有可能是1，也有可能是0，所以导致b的赋值也是不能确定的
# SIM.6 禁止在RTL代码中使用#delay
# 代码块
#delay 不能综合1
2 在RTL代码中使⽤#delay，会导致问题在后仿时才能发现
# 10. DFT Rules
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>DFT.1</td><td>避免三态驱动cell</td></tr><tr><td>DFT.2</td><td>避免双向驱动inout</td></tr><tr><td>DFT.3</td><td>避免latch</td></tr><tr><td>DFT.4</td><td>避免使用时钟双沿</td></tr><tr><td>DFT.5</td><td>避免使用时钟gating</td></tr><tr><td>DFT.6</td><td>避免使用寄存器输出作为时钟</td></tr><tr><td>DFT.7</td><td>避免使用内部的异步复位/置位信号</td></tr><tr><td>DFT.8</td><td>避免时钟和复位/置位信号作为DFF输入端</td></tr><tr><td>DFT.9</td><td>避免组合逻辑的design loop</td></tr><tr><td>DFT.10</td><td>避免DFF输入常数和DFF输出floating</td></tr></table>
# DFT.1 避免三态驱动cell的使用
三态驱动cell可以多个cell驱动⼀条wire，前提是多个cell不能同时驱动，必须分时驱动；只有当⼀个cell 输出z时, 另⼀个cell就可以驱动wire。
当多个cell同时驱动⼀条wire时，有可能发⽣驱动到0和驱动到1的请求同时发⽣，会发⽣short。
如果必须使⽤三态驱动cell，DFT测试时，需要将⽤三态⻔驱动的cell的驱动数量通过逻辑信号的引⼊，降低为⼀个，才好进⾏DFT测试。
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/401659a70c0b479f7f0ef66b0faf38db3544a10a3acdaea12478e32f7892b3ee.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/c71aff3d38a8fb969c97e82bcd86d51d99be3d25b2e04e307f42b4bdb214f525.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/32545956679433960da5607ac000cd8d3420cb1e97131a735c55a792b0a53752.jpg)

# DFT.2 避免双向驱动inout的使用
Inout会导致⼯具在驱动时⽆法确定驱动⽅向，导致激励不能准确送⾄相应的DFF
# DFT.3 避免Latch
DFT测试是将内部DFF更换为专⻔的DFF，latch不能被替换。
# DFT.4 避免使用时钟双沿
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/8613aa370eb185184845edca334b054b1f216f4ff212865ae601684ddfc866a8.jpg)

# DFT.5 避免时钟gating
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/f91c4725597199b94762a02bdd6fe5fe3db133dfa262f3e2a417bf29fea7f507.jpg)

# DFT.6 避免使用寄存器输出作为时钟
如果使⽤这种操作，需要给⽣成时钟使⽤另⼀条scanchiain；
这样才能避免对原有时钟树的影响。
# DFT.7 避免使用内部的异步复位/置位信号作为DFF输入
DFT需要所有的DFF都可以控制，如果使⽤内部异步的复位或者置位信号， 将会导致DFF的状态不可控，相应的 检测也会因此失效。
# DFT.8避免时钟和复位/置位信号作为DFF输入端
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/d912c2d31593b5ee8213cbfc7023661d8ee208e18f310f50d25a48072c6889c1.jpg)

clk1作为DFF输⼊端，时钟频繁变化，将会导致D端不能进⾏control，如果使⽤TM进⾏切换，也会导致⽆法确定信号来源
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/490680af0d49702ce067bb24cde8b176a89f387159b7d69a8d6fce277ada17be.jpg)

reset/set作为DFF输⼊端，在控制其的值进⾏改变时将会导致部分DFF复位或者置位，从⽽使这些DFF丧失可空性，如果使⽤TM进⾏切换，也会导致⽆法确定信号来源
# DFT.9 避免组合逻辑的design loop
Scan Chain在控制DFF输⼊端时，design loop会导致数据失去控制; 也不能使⽤TM进⾏数据控制
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/62d93e78c5fa2e6c8dd9272ed284c75f9b8062a6285fe3494e46d9f55b0eecf2.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/13ec825c81c2d92dad9652cdd90500d4c459d72d95e91879e6162b78bebf3a09.jpg)

# DFT.10 避免DFF输入常数和DFF输出floating
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/d2a734d31bd26a870a00900df4c26998e561f3fb5b9d7bbfd18c2ac749c54fe7.jpg)

ScanChain在控制DFF输⼊端时，constant会导致数据⽆法控制，使⽤TM进⾏控制也不能组成完整的scan chain
DFF 输出floating 会导致scan chain断开，即使增加TM进⾏控制，输出也很难加⼊正常的逻辑链
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/5fc95e8b79b519986abecff679a588938834edab19d4cf6d1aa13623cf9bd2ce.jpg)

# 11. Design Style Guideline Rules
<table><tr><td>Name</td><td>Comments</td></tr><tr><td>DG.1</td><td>模块输出使用寄存器输出</td></tr><tr><td>DG.2</td><td>模块输入先经过寄存器锁存再使用</td></tr><tr><td>DG.3</td><td>避免纯组合逻辑的模块设计</td></tr><tr><td>DG.4</td><td>模块要有复位控制信号</td></tr><tr><td>DG.5</td><td>复位信号应该包括hard_reset和soft_reset</td></tr><tr><td>DG.6</td><td>复位信号统一为低电平</td></tr><tr><td>DG.7</td><td>模块受同步使能信号控制</td></tr><tr><td>DG.8</td><td>不直接使用标准单元库中的cell</td></tr><tr><td>DG.9</td><td>条件赋值语句不嵌套使用</td></tr><tr><td>DG.10</td><td>无优先级的逻辑使用case语句来实现</td></tr><tr><td>DG.11</td><td>可复用功能模块化</td></tr><tr><td>DG.12</td><td>异步复位不做同步化处理</td></tr><tr><td>DG.13</td><td>计数器复位优先级高于计数优先级</td></tr><tr><td>DG.14</td><td>Gating时钟前后保留足够的margin</td></tr><tr><td>DG.15</td><td>同一个DFF时钟切换前后要保留足够的时间</td></tr><tr><td>DG.16</td><td>不对大量的寄存器使用移位操作</td></tr><tr><td>DG.17</td><td>FSM状态机需设计为主状态机+子状态机的模式</td></tr><tr><td>DG.18</td><td>FSM状态机需要同步复位/置位操作</td></tr><tr><td>DG.19</td><td>使用common_lib</td></tr></table>
# DG.1 模块输出使用寄存器输出
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/deecd3d77db2ad7ba82625e0d253853a3f0437835f680728d5e3081960d12f64.jpg)

可预期延时 $=$ wire delay $^ +$ logic delay
# DG.2 模块输入先经过寄存器锁存再使用
这种情况下，只要满⾜DFF setup要求，在⼀个clock内剩余的时间都可以留作input delay margin，对前⼀个模块更友好。
# DG.3 避免纯组合逻辑的模块设计
综合时跨模块优化很难进⾏
前接模块 $^ +$ 该模块 $^ +$ 后接模块才可以进⾏实际的timing分析
# DG.4 模块要有复位控制信号
复位信号保证确定的信号值，确定的信号值保证确定的⼯作状态
# DG.5复位信号应该包括hard_reset和soft_reset
软件复位的代价是最低的，对于后⾯复位，效果是⼀样的
复位开关电源开吴
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/f505c1669dbf3b974c6ababf5c2d885614530683465f05273be9a555a6fa99dd.jpg)

# DG.6 复位信号统一为低电平
power 
没有电源
电源不稳
电源稳定
reset_n 
稳定复位
# DG.7 模块受同步使能信号控制
power 
clk 
reset 
enable 
同步使能信号可以对模块进⾏控制，通过关闭可以降低功耗
同步使能信号有效时，电源，异步复位已经结束，所有寄存器的⼯作状态都同步起来了
# DG.8
# 不直接使用工艺相关库单元
综合时需要设置dont_touch才能保留该单元，处理较⿇烦
不能跨⼯艺使⽤，代码⽆复⽤性。SMIC和TSMC是不能交叉使⽤的。
# DG.9 条件赋值语句不嵌套使用
# 代码块
assign a1 $=$ b ? (c? 
d: e) : f; 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/e0828da0d95a365f84fe9f0292ebd6278f77f78952f58efda9f850bb1c3321ea.jpg)

# 代码块
always @(*)1 
2 $\mathsf { i f } ( \mathsf { b \Omega } = \mathsf { \Omega } _ { 1 } \prime \mathsf { b } \mathsf { 1 } )$ 
3 begin 
4 if(c == 1'b1) 
5 a = d; 
6 else 
7 a = e; 
8 end 
9 else 
10 a = f 
# DG.10
# 无优先级的逻辑使用case语句来实现
# 代码块
模式1： 颜⾊1 $=$ 红⾊；
模式2： 颜⾊2 $=$ 绿⾊；
3 
模式n： 颜⾊4 $=$ 蓝⾊；
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/1d5d42dcf16f37dbf82e6f08c67d266ca64b7ad5b54ad25fcbf6c7c5e6ce49d5.jpg)

# 代码块
always @(*)1 
case（）2 
3 0 : color = red; 
4 1 : color = green; 
5 
6 n : color = blue; 
7 endcase 
# DG.11 可复用功能模块化
# 代码块
module 1 ieee_1500_1(); 
2 module ieee_1500_2(); 
3 
4 module ieee_1500_n(); 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/908f088702f9131ed3a174ddfe8692966636c5c3671179916cf0ea5602892436.jpg)

# 代码块
module ieee_1500();1 
2 
ieee_15003 
u_ieee_1500_1(); 
ieee_15004 
u_ieee_1500_2(); 
5 
ieee_15006 
u_ieee_1500_n(); 
# DG.12 异步复位不做同步化处理
power 
plI_clk 
reset 
异步复位同步化在外部提供时钟时才能进⾏，这种上电时序有时候并不能满⾜；
异步复位 $^ +$ 同步复位/置位才能解决这种问题，并且不依赖于上电时序；
# DG.13 计数器复位优先级高于计数优先级
# 代码块
1 assign cnt_rst $=$ cnt $\mathbf { \Sigma } = \mathbf { \Sigma } \times \mathbf { \Sigma }$ ; 
2 assign cnt_incr $=$ cnt $\mathsf { { < } } \mathsf { { = } } \mathsf { { \times } }$ ; 
3 always 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/955978ff0bd19d333ddf9a2278cf7c50f00de01ebc8bfea3872d9e3d6c7bd84b.jpg)

# 代码块
assign cnt_rst1 $=$ cnt $\mathbf { \Sigma } = \mathbf { \Sigma } \times \mathbf { \Sigma }$ ; 
assign cnt_incr2 $=$ cnt $< = \times$ ; 
always3 
4 i f ( c n t _ i n c r ) 
5 c n t $< =$ c n t  + 1 ’ b 1 ; 
e l s e 6 
i f ( c n t _ r s t )7 
8 c n t  < =  0 ; 
4 i f ( c n t _ r s t ) 
5 c n t $\qquad < 0$ 
e l s e6 
i f ( c n t _ i n c r )7 
8 c n t  < =  c n t  + 1 ’ b 1 ; 
cnt_incr 
cnt_rst 
cnt 
计数
计数器值未复位
# DG.14 Gating时钟前后保留足够的margin
clk_ori 
clk 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/d7431a004c72ac8e8f8a00a03d427f8903b5606f550b37bc1c9fc530e6dd860b.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/57436f574cb92e3603b768890eb2662c2be41a16379f901a96c8bf661184172f.jpg)

clk_gate 
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/ed9d05ee578d6d157063aa15c6a3bc48d5555a9c02a7174de63086f5729ac9a8.jpg)

第一个时钟cycle 周期缩短
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/2388c7b8cbd5e140c1301f628246718183139a265751366d2012d8eaf70f6b8c.jpg)

# DG.15同一个DFF时钟切换前后要保留足够的时间
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/9e203b1cdf69b904ea0a418e657477f0f6d0f31c914a9868180fc3e3948bbce5.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/e735cd58236fc126977def677a39ace256356a40c03669ce1cc234c6eb176bad.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/5a942449d4a40247d62ea1f6b35b9ad819d887eac7ac01cfbb4ec3b01089eb94.jpg)


clk_slow时钟域setup不能满足

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/07e02880ba1123bce85d1d596d8f78d523c5d1f7eddaab07d24d37a7c9244a85.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/71caaf63c2f5d47bb0bcc37c1f7fd63b9a61422ea46bbf416313f5bfa7636026.jpg)


clk_fast时钟域setup不能满足

# DG.16 不对大量的寄存器使用移位操作
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/18a00357d8972b9e9c0e23f233a9961917dda6ecb2b1b5e3529bda697facef01.jpg)

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/fe049df8506dd5d29d68b9addfa4362ac8b5b3b92988bca5bff8d2cc6a6117bd.jpg)

-般情况下DFF toggle rate 15%
移位状态下DFF toggle rate 可达 $100 \%$ 
# DG.17 FSM状态机需设计为主状态机+子状态机的模式
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/6718fe552d21db8224b92434d32bfa377e57d209e998105709c931d9fe3a2d8c.jpg)

# DG.18 FSM状态机需要同步复位/置位操作
![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/93c3fc11e3ffdd905e9604fbc232a42744bac546af4921aa35cb2aea8f7e9328.jpg)

# DG.19 使用common_lib
需要调⽤std cell的设计（clock cells(gate/switch) delay cell, clock IPs(switch/divider),synchronizer, FIFO, RAM等) 必须调⽤common lib cell
数字RTL设计common lib规范
# 附录-缩写
全称
缩写
<table><tr><td>acknowledge</td><td>ack</td></tr><tr><td>active</td><td>act</td></tr><tr><td>analog digital convert</td><td>adc</td></tr><tr><td>add</td><td>add</td></tr><tr><td>address</td><td>addr(ad)</td></tr><tr><td>adjustment</td><td>adj</td></tr><tr><td>arbiter</td><td>arb</td></tr><tr><td>bank</td><td>bk</td></tr><tr><td>bit</td><td>bit</td></tr><tr><td>break</td><td>brk</td></tr><tr><td>byte</td><td>byte</td></tr><tr><td>by pass</td><td>byps</td></tr><tr><td>check</td><td>chk</td></tr><tr><td>clock</td><td>clk</td></tr><tr><td>channel</td><td>ch</td></tr><tr><td>chip select</td><td>cs</td></tr><tr><td>column</td><td>col</td></tr><tr><td>config</td><td>cfg</td></tr><tr><td>control</td><td>ctrl</td></tr><tr><td>counter</td><td>cnt</td></tr><tr><td>cyclic redundancy check</td><td>crc</td></tr><tr><td>data input</td><td>din(di)</td></tr><tr><td>data output</td><td>dout(do)</td></tr><tr><td>data dff delay output</td><td>dn</td></tr><tr><td>decode</td><td>dec</td></tr><tr><td>decrease</td><td>decr</td></tr><tr><td>delay</td><td>dly</td></tr><tr><td>different</td><td>diff</td></tr><tr><td>disable</td><td>dis</td></tr><tr><td>divide</td><td>div</td></tr><tr><td>digital analog convert</td><td>dac</td></tr><tr><td>down</td><td>down</td></tr><tr><td>branching multiplexer</td><td>dmux</td></tr><tr><td>error</td><td>err</td></tr><tr><td>enable</td><td>en</td></tr><tr><td>end</td><td>end</td></tr><tr><td>encoder</td><td>enc</td></tr><tr><td>error correction code</td><td>ecc</td></tr><tr><td>equalizer</td><td>eq</td></tr><tr><td>even</td><td>even</td></tr><tr><td>external</td><td>ext</td></tr><tr><td>first in first out</td><td>fifo</td></tr><tr><td>frame</td><td>frm</td></tr><tr><td>fuse</td><td>fuse</td></tr><tr><td>function</td><td>func</td></tr><tr><td>generate</td><td>gen</td></tr><tr><td>grant</td><td>gnt</td></tr><tr><td>group</td><td>grp</td></tr><tr><td>height</td><td>h</td></tr><tr><td>increase</td><td>incr</td></tr><tr><td>interrupt</td><td>int</td></tr><tr><td>input</td><td>in</td></tr><tr><td>length</td><td>len</td></tr><tr><td>left</td><td>l</td></tr><tr><td>least significant bit</td><td>lsb</td></tr><tr><td>maximum</td><td>max</td></tr><tr><td>maximum significant bit</td><td>msb</td></tr><tr><td>minimum</td><td>min</td></tr><tr><td>memory</td><td>mem</td></tr><tr><td>multiplexer</td><td>mux</td></tr><tr><td>multiple</td><td>mul</td></tr><tr><td>negative edge</td><td>neg</td></tr><tr><td>odd</td><td>odd</td></tr><tr><td>output</td><td>out</td></tr><tr><td>overflow</td><td>ov</td></tr><tr><td>packet</td><td>pkt</td></tr><tr><td>package</td><td>pkg</td></tr><tr><td>parity</td><td>par</td></tr><tr><td>phase</td><td>ph</td></tr><tr><td>physical</td><td>phy</td></tr><tr><td>phase detect</td><td>pd</td></tr><tr><td>power</td><td>pwr</td></tr><tr><td>power down</td><td>pdwn</td></tr><tr><td>power up</td><td>pwup</td></tr><tr><td>positive edge</td><td>peg</td></tr><tr><td>previous charge</td><td>pchg</td></tr><tr><td>priority</td><td>pri</td></tr><tr><td>program counter</td><td>pc</td></tr><tr><td>pulse</td><td>p</td></tr><tr><td>pointer</td><td>ptr</td></tr><tr><td>read</td><td>rd</td></tr><tr><td>read enable</td><td>ren</td></tr><tr><td>ready</td><td>rdy</td></tr><tr><td>receive</td><td>rx</td></tr><tr><td>reference</td><td>ref</td></tr><tr><td>refresh</td><td>rfr</td></tr><tr><td>request</td><td>req</td></tr><tr><td>right</td><td>r</td></tr><tr><td>row</td><td>row</td></tr><tr><td>saturation</td><td>sat</td></tr><tr><td>segment</td><td>seg</td></tr><tr><td>sequence</td><td>seq</td></tr><tr><td>sleep</td><td>slp</td></tr><tr><td>source</td><td>src</td></tr><tr><td>start</td><td>stt</td></tr><tr><td>status</td><td>sta</td></tr><tr><td>strobe</td><td>stb</td></tr><tr><td>stop</td><td>stp</td></tr><tr><td>substrate</td><td>sub</td></tr><tr><td>switch</td><td>sw</td></tr></table>



<table><tr><td>switch</td><td>sw</td></tr><tr><td>temporary</td><td>tmp</td></tr><tr><td>temporary signal</td><td>tn</td></tr><tr><td>testbench</td><td>tb</td></tr><tr><td>through Silicon Via</td><td>tsv</td></tr><tr><td>threshold</td><td>th</td></tr><tr><td>timer</td><td>tmr</td></tr><tr><td>top</td><td>top</td></tr><tr><td>transmit</td><td>tx</td></tr><tr><td>trimming</td><td>trim</td></tr><tr><td>trigger</td><td>trig</td></tr><tr><td>update</td><td>ud</td></tr><tr><td>valid</td><td>vld</td></tr><tr><td>vector</td><td>vec</td></tr><tr><td>wait</td><td>wait</td></tr><tr><td>width</td><td>w</td></tr><tr><td>word</td><td>word</td></tr><tr><td>write</td><td>wr</td></tr><tr><td>write enable</td><td>wen</td></tr></table>

附录-Rule 和Annotation的对应列表

<table><tr><td>Rule</td><td>须自查</td><td>命名规则</td></tr><tr><td>NAME.1</td><td></td><td>STARC-1.1.1.2 STARC-1.1.1.9b STARC02-1.1.1.2 STARC02-1.1.1.9b STARC05</td></tr><tr><td>NAME.2</td><td></td><td>这个工具编译都不过，没有rule</td></tr><tr><td>NAME.3</td><td></td><td>STARC-1.1.1.5 STARC02-1.1.1.5 STARC05-1.1.1.5 ConsCase</td></tr><tr><td>NAME.4</td><td></td><td></td></tr><tr><td>NAME.5</td><td></td><td></td></tr><tr><td>NAME.6</td><td></td><td></td></tr><tr><td>NAME.7</td><td></td><td>STARC-1.1.1.1 STARC02-1.1.1.1 STARC05-1.1.1.1</td></tr><tr><td>NAME.8</td><td></td><td>STARC-1.1.4.2 STARC02-1.1.4.2 STARC05-1.1.4.2a ConstName ParamName</td></tr><tr><td>NAME.9</td><td></td><td>PortName</td></tr><tr><td>NAME.10</td><td></td><td></td></tr><tr><td>NAME.11</td><td></td><td></td></tr><tr><td>NAME.12</td><td></td><td></td></tr><tr><td>NAME.13</td><td></td><td></td></tr><tr><td>NAME.14</td><td></td><td></td></tr><tr><td>NAME.15</td><td></td><td></td></tr><tr><td>NAME.16</td><td></td><td></td></tr><tr><td>NAME.17</td><td></td><td>STARC02-1.1.3.3 STARC05-1.1.3.3b</td></tr><tr><td>NAME.18</td><td></td><td></td></tr><tr><td>NAME.19</td><td></td><td>InvalidReverseIndexing-ML STARC-2.1.6.1 BitOrder-ML</td></tr><tr><td>NAME.20</td><td></td><td></td></tr><tr><td colspan="3">标准头文件</td></tr><tr><td>FH.1</td><td></td><td>STARC-3.5.3.1 STARC02-3.5.3.1 STARC05-3.5.3.1</td></tr><tr><td>FH.2</td><td></td><td></td></tr><tr><td>FH.3</td><td></td><td></td></tr><tr><td>FH.4</td><td></td><td></td></tr><tr><td>FH.5</td><td></td><td></td></tr><tr><td>FH.6</td><td></td><td></td></tr><tr><td>FH.7</td><td></td><td></td></tr><tr><td>FH.8</td><td></td><td></td></tr><tr><td>FH.9</td><td></td><td></td></tr><tr><td>FH.10</td><td></td><td></td></tr><tr><td colspan="3">注释</td></tr><tr><td>COM.1</td><td></td><td>说明信号的作用范围,功能等,并不是每个信号都需要注释,标注设计中比较</td></tr><tr><td>COM.2</td><td></td><td></td></tr><tr><td>COM.3</td><td></td><td>关键逻辑块的说明,便于理解</td></tr><tr><td>COM.4</td><td></td><td></td></tr><tr><td>COM.5</td><td></td><td></td></tr><tr><td>COM.6</td><td></td><td></td></tr><tr><td>COM.7</td><td></td><td></td></tr><tr><td>COM.8</td><td></td><td></td></tr><tr><td colspan="3">CodingStyle</td></tr><tr><td>CS.1</td><td></td><td></td></tr><tr><td>CS.2</td><td></td><td></td></tr><tr><td>CS.3</td><td></td><td></td></tr><tr><td>CS.4</td><td></td><td>STARC-3.1.3.4a STARC05-3.1.3.4a OnePortLine STARC02-3.1.3.4a</td></tr><tr><td>CS.5</td><td></td><td></td></tr><tr><td>CS.6</td><td></td><td>所有内部信号的说明都放在设计的最前面,vcs&gt;&gt;spyglass工具的检查都比较严</td></tr><tr><td>CS.7</td><td></td><td></td></tr><tr><td>CS.8</td><td></td><td></td></tr><tr><td>CS.9</td><td></td><td></td></tr><tr><td>CS.10</td><td></td><td>实例化过程中端口连接不要做逻辑</td></tr><tr><td>CS.11</td><td></td><td>CheckLocalParam-ML 注:localparameter与parameter</td></tr><tr><td>CS.12</td><td></td><td>避免运算错误，不带括号运算会根据逻辑符号的优先级进行运算，优先级相同</td></tr><tr><td>CS.13</td><td></td><td>case</td></tr><tr><td>CS.14</td><td></td><td></td></tr><tr><td>CS.15</td><td></td><td></td></tr><tr><td>CS.16</td><td></td><td></td></tr><tr><td>CS.17</td><td></td><td></td></tr><tr><td>CS.18</td><td></td><td>case</td></tr><tr><td>CS.19</td><td></td><td></td></tr><tr><td>CS.20</td><td></td><td>设计尽量参数化，可移植性</td></tr><tr><td>CS.21</td><td></td><td>ConstName ParamName</td></tr><tr><td>CS.22</td><td></td><td>同NAME.1</td></tr><tr><td>CS.23</td><td></td><td></td></tr><tr><td>CS.24</td><td></td><td></td></tr><tr><td>CS.25</td><td></td><td></td></tr><tr><td>CS.26</td><td></td><td></td></tr><tr><td>CS.27</td><td></td><td></td></tr><tr><td>CS.28</td><td></td><td></td></tr><tr><td colspan="3">综合规范</td></tr><tr><td>SYN.1</td><td></td><td></td></tr><tr><td>SYN.2</td><td></td><td></td></tr><tr><td>SYN.3</td><td></td><td></td></tr><tr><td>SYN.4</td><td></td><td></td></tr><tr><td>SYN.5</td><td></td><td></td></tr><tr><td>SYN.6</td><td></td><td>未被使用的输入端口会报出来</td></tr><tr><td>SYN.7</td><td></td><td>顶层只进行实例化，不要做逻辑，对综合会有影响</td></tr><tr><td>SYN.8</td><td></td><td></td></tr><tr><td>SYN.9</td><td></td><td></td></tr><tr><td colspan="3">STA规范</td></tr><tr><td>STA.1</td><td></td><td>会形成组合逻辑环，仿真会出现问题</td></tr><tr><td>STA.2</td><td></td><td>cdc问题，lint rule不检查</td></tr><tr><td>STA.3</td><td></td><td>设计架构的划分原则</td></tr><tr><td>STA.4</td><td></td><td>设计需求问题</td></tr><tr><td>STA.5</td><td></td><td>寄存器的时钟信号被用作非时钟信号，error</td></tr><tr><td>STA.6</td><td></td><td>对STA有影响</td></tr><tr><td colspan="3">仿真规范</td></tr><tr><td>SIM.1</td><td></td><td></td></tr><tr><td>SIM.2</td><td></td><td></td></tr><tr><td>SIM.3</td><td></td><td></td></tr><tr><td>SIM.4</td><td></td><td></td></tr><tr><td>SIM.5</td><td></td><td></td></tr><tr><td>SIM.6</td><td></td><td></td></tr><tr><td colspan="3">DFT规范</td></tr><tr><td>DFT.1</td><td></td><td></td></tr><tr><td>DFT.2</td><td></td><td></td></tr><tr><td>DFT.3</td><td></td><td></td></tr><tr><td>DFT.4</td><td></td><td></td></tr><tr><td>DFT.5</td><td></td><td></td></tr><tr><td>DFT.6</td><td></td><td></td></tr><tr><td>DFT.7</td><td></td><td></td></tr><tr><td>DFT.8</td><td></td><td></td></tr><tr><td>DFT.9</td><td></td><td></td></tr><tr><td>DFT.10</td><td></td><td></td></tr><tr><td colspan="3">设计规范</td></tr><tr><td>DG.1</td><td></td><td></td></tr><tr><td>DG.2</td><td></td><td></td></tr><tr><td>DG.3</td><td></td><td></td></tr><tr><td>DG.4</td><td></td><td></td></tr><tr><td>DG.5</td><td></td><td></td></tr><tr><td>DG.6</td><td></td><td></td></tr><tr><td>DG.7</td><td></td><td>这个信号设计中是如何使用的呢? case</td></tr><tr><td>DG.8</td><td></td><td>这种方式更贴近逻辑级电路,综合实现的电路结构</td></tr><tr><td>DG.9</td><td></td><td>不推荐使用条件运算符“?”,使用if/else,case选择结构</td></tr><tr><td>DG.10</td><td></td><td></td></tr><tr><td>DG.11</td><td></td><td></td></tr><tr><td>DG.12</td><td></td><td>cdc问题,lint rule不涉及</td></tr><tr><td>DG.13</td><td></td><td></td></tr><tr><td>DG.14</td><td></td><td>门控时钟的STA check,属于special check的一种</td></tr><tr><td>DG.15</td><td></td><td>要考虑到前后逻辑的余量问题</td></tr><tr><td>DG.16</td><td></td><td></td></tr><tr><td>DG.17</td><td></td><td></td></tr><tr><td>DG.18</td><td></td><td></td></tr><tr><td>DG.19</td><td></td><td></td></tr></table>





![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-25/9cfb4091-4670-4618-b835-13143d0568f9/5cf10ce17866321878c8d4784af7a877da25e3918656ba9cbd8b861c94489928.jpg)
