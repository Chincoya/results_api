package main

import (
	"fmt"
	results_api "results_api/src"
)

func main() {
	var client *results_api.ApiClient

	client = results_api.NewApi()

	fmt.Println(client.FetchParticipants())
	fmt.Println(client.FetchResults(1, 1))
	fmt.Println(client.FetchResults(1, 2))
}
