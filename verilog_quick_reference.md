# Verilog HDL Quick Reference

## Module Declaration
```verilog
module module_name (
    // Inputs
    input wire clk,
    input wire reset_n,  // Active-low reset
    input wire [7:0] data_in,
    
    // Outputs  
    output reg [3:0] data_out,
    output wire ready
);
```

## Data Types
- **wire** - For continuous assignments and connections
- **reg** - For storage elements (does not imply hardware register)
- **integer** - 32-bit signed integer
- **parameter** - Constant value, can be overridden
- **localparam** - Constant value, cannot be overridden

## Bit Width Notation
```verilog
wire [7:0] byte_data;      // 8-bit wire, MSB index 7
reg [0:7] reverse_byte;    // 8-bit reg, LSB index 0
wire [15:0] word_data;     // 16-bit wire
reg signed [31:0] int_data; // 32-bit signed register
```

## Operators

### Arithmetic Operators
- `+` (addition), `-` (subtraction)
- `*` (multiplication), `/` (division)
- `%` (modulus), `**` (power)

### Bitwise Operators
- `~` (bitwise NOT)
- `&` (bitwise AND), `|` (bitwise OR), `^` (bitwise XOR)
- `~&` (NAND), `~|` (NOR), `~^` or `^~` (XNOR)

### Logical Operators
- `!` (logical NOT)
- `&&` (logical AND), `||` (logical OR)

### Relational Operators
- `>` (greater than), `<` (less than)
- `>=` (greater or equal), `<=` (less or equal)
- `==` (logical equality), `!=` (logical inequality)
- `===` (case equality), `!==` (case inequality)

### Shift Operators
- `<<` (logical left shift)
- `>>` (logical right shift)
- `<<<` (arithmetic left shift)
- `>>>` (arithmetic right shift)

### Concatenation & Replication
```verilog
{4'b1010, 4'b1100}  // 8-bit concatenation: 8'b10101100
{4{2'b01}}           // 8-bit replication: 8'b01010101
```

## Assignment Types

### Continuous Assignment (wire)
```verilog
assign wire_out = sel ? a : b;
assign {carry, sum} = a + b + cin;
```

### Procedural Assignment (reg)
**Blocking (=)** - Execute in order, for combinational logic:
```verilog
always @(*) begin
    a = b;
    b = a;  // b gets old value of a
end
```

**Non-blocking (<=)** - Execute concurrently, for sequential logic:
```verilog
always @(posedge clk) begin
    a <= b;
    b <= a;  // Both get old values
end
```

## Always Blocks

### Combinational Logic
```verilog
always @(*) begin
    // All inputs in sensitivity list
    // Use blocking assignments (=)
    out = in1 & in2;
end
```

### Clocked Sequential Logic
```verilog
always @(posedge clk) begin
    // Positive edge triggered
    // Use non-blocking assignments (<=)
    q <= d;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 0;
    end else begin
        q <= d;
    end
end
```

### Asynchronous Reset
```verilog
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 0;
    end else begin
        q <= d;
    end
end
```

## Control Statements

### If-Else
```verilog
if (condition1) begin
    // Code block 1
end else if (condition2) begin
    // Code block 2
end else begin
    // Default block
end
```

### Case Statement
```verilog
case (state)
    2'b00: next_state = 2'b01;
    2'b01: next_state = 2'b10;
    2'b10: next_state = 2'b11;
    2'b11: next_state = 2'b00;
    default: next_state = 2'b00;
endcase
```

### Casez & Casex
```verilog
casez (data)
    8'b1???????: priority = 3'd7;  // Highest bit set
    8'b01??????: priority = 3'd6;
    8'b001?????: priority = 3'd5;
    default:     priority = 3'd0;
endcase
```

## Tasks and Functions

### Functions (combinational, return single value)
```verilog
function [7:0] adder;
    input [7:0] a, b;
    begin
        adder = a + b;
    end
endfunction
```

### Tasks (can have timing, multiple outputs)
```verilog
task check_result;
    input [7:0] expected;
    input [7:0] actual;
    output error;
    begin
        error = (expected !== actual);
    end
endtask
```

## Common Constructs

### Parameterized Modules
```verilog
module adder #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a, b,
    output [WIDTH-1:0] sum
);
    assign sum = a + b;
endmodule
```

### Generate Statements
```verilog
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : bit_slice
        assign out[i] = in[i] & enable[i];
    end
endgenerate
```

### Initial Block (for simulation only)
```verilog
initial begin
    clk = 0;
    reset = 1;
    #10 reset = 0;
    #100 $finish;
end
```

## Coding Guidelines

### Good Practices
1. Use meaningful signal names
2. Comment complex logic
3. Use parameters for configurable designs
4. Register outputs for better timing
5. Use `default` in case statements

### Common Pitfalls
1. **Incomplete sensitivity lists** - Use `always @(*)` for combinational
2. **Latch inference** - Provide all branch assignments in combinational blocks
3. **Blocking in sequential** - Use non-blocking (`<=`) in clocked blocks
4. **Race conditions** - Avoid mixing blocking/non-blocking in same always block
5. **Uninitialized variables** - Initialize registers in reset
