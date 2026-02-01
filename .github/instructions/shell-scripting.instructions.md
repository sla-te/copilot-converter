---
applyTo: "**/*.{sh,bash,zsh,fish,awk,sed}"
---

# Shell Scripting Guidelines

## Focus Areas

- Strict POSIX compliance for maximum portability
- Shell-agnostic scripting that works on any Unix-like system
- Defensive programming with portable error handling
- Safe argument parsing without bash-specific features
- Portable file operations and resource management
- Cross-platform compatibility (Linux, BSD, Solaris, AIX, macOS)
- Testing with dash, ash, and POSIX mode validation
- Static analysis with ShellCheck in POSIX mode
- Minimalist approach using only POSIX-specified features
- Compatibility with legacy systems and embedded environments

## POSIX Constraints

- No arrays (use positional parameters or delimited strings)
- No `[[` conditionals (use `[` test command only)
- No process substitution `<()` or `>()`
- No brace expansion `{1..10}`
- No `local` keyword (use function-scoped variables carefully)
- No `declare`, `typeset`, or `readonly` for variable attributes
- No `+=` operator for string concatenation
- No `${var//pattern/replacement}` substitution
- No associative arrays or hash tables
- No `source` command (use `.` for sourcing files)

## Approach

- Always use `#!/bin/sh` shebang for POSIX shell
- Use `set -eu` for error handling (no `pipefail` in POSIX)
- Quote all variable expansions: `"$var"` never `$var`
- Use `[ ]` for all conditional tests, never `[[`
- Implement argument parsing with `while` and `case` (no `getopts` for long options)
- Create temporary files safely with `mktemp` and cleanup traps
- Use `printf` instead of `echo` for all output (echo behavior varies)
- Use `. script.sh` instead of `source script.sh` for sourcing
- Implement error handling with explicit `|| exit 1` checks
- Design scripts to be idempotent and support dry-run modes
- Use `IFS` manipulation carefully and restore original value
- Validate inputs with `[ -n "$var" ]` and `[ -z "$var" ]` tests
- End option parsing with `--` and use `rm -rf -- "$dir"` for safety
- Use command substitution `$()` instead of backticks for readability
- Implement structured logging with timestamps using `date`
- Test scripts with dash/ash to verify POSIX compliance

## Compatibility & Portability

- Use `#!/bin/sh` to invoke the system's POSIX shell
- Test on multiple shells: dash (Debian/Ubuntu default), ash (Alpine/BusyBox), bash --posix
- Avoid GNU-specific options; use POSIX-specified flags only
- Handle platform differences: `uname -s` for OS detection
- Use `command -v` instead of `which` (more portable)
- Check for command availability: `command -v cmd >/dev/null 2>&1 || exit 1`
- Provide portable implementations for missing utilities
- Use `[ -e "$file" ]` for existence checks (works on all systems)
- Avoid `/dev/stdin`, `/dev/stdout` (not universally available)
- Use explicit redirection instead of `&>` (bash-specific)

## Readability & Maintainability

- Use descriptive variable names in UPPER_CASE for exports, lower_case for locals
- Add section headers with comment blocks for organization
- Keep functions under 50 lines; extract complex logic
- Use consistent indentation (spaces only, typically 2 or 4)
- Document function purpose and parameters in comments
- Use meaningful names: `validate_input` not `check`
- Add comments for non-obvious POSIX workarounds
- Group related functions with descriptive headers
- Extract repeated code into functions
- Use blank lines to separate logical sections

## Safety & Security Patterns

- Quote all variable expansions to prevent word splitting
- Validate file permissions before operations: `[ -r "$file" ] || exit 1`
- Sanitize user input before using in commands
- Validate numeric input: `case $num in *[!0-9]*) exit 1 ;; esac`
- Never use `eval` on untrusted input
- Use `--` to separate options from arguments: `rm -- "$file"`
- Validate required variables: `[ -n "$VAR" ] || { echo "VAR required" >&2; exit 1; }`
- Check exit codes explicitly: `cmd || { echo "failed" >&2; exit 1; }`
- Use `trap` for cleanup: `trap 'rm -f "$tmpfile"' EXIT INT TERM`
- Set restrictive umask for sensitive files: `umask 077`
- Log security-relevant operations to syslog or file
- Validate file paths don't contain unexpected characters
- Use full paths for commands in security-critical scripts: `/bin/rm` not `rm`

## Performance Optimization

- Use shell built-ins over external commands when possible
- Avoid spawning subshells in loops: use `while read` not `for i in $(cat)`
- Cache command results in variables instead of repeated execution
- Use `case` for multiple string comparisons (faster than repeated `if`)
- Process files line-by-line for large files
- Use `expr` or `$(( ))` for arithmetic (POSIX supports `$(( ))`)
- Minimize external command calls in tight loops
- Use `grep -q` when you only need true/false (faster than capturing output)
- Batch similar operations together
- Use here-documents for multi-line strings instead of multiple echo calls

## Documentation Standards

- Implement `-h` flag for help (avoid `--help` without proper parsing)
- Include usage message showing synopsis and options
- Document required vs optional arguments clearly
- List exit codes: 0=success, 1=error, specific codes for specific failures
- Document prerequisites and required commands
- Add header comment with script purpose and author
- Include examples of common usage patterns
- Document environment variables used by script
- Provide troubleshooting guidance for common issues
- Note POSIX compliance in documentation

## Working Without Arrays

Since POSIX sh lacks arrays, use these patterns:

- **Positional Parameters**: `set -- item1 item2 item3; for arg; do echo "$arg"; done`
- **Delimited Strings**: `items="a:b:c"; IFS=:; set -- $items; IFS=' '`
- **Newline-Separated**: `items="a\nb\nc"; while IFS= read -r item; do echo "$item"; done <<EOF`
- **Counters**: `i=0; while [ $i -lt 10 ]; do i=$((i+1)); done`
- **Field Splitting**: Use `cut`, `awk`, or parameter expansion for string splitting

## Portable Conditionals

Use `[ ]` test command with POSIX operators:

- **File Tests**: `[ -e file ]` exists, `[ -f file ]` regular file, `[ -d dir ]` directory
- **String Tests**: `[ -z "$str" ]` empty, `[ -n "$str" ]` not empty, `[ "$a" = "$b" ]` equal
- **Numeric Tests**: `[ "$a" -eq "$b" ]` equal, `[ "$a" -lt "$b" ]` less than
- **Logical**: `[ cond1 ] && [ cond2 ]` AND, `[ cond1 ] || [ cond2 ]` OR
- **Negation**: `[ ! -f file ]` not a file
- **Pattern Matching**: Use `case` not `[[ =~ ]]`

## CI/CD Integration

- **Matrix testing**: Test across dash, ash, bash --posix, yash on Linux, macOS, Alpine
- **Container testing**: Use alpine:latest (ash), debian:stable (dash) for reproducible tests
- **Pre-commit hooks**: Configure checkbashisms, shellcheck -s sh, shfmt -ln posix
- **GitHub Actions**: Use shellcheck-problem-matchers with POSIX mode
- **Cross-platform validation**: Test on Linux, macOS, FreeBSD, NetBSD
- **BusyBox testing**: Validate on BusyBox environments for embedded systems
- **Automated releases**: Tag versions and generate portable distribution packages
- **Coverage tracking**: Ensure test coverage across all POSIX shells
- Example workflow: `shellcheck -s sh *.sh && shfmt -ln posix -d *.sh && checkbashisms *.sh`

## Embedded Systems & Limited Environments

- **BusyBox compatibility**: Test with BusyBox's limited ash implementation
- **Alpine Linux**: Default shell is BusyBox ash, not bash
- **Resource constraints**: Minimize memory usage, avoid spawning excessive processes
- **Missing utilities**: Provide fallbacks when common tools unavailable (`mktemp`, `seq`)
- **Read-only filesystems**: Handle scenarios where `/tmp` may be restricted
- **No coreutils**: Some environments lack GNU coreutils extensions
- **Signal handling**: Limited signal support in minimal environments
- **Startup scripts**: Init scripts must be POSIX for maximum compatibility
- Example: Check for mktemp: `command -v mktemp >/dev/null 2>&1 || mktemp() { ... }`

## Migration from Bash to POSIX sh

- **Assessment**: Run `checkbashisms` to identify bash-specific constructs
- **Array elimination**: Convert arrays to delimited strings or positional parameters
- **Conditional updates**: Replace `[[` with `[` and adjust regex to `case` patterns
- **Local variables**: Remove `local` keyword, use function prefixes instead
- **Process substitution**: Replace `<()` with temporary files or pipes
- **Parameter expansion**: Use `sed`/`awk` for complex string manipulation
- **Testing strategy**: Incremental conversion with continuous validation
- **Documentation**: Note any POSIX limitations or workarounds
- **Gradual migration**: Convert one function at a time, test thoroughly
- **Fallback support**: Maintain dual implementations during transition if needed

## Quality Checklist

- Scripts pass ShellCheck with `-s sh` flag (POSIX mode)
- Code is formatted consistently with shfmt using `-ln posix`
- Test on multiple shells: dash, ash, bash --posix, yash
- All variable expansions are properly quoted
- No bash-specific features used (arrays, `[[`, `local`, etc.)
- Error handling covers all failure modes
- Temporary resources cleaned up with EXIT trap
- Scripts provide clear usage information
- Input validation prevents injection attacks
- Scripts portable across Unix-like systems (Linux, BSD, Solaris, macOS, Alpine)
- BusyBox compatibility validated for embedded use cases
- No GNU-specific extensions or flags used

## Output

- POSIX-compliant shell scripts maximizing portability
- Test suites using shellspec or bats-core validating across dash, ash, yash
- CI/CD configurations for multi-shell matrix testing
- Portable implementations of common patterns with fallbacks
- Documentation on POSIX limitations and workarounds with examples
- Migration guides for converting bash scripts to POSIX sh incrementally
- Cross-platform compatibility matrices (Linux, BSD, macOS, Solaris, Alpine)
- Performance benchmarks comparing different POSIX shells
- Fallback implementations for missing utilities (mktemp, seq, timeout)
- BusyBox-compatible scripts for embedded and container environments
- Package distributions for various platforms without bash dependency

## Essential Tools

### Static Analysis & Formatting

- **ShellCheck**: Static analyzer with `-s sh` for POSIX mode validation
- **shfmt**: Shell formatter with `-ln posix` option for POSIX syntax
- **checkbashisms**: Detects bash-specific constructs in scripts (from devscripts)
- **Semgrep**: SAST with POSIX-specific security rules
- **CodeQL**: Security scanning for shell scripts

### POSIX Shell Implementations for Testing

- **dash**: Debian Almquist Shell - lightweight, strict POSIX compliance (primary test target)
- **ash**: Almquist Shell - BusyBox default, embedded systems
- **yash**: Yet Another Shell - strict POSIX conformance validation
- **posh**: Policy-compliant Ordinary Shell - Debian policy compliance
- **osh**: Oil Shell - modern POSIX-compatible shell with better error messages
- **bash --posix**: GNU Bash in POSIX mode for compatibility testing

### Testing Frameworks

- **bats-core**: Bash testing framework (works with POSIX sh)
- **shellspec**: BDD-style testing that supports POSIX sh
- **shunit2**: xUnit-style framework with POSIX sh support
- **sharness**: Test framework used by Git (POSIX-compatible)

## Common Pitfalls to Avoid

- Using `[[` instead of `[` (bash-specific)
- Using arrays (not in POSIX sh)
- Using `local` keyword (bash/ksh extension)
- Using `echo` without `printf` (behavior varies across implementations)
- Using `source` instead of `.` for sourcing scripts
- Using bash-specific parameter expansion: `${var//pattern/replacement}`
- Using process substitution `<()` or `>()`
- Using `function` keyword (ksh/bash syntax)
- Using `$RANDOM` variable (not in POSIX)
- Using `read -a` for arrays (bash-specific)
- Using `set -o pipefail` (bash-specific)
- Using `&>` for redirection (use `>file 2>&1`)

## Advanced Techniques

- **Error Trapping**: `trap 'echo "Error at line $LINENO" >&2; exit 1' EXIT; trap - EXIT` on success
- **Safe Temp Files**: `tmpfile=$(mktemp) || exit 1; trap 'rm -f "$tmpfile"' EXIT INT TERM`
- **Simulating Arrays**: `set -- item1 item2 item3; for arg; do process "$arg"; done`
- **Field Parsing**: `IFS=:; while read -r user pass uid gid; do ...; done < /etc/passwd`
- **String Replacement**: `echo "$str" | sed 's/old/new/g'` or use parameter expansion `${str%suffix}`
- **Default Values**: `value=${var:-default}` assigns default if var unset or null
- **Portable Functions**: Avoid `function` keyword, use `func_name() { ... }`
- **Subshell Isolation**: `(cd dir && cmd)` changes directory without affecting parent
- **Here-documents**: `cat <<'EOF'` with quotes prevents variable expansion
- **Command Existence**: `command -v cmd >/dev/null 2>&1 && echo "found" || echo "missing"`

## POSIX-Specific Best Practices

- Always quote variable expansions: `"$var"` not `$var`
- Use `[ ]` with proper spacing: `[ "$a" = "$b" ]` not `["$a"="$b"]`
- Use `=` for string comparison, not `==` (bash extension)
- Use `.` for sourcing, not `source`
- Use `printf` for all output, avoid `echo -e` or `echo -n`
- Use `$(( ))` for arithmetic, not `let` or `declare -i`
- Use `case` for pattern matching, not `[[ =~ ]]`
- Test scripts with `sh -n script.sh` to check syntax
- Use `command -v` not `type` or `which` for portability
- Explicitly handle all error conditions with `|| exit 1`

## References & Further Reading

### POSIX Standards & Specifications

- [POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html) - Official POSIX.1-2024 specification
- [POSIX Utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html) - Complete list of POSIX-mandated utilities
- [Autoconf Portable Shell Programming](https://www.gnu.org/software/autoconf/manual/autoconf.html#Portable-Shell) - Comprehensive portability guide from GNU

### Portability & Best Practices

- [Rich's sh (POSIX shell) tricks](http://www.etalabs.net/sh_tricks.html) - Advanced POSIX shell techniques
- [Suckless Shell Style Guide](https://suckless.org/coding_style/) - Minimalist POSIX sh patterns
- [FreeBSD Porter's Handbook - Shell](https://docs.freebsd.org/en/books/porters-handbook/makefiles/#porting-shlibs) - BSD portability considerations

### Tools & Testing

- [checkbashisms](https://manpages.debian.org/testing/devscripts/checkbashisms.1.en.html) - Detect bash-specific constructs

These guidelines provide practices for shell scripting.

## Bash Defensive Patterns

# Bash Defensive Patterns

Comprehensive guidance for writing production-ready Bash scripts using defensive programming techniques, error handling, and safety best practices to prevent common pitfalls and ensure reliability.

## When to Use This Skill

- Writing production automation scripts
- Building CI/CD pipeline scripts
- Creating system administration utilities
- Developing error-resilient deployment automation
- Writing scripts that must handle edge cases safely
- Building maintainable shell script libraries
- Implementing comprehensive logging and monitoring
- Creating scripts that must work across different platforms

## Core Defensive Principles

### 1. Strict Mode

Enable bash strict mode at the start of every script to catch errors early.

```bash
#!/bin/bash
set -Eeuo pipefail  # Exit on error, unset variables, pipe failures
```

**Key flags:**

- `set -E`: Inherit ERR trap in functions
- `set -e`: Exit on any error (command returns non-zero)
- `set -u`: Exit on undefined variable reference
- `set -o pipefail`: Pipe fails if any command fails (not just last)

### 2. Error Trapping and Cleanup

Implement proper cleanup on script exit or error.

```bash
#!/bin/bash
set -Eeuo pipefail

trap 'echo "Error on line $LINENO"' ERR
trap 'echo "Cleaning up..."; rm -rf "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d)
# Script code here
```

### 3. Variable Safety

Always quote variables to prevent word splitting and globbing issues.

```bash
# Wrong - unsafe
cp $source $dest

# Correct - safe
cp "$source" "$dest"

# Required variables - fail with message if unset
: "${REQUIRED_VAR:?REQUIRED_VAR is not set}"
```

### 4. Array Handling

Use arrays safely for complex data handling.

```bash
# Safe array iteration
declare -a items=("item 1" "item 2" "item 3")

for item in "${items[@]}"; do
    echo "Processing: $item"
done

# Reading output into array safely
mapfile -t lines < <(some_command)
readarray -t numbers < <(seq 1 10)
```

### 5. Conditional Safety

Use `[[ ]]` for Bash-specific features, `[ ]` for POSIX.

```bash
# Bash - safer
if [[ -f "$file" && -r "$file" ]]; then
    content=$(<"$file")
fi

# POSIX - portable
if [ -f "$file" ] && [ -r "$file" ]; then
    content=$(cat "$file")
fi

# Test for existence before operations
if [[ -z "${VAR:-}" ]]; then
    echo "VAR is not set or is empty"
fi
```

## Fundamental Patterns

### Pattern 1: Safe Script Directory Detection

```bash
#!/bin/bash
set -Eeuo pipefail

# Correctly determine script directory
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

echo "Script location: $SCRIPT_DIR/$SCRIPT_NAME"
```

### Pattern 2: Comprehensive Function Template

```bash
#!/bin/bash
set -Eeuo pipefail

# Prefix for functions: handle_*, process_*, check_*, validate_*
# Include documentation and error handling

validate_file() {
    local -r file="$1"
    local -r message="${2:-File not found: $file}"

    if [[ ! -f "$file" ]]; then
        echo "ERROR: $message" >&2
        return 1
    fi
    return 0
}

process_files() {
    local -r input_dir="$1"
    local -r output_dir="$2"

    # Validate inputs
    [[ -d "$input_dir" ]] || { echo "ERROR: input_dir not a directory" >&2; return 1; }

    # Create output directory if needed
    mkdir -p "$output_dir" || { echo "ERROR: Cannot create output_dir" >&2; return 1; }

    # Process files safely
    while IFS= read -r -d '' file; do
        echo "Processing: $file"
        # Do work
    done < <(find "$input_dir" -maxdepth 1 -type f -print0)

    return 0
}
```

### Pattern 3: Safe Temporary File Handling

```bash
#!/bin/bash
set -Eeuo pipefail

trap 'rm -rf -- "$TMPDIR"' EXIT

# Create temporary directory
TMPDIR=$(mktemp -d) || { echo "ERROR: Failed to create temp directory" >&2; exit 1; }

# Create temporary files in directory
TMPFILE1="$TMPDIR/temp1.txt"
TMPFILE2="$TMPDIR/temp2.txt"

# Use temporary files
touch "$TMPFILE1" "$TMPFILE2"

echo "Temp files created in: $TMPDIR"
```

### Pattern 4: Robust Argument Parsing

```bash
#!/bin/bash
set -Eeuo pipefail

# Default values
VERBOSE=false
DRY_RUN=false
OUTPUT_FILE=""
THREADS=4

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
    -v, --verbose       Enable verbose output
    -d, --dry-run       Run without making changes
    -o, --output FILE   Output file path
    -j, --jobs NUM      Number of parallel jobs
    -h, --help          Show this help message
EOF
    exit "${1:-0}"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -j|--jobs)
            THREADS="$2"
            shift 2
            ;;
        -h|--help)
            usage 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "ERROR: Unknown option: $1" >&2
            usage 1
            ;;
    esac
done

# Validate required arguments
[[ -n "$OUTPUT_FILE" ]] || { echo "ERROR: -o/--output is required" >&2; usage 1; }
```

### Pattern 5: Structured Logging

```bash
#!/bin/bash
set -Eeuo pipefail

# Logging functions
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" >&2
}

log_warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] WARN: $*" >&2
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

log_debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] DEBUG: $*" >&2
    fi
}

# Usage
log_info "Starting script"
log_debug "Debug information"
log_warn "Warning message"
log_error "Error occurred"
```

### Pattern 6: Process Orchestration with Signals

```bash
#!/bin/bash
set -Eeuo pipefail

# Track background processes
PIDS=()

cleanup() {
    log_info "Shutting down..."

    # Terminate all background processes
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid" 2>/dev/null || true
        fi
    done

    # Wait for graceful shutdown
    for pid in "${PIDS[@]}"; do
        wait "$pid" 2>/dev/null || true
    done
}

trap cleanup SIGTERM SIGINT

# Start background tasks
background_task &
PIDS+=($!)

another_task &
PIDS+=($!)

# Wait for all background processes
wait
```

### Pattern 7: Safe File Operations

```bash
#!/bin/bash
set -Eeuo pipefail

# Use -i flag to move safely without overwriting
safe_move() {
    local -r source="$1"
    local -r dest="$2"

    if [[ ! -e "$source" ]]; then
        echo "ERROR: Source does not exist: $source" >&2
        return 1
    fi

    if [[ -e "$dest" ]]; then
        echo "ERROR: Destination already exists: $dest" >&2
        return 1
    fi

    mv "$source" "$dest"
}

# Safe directory cleanup
safe_rmdir() {
    local -r dir="$1"

    if [[ ! -d "$dir" ]]; then
        echo "ERROR: Not a directory: $dir" >&2
        return 1
    fi

    # Use -I flag to prompt before rm (BSD/GNU compatible)
    rm -rI -- "$dir"
}

# Atomic file writes
atomic_write() {
    local -r target="$1"
    local -r tmpfile
    tmpfile=$(mktemp) || return 1

    # Write to temp file first
    cat > "$tmpfile"

    # Atomic rename
    mv "$tmpfile" "$target"
}
```

### Pattern 8: Idempotent Script Design

```bash
#!/bin/bash
set -Eeuo pipefail

# Check if resource already exists
ensure_directory() {
    local -r dir="$1"

    if [[ -d "$dir" ]]; then
        log_info "Directory already exists: $dir"
        return 0
    fi

    mkdir -p "$dir" || {
        log_error "Failed to create directory: $dir"
        return 1
    }

    log_info "Created directory: $dir"
}

# Ensure configuration state
ensure_config() {
    local -r config_file="$1"
    local -r default_value="$2"

    if [[ ! -f "$config_file" ]]; then
        echo "$default_value" > "$config_file"
        log_info "Created config: $config_file"
    fi
}

# Rerunning script multiple times should be safe
ensure_directory "/var/cache/myapp"
ensure_config "/etc/myapp/config" "DEBUG=false"
```

### Pattern 9: Safe Command Substitution

```bash
#!/bin/bash
set -Eeuo pipefail

# Use $() instead of backticks
name=$(<"$file")  # Modern, safe variable assignment from file
output=$(command -v python3)  # Get command location safely

# Handle command substitution with error checking
result=$(command -v node) || {
    log_error "node command not found"
    return 1
}

# For multiple lines
mapfile -t lines < <(grep "pattern" "$file")

# NUL-safe iteration
while IFS= read -r -d '' file; do
    echo "Processing: $file"
done < <(find /path -type f -print0)
```

### Pattern 10: Dry-Run Support

```bash
#!/bin/bash
set -Eeuo pipefail

DRY_RUN="${DRY_RUN:-false}"

run_cmd() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY RUN] Would execute: $*"
        return 0
    fi

    "$@"
}

# Usage
run_cmd cp "$source" "$dest"
run_cmd rm "$file"
run_cmd chown "$owner" "$target"
```

## Advanced Defensive Techniques

### Named Parameters Pattern

```bash
#!/bin/bash
set -Eeuo pipefail

process_data() {
    local input_file=""
    local output_dir=""
    local format="json"

    # Parse named parameters
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --input=*)
                input_file="${1#*=}"
                ;;
            --output=*)
                output_dir="${1#*=}"
                ;;
            --format=*)
                format="${1#*=}"
                ;;
            *)
                echo "ERROR: Unknown parameter: $1" >&2
                return 1
                ;;
        esac
        shift
    done

    # Validate required parameters
    [[ -n "$input_file" ]] || { echo "ERROR: --input is required" >&2; return 1; }
    [[ -n "$output_dir" ]] || { echo "ERROR: --output is required" >&2; return 1; }
}
```

### Dependency Checking

```bash
#!/bin/bash
set -Eeuo pipefail

check_dependencies() {
    local -a missing_deps=()
    local -a required=("jq" "curl" "git")

    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "ERROR: Missing required commands: ${missing_deps[*]}" >&2
        return 1
    fi
}

check_dependencies
```

## Best Practices Summary

1. **Always use strict mode** - `set -Eeuo pipefail`
2. **Quote all variables** - `"$variable"` prevents word splitting
3. **Use [[]] conditionals** - More robust than [ ]
4. **Implement error trapping** - Catch and handle errors gracefully
5. **Validate all inputs** - Check file existence, permissions, formats
6. **Use functions for reusability** - Prefix with meaningful names
7. **Implement structured logging** - Include timestamps and levels
8. **Support dry-run mode** - Allow users to preview changes
9. **Handle temporary files safely** - Use mktemp, cleanup with trap
10. **Design for idempotency** - Scripts should be safe to rerun
11. **Document requirements** - List dependencies and minimum versions
12. **Test error paths** - Ensure error handling works correctly
13. **Use `command -v`** - Safer than `which` for checking executables
14. **Prefer printf over echo** - More predictable across systems

## Resources

- **Bash Strict Mode**: <http://redsymbol.net/articles/unofficial-bash-strict-mode/>
- **Google Shell Style Guide**: <https://google.github.io/styleguide/shellguide.html>
- **Defensive BASH Programming**: <https://www.lifepipe.net/>

## Bats Testing Patterns

# Bats Testing Patterns

Comprehensive guidance for writing comprehensive unit tests for shell scripts using Bats (Bash Automated Testing System), including test patterns, fixtures, and best practices for production-grade shell testing.

## When to Use This Skill

- Writing unit tests for shell scripts
- Implementing test-driven development (TDD) for scripts
- Setting up automated testing in CI/CD pipelines
- Testing edge cases and error conditions
- Validating behavior across different shell environments
- Building maintainable test suites for scripts
- Creating fixtures for complex test scenarios
- Testing multiple shell dialects (bash, sh, dash)

## Bats Fundamentals

### What is Bats?

Bats (Bash Automated Testing System) is a TAP (Test Anything Protocol) compliant testing framework for shell scripts that provides:

- Simple, natural test syntax
- TAP output format compatible with CI systems
- Fixtures and setup/teardown support
- Assertion helpers
- Parallel test execution

### Installation

```bash
# macOS with Homebrew
brew install bats-core

# Ubuntu/Debian
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local

# From npm (Node.js)
npm install --global bats

# Verify installation
bats --version
```

### File Structure

```
project/
├── bin/
│   ├── script.sh
│   └── helper.sh
├── tests/
│   ├── test_script.bats
│   ├── test_helper.sh
│   ├── fixtures/
│   │   ├── input.txt
│   │   └── expected_output.txt
│   └── helpers/
│       └── mocks.bash
└── README.md
```

## Basic Test Structure

### Simple Test File

```bash
#!/usr/bin/env bats

# Load test helper if present
load test_helper

# Setup runs before each test
setup() {
    export TMPDIR=$(mktemp -d)
}

# Teardown runs after each test
teardown() {
    rm -rf "$TMPDIR"
}

# Test: simple assertion
@test "Function returns 0 on success" {
    run my_function "input"
    [ "$status" -eq 0 ]
}

# Test: output verification
@test "Function outputs correct result" {
    run my_function "test"
    [ "$output" = "expected output" ]
}

# Test: error handling
@test "Function returns 1 on missing argument" {
    run my_function
    [ "$status" -eq 1 ]
}
```

## Assertion Patterns

### Exit Code Assertions

```bash
#!/usr/bin/env bats

@test "Command succeeds" {
    run true
    [ "$status" -eq 0 ]
}

@test "Command fails as expected" {
    run false
    [ "$status" -ne 0 ]
}

@test "Command returns specific exit code" {
    run my_function --invalid
    [ "$status" -eq 127 ]
}

@test "Can capture command result" {
    run echo "hello"
    [ $status -eq 0 ]
    [ "$output" = "hello" ]
}
```

### Output Assertions

```bash
#!/usr/bin/env bats

@test "Output matches string" {
    result=$(echo "hello world")
    [ "$result" = "hello world" ]
}

@test "Output contains substring" {
    result=$(echo "hello world")
    [[ "$result" == *"world"* ]]
}

@test "Output matches pattern" {
    result=$(date +%Y)
    [[ "$result" =~ ^[0-9]{4}$ ]]
}

@test "Multi-line output" {
    run printf "line1\nline2\nline3"
    [ "$output" = "line1
line2
line3" ]
}

@test "Lines variable contains output" {
    run printf "line1\nline2\nline3"
    [ "${lines[0]}" = "line1" ]
    [ "${lines[1]}" = "line2" ]
    [ "${lines[2]}" = "line3" ]
}
```

### File Assertions

```bash
#!/usr/bin/env bats

@test "File is created" {
    [ ! -f "$TMPDIR/output.txt" ]
    my_function > "$TMPDIR/output.txt"
    [ -f "$TMPDIR/output.txt" ]
}

@test "File contents match expected" {
    my_function > "$TMPDIR/output.txt"
    [ "$(cat "$TMPDIR/output.txt")" = "expected content" ]
}

@test "File is readable" {
    touch "$TMPDIR/test.txt"
    [ -r "$TMPDIR/test.txt" ]
}

@test "File has correct permissions" {
    touch "$TMPDIR/test.txt"
    chmod 644 "$TMPDIR/test.txt"
    [ "$(stat -f %OLp "$TMPDIR/test.txt")" = "644" ]
}

@test "File size is correct" {
    echo -n "12345" > "$TMPDIR/test.txt"
    [ "$(wc -c < "$TMPDIR/test.txt")" -eq 5 ]
}
```

## Setup and Teardown Patterns

### Basic Setup and Teardown

```bash
#!/usr/bin/env bats

setup() {
    # Create test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR

    # Source script under test
    source "${BATS_TEST_DIRNAME}/../bin/script.sh"
}

teardown() {
    # Clean up temporary directory
    rm -rf "$TEST_DIR"
}

@test "Test using TEST_DIR" {
    touch "$TEST_DIR/file.txt"
    [ -f "$TEST_DIR/file.txt" ]
}
```

### Setup with Resources

```bash
#!/usr/bin/env bats

setup() {
    # Create directory structure
    mkdir -p "$TMPDIR/data/input"
    mkdir -p "$TMPDIR/data/output"

    # Create test fixtures
    echo "line1" > "$TMPDIR/data/input/file1.txt"
    echo "line2" > "$TMPDIR/data/input/file2.txt"

    # Initialize environment
    export DATA_DIR="$TMPDIR/data"
    export INPUT_DIR="$DATA_DIR/input"
    export OUTPUT_DIR="$DATA_DIR/output"
}

teardown() {
    rm -rf "$TMPDIR/data"
}

@test "Processes input files" {
    run my_process_script "$INPUT_DIR" "$OUTPUT_DIR"
    [ "$status" -eq 0 ]
    [ -f "$OUTPUT_DIR/file1.txt" ]
}
```

### Global Setup/Teardown

```bash
#!/usr/bin/env bats

# Load shared setup from test_helper.sh
load test_helper

# setup_file runs once before all tests
setup_file() {
    export SHARED_RESOURCE=$(mktemp -d)
    echo "Expensive setup" > "$SHARED_RESOURCE/data.txt"
}

# teardown_file runs once after all tests
teardown_file() {
    rm -rf "$SHARED_RESOURCE"
}

@test "First test uses shared resource" {
    [ -f "$SHARED_RESOURCE/data.txt" ]
}

@test "Second test uses shared resource" {
    [ -d "$SHARED_RESOURCE" ]
}
```

## Mocking and Stubbing Patterns

### Function Mocking

```bash
#!/usr/bin/env bats

# Mock external command
my_external_tool() {
    echo "mocked output"
    return 0
}

@test "Function uses mocked tool" {
    export -f my_external_tool
    run my_function
    [[ "$output" == *"mocked output"* ]]
}
```

### Command Stubbing

```bash
#!/usr/bin/env bats

setup() {
    # Create stub directory
    STUBS_DIR="$TMPDIR/stubs"
    mkdir -p "$STUBS_DIR"

    # Add to PATH
    export PATH="$STUBS_DIR:$PATH"
}

create_stub() {
    local cmd="$1"
    local output="$2"
    local code="${3:-0}"

    cat > "$STUBS_DIR/$cmd" <<EOF
#!/bin/bash
echo "$output"
exit $code
EOF
    chmod +x "$STUBS_DIR/$cmd"
}

@test "Function works with stubbed curl" {
    create_stub curl "{ \"status\": \"ok\" }" 0
    run my_api_function
    [ "$status" -eq 0 ]
}
```

### Variable Stubbing

```bash
#!/usr/bin/env bats

@test "Function handles environment override" {
    export MY_SETTING="override_value"
    run my_function
    [ "$status" -eq 0 ]
    [[ "$output" == *"override_value"* ]]
}

@test "Function uses default when var unset" {
    unset MY_SETTING
    run my_function
    [ "$status" -eq 0 ]
    [[ "$output" == *"default"* ]]
}
```

## Fixture Management

### Using Fixture Files

```bash
#!/usr/bin/env bats

# Fixture directory: tests/fixtures/

setup() {
    FIXTURES_DIR="${BATS_TEST_DIRNAME}/fixtures"
    WORK_DIR=$(mktemp -d)
    export WORK_DIR
}

teardown() {
    rm -rf "$WORK_DIR"
}

@test "Process fixture file" {
    # Copy fixture to work directory
    cp "$FIXTURES_DIR/input.txt" "$WORK_DIR/input.txt"

    # Run function
    run my_process_function "$WORK_DIR/input.txt"

    # Compare output
    diff "$WORK_DIR/output.txt" "$FIXTURES_DIR/expected_output.txt"
}
```

### Dynamic Fixture Generation

```bash
#!/usr/bin/env bats

generate_fixture() {
    local lines="$1"
    local file="$2"

    for i in $(seq 1 "$lines"); do
        echo "Line $i content" >> "$file"
    done
}

@test "Handle large input file" {
    generate_fixture 1000 "$TMPDIR/large.txt"
    run my_function "$TMPDIR/large.txt"
    [ "$status" -eq 0 ]
    [ "$(wc -l < "$TMPDIR/large.txt")" -eq 1000 ]
}
```

## Advanced Patterns

### Testing Error Conditions

```bash
#!/usr/bin/env bats

@test "Function fails with missing file" {
    run my_function "/nonexistent/file.txt"
    [ "$status" -ne 0 ]
    [[ "$output" == *"not found"* ]]
}

@test "Function fails with invalid input" {
    run my_function ""
    [ "$status" -ne 0 ]
}

@test "Function fails with permission denied" {
    touch "$TMPDIR/readonly.txt"
    chmod 000 "$TMPDIR/readonly.txt"
    run my_function "$TMPDIR/readonly.txt"
    [ "$status" -ne 0 ]
    chmod 644 "$TMPDIR/readonly.txt"  # Cleanup
}

@test "Function provides helpful error message" {
    run my_function --invalid-option
    [ "$status" -ne 0 ]
    [[ "$output" == *"Usage:"* ]]
}
```

### Testing with Dependencies

```bash
#!/usr/bin/env bats

setup() {
    # Check for required tools
    if ! command -v jq &>/dev/null; then
        skip "jq is not installed"
    fi

    export SCRIPT="${BATS_TEST_DIRNAME}/../bin/script.sh"
}

@test "JSON parsing works" {
    skip_if ! command -v jq &>/dev/null
    run my_json_parser '{"key": "value"}'
    [ "$status" -eq 0 ]
}
```

### Testing Shell Compatibility

```bash
#!/usr/bin/env bats

@test "Script works in bash" {
    bash "${BATS_TEST_DIRNAME}/../bin/script.sh" arg1
}

@test "Script works in sh (POSIX)" {
    sh "${BATS_TEST_DIRNAME}/../bin/script.sh" arg1
}

@test "Script works in dash" {
    if command -v dash &>/dev/null; then
        dash "${BATS_TEST_DIRNAME}/../bin/script.sh" arg1
    else
        skip "dash not installed"
    fi
}
```

### Parallel Execution

```bash
#!/usr/bin/env bats

@test "Multiple independent operations" {
    run bash -c 'for i in {1..10}; do
        my_operation "$i" &
    done
    wait'
    [ "$status" -eq 0 ]
}

@test "Concurrent file operations" {
    for i in {1..5}; do
        my_function "$TMPDIR/file$i" &
    done
    wait
    [ -f "$TMPDIR/file1" ]
    [ -f "$TMPDIR/file5" ]
}
```

## Test Helper Pattern

### test_helper.sh

```bash
#!/usr/bin/env bash

# Source script under test
export SCRIPT_DIR="${BATS_TEST_DIRNAME%/*}/bin"

# Common test utilities
assert_file_exists() {
    if [ ! -f "$1" ]; then
        echo "Expected file to exist: $1"
        return 1
    fi
}

assert_file_equals() {
    local file="$1"
    local expected="$2"

    if [ ! -f "$file" ]; then
        echo "File does not exist: $file"
        return 1
    fi

    local actual=$(cat "$file")
    if [ "$actual" != "$expected" ]; then
        echo "File contents do not match"
        echo "Expected: $expected"
        echo "Actual: $actual"
        return 1
    fi
}

# Create temporary test directory
setup_test_dir() {
    export TEST_DIR=$(mktemp -d)
}

cleanup_test_dir() {
    rm -rf "$TEST_DIR"
}
```

## Integration with CI/CD

### GitHub Actions Workflow

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Install Bats
        run: |
          npm install --global bats

      - name: Run Tests
        run: |
          bats tests/*.bats

      - name: Run Tests with Tap Reporter
        run: |
          bats tests/*.bats --tap | tee test_output.tap
```

### Makefile Integration

```makefile
.PHONY: test test-verbose test-tap

test:
 bats tests/*.bats

test-verbose:
 bats tests/*.bats --verbose

test-tap:
 bats tests/*.bats --tap

test-parallel:
 bats tests/*.bats --parallel 4

coverage: test
 # Optional: Generate coverage reports
```

## Best Practices

1. **Test one thing per test** - Single responsibility principle
2. **Use descriptive test names** - Clearly states what is being tested
3. **Clean up after tests** - Always remove temporary files in teardown
4. **Test both success and failure paths** - Don't just test happy path
5. **Mock external dependencies** - Isolate unit under test
6. **Use fixtures for complex data** - Makes tests more readable
7. **Run tests in CI/CD** - Catch regressions early
8. **Test across shell dialects** - Ensure portability
9. **Keep tests fast** - Run in parallel when possible
10. **Document complex test setup** - Explain unusual patterns

## Resources

- **Bats GitHub**: <https://github.com/bats-core/bats-core>
- **Bats Documentation**: <https://bats-core.readthedocs.io/>
- **TAP Protocol**: <https://testanything.org/>
- **Test-Driven Development**: <https://en.wikipedia.org/wiki/Test-driven_development>

## Shellcheck Configuration

# ShellCheck Configuration and Static Analysis

Comprehensive guidance for configuring and using ShellCheck to improve shell script quality, catch common pitfalls, and enforce best practices through static code analysis.

## When to Use This Skill

- Setting up linting for shell scripts in CI/CD pipelines
- Analyzing existing shell scripts for issues
- Understanding ShellCheck error codes and warnings
- Configuring ShellCheck for specific project requirements
- Integrating ShellCheck into development workflows
- Suppressing false positives and configuring rule sets
- Enforcing consistent code quality standards
- Migrating scripts to meet quality gates

## ShellCheck Fundamentals

### What is ShellCheck?

ShellCheck is a static analysis tool that analyzes shell scripts and detects problematic patterns. It supports:

- Bash, sh, dash, ksh, and other POSIX shells
- Over 100 different warnings and errors
- Configuration for target shell and flags
- Integration with editors and CI/CD systems

### Installation

```bash
# macOS with Homebrew
brew install shellcheck

# Ubuntu/Debian
apt-get install shellcheck

# From source
git clone https://github.com/koalaman/shellcheck.git
cd shellcheck
make build
make install

# Verify installation
shellcheck --version
```

## Configuration Files

### .shellcheckrc (Project Level)

Create `.shellcheckrc` in your project root:

```
# Specify target shell
shell=bash

# Enable optional checks
enable=avoid-nullary-conditions
enable=require-variable-braces

# Disable specific warnings
disable=SC1091
disable=SC2086
```

### Environment Variables

```bash
# Set default shell target
export SHELLCHECK_SHELL=bash

# Enable strict mode
export SHELLCHECK_STRICT=true

# Specify configuration file location
export SHELLCHECK_CONFIG=~/.shellcheckrc
```

## Common ShellCheck Error Codes

### SC1000-1099: Parser Errors

```bash
# SC1004: Backslash continuation not followed by newline
echo hello\
world  # Error - needs line continuation

# SC1008: Invalid data for operator `=='
if [[ $var =  "value" ]]; then  # Space before ==
    true
fi
```

### SC2000-2099: Shell Issues

```bash
# SC2009: Consider using pgrep or pidof instead of grep|grep
ps aux | grep -v grep | grep myprocess  # Use pgrep instead

# SC2012: Use `ls` only for viewing. Use `find` for reliable output
for file in $(ls -la)  # Better: use find or globbing

# SC2015: Avoid using && and || instead of if-then-else
[[ -f "$file" ]] && echo "found" || echo "not found"  # Less clear

# SC2016: Expressions don't expand in single quotes
echo '$VAR'  # Literal $VAR, not variable expansion

# SC2026: This word is non-standard. Set POSIXLY_CORRECT
# when using with scripts for other shells
```

### SC2100-2199: Quoting Issues

```bash
# SC2086: Double quote to prevent globbing and word splitting
for i in $list; do  # Should be: for i in $list or for i in "$list"
    echo "$i"
done

# SC2115: Literal tilde in path not expanded. Use $HOME instead
~/.bashrc  # In strings, use "$HOME/.bashrc"

# SC2181: Check exit code directly with `if`, not indirectly in a list
some_command
if [ $? -eq 0 ]; then  # Better: if some_command; then

# SC2206: Quote to prevent word splitting or set IFS
array=( $items )  # Should use: array=( $items )
```

### SC3000-3999: POSIX Compliance Issues

```bash
# SC3010: In POSIX sh, use 'case' instead of 'cond && foo'
[[ $var == "value" ]] && do_something  # Not POSIX

# SC3043: In POSIX sh, use 'local' is undefined
function my_func() {
    local var=value  # Not POSIX in some shells
}
```

## Practical Configuration Examples

### Minimal Configuration (Strict POSIX)

```bash
#!/bin/bash
# Configure for maximum portability

shellcheck \
  --shell=sh \
  --external-sources \
  --check-sourced \
  script.sh
```

### Development Configuration (Bash with Relaxed Rules)

```bash
#!/bin/bash
# Configure for Bash development

shellcheck \
  --shell=bash \
  --exclude=SC1091,SC2119 \
  --enable=all \
  script.sh
```

### CI/CD Integration Configuration

```bash
#!/bin/bash
set -Eeuo pipefail

# Analyze all shell scripts and fail on issues
find . -type f -name "*.sh" | while read -r script; do
    echo "Checking: $script"
    shellcheck \
        --shell=bash \
        --format=gcc \
        --exclude=SC1091 \
        "$script" || exit 1
done
```

### .shellcheckrc for Project

```
# Shell dialect to analyze against
shell=bash

# Enable optional checks
enable=avoid-nullary-conditions,require-variable-braces,check-unassigned-uppercase

# Disable specific warnings
# SC1091: Not following sourced files (many false positives)
disable=SC1091

# SC2119: Use function_name instead of function_name -- (arguments)
disable=SC2119

# External files to source for context
external-sources=true
```

## Integration Patterns

### Pre-commit Hook Configuration

```bash
#!/bin/bash
# .git/hooks/pre-commit

#!/bin/bash
set -e

# Find all shell scripts changed in this commit
git diff --cached --name-only | grep '\.sh$' | while read -r script; do
    echo "Linting: $script"

    if ! shellcheck "$script"; then
        echo "ShellCheck failed on $script"
        exit 1
    fi
done
```

### GitHub Actions Workflow

```yaml
name: ShellCheck

on: [push, pull_request]

jobs:
  shellcheck:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Run ShellCheck
        run: |
          sudo apt-get install shellcheck
          find . -type f -name "*.sh" -exec shellcheck {} \;
```

### GitLab CI Pipeline

```yaml
shellcheck:
  stage: lint
  image: koalaman/shellcheck-alpine
  script:
    - find . -type f -name "*.sh" -exec shellcheck {} \;
  allow_failure: false
```

## Handling ShellCheck Violations

### Suppressing Specific Warnings

```bash
#!/bin/bash

# Disable warning for entire line
# shellcheck disable=SC2086
for file in $(ls -la); do
    echo "$file"
done

# Disable for entire script
# shellcheck disable=SC1091,SC2119

# Disable multiple warnings (format varies)
command_that_fails() {
    # shellcheck disable=SC2015
    [ -f "$1" ] && echo "found" || echo "not found"
}

# Disable specific check for source directive
# shellcheck source=./helper.sh
source helper.sh
```

### Common Violations and Fixes

#### SC2086: Double quote to prevent word splitting

```bash
# Problem
for i in $list; do done

# Solution
for i in $list; do done  # If $list is already quoted, or
for i in "${list[@]}"; do done  # If list is an array
```

#### SC2181: Check exit code directly

```bash
# Problem
some_command
if [ $? -eq 0 ]; then
    echo "success"
fi

# Solution
if some_command; then
    echo "success"
fi
```

#### SC2015: Use if-then instead of && ||

```bash
# Problem
[ -f "$file" ] && echo "exists" || echo "not found"

# Solution - clearer intent
if [ -f "$file" ]; then
    echo "exists"
else
    echo "not found"
fi
```

#### SC2016: Expressions don't expand in single quotes

```bash
# Problem
echo 'Variable value: $VAR'

# Solution
echo "Variable value: $VAR"
```

#### SC2009: Use pgrep instead of grep

```bash
# Problem
ps aux | grep -v grep | grep myprocess

# Solution
pgrep -f myprocess
```

## Performance Optimization

### Checking Multiple Files

```bash
#!/bin/bash

# Sequential checking
for script in *.sh; do
    shellcheck "$script"
done

# Parallel checking (faster)
find . -name "*.sh" -print0 | \
    xargs -0 -P 4 -n 1 shellcheck
```

### Caching Results

```bash
#!/bin/bash

CACHE_DIR=".shellcheck_cache"
mkdir -p "$CACHE_DIR"

check_script() {
    local script="$1"
    local hash
    local cache_file

    hash=$(sha256sum "$script" | cut -d' ' -f1)
    cache_file="$CACHE_DIR/$hash"

    if [[ ! -f "$cache_file" ]]; then
        if shellcheck "$script" > "$cache_file" 2>&1; then
            touch "$cache_file.ok"
        else
            return 1
        fi
    fi

    [[ -f "$cache_file.ok" ]]
}

find . -name "*.sh" | while read -r script; do
    check_script "$script" || exit 1
done
```

## Output Formats

### Default Format

```bash
shellcheck script.sh

# Output:
# script.sh:1:3: warning: foo is referenced but not assigned. [SC2154]
```

### GCC Format (for CI/CD)

```bash
shellcheck --format=gcc script.sh

# Output:
# script.sh:1:3: warning: foo is referenced but not assigned.
```

### JSON Format (for parsing)

```bash
shellcheck --format=json script.sh

# Output:
# [{"file": "script.sh", "line": 1, "column": 3, "level": "warning", "code": 2154, "message": "..."}]
```

### Quiet Format

```bash
shellcheck --format=quiet script.sh

# Returns non-zero if issues found, no output otherwise
```

## Best Practices

1. **Run ShellCheck in CI/CD** - Catch issues before merging
2. **Configure for your target shell** - Don't analyze bash as sh
3. **Document exclusions** - Explain why violations are suppressed
4. **Address violations** - Don't just disable warnings
5. **Enable strict mode** - Use `--enable=all` with careful exclusions
6. **Update regularly** - Keep ShellCheck current for new checks
7. **Use pre-commit hooks** - Catch issues locally before pushing
8. **Integrate with editors** - Get real-time feedback during development

## Resources

- **ShellCheck GitHub**: <https://github.com/koalaman/shellcheck>
- **ShellCheck Wiki**: <https://www.shellcheck.net/wiki/>
- **Error Code Reference**: <https://www.shellcheck.net/>
