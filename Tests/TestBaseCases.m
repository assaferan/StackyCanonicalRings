// define record type
RF := recformat< Genus : RngIntElt, StackyOrders : SeqEnum, LogDegree : RngIntElt, IsHyperelliptic: BoolElt>; // extra data like IsTrigonal, IsPlaneQuintic?

// r=0: no stacky points

// r=0, delta>0, g=0
// Evan's code
s := rec< RF | Genus := 0, StackyOrders := [], LogDegree := 3, IsHyperelliptic := false >;
GinBaseCase(s);

// r=0, delta>0

// r=0, delta>0, g=1
s := rec< RF | Genus := 1, StackyOrders := [], LogDegree := 2, IsHyperelliptic := false >;
GinBaseCase(s);

// r=0, delta=1, g>=2
s := rec< RF | Genus := 2, StackyOrders := [], LogDegree := 1, IsHyperelliptic := true >;
GinBaseCase(s);

// r=0, delta=2, g>=2
s := rec< RF | Genus := 2, StackyOrders := [], LogDegree := 2, IsHyperelliptic := true >;
GinBaseCase(s);

// r=0, delta>=3, g>=2
s := rec< RF | Genus := 2, StackyOrders := [], LogDegree := 3, IsHyperelliptic := true >;
GinBaseCase(s);

// r=0, delta=0

// r=0, delta=0, g<=2
s := rec< RF | Genus := 2, StackyOrders := [], LogDegree := 0, IsHyperelliptic := true >;
GinBaseCase(s);

// r=0, delta=0, g>=3, hyperelliptic
s := rec< RF | Genus := 3, StackyOrders := [], LogDegree := 0, IsHyperelliptic := true >;
GinBaseCase(s);

// r=0, delta=0, g>=3, non-hyperelliptic
s := rec< RF | Genus := 3, StackyOrders := [], LogDegree := 0, IsHyperelliptic := false>;
GinBaseCase(s);

// r>=1: with stacky points