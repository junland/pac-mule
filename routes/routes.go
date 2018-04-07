package routes

import (
	log "github.com/sirupsen/logrus"
	"net/http"
)

// Handler to send the PAK file to client.
func giveConfig(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/x-ns-proxy-autoconfig")
	log.Info("Remote Address: " + r.RemoteAddr + " Method: " + r.Method + " Endpoint: " + r.URL.Path)
	file := GetEnv("MULE_PAC_FILE", defConf)
	http.ServeFile(w, r, file)
}
