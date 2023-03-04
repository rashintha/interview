package env

import (
	"os"
	"strings"

	"github.com/rashintha/interview/core/lib/log"
)

var CONF = map[string]string{}

func init() {
	log.Defaultln("Loading environment variables")
	data, err := os.ReadFile(".env")

	if err != nil {
		log.Warningf("%v", err.Error())
	}

	for _, val := range strings.FieldsFunc(string(data), split) {
		if val[:1] != "#" {
			commentSplit := strings.Split(val, "#")
			commentLessString := strings.TrimSpace(commentSplit[0])

			split := strings.Split(commentLessString, "=")

			if len(split) < 2 {
				log.ErrorFatal("Wrong format found in .env")
			}

			CONF[split[0]] = split[1]
		}
	}
}

func split(r rune) bool {
	return r == '\r' || r == '\n'
}
