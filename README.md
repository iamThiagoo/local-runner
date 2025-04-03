# Local Runner

Local Runner is a simple project to quickly start projects in your local environment. Just register the project by providing the name, the absolute path, and the initialization command, and you're done!

Say goodbye to the manual work of navigating through multiple directories to execute specific commands.

## Preview

![Preview](./src/assets/screenshot.png)

## Pré-requisite
- Bash: The script was developed to be executed on systems with Bash installed.

## Installation

Clone the repository:
```bash 
$ git clone https://github.com/iamThiagoo/local-runner.git
$ cd local-runner
```

Give execution permission to the script:

```bash 
$ chmod +x index.sh
```

Run the script:

```bash 
$ ./index.sh
```

## Configuration File

The script uses a config file to store the projects information. The config file is located at `./src/projects.list.txt`.

The format of each line is as follows:

```bash
<project_name>, <project_path>, <project_command>
```

You can modify this file or add new project with the script.

## Make a alias to run the script

Give execution permission to the script:

```bash
$ chmod +x index.sh
```

To make the script runnable from anywhere in your terminal, you can create an simples alias.

```bash
$ echo 'alias runner="~/path/to/local-runner/index.sh"' >> ~/.bashrc
$ source ~/.bashrc
```

Now you can run the script from anywhere using:

```bash
$ runner
```

Note: The alias will work for bash shells. If users are using a different shell (like zsh), they should add the alias to their respective shell configuration file (like `~/.zshrc`).

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.