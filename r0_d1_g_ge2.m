intrinsic pgin(g::RngIntElt, hyp::BoolElt) -> Any
  {Pointed generic initial ideal for a curve of genus >= 2 having a log divisor of degree 1 and no stacky points.}

  k := Rationals();
  if not hyp then // nonhyperelliptic, Theorem 4.5.2
    wts := [3] cat [2, 2] cat [1 : i in [1..g]];
    R<[x]> := PolynomialRing(k,wts);
    z := x[1];
    y := GeneratorsSequence(R)[2..3];
    x := GeneratorsSequence(R)[4..g+3];
    gens := &cat[[x[i]*x[j] : j in [i+1..g-2]] : i in [1..g-2]];
    gens := gens cat [y[1]*x[i] : i in [1..g-1]];
    gens := gens cat [y[2]*x[i] : i in [1..g-1]];
    gens := gens cat [x[i]^2*x[g-1] : i in [1..g-3]];
    gens := gens cat [y[1]^2, y[1]*y[2], x[g-2]^3*x[g-1]];
    gens := gens cat [z*x[i] : i in [1..g-1]];
    gens := gens cat [z*y[1], z^2];
    return gens;
  else // hyperelliptic, Theorem 4.4.2
    wts := [3] cat [2 : i in [1..g]] cat [1 : i in [1..g]];
    R<[x]> := PolynomialRing(k,wts);
    z := x[1];
    y := GeneratorsSequence(R)[2..g+1];
    x := GeneratorsSequence(R)[g+2..2*g+1];
    gens := &cat[[x[i]*x[j] : j in [i+1..g-1]] : i in [1..g-1]];
    gens := gens cat &cat[[y[i]*x[j] : j in [1..g-1]] : i in [1..g-1]];
    gens := gens cat &cat[[y[i]*y[j] : j in [i..g] | not (i eq g and j eq g)] : i in [1..g]];
    gens := gens cat [z*x[i] : i in [1..g-1]];
    gens := gens cat [y[g]^2*x[i] : i in [1..g-1]];
    gens := gens cat [z*y[i] : i in [1..g-1]];
    gens := gens cat [z^2];
  end if;
  return gens;
end intrinsic;
