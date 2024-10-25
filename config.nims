import strformat
import strutils
import os

proc install_dependencies() =
    for line in readFile(&"{thisDir()}/dependencies.txt").split('\n'):
        exec(&"nimble list -i | grep -q '{line}' || nimble install {line}")

proc compile(release: bool) =
    var args: seq[string]
    if release:
        args.add(&"--checks:off")
        args.add(&"--verbosity:0")
        args.add(&"-d:danger")
        args.add(&"--opt:speed")
        args.add(&"-d:strip")
    args.add("--threads:on")
    args.add(&"--outdir:{thisDir()}/bin")
    args.add(&"{thisDir()}/src/mvtui.nim")

    exec("nim c " & args.join(" "))

task release, "Builds the project in release mode":
    echo "\e[36;1mBuilding\e[0;0m in release mode"
    install_dependencies()
    compile(true)

task debug, "Builds the project in debug mode":
    echo "\e[36;1mBuilding\e[0;0m in debug mode"
    install_dependencies()
    compile(false)
