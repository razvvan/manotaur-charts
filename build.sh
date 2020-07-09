#!/bin/bash

set -e

changes=false

mkdir -p charts

sha_root=$(git log --pretty=oneline . | head -n 1 | awk '{print $1}')

for chart in $(ls src); do
  echo "Checking $chart"

  sha_chart=$(git log --pretty=oneline src/$chart/ | head -n 1 | awk '{print $1}')


  if [[ "$sha_chart" == "$sha_root" ]]; then
    echo "Changes"
    helm package -d charts ./src/$chart
    changes=true
  else
    echo "No changes"
  fi
done


if $changes ; then
  helm repo index --url https://razvvan.github.io/manotaur-charts/ .

  git fetch --all
  git checkout gh-pages
  mv index.yaml charts/
  git add charts/
  git commit -m "Chart updates"
  git push
fi


