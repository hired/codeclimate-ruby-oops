# Hired RUBY-OOPS Engine for CodeClimate

`ruby-oops` looks for things you forgot to remove before checking in. It was developed by an engineer wanting to add a layer of idiot-proofing to his code. It looks for:

### Ruby Files

* `puts`
* `p`
* `pretty_print`
* `pp`
* `awesome_print`
* `ap`

### JS Files

* `console.log`

### All Files

* Rebase or merge conflicts: `<<<<<<`, `>>>>>>`, `======`

### Installation & Usage

1. If you haven't already, [install the Code Climate CLI](https://github.com/codeclimate/codeclimate).
2. Run `codeclimate engines:enable ruby-oops`. This command both installs the engine and enables it in your `.codeclimate.yml` file.
3. Browse into your project's folder and run `codeclimate analyze`.
