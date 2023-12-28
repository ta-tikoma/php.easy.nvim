# Php Easy Vim

A few functions for make work with PHP 7.4 (or more) projects easy and quickly.

# Install

## Lazy
```lua
    {
        'ta-tikoma/php.easy.nvim',
        config = true,
        keys = {
            {'-b', '<CMD>PHPEasyDocBlock<CR>'},
            {'-r', '<CMD>PHPEasyReplica<CR>'},
            {'-c', '<CMD>PHPEasyCopy<CR>'},
            {'-d', '<CMD>PHPEasyDelete<CR>'},
            {'-ii', '<CMD>PHPEasyInitInterface<CR>'},
            {'-ic', '<CMD>PHPEasyInitClass<CR>'},
            {'-iac', '<CMD>PHPEasyInitAbstractClass<CR>'},
            {'-it', '<CMD>PHPEasyInitTrait<CR>'},
            {'-ie', '<CMD>PHPEasyInitEnum<CR>'},
            {'-ic', '<CMD>PHPEasyAppendConstruct<CR>'},
            {'-ac', '<CMD>PHPEasyAppendConstant<CR>'},
            {'-ap', '<CMD>PHPEasyAppendProperty<CR>'},
            {'-am', '<CMD>PHPEasyAppendMethod<CR>'},
            {'-aa', '<CMD>PHPEasyAppendArgument<CR>'},
        }
    },
```

| Example Key Binding | Function  | Description |
| --- | --- | --- |
| **Any**        |                            | function or property or constant |
| `-y`           | `PHPEasyCopy`              | **Y**ank (copy) *any* under cursor |
| `-r`           | `PHPEasyReplica`           | **R**eplica *any*: Copy under cursor, paste after current and trigger rename function |
| `-d`           | `PHPEasyDelete`            | **D**elete *any* under cursor |
| `-b`           | `PHPEasyDocBlock`          | PhpDoc**B**lock for *any* or class or variable |
| **Append**     |                                                | |
| `-c`           | `PHPEasyAppendConstruct`   | Append **c**onstruct |
| `-ac`          | `PHPEasyAppendConstant`    | **A**ppend **c**constant |
| `-ap`          | `PHPEasyAppendProperty`    | **A**ppend **p**roperty |
| `-am`          | `PHPEasyAppendMethod`      | **A**ppend **m**ethod |
| `-aa`          | `PHPEasyAppendArgument`    | **A**ppend new **a**rgument in current function |
| **Objects**    |||
| `-ic`          | `PHPEasyInitClass`         | **I**nitialize **c**lass in current file |
| `-iac`         | `PHPEasyInitAbstractClass` | **I**nitialize **a**bstract **c**lass in current file |
| `-ii`          | `PHPEasyInitInterface`     | **I**nitialize **i**nterface in current file |
| `-it`          | `PHPEasyInitTrait`         | **I**nitialize **t**rait in current file |
| `-ie`          | `PHPEasyInitEnum`          | **I**nitialize **e**num in current file |
