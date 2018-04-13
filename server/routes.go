package server

import (
	log "github.com/sirupsen/logrus"
	"net/http"
)

// Sends the PAC file to client.
func (f PACFile) giveConfig(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/x-ns-proxy-autoconfig")
	log.Info("Remote Address: " + r.RemoteAddr + " Method: " + r.Method + " Endpoint: " + r.URL.Path)
	w.Write([]byte(f.content))
}
