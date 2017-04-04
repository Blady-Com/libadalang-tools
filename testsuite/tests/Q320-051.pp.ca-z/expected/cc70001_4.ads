-- No body for CC70001_3;

     --==================================================================--

-- Declare instances of the generic list packages for the discrete type. In
-- order to establish that the type passed as an actual to the parent generic
-- (CC70001_0) is the one utilized by the child generic (CC70001_1), the
-- instance of the child must itself be declared as a child of the instance of
-- the parent. Since only library units may have or be children, both instances
-- must be library units.

with Cc70001_0;            -- Generic list abstraction.
with Cc70001_3;            -- Package containing discrete type declaration.
pragma Elaborate (Cc70001_0);
package Cc70001_4 is new Cc70001_0 (Cc70001_3.Points);