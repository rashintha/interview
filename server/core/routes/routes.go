package routes

import (
	_ "github.com/rashintha/interview/api"
	"github.com/rashintha/interview/core/lib/env"
	"github.com/rashintha/interview/core/lib/log"
	"github.com/rashintha/interview/core/lib/router"
	corsUtil "github.com/rashintha/interview/core/middleware/cors"

	// jwtAuth "github.com/rashintha/interview/core/middleware/jwt"

	"github.com/gin-gonic/gin"
)

var Router *gin.Engine

func init() {
	if env.CONF["MODE"] == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	Router = gin.Default()
	Router.SetTrustedProxies(nil)
	Router.Use(corsUtil.CORS())
	// Router.Use(jwtAuth.AuthorizeJWT())

	log.Defaultln("Initializing routes")

	for key, value := range router.GetRoutes {
		Router.GET(key, value)
	}

	for key, value := range router.PostRoutes {
		Router.POST(key, value)
	}

	for key, value := range router.PutRoutes {
		Router.PUT(key, value)
	}

	for key, value := range router.DeleteRoutes {
		Router.DELETE(key, value)
	}

	for key, value := range router.PatchRoutes {
		Router.PATCH(key, value)
	}
}
