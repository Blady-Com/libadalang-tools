-- C45347C.ADA

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
-- CHECK THAT CATENATION IS DEFINED FOR PRIVATE TYPES AS COMPONENT TYPES.

-- JWC 11/15/85

with Report; use Report;

procedure C45347c is

begin

   Test
     ("C45347C",
      "CHECK THAT CATENATION IS DEFINED " &
      "FOR PRIVATE TYPES AS COMPONENT TYPES");

   declare

      package Pkg is
         type Priv is private;
         One   : constant Priv;
         Two   : constant Priv;
         Three : constant Priv;
         Four  : constant Priv;
      private
         type Priv is new Integer;
         One   : constant Priv := 1;
         Two   : constant Priv := 2;
         Three : constant Priv := 3;
         Four  : constant Priv := 4;
      end Pkg;

      use Pkg;

      subtype Int is Integer range 1 .. 4;
      type A is array (Int range <>) of Priv;

      P1 : Priv := Four;
      P2 : Priv := One;

      A1 : A (1 .. 2) := (One, Two);
      A2 : A (1 .. 2) := (Three, Four);
      A3 : A (1 .. 4) := (One, Two, Three, Four);
      A4 : A (1 .. 4);
      A5 : A (1 .. 4) := (Four, Three, Two, One);

   begin

      A4 := A1 & A2;

      if A3 /= A4 then
         Failed ("INCORRECT CATENATION FOR TWO ARRAYS OF " & "PRIVATE");
      end if;

      A4 := A5;

      A4 := A1 & A2 (1) & P1;

      if A3 /= A4 then
         Failed
           ("INCORRECT CATENATION FOR ARRAY OF PRIVATE, " & "AND PRIVATE");
      end if;

      A4 := A5;

      A4 := P2 & (A1 (2) & A2);

      if A3 /= A4 then
         Failed
           ("INCORRECT CATENATION FOR PRIVATE, AND ARRAY " & "OF PRIVATE");
      end if;

      A4 := A5;

      A4 := P2 & A1 (2) & (A2 (1) & P1);

      if A3 /= A4 then
         Failed ("INCORRECT CATENATION FOR PRIVATE");
      end if;

   end;

   Result;

end C45347c;
