# Php Easy NVim

A few functions for make work with PHP 7.4 (or more) projects easy and quickly.

## Install

### With [lazy.nvim](https://github.com/folke/lazy.nvim/): 
```lua
    {
        'ta-tikoma/php.easy.nvim',
        config = true,
        keys = {
            {'-b', '<CMD>PHPEasyDocBlock<CR>'},
            {'-r', '<CMD>PHPEasyReplica<CR>'},
            {'-c', '<CMD>PHPEasyCopy<CR>'},
            {'-d', '<CMD>PHPEasyDelete<CR>'},
            {'-uu', '<CMD>PHPEasyRemoveUnusedUses<CR>'},
            {'-e', '<CMD>PHPEasyExtends<CR>'},
            {'-i', '<CMD>PHPEasyImplements<CR>'},
            {'-ii', '<CMD>PHPEasyInitInterface<CR>'},
            {'-ic', '<CMD>PHPEasyInitClass<CR>'},
            {'-iac', '<CMD>PHPEasyInitAbstractClass<CR>'},
            {'-it', '<CMD>PHPEasyInitTrait<CR>'},
            {'-ie', '<CMD>PHPEasyInitEnum<CR>'},
            {'-c', '<CMD>PHPEasyAppendConstant<CR>', mode = {'n', 'v'}},
            {'-p', '<CMD>PHPEasyAppendProperty<CR>', mode = {'n', 'v'}},
            {'-m', '<CMD>PHPEasyAppendMethod<CR>', mode = {'n', 'v'}},
            {'-_', '<CMD>PHPEasyAppendConstruct<CR>'},
            {'-a', '<CMD>PHPEasyAppendArgument<CR>'},
        }
    },
```

## Features

| Example Key Binding | Function  | Description |
| --- | --- | --- |
| **Any**        |                            | function or property or constant |
| `-y`           | `PHPEasyCopy`              | **Y**ank (copy) *any* under cursor |
| `-r`           | `PHPEasyReplica`           | **R**eplica *any*: Copy under cursor, paste after current and trigger rename function |
| `-d`           | `PHPEasyDelete`            | **D**elete *any* under cursor |
| `-b`           | `PHPEasyDocBlock`          | PhpDoc**B**lock for *any* or class or variable |
| **Append**     | | |
| `-c`           | `PHPEasyAppendConstant`    | Append **c**onstant |
| `-p`           | `PHPEasyAppendProperty`    | Append **p**roperty |
| `-m`           | `PHPEasyAppendMethod`      | Append **m**ethod |
| `-t`           | `PHPEasyAppendTrait`       | Append **t**ait |
| `-_`           | `PHPEasyAppendConstruct`   | Append **_**_construct |
| `-a`           | `PHPEasyAppendArgument`    | Append new **a**rgument in current function |
| **Objects**    | | |
| `-uu`          | `PHPEasyRemoveUnusedUses` | Remove **u**nused **u**ses from current class |
| `-e`           | `PHPEasyExtends`           | **E**xtends current class |
| `-i`           | `PHPEasyImplements`        | **I**mplements current class |
| `-ic`          | `PHPEasyInitClass`         | **I**nitialize **c**lass in current file |
| `-iac`         | `PHPEasyInitAbstractClass` | **I**nitialize **a**bstract **c**lass in current file |
| `-ii`          | `PHPEasyInitInterface`     | **I**nitialize **i**nterface in current file |
| `-it`          | `PHPEasyInitTrait`         | **I**nitialize **t**rait in current file |
| `-ie`          | `PHPEasyInitEnum`          | **I**nitialize **e**num in current file |

## Configuration

```lua
{
    regex = { -- regex for parse php file
        tab = '    ',
        startTab = '^' .. tab,
        visibility = startTab .. '\\(public\\|protected\\|private\\|\\)\\s\\{1}',
        static = '\\(static\\s\\|\\)',
        constant = visibility .. 'const ',
        property = visibility .. static .. '\\(?*\\w\\+\\s\\|\\)\\$',
        method = visibility .. static .. 'function',
        construct = method .. ' __construct(',
        methodEnd = startTab .. '}',
        comment = startTab .. '\\/',
        commentMiddle = startTab .. '\\*',
        commentEnd = startTab .. '\\s\\*',
        any = startTab .. '[p}]\\{1}',
        variable = '\\(' .. tab .. '\\)\\+\\$\\w\\+\\s\\{1}=\\s\\{1}',
        object = '^\\(final class\\|abstract class\\|class\\|interface\\|trait\\|enum\\)\\s\\{1}',
    },
    onSave = { -- on save php file action
        removeUnusedUses = true -- remove unused uses (then use lsp: intelephense)
    },
    onAppend = { -- on append entity
        engine = 'defalut' -- how to insert template. 'default' - just string, 'LuaSinp' - via 'L3MON4D3/LuaSnip'
    }
}

```

## Examples

### Init

#### Init trait `-it`
![init trait](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/init/trait.gif)

#### Init interface `-ii`
![init interface](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/init/interface.gif)

#### Init abstract class `-iac`
![init abstract class](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/init/abstract-class.gif)

#### Init class `-ic`
![init class](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/init/class.gif)

### Add doc block `-b`

#### Class
![doc class](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/doc/class.gif)

#### Constant
![doc constant](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/doc/constant.gif)

#### Property
![doc property](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/doc/property.gif)

#### Method
![doc method](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/doc/method.gif)

#### Variable
![doc variable](https://raw.githubusercontent.com/ta-tikoma/php.easy.vim/with-examples/example/doc/variable.gif)
