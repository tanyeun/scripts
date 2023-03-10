#!/usr/bin/env bash

# git clone git@github.com:[target gist shar].git gists-blog
# cd gists-blog
# ./generate.sh
# git add .
# git commit -m "updated links"
# git push

function gistgen_help() {
    echo "Usage: $progname <command> [<options>]"
    echo "Commands:"
    echo "    get   gist from USER and generate a blog page"
}

function gistgen() {
    ACTION="$1"
    ACTION_PARAMETER="$2"

    case "${ACTION}" in
        "get")
            gistgen_get "$ACTION_PARAMETER";;
        *)
            gistgen_help
    esac
}
curl -I https://api.github.com/users/[username]/gists | grep link

# for i in $(seq 6); do
#   curl 'https://api.github.com/user/2342284/gists?page='$i \
#   | jq -r '.[] | "<a href=\"" + .url + "\">" + .description + "</a>" ' > index.html
# done

rm index.md
for i in $(seq 6); do 
  curl 'https://api.github.com/user/2342284/gists?page='$i \
  | jq -r '.[] | .created_at[0:10] + " - [" + .description + "](" + .html_url + ")\n"' >> index.md
done

# Use tinyurl.com to link to your gist