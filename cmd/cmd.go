package cmd

import (
	"flag"
	"fmt"
	"os"
	"syscall"
)

var BinVersion string

const (
	defLvl  = "info"
	defPort = "8080"
	defConf = "/etc/pac-mule/pac.js"
)

func Run() {
	flag.Usage = func() {
		fmt.Printf("Usage of pac-mule:\n")
		fmt.Printf("Commands:\n")
		fmt.Printf("    start     Starts the server.\n")
		fmt.Printf("    stop      Stops the current running server instance.\n")
		fmt.Printf("    version   Shows the version information.\n")
		fmt.Printf("\n")
		fmt.Printf("Options:\n")
		fmt.Printf("    -h --help     Show this screen.\n")
	}

	flag.Parse()

	if len(os.Args) < 2 {
		flag.Usage()
		os.Exit(1)
	}

	switch os.Args[1] {
	case "start":
		return
	case "stop":
		pid, err := ReadPID("/var/run/pac-mule.pid")
		if err != nil {
			fmt.Print(err)
			os.Exit(1)
		}
		syscall.Kill(pid, syscall.SIGINT)
		os.Exit(0)
	case "version":
		fmt.Printf("Made with love.\n")
		fmt.Printf("Version: %s\n", BinVersion)
		fmt.Printf("License: GPLv2\n")
		os.Exit(0)
	default:
		fmt.Printf("%v is not a valid command.\n", os.Args[1])
		os.Exit(3)
	}

	if flag.NArg() == 0 {
		flag.Usage()
		os.Exit(1)
	}

}
