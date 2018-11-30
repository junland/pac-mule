package server

import (
	"context"
	"fmt"
	log "github.com/sirupsen/logrus"
	"io/ioutil"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/junland/pac-mule/utils"
)

const (
	defLvl  = "info"
	defPort = "8080"
	defConf = "/etc/pac-mule/pac.js"
	defPID  = "/var/run/pac-mule.pid"
	defTLS  = "false"
)

type PACFile struct {
	content string
}

// Sets up and starts the main server application
func Start() {
	// Get log level enviroment variable.
	envLvl, err := log.ParseLevel(utils.GetEnv("MULE_LOG_LVL", defLvl))
	if err != nil {
		fmt.Println("Invalid log level ", utils.GetEnv("MULE_LOG_LVL", defLvl))
	} else {
		// Setup logging with Logrus.
		log.SetLevel(envLvl)
	}

	envCert := utils.GetEnv("MULE_CERT", "")
	envKey := utils.GetEnv("MULE_KEY", "")
	envTLS := utils.GetEnv("MULE_TLS", defTLS)

	if envTLS == "true" {
		if envCert == "" || envKey == "" {
			log.Fatal("Invalid TLS configuration, please pass a file path for both MULE_KEY and MULE_CERT")
		}
	}

	log.Info("Setting up server...")

	envPort := utils.GetEnv("MULE_SRV_PORT", defPort)
	envPID := utils.GetEnv("MULE_PID_FILE", defPID)

	// Get and check PAC file.
	stat, err := os.Stat(utils.GetEnv("MULE_PAC_FILE", defConf))
	if err != nil {
		log.Fatal(err)
	}

	// This can be adjusted, however just defaulted to 1MiB for the file.
	if stat.Size() > int64(1048576) {
		log.Fatal("PAC file is bigger than 1 MiB")
	}

	log.Info("PAC file is OK...")

	b, err := ioutil.ReadFile(utils.GetEnv("MULE_PAC_FILE", defConf))
	if err != nil {
		fmt.Print(err)
	}

	content := string(b)

	log.Debug("Setting route info...")

	// Configure router and routes.
	router := http.DefaultServeMux
	router.HandleFunc("/config", PACFile{content}.giveConfig)

	srv := &http.Server{Addr: ":" + envPort, Handler: router}

	log.Debug("Starting server on port ", envPort)

	go func() {
		if defTLS == "true" {
			err := srv.ListenAndServeTLS(envCert, envKey)
			if err != nil {
				log.Fatal("ListenAndServeTLS: ", err)
			}
		}
		err := srv.ListenAndServe()
		if err != nil {
			log.Fatal("ListenAndServe: ", err)
		}
	}()

	log.Info("Serving on port " + envPort + ", press CTRL + C to shutdown.")

	p := utils.NewPID(envPID)

	stopChan := make(chan os.Signal)

	signal.Notify(stopChan, os.Interrupt)

	<-stopChan // wait for SIGINT

	log.Warn("Shutting down server...")

	defer p.RemovePID()

	ctx, _ := context.WithTimeout(context.Background(), 5*time.Second) // shut down gracefully, but wait no longer than 5 seconds before halting

	srv.Shutdown(ctx)
}
