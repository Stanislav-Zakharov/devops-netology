package main

import "testing"

func TestMinLocator(t *testing.T) {
	seq := []int{3, 1, 2}

	if min := findMinElement(seq); min != 1 {
		t.Fatalf("findMinElement(%v) want %v got %v", seq, 1, min)
	}
}
