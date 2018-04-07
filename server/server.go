package server

import (
	"context"
	"fmt"
	log "github.com/sirupsen/logrus"
	"net/http"
	"os"
	"os/signal"
	"time"
)

func StartServer() {

  // Get log level enviroment variable.
  envLvl, err := log.ParseLevel(GetEnv("MULE_LOG_LVL", defLvl))
  if err != nil {
    fmt.Println("Invalid log level ", GetEnv("MULE_LOG_LVL", defLvl))
    os.Exit(3)
  }

  // Setup logging with Logrus.
  log.SetOutput(os.Stdout)
  log.SetLevel(envLvl)

	log.Info("Setting up server...")

	envPort := GetEnv("MULE_SRV_PORT", defPort)

	log.Info("Checking PAC file...")

	// Checks if the PAK file exists
	if _, err := os.Stat(GetEnv("MULE_PAC_FILE", defConf)); os.IsNotExist(err) {
		log.Fatal("PAC file does not exist at " + GetEnv("MULE_PAC_FILE", defConf))
	}

	log.Info("PAC file is OK...")

	log.Info("Setting route info...")

	// Configures router and routes.
	router := http.DefaultServeMux
	router.HandleFunc("/config", giveConfig)

	srv := &http.Server{Addr: ":" + envPort, Handler: router}

	go func() {
		if err := srv.ListenAndServe(); err != nil {
			log.Error("Listen: %s\n", err)
		}
	}()

	p := NewPID("/var/run/pac-mule.pid")

	// Sets gracefull shutdown
	stopChan := make(chan os.Signal)

	signal.Notify(stopChan, os.Interrupt)

	<-stopChan // wait for SIGINT

	log.Warn("Shutting down server...")

	defer p.RemovePID()

	// shut down gracefully, but wait no longer than 5 seconds before halting
	ctx, _ := context.WithTimeout(context.Background(), 5*time.Second)
	srv.Shutdown(ctx)
}
