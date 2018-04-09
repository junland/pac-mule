package server

import (
	"context"
	"fmt"
	"io/ioutil"
	log "github.com/sirupsen/logrus"
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
)

type PACFile struct {
    content string
}

func Start() {

  // Get log level enviroment variable.
  envLvl, err := log.ParseLevel(utils.GetEnv("MULE_LOG_LVL", defLvl))
  if err != nil {
    fmt.Println("Invalid log level ", utils.GetEnv("MULE_LOG_LVL", defLvl))
    os.Exit(3)
  }

  // Setup logging with Logrus.
  log.SetOutput(os.Stdout)
  log.SetLevel(envLvl)

	log.Info("Setting up server...")

	envPort := utils.GetEnv("MULE_SRV_PORT", defPort)

	// Checks if the PAK file exists
	if _, err := os.Stat(utils.GetEnv("MULE_PAC_FILE", defConf)); os.IsNotExist(err) {
		log.Fatal("PAC file does not exist at " + utils.GetEnv("MULE_PAC_FILE", defConf))
	}

	log.Info("PAC file exists...")

	log.Info("Loading PAC file...")
	b, err := ioutil.ReadFile(defConf)
	if err != nil {
        fmt.Print(err)
  }

	content := string(b)

	log.Info("Setting route info...")

	// Configures router and routes.
	router := http.DefaultServeMux
	router.HandleFunc("/config", PACFile{content}.giveConfig)

	srv := &http.Server{Addr: ":" + envPort, Handler: router}

	go func() {
		if err := srv.ListenAndServe(); err != nil {
			log.Error("Listen: %s\n", err)
		}
	}()

	p := utils.NewPID("/var/run/pac-mule.pid")

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
