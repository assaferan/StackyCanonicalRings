E := EllipticCurve([1,2,3,4,0]); // random with a point at (0,0)
P1 := E ! 0;
P2 := E ! [0, 0];

function sec_ring_info(alpha, beta)
  RR := [];
  maps := [];
  gdegs := [];
  gens := [];
  if alpha + beta le 0 then
    return [];
  end if;
  for d in [1..Ceiling(3/(alpha + beta)) + 10] do
    D := Floor(alpha*d) * Divisor(P1) + Floor(beta*d) * Divisor(P2);
    RR_d, map_d := RiemannRochSpace(D);
    RR cat:= [RR_d];
    maps cat:= [map_d];
    W := sub<RR_d | >;
    for d1 in [1..Floor(d/2)] do
      d2 := d - d1;
      map1 := maps[d1];
      map2 := maps[d2];
      for v1 in Basis(RR[d1]) do
        for v2 in Basis(RR[d2]) do
          v := Inverse(map_d)(map1(v1)*map2(v2));
          if not(v in W) then
            W +:= sub<RR_d | v>;
          end if;
        end for;
      end for;
      if W eq RR_d then break; end if;
    end for;
    for v in Basis(RR_d) do
      if not(v in W) then
        W +:= sub<RR_d | v>;
        gdegs cat:= [d];
        gens cat:= [v];
        if W eq RR_d then break; end if;
      end if;
    end for;
  end for;
  return gdegs;
end function;

sec_ring_info(1/2, -1/3)