# lia-angular-test

POC write Angular tests (wip)

Probably good to know

- Angular 15.2.4
- files generate with Angular CLI (aka `ng g service foobar`)
- VSCODE formatting and prettier is active on save

## how it works

convert folders

```bash
haxe build_interp.hxml -i path/to/folder
//
haxe build_interp.hxml -i _testme/one
```

convert files

```bash
haxe build_interp.hxml -i _testme/one/file.service.ts
```

## help

```
----------------------------------------------------
Lia-angular-test (0.0.1)

  --version / -v        : version number
  --help / -h           : show this help
  --in / -i             : path to project folder
  --out / -o            : write readme (WIP)
  --force / -f          : force overwrite
  --dryrun / -d         : run without writing files
----------------------------------------------------
```
