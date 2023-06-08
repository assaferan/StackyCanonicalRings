/*
A function for computing the canonical ring for a curve (of any genus)
corresponding to a Q-divisor supported at a single point P.

Input:
alpha: a rational number, the weight
semigroup: the gaps of the Weierstrass semigroup at P (default [], 
corresponding to P^1)

Output: The generators of the canonical ring, in the form
  <degree, pole order at P>
*/
function can_ring_1pt(alpha: semigroup := [])
  if alpha lt 0 then return []; end if;
  gens := [[1, 0]]; // u
  for c in [1 .. Numerator(alpha) + 3*Max(semigroup cat [0]) + 3] do
    if c in semigroup then
      continue;
    end if;
    // Possible new generator <d, c>.
    d := Ceiling(c/alpha);
    gen := [d, c];
    for c1 in [1 .. Floor(c/2)] do
      if not (c1 in semigroup) and not (c - c1 in semigroup) and
          d eq Ceiling(c1/alpha) + Ceiling((c - c1)/alpha) then
        // Sum of two simpler vectors.
        gen := [];
        break;
      end if;
    end for;
    if gen ne [] then
      gens cat:= [gen];
    end if;
  end for;
  return gens;
end function;


/*
Shortcut for doing the preceding in genus 1.

Input:
alpha: a rational number, the weight

Output: The generators of the canonical ring, in the form
  <degree, pole order at P>
*/
function guess_can_ring_ell(alpha)
  if alpha lt 0 then return []; end if;
  ans := can_ring_1pt(alpha);
  assert ans[1] eq [1,0];
  if #ans eq 1 then
    return ans;
  end if;
  ceil, one := Explode(ans[2]);
  assert one eq 1;
  if #ans ge 3 then
    old := true;
    old2ndpole, old2nddeg := Explode(ans[3]);
  else
    old := false;
  end if;
  Remove(~ans, 2);
  if #ans lt 2 or ans[2][2] gt 2 then
    Insert(~ans, 2, [Ceiling(2/alpha), 2]);
  end if;
  if #ans lt 3 or ans[3][2] gt 3 then
    Insert(~ans, 3, [Ceiling(3/alpha), 3]);
  end if;
  if old then
    new := [ceil + old2ndpole, 1 + old2nddeg];
    if forall(rec) {rec : rec in ans | rec[2] ne new[2]} then
      ans cat:= [new];
      Sort(~ans);
    end if;
  end if;
  return ans;
end function;



// Test cases
/*
[
can_ring_1pt(13/5: semigroup := []), 
can_ring_1pt(13/5: semigroup := [1])
]


g := 1;
for a in [1 .. 30] do
  for b in [3*a .. 4*a] do
    if GCD(a,b) eq 1 then
      "---------------------------------------------";
      print "alpha =", a/b;
      print "P^1:";
      p1 := can_ring_1pt(a/b);
      Matrix(p1);
      print "Genus", g, "curve:";
      ell := can_ring_1pt(a/b: semigroup := [1..g]);
      rem := Set(p1) diff Set(ell);
      if #rem gt 0 then
        print "Remove", Sort(Setseq(rem));
      end if;
      add := Set(ell) diff Set(p1);
      if #add gt 0 then
        print "Add", Sort(Setseq(add));
      end if;
    end if;
  end for;
end for;


for a in [1 .. 10] do
  for b in [1 .. 10] do
    alpha := a/b;
    guess := guess_can_ring_ell(a/b);
    actual := can_ring_1pt(a/b: semigroup := [1]);
    if guess ne actual then
      print "xxxxxxxxxxxxxxxxxxxxxxx";
      print a/b;
      print "Guess:", guess;
      print "Actual:", actual;
    end if;
  end for;
end for;
"Finished"
*/
