---
name: rtl-code-generator
description: Expert skill for generating Verilog RTL code from design specifications and requirements. Use when creating digital circuit designs, implementing RTL modules from specifications, generating hardware description language (HDL) code, or when asked to design digital circuits, finite state machines, or hardware components. This skill specializes in producing 1 implementation with functional verification and proper handling of undefined states (1'bx).
---

# Digital Circuit RTL Code Generator

## Overview

Expert tool for generating Verilog RTL code from design specifications and requirements. This skill produces 1 implementation for each design, ensuring functional correctness while handling edge cases like undefined states properly.

## Quick Start

To generate RTL code from design requirements:

1. **Provide Design Requirements** - Include detailed specifications, truth tables, state diagrams, or input-output relationships
2. **Provide Header Modules** - Include module definitions with port declarations
3. **Follow Generation Rules** - The system generates 1 RTL following strict verification rules

Example user request format:
```
Please generate the verilog RTL code according to the following design requirements and RTL header modules:

Design requirements:
{detailed design specifications}

RTL header modules:
{module definitions with ports}
```

## Core Generation Rules

### 1. Multiple Implementation Generation
- Always generate 1 RTL implementations simultaneously

### 2. Logic Extraction from Examples
- When design requirements include examples or data lists:
  1. Analyze the provided examples/data to infer underlying logic patterns
  2. Design code based on extracted logical relationships
  3. Test implementations with provided examples to verify correctness
  4. Summarize overall logic before writing RTL

### 3. Handling Undefined States
- Set output values to `1'bx` when design requirements specify arbitrary/undefined behavior
- Apply `1'bx` for invalid states, undefined conditions, or unspecified outputs
- Use proper Verilog syntax for unknown values: `1'bx` for single-bit, `'bx` for multi-bit

### 4. Verification Process
For each RTL implementation:
1. **Logical Analysis** - Ensure code matches design requirements
2. **Example Testing** - Test with provided examples/data lists
3. **Edge Case Handling** - Verify undefined state handling
4. **Syntactic Validation** - Check for valid Verilog syntax

### 5. Output Format Requirements
- Return a JSON object with key "RTL"
- "RTL" should be a list containing 1 RTL implementations
- Each implementation must be complete, syntactically correct Verilog code
- Output only the JSON object with no additional content

## RTL Design Patterns

### Combinational Logic Patterns
- **Boolean expressions**: Direct logic equations
- **Case statements**: Multiway selection for complex combinational logic
- **If-else chains**: Priority-based logic
- **Conditional assignments**: `assign` with `?:` operator

### Sequential Logic Patterns
- **Synchronous logic**: Clocked `always @(posedge clk)` blocks
- **Asynchronous resets**: `always @(posedge clk or posedge reset)`
- **State machines**: `case` within synchronous blocks for FSM implementation
- **Registered outputs**: Pipeline registers for timing optimization

### Code Structure Templates
```verilog
// Template 1: Standard synchronous design
module module_name (
    input clk,
    input reset,
    input [N:0] data_in,
    output reg [M:0] data_out
);
    // Internal signals
    reg [K:0] state_reg, state_next;
    
    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= 'b0;
            data_out <= 'b0;
        end else begin
            state_reg <= state_next;
            data_out <= next_out;
        end
    end
    
    // Combinational logic
    always @(*) begin
        // Default assignments
        state_next = state_reg;
        next_out = data_out;
        
        // Implementation logic here
        // ...
    end
endmodule

// Template 2: Pipeline design
module pipeline_module (
    input clk,
    input reset,
    input [N:0] stage1_in,
    output reg [M:0] stage3_out
);
    // Pipeline registers
    reg [N:0] stage1_reg, stage2_reg;
    reg [M:0] stage2_logic, stage3_logic;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_reg <= 'b0;
            stage2_reg <= 'b0;
            stage3_out <= 'b0;
        end else begin
            stage1_reg <= stage1_in;
            stage2_reg <= stage2_logic;
            stage3_out <= stage3_logic;
        end
    end
    
    // Pipeline stage logic
    always @(*) begin
        // Stage 2 logic
        stage2_logic = f(stage1_reg);
        
        // Stage 3 logic  
        stage3_logic = g(stage2_reg);
    end
endmodule
```

## Common Digital Circuit Implementations

### Finite State Machines (FSM)
- **Moore vs Mealy** - Choose based on requirements
- **One-hot encoding** - For simple FSMs
- **Binary encoding** - For complex FSMs with many states
- **Gray coding** - For reduced glitch power consumption

### Arithmetic Circuits
- **Adders**: Ripple-carry, carry-lookahead, carry-select
- **Multipliers**: Array, Wallace tree, Booth encoding
- **Counters**: Binary, Gray code, Johnson, ring

### Memory and Registers
- **Shift registers**: Serial-in serial-out, parallel-in parallel-out
- **FIFOs**: Synchronous, asynchronous
- **Register files**: Multi-port designs

### Data Path Components
- **Multiplexers**: 2:1, 4:1, 8:1 using `case` or conditional assignment
- **Decoders**: Binary to one-hot, 7-segment
- **Encoders**: Priority encoders

## Verification Guidelines

### Input Validation
- Verify all inputs specified in header modules are used
- Check for unused inputs (potential bugs)
- Validate port widths match requirements

### Functional Testing
- Test with provided examples from requirements
- Test edge cases and boundary conditions
- Verify reset behavior
- Test state transitions for FSMs

### Synthesis Considerations
- Avoid latches (use default assignments in combinational blocks)
- Use non-blocking assignments (`<=`) in sequential logic
- Use blocking assignments (`=`) in combinational logic
- Register critical paths for timing closure

## Resources

### scripts/
Contains Python utilities for RTL validation and verification:
- `verify_rtl.py`: Validates generated RTL against design requirements
- `syntax_check.py`: Checks Verilog syntax and coding standards
- `pattern_generator.py`: Generates common RTL design patterns

### references/
Contains reference materials for RTL design:
- `code_style_simple`: Verilog coding style and quick reference for RTL design
- `verilog_quick_reference.md`: Quick syntax reference for Verilog
- `rtl_design_patterns.md`: Detailed design patterns and examples
- `fsm_design.md`: Finite state machine design techniques
- `verification_methods.md`: RTL verification methodologies

### assets/
Contains Verilog templates and examples:
- `templates/basic_module.v`: Basic Verilog module template
- `templates/fsm_template.v`: FSM implementation template
- `templates/pipeline_template.v`: Pipeline design template
- `examples/adder.v`: Various adder implementations
- `examples/multiplier.v`: Multiplier implementations
