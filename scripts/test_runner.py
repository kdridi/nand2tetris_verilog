#!/usr/bin/env python3
"""
TDD framework for Verilog with automatic dependency resolution
Usage: python3 test_runner.py
"""

import subprocess
import sys
import os
from pathlib import Path
import re
from collections import defaultdict, deque

class DependencyResolver:
    """Resolve Verilog module dependencies"""
    
    def __init__(self, src_dir):
        self.src_dir = Path(src_dir)
        self.module_files = {}  # module_name -> file_path
        self.dependencies = defaultdict(set)  # module -> set of dependencies
        self._scan_modules()
    
    def _remove_comments(self, content):
        """Remove single-line and multi-line comments from Verilog content"""
        # Remove single-line comments (// comment)
        content = re.sub(r'//.*?\n', '\n', content)
        # Remove multi-line comments (/* comment */)
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        return content
    
    def _scan_modules(self):
        """Scan all .v files and build module index"""
        for vfile in self.src_dir.rglob("*.v"):
            with open(vfile, 'r') as f:
                content = f.read()
                
                # Remove comments before parsing
                clean_content = self._remove_comments(content)
                
                # Find module declarations
                module_pattern = r'module\s+(\w+)\s*[\(#]'
                modules = re.findall(module_pattern, clean_content)
                
                for module in modules:
                    self.module_files[module] = vfile
                    
                    # Find instantiations (dependencies)
                    # More precise pattern: module_name instance_name(...) or module_name #(...) instance_name(...)
                    # Must be followed by parentheses and preceded by whitespace/newline
                    inst_pattern = r'(?:^|\s|;)+(\w+)\s+(?:#\([^)]*\)\s+)?(\w+)\s*\('
                    instantiations = re.findall(inst_pattern, clean_content, re.MULTILINE)
                    
                    for inst_module, inst_name in instantiations:
                        # Filter out Verilog keywords, primitives, and common false positives
                        if inst_module not in ['module', 'endmodule', 'input', 'output', 
                                              'wire', 'reg', 'assign', 'always', 'initial',
                                              'begin', 'end', 'if', 'else', 'case', 'default',
                                              'for', 'while', 'repeat', 'forever', 'task', 'function',
                                              'integer', 'real', 'time', 'parameter', 'localparam',
                                              'generate', 'genvar', 'endgenerate', 'posedge', 'negedge']:
                            # Additional validation: instance name should be a valid identifier
                            if re.match(r'^\w+$', inst_name) and inst_module != inst_name:
                                self.dependencies[module].add(inst_module)
    
    def get_dependencies(self, module_name):
        """Get all dependencies for a module (recursive)"""
        visited = set()
        result = []
        
        def dfs(module):
            if module in visited:
                return
            visited.add(module)
            
            # Add dependencies first (depth-first)
            if module in self.dependencies:
                for dep in self.dependencies[module]:
                    if dep in self.module_files:  # Only if we have the file
                        dfs(dep)
            
            # Then add the module itself
            if module in self.module_files:
                result.append(self.module_files[module])
        
        dfs(module_name)
        return result
    
    def get_all_sources_for_test(self, test_file):
        """Get all source files needed for a testbench"""
        with open(test_file, 'r') as f:
            content = f.read()
        
        # Remove comments before parsing
        clean_content = self._remove_comments(content)
        
        # Find all module instantiations in the testbench
        inst_pattern = r'(?:^|\s|;)+(\w+)\s+(?:#\([^)]*\)\s+)?(\w+)\s*\('
        instantiations = re.findall(inst_pattern, clean_content, re.MULTILINE)
        
        all_sources = []
        seen = set()
        
        for module, inst_name in instantiations:
            # Filter out keywords and validate
            if (module not in ['module', 'endmodule', 'input', 'output', 
                              'wire', 'reg', 'assign', 'always', 'initial', 'task', 'function'] and
                re.match(r'^\w+$', inst_name) and module != inst_name):
                deps = self.get_dependencies(module)
                for dep in deps:
                    if dep not in seen:
                        all_sources.append(dep)
                        seen.add(dep)
        
        return all_sources

class VerilogTest:
    def __init__(self, verbose=False):
        self.passed = 0
        self.failed = 0
        self.verbose = verbose
        self.resolver = DependencyResolver("src")
        
    def compile_and_run(self, sources, testbench):
        """Compile and run a Verilog testbench"""
        # Create temp directory
        os.makedirs("temp", exist_ok=True)
        
        # Build compile command
        source_files = ' '.join(str(s) for s in sources)
        cmd = f"iverilog -o temp/test {source_files} {testbench}"
        
        if self.verbose:
            print(f"  Compiling: {cmd}")
        
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        
        if result.returncode != 0:
            return False, f"Compilation error:\n{result.stderr}"
        
        # Run simulation
        cmd = "vvp temp/test"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        
        # Check for FAIL in output
        if "FAIL" in result.stdout or "ERROR" in result.stdout.upper():
            return False, result.stdout
        
        # Check for assertion failures
        if "Assertion failed" in result.stdout:
            return False, result.stdout
            
        return True, result.stdout
    
    def run_single_test(self, testbench_path):
        """Run a single test with all its dependencies"""
        tb = Path(testbench_path)
        
        # Get all required source files
        sources = self.resolver.get_all_sources_for_test(tb)
        
        if not sources:
            # Try to find the main module based on naming convention
            module_name = tb.stem.replace("_tb", "")
            sources = self.resolver.get_dependencies(module_name)
            
            if not sources:
                return False, f"No source files found for {tb.name}"
        
        if self.verbose:
            print(f"  Dependencies: {[s.name for s in sources]}")
        
        # Run test
        return self.compile_and_run(sources, str(tb))
    
    def run_all_tests(self):
        """Run all tests in test/ directory"""
        test_dir = Path("tests")
        
        if not test_dir.exists():
            print("Error: 'tests' directory not found")
            return 1
        
        # Find all testbenches
        testbenches = sorted(list(test_dir.rglob("*_tb.v")))
        
        if not testbenches:
            print("No test files found (*_tb.v)")
            return 1
        
        print("Running Verilog TDD Tests")
        print("=" * 40)
        
        for tb in testbenches:
            success, output = self.run_single_test(tb)
            
            if success:
                print(f"✓ {tb.name}")
                self.passed += 1
                if self.verbose and output.strip():
                    print(f"  Output: {output.strip()}")
            else:
                print(f"✗ {tb.name}")
                self.failed += 1
                # Show error details
                for line in output.split('\n'):
                    if line.strip():
                        print(f"  {line}")
        
        print("=" * 40)
        print(f"Results: {self.passed} passed, {self.failed} failed")
        
        # Show dependency tree if verbose
        if self.verbose and self.resolver.module_files:
            print("\nModule dependency tree:")
            for module, deps in self.resolver.dependencies.items():
                if deps:
                    print(f"  {module} -> {', '.join(deps)}")
        
        return 0 if self.failed == 0 else 1

def generate_test_template(module_name, num_inputs=2, num_outputs=1):
    """Generate a test template for a module"""
    
    # Generate input declarations
    inputs = []
    for i in range(num_inputs):
        if num_inputs <= 3:
            inputs.append(chr(97 + i))  # a, b, c
        else:
            inputs.append(f"in{i}")
    
    # Generate output declarations
    outputs = []
    for i in range(num_outputs):
        if num_outputs == 1:
            outputs.append("y")
        else:
            outputs.append(f"out{i}")
    
    # Build template
    template = f"""module {module_name}_tb;
    // Inputs
"""
    for inp in inputs:
        template += f"    reg {inp};\n"
    
    template += f"""    
    // Outputs
"""
    for out in outputs:
        template += f"    wire {out};\n"
    
    template += f"""
    // Instantiate the Unit Under Test (UUT)
    {module_name} uut (
"""
    
    # Port connections
    ports = []
    for inp in inputs:
        ports.append(f"        .{inp}({inp})")
    for out in outputs:
        ports.append(f"        .{out}({out})")
    template += ",\n".join(ports) + "\n    );\n"
    
    template += f"""
    // Test vectors
    reg [31:0] test_count = 0;
    reg [31:0] error_count = 0;
    
    // Test task
    task run_test;
        input [{len(inputs)-1}:0] test_inputs;
        input [{len(outputs)-1}:0] expected_output;
        input [8*32:1] test_name;
        begin
            // Apply inputs
"""
    
    # Apply inputs in task
    for i, inp in enumerate(inputs):
        template += f"            {inp} = test_inputs[{i}];\n"
    
    template += f"""            #10; // Wait for propagation
            
            // Check output
            if ({outputs[0]} !== expected_output[0]) begin
                $display("FAIL: %s - Expected %b, got %b", test_name, expected_output, {outputs[0]});
                error_count = error_count + 1;
            end
            test_count = test_count + 1;
        end
    endtask
    
    // Test stimulus
    initial begin
        $dumpfile("temp/{module_name}.vcd");
        $dumpvars(0, {module_name}_tb);
        
        // Initialize
        error_count = 0;
        test_count = 0;
        
        // Run tests
        run_test(2'b00, 1'b1, "Test case 1");
        run_test(2'b01, 1'b1, "Test case 2");
        run_test(2'b10, 1'b1, "Test case 3");
        run_test(2'b11, 1'b0, "Test case 4");
        
        // Report results
        if (error_count == 0) begin
            $display("SUCCESS: All %d tests passed!", test_count);
        end else begin
            $display("FAILURE: %d/%d tests failed", error_count, test_count);
        end
        
        $finish;
    end
endmodule
"""
    return template

def print_help():
    """Print usage information"""
    print("""
Verilog TDD Test Runner
=======================

Usage:
    python3 test_runner.py [options] [command]

Commands:
    run              Run all tests (default)
    test <file>      Run a specific test file
    generate <name>  Generate a test template
    deps             Show module dependencies
    help             Show this help

Options:
    -v, --verbose    Show detailed output

Examples:
    python3 test_runner.py                    # Run all tests
    python3 test_runner.py -v                 # Run with verbose output
    python3 test_runner.py test and_gate_tb.v # Run specific test
    python3 test_runner.py generate xor_gate  # Generate template
    python3 test_runner.py deps               # Show dependencies
""")

if __name__ == "__main__":
    args = sys.argv[1:]
    verbose = False
    
    # Check for verbose flag
    if "-v" in args or "--verbose" in args:
        verbose = True
        args = [a for a in args if a not in ["-v", "--verbose"]]
    
    # Parse command
    if not args or args[0] == "run":
        tester = VerilogTest(verbose=verbose)
        sys.exit(tester.run_all_tests())
    
    elif args[0] == "test" and len(args) > 1:
        tester = VerilogTest(verbose=verbose)
        test_file = Path(args[1])
        if not test_file.exists():
            test_file = Path("tests") / args[1]
        
        if test_file.exists():
            success, output = tester.run_single_test(test_file)
            print(output)
            sys.exit(0 if success else 1)
        else:
            print(f"Test file not found: {args[1]}")
            sys.exit(1)
    
    elif args[0] == "generate" and len(args) > 1:
        module = args[1]
        num_inputs = int(args[2]) if len(args) > 2 else 2
        num_outputs = int(args[3]) if len(args) > 3 else 1
        print(generate_test_template(module, num_inputs, num_outputs))
    
    elif args[0] == "deps":
        resolver = DependencyResolver("src")
        print("Module Dependencies:")
        print("=" * 40)
        for module, deps in sorted(resolver.dependencies.items()):
            if deps:
                print(f"{module}:")
                for dep in sorted(deps):
                    file = resolver.module_files.get(dep, "NOT FOUND")
                    print(f"  → {dep} ({file})")
    
    elif args[0] == "help":
        print_help()
    
    else:
        print(f"Unknown command: {args[0] if args else 'none'}")
        print("Use 'python3 test_runner.py help' for usage information")
        sys.exit(1)