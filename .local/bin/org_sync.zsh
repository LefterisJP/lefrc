#!/bin/zsh

ORGDIR=/home/lefteris/org

cd $ORGDIR

git pull origin
if [[ $? != 0 ]]; then
    echo "Failed pull changes from remote"
    exit $?
fi

git_status=$(git status)
if [[ $git_status =~ ".*Changes\ not\ staged\ for\ commit.*" ]]; then
    git add . -u
    if [[ $? != 0 ]]; then
        echo "Failed to stage changes"
        exit $?
    fi

    git ci -m "save state"
    if [[ $? != 0 ]]; then
        echo "Failed to commit changes"
        exit $?
    fi

    git push origin
    if [[ $? != 0 ]]; then
        echo "Failed to commit changes"
        exit $?
    fi
fi
