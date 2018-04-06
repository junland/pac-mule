package main

import (
        "testing"
)


func TestCreateAndRemovePIDFile(t *testing.T) {
        file := NewPID("./testpid.pid")
        file.RemovePID()
}
