#!/bin/sh

# Default is 6 months
MONTHS=6
# Default is not dry run
DRY_RUN=
# Default is to ask for confirmation
ASK_CONFIRMATION=1
# Default is to prune remotes
PRUNE_REMOTES=1

usage()
{
    echo "usage: $0 [[[-m months ] [-n]] [-h] [-y]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -m | --months )         shift
                                MONTHS=$1
                                ;;
        -n | --dry-run )        DRY_RUN=1
                                ;;
        -y | --no-confirm )     ASK_CONFIRMATION=
                                ;;
        -p | --no-prune )       PRUNE_REMOTES=
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ "$PRUNE_REMOTES" = "1" ]]; then
    for remote in $(git remote); do
        echo "Pruning remote $remote references"
        git remote prune $remote
    done
fi
echo "Will delete branches older than $MONTHS months"

for branch in $(git branch -a | sed 's/^\s*//' | grep -v 'master$'); do
    if [[ "$(git log $branch --since "$MONTHS months ago" | wc -l)" -eq 0 ]]; then
        # Make sure to get only local branches
        local_branch_name=$(echo "$branch" | sed 's/remotes\/.*\///')
        if [[ "$DRY_RUN" = "1" ]]; then
            echo "DRY: Will delete $local_branch_name"
        else
            if [[ "$ASK_CONFIRMATION" = "1" ]]; then
                read -p "Will delete $local_branch_name. Are you sure? " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    git branch -D "$local_branch_name"
                else
                    echo "Did not delete $local_branch_name"
                fi
            else
                git branch -D "$local_branch_name"
            fi
        fi
    fi
done
