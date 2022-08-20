#!/usr/bin/env bash

# folder.sh
function folder() {
  #statements
  local file=$1
  local new_folder=`head -n 1 $file/README.md | sed 's/# //g'`

  mv $file $new_folder
}
# readme.sh
# 1. change word view to case-count
# 2. add description
function replace_readme_str() {
  #statements
  local file=$1/README.md
  local old=$2
  local new=$3

  perl -pi.bak -e "s/${old}/${new}/" $file
  rm -f $1/README.md.bak
}
function readme() {
  #statements
  local file=$1
  read -r -d '' DESCRIPTION <<EOF
Updated an immutable entity \`breedcount\` as a view using a subselect with 
case and join.

## Tech stack
EOF

  replace_readme_str $file "view" "case-count"

  replace_readme_str $file "## Tech stack" "$DESCRIPTION"
}
# build.sh
# 1. update file  BreedCountEntity
function build() {
  #statements
  local file=$1

  for e in `find $file -type d -name src`; do
    rm -f $e/main/java/example/entity/BreedCountEntity.java

    cp .src/BreedCountEntity.java $e/main/java/example/entity/BreedCountEntity.java
  done
}

# install.sh
function install() {
  #statements
  local file=$1

  build $file

  readme $file

  folder $file
}

for d in `ls -la | grep ^d | awk '{print $NF}' | egrep -v '^\.'`; do
  install $d
done
