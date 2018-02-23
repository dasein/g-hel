#!/bin/bash

oldrev=$(git rev-parse $1)
newrev=$(git rev-parse $2)
refname="$3"
zedrev="0000000000000000000000000000000000000000"


FORTUNE="fortune 50% fortunes 40% fortunes2 5% zippy 2% limerick 2% recipes 1% startrek"
PROTECT_BRANCH_PREFIX=(master release- hotpatch-)


ghe_verbose()
{
    echo ""
    echo "Running: `basename "$0"` $@"
    echo "----------------------------------------------------------------------"
    printenv
    echo "----------------------------------------------------------------------"
    echo ""
}

ghe_fortune()
{
    echo ""
    echo "A fortune for you:"
    echo "----------------------------------------------------------------------"
    $FORTUNE
    echo "----------------------------------------------------------------------"
    echo ""
}

ghe_protect_branch_prefix()
{
    for p in "${PROTECT_BRANCH_PREFIX[@]}"; do
        if [[ "${refname}" =~ ^refs/heads/$p ]]; then
            if [[ "${GITHUB_VIA}" != 'pull request merge button' && \
                  "${GITHUB_VIA}" != 'pull request merge api' ]]; then
                echo "Direct pushes to protected *${refname}* are not allowed"
                exit 1
            fi
        fi
    done
}

# Enable desired hooks
ghe_verbose
ghe_fortune
ghe_protect_branch_prefix
