-- CA110041.A
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
--      See CA110042.AM
--
-- TEST DESCRIPTION:
--      See CA110042.AM
--
-- TEST FILES:
--      The following files comprise this test:
--
--         CA110040.A
--      => CA110041.A
--         CA110042.AM
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--      26 Apr 96   SAIC    ACVC 2.1: Modified prologue.
--
--!

package Ca110040.Ca110041 is         -- Child Package Computer_System.Manager

   type User_Account is new Account with private;

   procedure Initialize_User_Account (Acct : out User_Account);

private

-- The private portion of this spec demonstrates that components contained in
-- the visible part of the parent are directly visible in the private part of
-- a public child.

   type Account_Access_Type is (None, Guest, User, System);

   type User_Account is new Account with                   -- Parent type.
   record
      Privilege : Account_Access_Type := None;
   end record;

   System_Account : User_Account :=
     (User_Id  => Administrator_Account.User_Id,          -- Parent constant.
     Privilege => System);                                -- User_ID has been
   -- set to 1.
   Auditor_Account : User_Account :=
     (User_Id  => Next_Available_Id,                      -- Parent function.
     Privilege => System);                                -- User_ID has been
   -- set to 2.
   Total_Authorized_Accounts :
     System_Account_Capacity renames
       Total_Accounts;                               -- Parent object.

   Unauthorized_Account : exception renames
     Illegal_Account;                              -- Parent exception

end Ca110040.Ca110041;             -- Child Package Computer_System.Manager
