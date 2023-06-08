//RF := recformat< genus : RngIntElt, stacky_orders : SeqEnum, log_degree : RngIntElt>; // extra data like IsHyperelliptic, IsTrigonal, IsPlaneQuintic?

/*
  To make a new record, write rec< RF | L >, where L is the field assignment list. E.g., 

  RF := recformat< genus : RngIntElt, stacky_orders : SeqEnum, log_degree : RngIntElt>; // extra data like IsHyperelliptic, IsTrigonal, IsPlaneQuintic?
  s := rec< RF | genus := 2, stacky_orders := [2,2,3,4], log_degree := 5 >;
*/

intrinsic IsBaseCase(s::Rec) -> BoolElt
  {Given a signature record, return true if the signature is one of the base cases; otherwise, return false. See Theorem 8.3.1 of JV-DZB.}

  g := s`genus;
  r := #s`stacky_orders;
  delta := s`log_degree;
  if r eq 0 then return true; end if;
  if g ge 2 then return false; end if;
  if (g eq 1) and (r + 2*delta lt 2) then return true; end if;
  if (g eq 0) and (delta lt 2) then return true; end if;
  return false;
end intrinsic;

intrinsic InductiveStep(s::Rec) -> Rec
  {}
  return false;
end intrinsic;

intrinsic gin_inductive(s::Rec) -> Any 
  {}

  s_i := s;
  /*
  while not IsBaseCase(s_i) do
  end while;
  */
  return false;
end intrinsic;
