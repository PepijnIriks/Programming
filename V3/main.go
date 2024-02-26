package main

import (
	"fmt"
	"time"
)

func main() {
	// Array van toegestane kentekens
	allowedPlates := []string{"RFFD71", "ABC123", "XYZ789"} // Voeg hier alle gewenste kentekens toe

	var inputPlate string

	currentTime := time.Now()
	hour := currentTime.Hour()

	morgen := "Goedemorgen"
	middag := "Goedemiddag"
	nacht := "Goedeavond"

	fmt.Println("Welkom, voer uw kenteken in.")
	fmt.Scan(&inputPlate)

	// Controleren of het ingevoerde kenteken in de lijst van toegestane kentekens staat
	var isAllowed bool
	for _, plate := range allowedPlates {
		if inputPlate == plate {
			isAllowed = true
			break
		}
	}

	if isAllowed {
		if hour >= 7 && hour < 12 {
			fmt.Println(morgen)
		} else if hour >= 12 && hour < 18 {
			fmt.Println(middag)
		} else if hour >= 18 && hour < 23 {
			fmt.Println(nacht)
		} else {
			fmt.Println("De parkeerplaats is 's nachts gesloten. Excuus voor het ongemak.")
		}
	} else {
		fmt.Println("Je hebt geen toegang tot de parkeerplaats. Excuses voor het ongemak.")
	}
}
