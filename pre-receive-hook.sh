#!/bin/bash

# Tune your fortune
FORTUNE="fortune 50% fortunes 40% fortunes2 5% zippy 2% limerick 2% recipes 1% startrek"

# Branches to protect from push updates
PROTECT_BRANCH_PREFIX=(master release- hotpatch-)

# User token that can validate a user name and email
# Go to https://<your ghe host>/settings/tokens and create token for
#     read:user
#     user:email
# Example: foo:0000000000000000000000000000000000000000
CHECK_USER_DATA_TOKEN=changme:0000000000000000000000000000000000000000

# Users that can override branch protections
GIT_MASTERS=(herb)

#------------------------------------------------------------
# GHE hook functions
#------------------------------------------------------------

while read oval nval ref
do
    oldrev=$oval
    newrev=$nval
    refname=$ref
    zedrev="0000000000000000000000000000000000000000"
done


err()
{
    echo ""
    echo "Error: $@" 1>&2;
    echo ""
    exit 1
}

ghe_verbose()
{
    echo ""
    echo "Running: `basename "$0"`"
    echo "----------------------------------------------------------------------"
    echo oldrev=$oldrev
    echo newrev=$newrev
    echo refname=$refname
    echo ""
    printenv
}

ghe_protect_branch_prefix()
{
    # Skip check if we are creating a new protected branch
    if [[ $oldrev == $zedrev ]]; then
        return
    fi
    for m in "${GIT_MASTERS[@]}"; do
        if [[ "${GITHUB_USER_LOGIN}" == $m ]]; then
            return
        fi
    done
    for p in "${PROTECT_BRANCH_PREFIX[@]}"; do
        if [[ "${refname}" =~ ^refs/heads/$p ]]; then
            if [[ "${GITHUB_VIA}" != 'pull request merge button' && \
                  "${GITHUB_VIA}" != 'pull request merge api' ]]; then
                err "Direct pushes to *${refname}* branch are not allowed"
            fi
        fi
    done
}

ghe_protect_commit_author()
{
    # Skip check if we are deleting a branch
    if [[ $newrev == $zedrev ]]; then
        return
    fi

    udata=$(curl -s -k -u ${CHECK_USER_DATA_TOKEN} https://localhost/api/v3/users/${GITHUB_USER_LOGIN})

    name=$(echo $udata | sed -n 's/.*"name": "\([^"]*\).*/\1/p')
    email=$(echo $udata | sed -n 's/.*"email": "\([^"]*\).*/\1/p')
    commits=$(git rev-list $newrev --not --all)

    echo $udata
    echo $name
    echo $email
    echo $commits
    echo "TODO: Not implemented"
}

ghe_fortune()
{
    if type fortune > /dev/null 2>&1; then
        echo "----------------------------------------------------------------------"
        echo ""
        $FORTUNE
        echo ""
        echo "----------------------------------------------------------------------"

    fi
}


#------------------------------------------------------------
# # Enable desired hooks (run in order that they are called)
#------------------------------------------------------------

ghe_verbose
ghe_protect_branch_prefix
ghe_protect_commit_author
ghe_fortune
