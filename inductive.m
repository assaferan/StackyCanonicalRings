/*
  To make a new record, write rec< RF | L >, where L is the field assignment list. E.g., 

  RF := recformat< Genus : RngIntElt, StackyOrders : SeqEnum, LogDegree : RngIntElt, IsHyperelliptic: BoolElt>; // extra data like IsTrigonal, IsPlaneQuintic?
  s := rec< RF | Genus := 2, StackyOrders := [2,2,3,4], LogDegree := 5, IsHyperelliptic := false >;
*/

intrinsic IsBaseCase(s::Rec) -> BoolElt
  {Given a signature record, return true if the signature is one of the base cases; otherwise, return false. See Theorem 8.3.1 of JV-DZB.}

  g := s`Genus;
  e := s`StackyOrders;
  delta := s`LogDegree;
  return IsBaseCase(g,e,delta);
end intrinsic;

intrinsic IsBaseCase(g::RngIntElt,e::SeqEnum[RngIntElt],delta::RngIntElt) -> SeqEnum
  {Given a genus, sequence of orders of stacky points, and degree of the log divisor, return true if the signature is one of the base cases; otherwise, return false. See Theorem 8.3.1 of JV-DZB.}
  
  r := #e;
  if r eq 0 then return true; end if;
  if (g eq 1) and (r + 2*delta lt 2) then return true; end if;
  if (g eq 0) and (delta lt 2) then return true; end if;
  return false;
end intrinsic;

intrinsic InductiveStep(s::Rec) -> Rec
  {}
  return false;
end intrinsic;

intrinsic GinInductiveStep(s::Rec) -> Any 
  {}

  //rec_cnt := 0;
  if IsBaseCase(s) then
    return GenericInitialIdealBaseCase(s);
  else
    s_new := s;
    e := s_new`StackyOrders[#s_new`StackyOrders];
    s_new`StackyOrders := s_new`StackyOrders[1..#s_new`StackyOrders-1];
    R<[x]>, gens, rels := $$(s_new); // recurse
    k := BaseRing(R);
    m := #x;
    assert Degree(x[m]) eq 1;
    assert &and[x[m] lt x[i] : i in [1..m-1]];
    R_new := PolynomialRing(k, [2..e] cat Grading(R));
    y := [* "" *] cat [* R_new.i : i in [1..e-1] *];
    x := [* R_new.i : i in [(e-1)+ 1..(e-1) + Rank(R)] *];
    x_vars := [Sprintf("x[%o]", i) : i in [1..Rank(R)]];
    y_vars := [Sprintf("y[%o]", i) : i in [2..e]];
    AssignNames(~R_new, y_vars cat x_vars);
    // add new relations: Thm 8.3.1(b)
    new_rels := [];
    for i := 2 to e do
      for j := 1 to Rank(R)-1 do
        Append(~new_rels, y[i]*x[j]);
      end for;
    end for;
    for i := 2 to e-1 do
      for j := i to e-1 do
        Append(~new_rels, y[i]*y[j]);
      end for;
    end for;
    // map old relations into new ring
    h := hom< R -> R_new | [R_new.i : i in [1..Rank(R)]] >;
    return R_new, GeneratorsSequence(R_new), [h(r) : r in rels] cat new_rels;
    //rec_cnt +:= 1;
  end if;
  return false;
end intrinsic;

intrinsic GinLogStackyCurve(s::Rec) -> Any
{Return the generic initial ideal of a log stacky curve.}
  return GinInductiveStep(s);
end intrinsic;
