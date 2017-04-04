-- C87B16A.ADA

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
-- CHECK THAT OVERLOADING RESOLUTION USES THE RULE THAT:
--
-- FOR A DEFAULT RECORD COMPONENT, THE TYPE OF THE INITIALIZATION EXPRESSION
-- MUST MATCH THE COMPONENTS'S EXPLICIT TYPEMARK.
--
-- THE FOUR KINDS OF EXPRESSIONS TESTED HERE ARE:
--
--    (A): A CALL TO AN OVERLOADED FUNCTION.
--    (B): AN OVERLOADED OPERATOR SYMBOL.
--    (C): AN OVERLOADED (INFIX) OPERATOR.
--    (D): AN OVERLOADED ENUMERATION LITERAL.

-- TRH  23 JUNE 82

with Report; use Report;

procedure C87b16a is

   type Whole is new Integer range 0 .. Integer'Last;
   type Citrus is (Lemon, Lime, Orange);
   type Hue is (Red, Orange, Yellow);

   function F1 (X, Y : Integer) return Integer is
   begin
      return -1;
   end F1;

   function F1 (X, Y : Whole) return Whole is
   begin
      return 0;
   end F1;

   function F1 (X, Y : Integer) return Hue is
   begin
      return Orange;
   end F1;

   function F1 (X, Y : Integer) return Citrus is
   begin
      return Orange;
   end F1;

begin
   Test
     ("C87B16A",
      "OVERLOADED INITIALIZATION EXPRESSIONS" &
      " IN DEFAULT RECORD COMPONENTS");
   declare

      function "-" (X, Y : Integer) return Integer renames F1;

      function "-" (X, Y : Whole) return Whole renames F1;

      function "-" (X, Y : Integer) return Hue renames F1;

      function "-" (X, Y : Integer) return Citrus renames F1;

      type Rec is record
         I1 : Integer := F1 (0, 0);
         W1 : Whole   := F1 (0, 0);
         C1 : Citrus  := F1 (0, 0);
         H1 : Hue     := F1 (0, 0);

         I2 : Integer := "-" (0, 0);
         W2 : Whole   := "-" (0, 0);
         C2 : Citrus  := "-" (0, 0);
         H2 : Hue     := "-" (0, 0);

         I3 : Integer := (0 - 0);
         W3 : Whole   := (0 - 0);
         C3 : Citrus  := (0 - 0);
         H3 : Hue     := (0 - 0);

         C4 : Citrus := Orange;
         H4 : Hue    := Orange;
      end record;

      R1 : Rec;

   begin
      if R1.I1 /= -1 or
        R1.W1 /= 0 or
        Citrus'Pos (R1.C1) /= 2 or
        Hue'Pos (R1.H1) /= 1
      then
         Failed ("(A): RESOLUTION INCORRECT - FUNCTION CALL");
      end if;

      if R1.I2 /= -1 or
        R1.W2 /= 0 or
        Citrus'Pos (R1.C2) /= 2 or
        Hue'Pos (R1.H2) /= 1
      then
         Failed ("(B): RESOLUTION INCORRECT - OPERATOR SYMBOL");
      end if;

      if R1.I3 /= -1 or
        R1.W3 /= 0 or
        Citrus'Pos (R1.C3) /= 2 or
        Hue'Pos (R1.H3) /= 1
      then
         Failed ("(C): RESOLUTION INCORRECT - INFIX OPERATOR");
      end if;

      if Citrus'Pos (R1.C4) /= 2 or Hue'Pos (R1.H4) /= 1 then
         Failed ("(D): RESOLUTION INCORRECT - ENUMERATION LITERAL");
      end if;
   end;

   Result;
end C87b16a;
