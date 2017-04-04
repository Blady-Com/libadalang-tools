-- C3A0001.A
--
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
--
-- OBJECTIVE:
--      Check that access to subprogram type can be used to select and
--      invoke functions with appropriate arguments dynamically.
--
-- TEST DESCRIPTION:
--      Declare an access to function type in a package specification.
--      Declare three different sine functions that can be referred to by
--      the access to function type.
--
--      In the main program, call each function indirectly by dereferencing
--      the access value.
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--
--!

package C3a0001_0 is

   Tc_Call_Tag : Natural := 0;

   -- Type accesses to any sine function
   type Sine_Function_Ptr is access function (Angle : in Float) return Float;

-- Three 'Sine' functions that model an application situation in which one
-- function might be chosen when speed is important, another (using a different
-- algorithm) might be chosen when accuracy is important, and so on.

   function Sine_Calc_Fast (Angle : in Float) return Float;

   function Sine_Calc_Acc (Angle : in Float) return Float;

   function Sine_Calc_Table (Angle : in Float) return Float;

end C3a0001_0;
