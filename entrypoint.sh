#!/bin/sh

if [ "$INPUT_INSTALL_DEPENDENCIES" = "true" ]; then
  echo "Running \`npm install\`"
  npm install
fi

echo "Running eleventy"
npx @11ty/eleventy $INPUT_ARGS
