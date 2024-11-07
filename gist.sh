# 0. Your file name
FNAME=some.file

# 1. Somehow sanitize the file content
#    Remove \r (from Windows end-of-lines),
#    Replace tabs by \t
#    Replace " by \"
#    Replace EOL by \n
CONTENT=$(sed -e 's/\r//' -e's/\t/\\t/g' -e 's/"/\\"/g' "${FNAME}" | awk '{ printf($0 "\\n") }')

# 2. Build the JSON request
read -r -d '' DESC <<EOF
{
  "description": "some description",
  "public": true,
  "files": {
    "${FNAME}": {
      "content": "${CONTENT}"
    }
  }
}
EOF

# 3. Use curl to send a POST request
curl -X POST -d "${DESC}" "https://api.github.com/gists"
