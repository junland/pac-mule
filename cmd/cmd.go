package cmd

import (
	"flag"
	"fmt"
	"os"

	"github.com/junland/pac-mule/server"
)

var BinVersion string
var GoVersion string

// Starts the processing of CLI commands and flags.
func Run() {
	flag.Usage = func() {
		fmt.Printf("Usage of pac-mule:\n")
		fmt.Printf("Commands:\n")
		fmt.Printf("    start     Starts the server.\n")
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
		server.Start()
	case "version":
		fmt.Printf("Made with love.\n")
		fmt.Printf("Version: %s\n", BinVersion)
		fmt.Printf("Go Version: %s\n", GoVersion)
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
