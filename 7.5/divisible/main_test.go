package main

import (
	"math"
	"testing"
)

func Test(t *testing.T) {
	var div float64 = 3

	for _, v := range findModulusSequence([]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 3) {
		if res := math.Mod(float64(v), div); res != 0 {
			t.Fatalf("math.Mod(%d, %f) want 0 got %f", v, div, res)
		}
	}
}
