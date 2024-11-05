#!/bin/bash

USAGE="""Usage: ./deployInfrastructure.sh <ARGUMENTS>

ARGUMENTS:
  -h                            Display this help message
  -d <Domain Name>              AD Domain Name
  -c <Client Number>            Number of clients to generate
  -u <U1/P1,U2/P2,U3/U3>        Users and passwords for the clients (format: User1/Pass1,User2/Pass2,...)

Note: Ensure to follow the specified format for users and passwords.
"""

echo "$USAGE"
