/*
can_ring_info: A program for computing canonical rings of Q-divisors on P^1.

Input:
alpha: a sequence of n >= 1 rational weights
points: a system of n - 1 points (the first point is always oo), 
Print: whether to print information about what's found (default true)
Factor: whether to work out the locus of exceptional locations of the points
where the presentation found may not hold.

Output: The canonical ring, presented as a quotient of a weighted polynomial 
ring.
*/

function can_ring_info(alpha, points: Print := true, Factor := false)
  
  // The field/ring over which we are working.
  F := Universe(points);
  P<t> := PolynomialRing(F); // for functions in the linear systems
  
  if Print then
    "-------------------------------------------------------------------------";
    print "Computing the ring corresponding to a divisor on P^1 of";
    print "signature", alpha, "at points", <Infinity()> cat <pt : pt in points>;
  end if;
  assert #points eq #alpha - 1;
  s := &+alpha;
  if Print then
    "Degree:", s;
  end if;
  if (s le 0) then
    return F; // the canonical ring is trivial
  end if;
  n := #alpha;
  
  /*
  Goal Hilbert series. We will keep adding generators until we reach this goal 
  in all but finitely many degrees (where the "expected" dimension may be
  negative).
  */
  Z<z> := FunctionField(Integers());
  goal := (1 + &+[Floor(al)*z/(1-z) +
      (al eq Floor(al) select 0 else (&+[z^Ceiling(i*b) : i in [1..Denominator(b)]]
  / (1-z^Numerator(b)) where b is 1/(al - Floor(al)))) : al in alpha]) / (1 - z);
  
  if Factor then
    try
      A := Parent(Numerator(F.1));
      try
        AssignNames(~A, [Sprint(F.i) : i in [1..Rank(F)]]);
      catch e;
      end try;
      Factor := true;
    catch e
      "warning: denominator factorization disabled";
    end try;
  end if;
  
  // The free ring on the known generators.
  G := PolynomialRing(F, 0);
  gdivs := [];
  initials := [];
  rels := [];
  
  if Factor then
    known_denoms := { A | };
    for i in [1..n-2] do
      for j in [i+1..n-1] do
        denom := Numerator(points[j] - points[i]);
        fac := Factorization(denom);
        for rec in fac do
          Include(~known_denoms, rec[1]);
        end for;
      end for;
    end for;
  end if;
  
  // Examine each degree.
  d := 0;
  while true do
    d +:= 1;
    r := &+[Floor(aa*d) : aa in alpha]; // rank of the linear system
    if (r lt 0) then
      continue;
    end if;
    ringchg := false;
    
    // All monomials of the correct degree generated by the known generators.
    mons := #gdivs gt 0 select
    Reverse(Monomials(&+[G|mon : mon in MonomialsOfWeightedDegree(G,d) |
    forall(rel){ rel : rel in initials | not(IsDivisibleBy(mon,rel))}]))
    else [];
    V := VectorSpace(F,r+1);
    
    monvecs := [V![Coefficient(f,j) : j in [0..r]] where f is
      &*[(t - points[i])^(Floor(d*alpha[i]) +
          &+[Degree(mon,Rank(G)+1-j)*gdivs[j,i]
      : j in [1..Rank(G)]]) : i in [1..n-1]] : mon in mons
    ];
    
    gen_idxs := [];
    W := [];
    for i in [1..#mons] do
      if (monvecs[i] in W) then
        // Relation
        ringchg := true;
        coor := Coordinates(W,monvecs[i]);
        newden := Lcm([Denominator(c) : c in coor]);
        /*
        if Factor then
          denom := Lcm(denom, newden);
        end if;
        */
        Append(~initials, mons[i]);
        Append(~rels, newden*(mons[i] - &+[coor[i] * mons[gen_idxs[i]] :
        i in [1..#coor]]));
      else
        // New basis element in this degree
        Append(~gen_idxs, i);
        W := VectorSpaceWithBasis(monvecs[gen_idxs]);
      end if;
    end for;
    
    // Fill out with generators
    if (#gen_idxs lt r+1) then
      for q in [0..r] do
        gdiv := [-Floor(alpha[1]*d) + q] cat
        [-Floor(alpha[i]*d) : i in [2..n-1]] cat [d];
        gen := V![Coefficient(t^q,j)
        : j in [0..r]];
        if (gen in W) then
          if Factor then 
            denom := Lcm([denom] cat [Denominator(c) :
              c in Coordinates(W,gen)]
            );
          end if;
        else
          Append(~gdivs,gdiv);
          Append(~monvecs,gen);
          Append(~gen_idxs,#monvecs);
          W := VectorSpaceWithBasis(monvecs[gen_idxs]);
        end if;
      end for;
      
      gnames := ["g" * Sprint(i) : i in [#gdivs..1 by -1]];
      Gnew := PolynomialRing(F,Reverse([gdiv[n] : gdiv in gdivs]));
      AssignNames(~Gnew, gnames);
      f := hom<G -> Gnew | [Gnew.i : i in [Rank(Gnew)-Rank(G)+1..Rank(Gnew)]]>;
      initials := [Gnew | f(r) : r in initials];
      rels := [Gnew | f(r) : r in rels];
      G := Gnew;
      ringchg := true;
    end if;
    
    /*
    if Factor then
      denom := Lcm([denom,Numerator(Determinant(Matrix(monvecs[gen_idxs])))]);
    end if;
    */
    
    if (ringchg) then
      // Check if we're done
      dif := HilbertSeries(Ideal(initials)) - goal;
      if (Denominator(dif) eq 1 and
      forall(c) {c : c in Coefficients(Numerator(dif)) | c ge 0}) then
        break;
      end if;
    end if;
  end while;

  minbas := MinimalBasis(Ideal(rels));
  
  // Rectify the reversal of generator order (introduced earlier to get correct
  // monomial order).
  Gback<[g]> := PolynomialRing(F,[gdiv[n] : gdiv in gdivs]);
  back := hom<G -> Gback | [Gback.i : i in [#gdivs..1 by -1]]>;
  
  // Print the result found.
  if Print then
    "Generators:", [g[n] : g in gdivs];
    "Groebner relations:", [WeightedDegree(r) : r in initials];
    "Initial ideal:";
    print back(initials);
    /* "Relations are:";
    print back(rels); */
    /*
    if Factor then
      fac := Factorization(denom);
      for rec in fac do
        if (rec[1] notin known_denoms) then
          "### Generators invalid if the following vanishes:", A!rec[1];
          Include(~known_denoms, rec[1]);
        end if;
      end for;
    end if;
    */
    "Minimal relations: ", [Degree(r) : r in minbas];
  end if;
  
  //CRing := quo<Gback | back(minbas)>;
  return Gback, GeneratorsSequence(Gback), back(minbas);
end function;

/*
A reasonably general cross-section: Computes the canonical ring over a finite
field for the given point weights, with points [oo, a, 0, 1, ..., n-3] where a
is a formal parameter.

Input:
alpha: a sequence of n >= 1 rational weights

Output: the canonical ring
*/
function can_ring_one_moving_pt(alpha)
  // Choose a finite field of sufficiently high characteristic.
  k := GF(101);
  F<a> := FunctionField(k);

  return can_ring_info(alpha, [a] cat [0..#alpha-3]: Factor := true);
end function;

/*
A thorough exploration of canonical rings: Computes the canonical ring for the 
given point weights, with points given by formal parameters.

Input:
alpha: a sequence of n >= 1 rational weights

Output: the canonical ring
*/
function can_ring_all_moving_pts(alpha)
  K<[a]> := FunctionField(Rationals(), #alpha);
  return can_ring_info([0] cat alpha, [a[i] : i in [1..#alpha]]:
    Factor := true
  );
end function;

// Test case: All Q-divisors with bounded denominator, n points, 0 < deg D <= 1.
procedure close_cases(n, max_denom)
  fracs := {a/b : a in [1..b-1], b in [1..max_denom]};
  as := Sort(Setseq(Multisets(fracs,n)));
  i := 0;
  
  while i lt #as do
    i +:= 1;
    print "";
    print "Case", i, "of", #as;
    alpha := [x : x in as[i]]; alpha[1] -:= -1 + Ceiling(&+alpha);
    _ := can_ring_all_moving_pts(alpha);
  end while;
end procedure;

/*
Test cases.
*/
/*
can_ring_info([1/2, 2/3, 6/7 - 2], [0/1, 1]: Print := false, Factor := true);
Qsqrt3<sqrt3> := RadicalExtension(Rationals(), 2, 3);
can_ring_info([1/3, 1/5, 1/4, 1/4 - 1], [0, 1, sqrt3]: Print := false);
can_ring_one_moving_pt([-1/2, -1/2, 1/3, 1/3, 1/5, 1/5]);
can_ring_all_moving_pts([-1/2, -1/2, 1/3, 1/3, 1/5, 1/5]);
can_ring_info([-1/2, -1/2, 1/3, 1/3, 1/5, 1/5], [7/3,0,1,2,3]: Factor := true);
close_cases(4, 3);
*/
