#!/bin/bash

set -e

GEN_DIR=goget

CUSTOM_PREFIX=ext.arhat.dev
REPO_ORG=https://github.com/arhat-ext
VCS=git

gen() {
  rm -rf "${GEN_DIR}"
  mkdir -p "${GEN_DIR}" data

  cat > "data/goget.yml" << EOF
custom_prefix: ${CUSTOM_PREFIX}
repo_org: ${REPO_ORG}
vcs: ${VCS}
EOF

  for project in projects/*.txt; do
    [[ -e "$project" ]] || break  # handle the case of no *.wav files

    packages="$(cat "${project}")"
    repo_name="$(basename "${project%.txt}")"

    for p in ${packages}; do
      file_name=${p//\//_}
      package=${p%%\/*}
      cat > "${GEN_DIR}/${file_name}.md" << EOF
---
package: ${package}
permalink: /${p}
layout: goget
repo_name: ${repo_name}
---
EOF
    done
  done
}

gen
