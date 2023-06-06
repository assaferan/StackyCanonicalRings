/**************************************************
  Magma script for computing the generic initial
  ideal. In general this depends casewise on whether
  the divisor K + Delta embeds C as an elliptic normal 
  curve (the case when deg(Delta) \geq 5, or otherwise.

  The intrinsics in this file are:

**************************************************/

intrinsic GenusOnePointedGenericInitialIdeal(deg_delta::RngIntElt) -> SeqEnum
{
  On input deg_delta := deg(\Delta) where \Delta is a divisor on 
  X, we output the pointed generic initial ideal gin_<(I;S).
  
}
    ZZ := Integers(); //base field, one can change.
    
    if deg_delta eq 1 then
        // Elliptic curve with Weiertsrass equation
        
         P<[x]> := PolynomialRing(ZZ, [3,2,1]);
         return [x[1]^2];

    elif deg_delta eq 2 then
        // A degree 2 genus one curve (double cover of P1 ramified over 4 points)
        
        P<[x]> := PolynomialRing(ZZ, [2,1,1]);
        return [x[1]^2];

    elif deg_delta eq 3 then
        // A degree 3 genus one curve (plane cubic)

        P<[x]> := PolynomialRing(ZZ, [1,1,1]);
        return [x[1]^3];
    else
        // An n-covering, genus one normal curve
        
        P<[x]> := PolynomialRing(ZZ, [1 : 1 in [1..deg_delta]]);
        l1 := [[x[i]*x[j] : i in [1..j-1] | <i,j> ne <deg_delta-2, deg_delta-1> ] : j in 1..deg_delta-1];
        l2 := [x[deg_delta-2]^2*x[deg_delta-1]];
        return l1 cat l2;
    end if;

end intrinsic;

    
         
