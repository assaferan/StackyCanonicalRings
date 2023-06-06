//Generic initial ideal for a curve of genus <= 3 that has no stacky points and no log divisor.



function gin(g)

k := ComplexField(); //base field
gens := [];

//trivial cases - these print out the rings and return an empty gin
if (g eq 0) then
	R := k;
	print(R);
end if;
if (g eq 1) then
	R<u> := PolynomialRing(k);
	print(R);
end if;

//genus 2 case
if (g eq 2) then
	R<x,u,y> := PolynomialRing(k, [1,1,3]);
	Append(~gens, y^2);
end if;
return gens;
end function;