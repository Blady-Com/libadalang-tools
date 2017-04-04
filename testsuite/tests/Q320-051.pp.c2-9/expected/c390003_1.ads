-- C390003.A
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
--     Check that for a subtype S of a tagged type T, S'Class denotes a
--     class-wide subtype.  Check that T'Tag denotes the tag of the type T,
--     and that, for a class-wide tagged type X, X'Tag denotes the tag of X.
--     Check that the tags of stand alone objects, record and array
--     components, aggregates, and formal parameters identify their type.
--     Check that the tag of a value of a formal parameter is that of the
--     actual parameter, even if the actual is passed by a view conversion.
--
-- TEST DESCRIPTION:
--     This test defines a class hierarchy (based on C390002) and
--     uses it to determine the correctness of the resulting tag
--     information generated by the compiler.  A type is defined in the
--     class which contains components of the class as part of its
--     definition.  This is to reduce the overall number of types
--     required, and to achieve the required nesting to accomplish
--     this test.  The model is that of a car carrier truck; both car
--     and truck being in the class of Vehicle.
--
--      Class Hierarchy:
--                         Vehicle - - - - - - - (Bicycle)
--                        /   |   \               /      \
--                   Truck   Car   Q_Machine   Tandem  Motorcycle
--                     |
--                Auto_Carrier
--      Contains:
--                Auto_Carrier( Car )
--                Q_Machine( Car, Motorcycle )
--
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--      19 Dec 94   SAIC    Removed ARM references from objective text.
--      20 Dec 94   SAIC    Replaced three unnecessary extension
--                          aggregates with simple aggregates.
--      16 Oct 95   SAIC    Fixed bugs for ACVC 2.0.1
--
--!

----------------------------------------------------------------- C390003_1

with Ada.Tags;
package C390003_1 is -- Vehicle

   type Tc_Keys is (Veh, Mc, Tand, Car, Q, Truk, Heavy);
   type States is (Good, Flat, Worn);

   type Wheel_List is array (Positive range <>) of States;

   type Object (Wheels : Positive) is tagged record
      Wheel_State : Wheel_List (1 .. Wheels);
   end record;

   procedure Tc_Validate (It : Object; Key : Tc_Keys);
   procedure Tc_Validate (It : Object'Class; The_Tag : Ada.Tags.Tag);

   procedure Create (The_Vehicle : in out Object; Tyres : in States);
   procedure Rotate (The_Vehicle : in out Object);
   function Wheels (The_Vehicle : Object) return Positive;

end C390003_1; -- Vehicle;
