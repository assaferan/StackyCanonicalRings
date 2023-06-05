/**************************************************
  Magma script for computing the generic initial
  ideal. In general this depends casewise on whether
  the divisor K + Delta embeds C as an elliptic normal 
  curve (the case when deg(Delta) \geq 5, or otherwise.

  The intrinsics in this file are:

**************************************************/

intrinsic GenusOnePointedGenericInitialIdeal(deg_delta)
{
  On input deg_delta := deg(\Delta) where \Delta is a divisor on 
  X, we output the pointed generic initial ideal gin_<(I;S).
  
}
    ZZ := Integers(); //base field, one can change.
    
    if deg_delta eq 1 then
         P<[x]> := PolynomialRing(ZZ, [3,2,1]);
         return [x[1]^2];

    elif deg_delta eq 2 then
        P<[x]> := PolynomialRing(ZZ, [2,1,1]);
        return [x[1]^2];

    elif deg_delta eq 3 then
        P<[x]> := PolynomialRing(ZZ, [1,1,1]);
        return [x[1]^3];

    else
        return 0;

    end if;

end intrinsic;

    
         
