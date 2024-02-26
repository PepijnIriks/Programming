package main

import (
	"fmt"
	"time"
)

func main() {
	currentHour := time.Now().Hour()

	var greeting string

	if currentHour >= 7 && currentHour < 12 {
		greeting = "Goedemorgen"
	} else if currentHour >= 12 && currentHour < 18 {
		greeting = "Goedemiddag"
	} else if currentHour >= 18 && currentHour < 23 {
		greeting = "Goedenavond"
	} else {
		greeting = "Sorry, de parkeerplaats is 's nachts gesloten"
	}

	fmt.Printf("%s! Welkom bij Fonteyn Vakantieparken\n", greeting)
}
