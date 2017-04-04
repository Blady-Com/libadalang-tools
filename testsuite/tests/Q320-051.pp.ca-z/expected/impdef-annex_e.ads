-- IMPDEFE.A
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
-- DESCRIPTION:
--     This package provides tailorable entities for a particular
--     implementation.  Each entity may be modified to suit the needs
--     of the implementation.  Default values are provided to act as
--     a guide.
--
--     The entities in this package are those which are used exclusively
--     in tests for Annex E (Distributed Systems).
--
-- APPLICABILITY CRITERIA:
--     This package is only required for implementations validating the
--     Distributed Systems Annex.
--
-- CHANGE HISTORY:
--     29 Jan 96   SAIC    Initial version for ACVC 2.1.
--
--!

package Impdef.Annex_E is

--=====-=====-=====-=====-=====-=====-=====-=====-=====-=====-=====-=====--

   -- The Max_RPC_Call_Time value is the longest time a test needs to wait
   -- for an RPC to complete. Included in this time is the time for the called
   -- procedure to make a task entry call where the task is ready to accept the
   -- call.

   Max_Rpc_Call_Time : constant Duration := 2.0;
   --                                       ^^^  --- MODIFY HERE AS NEEDED

--=====-=====-=====-=====-=====-=====-=====-=====-=====-=====-=====-=====--

end Impdef.Annex_E;