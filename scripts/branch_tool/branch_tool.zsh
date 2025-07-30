#!/bin/zsh

set -eo pipefail

# Configuration
readonly SQUAD_NAME="APO"
readonly TICKET_URL_PREFIX="https://wearepion.atlassian.net/browse/${SQUAD_NAME}-"
readonly CHANGELOG_FILE="CHANGELOG.md"

# Try to get the actual command name used (handles aliases better)
get_command_name() {
    # Check if we can get the command from the process command line
    local cmd_from_ps
    if cmd_from_ps=$(ps -o args= -p $ 2>/dev/null | awk '{print $2}'); then
        # If it looks like our script was called via alias, use the alias name
        if [[ "$cmd_from_ps" =~ branch$ ]]; then
            echo "branch"
            return
        fi
    fi

    # Fallback to basename of $0
    echo "${0##*/}"
}

readonly SCRIPT_NAME=$(get_command_name)

# Global variables
ticket_number=""
message=""
change_type=""
branch_name=""

#==============================================================================
# Helper Functions
#==============================================================================

log_error() {
    echo "Error: $*" >&2
}

run_command() {
    if ! "$@" 2>/dev/null; then
        log_error "Command failed: $*"
        exit 1
    fi
}

# Capitalize first letter of a string
capitalize_first() {
    local str="$1"
    echo "${str:0:1:u}${str:1}"
}

#==============================================================================
# Usage and Argument Parsing
#==============================================================================

show_usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] or $SCRIPT_NAME CHANGE_TYPE TICKET_NUMBER MESSAGE...

Flag-based usage:
  $SCRIPT_NAME -t TICKET_NUMBER -m MESSAGE [CHANGE_TYPE]

Positional usage:
  $SCRIPT_NAME CHANGE_TYPE TICKET_NUMBER MESSAGE...

Arguments:
  CHANGE_TYPE           One of: a/added, c/changed, r/removed, f/fixed, w/wip
  TICKET_NUMBER         The ticket number (e.g., 1234)
  MESSAGE...            A short, descriptive message (remaining arguments)

Options:
  -t, --ticket-number   The ticket number (flag mode)
  -m, --message         The message (flag mode)
  -h, --help            Show this help message

Change Types:
  a, added              Added - for new features
  c, changed            Changed - for changes in existing functionality
  r, removed            Removed - for removed features
  f, fixed              Fixed - for bug fixes
  w, wip                Work in progress - for incomplete work

Examples:
  $SCRIPT_NAME f 1234 "Fix user authentication bug"
  $SCRIPT_NAME fixed 1234 Fix user authentication bug
  $SCRIPT_NAME c 5678 "Update API endpoint"
  $SCRIPT_NAME changed 5678 Update API endpoint to use v2
  $SCRIPT_NAME -t 1234 -m "Add user authentication" -f
  $SCRIPT_NAME --help

Note: For WIP tickets, use format "Parent ticket | Child ticket" - the branch will be named after the child ticket only.
EOF
    exit 0
}

parse_arguments() {
    # Check for help flags first
    if [[ "$*" =~ (^|[[:space:]])(-h|--help)([[:space:]]|$) ]]; then
        show_usage
    fi

    # Check if using positional arguments (at least 3 args, first arg doesn't start with -)
    if [[ $# -ge 3 && "$1" != -* ]]; then
        parse_positional_arguments "$@"
        return
    fi

    # Otherwise use flag-based parsing
    parse_flag_arguments "$@"
}

parse_positional_arguments() {
    local change_flag="$1"
    ticket_number="$2"
    shift 2  # Remove first two arguments

    # Join remaining arguments with spaces and capitalize first letter
    message=$(capitalize_first "$*")

    # Map change flag to change type (support both short and long forms)
    case "${change_flag:l}" in  # Convert to lowercase for comparison
        a|added) change_type="Added" ;;
        c|changed) change_type="Changed" ;;
        r|removed) change_type="Removed" ;;
        f|fixed) change_type="Fixed" ;;
        w|wip) change_type="Work in Progress" ;;
        *)
            log_error "Invalid change type '$change_flag'. Use: a/added, c/changed, r/removed, f/fixed, or w/wip"
            show_usage
            ;;
    esac

    # Validate ticket number is numeric
    if [[ ! "$ticket_number" =~ ^[0-9]+$ ]]; then
        log_error "Ticket number must be numeric"
        exit 1
    fi

    # Validate message is not empty
    if [[ -z "$message" ]]; then
        log_error "Message cannot be empty"
        exit 1
    fi
}

parse_flag_arguments() {
    local added changed removed fixed wip help

    zparseopts -D -E -F -K \
        t:=ticket_number \
        m:=message \
        a=added c=changed r=removed f=fixed w=wip \
        h=help -help=help || show_usage

    # Check for help flag
    if [[ ${#help[@]} -gt 0 ]]; then
        show_usage
    fi

    # Validate required arguments
    if [[ -z "${ticket_number:-}" || -z "${message:-}" ]]; then
        log_error "Both ticket number and message are required"
        show_usage
    fi

    # Extract scalar values from zparseopts arrays
    ticket_number="${ticket_number[2]}"
    message="${message[2]}"

    # Determine change type - check which flag was provided
    if [[ "${changed[1]:-}" == "-c" ]]; then
        change_type="Changed"
    elif [[ "${added[1]:-}" == "-a" ]]; then
        change_type="Added"
    elif [[ "${removed[1]:-}" == "-r" ]]; then
        change_type="Removed"
    elif [[ "${fixed[1]:-}" == "-f" ]]; then
        change_type="Fixed"
    elif [[ "${wip[1]:-}" == "-w" ]]; then
        change_type="Work in progress"
    else
        log_error "You must specify exactly one change type (-a, -c, -r, -f, -w)"
        show_usage
    fi

    # Validate ticket number is numeric
    if [[ ! "$ticket_number" =~ ^[0-9]+$ ]]; then
        log_error "Ticket number must be numeric"
        exit 1
    fi
}

#==============================================================================
# Branch Management
#==============================================================================

generate_branch_name() {
    local type_slug="${change_type:l}"  # Convert to lowercase

    # Handle special case for "Work in progress"
    [[ "$type_slug" == "work in progress" ]] && type_slug="wip"

    # For WIP tickets, extract only the child ticket part (after |) for branch naming
    local branch_message="$message"
    if [[ "$change_type" == "Work in Progress" && "$message" == *" | "* ]]; then
        # Extract everything after " | " and trim whitespace
        branch_message="${message#*" | "}"
        branch_message="${branch_message## }"  # Remove leading spaces
        branch_message="${branch_message%% }"  # Remove trailing spaces
    fi

    # Create URL-friendly slug from message
    local message_slug="${branch_message:l}"    # Convert to lowercase
    message_slug="${message_slug// /_}"         # Replace spaces with underscores
    message_slug="${message_slug//[^a-z0-9_-]/}" # Remove special characters

    branch_name="${type_slug}/${SQUAD_NAME}-${ticket_number}_${message_slug}"
}

create_branch() {
    run_command git checkout -b "$branch_name"
}

#==============================================================================
# Changelog Management
#==============================================================================

validate_changelog_exists() {
    if [[ ! -f "$CHANGELOG_FILE" ]]; then
        log_error "Changelog file '$CHANGELOG_FILE' not found"
        exit 1
    fi
}

update_changelog() {
    validate_changelog_exists

    local new_entry="- ${message} [${SQUAD_NAME}-${ticket_number}](${TICKET_URL_PREFIX}${ticket_number})"
    local header="### $change_type"

    # Read the entire file into an array
    local lines=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        lines+=("$line")
    done < "$CHANGELOG_FILE"

    # Find the header line index
    local header_index=-1
    local i
    for i in {1..${#lines[@]}}; do
        if [[ "${lines[i]}" == "$header" ]]; then
            header_index=$i
            break
        fi
    done

    if (( header_index == -1 )); then
        log_error "Section '$header' not found in $CHANGELOG_FILE"
        echo "Available sections:" >&2
        grep "^### " "$CHANGELOG_FILE" 2>/dev/null >&2 || echo "No sections found" >&2
        exit 1
    fi

    # Find the next section header or end of file
    local next_section_index=$((${#lines[@]} + 1))
    for ((i = header_index + 1; i <= ${#lines[@]}; i++)); do
        if [[ "${lines[i]}" == "### "* ]]; then
            next_section_index=$i
            break
        fi
    done

    # Find the last entry in this section
    local insert_index=$((header_index + 1))
    for ((i = header_index + 1; i < next_section_index; i++)); do
        if [[ "${lines[i]}" == "- "* ]]; then
            insert_index=$((i + 1))
        fi
    done

    # Insert the new entry
    lines=("${lines[@]:0:$((insert_index-1))}" "$new_entry" "${lines[@]:$((insert_index-1))}")

    # Write back to file
    printf "%s\n" "${lines[@]}" > "$CHANGELOG_FILE"
}

commit_changelog() {
    run_command git add "$CHANGELOG_FILE"
    run_command git commit -m "Update changelog"
}

#==============================================================================
# Main Function
#==============================================================================

main() {
    parse_arguments "$@"
    generate_branch_name

    create_branch
    update_changelog
    commit_changelog
}

# Script entry point
main "$@"
