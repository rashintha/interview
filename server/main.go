package main

import (
	"github.com/rashintha/interview/core/lib/env"
	"github.com/rashintha/interview/core/lib/log"
	"github.com/rashintha/interview/core/routes"
)

func init() {
	log.Defaultln("Starting server on " + env.CONF["HOST"] + ":" + env.CONF["PORT"])
}

func main() {
	routes.Router.Run(env.CONF["HOST"] + ":" + env.CONF["PORT"])
}
