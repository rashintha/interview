package router

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/rashintha/interview/core/lib/env"
)

var GetRoutes = map[string]gin.HandlerFunc{}
var NoAuthGetPaths = []string{}
var PostRoutes = map[string]gin.HandlerFunc{}
var NoAuthPostPaths = []string{}
var PutRoutes = map[string]gin.HandlerFunc{}
var NoAuthPutPaths = []string{}
var DeleteRoutes = map[string]gin.HandlerFunc{}
var NoAuthDeletePaths = []string{}
var PatchRoutes = map[string]gin.HandlerFunc{}
var NoAuthPatchPaths = []string{}

func Get(path string, handler gin.HandlerFunc, authRequired ...bool) {
	authReq := true
	finalPath := fmt.Sprintf("%s%s", env.CONF["API_PREFIX"], path)

	if len(authRequired) > 0 {
		authReq = authRequired[0]
	}

	if !authReq {
		NoAuthGetPaths = append(NoAuthGetPaths, finalPath)
	}

	GetRoutes[finalPath] = handler
}

func Post(path string, handler gin.HandlerFunc, authRequired ...bool) {
	authReq := true
	finalPath := fmt.Sprintf("%s%s", env.CONF["API_PREFIX"], path)

	if len(authRequired) > 0 {
		authReq = authRequired[0]
	}

	if !authReq {
		NoAuthPostPaths = append(NoAuthPostPaths, finalPath)
	}

	PostRoutes[finalPath] = handler
}

func Put(path string, handler gin.HandlerFunc, authRequired ...bool) {
	authReq := true
	finalPath := fmt.Sprintf("%s%s", env.CONF["API_PREFIX"], path)

	if len(authRequired) > 0 {
		authReq = authRequired[0]
	}

	if !authReq {
		NoAuthPutPaths = append(NoAuthPutPaths, finalPath)
	}

	PutRoutes[finalPath] = handler
}

func Delete(path string, handler gin.HandlerFunc, authRequired ...bool) {
	authReq := true
	finalPath := fmt.Sprintf("%s%s", env.CONF["API_PREFIX"], path)

	if len(authRequired) > 0 {
		authReq = authRequired[0]
	}

	if !authReq {
		NoAuthDeletePaths = append(NoAuthDeletePaths, finalPath)
	}

	DeleteRoutes[finalPath] = handler
}

func Patch(path string, handler gin.HandlerFunc, authRequired ...bool) {
	authReq := true
	finalPath := fmt.Sprintf("%s%s", env.CONF["API_PREFIX"], path)

	if len(authRequired) > 0 {
		authReq = authRequired[0]
	}

	if !authReq {
		NoAuthPatchPaths = append(NoAuthDeletePaths, finalPath)
	}

	PatchRoutes[finalPath] = handler
}
