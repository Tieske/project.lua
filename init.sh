#!/usr/bin/env bash

REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
GH_ACCOUNT=$(git remote -v | grep "(fetch)" | sed "s/ (fetch)//" | sed "s/^.*github.com\///" | sed "s/\/.*$//")
USER_NAME=$(git config user.name)
# shellcheck disable=SC2001
MODULE_NAME=$(echo "$REPO_NAME" | sed "s/\.lua$//")
YEAR=$(date +%Y)

# fetch description from github api, poorman's json parsing, but don't want
# another dependency (eg. jq).
SHORT_DESC=$(curl -s -X GET https://api.github.com/repos/$GH_ACCOUNT/$REPO_NAME | grep '"description":' | grep -v 'template' | sed -n '1p')
SHORT_DESC=$(echo "$SHORT_DESC" | sed "s/^.*\"description\"//" | sed "s/^[^\"]*\"//" | sed "s/\",.*$//")
if [ "$SHORT_DESC" == "" ] ; then
  SHORT_DESC="short description"
fi

echo ""
echo "This script will update the template repo for first use."
echo ""

read -r -p "Enter the Github repository name [$REPO_NAME]: " uinput
REPO_NAME=${uinput:-$REPO_NAME}
read -r -p "Enter the Lua module name [$MODULE_NAME]: " uinput
MODULE_NAME=${uinput:-$MODULE_NAME}
read -r -p "Enter the short project description [$SHORT_DESC]: " uinput
SHORT_DESC=${uinput:-$SHORT_DESC}
read -r -p "Enter the Github account name [$GH_ACCOUNT]: " uinput
GH_ACCOUNT=${uinput:-$GH_ACCOUNT}
read -r -p "Enter the author name [$USER_NAME]: " uinput
USER_NAME=${uinput:-$USER_NAME}
read -r -p "Enter the copyright year [$YEAR]: " uinput
YEAR=${uinput:-$YEAR}

echo ""
echo "Please validate the following settings:"
echo ""
echo "Repository        : $REPO_NAME"
echo "Module name       : $MODULE_NAME"
echo "Short description : $SHORT_DESC"
echo "Github account    : $GH_ACCOUNT"
echo "Author name       : $USER_NAME"
echo "Copyright year    : $YEAR"
echo ""

while true; do
    read -r -p "Do you wish to continue updating this repo? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


# find/replace a single file
function replace_single_file {
    local FILENAME="$1"
    local ESCAPED_FIND
    local ESCAPED_REPLACE
    # escaping see: https://stackoverflow.com/questions/407523/escape-a-string-for-a-sed-replace-pattern
    ESCAPED_FIND=$(printf '%s\n' "$FIND_VALUE" | sed -e 's/[]\/$*.^[]/\\&/g')
    ESCAPED_REPLACE=$(printf '%s\n' "$REPLACE_VALUE" | sed -e 's/[\/&]/\\&/g')

    if ! [ "${FILENAME:0:7}" == "./.git/" ] ; then
        # see https://stackoverflow.com/questions/19456518/error-when-using-sed-with-find-command-on-os-x-invalid-command-code
        sed -i "" -e "s/$ESCAPED_FIND/$ESCAPED_REPLACE/g" "$FILENAME"
    fi
}
export -f replace_single_file


# find/replace over entire file tree
function patch {
    export FIND_VALUE="$1"
    export REPLACE_VALUE="$2"

    find . -type f -exec bash -c 'replace_single_file "$0"' {} \;
}


# Making the changes from here onwards
if [ "$REPO_NAME" == "project.lua" ] ; then
    echo "cannot run this script (since it is destructive) on the template repo itself"
    exit 1
fi

patch "[repo-name]" "$REPO_NAME"
patch "[module-name]" "$MODULE_NAME"
patch "[short-description]" "$SHORT_DESC"
patch "[github-account-name]" "$GH_ACCOUNT"
patch "[your-name]" "$USER_NAME"
patch "[copyright-year]" "$YEAR"

mv src/project "src/$MODULE_NAME"
mv project-scm-1.rockspec "$MODULE_NAME-scm-1.rockspec"
mv bin/project.lua "bin/$MODULE_NAME.lua"

# make sure we have tools available
make dev

# cleanup manual
cat > ./doc_topics/01-introduction.md<< EOF
# 1. Introduction

## 1.1 Paragraph
EOF

# cleanup readme
grep -v "please ignore information below" < README.md > README.new
rm README.md
mv README.new README.md

# cleanup
unset replace_single_file
unset FIND_VALUE
unset REPLACE_VALUE

echo "Updates done, now cleaning and generating initial docs..."
make clean
make docs
echo "Generation complete, please commit all changes and push to the remote."

# delete this script, and exit, on same line to prevent errors
rm "$0"; git add -A; git commit -e --message="Initial repo setup from template"; exit 0
