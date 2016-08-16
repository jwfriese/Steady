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
	xcprettyCommand := exec.Command("xcpretty")
	xcprettyCommand.Stdin, err = uiTestCommand.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}

	uiTestCommand.Stderr = stdErr
	xcprettyCommand.Stderr = stdErr
	xcprettyCommand.Stdout = stdOut
	err = xcprettyCommand.Start()
	if err != nil {
		log.Fatal(err)
	}

	err = uiTestCommand.Run()
	if err != nil {
		log.Fatal(err)
	}

	err = xcprettyCommand.Wait()
	if err != nil {
		log.Fatal(err)
	}

	_, err = stdOut.Write([]byte("Fleet UI tests passed...\n"))
	if err != nil {
		log.Fatal(err)
	}
}
