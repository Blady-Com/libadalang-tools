     --==================================================================--

with Report;
with Impdef;

with F954a00;              -- Printer device abstraction.
use F954a00;
pragma Elaborate (F954a00);

package body C954a01_0 is  -- Printer server abstraction.

   task body Printer_Server is
      Printers_Busy  : Boolean    := True;
      Index          : Printer_Id := 1;
      Print_Accepted : Boolean    := False;
   begin

      loop
         -- Wait for a printer to become available:

         while Printers_Busy loop
            Printers_Busy := False;                        -- Exit loop if
            -- entry accepted.
            select
               Printer (Index).Done_Printing;               -- Accepted immed.
            -- when printer is
            -- available.
            else
               Index := 1 + (Index mod Number_Of_Printers);-- Entry not immed.
               Printers_Busy := True;                      -- accepted; keep
            end select;                                    -- looping.
         end loop;
         -- Value of Index
         -- at loop exit
         -- identifies the
         -- avail. printer.

         -- Wait for a print request or terminate:

         select
            accept Print (File_Name : String) do
               Print_Accepted := True;                     -- Allow
               -- Verify_Results
               -- to be accepted.

               Printer (Index).Start_Printing
                 (File_Name);  -- Begin printing on
               -- the available
               --                        --                -- printer.
               -- Requeue is tested here --
               --                        --
               -- Requeue caller so
               requeue Printer (Index).Done_Printing;       -- server task free
               -- to accept other
            end Print;                                     -- requests.
         or
            --  Guard ensures that Verify_Results cannot be accepted until
            --  after Print has been accepted. This avoids a race condition
            --  in the main program.

 when Print_Accepted =>
            accept Verify_Results;  -- Artifice for
            -- testing purposes.
         or
            terminate;
         end select;

         -- Allow other tasks to get control
         delay Impdef.Minimum_Task_Switch;

      end loop;

   exception
      when others =>
         Report.Failed ("Exception raised in Printer_Server task");
   end Printer_Server;

end C954a01_0;
