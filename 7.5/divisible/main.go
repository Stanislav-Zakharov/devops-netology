package main

import (
	"fmt"
	"math"
)

func main() {
	seq := []int{}

	for i := 1; i <= 100; i++ {
		seq = append(seq, i)
	}

	fmt.Printf("Sequence devided by 3 is %v\n", findModulusSequence(seq, 3))
}

func findModulusSequence(seq []int, div int) []int {
	res := []int{}
	for _, v := range seq {
		if math.Mod(float64(v), float64(div)) == 0 {
			res = append(res, v)
		}
	}

	return res
}
