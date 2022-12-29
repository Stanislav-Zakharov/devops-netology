package main

import "fmt"

func main() {
	const poundInMeter float64 = 0.3048

	fmt.Print("Enter a number:")

	var input float64 = 1
	fmt.Scanf("%f", &input)

	fmt.Println(input * poundInMeter)
}
