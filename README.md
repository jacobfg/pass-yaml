
| Branch | Status |
|--------|--------|
| [**master**](https://github.com/jacobfg/pass-yaml/tree/master) | |
| [**develop**](https://github.com/jacobfg/pass-yaml/tree/develop) | |

# pass-yaml

A [pass](https://www.passwordstore.org/) extension for outputting YAML format.

## Usage

```
Usage:

    pass yaml [show] pass-name
        command for outputing YAML formated text, requires the password is the first
        line of the text and the rest is already formatted yaml.

More information may be found in the pass-yaml(1) man page.
```

## Examples

Show YAML output from the additional notes of a pass entry

```
$ pass yaml secret
```

## Installation

### From git

```
git clone https://github.com/jacobfg/pass-yaml
cd pass-yaml
sudo make install
```

### macOS
#### Brew
```
brew install pass-yaml
```

## Requirements

- `pass` 1.7.0 or later for extension support

### Build requirements

- `make test`
  - `pass` >= 1.7.0
  - `git`
