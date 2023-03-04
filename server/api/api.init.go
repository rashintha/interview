package api

import "github.com/rashintha/interview/core/lib/router"

func init() {
	// API
	router.Get("/", getAPI, false)
	router.Get("/status", getAPIStatus, false)
}
