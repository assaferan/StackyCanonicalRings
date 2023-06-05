intrinsic gin(g::RngIntElt, hyp::BoolElt) -> Any
  {Generic initial ideal for a curve of genus >= 3 that is nonhyperelliptic and has no stacky points and no log divisor.}

  k := Rationals();
  if not hyp then // nonhyperelliptic, Theorem 2.8.1
    R<[x]> := PolynomialRing(k,g);
    gens := [];
    for i := 1 to g-3 do
      for j := i to g-3 do
        Append(~gens, x[i]*x[j]);
      end for;
      Append(~gens, x[i]*x[g-2]^2);
    end for;
    Append(~gens, x[g-2]^4);
  else // hyperelliptic, Theorem 2.8.4
    wts := [2 : i in [1..g-2]] cat [1 : i in [1..g]];
    R<[x]> := PolynomialRing(k,wts);
    y := GeneratorsSequence(R)[1..g-2];
    x := GeneratorsSequence(R)[g-1..2*g-2];
    gens := [];
    for i := 1 to g-2 do
      for j := i to g-2 do
        Append(~gens x[i]*x[j]);
        Append(~gens y[i]*y[j]);
        if [i, j] ne [g-2, g-2] then
          Append(~gens y[i]*x[j]);
        end if;
      end for;
    end for;
  end if;
  return gens;
end intrinsic;
