function LogDivisorDelta2Hyperelliptic(h) 
    ZZ := Integers();
    R := PolynomialRing(ZZ, 2*h-2);
    y_vars := [Sprintf("y[%o]", i) : i in [1..h-2]];
    x_vars := [Sprintf("x[%o]", i) : i in [1..h]];
    AssignNames(~R, y_vars cat x_vars);
    y := [R.i : i in [1..h-2]];
    x := [R.i : i in [(h-2) + 1..(h-2) + h]];
    x_mons := [x[i]*x[j] : i,j in [1..h-1] | i lt j];
    y_mons := [y[i]*y[j] : i,j in [1..h-2]];
    mons := [x[i]*y[j] : i,j in [1..h-2] | (i ne h-2) or (j ne h-2)];
    return x_mons cat mons cat y_mons;
end function;

function LogDivisorDelta2NonHyperelliptic(h) 
    ZZ := Integers();
    R := PolynomialRing(ZZ, 2*h-2);
    y_vars := ["y"];
    x_vars := [Sprintf("x[%o]", i) : i in [1..h]];
    AssignNames(~R, y_vars cat x_vars);
    y := R.1;
    x := [R.i : i in [1 + 1..1 + h]];
    x_mons_2 := [x[i]*x[j] : i,j in [1..h-2] | i lt j];
    x_mons_3 := [x[i]^2 * x[h-1] : i in [1..h-3]];
    x_mons := x_mons_2 cat x_mons_3;
    mons := [y*x[i] : i in [1..h-1]];
    return x_mons cat mons cat [y^2, x[h-2]^3*x[h-1]];
end function;				 

intrinsic LogDivisorDelta2(g::RngIntElt, hyperelliptic::BoolElt) -> SeqEnum
{Returns the (pointed) generic initial ideal for a classical log divisor with delta = 2 and g ge 2.}
  require g ge 2 : "The genus must be at least 2.";
  h := g + 1;
  if hyperelliptic then
      return LogDivisorDelta2Hyperelliptic(h);
  else
      return LogDivisorDelta2NonHyperelliptic(h);
  end if;
end intrinsic;
