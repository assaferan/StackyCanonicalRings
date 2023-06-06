RF := recformat< genus : RngIntElt, stacky_orders : SeqEnum, log_degree : RngIntElt> // extra data like IsHyperelliptic, IsTrigonal, IsPlaneQuintic?

intrinsic IsBaseCase(rec::Rec) -> BoolElt
  {Given a signature record, return true if the signature is one of the base cases; otherwise, return false. See Theorem 8.3.1 of JV-DZB.}

  g := rec`genus;
  r := #rec`stacky_orders;
  delta := rec`log_degree;
  if r eq 0 then return true; end if;
  if g ge 2 then return false; end if;
  if (g eq 1) and (r + 2*delta lt 2) then return true; end if;
  if (g eq 0) and (delta lt 2) then return true; end if;
  return false;
end intrinsic;
