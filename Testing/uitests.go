package main

import (
	"log"
	"os"
	"os/exec"
)

func main() {
	stdOut := os.Stdout
	stdErr := os.Stderr
	_, err := stdOut.Write([]byte("Running Fleet UI tests...\n"))
	if err != nil {
		log.Fatal(err)
	}

	uiTestCommand := exec.Command("xcodebuild", "-workspace", "FleetUI.xcworkspace", "-scheme", "FleetUI", "-destination", "platform=iOS Simulator,name=iPhone 6", "clean", "build", "test")
	uiTestCommand.Stdout = stdOut
	uiTestCommand.Stderr = stdErr
	uiTestErr := uiTestCommand.Run()
	if uiTestErr != nil {
		log.Fatal(uiTestErr)
	}

	_, err = stdOut.Write([]byte("Fleet UI tests passed...\n"))
	if err != nil {
		log.Fatal(err)
	}
}
