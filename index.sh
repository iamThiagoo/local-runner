#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECTS_FILE="$(dirname "$0")/src/projects.list.txt"

main() {
  if [ ! -f "$PROJECTS_FILE" ]; then
    echo -e "${RED}Error: $PROJECTS_FILE file not found ${NC}"
    echo -e "Tip: Create a projects.list.txt file with the format: "
    echo -e "${YELLOW} - PROJECT_NAME PROJECT_PATH INIT_COMMAND"
    exit 1
  fi

  while true; do
    print_logo
    
    echo "1. Start projects"
    echo "2. Add new project"
    echo "3. List projects"
    echo "4. Edit projects file"
    echo "5. Exit"

    echo ""
    read -rp "Choose an option: " OPTION

    case $OPTION in
      1) start_project ;;
      2) add_project ;;
      3) list_projects ;;
      4) edit_projects_file ;;
      5) echo -e "${YELLOW}\nExiting...${NC}"; exit ;;
      *) echo -e "${RED}\nInvalid option!${NC}" ;;
    esac
  done
}

start_project() {
  print_logo
  echo -e "${GREEN}\nAvailable projects: \n${NC}"

  if [ ! -s "$PROJECTS_FILE" ]; then
    echo -e "${YELLOW}No projects registered.${NC}"
    return
  fi

  awk -F',' '{print NR". "$1}' "$PROJECTS_FILE"
  echo ""
  read -rp "Choose a project to start: " choice

  if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid choice. Enter a number.${NC}"
    return
  fi

  selected_project=$(sed -n "${choice}p" "$PROJECTS_FILE")

  if [ -z "$selected_project" ]; then
    echo -e "${RED}Error: Invalid number.${NC}"
    return
  fi

  IFS=',' read -r NAME PATH INIT_CMD <<< "$selected_project"

  NAME=${NAME//[$'\t\r\n']}
  PATH=${PATH//[$'\t\r\n']}
  INIT_CMD=${INIT_CMD//[$'\t\r\n']}
  PROJECT_ROOT="$(pwd)"
  ABS_PATH=$(eval echo "$PATH")

  echo -e "${GREEN}Starting: $NAME...${NC}"

  export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/mnt/c/Program\ Files/nodejs
  NODE_PATH=$(command -v node)

  if [ -d "$ABS_PATH" ]; then
    (
      echo ${INIT_CMD}
      cd "$ABS_PATH" || exit
      eval "$INIT_CMD"
    )
    echo -e "${GREEN}$NAME started successfully.${NC}"
  else
    echo -e $ABS_PATH
    echo -e "${RED}Error: Directory $ABS_PATH does not exist.${NC}"
  fi
}

add_project() {
  print_logo

  echo -e "${YELLOW}Adding a new project...${NC}"
  echo ""
  read -rp "Project name: " NAME
  read -rp "Project path: " PATH
  read -rp "Startup command: " INIT_CMD

  if [ -z "$NAME" ] || [ -z "$PATH" ] || [ -z "$INIT_CMD" ]; then
    echo -e "${RED}\nError: All fields are required!${NC}"
    return
  fi

  if [ -s "$PROJECTS_FILE" ]; then
    printf "\n" >> "$PROJECTS_FILE"
  fi

  printf "%s, %s, %s" "$NAME" "$PATH" "$INIT_CMD" >> "$PROJECTS_FILE"

  echo -e "${GREEN}\nProject $NAME added successfully!${NC}"
  echo ""
  read -n 1 -s -r -p "Press Enter to continue..."
}

list_projects() {
  print_logo

  echo -e "${GREEN}\nAvailable projects:\n${NC}"
  if [ ! -s "$PROJECTS_FILE" ]; then
    echo -e "${YELLOW}\nNo projects registered.${NC}"
    return
  fi
  awk -F',' '{print NR". "$1}' "$PROJECTS_FILE"

  echo ""
  read -n 1 -s -r -p "Press Enter to continue..."
}

edit_projects_file() {
  if [ ! -f "$PROJECTS_FILE" ]; then
    echo -e "${RED}\nError: $PROJECTS_FILE file not found.${NC}"
    return
  fi

  vi "$PROJECTS_FILE"
}

print_logo() {
  clear
  echo -e "\n$(cat "$(dirname "$0")/src/assets/logo.txt") \n"
}

main
