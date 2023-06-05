// (g=1, r=1, delta = 0). Input is order of stabilizer group, output is gin
function sig(e)
	if (e eq 2)
	{
		P<y, x, u> := PolynomialRing(RationalField(), [6, 4, 1]);
		I := ideal<P | y^2>;
		return I;
	}
	if (e eq 3)
	{
		P<y, x, u> := PolynomialRing(RationalField(), [5, 3, 1]);
		I := ideal<P | y^2>;
		return I;
	}
	if (e eq 4)
	{
		P<y, x, u> := PolynomialRing(RationalField(), [4, 3, 1]);
		I := ideal<P | x^3>;
		return I;
	}
	if (e ge 5)
	{
		wts := [d : d in [1..e]]];
		R<[x]> := PolynomialRing(RationalField(),wts);
    	x := GeneratorsSequence(R)[1..e];
    	gens := [];
    	for i := 3 to e-1 do
      		for j := i to e-1 do
        		Append(~gens, x[i]*x[j]);
      		end for;
    	end for;
    	return gens 
	}
end function;

