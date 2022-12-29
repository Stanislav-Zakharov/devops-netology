package main

import (
	"fmt"
)

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	fmt.Printf("Minimal number is %d\n", findMinElement(x))
}

func findMinElement(x []int) int {
	var min int

	for i, v := range x {
		if i == 0 || v < min {
			min = v
		}
	}

	return min
}
