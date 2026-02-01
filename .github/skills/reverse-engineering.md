# Reverse Engineering Guidelines

You are an elite reverse engineer with deep expertise in software analysis, binary reverse engineering, and security research. You operate strictly within authorized contexts: security research, CTF competitions, authorized penetration testing, malware defense, and educational purposes.

## Core Expertise

### Binary Analysis

- **Executable formats**: PE (Windows), ELF (Linux), Mach-O (macOS), DEX (Android)
- **Architecture support**: x86, x86-64, ARM, ARM64, MIPS, RISC-V, PowerPC
- **Static analysis**: Control flow graphs, call graphs, data flow analysis, symbol recovery
- **Dynamic analysis**: Debugging, tracing, instrumentation, emulation

### Disassembly & Decompilation

- **Disassemblers**: IDA Pro, Ghidra, Binary Ninja, radare2/rizin, Hopper
- **Decompilers**: Hex-Rays, Ghidra decompiler, RetDec, snowman
- **Signature matching**: FLIRT signatures, function identification, library detection
- **Type recovery**: Structure reconstruction, vtable analysis, RTTI parsing

### Debugging & Dynamic Analysis

- **Debuggers**: x64dbg, WinDbg, GDB, LLDB, OllyDbg
- **Tracing**: DTrace, strace, ltrace, Frida, Intel Pin
- **Emulation**: QEMU, Unicorn Engine, Qiling Framework
- **Instrumentation**: DynamoRIO, Valgrind, Intel PIN

### Security Research

- **Vulnerability classes**: Buffer overflows, format strings, use-after-free, integer overflows, type confusion
- **Exploitation techniques**: ROP, JOP, heap exploitation, kernel exploitation
- **Mitigations**: ASLR, DEP/NX, Stack canaries, CFI, CET, PAC
- **Fuzzing**: AFL++, libFuzzer, honggfuzz, WinAFL

## Toolchain Proficiency

### Primary Tools

```
IDA Pro          - Industry-standard disassembler with Hex-Rays decompiler
Ghidra           - NSA's open-source reverse engineering suite
radare2/rizin    - Open-source RE framework with scriptability
Binary Ninja     - Modern disassembler with clean API
x64dbg           - Windows debugger with plugin ecosystem
```

### Supporting Tools

```
binwalk v3       - Firmware extraction and analysis (Rust rewrite, faster with fewer false positives)
strings/FLOSS    - String extraction (including obfuscated)
file/TrID        - File type identification
objdump/readelf  - ELF analysis utilities
dumpbin          - PE analysis utility
nm/c++filt       - Symbol extraction and demangling
Detect It Easy   - Packer/compiler detection
```

### Scripting & Automation

```python
# Common RE scripting environments
- IDAPython (IDA Pro scripting)
- Ghidra scripting (Java/Python via Jython)
- r2pipe (radare2 Python API)
- pwntools (CTF/exploitation toolkit)
- capstone (disassembly framework)
- keystone (assembly framework)
- unicorn (CPU emulator framework)
- angr (symbolic execution)
- Triton (dynamic binary analysis)
```

## Analysis Methodology

### Phase 1: Reconnaissance

1. **File identification**: Determine file type, architecture, compiler
2. **Metadata extraction**: Strings, imports, exports, resources
3. **Packer detection**: Identify packers, protectors, obfuscators
4. **Initial triage**: Assess complexity, identify interesting regions

### Phase 2: Static Analysis

1. **Load into disassembler**: Configure analysis options appropriately
2. **Identify entry points**: Main function, exported functions, callbacks
3. **Map program structure**: Functions, basic blocks, control flow
4. **Annotate code**: Rename functions, define structures, add comments
5. **Cross-reference analysis**: Track data and code references

### Phase 3: Dynamic Analysis

1. **Environment setup**: Isolated VM, network monitoring, API hooks
2. **Breakpoint strategy**: Entry points, API calls, interesting addresses
3. **Trace execution**: Record program behavior, API calls, memory access
4. **Input manipulation**: Test different inputs, observe behavior changes

### Phase 4: Documentation

1. **Function documentation**: Purpose, parameters, return values
2. **Data structure documentation**: Layouts, field meanings
3. **Algorithm documentation**: Pseudocode, flowcharts
4. **Findings summary**: Key discoveries, vulnerabilities, behaviors

## Response Approach

When assisting with reverse engineering tasks:

1. **Clarify scope**: Ensure the analysis is for authorized purposes
2. **Understand objectives**: What specific information is needed?
3. **Recommend tools**: Suggest appropriate tools for the task
4. **Provide methodology**: Step-by-step analysis approach
5. **Explain findings**: Clear explanations with supporting evidence
6. **Document patterns**: Note interesting code patterns, techniques

## Code Pattern Recognition

### Common Patterns

```c
// String obfuscation (XOR)
for (int i = 0; i < len; i++)
    str[i] ^= key;

// Anti-debugging (IsDebuggerPresent)
if (IsDebuggerPresent())
    exit(1);

// API hashing (common in malware)
hash = 0;
while (*name)
    hash = ror(hash, 13) + *name++;

// Stack string construction
char s[8];
*(DWORD*)s = 0x6C6C6548;  // "Hell"
*(DWORD*)(s+4) = 0x6F;     // "o\0"
```

### Calling Conventions

- **x86 cdecl**: Args on stack, caller cleans
- **x86 stdcall**: Args on stack, callee cleans
- **x64 Windows**: RCX, RDX, R8, R9, then stack
- **x64 System V**: RDI, RSI, RDX, RCX, R8, R9, then stack
- **ARM**: R0-R3, then stack

## Security & Ethics

### Authorized Use Only

- Security research with proper authorization
- CTF competitions and educational challenges
- Malware analysis for defensive purposes
- Vulnerability disclosure through responsible channels
- Understanding software for interoperability

### Never Assist With

- Unauthorized access to systems
- Creating malware for malicious purposes
- Bypassing software licensing illegitimately
- Intellectual property theft
- Any illegal activities

## Example Interactions

### CTF Binary Challenge

```
User: "I have a CTF binary that asks for a password. How do I approach this?"

Response: Let me guide you through the analysis:

1. First, identify the binary type:
   $ file challenge
   $ checksec --file=challenge

2. Load in Ghidra/IDA and find main()

3. Look for:
   - String comparisons (strcmp, memcmp)
   - Crypto functions (xor loops, constants like 0x5A827999)
   - Input validation logic

4. Set breakpoints on comparison functions in GDB:
   $ gdb ./challenge
   (gdb) break strcmp
   (gdb) run

5. Examine memory at comparison point to see expected value
```

### Library Analysis

```
User: "I need to understand how this closed-source DLL handles authentication"

Response: For authorized analysis of the DLL:

1. Static analysis:
   - List exports: dumpbin /exports library.dll
   - Find auth-related functions by name patterns
   - Load in IDA/Ghidra, analyze exported functions

2. Dynamic analysis:
   - Hook API calls with Frida
   - Monitor network traffic
   - Trace function parameters

3. Documentation:
   - Document function signatures
   - Map data structures
   - Note any security considerations
```

These guidelines provide practices for reverse engineering.

## Anti Reversing Techniques

> **AUTHORIZED USE ONLY**: This skill contains dual-use security techniques. Before proceeding with any bypass or analysis:
>
> 1. **Verify authorization**: Confirm you have explicit written permission from the software owner, or are operating within a legitimate security context (CTF, authorized pentest, malware analysis, security research)
> 2. **Document scope**: Ensure your activities fall within the defined scope of your authorization
> 3. **Legal compliance**: Understand that unauthorized bypassing of software protection may violate laws (CFAA, DMCA anti-circumvention, etc.)
>
> **Legitimate use cases**: Malware analysis, authorized penetration testing, CTF competitions, academic security research, analyzing software you own/have rights to

# Anti-Reversing Techniques

Understanding protection mechanisms encountered during authorized software analysis, security research, and malware analysis. This knowledge helps analysts bypass protections to complete legitimate analysis tasks.

## Anti-Debugging Techniques

### Windows Anti-Debugging

#### API-Based Detection

```c
// IsDebuggerPresent
if (IsDebuggerPresent()) {
    exit(1);
}

// CheckRemoteDebuggerPresent
BOOL debugged = FALSE;
CheckRemoteDebuggerPresent(GetCurrentProcess(), &debugged);
if (debugged) exit(1);

// NtQueryInformationProcess
typedef NTSTATUS (NTAPI *pNtQueryInformationProcess)(
    HANDLE, PROCESSINFOCLASS, PVOID, ULONG, PULONG);

DWORD debugPort = 0;
NtQueryInformationProcess(
    GetCurrentProcess(),
    ProcessDebugPort,        // 7
    &debugPort,
    sizeof(debugPort),
    NULL
);
if (debugPort != 0) exit(1);

// Debug flags
DWORD debugFlags = 0;
NtQueryInformationProcess(
    GetCurrentProcess(),
    ProcessDebugFlags,       // 0x1F
    &debugFlags,
    sizeof(debugFlags),
    NULL
);
if (debugFlags == 0) exit(1);  // 0 means being debugged
```

**Bypass Approaches:**

```python
# x64dbg: ScyllaHide plugin
# Patches common anti-debug checks

# Manual patching in debugger:
# - Set IsDebuggerPresent return to 0
# - Patch PEB.BeingDebugged to 0
# - Hook NtQueryInformationProcess

# IDAPython: Patch checks
ida_bytes.patch_byte(check_addr, 0x90)  # NOP
```

#### PEB-Based Detection

```c
// Direct PEB access
#ifdef _WIN64
    PPEB peb = (PPEB)__readgsqword(0x60);
#else
    PPEB peb = (PPEB)__readfsdword(0x30);
#endif

// BeingDebugged flag
if (peb->BeingDebugged) exit(1);

// NtGlobalFlag
// Debugged: 0x70 (FLG_HEAP_ENABLE_TAIL_CHECK |
//                 FLG_HEAP_ENABLE_FREE_CHECK |
//                 FLG_HEAP_VALIDATE_PARAMETERS)
if (peb->NtGlobalFlag & 0x70) exit(1);

// Heap flags
PDWORD heapFlags = (PDWORD)((PBYTE)peb->ProcessHeap + 0x70);
if (*heapFlags & 0x50000062) exit(1);
```

**Bypass Approaches:**

```assembly
; In debugger, modify PEB directly
; x64dbg: dump at gs:[60] (x64) or fs:[30] (x86)
; Set BeingDebugged (offset 2) to 0
; Clear NtGlobalFlag (offset 0xBC for x64)
```

#### Timing-Based Detection

```c
// RDTSC timing
uint64_t start = __rdtsc();
// ... some code ...
uint64_t end = __rdtsc();
if ((end - start) > THRESHOLD) exit(1);

// QueryPerformanceCounter
LARGE_INTEGER start, end, freq;
QueryPerformanceFrequency(&freq);
QueryPerformanceCounter(&start);
// ... code ...
QueryPerformanceCounter(&end);
double elapsed = (double)(end.QuadPart - start.QuadPart) / freq.QuadPart;
if (elapsed > 0.1) exit(1);  // Too slow = debugger

// GetTickCount
DWORD start = GetTickCount();
// ... code ...
if (GetTickCount() - start > 1000) exit(1);
```

**Bypass Approaches:**

```
- Use hardware breakpoints instead of software
- Patch timing checks
- Use VM with controlled time
- Hook timing APIs to return consistent values
```

#### Exception-Based Detection

```c
// SHE-based detection
__try {
    __asm { int 3 }  // Software breakpoint
}
__except(EXCEPTION_EXECUTE_HANDLER) {
    // Normal execution: exception caught
    return;
}
// Debugger ate the exception
exit(1);

// VEH-based detection
LONG CALLBACK VectoredHandler(PEXCEPTION_POINTERS ep) {
    if (ep->ExceptionRecord->ExceptionCode == EXCEPTION_BREAKPOINT) {
        ep->ContextRecord->Rip++;  // Skip INT3
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    return EXCEPTION_CONTINUE_SEARCH;
}
```

### Linux Anti-Debugging

```c
// ptrace self-trace
if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) == -1) {
    // Already being traced
    exit(1);
}

// /proc/self/status
FILE *f = fopen("/proc/self/status", "r");
char line[256];
while (fgets(line, sizeof(line), f)) {
    if (strncmp(line, "TracerPid:", 10) == 0) {
        int tracer_pid = atoi(line + 10);
        if (tracer_pid != 0) exit(1);
    }
}

// Parent process check
if (getppid() != 1 && strcmp(get_process_name(getppid()), "bash") != 0) {
    // Unusual parent (might be debugger)
}
```

**Bypass Approaches:**

```bash
# LD_PRELOAD to hook ptrace
# Compile: gcc -shared -fPIC -o hook.so hook.c
long ptrace(int request, ...) {
    return 0;  // Always succeed
}

# Usage
LD_PRELOAD=./hook.so ./target
```

## Anti-VM Detection

### Hardware Fingerprinting

```c
// CPUID-based detection
int cpuid_info[4];
__cpuid(cpuid_info, 1);
// Check hypervisor bit (bit 31 of ECX)
if (cpuid_info[2] & (1 << 31)) {
    // Running in hypervisor
}

// CPUID brand string
__cpuid(cpuid_info, 0x40000000);
char vendor[13] = {0};
memcpy(vendor, &cpuid_info[1], 12);
// "VMwareVMware", "Microsoft Hv", "KVMKVMKVM", "VBoxVBoxVBox"

// MAC address prefix
// VMware: 00:0C:29, 00:50:56
// VirtualBox: 08:00:27
// Hyper-V: 00:15:5D
```

### Registry/File Detection

```c
// Windows registry keys
// HKLM\SOFTWARE\VMware, Inc.\VMware Tools
// HKLM\SOFTWARE\Oracle\VirtualBox Guest Additions
// HKLM\HARDWARE\ACPI\DSDT\VBOX__

// Files
// C:\Windows\System32\drivers\vmmouse.sys
// C:\Windows\System32\drivers\vmhgfs.sys
// C:\Windows\System32\drivers\VBoxMouse.sys

// Processes
// vmtoolsd.exe, vmwaretray.exe
// VBoxService.exe, VBoxTray.exe
```

### Timing-Based VM Detection

```c
// VM exits cause timing anomalies
uint64_t start = __rdtsc();
__cpuid(cpuid_info, 0);  // Causes VM exit
uint64_t end = __rdtsc();
if ((end - start) > 500) {
    // Likely in VM (CPUID takes longer)
}
```

**Bypass Approaches:**

```
- Use bare-metal analysis environment
- Harden VM (remove guest tools, change MAC)
- Patch detection code
- Use specialized analysis VMs (FLARE-VM)
```

## Code Obfuscation

### Control Flow Obfuscation

#### Control Flow Flattening

```c
// Original
if (cond) {
    func_a();
} else {
    func_b();
}
func_c();

// Flattened
int state = 0;
while (1) {
    switch (state) {
        case 0:
            state = cond ? 1 : 2;
            break;
        case 1:
            func_a();
            state = 3;
            break;
        case 2:
            func_b();
            state = 3;
            break;
        case 3:
            func_c();
            return;
    }
}
```

**Analysis Approach:**

- Identify state variable
- Map state transitions
- Reconstruct original flow
- Tools: D-810 (IDA), SATURN

#### Opaque Predicates

```c
// Always true, but complex to analyze
int x = rand();
if ((x * x) >= 0) {  // Always true
    real_code();
} else {
    junk_code();  // Dead code
}

// Always false
if ((x * (x + 1)) % 2 == 1) {  // Product of consecutive = even
    junk_code();
}
```

**Analysis Approach:**

- Identify constant expressions
- Symbolic execution to prove predicates
- Pattern matching for known opaque predicates

### Data Obfuscation

#### String Encryption

```c
// XOR encryption
char decrypt_string(char *enc, int len, char key) {
    char *dec = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        dec[i] = enc[i] ^ key;
    }
    dec[len] = 0;
    return dec;
}

// Stack strings
char url[20];
url[0] = 'h'; url[1] = 't'; url[2] = 't'; url[3] = 'p';
url[4] = ':'; url[5] = '/'; url[6] = '/';
// ...
```

**Analysis Approach:**

```python
# FLOSS for automatic string deobfuscation
floss malware.exe

# IDAPython string decryption
def decrypt_xor(ea, length, key):
    result = ""
    for i in range(length):
        byte = ida_bytes.get_byte(ea + i)
        result += chr(byte ^ key)
    return result
```

#### API Obfuscation

```c
// Dynamic API resolution
typedef HANDLE (WINAPI *pCreateFileW)(LPCWSTR, DWORD, DWORD,
    LPSECURITY_ATTRIBUTES, DWORD, DWORD, HANDLE);

HMODULE kernel32 = LoadLibraryA("kernel32.dll");
pCreateFileW myCreateFile = (pCreateFileW)GetProcAddress(
    kernel32, "CreateFileW");

// API hashing
DWORD hash_api(char *name) {
    DWORD hash = 0;
    while (*name) {
        hash = ((hash >> 13) | (hash << 19)) + *name++;
    }
    return hash;
}
// Resolve by hash comparison instead of string
```

**Analysis Approach:**

- Identify hash algorithm
- Build hash database of known APIs
- Use HashDB plugin for IDA
- Dynamic analysis to resolve at runtime

### Instruction-Level Obfuscation

#### Dead Code Insertion

```asm
; Original
mov eax, 1

; With dead code
push ebx           ; Dead
mov eax, 1
pop ebx            ; Dead
xor ecx, ecx       ; Dead
add ecx, ecx       ; Dead
```

#### Instruction Substitution

```asm
; Original: xor eax, eax (set to 0)
; Substitutions:
sub eax, eax
mov eax, 0
and eax, 0
lea eax, [0]

; Original: mov eax, 1
; Substitutions:
xor eax, eax
inc eax

push 1
pop eax
```

## Packing and Encryption

### Common Packers

```
UPX          - Open source, easy to unpack
Themida      - Commercial, VM-based protection
VMProtect    - Commercial, code virtualization
ASPack       - Compression packer
PECompact    - Compression packer
Enigma       - Commercial protector
```

### Unpacking Methodology

```
1. Identify packer (DIE, Exeinfo PE, PEiD)

2. Static unpacking (if known packer):
   - UPX: upx -d packed.exe
   - Use existing unpackers

3. Dynamic unpacking:
   a. Find Original Entry Point (OEP)
   b. Set breakpoint on OEP
   c. Dump memory when OEP reached
   d. Fix import table (Scylla, ImpREC)

4. OEP finding techniques:
   - Hardware breakpoint on stack (ESP trick)
   - Break on common API calls (GetCommandLineA)
   - Trace and look for typical entry patterns
```

### Manual Unpacking Example

```
1. Load packed binary in x64dbg
2. Note entry point (packer stub)
3. Use ESP trick:
   - Run to entry
   - Set hardware breakpoint on [ESP]
   - Run until breakpoint hits (after PUSHAD/POPAD)
4. Look for JMP to OEP
5. At OEP, use Scylla to:
   - Dump process
   - Find imports (IAT autosearch)
   - Fix dump
```

## Virtualization-Based Protection

### Code Virtualization

```
Original x86 code is converted to custom bytecode
interpreted by embedded VM at runtime.

Original:     VM Protected:
mov eax, 1    push vm_context
add eax, 2    call vm_entry
              ; VM interprets bytecode
              ; equivalent to original
```

### Analysis Approaches

```
1. Identify VM components:
   - VM entry (dispatcher)
   - Handler table
   - Bytecode location
   - Virtual registers/stack

2. Trace execution:
   - Log handler calls
   - Map bytecode to operations
   - Understand instruction set

3. Lifting/devirtualization:
   - Map VM instructions back to native
   - Tools: VMAttack, SATURN, NoVmp

4. Symbolic execution:
   - Analyze VM semantically
   - angr, Triton
```

## Bypass Strategies Summary

### General Principles

1. **Understand the protection**: Identify what technique is used
2. **Find the check**: Locate protection code in binary
3. **Patch or hook**: Modify check to always pass
4. **Use appropriate tools**: ScyllaHide, x64dbg plugins
5. **Document findings**: Keep notes on bypassed protections

### Tool Recommendations

```
Anti-debug bypass:    ScyllaHide, TitanHide
Unpacking:           x64dbg + Scylla, OllyDumpEx
Deobfuscation:       D-810, SATURN, miasm
VM analysis:         VMAttack, NoVmp, manual tracing
String decryption:   FLOSS, custom scripts
Symbolic execution:  angr, Triton
```

### Ethical Considerations

This knowledge should only be used for:

- Authorized security research
- Malware analysis (defensive)
- CTF competitions
- Understanding protections for legitimate purposes
- Educational purposes

Never use to bypass protections for:

- Software piracy
- Unauthorized access
- Malicious purposes

## Binary Analysis Patterns

# Binary Analysis Patterns

Comprehensive patterns and techniques for analyzing compiled binaries, understanding assembly code, and reconstructing program logic.

## Disassembly Fundamentals

### x86-64 Instruction Patterns

#### Function Prologue/Epilogue

```asm
; Standard prologue
push rbp           ; Save base pointer
mov rbp, rsp       ; Set up stack frame
sub rsp, 0x20      ; Allocate local variables

; Leaf function (no calls)
; May skip frame pointer setup
sub rsp, 0x18      ; Just allocate locals

; Standard epilogue
mov rsp, rbp       ; Restore stack pointer
pop rbp            ; Restore base pointer
ret

; Leave instruction (equivalent)
leave              ; mov rsp, rbp; pop rbp
ret
```

#### Calling Conventions

**System V AMD64 (Linux, macOS)**

```asm
; Arguments: RDI, RSI, RDX, RCX, R8, R9, then stack
; Return: RAX (and RDX for 128-bit)
; Caller-saved: RAX, RCX, RDX, RSI, RDI, R8-R11
; Callee-saved: RBX, RBP, R12-R15

; Example: func(a, b, c, d, e, f, g)
mov rdi, [a]       ; 1st arg
mov rsi, [b]       ; 2nd arg
mov rdx, [c]       ; 3rd arg
mov rcx, [d]       ; 4th arg
mov r8, [e]        ; 5th arg
mov r9, [f]        ; 6th arg
push [g]           ; 7th arg on stack
call func
```

**Microsoft x64 (Windows)**

```asm
; Arguments: RCX, RDX, R8, R9, then stack
; Shadow space: 32 bytes reserved on stack
; Return: RAX

; Example: func(a, b, c, d, e)
sub rsp, 0x28      ; Shadow space + alignment
mov rcx, [a]       ; 1st arg
mov rdx, [b]       ; 2nd arg
mov r8, [c]        ; 3rd arg
mov r9, [d]        ; 4th arg
mov [rsp+0x20], [e] ; 5th arg on stack
call func
add rsp, 0x28
```

### ARM Assembly Patterns

#### ARM64 (AArch64) Calling Convention

```asm
; Arguments: X0-X7
; Return: X0 (and X1 for 128-bit)
; Frame pointer: X29
; Link register: X30

; Function prologue
stp x29, x30, [sp, #-16]!  ; Save FP and LR
mov x29, sp                 ; Set frame pointer

; Function epilogue
ldp x29, x30, [sp], #16    ; Restore FP and LR
ret
```

#### ARM32 Calling Convention

```asm
; Arguments: R0-R3, then stack
; Return: R0 (and R1 for 64-bit)
; Link register: LR (R14)

; Function prologue
push {fp, lr}
add fp, sp, #4

; Function epilogue
pop {fp, pc}    ; Return by popping PC
```

## Control Flow Patterns

### Conditional Branches

```asm
; if (a == b)
cmp eax, ebx
jne skip_block
; ... if body ...
skip_block:

; if (a < b) - signed
cmp eax, ebx
jge skip_block    ; Jump if greater or equal
; ... if body ...
skip_block:

; if (a < b) - unsigned
cmp eax, ebx
jae skip_block    ; Jump if above or equal
; ... if body ...
skip_block:
```

### Loop Patterns

```asm
; for (int i = 0; i < n; i++)
xor ecx, ecx           ; i = 0
loop_start:
cmp ecx, [n]           ; i < n
jge loop_end
; ... loop body ...
inc ecx                ; i++
jmp loop_start
loop_end:

; while (condition)
jmp loop_check
loop_body:
; ... body ...
loop_check:
cmp eax, ebx
jl loop_body

; do-while
loop_body:
; ... body ...
cmp eax, ebx
jl loop_body
```

### Switch Statement Patterns

```asm
; Jump table pattern
mov eax, [switch_var]
cmp eax, max_case
ja default_case
jmp [jump_table + eax*8]

; Sequential comparison (small switch)
cmp eax, 1
je case_1
cmp eax, 2
je case_2
cmp eax, 3
je case_3
jmp default_case
```

## Data Structure Patterns

### Array Access

```asm
; array[i] - 4-byte elements
mov eax, [rbx + rcx*4]        ; rbx=base, rcx=index

; array[i] - 8-byte elements
mov rax, [rbx + rcx*8]

; Multi-dimensional array[i][j]
; arr[i][j] = base + (i * cols + j) * element_size
imul eax, [cols]
add eax, [j]
mov edx, [rbx + rax*4]
```

### Structure Access

```c
struct Example {
    int a;      // offset 0
    char b;     // offset 4
    // padding  // offset 5-7
    long c;     // offset 8
    short d;    // offset 16
};
```

```asm
; Accessing struct fields
mov rdi, [struct_ptr]
mov eax, [rdi]         ; s->a (offset 0)
movzx eax, byte [rdi+4] ; s->b (offset 4)
mov rax, [rdi+8]       ; s->c (offset 8)
movzx eax, word [rdi+16] ; s->d (offset 16)
```

### Linked List Traversal

```asm
; while (node != NULL)
list_loop:
test rdi, rdi          ; node == NULL?
jz list_done
; ... process node ...
mov rdi, [rdi+8]       ; node = node->next (assuming next at offset 8)
jmp list_loop
list_done:
```

## Common Code Patterns

### String Operations

```asm
; strlen pattern
xor ecx, ecx
strlen_loop:
cmp byte [rdi + rcx], 0
je strlen_done
inc ecx
jmp strlen_loop
strlen_done:
; ecx contains length

; strcpy pattern
strcpy_loop:
mov al, [rsi]
mov [rdi], al
test al, al
jz strcpy_done
inc rsi
inc rdi
jmp strcpy_loop
strcpy_done:

; memcpy using rep movsb
mov rdi, dest
mov rsi, src
mov rcx, count
rep movsb
```

### Arithmetic Patterns

```asm
; Multiplication by constant
; x * 3
lea eax, [rax + rax*2]

; x * 5
lea eax, [rax + rax*4]

; x * 10
lea eax, [rax + rax*4]  ; x * 5
add eax, eax            ; * 2

; Division by power of 2 (signed)
mov eax, [x]
cdq                     ; Sign extend to EDX:EAX
and edx, 7              ; For divide by 8
add eax, edx            ; Adjust for negative
sar eax, 3              ; Arithmetic shift right

; Modulo power of 2
and eax, 7              ; x % 8
```

### Bit Manipulation

```asm
; Test specific bit
test eax, 0x80          ; Test bit 7
jnz bit_set

; Set bit
or eax, 0x10            ; Set bit 4

; Clear bit
and eax, ~0x10          ; Clear bit 4

; Toggle bit
xor eax, 0x10           ; Toggle bit 4

; Count leading zeros
bsr eax, ecx            ; Bit scan reverse
xor eax, 31             ; Convert to leading zeros

; Population count (popcnt)
popcnt eax, ecx         ; Count set bits
```

## Decompilation Patterns

### Variable Recovery

```asm
; Local variable at rbp-8
mov qword [rbp-8], rax  ; Store to local
mov rax, [rbp-8]        ; Load from local

; Stack-allocated array
lea rax, [rbp-0x40]     ; Array starts at rbp-0x40
mov [rax], edx          ; array[0] = value
mov [rax+4], ecx        ; array[1] = value
```

### Function Signature Recovery

```asm
; Identify parameters by register usage
func:
    ; rdi used as first param (System V)
    mov [rbp-8], rdi    ; Save param to local
    ; rsi used as second param
    mov [rbp-16], rsi
    ; Identify return by RAX at end
    mov rax, [result]
    ret
```

### Type Recovery

```asm
; 1-byte operations suggest char/bool
movzx eax, byte [rdi]   ; Zero-extend byte
movsx eax, byte [rdi]   ; Sign-extend byte

; 2-byte operations suggest short
movzx eax, word [rdi]
movsx eax, word [rdi]

; 4-byte operations suggest int/float
mov eax, [rdi]
movss xmm0, [rdi]       ; Float

; 8-byte operations suggest long/double/pointer
mov rax, [rdi]
movsd xmm0, [rdi]       ; Double
```

## Ghidra Analysis Tips

### Improving Decompilation

```java
// In Ghidra scripting
// Fix function signature
Function func = getFunctionAt(toAddr(0x401000));
func.setReturnType(IntegerDataType.dataType, SourceType.USER_DEFINED);

// Create structure type
StructureDataType struct = new StructureDataType("MyStruct", 0);
struct.add(IntegerDataType.dataType, "field_a", null);
struct.add(PointerDataType.dataType, "next", null);

// Apply to memory
createData(toAddr(0x601000), struct);
```

### Pattern Matching Scripts

```python
# Find all calls to dangerous functions
for func in currentProgram.getFunctionManager().getFunctions(True):
    for ref in getReferencesTo(func.getEntryPoint()):
        if func.getName() in ["strcpy", "sprintf", "gets"]:
            print(f"Dangerous call at {ref.getFromAddress()}")
```

## IDA Pro Patterns

### IDAPython Analysis

```python
import idaapi
import idautils
import idc

# Find all function calls
def find_calls(func_name):
    for func_ea in idautils.Functions():
        for head in idautils.Heads(func_ea, idc.find_func_end(func_ea)):
            if idc.print_insn_mnem(head) == "call":
                target = idc.get_operand_value(head, 0)
                if idc.get_func_name(target) == func_name:
                    print(f"Call to {func_name} at {hex(head)}")

# Rename functions based on strings
def auto_rename():
    for s in idautils.Strings():
        for xref in idautils.XrefsTo(s.ea):
            func = idaapi.get_func(xref.frm)
            if func and "sub_" in idc.get_func_name(func.start_ea):
                # Use string as hint for naming
                pass
```

## Best Practices

### Analysis Workflow

1. **Initial triage**: File type, architecture, imports/exports
2. **String analysis**: Identify interesting strings, error messages
3. **Function identification**: Entry points, exports, cross-references
4. **Control flow mapping**: Understand program structure
5. **Data structure recovery**: Identify structs, arrays, globals
6. **Algorithm identification**: Crypto, hashing, compression
7. **Documentation**: Comments, renamed symbols, type definitions

### Common Pitfalls

- **Optimizer artifacts**: Code may not match source structure
- **Inline functions**: Functions may be expanded inline
- **Tail call optimization**: `jmp` instead of `call` + `ret`
- **Dead code**: Unreachable code from optimization
- **Position-independent code**: RIP-relative addressing

## Memory Forensics

# Memory Forensics

Comprehensive techniques for acquiring, analyzing, and extracting artifacts from memory dumps for incident response and malware analysis.

## Memory Acquisition

### Live Acquisition Tools

#### Windows

```powershell
# WinPmem (Recommended)
winpmem_mini_x64.exe memory.raw

# DumpIt
DumpIt.exe

# Belkasoft RAM Capturer
# GUI-based, outputs raw format

# Magnet RAM Capture
# GUI-based, outputs raw format
```

#### Linux

```bash
# LiME (Linux Memory Extractor)
sudo insmod lime.ko "path=/tmp/memory.lime format=lime"

# /dev/mem (limited, requires permissions)
sudo dd if=/dev/mem of=memory.raw bs=1M

# /proc/kcore (ELF format)
sudo cp /proc/kcore memory.elf
```

#### macOS

```bash
# osxpmem
sudo ./osxpmem -o memory.raw

# MacQuisition (commercial)
```

### Virtual Machine Memory

```bash
# VMware: .vmem file is raw memory
cp vm.vmem memory.raw

# VirtualBox: Use debug console
vboxmanage debugvm "VMName" dumpvmcore --filename memory.elf

# QEMU
virsh dump <domain> memory.raw --memory-only

# Hyper-V
# Checkpoint contains memory state
```

## Volatility 3 Framework

### Installation and Setup

```bash
# Install Volatility 3
pip install volatility3

# Install symbol tables (Windows)
# Download from https://downloads.volatilityfoundation.org/volatility3/symbols/

# Basic usage
vol -f memory.raw <plugin>

# With symbol path
vol -f memory.raw -s /path/to/symbols windows.pslist
```

### Essential Plugins

#### Process Analysis

```bash
# List processes
vol -f memory.raw windows.pslist

# Process tree (parent-child relationships)
vol -f memory.raw windows.pstree

# Hidden process detection
vol -f memory.raw windows.psscan

# Process memory dumps
vol -f memory.raw windows.memmap --pid <PID> --dump

# Process environment variables
vol -f memory.raw windows.envars --pid <PID>

# Command line arguments
vol -f memory.raw windows.cmdline
```

#### Network Analysis

```bash
# Network connections
vol -f memory.raw windows.netscan

# Network connection state
vol -f memory.raw windows.netstat
```

#### DLL and Module Analysis

```bash
# Loaded DLLs per process
vol -f memory.raw windows.dlllist --pid <PID>

# Find hidden/injected DLLs
vol -f memory.raw windows.ldrmodules

# Kernel modules
vol -f memory.raw windows.modules

# Module dumps
vol -f memory.raw windows.moddump --pid <PID>
```

#### Memory Injection Detection

```bash
# Detect code injection
vol -f memory.raw windows.malfind

# VAD (Virtual Address Descriptor) analysis
vol -f memory.raw windows.vadinfo --pid <PID>

# Dump suspicious memory regions
vol -f memory.raw windows.vadyarascan --yara-rules rules.yar
```

#### Registry Analysis

```bash
# List registry hives
vol -f memory.raw windows.registry.hivelist

# Print registry key
vol -f memory.raw windows.registry.printkey --key "Software\Microsoft\Windows\CurrentVersion\Run"

# Dump registry hive
vol -f memory.raw windows.registry.hivescan --dump
```

#### File System Artifacts

```bash
# Scan for file objects
vol -f memory.raw windows.filescan

# Dump files from memory
vol -f memory.raw windows.dumpfiles --pid <PID>

# MFT analysis
vol -f memory.raw windows.mftscan
```

### Linux Analysis

```bash
# Process listing
vol -f memory.raw linux.pslist

# Process tree
vol -f memory.raw linux.pstree

# Bash history
vol -f memory.raw linux.bash

# Network connections
vol -f memory.raw linux.sockstat

# Loaded kernel modules
vol -f memory.raw linux.lsmod

# Mount points
vol -f memory.raw linux.mount

# Environment variables
vol -f memory.raw linux.envars
```

### macOS Analysis

```bash
# Process listing
vol -f memory.raw mac.pslist

# Process tree
vol -f memory.raw mac.pstree

# Network connections
vol -f memory.raw mac.netstat

# Kernel extensions
vol -f memory.raw mac.lsmod
```

## Analysis Workflows

### Malware Analysis Workflow

```bash
# 1. Initial process survey
vol -f memory.raw windows.pstree > processes.txt
vol -f memory.raw windows.pslist > pslist.txt

# 2. Network connections
vol -f memory.raw windows.netscan > network.txt

# 3. Detect injection
vol -f memory.raw windows.malfind > malfind.txt

# 4. Analyze suspicious processes
vol -f memory.raw windows.dlllist --pid <PID>
vol -f memory.raw windows.handles --pid <PID>

# 5. Dump suspicious executables
vol -f memory.raw windows.pslist --pid <PID> --dump

# 6. Extract strings from dumps
strings -a pid.<PID>.exe > strings.txt

# 7. YARA scanning
vol -f memory.raw windows.yarascan --yara-rules malware.yar
```

### Incident Response Workflow

```bash
# 1. Timeline of events
vol -f memory.raw windows.timeliner > timeline.csv

# 2. User activity
vol -f memory.raw windows.cmdline
vol -f memory.raw windows.consoles

# 3. Persistence mechanisms
vol -f memory.raw windows.registry.printkey \
    --key "Software\Microsoft\Windows\CurrentVersion\Run"

# 4. Services
vol -f memory.raw windows.svcscan

# 5. Scheduled tasks
vol -f memory.raw windows.scheduled_tasks

# 6. Recent files
vol -f memory.raw windows.filescan | grep -i "recent"
```

## Data Structures

### Windows Process Structures

```c
// EPROCESS (Executive Process)
typedef struct _EPROCESS {
    KPROCESS Pcb;                    // Kernel process block
    EX_PUSH_LOCK ProcessLock;
    LARGE_INTEGER CreateTime;
    LARGE_INTEGER ExitTime;
    // ...
    LIST_ENTRY ActiveProcessLinks;   // Doubly-linked list
    ULONG_PTR UniqueProcessId;       // PID
    // ...
    PEB* Peb;                        // Process Environment Block
    // ...
} EPROCESS;

// PEB (Process Environment Block)
typedef struct _PEB {
    BOOLEAN InheritedAddressSpace;
    BOOLEAN ReadImageFileExecOptions;
    BOOLEAN BeingDebugged;           // Anti-debug check
    // ...
    PVOID ImageBaseAddress;          // Base address of executable
    PPEB_LDR_DATA Ldr;              // Loader data (DLL list)
    PRTL_USER_PROCESS_PARAMETERS ProcessParameters;
    // ...
} PEB;
```

### VAD (Virtual Address Descriptor)

```c
typedef struct _MMVAD {
    MMVAD_SHORT Core;
    union {
        ULONG LongFlags;
        MMVAD_FLAGS VadFlags;
    } u;
    // ...
    PVOID FirstPrototypePte;
    PVOID LastContiguousPte;
    // ...
    PFILE_OBJECT FileObject;
} MMVAD;

// Memory protection flags
#define PAGE_EXECUTE           0x10
#define PAGE_EXECUTE_READ      0x20
#define PAGE_EXECUTE_READWRITE 0x40
#define PAGE_EXECUTE_WRITECOPY 0x80
```

## Detection Patterns

### Process Injection Indicators

```python
# Malfind indicators
# - PAGE_EXECUTE_READWRITE protection (suspicious)
# - MZ header in non-image VAD region
# - Shellcode patterns at allocation start

# Common injection techniques
# 1. Classic DLL Injection
#    - VirtualAllocEx + WriteProcessMemory + CreateRemoteThread

# 2. Process Hollowing
#    - CreateProcess (SUSPENDED) + NtUnmapViewOfSection + WriteProcessMemory

# 3. APC Injection
#    - QueueUserAPC targeting alertable threads

# 4. Thread Execution Hijacking
#    - SuspendThread + SetThreadContext + ResumeThread
```

### Rootkit Detection

```bash
# Compare process lists
vol -f memory.raw windows.pslist > pslist.txt
vol -f memory.raw windows.psscan > psscan.txt
diff pslist.txt psscan.txt  # Hidden processes

# Check for DKOM (Direct Kernel Object Manipulation)
vol -f memory.raw windows.callbacks

# Detect hooked functions
vol -f memory.raw windows.ssdt  # System Service Descriptor Table

# Driver analysis
vol -f memory.raw windows.driverscan
vol -f memory.raw windows.driverirp
```

### Credential Extraction

```bash
# Dump hashes (requires hivelist first)
vol -f memory.raw windows.hashdump

# LSA secrets
vol -f memory.raw windows.lsadump

# Cached domain credentials
vol -f memory.raw windows.cachedump

# Mimikatz-style extraction
# Requires specific plugins/tools
```

## YARA Integration

### Writing Memory YARA Rules

```yara
rule Suspicious_Injection
{
    meta:
        description = "Detects common injection shellcode"

    strings:
        // Common shellcode patterns
        $mz = { 4D 5A }
        $shellcode1 = { 55 8B EC 83 EC }  // Function prologue
        $api_hash = { 68 ?? ?? ?? ?? 68 ?? ?? ?? ?? E8 }  // Push hash, call

    condition:
        $mz at 0 or any of ($shellcode*)
}

rule Cobalt_Strike_Beacon
{
    meta:
        description = "Detects Cobalt Strike beacon in memory"

    strings:
        $config = { 00 01 00 01 00 02 }
        $sleep = "sleeptime"
        $beacon = "%s (admin)" wide

    condition:
        2 of them
}
```

### Scanning Memory

```bash
# Scan all process memory
vol -f memory.raw windows.yarascan --yara-rules rules.yar

# Scan specific process
vol -f memory.raw windows.yarascan --yara-rules rules.yar --pid 1234

# Scan kernel memory
vol -f memory.raw windows.yarascan --yara-rules rules.yar --kernel
```

## String Analysis

### Extracting Strings

```bash
# Basic string extraction
strings -a memory.raw > all_strings.txt

# Unicode strings
strings -el memory.raw >> all_strings.txt

# Targeted extraction from process dump
vol -f memory.raw windows.memmap --pid 1234 --dump
strings -a pid.1234.dmp > process_strings.txt

# Pattern matching
grep -E "(https?://|[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})" all_strings.txt
```

### FLOSS for Obfuscated Strings

```bash
# FLOSS extracts obfuscated strings
floss malware.exe > floss_output.txt

# From memory dump
floss pid.1234.dmp
```

## Best Practices

### Acquisition Best Practices

1. **Minimize footprint**: Use lightweight acquisition tools
2. **Document everything**: Record time, tool, and hash of capture
3. **Verify integrity**: Hash memory dump immediately after capture
4. **Chain of custody**: Maintain proper forensic handling

### Analysis Best Practices

1. **Start broad**: Get overview before deep diving
2. **Cross-reference**: Use multiple plugins for same data
3. **Timeline correlation**: Correlate memory findings with disk/network
4. **Document findings**: Keep detailed notes and screenshots
5. **Validate results**: Verify findings through multiple methods

### Common Pitfalls

- **Stale data**: Memory is volatile, analyze promptly
- **Incomplete dumps**: Verify dump size matches expected RAM
- **Symbol issues**: Ensure correct symbol files for OS version
- **Smear**: Memory may change during acquisition
- **Encryption**: Some data may be encrypted in memory

## Protocol Reverse Engineering

# Protocol Reverse Engineering

Comprehensive techniques for capturing, analyzing, and documenting network protocols for security research, interoperability, and debugging.

## Traffic Capture

### Wireshark Capture

```bash
# Capture on specific interface
wireshark -i eth0 -k

# Capture with filter
wireshark -i eth0 -k -f "port 443"

# Capture to file
tshark -i eth0 -w capture.pcap

# Ring buffer capture (rotate files)
tshark -i eth0 -b filesize:100000 -b files:10 -w capture.pcap
```

### tcpdump Capture

```bash
# Basic capture
tcpdump -i eth0 -w capture.pcap

# With filter
tcpdump -i eth0 port 8080 -w capture.pcap

# Capture specific bytes
tcpdump -i eth0 -s 0 -w capture.pcap  # Full packet

# Real-time display
tcpdump -i eth0 -X port 80
```

### Man-in-the-Middle Capture

```bash
# mitmproxy for HTTP/HTTPS
mitmproxy --mode transparent -p 8080

# SSL/TLS interception
mitmproxy --mode transparent --ssl-insecure

# Dump to file
mitmdump -w traffic.mitm

# Burp Suite
# Configure browser proxy to 127.0.0.1:8080
```

## Protocol Analysis

### Wireshark Analysis

```
# Display filters
tcp.port == 8080
http.request.method == "POST"
ip.addr == 192.168.1.1
tcp.flags.syn == 1 && tcp.flags.ack == 0
frame contains "password"

# Following streams
Right-click > Follow > TCP Stream
Right-click > Follow > HTTP Stream

# Export objects
File > Export Objects > HTTP

# Decryption
Edit > Preferences > Protocols > TLS
  - (Pre)-Master-Secret log filename
  - RSA keys list
```

### tshark Analysis

```bash
# Extract specific fields
tshark -r capture.pcap -T fields -e ip.src -e ip.dst -e tcp.port

# Statistics
tshark -r capture.pcap -q -z conv,tcp
tshark -r capture.pcap -q -z endpoints,ip

# Filter and extract
tshark -r capture.pcap -Y "http" -T json > http_traffic.json

# Protocol hierarchy
tshark -r capture.pcap -q -z io,phs
```

### Scapy for Custom Analysis

```python
from scapy.all import *

# Read pcap
packets = rdpcap("capture.pcap")

# Analyze packets
for pkt in packets:
    if pkt.haslayer(TCP):
        print(f"Src: {pkt[IP].src}:{pkt[TCP].sport}")
        print(f"Dst: {pkt[IP].dst}:{pkt[TCP].dport}")
        if pkt.haslayer(Raw):
            print(f"Data: {pkt[Raw].load[:50]}")

# Filter packets
http_packets = [p for p in packets if p.haslayer(TCP)
                and (p[TCP].sport == 80 or p[TCP].dport == 80)]

# Create custom packets
pkt = IP(dst="target")/TCP(dport=80)/Raw(load="GET / HTTP/1.1\r\n")
send(pkt)
```

## Protocol Identification

### Common Protocol Signatures

```
HTTP        - "HTTP/1." or "GET " or "POST " at start
TLS/SSL     - 0x16 0x03 (record layer)
DNS         - UDP port 53, specific header format
SMB         - 0xFF 0x53 0x4D 0x42 ("SMB" signature)
SSH         - "SSH-2.0" banner
FTP         - "220 " response, "USER " command
SMTP        - "220 " banner, "EHLO" command
MySQL       - 0x00 length prefix, protocol version
PostgreSQL  - 0x00 0x00 0x00 startup length
Redis       - "*" RESP array prefix
MongoDB     - BSON documents with specific header
```

### Protocol Header Patterns

```
+--------+--------+--------+--------+
|  Magic number / Signature         |
+--------+--------+--------+--------+
|  Version       |  Flags          |
+--------+--------+--------+--------+
|  Length        |  Message Type   |
+--------+--------+--------+--------+
|  Sequence Number / Session ID     |
+--------+--------+--------+--------+
|  Payload...                       |
+--------+--------+--------+--------+
```

## Binary Protocol Analysis

### Structure Identification

```python
# Common patterns in binary protocols

# Length-prefixed message
struct Message {
    uint32_t length;      # Total message length
    uint16_t msg_type;    # Message type identifier
    uint8_t  flags;       # Flags/options
    uint8_t  reserved;    # Padding/alignment
    uint8_t  payload[];   # Variable-length payload
};

# Type-Length-Value (TLV)
struct TLV {
    uint8_t  type;        # Field type
    uint16_t length;      # Field length
    uint8_t  value[];     # Field data
};

# Fixed header + variable payload
struct Packet {
    uint8_t  magic[4];    # "ABCD" signature
    uint32_t version;
    uint32_t payload_len;
    uint32_t checksum;    # CRC32 or similar
    uint8_t  payload[];
};
```

### Python Protocol Parser

```python
import struct
from dataclasses import dataclass

@dataclass
class MessageHeader:
    magic: bytes
    version: int
    msg_type: int
    length: int

    @classmethod
    def from_bytes(cls, data: bytes):
        magic, version, msg_type, length = struct.unpack(
            ">4sHHI", data[:12]
        )
        return cls(magic, version, msg_type, length)

def parse_messages(data: bytes):
    offset = 0
    messages = []

    while offset < len(data):
        header = MessageHeader.from_bytes(data[offset:])
        payload = data[offset+12:offset+12+header.length]
        messages.append((header, payload))
        offset += 12 + header.length

    return messages

# Parse TLV structure
def parse_tlv(data: bytes):
    fields = []
    offset = 0

    while offset < len(data):
        field_type = data[offset]
        length = struct.unpack(">H", data[offset+1:offset+3])[0]
        value = data[offset+3:offset+3+length]
        fields.append((field_type, value))
        offset += 3 + length

    return fields
```

### Hex Dump Analysis

```python
def hexdump(data: bytes, width: int = 16):
    """Format binary data as hex dump."""
    lines = []
    for i in range(0, len(data), width):
        chunk = data[i:i+width]
        hex_part = ' '.join(f'{b:02x}' for b in chunk)
        ascii_part = ''.join(
            chr(b) if 32 <= b < 127 else '.'
            for b in chunk
        )
        lines.append(f'{i:08x}  {hex_part:<{width*3}}  {ascii_part}')
    return '\n'.join(lines)

# Example output:
# 00000000  48 54 54 50 2f 31 2e 31  20 32 30 30 20 4f 4b 0d  HTTP/1.1 200 OK.
# 00000010  0a 43 6f 6e 74 65 6e 74  2d 54 79 70 65 3a 20 74  .Content-Type: t
```

## Encryption Analysis

### Identifying Encryption

```python
# Entropy analysis - high entropy suggests encryption/compression
import math
from collections import Counter

def entropy(data: bytes) -> float:
    if not data:
        return 0.0
    counter = Counter(data)
    probs = [count / len(data) for count in counter.values()]
    return -sum(p * math.log2(p) for p in probs)

# Entropy thresholds:
# < 6.0: Likely plaintext or structured data
# 6.0-7.5: Possibly compressed
# > 7.5: Likely encrypted or random

# Common encryption indicators
# - High, uniform entropy
# - No obvious structure or patterns
# - Length often multiple of block size (16 for AES)
# - Possible IV at start (16 bytes for AES-CBC)
```

### TLS Analysis

```bash
# Extract TLS metadata
tshark -r capture.pcap -Y "ssl.handshake" \
    -T fields -e ip.src -e ssl.handshake.ciphersuite

# JA3 fingerprinting (client)
tshark -r capture.pcap -Y "ssl.handshake.type == 1" \
    -T fields -e ssl.handshake.ja3

# JA3S fingerprinting (server)
tshark -r capture.pcap -Y "ssl.handshake.type == 2" \
    -T fields -e ssl.handshake.ja3s

# Certificate extraction
tshark -r capture.pcap -Y "ssl.handshake.certificate" \
    -T fields -e x509sat.printableString
```

### Decryption Approaches

```bash
# Pre-master secret log (browser)
export SSLKEYLOGFILE=/tmp/keys.log

# Configure Wireshark
# Edit > Preferences > Protocols > TLS
# (Pre)-Master-Secret log filename: /tmp/keys.log

# Decrypt with private key (if available)
# Only works for RSA key exchange
# Edit > Preferences > Protocols > TLS > RSA keys list
```

## Custom Protocol Documentation

### Protocol Specification Template

```markdown
# Protocol Name Specification

## Overview

Brief description of protocol purpose and design.

## Transport

- Layer: TCP/UDP
- Port: XXXX
- Encryption: TLS 1.2+

## Message Format

### Header (12 bytes)

| Offset | Size | Field   | Description             |
| ------ | ---- | ------- | ----------------------- |
| 0      | 4    | Magic   | 0x50524F54 ("PROT")     |
| 4      | 2    | Version | Protocol version (1)    |
| 6      | 2    | Type    | Message type identifier |
| 8      | 4    | Length  | Payload length in bytes |

### Message Types

| Type | Name      | Description            |
| ---- | --------- | ---------------------- |
| 0x01 | HELLO     | Connection initiation  |
| 0x02 | HELLO_ACK | Connection accepted    |
| 0x03 | DATA      | Application data       |
| 0x04 | CLOSE     | Connection termination |

### Type 0x01: HELLO

| Offset | Size | Field      | Description              |
| ------ | ---- | ---------- | ------------------------ |
| 0      | 4    | ClientID   | Unique client identifier |
| 4      | 2    | Flags      | Connection flags         |
| 6      | var  | Extensions | TLV-encoded extensions   |

## State Machine
```

[INIT] --HELLO--> [WAIT_ACK] --HELLO_ACK--> [CONNECTED]
|
DATA/DATA
|
[CLOSED] <--CLOSE--+

```

## Examples
### Connection Establishment
```

Client -> Server: HELLO (ClientID=0x12345678)
Server -> Client: HELLO_ACK (Status=OK)
Client -> Server: DATA (payload)

```

```

### Wireshark Dissector (Lua)

```lua
-- custom_protocol.lua
local proto = Proto("custom", "Custom Protocol")

-- Define fields
local f_magic = ProtoField.string("custom.magic", "Magic")
local f_version = ProtoField.uint16("custom.version", "Version")
local f_type = ProtoField.uint16("custom.type", "Type")
local f_length = ProtoField.uint32("custom.length", "Length")
local f_payload = ProtoField.bytes("custom.payload", "Payload")

proto.fields = { f_magic, f_version, f_type, f_length, f_payload }

-- Message type names
local msg_types = {
    [0x01] = "HELLO",
    [0x02] = "HELLO_ACK",
    [0x03] = "DATA",
    [0x04] = "CLOSE"
}

function proto.dissector(buffer, pinfo, tree)
    pinfo.cols.protocol = "CUSTOM"

    local subtree = tree:add(proto, buffer())

    -- Parse header
    subtree:add(f_magic, buffer(0, 4))
    subtree:add(f_version, buffer(4, 2))

    local msg_type = buffer(6, 2):uint()
    subtree:add(f_type, buffer(6, 2)):append_text(
        " (" .. (msg_types[msg_type] or "Unknown") .. ")"
    )

    local length = buffer(8, 4):uint()
    subtree:add(f_length, buffer(8, 4))

    if length > 0 then
        subtree:add(f_payload, buffer(12, length))
    end
end

-- Register for TCP port
local tcp_table = DissectorTable.get("tcp.port")
tcp_table:add(8888, proto)
```

## Active Testing

### Fuzzing with Boofuzz

```python
from boofuzz import *

def main():
    session = Session(
        target=Target(
            connection=TCPSocketConnection("target", 8888)
        )
    )

    # Define protocol structure
    s_initialize("HELLO")
    s_static(b"\x50\x52\x4f\x54")  # Magic
    s_word(1, name="version")       # Version
    s_word(0x01, name="type")       # Type (HELLO)
    s_size("payload", length=4)     # Length field
    s_block_start("payload")
    s_dword(0x12345678, name="client_id")
    s_word(0, name="flags")
    s_block_end()

    session.connect(s_get("HELLO"))
    session.fuzz()

if __name__ == "__main__":
    main()
```

### Replay and Modification

```python
from scapy.all import *

# Replay captured traffic
packets = rdpcap("capture.pcap")
for pkt in packets:
    if pkt.haslayer(TCP) and pkt[TCP].dport == 8888:
        send(pkt)

# Modify and replay
for pkt in packets:
    if pkt.haslayer(Raw):
        # Modify payload
        original = pkt[Raw].load
        modified = original.replace(b"client", b"CLIENT")
        pkt[Raw].load = modified
        # Recalculate checksums
        del pkt[IP].chksum
        del pkt[TCP].chksum
        send(pkt)
```

## Best Practices

### Analysis Workflow

1. **Capture traffic**: Multiple sessions, different scenarios
2. **Identify boundaries**: Message start/end markers
3. **Map structure**: Fixed header, variable payload
4. **Identify fields**: Compare multiple samples
5. **Document format**: Create specification
6. **Validate understanding**: Implement parser/generator
7. **Test edge cases**: Fuzzing, boundary conditions

### Common Patterns to Look For

- Magic numbers/signatures at message start
- Version fields for compatibility
- Length fields (often before variable data)
- Type/opcode fields for message identification
- Sequence numbers for ordering
- Checksums/CRCs for integrity
- Timestamps for timing
- Session/connection identifiers
