with System; use System;
with Report; use Report;
with C94004c_Task;
procedure C94004c is

begin
   Test
     ("C94004C",
      "CHECK THAT A MAIN PROGRAM TERMINATES " &
      "WITHOUT WAITING FOR TASKS THAT DEPEND " &
      "ON A LIBRARY PACKAGE AND THAT SUCH TASKS " &
      "CONTINUE TO EXECUTE");

   Comment
     ("THE INVOKING SYSTEM'S JOB CONTROL LOG MUST BE " &
      "EXAMINED TO SEE IF THIS TEST REALLY TERMINATES");

   C94004c_Task.T.E;      -- ALLOW TASK TO PROCEED.
   if C94004c_Task.T'Terminated then
      Failed ("LIBRARY DECLARED TASK PREMATURELY TERMINATED");
   end if;

   -- RESULT PROCEDURE IS CALLED BY LIBRARY TASK.

end C94004c;
