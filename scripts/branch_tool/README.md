# Branch Tool

A zsh script that automates git branch creation and changelog management for ticket-based development workflows.

## Features

- 🚀 **Dual usage modes**: Both positional and flag-based arguments
- 🔄 **Flexible change types**: Accept both short (`f`) and long (`fixed`) forms
- 💬 **Quote-free messages**: No need to wrap simple messages in quotes
- 📝 **Automatic changelog updates**: Adds entries to the correct changelog sections
- 🌳 **Consistent branch naming**: Generates descriptive branch names with ticket references
- ⚡ **Silent operation**: Only outputs errors, perfect for automation
- 🎯 **Smart validation**: Ensures ticket numbers are numeric and required fields are present
- ✨ **Auto-capitalization**: Automatically capitalizes the first letter of messages

## Installation

1. Copy the script to your desired location:
   ```bash
   cp branch_tool.zsh /path/to/your/scripts/
   chmod +x /path/to/your/scripts/branch_tool.zsh
   ```

2. (Optional) Set up an alias for easier access:
   ```bash
   # Add to your ~/.zshrc
   alias branch="/path/to/your/scripts/branch_tool.zsh"
   
   # Reload your shell
   source ~/.zshrc
   ```

## Usage

### Positional Mode (Recommended)
```bash
branch_tool.zsh CHANGE_TYPE TICKET_NUMBER "MESSAGE"

branch_tool.zsh CHANGE_TYPE TICKET_NUMBER MESSAGE WORDS...
```

### Flag Mode
```bash
branch_tool.zsh -t TICKET_NUMBER -m MESSAGE -CHANGE_FLAG
```

### Arguments

| Argument | Description | Examples |
|----------|-------------|----------|
| `CHANGE_TYPE` | Short or long form | `f`/`fixed`, `a`/`added`, `c`/`changed`, `r`/`removed`, `w`/`wip` |
| `TICKET_NUMBER` | Numeric ticket ID | `1234` |
| `MESSAGE` | Short, descriptive message | Can be quoted or unquoted |

### Change Types

| Short | Long | Type | Description |
|-------|------|------|-------------|
| `a` | `added` | Added | New features |
| `c` | `changed` | Changed | Changes in existing functionality |
| `r` | `removed` | Removed | Removed features |
| `f` | `fixed` | Fixed | Bug fixes |
| `w` | `wip` | Work in progress | Incomplete work |

## Examples

### Positional Mode - Short Form
```bash
# Fix a bug (with quotes)
./branch_tool.zsh f 1234 "Fix user authentication bug"

# Fix a bug (without quotes - auto-capitalized)
./branch_tool.zsh f 1234 fix user authentication bug

# Add a new feature
./branch_tool.zsh a 5678 add dark mode support

# Update existing functionality
./branch_tool.zsh c 9012 update API endpoint structure
```

### Positional Mode - Long Form
```bash
# Fix a bug (descriptive and no quotes needed!)
./branch_tool.zsh fixed 1234 resolve authentication timeout issue

# Add a new feature
./branch_tool.zsh added 5678 implement user preference settings

# Change existing functionality
./branch_tool.zsh changed 9012 refactor database connection pooling
```

### Flag Mode
```bash
# Fix a bug
./branch_tool.zsh -t 1234 -m "Fix user authentication bug" -f

# Add a new feature
./branch_tool.zsh -t 5678 -m "Add dark mode support" -a
```

### With Alias
```bash
# Much cleaner with an alias!
branch fixed 1234 resolve authentication timeout
branch added 5678 implement user preferences
branch changed 9012 refactor connection pooling
```

## What It Does

1. **Creates a new git branch** with the format: `{type}/{squad}-{ticket}_{message_slug}`
   - Example: `fixed/APO-1234_fix_user_authentication_bug`

2. **Updates your CHANGELOG.md** by adding an entry under the appropriate section:
   - Format: `- {Message} [{squad}-{ticket}](https://wearepion.atlassian.net/browse/{squad}-{ticket})`
   - Note: Messages are automatically capitalized

3. **Commits the changelog** with a descriptive commit message

## Setup Tips

### Create an Alias

Add this to your `~/.zshrc` for easier access:

```bash
# Simple alias
alias branch="/path/to/branch_tool.zsh"

# Or if the script is in your PATH
alias branch="branch_tool.zsh"
```

### Enhanced Zsh Completions

Create a completion function for enhanced productivity. Add this to your `~/.zshrc` or a completion file:

```bash
# Branch tool completions with flexible change types
_branch_tool() {
    local context state line
    typeset -A opt_args

    # Define the completion spec
    _arguments -C \
        '(-h --help)'{-h,--help}'[Show help message]' \
        '(-t --ticket-number)'{-t,--ticket-number}'[Ticket number]:ticket number:' \
        '(-m --message)'{-m,--message}'[Commit message]:message:' \
        '(-a -c -r -f -w)-a[Added - new features]' \
        '(-a -c -r -f -w)-c[Changed - changes in existing functionality]' \
        '(-a -c -r -f -w)-r[Removed - removed features]' \
        '(-a -c -r -f -w)-f[Fixed - bug fixes]' \
        '(-a -c -r -f -w)-w[Work in progress]' \
        '1:change type:(a added c changed r removed f fixed w wip)' \
        '2:ticket number:' \
        '*:message words:'
}

# Register the completion function
compdef _branch_tool branch_tool.zsh

# If you're using an alias, register it too
compdef _branch_tool branch
```

This enhanced completion provides:

- **Tab completion** for both short and long change types:
  - `a`, `added`
  - `c`, `changed` 
  - `r`, `removed`
  - `f`, `fixed`
  - `w`, `wip`
- **Multiple word support** for messages (using `*:message words:`)
- **Flag completion** with descriptions
- **Help text** for each option

After adding this, restart your shell or run `source ~/.zshrc`. You can then type:

```bash
branch <TAB>        # Shows: a added c changed r removed f fixed w wip
branch f<TAB>       # Completes to: fixed
branch fixed 1234 <TAB>  # Ready for your message
```

### Advanced Alias with Validation

For extra safety, you can create an alias that validates you're in a git repository:

```bash
branch() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "Error: Not in a git repository" >&2
        return 1
    fi
    /path/to/branch_tool.zsh "$@"
}
```

## Workflow Examples

### Quick Daily Usage (No Quotes Needed!)
```bash
# Morning bug fixes
branch fixed 1234 resolve login timeout
branch fixed 1235 fix responsive layout on mobile

# Afternoon feature work  
branch added 1236 implement user avatar upload
branch changed 1237 update navigation menu design

# End of day cleanup
branch removed 1238 remove deprecated API endpoints
```

### Traditional Usage (Still Works!)
```bash
branch f 1234 "Fix login timeout"
branch a 1235 "Add user avatars"
branch c 1236 "Update navigation"
```

## Requirements

- **zsh shell** (uses zsh-specific features like `zparseopts`)
- **git** (for branch creation and commits)
- **CHANGELOG.md** file with appropriate sections:
  ```markdown
  ## Added
  
  ## Changed
  
  ## Removed
  
  ## Fixed
  
  ## Work in progress
  ```

## Configuration

The script uses these configurable constants at the top:

```bash
SQUAD_NAME="APO"
TICKET_URL_PREFIX="https://wearepion.atlassian.net/browse/${SQUAD_NAME}-"
CHANGELOG_FILE="CHANGELOG.md"
```

Modify these if your ticket system or changelog file differs.

## Troubleshooting

### "Invalid change type"
Make sure you're using one of the supported change types:
- **Short**: `a`, `c`, `r`, `f`, `w`
- **Long**: `added`, `changed`, `removed`, `fixed`, `wip`

Case doesn't matter: `Fixed`, `FIXED`, and `fixed` all work.

### "Section not found in CHANGELOG.md"
Ensure your CHANGELOG.md has the required sections:
- `## Added`
- `## Changed` 
- `## Removed`
- `## Fixed`
- `## Work in progress`

### "Not in a git repository"
Run the script from within a git repository, or initialize one with `git init`.

### Permission denied
Make sure the script is executable:
```bash
chmod +x branch_tool.zsh
```

## Contributing

Feel free to submit issues or pull requests to improve the tool!