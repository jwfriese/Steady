package main

import (
	"io"
	"log"
	"os"
	"os/exec"
)

func main() {
	stdOut := os.Stdout
	stdErr := os.Stderr

	runUITests(stdOut, stdErr)

	_, _ = stdOut.Write([]byte("All tests passed"))
}

func runUITests(stdOut io.Writer, stdErr io.Writer) {
	runCommand := exec.Command("go", "run", "Testing/uitests.go")
	runCommand.Stdout = stdOut
	runCommand.Stderr = stdErr

	runErr := runCommand.Run()
	if runErr != nil {
		log.Fatal(runErr)
	}
}
