# 目录

# 1 简介..

1.1 目的...

1.2 范围..

# 2 二级模块 nACU_Shift 架构设计..

2.1 功能描述..

2.2 设计框图.

2.3 子模块描述.

2.4 数据接口..

2.5 模块特性..

2.6 异步设计.. .6

2.7 低功耗设计. .6

2.8 dfx 设计 .

2.9 重用分析..

2.10 可验证性分析..

# 3 三级模块 PreCh_Shift_nACU 设计.. 8

3.1 设计框图.. .8

3.2 处理描述. .8

3.3 数据接口.. .10

3.4 参考波形.. .10

3.5 dfx 设计 . .12

3.6 重用分析.. 12

# 4 三级模块 PreCh_BKinf_Shift_nACU 设计.. 13

4.1 设计框图.. .13

4.2 处理描述.. .13

4.3 数据接口.. .13

4.4 参考波形.. .15

4.5 dfx 设计 . .15

4.6 重用分析.. .15

# 5 三级模块 MR_Dec 设计.. .16

5.1 设计框图.. .16

5.2 处理描述.. .17

5.3 数据接口. .19

5.4 dfx 设计 . .20

5.5 重用分析.. .20

# 6 三级模块 Glue 设计. .21

6.1 设计框图.. .21

6.2 处理描述.. .21

6.3 数据接口.. .22

6.4 dfx 设计 . .22

6.5 重用分析.. .22

# 附录 .. .23

# 图目录

图 1. nACU 示例 . 

图 2. nACU_Shift 设计框图

图 3. PreCh_Shift_nACU 设计框图. .8

图 4. PreCh_Shift_nACU 结构详图. 

图 5. 慢速时钟频率下，工作参考波形图. 11

图 6. 快速时钟频率下，启动参考波形图. 11

图 7. 快速时钟频率下，结束参考波形图. 12

图 8. PreCh_BKinf_Shift_nACU 设计框图. .13

图 9. PreCh_BKinf_Shift_nACU 参考波形.. .15

图 10. PreCh_Shift_nACU 中需要被 MR_Dec 控制的单元 . .16

图 11. nACU 在 DVFSL 关闭的情况下的数量. 17

图 12. nACU 在 DVFSL 启动的情况下的数量. 17

图 13. MR1OP[4]与 DVFSL 的对应 . .17

图 14. MR1OP[4:0]与 nACU 数量的对应 .18

图 15. 定制电路中的 glue 逻辑. .21

# 表目录

表 1. TOP 输入接口 .

表 2. TOP 输出接口 .

表 3. 主要功能特性.

表 4. PreCh_Shift_nACU 输入接口.. .10

表 5. PreCh_Shift_nACU 输出接口... .10

表 6. PreCh_BKinf_Shift_nACU 输入接口. .13

表 7. PreCh_BKinf_Shift_nACU 输出接口. .14

表 8. 被 MR_Dec 控制的单元表. .16

表 9. 解码表 a... .18

表 10. 解码表 b.. .18

表 11. 解码表 c .. .19

表 12. 配置表.. .19

表 13. MR_Dec 输入接口. .19

表 14. MR_Dec 输出接口 ..20

表 15. GLUE 输入接口. .22

表 16. GLUE 输出接口. .22

# 1 简介

# 1.1 目的

本文档的主要用于描述用于实现 nACU_Shift功能的主要模块和其内部设计细节，用于RTL编写参考，便于后续迭代修改。

# 1.2 范围

本文档描述的 nACU_Shift 模块用于 PIM2 项目，其主要功能是用于保护 LPDDR6 中定义的 nACU 延时，负责对 PreCh、WrAp、RdAp 命令及其相关信息根据 MR 的配置进行延时。产生 perBK 的预充电命令

# 2 二级模块 nACU_Shift 架构设计

# 2.1 功能描述

根据 LPDDR6 协议，由于新增了 PRAC 功能，需要对每行的 ACT 时间和次数进行计数，此计数器要在每行关闭时更新(ACU)，因此需要增加PreCh命令的时间，用于进行ACU。因此协议要求在Host下发的PreCh命令之后，由 DRAM自身在内部基于下发的 PreCh 命令时刻经过一定延时之后重新产生一个内部的预充电命令 iPreCh，这段延时将被用于行激活计数器更新，这段时间被定义为 nACU(图中为 tACU)，如下图 1 所示。

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/1e4d2dd986a00682effeb5715032081db66374ce734c0045537d0f2572698cbe.jpg)



图 1. nACU 示例


本模块承载来自 CmdDec 的 PreCh 命令、经过 tRTP 延时的 RdAp 命令、经过 WL+BL/n+tWTP 延时的 WrAp 命令。它们在本模块根据 MR 的相关配置进行延时，然后产生per_bank 的预充电命令，再送往 RowCtrl 和 ECSCtrl。

# 2.2 设计框图

本模块的主要结构如下图2所示，

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/673f08f375bd71401b647f7424f497ee5f7c648d0493c0f50a1826bfe0e7b592.jpg)



图 2. nACU_Shift 设计框图


主要包括 MR_Dec、Glue、PreCh_Shift_nACU、PreCh_BKinf_Shift_nACU(Syn FIFO)、WrAp_Shift_nACU 、 WrAp_BKinf_Shift_nACU(Syn FIFO) 、 RdAp_Shift_nACU 、RdAp_BKinf_Shift_nACU(Syn FIFO)八个子模块。

# 2.3 子模块描述

MR_Dec 模块主要负责解析相关 MR 的配置，控制 shift 模块内部的 switch 和 mux，从而控制命令在 shift 内部的延迟时间，此外它还负责产生配置信号控制模块内部的 clk 控制模块，按需产生时钟，从而降低功耗。

PreCh_Shift_nACU 模块主要负责根据 MR 的配置对 PreCh 命令进行适当的延时，控制PreCh_BKinf_Shift_nACU 模块中的同步 FIFO 的数据读写。

WrAp_Shift_nACU 模块主要负责根据 MR 的配置对 WrAp 命令进行适当的延时，控制WrAp _BKinf_Shift_nACU 模块中的同步 FIFO 的数据读写。

RdAp_Shift_nACU 模块主要负责根据 MR 的配置对 RdAp 命令进行适当的延时，控制RdAp _BKinf_Shift_nACU 模块中的同步 FIFO 的数据读写。

PreCh_BKinf_Shift_nACU 模块是一个同步 FIFO 模块，它主要负责根据 PreCh_Shift_nACU 产生的读写控制信息，将命令相应的 bank 地址同步延时，并且最终产生 PreBK 的PreCh 命令。

WrAp_BKinf_Shift_nACU 模块是一个同步 FIFO 模块，它主要负责根据 WrAp_Shift_nACU 产生的读写控制信息，将命令相应的 bank 地址同步延时，并且最终产生 PreBK 的PreCh 命令。

RdAp_BKinf_Shift_nACU 模块是一个同步 FIFO 模块，它主要负责根据 RdAp_Shift_nACU 产生的读写控制信息，将命令相应的 bank 地址同步延时，并且最终产生 PreBK 的PreCh 命令。

Glue 模块，实际上是一个或逻辑，主要负责将 PreCh、WrAp、RdAp 经过延时之后产生的perBK的预充电命令合并，并输出。

# 2.4 数据接口

本模块数据输入输出接口描述如下表 1 和表 2 所示。


表 1. TOP 输入接口


| 接口名称 | 位宽 | 描述 | 时钟域 |
| --- | --- | --- | --- |
| CK_nACU | 1 | 时钟信号，CK信号 | CK, CK/2 |
| CK_div2_nACU | 1 | 时钟信号，CK信号的二分频 | CK, CK/2 |
| Reset | 1 | 重置信号 | CK, CK/2 |
| MR1_OP[4:0] | 5 | 模式寄存器1的低五位,有Host进行配置,用于控制nACU的时长,单位为tCK | 静态 |
| MR11_OP[4] | 1 | 模式寄存器11的第5位,用于指示DVFSL是否启用,nACU的时长会受到它的影响,启用DVFSL之后,nACU会更长 | 静态 |
| PracEn | 1 | 来自MR76OP5和cm1_ro_PracDisRW,共同控制PRAC功能的启用,如果PRAC功能不启用,则本模块不工作 | 静态 |
| EcsEnWin | 1 | ECS window enable信号,会影响nACU的时长 | 待确认 |
| PreCh_wo_nACU | 1 | 来自于CmdDec模块,用于指示收到了PreCh命令 | CK, CK/2 |
| PreCh_SC_wo_nACU | 1 | 来自于CmdDec模块,PreCh命令的SC信息 | CK, CK/2 |
| PreCh_AB_wo_nACU | 1 | 来自于CmdDec模块,PreCh命令的AB信息 | CK, CK/2 |
| PreCh_BA0_wo_nACU | 1 | 来自于CmdDec模块,PreCh命令的BANK地址信息 | CK, CK/2 |
| PreCh_BA1_wo_nACU | 1 | 来自于CmdDec模块,PreCh命令的BANK地址信息 | CK, CK/2 |
| PreCh_BG0_wo_nACU | 1 | 来自于CmdDec模块,PreCh命令的BANK地址信息 | CK, CK/2 |
| PreCh_BG1_wo_nACU | 1 | 来自于CmdDec模块,PreCh命令的BANK地址信息 | CK, CK/2 |
| WrAp_wo_nACU | 1 | 经过WL+BL/n+nWTP延时的WrAp命令 | CK, CK/2 |
| WrAp_SC_wo_nACU | 1 | WrAp命令的SC信息 | CK, CK/2 |
| WrAp_BA0_wo_nACU | 1 | WrAp命令的BANK地址信息 | CK, CK/2 |
| WrAp_BA1_wo_nACU | 1 | WrAp命令的BANK地址信息 | CK, CK/2 |
| WrAp_BG0_wo_nACU | 1 | WrAp命令的BANK地址信息 | CK, CK/2 |
| WrAp_BG1_wo_nACU | 1 | WrAp命令的BANK地址信息 | CK, CK/2 |
| RdAp_wo_nACU | 1 | 经过nRTP延时的RdAp命令 | CK, CK/2 |
| RdAp_SC_wo_nACU | 1 | RdAp命令的SC信息 | CK, CK/2 |
| RdAp_BA0_wo_nACU | 1 | RdAp命令的BANK地址信息 | CK, CK/2 |
| RdAp_BA1_wo_nACU | 1 | RdAp命令的BANK地址信息 | CK, CK/2 |
| RdAp_BG0_wo_nACU | 1 | RdAp命令的BANK地址信息 | CK, CK/2 |
| RdAp_BG1_wo_nACU | 1 | RdAp命令的BANK地址信息 | CK, CK/2 |
| FnCompN | 1 | 来自于cm0 ts_comp,一种 testmode,它会影响SC信息的解码 | 静态 |


表 2. TOP 输出接口


| 接口名称 | 位宽 | 描述 | 时钟域 |
| --- | --- | --- | --- |
| CK_En_nACU | 1 | 本模块CK使能信号 | CK, CK/2 |
| PreCh_SC0_BG0_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC0的PreBank的PreCh命令 | CK |
| PreCh_SC0_BG1_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC0的PreBank的PreCh命令 | CK |
| PreCh_SC0_BG2_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC0的PreBank的PreCh命令 | CK |
| PreCh_SC0_BG3_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC0的PreBank的PreCh命令 | CK |
| PreCh_SC1_BG0_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC1的PreBank的PreCh命令 | CK |
| PreCh_SC1_BG1_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC1的PreBank的PreCh命令 | CK |
| PreCh_SC1_BG2_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC1的PreBank的PreCh命令 | CK |
| PreCh_SC1_BG3_Bnk_w_nACU(3:0) | 4 | 经过shift之后SC1的PreBank的PreCh命令 | CK |

# 2.5 模块特性

本模块主要特性和功能如下表 3所示。


表 3. 主要功能特性


| Number | Feature | Sub Feature | Description |
| --- | --- | --- | --- |
| 1 | 时钟控制 | 本模块输入时钟启用和关闭 | 在不需要时,可以关闭本模块的时钟输入,从而降低功耗 |
| 1 | 时钟控制 | XXXSHIFT_nACU模块中,一些DFF的时钟启动和关闭 | 根据nACU的所需要花费的CK拍数,关闭不需要的DFF |
| 1 | 时钟控制 | CK_div2_nACU的二分频 | 在高速情况下进一步降低时钟频率,降低功耗,减少DFF数量 |
| 2 | 命令延时和解码 | PreCh的延时和解码 | 根据配置将PreCh命令及其相关信息延时nACU,并产生PerBank的预充电命令 |
| 2 | 命令延时和解码 | WrAp的延时和解码 | 根据配置将WrAp命令及其相关信息延时nACU,并产生PerBank的预充电命令 |
| 2 | 命令延时和解码 | RdAp的延时和解码 | 根据配置将RdAp命令及其相关信息延时nACU,并产生PerBank的预充电命令 |
| 3 | 配置解码 | MR配置解码 | 根据MR1和MR11的配置解码出延时nACU所需要的CK数 |
| 4 | 预充电命令整合 | 产生PerBANK的预充电命令 | 将PreCh、WrAp和RdAp产生的三组PerBank预充电命令整合成一组PerBank预充电命令 |

# 2.6 异步设计

# 2.7 低功耗设计

# 1、 时钟门控

# 2、 数据路径优化

# 3、 状态机与流水线设计

# 2.8 dfx 设计

# 2.9 重用分析

# 2.10可验证性分析

# 3 三级模块 PreCh_Shift_nACU 设计

# 3.1 设计框图

PreCh_Shift_nACU 的模块简图如下图 3 所示。

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/2ccc563515f5db6c982d913cb82fd9bf1a7b94a193d0c4cccbcd588a0d385d4a.jpg)



图 3. PreCh_Shift_nACU 设计框图


PreCh_Shift_nACU 主要由 input_shift、main_shift、output_shift 以及 clk_ctl 四个部分构成，input_shift 负责在高频的情况下记录 prech 的边沿信息。main_shfit 负责对命令进行 shift，它由若干个DFF构成。Output_shift主要有两个功能，负责在高频模式下将可能连续的两笔命令拆分，负责对命令进行精细化 shift，这是由于，main_shift工作在CK/2或者CK/4 的时钟频率下，因此它能够做到的 shift 周期数一定是 CK 的偶数倍，而根据 LPDDR6的协议配置要求，命令的 shift 周期数可能是 CK 的奇数倍，因此额外需要工作在 CK 时钟频率下的shift_dff。Clk_ctl 负责控制时钟的 gate 和 div，负责在不需要时关闭模块的时钟，负责在高速时对 CK/2 时钟进行进一步分频。

本模块中的 clk_gate、switch 和 mux 均由 MR_Dec 控制。

# 3.2 处理描述

本模块的详细结构图如下图 4 所示。

T1_dff、t2_dff、t3_dff 以及 save_edge 功能，共同构成了 input_shift。它们能够在 CK/2的时钟频率下，对输入的命令缓存三拍。它们的主要功能有两个，在高频时钟下，main_shift运行在 CK/4 的时钟频率下，此时需要展宽命令，并保存命令在 CK/2 时钟下的边沿信息，这样才能保住快速时钟域的脉冲能够被低速时钟域采到，此外它们还负责启动本模块的时钟，延迟三拍是由于 clk_ctl架构的限制，防止在某些情况下时钟被误关闭。

Main_shift0~7、odd_even_shfit 以及附带的 switch、mux 共同构成了 main_shift，它们负

责按照配置要求对命令进行 shift，工作在 CK/2 或者 CK/4 的时钟频率下，具体取决于时钟速度，它们的 shift 范围为 0nck~34nck(以 2nck 步进)或者 0nck~68nck(以 4nck 步进)。

Shift1~4 以及附带的 mux 共同构成了 output_shift。在高频时钟域下，main_shift 可能会输出连续的命令，它负责将这些命令拆分(shift1)。此外由于 main_shift 本身不能完整的将命令 shift 协议所要求的 nACU，它负责将命令 shift 剩余的 CK 数量(shift2 和 shift4)。Shfit3 负责对命令进行打拍，这是由于 FIFO 读出时需要两拍 CK/2时钟。

![image](https://cdn-mineru.oimage.pngpenxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/2eb3968c39997e0d13f18e0cf4f33b6fe2b5e02ad004e6ff53cb13c533dc272c.jpg)



图 4. PreCh_Shift_nACU 结构详图


Clk_en_cnt、clk_en_dff、gate、div 以及其他附属逻辑共同构成了 clk_ctl，本模块的 clk_ctl主要有以下几个功能：

1. 启动和关闭本模块的时钟，在收到 PreCh命令时，立刻启动本模块时钟，在命令进入main_shift时，启动clk_en_cnt以保持时钟启动，当 cnt结束之后关闭时钟，以降低功耗。

2. 时钟分频和切换，在高速的情况下，进一步降低 main_shift 和 clk_en_cnt 的工作频

率，以节省功耗和面积。

3. 根据需要精细化控制 DFF 的输入时钟的启动和关闭，例如 nACU 的数量为 10，则将多余的main_shift的DFF 的输入时钟全部关闭，以降低功耗。

# 3.3 数据接口

本模块的主要输入输出接口如下表 4 和表 5 所示。


表 4. PreCh_Shift_nACU 输入接口


| input | width | from | description |
| --- | --- | --- | --- |
| CK_div2_nACU | 1 | TOP | CK的二分频时钟 |
| Reset | 1 | TOP | 重置信号 |
| PreCh_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令 |
| T3_en | 1 | MR_DEC | 用于控制input_shift中的第三个DFF是否启用，仅在高速时启用 |
| Div2_en | 1 | MR_DEC | 用于控制是否启动内部分频器，仅在高速时启用 |
| _clk_mux | 1 | MR_DEC | 用于选择main SHIFT中DFF使用的时钟 |
| Save_edge_en | 1 | MR_DEC | 用于控制是否启动save_edge_dff，仅在高速时启用 |
| Shift0_mux | 1 | MR_DEC | 用于控制main shift的输入选择 |
| Oddshift_en | 1 | MR_DEC | 用于控制main shift的周期数 |
| Odd_mux | 1 | MR_DEC | 用于控制main shift的周期数 |
| Switch00 | 1 | MR_DEC | 用于控制main shift的周期数 |
| Switch0_7[7:0] | 8 | MR_DEC | 用于控制main shift的周期数 |
| Gate0_7[7:0] | 8 | MR_DEC | 用于控制main shift的周期数 |
| Shift2_en | 1 | MR_DEC | 用于控制output shift的周期数 |
| Shift2_mux | 1 | MR_DEC | 用于控制output shift的周期数 |
| Value_for_rst[4:0] | 5 | MR_DEC | 用于控制clk_en_cnt的初始化值 |


表 5. PreCh_Shift_nACU 输出接口


| output | width | to | description |
| --- | --- | --- | --- |
| PreCh_clk_en | 1 | glue | PreCh命令需要进行Shift，因此请求时钟启动 |
| PreCh_fifo_out1 | 1 | PreCh_BKinfSHIFT_nACU | 经过shift的PreCh命令 |
| PreCh_fifo_out2 | 1 | PreCh_BKinfSHIFT_nACU | 经过shift的PreCh命令 |

# 3.4 参考波形

本小结给出上述电路主要功能的参考波形，分成低速和高速两种情况。

需要说明的是，根据协议要求，在CK时钟域下，命令只会在偶数边沿出现，而且出现的间隔最小为 4，因此在 CK/2 时钟域下，命令在最密集的情况下也只会间隔出现，下列参考波形图均以这种最密集情况为例。

当本模块工作在慢速时钟频率下，其启动和结束波形如下图 5 所示。

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/625e9dc53be31cda0d213d42142e9de1acbe77a036e07246a759470b1d3c23fc.jpg)



图 5. 慢速时钟频率下，工作参考波形图


说明：

1. 命令当拍即启动时钟。

2. 命令花费一拍时间，即进入 main_shift。

3. 令进入 main_shift 的第一拍，重置并启动 clk_en_cnt。

4. clk_en_cnt 结束触发关闭时钟

5. 框中波形图展示的是，在即将关闭时钟时，收到一笔新的命令可能会导致时钟误关闭，这是由于从收到命令到启动 clk_en_cnt需要花费两拍时间，因此需要将输入命令延迟一拍来保持时钟的启动。

本模块工作在快速时钟频率下，其启动和结束波形如下图 6 和图7所示。

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/f8fbbde028bc637101f37132ab532d864df5b842edc8e4576299906e5517e376.jpg)



图 6. 快速时钟频率下，启动参考波形图


说明：

1. 命令花费一拍被采到，并记录边沿信息。

2. 命令花费两拍被采用，并记录边沿信息。

# 3. Main_shift 和 clk_en_cnt 工作在 CK/4 的时钟速度下

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/006175da2750ab72601b73642280d993176bcf0abc22a4ae4ee3723dbb93a4ba.jpg)



图 7. 快速时钟频率下，结束参考波形图


框中波形图展示的是，在即将关闭时钟时，收到一笔新的命令可能会导致时钟误关闭，这是由于从收到命令到启动 clk_en_cnt 需要花费三拍(CK/2)时间，因此需要将输入命令延迟两拍(CK/2)来保持时钟的启动。

# 3.5 dfx 设计

# 3.6 重用分析

# 4 三级模块 PreCh_BKinf_Shift_nACU 设计

# 4.1 设计框图

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/1b54a4294476ec44f4317b60bb35ace3adc7f5dd6c9f6dc7b810416490aa49b7.jpg)



图 8. PreCh_BKinf_Shift_nACU 设计框图


本模块的核心部分是一个同步 FIFO，它主要负责根据PreCh_Shift_nACU 模块产生的信号，将命令附带的Bank地址信息在适当的时间写入和读出FIFO，已达到延迟的效果，此外它还负责将Bank 地址信息解码成 PerBank的预充电命令，然后输出。

# 4.2 处理描述

本模块是一个同步 FIFO，其深度为 24，其最小深度为 tACU/tPPD=20。

写使能一直为高，等待写时钟的到来，每产生一次命令，就会释放一拍的CK/2 时钟脉冲，将命令携带的Bank信息写入FIFO，并且FIFO会将写指针加一。

本模块实际上并不需要判空和判满逻辑，因为读写是严格一一对应的。

FIFO的输出接口直接连接DEC逻辑，将Bank 信息解码成PerBank的预充电命令。

当命令经过延时离开 PreCh_Shift_nACU 模块时，会释放两拍 CK/2 时钟脉冲，第一拍负责将PerBank的预充电命令保存在 DFF中，第二拍负责清除 DFF。这样做的目的有三个，1.由DFF 直接输出，避免毛刺，因为后续模块会将预充电脉冲当成异步信号处理，可能对毛刺敏感，2.尽量快的输出命令，因为在最慢时钟情况下仅有三拍时钟可用，3.将命令缩短为一个 CK/2 的脉冲。

# 4.3 数据接口

本模块的主要输入输出接口如下表 6和表7 所示。


表 6. PreCh_BKinf_Shift_nACU 输入接口


| input | width | from | description |
| --- | --- | --- | --- |
| CK_nACU | 1 | TOP | CK时钟信号 |
| CK_div2_nACU | 1 | TOP | CK的二分频信号 |
| Reset | 1 | TOP | 重置信号 |
| PreCh_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令 |
| PreCh_SC_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令的SC信息 |
| PreCh_AB_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令的AB信息 |
| PreCh_BA0_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令的BK信息 |
| PreCh_BA1_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令的BK信息 |
| PreCh_BG0_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令的BG信息 |
| PreCh_BG1_wo_nACU | 1 | TOP | 来自顶层接口，未经过Shift的PreCh命令的BG信息 |
| PreCh_fifo_out1 | 1 | PreChSHIFT_nACU | 经过shift的PreCh命令 |
| PreCh_fifo_out2 | 1 | PreChSHIFT_nACU | 经过shift的PreCh命令 |
| Shift4_en | 1 | MR_DEC | 用于控制output_shift的周期数 |
| Shift4_mux | 1 | MR_DEC | 用于控制output_shift的周期数 |


表 7. PreCh_BKinf_Shift_nACU 输出接口


| output | width | to | description |
| --- | --- | --- | --- |
| prech_w_nACU[31:0]] | 32 | glue | 经过解码和 shift 的 PerBank 的 PreCh 命令 |

# 4.4 参考波形

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/aafee1947e88b29483f0e9abe812e817c00cbb5b7bb73797ef6c6242f57aa9cc.jpg)



图 9. PreCh_BKinf_Shift_nACU 参考波形


说明：

1. 每一笔 PreCh 命令释放一拍 CK/2 时钟脉冲到写时钟 CK_fifo_in

2. 每一笔写时钟到来，将 bank 信息写入 FIFO，并将写指针加一

3. 每一笔 PreCh 命令经过 PreCh_ Shift_nACU 之后将被再延迟一拍(基于 CK/2)，它们将会释放两拍 CK/2 时钟脉冲到读时钟 CK_fifo_out。此外它们还会根据需要释放 8拍CK时钟，用于最后的 shift。

4. FIFO 的输出直接将 bank 信息解码成 PerBank 的预充电命令

5. 每两拍读时钟的第一拍，将 FIFO输出保存，第二拍再将其清除

# 4.5 dfx 设计

# 4.6 重用分析

# 5 三级模块 MR_Dec 设计

# 5.1 设计框图

本模块为纯组合逻辑模块，暂无设计框图。

本模块需要控制的 gate、switch 和 mux 如下图 10 和下表 4 中序号 1~14 所示。

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/430f525e23ef67535e2c0e92119e0f3188983bd9c52c28b2f273a4420128596b.jpg)



图 10. PreCh_Shift_nACU 中需要被 MR_Dec 控制的单元



表 8. 被 MR_Dec 控制的单元表


| 序号 | 名称 | 序号 | 名称 | 序号 | 名称 |
| --- | --- | --- | --- | --- | --- |
| 1 | T3_en | 6 | Odd_shift_en | 11 | Shift2_mux |
| 2 | Div2_en | 7 | Odd_mux | 12 | Shift4_en |
| 3 | _clk_mux | 8 | Switch00、switch0~7 | 13 | Shift4_mux |
| 4 | Save_edge_en | 9 | Gate0~7 | 14 | Value_for_rst |
| 5 | Shift0_mux | 10 | Shift2_en |  |  |

# 5.2 处理描述

根据 LPDDR6 协议，对不同的 CK 时钟频率下，tACU 的长度换算为 nCK 的数量如下表11和表12所示


Table 11 - nACU 在 DVFSL 关闭的情况下的数量


| Data Rate Lower Limit (Mbps) | Data Rate Upper Limit (Mbps) | Lower Clock Frequency Limit (>) (MHz) | Upper Clock Frequency Limit (<=) (MHz) | nACU [nCK] | Notes |
| --- | --- | --- | --- | --- | --- |
| 80 | 1067 | 20 | 267 | 6 |  |
| 1067 | 1600 | 267 | 400 | 9 |  |
| 1600 | 2133 | 400 | 533 | 12 |  |
| 2133 | 2750 | 533 | 688 | 16 |  |
| 2750 | 3200 | 688 | 800 | 18 |  |
| 3200 | 3750 | 800 | 938 | 21 |  |
| 3750 | 4267 | 938 | 1067 | 24 |  |
| 4267 | 4800 | 1067 | 1200 | 27 |  |
| 4800 | 5500 | 1200 | 1375 | 31 |  |
| 5500 | 6400 | 1375 | 1600 | 36 |  |
| 6400 | 7500 | 1600 | 1875 | 42 |  |
| 7500 | 8533 | 1875 | 2133 | 47 |  |
| 8533 | 9600 | 2133 | 2400 | 53 |  |
| 9600 | 10667 | 2400 | 2667 | 59 |  |
| 10667 | 11733 | 2667 | 2933 | 65 |  |
| 11733 | 12800 | 2933 | 3200 | 71 |  |
| 12800 | 14400 | 3200 | 3600 | 80 |  |

Table 12 - nACU: DVFSL is Enabled

| Data Rate Lower Limit (Mbps) | Data Rate Upper Limit (Mbps) | Lower Clock Frequency Limit (>) (MHz) | Upper Clock Frequency Limit (<=) (MHz) | nACU [nCK] | Notes |
| --- | --- | --- | --- | --- | --- |
| 80 | 1067 | 20 | 267 | 7 |  |
| 1067 | 1600 | 267 | 400 | 11 |  |
| 1600 | 2133 | 400 | 533 | 14 |  |
| 2133 | 2750 | 533 | 688 | 18 |  |
| 2750 | 3200 | 688 | 800 | 21 |  |


相关MR定义如表13和表14所示


Table 13 - MR11 Register Information（MA[6:0]=0B_H


| OP[7] | OP[6] | OP[5] | OP[4] | OP[3] | OP[2] | OP[1] | OP[0] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| WCK2DQ OSC FM | WCK FM | DVFSQ | DVFSL | DVFSB | DVFSH | RFU | RFU |
| DVFSL (VDD2D Dynamic Voltage and Frequency for Low Data Rate) | Write-only | OP[4] | 0B: VDD2D = 0.875V (default); 1B: VDD2D = 0.85V | 0B: VDD2D = 0.875V (default); 1B: VDD2D = 0.85V | 0B: VDD2D = 0.875V (default); 1B: VDD2D = 0.85V | 0B: VDD2D = 0.875V (default); 1B: VDD2D = 0.85V | 1,2,5 |


图 13. MR1OP[4]与 DVFSL 的对应



Table 49 - MR1 Register Information (MA $[ 7 ; 0 ] = 0 1 _ { \mathsf { H } } )$


| OP[7] | OP[6] | OP[5] | OP[4] | OP[3] | OP[2] | OP[1] | OP[0] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Eff Latency | Eff CNTL | WLS | RL/WL/nWTP/nRTP/nACU | RL/WL/nWTP/nRTP/nACU | RL/WL/nWTP/nRTP/nACU | RL/WL/nWTP/nRTP/nACU | RL/WL/nWTP/nRTP/nACU |

| MR1 OP[4:0] | nACU [nCK] |
| --- | --- |
| 00000B (default) | 6 |
| 00001B | 9 |
| 00010B | 12 |
| 00011B | 16 |
| 00100B | 18 |
| 00101B | 21 |
| 00110B | 24 |
| 00111B | 27 |
| 01000B | 31 |
| 01001B | 36 |
| 01010B | 42 |
| 01011B | 47 |
| 01100B | 53 |
| 01101B | 59 |
| 01110B | 65 |
| 01111B | 71 |
| 10000B | 80 |

| MR1 OP[4:0] | nACU [nCK] |
| --- | --- |
| 00000B (default) | 7 |
| 00001B | 11 |
| 00010B | 14 |
| 00011B | 18 |
| 00100B | 21 |

图 14. MR1OP[4:0]与 nACU 数量的对应

结合电路，DEC 对 MR 的解码如下表 5~7。


表 9. 解码表 a


| 模式 | MR | nACU | module_in | module_out | main_shift | 最大分频 | /4 | /2 | /1 main shift odd |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DVFSL Disable | 00000B | 6 | 2 | 4 | 0 | 2 | 0 | 0 | 0eve |
| DVFSL Disable | 00001B | 9 | 2 | 4 | 3 | 2 | 0 | 1 | 1 odd |
| DVFSL Disable | 00010B | 12 | 2 | 4 | 6 | 2 | 0 | 3 | 0 odd |
| DVFSL Disable | 00011B | 16 | 2 | 4 | 10 | 2 | 0 | 5 | 0 odd |
| DVFSL Disable | 00100B | 18 | 2 | 4 | 12 | 2 | 0 | 6 | 0eve |
| DVFSL Disable | 00101B | 21 | 2 | 4 | 15 | 2 | 0 | 7 | 1 odd |
| DVFSL Disable | 00110B | 24 | 2 | 4 | 18 | 2 | 0 | 9 | 0 odd |
| DVFSL Disable | 00111B | 27 | 2 | 4 | 21 | 2 | 0 | 10 | 1eve |
| DVFSL Disable | 01000B | 31 | 2 | 4 | 25 | 2 | 0 | 12 | 1eve |
| DVFSL Disable | 01001B | 36 | 2 | 4 | 30 | 2 | 0 | 15 | 0 odd |
| DVFSL Disable | 01010B | 42 | 6 | 4 | 32 | 4 | 8 | 0 | 0eve |
| DVFSL Disable | 01011B | 47 | 6 | 4 | 37 | 4 | 9 | 0 | 1 odd |
| DVFSL Disable | 01100B | 53 | 6 | 4 | 43 | 4 | 10 | 1 | 1eve |
| DVFSL Disable | 01101B | 59 | 6 | 4 | 49 | 4 | 12 | 0 | 1eve |
| DVFSL Disable | 01110B | 65 | 6 | 4 | 55 | 4 | 13 | 1 | 1 odd |
| DVFSL Disable | 01111B | 71 | 6 | 4 | 61 | 4 | 15 | 0 | 1 odd |
| DVFSL Disable | 10000B | 80 | 6 | 4 | 70 | 4 | 17 | 1 | 0 odd |


表 10. 解码表 b


| MR | nACU | module in | module out | main shift | 最大分频 | /4 | /2 | /1 | main shift odd |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 00000B |  |  |  |  |  |  |  |  |  |
| 00001B |  |  |  |  |  |  |  |  |  |
| 00010B |  |  |  |  |  |  |  |  |  |
| 00011B |  |  |  |  |  |  |  |  |  |
| 00100B |  |  |  |  |  |  |  |  |  |
| 00101B |  |  |  |  |  |  |  |  |  |
| 00110B |  |  |  |  |  |  |  |  |  |
| 00111B |  |  |  |  |  |  |  |  |  |
| 01000B |  |  |  |  |  |  |  |  |  |
| 01001B |  |  |  |  |  |  |  |  |  |
| 01010B | 42 | 8 | 4 | 30 | 4 | 7 | 1 | 0 | odd |
| 01011B | 47 | 8 | 4 | 35 | 4 | 8 | 1 | 1 | eve |
| 01100B | 53 | 8 | 4 | 41 | 4 | 10 | 0 | 1 | eve |
| 01101B | 59 | 8 | 4 | 47 | 4 | 11 | 1 | 1 | odd |
| 01110B | 65 | 8 | 4 | 53 | 4 | 13 | 0 | 1 | odd |
| 01111B | 71 | 8 | 4 | 59 | 4 | 14 | 1 | 1 | eve |
| 10000B | 80 | 8 | 4 | 68 | 4 | 17 | 0 | 0 | odd |


表 11. 解码表 c


| 模式 | MR | nACU | module in | module_out | main shift | 最大分频 | /4 | /2 | /1 | main shift odd |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DVFSL Enable | 00000B | 7 | 2 | 4 | 1 | 2 | 0 | 0 | 1 | eve |
| DVFSL Enable | 00001B | 11 | 2 | 4 | 5 | 2 | 0 | 2 | 1 | eve |
| DVFSL Enable | 00010B | 14 | 2 | 4 | 8 | 2 | 0 | 4 | 0 | eve |
| DVFSL Enable | 00011B | 18 | 2 | 4 | 12 | 2 | 0 | 6 | 0 | eve |
| DVFSL Enable | 00100B | 21 | 2 | 4 | 15 | 2 | 0 | 7 | 1 | odd |
| DVFSL Enable | 00101B | 24 | 2 | 4 | 18 | 2 | 0 | 9 | 0 | odd |
| DVFSL Enable | 00110B | 27 | 2 | 4 | 21 | 2 | 0 | 10 | 1 | eve |
| DVFSL Enable | 00111B | 31 | 2 | 4 | 25 | 2 | 0 | 12 | 1 | eve |
| DVFSL Enable | 01000B | 35 | 2 | 4 | 29 | 2 | 0 | 14 | 1 | eve |
| DVFSL Enable | 01001B | 41 | 2 | 4 | 35 | 2 | 0 | 17 | 1 | odd |
| DVFSL Enable | 01010B | 48 | 6 | 4 | 38 | 4 | 9 | 1 | 0 | odd |
| DVFSL Enable | 01011B | 54 | 6 | 4 | 44 | 4 | 11 | 0 | 0 | odd |
| DVFSL Enable | 01100B | 61 | 6 | 4 | 51 | 4 | 12 | 1 | 1 | eve |
| DVFSL Enable | 01101B | 68 | 6 | 4 | 58 | 4 | 14 | 1 | 0 | eve |
| DVFSL Enable | 01110B | TBD | 6 | 4 | #VALUE! | #VALUE! | #VALUE! | #VALUE! | #VALUE! | #VALUE! |
| DVFSL Enable | 01111B | TBD | 6 | 4 | #VALUE! | #VALUE! | #VALUE! | #VALUE! | #VALUE! | #VALUE! |
| DVFSL Enable | 10000B | TBD | 6 | 4 | #VALUE! | #VALUE! | #VALUE! | #VALUE! | #VALUE! | #VALUE! |

依据上述解码表，电路中受控模块的配置表如下表8。


表 12. 配置表


| MR1OP[4:0] | MROP[5] | edge_flag | div2_en clk_mux | save_edge_en shift0_mux | odd_offset_en | odd_mux | switch00 | switch7~0 gate7~0 | shift2_en shift2_mux | shift4_en shift4_mux | t3_GATE value for rst |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 00000B | OB | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b1 | 8'b0000 0000 | 1'b0 | 1'b0 | 1'b0、4 |
| 00000B | 1B | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b1 | 8'b0000 0000 | 1'b0 | 1'b1 | 1'b0、4 |
| 00001B | OB | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0000 | 1'b0 | 1'b1 | 1'b0、5 |
| 00001B | 1B | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0001 | 1'b0 | 1'b1 | 1'b0、6 |
| 00010B | OB | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0001 | 1'b0 | 1'b0 | 1'b0、7 |
| 00010B | 1B | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0010 | 1'b0 | 1'b0 | 1'b0、8 |
| 00011B | OB | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0010 | 1'b0 | 1'b0 | 1'b0、9 |
| 00011B | 1B | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0100 | 1'b0 | 1'b0 | 1'b0、10 |
| 00100B | OB | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0100 | 1'b0 | 1'b0 | 1'b0、10 |
| 00100B | 1B | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0100 | 1'b0 | 1'b1 | 1'b0、11 |
| 00101B | OB | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0100 | 1'b0 | 1'b1 | 1'b0、11 |
| 00110B | OB | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 1000 | 1'b0 | 1'b0 | 1'b0、13 |
| 00111B | OB | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b0 | 8'b0001 0000 | 1'b0 | 1'b1 | 1'b0、14 |
| 01000B | OB | OB | 2'b00 | 2'b00 | 1'b0 | 1'b0 | 1'b0 | 8'b0010 0000 | 1'b0 | 1'b1 | 1'b0、16 |
| 01001B | OB | OB | 2'b00 | 2'b00 | 1'b1 | 1'b1 | 1'b0 | 8'b0100 0000 | 1'b0 | 1'b0 | 1'b0、19 |
| 01010B | OB | OB | 2'b11 | 2'b11 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 1000 | 1'b0 | 1'b0 | 1'b1、10 |
| 01010B | OB | 1B | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0000 | 1'b1 | 1'b0 | 1'b1、9 |
| 01011B | OB | OB | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 1000 | 1'b0 | 1'b1 | 1'b1、11 |
| 01011B | OB | 1B | 2'b11 | 2'b11 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0000 | 1'b1 | 1'b1 | 1'b1、10 |
| 01100B | OB | OB | 2'b11 | 2'b11 | 1'b0 | 1'b0 | 1'b0 | 8'b0001 0000 | 1'b1 | 1'b1 | 1'b1、12 |
| 01100B | OB | 1B | 2'b11 | 2'b11 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0000 | 1'b0 | 1'b1 | 1'b1、12 |
| 01101B | OB | OB | 2'b11 | 2'b11 | 1'b0 | 1'b0 | 1'b0 | 8'b0010 0000 | 1'b0 | 1'b1 | 1'b1、14 |
| 01101B | OB | 1B | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0000 | 1'b1 | 1'b1 | 1'b1、13 |
| 01110B | OB | OB | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0010 0000 | 1'b1 | 1'b1 | 1'b1、15 |
| 01110B | OB | 1B | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0000 | 1'b0 | 1'b1 | 1'b1、15 |
| 01111B | OB | OB | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0100 0000 | 1'b0 | 1'b1 | 1'b1、17 |
| 01111B | OB | 1B | 2'b11 | 2'b11 | 1'b0 | 1'b0 | 1'b0 | 8'b0000 0000 | 1'b1 | 1'b1 | 1'b1、16 |
| 10000B | OB | OB | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b1000 0000 | 1'b1 | 1'b0 | 1'b1、19 |
| 10000B | OB | 1B | 2'b11 | 2'b11 | 1'b1 | 1'b1 | 1'b0 | 8'b0000 0000 | 1'b0 | 1'b0 | 1'b1、19 |

# 5.3 数据接口

本模块的主要输入输出接口如下表 13 和表 14 所示。


表 13. MR_Dec 输入接口


| input | width | from | description |
| --- | --- | --- | --- |
| MR1_OP[4:0] | 5 | TOP | MR1 寄存器的低五位数据，用于控制 nACU 的时钟周期数 |
| MR11_OP[4] | 1 | TOP | MR11 寄存器的第五位数据，会影响 nACU 的时钟周期数 |
| edge_flag | 1 | TOP | 奇偶相位差标志位 |
| PracEn | 1 | TOP | Prac 功能启动指示信号，不启动 Prac 功能，关闭 nACU_shift |
| EcsEnWin | 1 | TOP | 指示正在进行 ECS，旧版本中会将 nACU 锁定为 9，新版本已经废弃 |


表 14. MR_Dec 输出接口


| output | width | to | description |
| --- | --- | --- | --- |
| T3_en | 1 | PreChSHIFT_nACU | 用于控制input_shift中的第三个DFF是否启用,仅在高速时启用 |
| Div2_en | 1 | PreChShift_nACU | 用于控制是否启动内部分频器,仅在高速时启用 |
| _clk_mux | 1 | PreChShift_nACU | 用于选择main SHIFT中DFF使用的时钟 |
| Save_edge_en | 1 | PreChShift_nACU | 用于控制是否启动save_edge_dff,仅在高速时启用 |
| Shift0_mux | 1 | PreChShift_nACU | 用于控制main shift的输入选择 |
| Oddshift_en | 1 | PreChShift_nACU | 用于控制main shift的周期数 |
| Odd_mux | 1 | PreChShift_nACU | 用于控制main shift的周期数 |
| Switch00 | 1 | PreChShift_nACU | 用于控制main shift的周期数 |
| Switch0_7[7:0] | 8 | PreChShift_nACU | 用于控制main shift的周期数 |
| Gate0_7[7:0] | 8 | PreChShift_nACU | 用于控制main shift的周期数 |
| Shift2_en | 1 | PreChShift_nACU | 用于控制output shift的周期数 |
| Shift2_mux | 1 | PreChShift_nACU | 用于控制output shift的周期数 |
| Value_for_rst[4:0] | 5 | PreChShift_nACU | 用于控制clk_en_cnt的初始化值 |
| Shift4_en | 1 | PreCh_BKinf Shift nACU | 用于控制output shift的周期数 |
| Shift4_mux | 1 | PreCh_BKinf Shift nACU | 用于控制output shift的周期数 |

# 5.4 dfx 设计

# 5.5 重用分析

# 6 三级模块 Glue 设计

# 6.1 设计框图

本模块实际上是一个“或”逻辑。

# 6.2 处理描述

本模块负责将 PreCh_Shift_nACU、WrAp_Shift_nACU、RdAp_Shift_nACU 三种不同命令shift模块产生的时钟 EN 信号以及PerBank信号进行合并(OR)，最终输出，如下图15

![image](https://cdn-mineru.openxlab.org.cn/result/2026-03-26/93a8a6b3-1872-4099-84f7-7a48b74becbd/f7a11975649399a9ebe62af8b088eeae16a7d6a0f75e01d72419d078faf270e3.jpg)



图 15. 定制电路中的 glue逻辑


# 6.3 数据接口

本模块的主要输入输出接口如下表 15 和表 16 所示。


表 15. GLUE 输入接口


| input | width | from | description |
| --- | --- | --- | --- |
| PreCh_clk_en | 1 | PreChSHIFT_nACU | PreCh命令需要进行Shift，因此请求时钟启动 |
| prech_w_nACU[31:0]] | 32 | PreCh_BKinfSHIFT_nACU | 经过解码和shift的PerBank的PreCh命令 |
| WrAp_clk_en | 1 | WrApShift_nACU | WrAp命令需要进行Shift，因此请求时钟启动 |
| WrAp_w_nACU[31:0]] | 32 | WrAp_BKinfShift_nACU | 经过解码和shift的PerBank的WrAp命令 |
| RdAp_clk_en | 1 | RdApShift_nACU | RdAp命令需要进行Shift，因此请求时钟启动 |
| RdAp_w_nACU[31:0]] | 32 | RdAp_BKinfShift_nACU | 经过解码和shift的PerBank的RdAp命令 |


表 16. GLUE 输出接口


| output | width | to | description |
| --- | --- | --- | --- |
| CK_En_nACU | 1 | TOP | PreCh或WrAp或RdAp命令需要进行Shift,因此请求时钟启动 |
| PreCh_SC0_BG0_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC0_BG1_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC0_BG2_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC0_BG3_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC1_BG0_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC1_BG1_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC1_BG2_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |
| PreCh_SC1_BG3_Bnk_w_nACU[3:0] | 4 | TOP | 经过解码和shift以及合并(PreCh、WrAp的PreCh、RdAp的PreCh)的PerBank的PreCh命令 |

# 6.4 dfx 设计

# 6.5 重用分析

# 附录

术语和缩写

寄存器手册

使用指南
