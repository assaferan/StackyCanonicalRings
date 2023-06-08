import "CanRingsQDiv.m": can_ring_info, can_ring_all_moving_pts;

function gin_g_ge_3_r_eq_0_d_eq_0(g, hyp)
/***************************************************
g >= 3, r = 0, delta = 0
Generic initial ideal for a curve of genus >= 3 that 
is nonhyperelliptic and has  no stacky points and no log divisor.
**************************************************/

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
                Append(~gens, x[i]*x[j]);
                Append(~gens, y[i]*y[j]);
                if [i, j] ne [g-2, g-2] then
                    Append(~gens, y[i]*x[j]);
                end if;
            end for;
        end for;
    end if;
    return R, GeneratorsSequence(R), gens;
end function;


function gin_g_le_2_r_eq_0_d_eq_0(g)
/**************************************************  
g <= 2, r = 0, delta = 0                                             
Generic initial ideal for a curve of genus <= 3 that 
has no stacky points and no log divisor.
**************************************************/                                               
    k := Rationals(); // base field

    if (g eq 0) then // trivial cases - these print out the rings and return an empty gin
      R := k;
      gens := [k | ];
    end if;
    
    if (g eq 1) then
      R<u> := PolynomialRing(k);
      gens := [k | ];
    end if;

    if (g eq 2) then // genus 2 case
      R<y,x,u> := PolynomialRing(k, [3,1,1]);
      gens := [y^2];
      end if;
    return R, GeneratorsSequence(R), gens;
end function;


function gin_g_eq_1_r_eq_0(delta)
/**************************************************
g = 1, r = 0, delta = anything
On input delta := deg(Delta) where Delta is a divisor on 
X, we output the pointed generic initial ideal gin
**************************************************/
    k := Rationals(); //base field, one can change.
    
    if delta eq 1 then
        // Elliptic curve with Weiertsrass equation
        
         P<[x]> := PolynomialRing(k, [3,2,1]);
         return P, GeneratorsSequence(P), [x[1]^2];

    elif delta eq 2 then
        // A degree 2 genus one curve (double cover of P1 ramified over 4 points)
        
        P<[x]> := PolynomialRing(k, [2,1,1]);
        return P, GeneratorsSequence(P), [x[1]^2];

    elif delta eq 3 then
        // A degree 3 genus one curve (plane cubic)

        P<[x]> := PolynomialRing(k, [1,1,1]);
        return P, GeneratorsSequence(P), [x[1]^3];
    else
        // An n-covering, genus one normal curve
        
        P<[x]> := PolynomialRing(k, [1 : i in [1..delta]]);
        l1 := [[x[i]*x[j] : i in [1..j-1] | <i,j> ne <delta-2, delta-1> ] : j in [1..delta-1]];
        l2 := [x[delta-2]^2*x[delta-1]];
        return P, GeneratorsSequence(P), l1 cat l2;
    end if;
end function;


function gin_g_eq_1_r_eq_1_d_eq_0(e)
/**************************************************
(g=1, r=1, delta = 0). 
Generic initial ideal for a curve of genus 1 that 
has one stacky point of order e and no log divisor.
**************************************************/
    k := Rationals();
    
    if (e eq 2) then
        P<[x]> := PolynomialRing(k, [6, 4, 1]);
        return P, GeneratorsSequence(P), [x[1]^3];

    elif (e eq 3) then
        P<[x]> := PolynomialRing(k, [5, 3, 1]);
        return P, GeneratorsSequence(P), [x[1]^2];
        
    elif (e eq 4) then
        P<[x]> := PolynomialRing(k, [4, 3, 1]);
        return P, GeneratorsSequence(P), [x[2]^3];

    elif (e ge 5) then
        P<[x]> := PolynomialRing(k, [d : d in [1..e]]);
    	gens := [];
    	for i in [3..e-1] do
      	    for j in [i..e-1] do
        	Append(~gens, x[i]*x[j]);
      	    end for;
    	end for;
        
    	return P, GeneratorsSequence(P), gens;
    end if;             
end function;


function LogDivisorDelta2Hyperelliptic(h) 
    k := Rationals();
    R := PolynomialRing(k, 2*h-2);
    y_vars := [Sprintf("y[%o]", i) : i in [1..h-2]];
    x_vars := [Sprintf("x[%o]", i) : i in [1..h]];
    AssignNames(~R, y_vars cat x_vars);
    y := [R.i : i in [1..h-2]];
    x := [R.i : i in [(h-2) + 1..(h-2) + h]];
    x_mons := [x[i]*x[j] : i,j in [1..h-1] | i lt j];
    y_mons := [y[i]*y[j] : i,j in [1..h-2]];
    mons := [x[i]*y[j] : i,j in [1..h-2] | (i ne h-2) or (j ne h-2)];
    return R, GeneratorsSequence(R), x_mons cat mons cat y_mons;
end function;

function LogDivisorDelta2NonHyperelliptic(h) 
    k := Rationals();
    R := PolynomialRing(k, 2*h-2);
    y_vars := ["y"];
    x_vars := [Sprintf("x[%o]", i) : i in [1..h]];
    AssignNames(~R, y_vars cat x_vars);
    y := R.1;
    x := [R.i : i in [1 + 1..1 + h]];
    x_mons_2 := [x[i]*x[j] : i,j in [1..h-2] | i lt j];
    x_mons_3 := [x[i]^2 * x[h-1] : i in [1..h-3]];
    x_mons := x_mons_2 cat x_mons_3;
    mons := [y*x[i] : i in [1..h-1]];
    return R, GeneratorsSequence(R), x_mons cat mons cat [y^2, x[h-2]^3*x[h-1]];
end function;				 

function gin_g_eq_2_r_eq_0_d_eq_2(g, hyp)
/**************************************************
g>=2, r=0, delta=2
Returns the (pointed) generic initial ideal for a 
classical log divisor with delta = 2 and g ge 2.
**************************************************/
  assert g ge 2;
  h := g + 1;
  if hyp then
      return LogDivisorDelta2Hyperelliptic(h);
  else
      return LogDivisorDelta2NonHyperelliptic(h);
  end if;
end function;

// this is the top-level intrinsic 
intrinsic GenericInitialIdealBaseCase(g::RngIntElt,e::SeqEnum[RngIntElt],delta::RngIntElt,hyp::BoolElt) -> SeqEnum
  {Returns the (pointed) generic initial ideal for the base cases in VZB} 

    assert IsBaseCase(g,e,delta);
    r := #e;
    if r eq 0 then
        if g eq 1 then
            return gin_g_eq_1_r_eq_0(delta);
        elif g eq 2 and delta eq 2 then  
            gin_g_eq_2_r_eq_0_d_eq_2(g, hyp);
        elif g le 2 and delta eq 0 then
            return gin_g_le_2_r_eq_0_d_eq_0(g);
        elif g ge 3 and delta eq 0 then
          return gin_g_ge_3_r_eq_0_d_eq_0(g, hyp);
        end if;

    elif r eq 1 then
        if g eq 1 and delta eq 0 then
            return gin_g_eq_1_r_eq_1_d_eq_0(e[1]);
        end if;

    elif g eq 0 then
      can_ring_all_moving_pts(e);
    end if;

    error "Information does not define a base case";
end intrinsic;

intrinsic GinBaseCase(g::RngIntElt, e::SeqEnum, delta::RngIntElt, hyp::BoolElt) -> Any
  {}
  return GenericInitialIdealBaseCase(g,e,delta,hyp);
end intrinsic;

intrinsic GenericInitialIdealBaseCase(s::Rec) -> Any
  {}
  g := s`Genus;
  es := s`StackOrders;
  delta := s`LogDegree;
  hyp := s`IsHyperelliptic;
  return GenericInitialIdealBaseCase(g, es, delta, hyp);
end intrinsic;

intrinsic GinBaseCase(s::Rec) -> Any
  {}
  return GenericInitialIdealBaseCase(s);
end intrinsic;
