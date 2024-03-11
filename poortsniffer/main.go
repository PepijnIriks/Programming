package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"sort"
	"strconv"
	"sync"
)

func scanPort(protocol, hostname string, port int, openPorts *[]int, mutex *sync.Mutex) {
	address := hostname + ":" + strconv.Itoa(port)
	conn, err := net.Dial(protocol, address)
	if err == nil {
		conn.Close()
		mutex.Lock()
		*openPorts = append(*openPorts, port)
		mutex.Unlock()
	}
}

func main() {
	var wg sync.WaitGroup
	var mutex sync.Mutex
	protocol := "tcp"
	hostname := "127.0.0.1"
	portStart := 1
	portEnd := 10000
	var openPorts []int

	for port := portStart; port <= portEnd; port++ {
		wg.Add(1)
		go func(p int) {
			defer wg.Done()
			scanPort(protocol, hostname, p, &openPorts, &mutex)
		}(port)
	}
	wg.Wait()

	sort.Ints(openPorts) // Sort the slice of open ports

	// Marshal the slice of open ports into JSON
	openPortsJSON, err := json.Marshal(openPorts)
	if err != nil {
		fmt.Println("Error marshaling to JSON:", err)
		return
	}

	// Write the JSON to a file
	jsonFileName := "open_ports.json"
	err = os.WriteFile(jsonFileName, openPortsJSON, 0644) // 0644 provides read/write permissions for the owner and read-only for others
	if err != nil {
		fmt.Println("Error writing JSON to file:", err)
		return
	}

	fmt.Printf("Open ports saved to %s\n", jsonFileName)
}
