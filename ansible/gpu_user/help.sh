#!/bin/bash

echo "
- change IP address in hosts
- run
  ansible-playbook user.yml --key-file ~/.ssh/singapore.pem -i hosts \\
    -e 'username=USER_NAME' \\
    -e 'key_path=\"\"'
"
