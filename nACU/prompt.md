# 3 三级模块 PreCh_Shift_nACU 设计



# 3.1 设计框图



PreCh_Shift_nACU 的模块简图如下图 3 所示。



![image](./fig/设计框图.png)

图 3. PreCh_Shift_nACU 设计框图



PreCh_Shift_nACU 主要由 input_shift、main_shift、output_shift 以及 clk_ctl 四个部分构成，input_shift 负责在高频的情况下记录 prech 的边沿信息。main_shfit 负责对命令进行 shift，它由若干个DFF构成。Output_shift主要有两个功能，负责在高频模式下将可能连续的两笔命令拆分，负责对命令进行精细化 shift，这是由于，main_shift工作在CK/2或者CK/4 的时钟频率下，因此它能够做到的 shift 周期数一定是 CK 的偶数倍，而根据 LPDDR6的协议配置要求，命令的 shift 周期数可能是 CK 的奇数倍，因此额外需要工作在 CK 时钟频率下的shift_dff。Clk_ctl 负责控制时钟的 gate 和 div，负责在不需要时关闭模块的时钟，负责在高速时对 CK/2 时钟进行进一步分频。



本模块中的 clk_gate、switch 和 mux 均由 MR_Dec 控制。



# 3.2 处理描述



本模块的详细结构图如下图 4 所示。



T1_dff、t2_dff、t3_dff 以及 save_edge 功能，共同构成了 input_shift。它们能够在 CK/2的时钟频率下，对输入的命令缓存三拍。它们的主要功能有两个，在高频时钟下，main_shift运行在 CK/4 的时钟频率下，此时需要展宽命令，并保存命令在 CK/2 时钟下的边沿信息，这样才能保住快速时钟域的脉冲能够被低速时钟域采到，此外它们还负责启动本模块的时钟，延迟三拍是由于 clk_ctl架构的限制，防止在某些情况下时钟被误关闭。



Main_shift0~7、odd_even_shfit 以及附带的 switch、mux 共同构成了 main_shift，它们负



责按照配置要求对命令进行 shift，工作在 CK/2 或者 CK/4 的时钟频率下，具体取决于时钟速度，它们的 shift 范围为 0nck~34nck(以 2nck 步进)或者 0nck~68nck(以 4nck 步进)。



Shift1~4 以及附带的 mux 共同构成了 output_shift。在高频时钟域下，main_shift 可能会输出连续的命令，它负责将这些命令拆分(shift1)。此外由于 main_shift 本身不能完整的将命令 shift 协议所要求的 nACU，它负责将命令 shift 剩余的 CK 数量(shift2 和 shift4)。Shfit3 负责对命令进行打拍，这是由于 FIFO 读出时需要两拍 CK/2时钟。



![image](./fig/结构详图.png)

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



![image](./fig/慢时钟波形.png)

图 5. 慢速时钟频率下，工作参考波形图



说明：



1. 命令当拍即启动时钟。



2. 命令花费一拍时间，即进入 main_shift。



3. 令进入 main_shift 的第一拍，重置并启动 clk_en_cnt。



4. clk_en_cnt 结束触发关闭时钟



5. 框中波形图展示的是，在即将关闭时钟时，收到一笔新的命令可能会导致时钟误关闭，这是由于从收到命令到启动 clk_en_cnt需要花费两拍时间，因此需要将输入命令延迟一拍来保持时钟的启动。



本模块工作在快速时钟频率下，其启动和结束波形如下图 6 和图7所示。



![image](./fig/快时钟启动波形.png)

图 6. 快速时钟频率下，启动参考波形图



说明：



1. 命令花费一拍被采到，并记录边沿信息。



2. 命令花费两拍被采用，并记录边沿信息。



# 3. Main_shift 和 clk_en_cnt 工作在 CK/4 的时钟速度下



![image](./fig/快时钟结束波形.png)

图 7. 快速时钟频率下，结束参考波形图



框中波形图展示的是，在即将关闭时钟时，收到一笔新的命令可能会导致时钟误关闭，这是由于从收到命令到启动 clk_en_cnt 需要花费三拍(CK/2)时间，因此需要将输入命令延迟两拍(CK/2)来保持时钟的启动。



我帮助你提取了三级模块PreCh_Shift_nACU的设计描述，框图与时序图，对这一模块的设计仔细分析。

包括一下内容的分析：

1. main shift时钟的启动：应该通过t1，t2，t3以及cnt end的下降沿检测，通过组合逻辑（如果开启和关断同时有效，优先保持开启）然后接上触发器，然后该输出与PreCh相或作为main shift时钟门控的控制信号

2. save edge存储边沿信息：这部分结构图中没有描述清楚，由我为你讲解。{t1,t2}拼接后通过save edge触发器，如果检测到10信号转换为2’b11，如果检测到01信号转换为2‘b10，其中高位用来控制clk en cnt的置位，低位相当于MR DEC部分的edge flag，MR DEC的edge flag并不作为这个模块的输入，因此需要在这个模块内根据edge flag信号当即改变配置信息，比如shift2 en和mux（对MR DEC输入的配置信息进行修改）。然后这个转换后的信号两bits信号会一起进入后面的main shift。

这里的逻辑在于，如果是{t1,t2}为10时候被CK/4的上升沿检测到，说明在input shift里面少打了2拍，MR DEC输入的信息需要被修改（这部分修改组合逻辑暂未确定，写一个模块、空置）

3. main shift中的switch需要从左到右将信号移位，这里移位是对通过mux对shift0_sc两比特信号同时移位，注意输入switch0-7和gate0-7应该是0010000这种编码，需要变成温度计编码赋值给真正的switch和gate。

4.clk en cnt计数，通过shift0_sc和value for rst进行置数。

5.输出部分shift1在CK/2频率下打拍，CK/4频率下通过将输出反接如输出的mux来拆开连续命令；shift2 mux后得到输出

6.clock gating用下面代码实例化

// 基础时钟门控单元 (由用户提供)

module clk_gate(

    input  wire     clk_in,

    input  wire     en,

    output wire     clk_gated

);

    reg en_latch;

    always @(*) begin 

        if (!clk_in) begin

            en_latch = en;

        end

    end

    assign clk_gated = en_latch & clk_in;

endmodule

请你进行详细的分析，然后用模块化的设计思路对这个复杂的三级模块进行模块拆分和端口设计，先不进行模块内部设计
