-- C64005DB.ADA

--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making
--     this public release, the Government intends to confer upon all
--     recipients unlimited rights  equal to those held by the Government.
--     These rights include rights to use, duplicate, release or disclose the
--     released technical data and computer software in whole or in part, in
--     any manner and for any purpose whatsoever, and to have or permit others
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
-- JRK 7/30/84

separate (C64005d0m.C64005da)

procedure C64005db (L : Level; C : Call; T : in out Trace) is

   V : String (1 .. 2);

   M : constant Natural := Level'Pos (L) - Level'Pos (Level'First) + 1;
   N : constant Natural := 2 * M + 1;

   procedure C64005dc (L : Level; C : Call; T : in out Trace) is separate;

begin

   V (1) := Ident_Char (Ascii.Lc_B);
   V (2) := C;

   -- APPEND ALL V TO T.
   T.S (T.E + 1 .. T.E + N) := C64005d0m.V & C64005da.V & C64005db.V;
   T.E                      := T.E + N;

   case C is

      when '1' =>
         C64005dc (Level'Succ (L), Ident_Char ('1'), T);

      when '2' =>
         C64005db (L, Ident_Char ('3'), T);

      when '3' =>
         C64005dc (Level'Succ (L), Ident_Char ('2'), T);
   end case;

   -- APPEND ALL L AND C TO T IN REVERSE ORDER.
   T.S (T.E + 1 .. T.E + N) :=
     C64005db.L & C64005db.C & C64005da.L & C64005da.C & C64005d0m.L;
   T.E := T.E + N;

end C64005db;
